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
    
    public var listings: [ListingsState]
    public var navigation: NavigationState
    
    public init(listings: [ListingsState],
                navigation: NavigationState) {
        self.listings = listings
        self.navigation = navigation
    }
    
}

extension AppState: Equatable {
    
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.listings == rhs.listings
    }
    
}
