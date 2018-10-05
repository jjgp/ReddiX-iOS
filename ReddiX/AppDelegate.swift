//
//  AppDelegate.swift
//  ReddiX
//
//  Created by Jason Prasad on 9/29/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift
import ReSwiftRouter
import UIKit
import UNI

// MARK:- Store Singleton

#if DEBUG
let middleware = [loggingMiddleware]
#else
let middleware = []
#endif

let store: Store<AppState> = createStore(middleware: middleware)

// MARK:- Router

var router: Router<AppState>!

// MARK:- AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = window?.rootViewController as! ChildrenViewController
        
        router = Router(store: store, rootRoutable: RootRoutable(rootViewController: rootViewController)) { state in
            state.select { $0.navigation }
        }
        
        return true
    }

}

