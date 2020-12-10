//
//  LikesCountCell.swift
//  myscrap
//
//  Created by MS1 on 11/23/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class LikesCountCell: BaseCell {
    
    @IBOutlet private weak var likeImgButton: LikeImageButton!
    @IBOutlet private weak var label : UILabel!

    func configCell(item: FeedV2Item?){
        guard let feedItem = item else { return }
        likeImgButton.isLiked = feedItem.likeStatus
        label.text = getlikelblText(likeStatus: feedItem.likeStatus, likeCount: feedItem.likeCount)
    }
    
    private func getlikelblText(likeStatus: Bool, likeCount: Int) -> String{
        if likeStatus{
            if likeCount == 1{
                return "You liked this"
            } else {
                return "You and \(likeCount - 1) people liked this"
            }
        } else {
            
            if likeCount == 1{
                return "1 person liked this"
            } else {
                return "\(likeCount) people liked this."
            }
        }
    }
}

