//
//  SubredditSearchView.swift
//  ReddiX
//
//  Created by Jason Prasad on 10/5/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwiftRouter
import UIKit
import UNI

class SubredditSearchView: UIStackView {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
}

extension SubredditSearchView {
    
    func clearSubreddit(animated: Bool) {
        searchBar.text = ""
        setBackButtonIsHidden(true)
        store.dispatch(SetRouteAction([], animated: animated))
        searchBar.endEditing(true)
    }
    
}

// MARK: Back Button

extension SubredditSearchView {
    
    func setBackButtonIsHidden(_ hidden: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.backButton.isHidden = hidden
        }
    }
    
    @IBAction func backButtonPressed() {
        clearSubreddit(animated: true)
    }
    
}

// MARK: UISearchBarDelegate

extension SubredditSearchView: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSubreddit(animated: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        searchBar.resignFirstResponder()
        setBackButtonIsHidden(false)
        store.dispatch(ListingsActions.clearChildren())
        store.dispatch(ListingsActions.setSubreddit(text))
        store.dispatch(ListingsActions.fetchChildren(replacement: true))
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        if store.state.navigation.route.count < 1 {
            store.dispatch(SetRouteAction([.childrenViewController], animated: false))
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}
