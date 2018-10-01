//
//  ViewController.swift
//  ReddiX
//
//  Created by Jason Prasad on 9/29/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import ReSwift
import UIKit
import UNI

class ChildrenViewController: UIViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = ChildrenState
    
    var isRefreshing = false
    var isFetching = false
    var postings: [Posting] = []
    @IBOutlet var tableView: UITableView!
    
}

// MARK:- Lifecycle

extension ChildrenViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) { $0.select { $0.children }.skip(when: ==) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshChildren),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        
        store.dispatch(FetchChildren())
    }
    
}

// MARK:- Refresh

extension ChildrenViewController {
    
    @objc func refreshChildren() {
        isRefreshing = true
        store.dispatch(FetchChildren(replacement: true))
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

// MARK:- UIScrollViewDelegate

extension ChildrenViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !isFetching else {
            return
        }
        
        // NOTE: https://stackoverflow.com/a/31454471
        let offset = scrollView.contentOffset.y + scrollView.frame.size.height
        if (offset >= scrollView.contentSize.height) {
            store.dispatch(FetchChildren())
        }
    }
    
}

// MARK:- UITableViewDelegate

extension ChildrenViewController: UITableViewDelegate {}
