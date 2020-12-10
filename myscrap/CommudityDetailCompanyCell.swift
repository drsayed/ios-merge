//
//  CommudityDetailCompanyCell.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class CommudityDetailCompanyCell: BaseTableCell {


    @IBOutlet weak var premiumLable: UILabel!
    @IBOutlet weak var companyAddress: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet var changeIndicator: UIImageView!
    @IBOutlet weak var reportPriceBtn: UIButton!
    @IBOutlet weak var companyDetailsBtn: UIButton!
    @IBOutlet weak var phoneBtnHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var reporttButtonHight: NSLayoutConstraint!
    
    @IBOutlet weak var reportButtonSpaces: NSLayoutConstraint!
    @IBOutlet weak var mobileNumberBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        premiumLable.layer.cornerRadius = premiumLable.frame.size.height/2
        premiumLable.layer.borderWidth = 1
        premiumLable.layer.borderColor = UIColor.MyScrapGreen.cgColor
        premiumLable.textColor =  UIColor.MyScrapGreen
        reportPriceBtn.layer.cornerRadius = 5

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
