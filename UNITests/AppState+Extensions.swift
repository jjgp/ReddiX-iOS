//
//  AppState+Extensions.swift
//  UNITests
//
//  Created by Jason Prasad on 10/5/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

@testable import UNI

extension AppState {
    
    init() {
        self.init(children: ChildrenState())
    }
    
}
