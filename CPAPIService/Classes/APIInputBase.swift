//
//  Result.swift
//  Lixi
//
//  Created by Nguyen Quoc Vuong on 9/25/18.
//  Copyright © 2018 King Nguyen. All rights reserved.
//

import Foundation
import Alamofire


public protocol URLContructable {
    var baseURL: String { get }
    var path: String { get }
}

public extension URLContructable where Self: APIInputBase {
    var path: String {
        return baseURL + "\(name)"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        
        // setting path
        var urlRequest: URLRequest = URLRequest(url: url)
        
        // setting method
        urlRequest.httpMethod = requestType.rawValue
    
        // setting header
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest = try encoding.encode(urlRequest, with: params)
        
        return urlRequest
    }
}

public protocol APIInputBase: URLContructable, URLRequestConvertible {
    var headers: HTTPHeaders { get }
    var name: String { get }
    var params: Parameters { get }
    var requestType: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var data: Data? { get }
    var returnErrorData: Bool { get }
}
