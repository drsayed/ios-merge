//
//  MemberCell.swift
//  myscrap
//
//  Created by MS1 on 10/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
protocol MembersCellDelegate: class{
    func favouriteBtnPressed(cell: MemberCell)
}

class MemberCell: BaseCell {

    weak var delegate : MembersCellDelegate?
    weak var favouriteVC : FavouriteVC?
    
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var designationLabel:UILabel!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var scoreLbl:UILabel!
    @IBOutlet weak var starBtn:UIButton!
    @IBOutlet weak var countryLbl:UILabel!

    
    var iscontacts:Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = Fonts.NAME_FONT
        nameLabel.textColor = UIColor.BLACK_ALPHA
        // MARK DESIGNATION LABEL
        designationLabel.textColor = UIColor.BLACK_ALPHA
        designationLabel.numberOfLines = 2
        designationLabel.font = Fonts.DESIG_FONT
        // MARK COUNTRY LABEL
        countryLbl.textColor = UIColor.BLACK_ALPHA
        countryLbl.font = Fonts.DESIG_FONT
        scoreLbl.textColor = UIColor.gray
        starBtn.isHidden = true
    }
    
    func configCell(item: MemberItem, isFavourite: Bool = false){
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
        nameLabel.text = item.name
        designationLabel.text = item.userCompany == "" ? item.designation : "\(item.designation) • \(item.userCompany)"
        profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank, isLevel: item.isLevel, level: item.level)
        

        countryLbl.text = item.country == "" ? "" : item.country
    
        scoreLbl.text = isFavourite ? "" : item.score
        starBtn.isHidden = AuthService.instance.userId == item.userId ? true : false
        let favImg = #imageLiteral(resourceName: "fav").withRenderingMode(.alwaysTemplate)
        starBtn.setImage(favImg, for: .normal)
        starBtn.tintColor = UIColor.GREEN_PRIMARY
    }
    
    func configLike(item: MemberItem){
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
        nameLabel.text = item.name
        designationLabel.text = item.userCompany == "" ? item.designation : "\(item.designation) • \(item.userCompany)"
        profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank, isLevel: item.isLevel, level: item.level)
        countryLbl.text = item.country == "" ? "" : item.country
        scoreLbl.text = item.score
    }
    
    @IBAction func favoutiteBtnTapped(_ sender: UIButton){
        delegate?.favouriteBtnPressed(cell: self)
    }

}
