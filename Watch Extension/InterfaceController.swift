//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Jason Prasad on 10/1/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import Foundation
import RAPI
import ReSwift
import UNI
import WatchKit

class InterfaceController: WKInterfaceController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = ChildrenState
    
    var postings: [Posting] = []
    @IBOutlet var table: WKInterfaceTable!

    @IBAction func refresh() {
        store.dispatch(ChildrenActions.clearChildren)
        store.dispatch(fetchChildren())
    }
}

// MARK:- Lifecycle

extension InterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        store.dispatch(fetchChildren())
    }
    
    override func willActivate() {
        super.willActivate()
        
        store.subscribe(self) { $0.select { $0.children }.skip(when: ==) }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        store.unsubscribe(self)
    }
    
}

// MARK:- StoreSubscriber

extension InterfaceController {
    
    func newState(state: ChildrenState) {
        let newPostings = state.children.flatMap { $0.children }
        
        if postings != newPostings {
            postings = newPostings
            reloadTable()
        }
    }
    
}

// MARK:- Table

extension InterfaceController {
    
    func reloadTable() {
        table.setNumberOfRows(postings.count, withRowType: "PostingRow")
        
        for (index, posting) in postings.enumerated() {
            let row = table.rowController(at: index) as! PostingRow
            row.subredditLabel.setText("/r/\(posting.subreddit)")
            row.titleLabel.setText(posting.title)
        }
    }
    
}
