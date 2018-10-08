//
//  ChildrenViewController.swift
//  ReddiX
//
//  Created by Jason Prasad on 9/29/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import ReSwift
import ReSwiftRouter
import SafariServices
import UIKit
import UNI

class ChildrenViewController: UIViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = ListingsState?
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: ChildrenTableView!
    
}

// MARK:- Lifecycle

extension ChildrenViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        store.subscribe(self) { $0.select { $0.listings.last }.skipRepeats() }
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        store.unsubscribe(self)
        
        super.viewWillDisappear(animated)
    }
    
}

// MARK:- StoreSubscriber

extension ChildrenViewController {
    
    func newState(state: ListingsState?) {
        DispatchQueue.main.async {
            if state?.isFetching == true {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}
