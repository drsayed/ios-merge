//
//  NewUserInsideScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 3/23/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

protocol NewUserDelegate : class {
    func didTapProfile(userId: String)
}

class NewUserInsideScrollCell: BaseCell {

    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var profileView: NewMembsProfileView!
    @IBOutlet weak var profileType: NewMembsProfileTypeView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var joinedLbl: UILabel!
    @IBOutlet weak var bigProfileIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        curveView.layer.cornerRadius = 10
//        curveView.layer.borderWidth = 0.2
//        curveView.layer.borderColor = UIColor.black.cgColor
//        curveView.layer.shadowColor = UIColor.black.cgColor
//        curveView.layer.shadowOffset = CGSize.zero
//        curveView.layer.shadowOpacity = 1
//        curveView.layer.shadowRadius = 10
//        curveView.layer.masksToBounds = true
        
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
        
    }

}
