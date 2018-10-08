//
//  ListingViewController.swift
//  ReddiX
//
//  Created by Jason Prasad on 10/6/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import UIKit
import UNI

class ListingViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet var subredditSearchView: SubredditSearchView!
    
}

// MARK:- Lifecycle

extension ListingViewController {
    
    override func viewDidLoad() {
        if children.count == 1 {
            store.dispatch(ListingsActions.fetchChildren())
        }
        
        super.viewDidLoad()
    }
    
}
