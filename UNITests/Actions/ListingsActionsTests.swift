//
//  ListingsActionsTests.swift
//  UNITests
//
//  Created by Jason Prasad on 10/2/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import OHHTTPStubs
import RAPI
import ReSwift
import ReSwiftRouter
import XCTest
@testable import UNI

class ListingsActionsTests: XCTestCase {
    
    let appState = AppState(listings: [ListingsState()], navigation: NavigationState())
    
    override func tearDown() {
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    func testFetchChildren() {
        stubChildrenResponse()
        
        let expectedChildren = try! Children.map(forResource: "Reddit", ofType: "json")!
        
        let expect = ExpectActionCreator<AppState>(ListingsActions.fetchChildren())
            .returnsNil()
            .dispatches(ListingsActions.isFetching(true, 0))
            .dispatches(ListingsActions.appendChildren(expectedChildren, 0))
            .dispatches(ListingsActions.isFetching(false, 0))
            .run(with: appState)
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFetchChildrenWithReplacement() {
        stubChildrenResponse()
        
        let expectedChildren = try! Children.map(forResource: "Reddit", ofType: "json")!
        
        let expect = ExpectActionCreator<AppState>(ListingsActions.fetchChildren(replacement: true))
            .returnsNil()
            .dispatches(ListingsActions.isFetching(true, 0))
            .dispatches(ListingsActions.replaceChildren(expectedChildren, 0))
            .dispatches(ListingsActions.isFetching(false, 0))
            .run(with: appState)
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFetchChildrenErrors() {
        stubChildrenResponse(status: 500)
        
        let expect = ExpectActionCreator<AppState>(ListingsActions.fetchChildren())
            .returnsNil()
            .dispatches(ListingsActions.isFetching(true, 0))
            .dispatches(ListingsActions.isErrored(true, 0))
            .dispatches(ListingsActions.isFetching(false, 0))
            .run(with: appState)
        
        wait(for: [expect], timeout: 1.0)
    }
    
}
