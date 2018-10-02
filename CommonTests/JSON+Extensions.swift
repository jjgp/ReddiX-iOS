//
//  JSON+Extensions.swift
//  UNITests
//
//  Created by Jason Prasad on 10/2/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

@testable import RAPI

extension JSON {
    
    public static func map(forResource: String, ofType: String) throws -> Self? {
        return try Bundle(for: type(of: BundleForClass()))
            .path(forResource: forResource, ofType: ofType)
            .flatMap({ URL(fileURLWithPath: $0) })
            .flatMap({ try Data(contentsOf: $0)} )
            .flatMap({ try self.map(data: $0) })
    }
    
}
