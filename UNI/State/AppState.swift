//
//  AppState.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift
import ReSwiftRouter

public struct AppState: StateType {
    
    public var children: ChildrenState
    public var navigation: NavigationState
    
    public init(children: ChildrenState,
                navigation: NavigationState) {
        self.children = children
        self.navigation = navigation
    }
    
}

extension AppState: Equatable {
    
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.children == rhs.children
    }
    
}
