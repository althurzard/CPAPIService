//
//  APIOutputBase.swift
//  Lixi
//
//  Created by Nguyen Quoc Vuong on 11/28/18.
//  Copyright © 2018 King Nguyen. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIOutputBase: class {
    init(response: DataResponse<Any>)
    var output: FetchedResult<Data,ServiceError> { get }
    var errorData: Any? { get }
}
