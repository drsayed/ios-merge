//
//  ReportedFeedImageTextCell.swift
//  myscrap
//
//  Created by MS1 on 10/10/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ReportedFeedImageTextCell: ReportedFeedImageCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setupAPIViews(item:FeedV2Item){
        super.setupAPIViews(item: item)
        descriptionText?.attributedText = item.descriptionStatus
    }
    
    override func configCell(withItem item: FeedV2Item) {
        super.configCell(withItem: item)
        self.setupAPIViews(item: item)
        reportedView.isHidden = true
        
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "Reported By • ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.BLACK_ALPHA, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 11)!]))
        attributedString.append(NSAttributedString(string: item.reportBy, attributes: [NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 11)!]))
        reportedLbl.attributedText = attributedString
    }
    
    override func setupTap(){
        if network.reachability.isReachable == true {
            descriptionText?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
            tap.numberOfTapsRequired = 1
            descriptionText?.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
    }
    
    

}
