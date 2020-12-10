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

    @IBOutlet weak var reportedImage: UIImageView!
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var companyRatingStar: CosmosView!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var affliationBtn: CorneredButton!
    @IBOutlet weak var isriBtn: CorneredButton!
    @IBOutlet weak var ownCompBtn: UIButton!

    @IBOutlet weak var reportDescTitleLabel : UILabel!
    @IBOutlet weak var reportDescLabel : UILabel!
        
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
            
            
            var reportTypeStr : String = item.reportedType
            if reportTypeStr == "0" {
                reportTypeStr = "Admin"
            }
            else {
                reportTypeStr = "Company"
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

        self.reportDescLabel.layer.cornerRadius = 5
        self.reportDescLabel.layer.masksToBounds = true
        
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
