//
//  ChildrenTableView.swift
//  ReddiX
//
//  Created by Jason Prasad on 10/5/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import ReSwift
import ReSwiftRouter
import UIKit
import UNI

class ChildrenTableView: UITableView, StoreSubscriber {
    
    typealias StoreSubscriberStateType = ChildrenState
    
    var state: ChildrenState?
    
}

extension ChildrenTableView {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            rowHeight = UITableView.automaticDimension
            estimatedRowHeight = 140
            
            dataSource = self
            delegate = self
            
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self,
                                      action: #selector(refreshChildren),
                                      for: .valueChanged)
            
            store.subscribe(self) { $0.select { $0.children }.skipRepeats() }
        } else {
            store.unsubscribe(self)
        }
        
        super.willMove(toSuperview: newSuperview)
    }
    
}

// MARK:- Actions

extension ChildrenTableView {
    
    @objc func refreshChildren() {
        store.dispatch(fetchChildren(replacement: true))
    }
    
}

// MARK:- StoreSubscriber

extension ChildrenTableView {
    
    func newState(state: ChildrenState) {
        let shouldEndProgress = self.state?.isFetching == true && !state.isFetching
        let shouldReload = self.state?.children != state.children
        self.state = state
        
        if shouldReload {
            DispatchQueue.main.async {
                self.isHidden = self.state?.children.count == 0
                self.reloadData()
            }
        }
        
        if shouldEndProgress {
            DispatchQueue.main.async {
                if self.refreshControl?.isRefreshing == true {
                    self.refreshControl?.endRefreshing()
                }
            }
        }
        
    }
    
}


// MARK:- UITableViewDataSource

extension ChildrenTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return state?.children.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChildTableViewCell.reuseIdentifier, for: indexPath) as! ChildTableViewCell
        cell.update(with: state!.children[indexPath.section])
        return cell
    }
    
}

// MARK:- UITableViewDelegate

extension ChildrenTableView: UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard state?.isFetching == false else {
            return
        }
        
        // NOTE: https://stackoverflow.com/a/31454471
        let offset = scrollView.contentOffset.y + scrollView.frame.size.height
        if (offset >= scrollView.contentSize.height) {
            store.dispatch(fetchChildren())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        guard let url = URL(string: state!.children[indexPath.section].url) else {
            return
        }
        
        store.dispatch(SetRouteSpecificData(route: [.childViewController], data: url))
        store.dispatch(SetRouteAction([.childViewController]))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
}
