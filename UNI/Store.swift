//
//  Store.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift

public func createStore(middleware: [Middleware<AppState>]? = nil) -> Store<AppState> {
    return Store(reducer: appReducer,
                 state: nil,
                 middleware: middleware ?? [])
}
