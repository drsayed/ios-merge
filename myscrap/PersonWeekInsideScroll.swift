//
//  PersonWeekInsideScroll.swift
//  myscrap
//
//  Created by MyScrap on 8/4/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

protocol POWScrollDelegate : class {
    func didTapPOWView(powId : String, userId : String)
    func didTapUserProfile(userId: String)
    func didShareBtnTapped(sender : Any, powId: String)
}

class PersonWeekInsideScroll: BaseCell {
    
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var powImageView: UIImageView!
    @IBOutlet weak var powName: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var viewBio: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var shareBtnAction: ((Any) -> Void)?
    var offlineActionBlock : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codecurveView.backgroundColor = UIColor.clear
        spinner.startAnimating()
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
