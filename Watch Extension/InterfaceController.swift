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
    
    var state: ChildrenState?
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
        
        store.subscribe(self) { $0.select { $0.children }.skipRepeats() }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        store.unsubscribe(self)
    }
    
}

// MARK:- StoreSubscriber

extension InterfaceController {
    
    func newState(state: ChildrenState) {
        let shouldReload = self.state?.children == state.children
        self.state = state
        
        if shouldReload {
            reloadTable()
        }
    }
    
}

// MARK:- Table

extension InterfaceController {
    
    func reloadTable() {
        table.setNumberOfRows(state!.children.count, withRowType: ChildRow.reuseIdentifier)
        
        for (index, posting) in state!.children.enumerated() {
            let row = table.rowController(at: index) as! ChildRow
            row.subredditLabel.setText("/r/\(posting.subreddit)")
            row.titleLabel.setText(posting.title)
        }
    }
    
}
