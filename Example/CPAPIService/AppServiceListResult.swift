//
//  AppServiceListResult.swift
//  CPAPIService_Example
//
//  Created by Nguyen Quoc Vuong on 2/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CPAPIService
struct AppServiceListResult<T: BaseModel>: ServiceListResultBase {
    var meta: Paging
    var items: [T]
    
    enum CodingKeys: String, CodingKey {
        case meta = "paging"
        case items = "data"
    }
}
