//
//  Decoable+Extension.swift
//  DMCL
//
//  Created by Nguyen Quoc Vuong on 2/20/20.
//  Copyright © 2020 CP Tech. All rights reserved.
//

import Foundation

public extension Decodable {
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
    
    func decodeUnknownKeys(from decoder: Decoder, with knownKeys: Set<String>) throws -> [String: Any] {
        let container = try decoder.container(keyedBy: UnknownCodingKey.self)
        var unknownKeyValues = [String: Any]()
        
        for key in container.allKeys {
            guard !knownKeys.contains(key.stringValue) else { continue }
            if let codingKey = MyCodingKey(stringValue: key.stringValue) {
                var container = try decoder.container(keyedBy: MyCodingKey.self)
                 unknownKeyValues[key.stringValue] = try JSONAny.decode(from: &container, forKey: codingKey)
            }
        }
        return unknownKeyValues
    }
}
