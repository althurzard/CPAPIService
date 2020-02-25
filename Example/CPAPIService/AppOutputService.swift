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
        if let dict = result.value as? [String: Any] {
            return dict
        }
        return nil
    }()
    
    var output: FetchedResult<Data,ServiceError> {
        let result = response.result
        if result.isSuccess {
            if let records = response.data {
                return .success(records)
            } else {
                return .failure(.parser)
            }
        } else {
            if let errorDescription = result.error?.localizedDescription {
                return .failure(.network(errorDescription))
            } else {
                return .failure(.network("Network Error"))
            }
        }
    }
    
    required init(response: DataResponse<Any>) {
        self.response = response
    }
    
    
}
