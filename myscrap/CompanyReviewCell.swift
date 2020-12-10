//
//  CompanyReviewCell.swift
//  myscrap
//
//  Created by MyScrap on 6/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import Cosmos

class CompanyReviewCell: UITableViewCell {

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var star:CosmosView!
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var reviewTextView:UITextView!
    
    weak var delegate: ReviewServiceDelegate?
    
    var userData : UserReview? {
        didSet {
            if let items = userData {
                configure(userData: items)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(userData: UserReview) {
        star.settings.updateOnTouch = false
        nameLbl.text = userData.name
        dateLbl.text = userData.date
        reviewCount.text = userData.reviewCount
        star.rating = userData.ratting
        
        let name = userData.first_name + " " + userData.last_name
        profileView.updateViews(name: name, url: userData.profilePic, colorCode: userData.colorcode)
        //profileTypeView.checkType = ProfileTypeScore(isAdmin: true, isMod: false, isNew: false, rank: nil)
        if userData.reviewText == "" {
            reviewTextView.text = "-"
        } else {
            reviewTextView.text = userData.reviewText
        }
        
        adjustUITextViewHeight(arg: reviewTextView)
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = false
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }

}
