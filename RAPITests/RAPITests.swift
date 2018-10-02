//
//  RAPITests.swift
//  RAPITests
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import OHHTTPStubs
import XCTest
@testable import RAPI

class RAPITests: XCTestCase {
    
    let rapi = RAPI()
    let request = Request<Children>(parameters: ["count": "25"],
                                    URLPath: "/.json")
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func testProcessChildren() {
        stubChildrenResponse()

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
        stubChildrenResponse(status: 500)
        
        let expect = expectation(description: "process fulfills")
        rapi.process(request) { children, response, error in
            XCTAssertNil(children)
            XCTAssert(response?.statusCode == 500)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testProcessMapFailure() {
        stubChildrenResponse(fixture: nil)
        
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
    
}
