//
//  ExpectAsyncAction.swift
//  UNITests
//
//  Created by Jason Prasad on 10/2/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift
import XCTest
@testable import UNI

class ExpectAsyncAction<State: StateType>: XCTestExpectation {
    
    let action: AsyncAction
    private var dispatch: DispatchFunction {
        return { action in
            let matcher = self.expectedDispatches.remove(at: 0)
            matcher(action)
            if self.expectedDispatches.count == 0 {
                self.fulfill()
            }
        }
    }
    private typealias DispatchMatcher = (Action) -> Void
    private var expectedDispatches = [DispatchMatcher]()
    private var expectedStates = [State]()
    private var getState: () -> State? {
        return {
            return self.expectedStates.remove(at: 0)
        }
    }
    
    init(_ action: AsyncAction, description: String? = nil) {
        self.action = action
        super.init(description: description ?? "ExpectAsyncAction: \(action)")
    }
    
    func dispatches<A: Action & Equatable>(_ expected: A, file: StaticString = #file, line: UInt = #line) -> Self {
        func matcher(dispatched: Action) {
            guard let dispatched = dispatched as? A else {
                XCTFail("dispatch fails protocol assertion: \(dispatch)", file: file, line: line)
                return
            }
            XCTAssert(dispatched == expected, "dispatched does not equal expected: \(dispatch) \(expected)", file: file, line: line)
        }
        expectedDispatches.append(matcher)
        return self
    }
    
    func getsState(_ state: State) -> Self {
        expectedStates.append(state)
        return self
    }
    
    func run() -> Self {
        action.run(dispatch: dispatch, getState: getState as! () -> AppState?)
        return self
    }
    
}
