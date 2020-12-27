//
//  CompanyAdminRequestCell.swift
//  myscrap
//
//  Created by Mehtab Ahmed on 26/12/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import Cosmos

class CompanyAdminRequestCell: BaseCell {
    
    @IBOutlet weak var reportedUserLabel : UILabel!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var companyRatingStar: CosmosView!
    @IBOutlet weak var affliationBtn: CorneredButton!
    @IBOutlet weak var isriBtn: CorneredButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    var acceptAction: (() -> Void)? = nil
    var rejectAction: (() -> Void)? = nil
    
    var requestTypeStr: String {
        if requestItem?.type == "0" {
            return "Company Created By • "
        }
        else {
            return "Admin Request By • "
        }
    }
    
    var requestItem : AdminRequestModel? {
        didSet {
            guard let item = requestItem else { return }

            if item.companyPhoto != "" {
                companyImage.setImageWithIndicator(imageURL: item.companyPhoto!)
            }

            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: requestTypeStr, attributes: [NSAttributedString.Key.foregroundColor : UIColor.BLACK_ALPHA, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 13)!]))
            attributedString.append(NSAttributedString(string: item.senderName ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 13)!]))
            self.reportedUserLabel.attributedText = attributedString
            
            self.companyName.text = item.companyName
            self.avgRatingLbl.text = item.avgRating
            self.affliationBtn.setTitle(item.companyAffiliation?.first, for: .normal)
            if item.companyAffiliation?.count ?? 0 > 1 {
                self.isriBtn.isHidden = false
                self.isriBtn.setTitle(item.companyAffiliation?.last, for: .normal)
            }
            self.companyRatingStar.rating = (self.avgRatingLbl.text! as NSString).doubleValue
            self.companyRatingStar.text = "(\(item.totalReview ?? ""))"

        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isriBtn.isHidden = true
        
        affliationBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        affliationBtn.layer.borderWidth = 1
        
        isriBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        isriBtn.layer.borderWidth = 1
        
        acceptButton.layer.cornerRadius = 5
        rejectButton.layer.cornerRadius = 5
        
        if network.reachability.isReachable == true {
            companyImage.contentMode = .scaleAspectFill
            companyImage.clipsToBounds = true
            companyImage.isUserInteractionEnabled = true
        }
        
        acceptButton.addTarget(self, action:#selector(self.acceptBtnAction), for: .touchUpInside)
        
        rejectButton.addTarget(self, action:#selector(self.cancelBtnAction), for: .touchUpInside)
    }
    
    @objc func acceptBtnAction() {
        acceptAction!()
    }
    
    @objc func cancelBtnAction() {
        rejectAction!()
    }
}

