//
//  Land_Online_UsersCell.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

protocol LandOnlineScrollDelegate : class {
    func didTapUserProfile(userId: String)
    func didTapOnlineUser(friendId: String, name: String, colorCode: String, profileImage: String, jid: String)
}

class Land_Online_UsersCell: BaseCell {
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var rankView: ProfileTypeView!
    @IBOutlet weak var onlineView: CircleView!
    
}
