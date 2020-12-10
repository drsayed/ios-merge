//
//  FriendProfileCell.swift
//  myscrap
//
//  Created by MS1 on 11/20/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class FriendProfileCell: UserProfileCell {

    @IBOutlet weak var chatBtn: CorneredButton!
    @IBOutlet weak var favouriteBtn: FavouriteButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func configCell(item: ProfileData) {
        super.configCell(item: item)
        favouriteBtn.isFavourite = item.isFavourite
    }

    @IBAction func chatBtnPressed(_ sender: UIButton) {
        delegate?.DidPressChat(cell: self)
    }
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
        delegate?.DidPressFavourite(cell: self)
    }
    
}
