//
//  AppState.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift

public struct AppState: StateType {
    
    public var children: ChildrenState
    
    public init(children: ChildrenState) {
        self.children = children
    }
    
}

extension AppState: Equatable {
    
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.children == rhs.children
    }
    
}
