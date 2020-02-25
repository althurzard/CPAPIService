//
//  Job.swift
//  CPAPIService_Example
//
//  Created by Nguyen Quoc Vuong on 2/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CPAPIService

struct Job: BaseModel {
    var title: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case address
    }
    
}
