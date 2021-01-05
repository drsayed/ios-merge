//
//  ReportCompanyAdminCollectionViewCell.swift
//  myscrap
//
//  Created by Apple on 08/11/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import Cosmos

class ReportCompanyAdminCollectionViewCell: BaseCell {

    @IBOutlet weak var reportedUserLabel : UILabel!
    @IBOutlet weak var reportedTypeLabel : UILabel!

    @IBOutlet weak var adminViewButton: UIButton!
    @IBOutlet weak var companyViewButton: UIButton!
    @IBOutlet weak var reportedImage: UIImageView!
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var companyRatingStar: CosmosView!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var affliationBtn: CorneredButton!
    @IBOutlet weak var isriBtn: CorneredButton!
    @IBOutlet weak var ownCompBtn: UIButton!
    @IBOutlet weak var reportedCompBtn: UIButton!
    @IBOutlet weak var reportDescTitleLabel : UILabel!
    @IBOutlet weak var reportDescLabel : UILabel!
    @IBOutlet weak var reportDescView: UIView!
    
    @IBOutlet weak var adminViewHeight: NSLayoutConstraint!
    @IBOutlet weak var adminView: UIView!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var adminImage: UIImageView!
    @IBOutlet weak var adminNameLabel: UILabel!
    
    @IBOutlet weak var adminDesignationLabel: UILabel!
    
    var companyItem : CompanyItems? {
        didSet{
            guard let item = companyItem else { return }
//            configCell(withItem: item)
            
            if item.companyProfilePic != "" {
                reportedImage.setImageWithIndicator(imageURL: item.companyProfilePic)
            }

            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: "Reported By • ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.BLACK_ALPHA, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 13)!]))
            attributedString.append(NSAttributedString(string: item.reportedBy, attributes: [NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 13)!]))
            self.reportedUserLabel.attributedText = attributedString
            
            
            var reportTypeStr : String = item.reportType
            if reportTypeStr == "0" {
                reportTypeStr = "Admin"
                self.adminViewHeight.constant = 60
                self.adminView.isHidden = false
                self.adminNameLabel.text = item.employees[0].name
                let designation = item.employees[0].designation
                self.adminDesignationLabel.text = designation == "" ? "Trader" : designation
                self.reportedCompBtn.isHidden = true
                if item.employees[0].profilePic != "" {
                    self.adminImage.setImageWithIndicator(imageURL: item.employees[0].profilePic)
                }
                
            }
            else {
                reportTypeStr = "Company"
                self.adminViewHeight.constant = 0
                self.adminView.isHidden = true
                self.reportedCompBtn.isHidden = false
            }
//            reportTypeStr = "Company"

            
            let reportTypeAttrStr = NSMutableAttributedString()
            reportTypeAttrStr.append(NSAttributedString(string: "Report type • ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.BLACK_ALPHA, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 13)!]))
            reportTypeAttrStr.append(NSAttributedString(string: reportTypeStr, attributes: [NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 13)!]))

            
            self.reportedTypeLabel.attributedText = reportTypeAttrStr
            
            self.companyName.text = item.compnayName
            
            if item.companyType == "" {
                self.designationLbl.text = "Not provided"
            } else {
                self.designationLbl.text = item.interest.last?.industry.last
            }
            self.avgRatingLbl.text = item.AvgRating
            self.affliationBtn.setTitle(item.affiliation.first, for: .normal)
            self.isriBtn.setTitle(item.affiliation.last, for: .normal)
            self.companyRatingStar.rating = (self.avgRatingLbl.text! as NSString).doubleValue
            self.companyRatingStar.text = " (" + item.totalReview + ")"

            
            if item.reportedReason != "" {
                self.reportDescLabel.text = item.reportedReason
            }
        }
    }
    
//    override func configCell(withItem item: CompanyItems) {
//        super.configCell(withItem: item)
//
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        affliationBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        affliationBtn.layer.borderWidth = 1
        
        isriBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        isriBtn.layer.borderWidth = 1


        self.ownCompBtn.setTitle("   Reported   ", for: .normal)
        self.ownCompBtn.layer.cornerRadius = 3
        self.ownCompBtn.layer.masksToBounds = true
        
        self.reportedCompBtn.setTitle("   Reported   ", for: .normal)
        self.reportedCompBtn.layer.cornerRadius = 3
        self.reportedCompBtn.layer.masksToBounds = true

        self.reportDescView.layer.cornerRadius = 5
        self.reportDescView.layer.masksToBounds = true
        
        self.adminButton.layer.cornerRadius = 5
        self.adminButton.layer.masksToBounds = true
        self.adminButton.layer.borderWidth = 1
        self.adminButton.layer.borderColor = UIColor.MyScrapGreen.cgColor
        
        if network.reachability.isReachable == true {
            reportedImage.contentMode = .scaleAspectFill
            reportedImage.clipsToBounds = true
            reportedImage.isUserInteractionEnabled = true
//            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//            tap.numberOfTapsRequired = 1
//            reportedImage.addGestureRecognizer(tap)

        } else {
//            offlineBtnAction?()
        }
    }
}
