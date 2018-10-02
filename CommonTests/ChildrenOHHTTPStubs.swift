//
//  ChildrenOHHTTPStubs.swift
//  UNITests
//
//  Created by Jason Prasad on 10/2/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import OHHTTPStubs

func stubChildrenResponse(fixture named: String? = "Reddit.json", status: Int32 = 200) {
    stub(condition: isHost("reddit.com") && isPath("/.json")) { _ in
        if let named = named {
            let stubPath = OHPathForFile(named, type(of: BundleForClass()))
            return fixture(filePath: stubPath!,
                           status: status,
                           headers: ["Content-Type":"application/json"])
        } else {
            return OHHTTPStubsResponse(data: Data(), statusCode: status, headers: nil)
        }
        
    }
}
