//
//  LikeCell.swift
//  myscrap
//
//  Created by MS1 on 6/22/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

final class LikeCell: UITableViewCell {


    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var designationLabel:UILabel!
    @IBOutlet weak var companyLabel:UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.font = Fonts.NAME_FONT
        nameLabel.textColor = UIColor.BLACK_ALPHA
        
        designationLabel.font = Fonts.DESIG_FONT
        designationLabel.textColor = UIColor.BLACK_ALPHA

    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configCell(lk: Like){
        nameLabel.text = lk.name
        if lk.usercompany == ""{
            designationLabel.text = "\(lk.designation)"
            designationLabel.textColor = UIColor.BLACK_ALPHA
        } else {
            designationLabel.text = "\(lk.designation) \u{2022} \(lk.usercompany)"
            designationLabel.textColor = UIColor.BLACK_ALPHA
        }
        companyLabel.text = lk.usercompany
        profileView.updateViews(name: lk.name, url: lk.likeProfilePic, colorCode: lk.colorCode)
        profileTypeView.checkType = ProfileTypeScore(isAdmin:lk.admin == "Admin",isMod: lk.isMod, isNew:lk.isNew, rank:lk.rank, isLevel: false, level: nil)
    }
    
    
}
