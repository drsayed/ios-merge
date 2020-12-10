//
//  MembersCell.swift
//  myscrap
//
//  Created by MS1 on 1/15/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit



import UIKit
protocol MemberCellDelegate: class {
    func favouriteTapped(cell: MembersCell)
    func followersBtnTapped(cell: MembersCell)
}

final class MembersCell: BaseTableCell {
    
    weak var delegate : MemberCellDelegate?
    
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var designationLabel:UILabel!
    @IBOutlet weak var scoreLbl:UILabel!
    @IBOutlet weak var starBtn:UIButton!
    @IBOutlet weak var countryLbl:UILabel!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    
    var iscontacts:Bool!
    
    @IBOutlet weak var followUserButton: UIButton!

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
    }
    
    func configCell(item: MemberItem){
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
        nameLabel.text = item.name
        
        profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank, isLevel: item.isLevel, level: item.level)
        
        designationLabel.text = item.userCompany == "" ? item.designation : item.designation + " • " + item.userCompany
        countryLbl.text = item.country  == "" ? " " : item.country
        
        print(item.score)
        scoreLbl.text = item.score
        //MARK :- Favourite Button Configuration
        
        
        //print("friend \(item.userId)")
        /*
        if item.userId == AuthService.instance.userId{
            
            starBtn.isHidden = true
        } else {
            starBtn.isHidden = false
            
            let favImg = #imageLiteral(resourceName: "fav").withRenderingMode(.alwaysTemplate)
            let fav = #imageLiteral(resourceName: "fav1").withRenderingMode(.alwaysTemplate)
            
            if item.FriendStatus == 3 {
                starBtn.setImage(favImg, for: .normal)
                starBtn.tintColor = UIColor.GREEN_PRIMARY
            } else {
                starBtn.setImage(fav, for: .normal)
                starBtn.tintColor = UIColor.BLACK_ALPHA
            }
        }*/
        
        self.setUpFollowerButton(item: item)
    }
    
    func setUpFollowerButton(item: MemberItem) {
        
        if item.userId == AuthService.instance.userId {
            self.followUserButton.isHidden = true
        }
        else {
            self.followUserButton.isHidden = false
        }

        
        self.followUserButton.layer.cornerRadius = 5
        self.followUserButton.layer.masksToBounds = true
        self.followUserButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
        
         if item.followStatusType == 1 {
            self.followUserButton.setTitle("Requested", for: .normal)
            self.followUserButton.backgroundColor = UIColor.clear
            self.followUserButton.layer.borderColor = UIColor.black.cgColor
            self.followUserButton.layer.borderWidth = 1.0
            self.followUserButton.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
            self.followUserButton.semanticContentAttribute = .forceLeftToRight
            self.followUserButton.setImage(UIImage(named: "")?.withRenderingMode(.alwaysTemplate), for: .normal)

//            self.followUserButton.isEnabled = false
        }
        else if item.followStatusType == 2 {
//            self.followUserButton.setTitle("Following", for: .normal)
//            self.followUserButton.backgroundColor = UIColor.GREEN_PRIMARY
//            self.followUserButton.layer.borderColor = UIColor.clear.cgColor
//            self.followUserButton.layer.borderWidth = 0
////            self.followUserButton.isEnabled = false
//            self.followUserButton.setTitleColor(UIColor.white, for: .normal)
            self.followUserButton.layer.borderColor = UIColor.clear.cgColor
            self.followUserButton.layer.borderWidth = 0
            self.followUserButton.setImage(UIImage(named: "ic_arrow_down")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.followUserButton.tintColor = .white
            self.followUserButton.setTitleColor(.white, for: .normal)
            self.followUserButton.setTitle("Following", for: .normal)
            self.followUserButton.backgroundColor = UIColor.GREEN_PRIMARY
            self.followUserButton.semanticContentAttribute = .forceRightToLeft
            self.followUserButton.isEnabled = true
        }
        else {
            self.followUserButton.setTitle("Follow", for: .normal)
            self.followUserButton.backgroundColor = UIColor.clear
            self.followUserButton.layer.borderColor = UIColor.black.cgColor
            self.followUserButton.layer.borderWidth = 1.0
            self.followUserButton.semanticContentAttribute = .forceLeftToRight
            self.followUserButton.setImage(UIImage(named: "")?.withRenderingMode(.alwaysTemplate), for: .normal)

//            self.isEnabled = true
//            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
//            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
            self.followUserButton.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
//            self.followUserButton.isEnabled = true
        }
    }
    
    @IBAction func favoutiteBtnTapped(_ sender: UIButton){
        delegate?.favouriteTapped(cell: self)
    }
    
    @IBAction func followUserBtnAction() {
        delegate?.followersBtnTapped(cell: self)
    }
}

