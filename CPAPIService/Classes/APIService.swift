//
//  APIService.swift
//  Lixi
//
//  Created by Nguyen Quoc Vuong on 9/26/18.
//  Copyright © 2018 King Nguyen. All rights reserved.
//
/*
 Static class trung gian giữa alamofire và service classes, giúp xử lý, parse data từ json sang swift object bằng Codable Protocol.
*/

import Alamofire

fileprivate var manager: SessionManager = {
    let requestTimeout: TimeInterval = 15
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = requestTimeout
    let _manager = SessionManager(configuration: configuration)
    _manager.delegate.sessionDidReceiveChallenge = { session, challenge in
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            disposition = .useCredential
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        } else {
            if challenge.previousFailureCount > 0 {
                disposition = .cancelAuthenticationChallenge
            } else {
                credential = _manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                
                if credential != nil {
                    disposition = .useCredential
                }
            }
        }
        return (disposition, credential)
    }
    return _manager
}()

fileprivate var bgAlamofire: SessionManager = {
    return Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.app.backgroundtransfer"))
}()

final public class APIService {
    
    static private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    public class func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }

    public class func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }

    fileprivate class func _request<T: APIOutputBase>(input: APIInputBase,output: T.Type,completion: @escaping (T)-> Void) {
        manager.request(input).debugLog().responseJSON { completion(T(response: $0)) }
    }
    
    fileprivate class func _upload(input: APIInputBase, completion: @escaping (FetchedResult<Data,ServiceError>)->Void) {
        manager.upload(multipartFormData: { (formData) in
            formData.append(input.data!, withName: "file", fileName: "hahah.png", mimeType: "image/png")
        }, to: input.path, method: input.requestType , headers: input.headers) { (result) in
            switch result {
                case .success( let data, _, _):
                    data.responseJSON { response in
                        if let data = response.data {
                            completion(.success(data))
                        } else {
                            completion(.failure(.message("Error")))
                        }
                    }
                case .failure(let error):
                    completion(.failure(.message(error.localizedDescription)))
                    debug(error.localizedDescription)
            }
        }
    }
    
    fileprivate class func _uploadWithProgress<T: APIOutputBase>(input: APIInputBase, output: T.Type, completion: @escaping (ProgressResult<T,ServiceError,Double>)->Void) {
        bgAlamofire.upload(multipartFormData: { (formData) in
            input.params.forEach {
                let key = $0.key
                if let urls = $0.value as? [URL] {
                    urls.forEach {
                        formData.append($0, withName: key)
                    }
                } else if let url = $0.value as? URL {
                    formData.append(url, withName: key)
                }
            }
        }, to: input.path, method: input.requestType , headers: input.headers) { (result) in
            switch result {
            case .success( let data, _, _):
                data.responseJSON { response in
                    completion(.success(T(response: response)))
                }
                data.uploadProgress { progress in
                    completion(.progress(progress.fractionCompleted))
                }
            case .failure(let error):
                completion(.failure(.message(error.localizedDescription)))
                debug(error.localizedDescription)
            }
        }
    }
    
    fileprivate class func getDecodeError(_ error: Error, _ input: APIInputBase) -> String {
        return String(describing: error) + " when request \(input.path) API"
    }
    
    fileprivate class func getErrorDescription(_ error: ServiceError, _ input: APIInputBase) -> String {
        return error.description + " when request \(input.path) API"
    }
    
    fileprivate class func debug(_ content: String) {
        print("APIDebug: \(content)")
    }
    
    /// Upload data thông qua alamofire cùng tham số đầu vào là interface APIInputBase với URL path, headers, encodingType, method. Trả về một object nếu request thành công.
    /// - parameter input: Tham số request
    /// - parameter completion: Gói dữ liệu sau khi decode từ json
    public class func upload<T:ServiceResultBase>(input: APIInputBase, completion: @escaping ((FetchedResult<T,ServiceError>)->()) ) {
        APIService._upload(input: input) { (result) in
            switch result {
            case .success(let data):
                do {
                    let result = try T.decode(data: data)
                    completion(.success(result))
                } catch let error {
                    completion(.failure(.message(getDecodeError(error,input))))
                    debug(getDecodeError(error, input))
                }
            case .failure(let error):
                completion(.failure(.message(error.description)))
                debug(getErrorDescription(error, input))
            }
        }
    }
    
    /// Upload data thông qua alamofire cùng tham số đầu vào là interface APIInputBase với URL path, headers, encodingType, method. Trả về một object nếu request thành công.
    /// - parameter input: Tham số request
    /// - parameter completion: Gói dữ liệu sau khi decode từ json
    public class func upload<T:ServiceResultBase, R: APIOutputBase>(input: APIInputBase, output: R.Type, completion: @escaping ((ProgressResult<T,ServiceError,Double>)->()) ) {
        APIService._uploadWithProgress(input: input, output: output) { (result) in
            switch result {
            case .success(let data):
                let output = data.output
                switch output {
                case .success(let result):
                    do {
                        let result = try T.decode(data: result)
                        completion(.success(result))
                    } catch let error {
                        completion(.failure(.message(getDecodeError(error,input))))
                        debug(getDecodeError(error, input))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    debug(getErrorDescription(error, input))
                }
                
            case .progress(let progress):
                completion(.progress(progress))
            case .failure(let error):
                endBackgroundTask()
                completion(.failure(.message(error.description)))
                debug(getErrorDescription(error, input))
            }
            
        }
    }
    
    /// Upload data thông qua alamofire cùng tham số đầu vào là interface APIInputBase với URL path, headers, encodingType, method. Trả về một object nếu request thành công.
    /// - parameter input: Tham số request
    /// - parameter completion: Gói dữ liệu sau khi decode từ json
    public class func upload<T:ServiceListResultBase, R: APIOutputBase>(input: APIInputBase, output: R.Type, completion: @escaping ((ProgressResult<T,ServiceError,Double>)->()) ) {
        APIService._uploadWithProgress(input: input, output: output) { (result) in
            switch result {
            case .success(let data):
                let output = data.output
                switch output {
                case .success(let result):
                    do {
                        let result = try T.decode(data: result)
                        completion(.success(result))
                    } catch let error {
                        completion(.failure(.message(getDecodeError(error,input))))
                        debug(getDecodeError(error, input))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    debug(getErrorDescription(error, input))
                }
                
            case .progress(let progress):
                completion(.progress(progress))
            case .failure(let error):
                endBackgroundTask()
                completion(.failure(.message(error.description)))
                debug(getErrorDescription(error, input))
            }
            
        }
    }
    
    /// Request API thông qua alamofire cùng tham số đầu vào là interface APIInputBase với URL path, headers, encodingType, method. Trả về một object nếu request thành công.
    /// - parameter input: Tham số request
    /// - parameter output: Kiểu output xử lý gói dữ liệu trả về
    /// - parameter completion: Gói dữ liệu sau khi decode từ json
    public class func request<T:ServiceResultBase, R: APIOutputBase>(input: APIInputBase, output: R.Type, completion: ((FetchedResult<T,ServiceError>)->())? = nil) {
        APIService._request(input: input, output: output) {
            let output = $0.output
            switch output {
            case .success(let data):
                do {
                    let result = try T.decode(data: data)
                    completion?(.success(result))
                } catch let error {
                    completion?(.failure(.message(getDecodeError(error,input))))
                    debug(getDecodeError(error, input))
                }
            case .failure(let error):
                if input.returnErrorData, let data = $0.errorData {
                    completion?(.failure(.other(data)))
                } else {
                    completion?(.failure(error))
                }
                debug(getErrorDescription(error, input))
            }
        }
    }
    
    /// Request API thông qua alamofire cùng tham số đầu vào là interface APIInputBase với URL path, headers, encodingType, method. Trả về danh sách object nếu request thành công.
    /// - parameter input: Tham số request
    /// - parameter output: Kiểu output xử lý gói dữ liệu trả về
    /// - parameter completion: Gói dữ liệu sau khi decode từ json
    public class func request<T:ServiceListResultBase, R: APIOutputBase>(input: APIInputBase, output: R.Type, completion: ((FetchedResult<T,ServiceError>)->())? = nil) {
        APIService._request(input: input, output: output) {
            let output = $0.output
            switch output {
            case .success(let data):
                do {
                    let result = try T.decode(data: data)
                    completion?(.success(result))
                } catch let error {
                    completion?(.failure(.message(getDecodeError(error,input))))
                    debug(getDecodeError(error, input))
                }
            case .failure(let error):
                if input.returnErrorData, let data = $0.errorData {
                    completion?(.failure(.other(data)))
                } else {
                    completion?(.failure(error))
                }
                debug(getErrorDescription(error, input))
            }
        }
    }
    
    /// Request API thông qua alamofire cùng tham số đầu vào là interface APIInputBase với URL path, headers, encodingType, method. Trả về danh sách object nếu request thành công.
    /// - parameter input: Tham số request
    /// - parameter output: Kiểu output xử lý gói dữ liệu trả về
    /// - parameter completion: Gói dữ liệu sau khi decode từ json
    public class func request<T:BaseModel, R: APIOutputBase>(input: APIInputBase, output: R.Type, completion: ((FetchedResult<T,ServiceError>)->())? = nil) {
        APIService._request(input: input, output: output) {
            let output = $0.output
            switch output {
            case .success(let data):
                do {
                    let result = try T.decode(data: data)
                    completion?(.success(result))
                } catch let error {
                    completion?(.failure(.message(getDecodeError(error,input))))
                    debug(getDecodeError(error, input))
                }
            case .failure(let error):
                if input.returnErrorData, let data = $0.errorData {
                    completion?(.failure(.other(data)))
                } else {
                    completion?(.failure(error))
                }
                debug(getErrorDescription(error, input))
            }
        }
    }
}


public extension Request {
    func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}
