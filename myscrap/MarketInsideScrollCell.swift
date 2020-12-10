//
//  MarketInsideScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 3/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

protocol MarketScrollDelegate : class {
    func didTapMarketView(listingId : String, userId : String)
    func didTapUserProfile(userId: String)
    func didShareBtnTapped(sender : Any, listingId: String, userId : String, image: UIImage,imageURL: NSURL)
}

class MarketInsideScrollCell: BaseCell {

    
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var listingImgView: UIImageView!
    @IBOutlet var feedType: UILabel!
    @IBOutlet weak var listingTypeLbl: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var userBGView: UIView!
    @IBOutlet weak var postedUserProfileIV: MarketProfileView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var marketView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    var shareBtnAction: ((Any) -> Void)?
    var offlineActionBlock : (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postedUserProfileIV.label.font = Fonts.TIME_FONT
        listingImgView.layer.borderWidth = 0.1
//                _ = curveView.dropShadow()
        
        curveView.backgroundColor = UIColor.clear
        curveView.layer.shadowColor = UIColor.black.cgColor
        curveView.layer.shadowOpacity = 0.1
        curveView.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        curveView.layer.shadowRadius = 2
        curveView.layer.shadowPath = UIBezierPath(roundedRect: curveView.bounds, cornerRadius: 10).cgPath
        curveView.layer.shouldRasterize = true
        curveView.layer.rasterizationScale = UIScreen.main.scale
        
        // add the border to subview
        borderView.frame = curveView.bounds
        borderView.layer.cornerRadius = 10
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 0.1
        borderView.layer.masksToBounds = true
        
        
//        curveView.layer.cornerRadius = 10
////        curveView.layer.borderWidth = 0.5
//        curveView.layer.borderColor = UIColor.black.cgColor
//        curveView.layer.masksToBounds = false
//        curveView.clipsToBounds = true
        
        
        
//        curveView.layer.shadowPath = UIBezierPath(roundedRect: curveView.bounds, cornerRadius: 10).cgPath

        
        feedType.layer.shadowColor = UIColor.black.cgColor
        feedType.layer.shadowRadius = 3.0
        feedType.layer.shadowOpacity = 1.0
        feedType.layer.shadowOffset = CGSize(width: 4, height: 4)
        feedType.layer.masksToBounds = false
        
        shareBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        shareBtn.setTitle(String.fontAwesomeIcon(name: .shareAlt), for: .normal)
    }
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            shareBtnAction?(sender)
        } else {
            offlineActionBlock?()
        }
    }
}
class StrokedLabel: UILabel {
    
    var strockedText: String = "" {
        willSet(newValue) {
            let strokeTextAttributes : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.strokeColor : UIColor.black,
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.strokeWidth : -4.0,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)
                ] as [NSAttributedString.Key  : Any]
            
            let customizedText = NSMutableAttributedString(string: newValue,
                                                           attributes: strokeTextAttributes)
            attributedText = customizedText
        }
    }
    
}

