//
//  ViewController.swift
//  ReddiX
//
//  Created by Jason Prasad on 9/29/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import ReSwift
import SafariServices
import UIKit
import UNI

class ChildrenViewController: UIViewController {
    
    @IBOutlet var searchBar: ChildrenSearchBar!
    @IBOutlet var tableView: ChildrenTableView!
    
}

// MARK:- Lifecycle

extension ChildrenViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
        
        store.dispatch(fetchChildren())
    }
    
}

// MARK:- Actions

extension ChildrenViewController {
    
    @objc func tapped() {
        searchBar.resignFirstResponder()
    }
    
}
