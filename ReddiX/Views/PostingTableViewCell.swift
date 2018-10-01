//
//  PostingTableViewCell.swift
//  ReddiX
//
//  Created by Jason Prasad on 10/1/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import UIKit

class PostingTableViewCell: UITableViewCell {
    
    @IBOutlet var subredditLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
}

extension PostingTableViewCell {
    
    func update(with posting: Posting) {
        subredditLabel.text = "/r/\(posting.subreddit)"
        titleLabel.text = posting.title
    }
    
}
