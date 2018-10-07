//
//  ChildViewController.swift
//  ReddiX
//
//  Created by Jason Prasad on 10/5/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwiftRouter
import SafariServices
import UIKit

class ChildViewController: SFSafariViewController {}

// MARK:- LifeCycle

extension ChildViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        delegate = self
        
        super.viewWillAppear(animated)
    }
    
}

// MARK:- SFSafariViewControllerDelegate

extension ChildViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
        store.dispatch(SetRouteAction([]))
    }
    
}
