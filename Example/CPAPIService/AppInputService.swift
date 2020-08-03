//
//  AppInputService.swift
//  CPAPIService_Example
//
//  Created by Nguyen Quoc Vuong on 2/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CPAPIService
import Alamofire

class AppInputService: APIInputBase {
    var headers: HTTPHeaders = [
        "Content-Type" : "application/json",
        "Authorization" : "Unig eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI2NzU2NDcxNDAsImlkIjo1LCJvcmlnX2lhdCI6MTU5NTY0NzE0MH0.mQvbuA1NkYYkRVEbtx944puOSTCkYsGax-rGUd5pLwI"
    ]
    var baseURL: String = ""
    var name: String = ""
    var params: Parameters = [:]
    var requestType: HTTPMethod = .get {
        didSet {
            encoding = (requestType == .get || requestType == .delete) ? URLEncoding.default : JSONEncoding.default
        }
    }
    var encoding: ParameterEncoding = URLEncoding.default
    var data: Data?
    var returnErrorData: Bool = false
    
    init(name: String = "", params: Parameters = [:], requestType: HTTPMethod = .get) {
        self.name = name
        self.params = params
        self.requestType = requestType
    }
    
}
