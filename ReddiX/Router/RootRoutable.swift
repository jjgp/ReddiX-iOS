//
//  RootRoutable.swift
//  ReddiX
//
//  Created by Jason Prasad on 10/6/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwiftRouter
import SafariServices
import UIKit

struct RootRoutable {
    
    let rootViewController: UIViewController
    
}

// MARK:- Routable

extension RootRoutable: Routable {
    
    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                          animated: Bool,
                          completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        let navigationState = store.state!.navigation
        let routeSpecificState: Any? = navigationState.getRouteSpecificState(navigationState.route)
        
        if routeElementIdentifier == .childViewController {
            guard let url = routeSpecificState as? URL else {
                fatalError("failed to call SetRouteSpecificData(route: [.childViewController], data: url)")
            }
            
            rootViewController.present(ChildViewController(url: url),
                                       animated: animated,
                                       completion: completionHandler)
        }
        
        return self
    }
    
    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                         animated: Bool,
                         completionHandler: @escaping RoutingCompletionHandler) {
        completionHandler()
    }
    
}
