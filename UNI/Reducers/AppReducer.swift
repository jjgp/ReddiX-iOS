//
//  AppReducer.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift
import ReSwiftRouter

public func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        children: childrenReducer(action: action, state: state?.children),
        navigation: NavigationReducer.handleAction(action, state: state?.navigation)
    )
}
