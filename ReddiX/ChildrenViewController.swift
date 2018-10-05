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

class ChildrenViewController: UIViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = ChildrenState
    
    var isRefreshing = false
    var isFetching = false
    var postings: [Posting] = []
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
}

// MARK:- Lifecycle

extension ChildrenViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshChildren),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
        
        store.dispatch(fetchChildren())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) { $0.select { $0.children }.skip(when: ==) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
    
}

// MARK:- Actions

extension ChildrenViewController {
    
    @objc func refreshChildren() {
        isRefreshing = true
        store.dispatch(fetchChildren(replacement: true))
    }
    
    @objc func tapped() {
        searchBar.resignFirstResponder()
    }
    
}

// MARK:- StoreSubscriber

extension ChildrenViewController {
    
    func newState(state: ChildrenState) {
        isFetching = state.isFetching
        
        let newPostings = state.children.flatMap { $0.children }
        
        if !state.isFetching, isRefreshing {
            isRefreshing = false
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
        
        if postings != newPostings {
            postings = newPostings
            DispatchQueue.main.async {
                if self.postings.count > 0 {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                } else {
                    self.tableView.isHidden = true
                }
            }
        }
    }
    
}

// MARK:- UISearchBarDelegate

extension ChildrenViewController: UISearchBarDelegate {
    
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

// MARK:- UITableViewDataSource

extension ChildrenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return postings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Posting", for: indexPath) as! PostingTableViewCell
        cell.update(with: postings[indexPath.section])
        return cell
    }
    
}

// MARK:- UITableViewDelegate

extension ChildrenViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !isFetching else {
            return
        }
        
        // NOTE: https://stackoverflow.com/a/31454471
        let offset = scrollView.contentOffset.y + scrollView.frame.size.height
        if (offset >= scrollView.contentSize.height) {
            store.dispatch(fetchChildren())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = URL(string: postings[indexPath.section].url) else {
            return
        }
        
        self.present(SFSafariViewController(url: url), animated: true)
    }
    
}
