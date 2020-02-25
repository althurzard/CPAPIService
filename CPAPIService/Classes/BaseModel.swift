//
//  BaseModel.swift
//  DMCL
//
//  Created by Nguyen Quoc Vuong on 2/20/20.
//  Copyright © 2020 CP Tech. All rights reserved.
//

import Foundation


public protocol BaseModel: Codable {

}

public protocol EquatableObject: Hashable, BaseModel {
    
}

extension BaseModel where Self: EquatableObject {
    static func ==(lhs: Self , rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
