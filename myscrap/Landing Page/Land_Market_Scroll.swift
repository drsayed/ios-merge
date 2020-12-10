//
//  Land_Market_Scroll.swift
//  myscrap
//
//  Created by MyScrap on 1/14/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

protocol LandMarketScrollDelegate : class {
    func didTapMarketView(listingId : String, userId : String)
    func didTapMUserProfile(userId: String)
    func didShareBtnTapped(sender : Any, listingId: String, userId : String, image: UIImage,imageURL: NSURL)
}

class Land_Market_Scroll: BaseCell {
    @IBOutlet weak var borderView: LandCRadiusView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var listingImgView: LandImageViewCRadius!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
    }

}
