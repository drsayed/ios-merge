//
//  FeedImageTextCell.swift
//  myscrap
//
//  Created by MS1 on 10/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
class ReportedFeedImageTextCell: ReportedFeedImageCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /*override func setupAPIViews(item: FeedItem) {
        super.setupAPIViews(item: item)
        statusTextView?.attributedText = item.description
    }*/
    
    override func configCell(withItem item: FeedV2Item){
        super.configCell(withItem: item)
        //Download StackView hide for only FeedText
        dwnldStackView.isHidden = false
    }
    override func setupAPIViews(item: FeedV2Item) {
        super.setupAPIViews(item: item)
        descriptionText?.attributedText = item.descriptionStatus
    }
    
    override func setupTap(){
        descriptionText?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
        tap.numberOfTapsRequired = 1
        descriptionText?.addGestureRecognizer(tap)
    }
//    override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//          
//            guard let item = newItem else { return }
//            updatedDelegate?.didTapImageViewV2(atIndex: indexPath.item, item: item)
//    }
}

