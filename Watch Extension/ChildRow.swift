//
//  ChildRow.swift
//  Watch Extension
//
//  Created by Jason Prasad on 10/1/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import Foundation
import WatchKit

class ChildRow: NSObject {
    
    static var reuseIdentifier = "ChildRow"
    @IBOutlet weak var subredditLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
}
