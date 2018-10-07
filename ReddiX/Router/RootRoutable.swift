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
    
    let rootViewController: ListingViewController
    
}

// MARK:- Routable

extension RootRoutable: Routable {
    
    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                          animated: Bool,
                          completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        let navigationState = store.state!.navigation
        let routeSpecificState: Any? = navigationState.getRouteSpecificState(navigationState.route)
        
        switch routeElementIdentifier {
        case .childViewController:
            guard let url = routeSpecificState as? URL else {
                fatalError("failed to call SetRouteSpecificData(route: [.childViewController], data: url)")
            }
            
            rootViewController.present(ChildViewController(url: url),
                                       animated: animated,
                                       completion: completionHandler)
        case .childrenViewController:
            let childrenViewController = ChildrenViewController.fromStoryboard() as! ChildrenViewController
            childrenViewController.view.frame = rootViewController.containerView.bounds
            rootViewController.addChild(childrenViewController)
            rootViewController.containerView.addSubview(childrenViewController.view)
            childrenViewController.didMove(toParent: rootViewController)
            completionHandler()
        default:
            completionHandler()
        }
        
        return self
    }
    
    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                         animated: Bool,
                         completionHandler: @escaping RoutingCompletionHandler) {
        switch routeElementIdentifier {
        case .childrenViewController:
            let childrenViewController = rootViewController.children.last!
            let completion: (Bool) -> Void = { _ in
                childrenViewController.view.removeFromSuperview()
                childrenViewController.removeFromParent()
                completionHandler()
            }
            
            childrenViewController.willMove(toParent: nil)
            if animated {
                childrenViewController.view.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                UIView.animate(withDuration: 0.2,
                               animations: {
                                let width = childrenViewController.view.bounds.width
                                childrenViewController.view.transform = CGAffineTransform(translationX: width, y: 0.0)
                },
                               completion: completion)
            } else {
                completion(true)
            }
        default:
            completionHandler()
        }
    }
    
}

extension UIViewController {
    
    static func fromStoryboard(named: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: named, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "\(self)")
    }
    
}
