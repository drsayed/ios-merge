//
//  UserFeedImageTextCell.swift
//  myscrap
//
//  Created by MyScrap on 12/15/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class UserFeedImageTextCell: UserFeedImageCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setupAPIViews(item: FeedV2Item) {
        super.setupAPIViews(item: item)
        statusTextView?.attributedText = item.descriptionStatus
    }
    
    override func setupTap(){
        statusTextView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
        tap.numberOfTapsRequired = 1
        statusTextView?.addGestureRecognizer(tap)
    }

}
