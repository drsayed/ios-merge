//
//  OnlineMembersCell.swift
//  myscrap
//
//  Created by MyScrap on 4/6/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class OnlineMembersCell: BaseCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var innerView: CircleView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var grpIconBtn: UIButton!
    @IBOutlet weak var usersCountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        outerView.layer.borderWidth = 0.5
        outerView.layer.borderColor = UIColor.white.cgColor
        outerView.layer.shadowColor = UIColor.white.cgColor
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowRadius = 10
        outerView.layer.masksToBounds = true
        outerView.layer.cornerRadius = 10
        
        innerView.layer.borderWidth = 0.5
        innerView.layer.borderColor = UIColor.white.cgColor
        innerView.layer.shadowColor = UIColor.white.cgColor
        innerView.layer.shadowOffset = CGSize.zero
        innerView.layer.shadowOpacity = 1
        innerView.layer.shadowRadius = 10
        innerView.layer.masksToBounds = true

        
        grpIconBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 13, style: .solid)
        grpIconBtn.setTitle(String.fontAwesomeIcon(name: .users), for: .normal)
    }

}
