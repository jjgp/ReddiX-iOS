//
//  MockStore.swift
//  UNITests
//
//  Created by Jason Prasad on 10/5/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift

class MockStore<State: StateType>: Store<State> {
    
    override func dispatch(_ action: Action) {
        guard action as? ReSwiftInit == nil else {
            return
        }
        
        proxy(action)
    }
    private var proxy: DispatchFunction!
    
    init(state: State, dispatch proxy: @escaping DispatchFunction) {
        self.proxy = proxy
        
        super.init(reducer: { _,_ in state }, state: nil)
    }
    
    required init(reducer: @escaping Reducer<State>,
                  state: State?,
                  middleware: [Middleware<State>]) {
        guard proxy != nil else {
            fatalError("use init(state:dispatch proxy:) to instantiate \(MockStore.self)")
        }
        
        super.init(reducer: reducer,
                   state: state,
                   middleware: middleware)
    }
    
}
