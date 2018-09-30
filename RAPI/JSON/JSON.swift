//
//  Model.swift
//  ReddiX
//
//  Created by Jason Prasad on 9/29/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import Foundation

enum JSONError: Error {
    
    case map(reason: Error)
    
}

public protocol JSON: Decodable {
    
    static func map(data: Data) throws -> Self
    
}

extension JSON {
    
    public static func map(data: Data) throws -> Self {
        do {
            return try JSONDecoder().decode(self, from: data)
        } catch {
            throw JSONError.map(reason: error)
        }
    }
    
}
