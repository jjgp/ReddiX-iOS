//
//  ExpectActionCreator.swift
//  UNITests
//
//  Created by Jason Prasad on 10/2/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift
import XCTest
@testable import UNI

class ExpectActionCreator<State: StateType>: XCTestExpectation {
    
    typealias ActionCreator = Store<State>.ActionCreator
    private typealias ActionMatcher = (Action) -> Void
    
    let creator: ActionCreator
    private var dispatch: DispatchFunction {
        return { action in
            let matcher = self.expectedActions.remove(at: 0)
            matcher(action)
            if self.expectedActions.count == 0 {
                self.fulfill()
            }
        }
    }
    private var expectedActions = [ActionMatcher]()
    private var expectedReturn: ActionMatcher?
    private var expectsReturnNil: ((Any?) -> Void)?
    
    init(_ creator: @escaping ActionCreator, description: String? = nil) {
        self.creator = creator
        
        super.init(description: description ?? "\(ExpectActionCreator.self)")
    }
    
    func dispatches<A: Action & Equatable>(_ expected: A, file: StaticString = #file, line: UInt = #line) -> Self {
        func matcher(received: Action) {
            guard let received = received as? A else {
                return
            }
            
            XCTAssert(received == expected, "received action does not equal expected: \(received) \(expected)", file: file, line: line)
        }
        
        expectedActions.append(matcher)
        
        return self
    }
    
    func returns<A: Action & Equatable>(_ expected: A, file: StaticString = #file, line: UInt = #line) -> Self {
        guard expectsReturnNil == nil else {
            fatalError("returns() and returnsNil() should be used exclusively")
        }
        
        expectedReturn = { received in
            guard let received = received as? A else {
                return
            }
            
            XCTAssert(received == expected, "received action does not equal expected: \(String(describing: received)) \(String(describing: expected))", file: file, line: line)
        }
        
        return self
    }
    
    func returnsNil(file: StaticString = #file, line: UInt = #line) -> Self {
        guard expectedReturn == nil else {
            fatalError("returns() and returnsNil() should be used exclusively")
        }
        
        expectsReturnNil = { received in
            XCTAssertNil(received, "received is not nil: \(String(describing: received))", file: file, line: line)
        }
        
        return self
    }
    
    func run(with initial: State) -> Self {
        let mockStore = MockStore(state: initial) { [weak self] (action) in
            self?.dispatch(action)
        }
        
        let returned = creator(initial, mockStore)
        if let expectsReturnNil = expectsReturnNil {
            expectsReturnNil(returned)
        } else if let expectedReturn = expectedReturn {
            expectedReturn(returned!)
        }
        
        return self
    }
    
}
