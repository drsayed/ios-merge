//
//  FeedImageTextCell.swift
//  myscrap
//
//  Created by MS1 on 10/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
class FeedImageTextCell: FeedImageCell {
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
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    override func setupAPIViews(item: FeedV2Item) {
        super.setupAPIViews(item: item)
        statusTextView?.attributedText = item.descriptionStatus
        if (item.likeCount == 0 && item.commentCount == 0  && item.viewsCount == 0 ){
            likeCommentViewHeight.constant = 0
        }
        else{
            likeCommentViewHeight.constant = 22
        }
        if (item.likeCount == 0) {
          
            likeCommentsDistance.constant = -30
        }
        else{
            
            likeCommentsDistance.constant = 10
        }
    }
    
    override func setupTap(){
        statusTextView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
        tap.numberOfTapsRequired = 1
        statusTextView?.addGestureRecognizer(tap)
    }
//    override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//          
//            guard let item = newItem else { return }
//            updatedDelegate?.didTapImageViewV2(atIndex: indexPath.item, item: item)
//    }
}

