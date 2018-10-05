//
//  ChildrenActionsTests.swift
//  UNITests
//
//  Created by Jason Prasad on 10/2/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import OHHTTPStubs
import RAPI
import ReSwift
import XCTest
@testable import UNI

class ChildrenActionsTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    func testFetchChildren() {
        stubChildrenResponse()
        
        let expectedChildren = try! Children.map(forResource: "Reddit", ofType: "json")!
        
        let expect = ExpectActionCreator<AppState>(fetchChildren())
            .returnsNil()
            .dispatches(ChildrenActions.isFetching(true))
            .dispatches(ChildrenActions.appendChildren(expectedChildren))
            .dispatches(ChildrenActions.isFetching(false))
            .run(with: AppState())
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFetchChildrenWithReplacement() {
        stubChildrenResponse()

        let expectedChildren = try! Children.map(forResource: "Reddit", ofType: "json")!

        let expect = ExpectActionCreator<AppState>(fetchChildren(replacement: true))
            .returnsNil()
            .dispatches(ChildrenActions.isFetching(true))
            .dispatches(ChildrenActions.replaceChildren(expectedChildren))
            .dispatches(ChildrenActions.isFetching(false))
            .run(with: AppState())

        wait(for: [expect], timeout: 1.0)
    }

    func testFetchChildrenErrors() {
        stubChildrenResponse(status: 500)

        let expect = ExpectActionCreator<AppState>(fetchChildren())
            .returnsNil()
            .dispatches(ChildrenActions.isFetching(true))
            .dispatches(ChildrenActions.isErrored(true))
            .dispatches(ChildrenActions.isFetching(false))
            .run(with: AppState())

        wait(for: [expect], timeout: 1.0)
    }

}
