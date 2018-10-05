//
//  ChildrenSearchBar.swift
//  ReddiX
//
//  Created by Jason Prasad on 10/5/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import UIKit
import UNI

class ChildrenSearchBar: UISearchBar {}

extension ChildrenSearchBar {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            delegate = self
            showsCancelButton = true
        }
        
        super.willMove(toSuperview: newSuperview)
    }
    
}

// MARK: UISearchBarDelegate

extension ChildrenSearchBar: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        searchBar.resignFirstResponder()
        fetch(subreddit: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        fetch()
    }
    
    func fetch(subreddit: String? = nil) {
        store.dispatch(ChildrenActions.clearChildren)
        store.dispatch(ChildrenActions.setSubreddit(subreddit))
        store.dispatch(fetchChildren(replacement: true))
    }
    
}
