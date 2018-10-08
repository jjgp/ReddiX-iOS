//
//  ChildTableViewCell.swift
//  ReddiX
//
//  Created by Jason Prasad on 10/1/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import UIKit

class ChildTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(ChildTableViewCell.self)"
    @IBOutlet var subredditLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
}

// MARK:- Interface

extension ChildTableViewCell {
    
    func update(with child: Child) {
        subredditLabel.text = "/r/\(child.subreddit)"
        titleLabel.text = child.title
    }
    
}
