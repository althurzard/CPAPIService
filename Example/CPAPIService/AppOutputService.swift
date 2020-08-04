//
//  AppOutputService.swift
//  CPAPIService_Example
//
//  Created by Nguyen Quoc Vuong on 2/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CPAPIService
import Alamofire

class AppOutputService: APIOutputBase {
    var response: DataResponse<Any>!
    lazy var errorData: Any? = {
        let result = response.result
        if let dict = try? result.value as? [String: Any] {
            return dict
        }
        return nil
    }()
    
    var output: FetchedResult<Data,ServiceError> {
        if let error = response?.error {
            return .failure(.message(error.localizedDescription))
        } else if let data = response?.data {
            return .success(data)
        } else {
            return .failure(.message("Error"))
        }
    }
    
    required init(response: DataResponse<Any>) {
        self.response = response
    }
    
    
}
