//
//  AppDelegate.swift
//  ReddiX
//
//  Created by Jason Prasad on 9/29/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift
import UIKit
import UNI

#if DEBUG
let middleware = [loggingMiddleware]
#else
let middleware = []
#endif

var store: Store<AppState> = createStore(middleware: middleware)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

}

