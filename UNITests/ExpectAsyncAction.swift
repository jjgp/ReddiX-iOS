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
            assert(matcher(action))
            if self.expectedDispatches.count == 0 {
                self.fulfill()
            }
        }
    }
    private typealias DispatchMatcher = (Action) -> Bool
    private var expectedDispatches = [DispatchMatcher]()
    private var getState: () -> State? {
        return {
            return self.expectedStates.remove(at: 0)
        }
    }
    private var expectedStates = [State]()
    
    init(_ action: AsyncAction, description: String? = nil) {
        self.action = action
        super.init(description: description ?? "ExpectAsyncAction: \(action)")
    }
    
    func dispatches<A: Action & Equatable>(_ action: A) -> Self {
        func matcher(dispatched: Action) -> Bool {
            guard let dispatched = dispatched as? A else {
                return false
            }
            return dispatched == action
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
