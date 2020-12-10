//
//  Land_Feeds_ImageTextCell.swift
//  myscrap
//
//  Created by MyScrap on 1/13/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class Land_Feeds_ImageTextCell: BaseCell {
    
    @IBOutlet weak var borderView: LandCRadiusView!
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var profileView: LandProfileView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var desgCompLbl: UILabel!
    @IBOutlet weak var postTimeLbl: LandTimeLabel!
    @IBOutlet weak var statusTextLbl: UILabel!
    @IBOutlet weak var firstLikeIV: UIImageView!
    @IBOutlet weak var secondLikeIV: UIImageView!
    @IBOutlet weak var thirdLikeIV: UIImageView!
    @IBOutlet weak var likesCmntLbl: UILabel!
    @IBOutlet weak var likeBtn: LandLikeImageButton!
    @IBOutlet weak var feedsImageView: UIImageView!
    
    @IBOutlet weak var firstLikeWidth: NSLayoutConstraint!
    @IBOutlet weak var secondLikeWidth: NSLayoutConstraint!
    @IBOutlet weak var thirdLikeWidth: NSLayoutConstraint!
    @IBOutlet weak var likeImgSpacing: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var likeBtnAction: ((Any) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderColor = UIColor.darkGray.cgColor
        borderView.layer.borderWidth = 0.1
        
        borderView.layer.shadowColor = UIColor.black.cgColor
        borderView.layer.shadowOpacity = 0.1
        borderView.layer.shadowOffset = CGSize(width: 0, height: 5)
        borderView.layer.shadowRadius = 2
        borderView.layer.shadowPath = UIBezierPath(roundedRect: borderView.bounds, cornerRadius: 10).cgPath
        borderView.layer.shouldRasterize = true
        borderView.layer.rasterizationScale = UIScreen.main.scale
    }

    @IBAction func likeBtnTapped(_ sender: UIButton) {
        likeBtnAction?(sender)
    }
}
