//
//  RAPITests.swift
//  RAPITests
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import RAPI

class RAPITests: XCTestCase {

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func testProcessChildren() {
        stubRedditResponse()
        
        let rapi = RAPI()
        let request = Request<Children>()
        
        let expect = expectation(description: "process fulfills")
        rapi.process(request) { children, response, error in
            XCTAssert(children?.after == "t3_9k656x")
            XCTAssert(children?.before == "t3_9k654x")
            XCTAssert(children?.children.count == 27)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testProcessHTTPFailure() {
        stubRedditResponse(status: 500)
        
        let rapi = RAPI()
        let request = Request<Children>()
        
        let expect = expectation(description: "process fulfills")
        rapi.process(request) { children, response, error in
            XCTAssertNil(children)
            XCTAssert(response?.statusCode == 500)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testProcessMapFailure() {
        stubRedditResponse(fixture: nil)
        
        let rapi = RAPI()
        let request = Request<Children>()
        
        let expect = expectation(description: "process fulfills")
        rapi.process(request) { children, response, error in
            if case let JSONError.map(reason) = error as! JSONError,
                case let DecodingError.dataCorrupted(context) = reason {
                XCTAssertNotNil(context)
            } else {
                XCTFail()
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func stubRedditResponse(fixture named: String? = "Reddit.json", status: Int32 = 200) {
        stub(condition: isHost("reddit.com") && isPath("/.json")) { _ in
            if let named = named {
                let stubPath = OHPathForFile(named, type(of: self))
                return fixture(filePath: stubPath!,
                               status: status,
                               headers: ["Content-Type":"application/json"])
            } else {
                return OHHTTPStubsResponse(data: Data(), statusCode: status, headers: nil)
            }
            
        }
    }

}
