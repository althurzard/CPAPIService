//
//  Result.swift
//  Lixi
//
//  Created by Nguyen Quoc Vuong on 9/26/18.
//  Copyright © 2018 King Nguyen. All rights reserved.
//

import Foundation

public enum FetchedResult<T, E> {
    case success(T)
    case failure(E)
}

public enum ProgressResult<T, E, P> {
    case success(T)
    case progress(P)
    case failure(E)
}

public enum ServiceError : Error {
    case network(String)
    case parser
    case message(String)
    case other(Any)
    case `default`
    public var description : String {
        switch self {
        case .network(let message):
            return message
        case .message(let message):
            return message
        default:
            return "Có lỗi xảy ra!"
        }
    }
    public var localizedDescription: String {
        return description
    }
    
    public var errorData: Any? {
        switch self {
        case .other(let data):
            return data
        default:
            return nil
        }
    }
}

public protocol MetaBase: BaseModel {}

public protocol ServiceResultBase: BaseModel {
    associatedtype T: BaseModel
    associatedtype E: MetaBase
    var meta: E { get }
    var item: T { get }
}

public protocol ServiceListResultBase: BaseModel {
    associatedtype T: BaseModel
    associatedtype E: MetaBase
    var meta: E { get }
    var items: [T] { get }
}
