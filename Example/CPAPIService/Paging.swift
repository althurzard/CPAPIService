//
//  Paging.swift
//  CPAPIService_Example
//
//  Created by Nguyen Quoc Vuong on 2/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CPAPIService

struct Paging: MetaBase { 
    var hasMore: Bool
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
    }
}
