//
//  MyProfileCollectionViewCell.swift
//  myscrap
//
//  Created by myscrap on 24/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

@objc protocol MyProfileCellDelegate: class{
    func DidPressAboutBtn(cell: BaseCell)
    func DidPressWallBtn(cell: BaseCell)
    func DidPressIntrestBtn(cell: BaseCell)
    func DidPressPhotosBtn(cell: BaseCell)
    func DidPressCompanyBtn(cell: BaseCell)

    func DidPressFollowingBtn(cell: BaseCell)
    func DidPressFollowersBtn(cell: BaseCell)
    func DidPressEditProfileBtn(cell: BaseCell)

}
class MyProfileCollectionViewCell: BaseCell {

    weak var delegate: MyProfileCellDelegate?

    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationBtn: UIButton!
    @IBOutlet weak var companyBtn: UIButton!
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var profileSlider: UISlider!
    @IBOutlet weak var reachLevelLabel: UILabel!

    
    //MARK:- setUpViews
    func setUpViews(data: ProfileData) {
        
        //profileTypeView
        self.profileTypeView.label.font = UIFont(name: "HelveticaNeue", size: 12)
        
        //designationBtn
        self.designationBtn.setImage(UIImage(named: "ic_Position"), for: .normal)
        self.designationBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 13)
        self.designationBtn.isUserInteractionEnabled = false
        self.designationBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        if data.designation != "" {
            self.designationBtn.isHidden = false
            self.designationBtn.setTitle(data.designation, for: .normal)
        }
        else {
            self.designationBtn.isHidden = true
        }
        self.designationBtn.titleLabel?.lineBreakMode = .byTruncatingTail

        //companyBtn
        self.companyBtn.setImage(UIImage(named: "ic_Company"), for: .normal)
        self.companyBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 13)
        self.companyBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        if data.company != "" {
            self.designationBtn.isHidden = false
            self.companyBtn.setTitle(data.company, for: .normal)
        }
        else {
            self.companyBtn.isHidden = true
        }
//        self.companyBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.companyBtn.titleLabel?.lineBreakMode = .byTruncatingTail

        
        //---->>>>Right Content View
        //followingButton
        var followingStr = "Following"
        if data.followingCount == 1 {
            followingStr = "Following"
        }

        self.followingButton.setAttributedTitle(self.setAttributedTextForButton(firstStr: String(data.followingCount), secondStr: followingStr), for: .normal)
        self.followingButton.titleLabel?.numberOfLines = 0
        
        var followerStr = "Followers"
        if data.followersCount == 1 {
            followerStr = "Follower"
        }

        //followersButton
        self.followersButton.setAttributedTitle(self.setAttributedTextForButton(firstStr: String(data.followersCount), secondStr: followerStr), for: .normal)
        self.followersButton.titleLabel?.numberOfLines = 0

        //editProfileButton
        self.editProfileButton.layer.cornerRadius = 5
        self.editProfileButton.layer.masksToBounds = true
        
        //levelLabel
        var levelCount = "0"
        if data.level != "" {
            levelCount = data.level
        }
        self.levelLabel.text = "Level " + levelCount
                
        
        var nextLevelTotalPointsStr = "0"
        if data.levelNextTotalPoint != "" {
            nextLevelTotalPointsStr = data.levelNextTotalPoint
        }
        self.scoreLbl.text = String(format: "%d/%@",  data.currentTotalPoints, nextLevelTotalPointsStr)
        
        profileSlider?.setValue(Float(data.currentTotalPoints), animated: true)

        var pointsNeededStr = "0"
        if data.pointsNeed != "" {
            pointsNeededStr = data.pointsNeed
        }
        var nextLevelStr = "0"
        if data.nextLevel != "" {
            nextLevelStr = data.nextLevel
        }

        self.reachLevelLabel.text = String(format: "Get %@ points to reach Level %@", pointsNeededStr, nextLevelStr)
    }
    
    func configCell(item: ProfileData){
        
        self.setUpViews(data: item)
        
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
        
        AuthService.instance.colorCode = item.colorCode
        profileTypeView.checkType = ProfileTypeScore(isAdmin: false, isMod: item.moderator, isNew: item.newJoined, rank: item.rank, isLevel: item.isLevel, level: item.level)
//        scoreLbl.text = "0 / 200" //"\(item.score) Score"
        nameLbl.text = item.name

        /*
        designationLbl.text = item.designation
        if item.profilePercentage == 100 || item.profilePercentage == 0 {
            sliderView?.isHidden = true
            profileCompleteLbl?.isHidden = true
        } else {
            sliderView?.isHidden = false
            profileCompleteLbl?.isHidden = false
            profileSlider?.setValue(Float(item.profilePercentage), animated: true)
            profileCompleteLbl?.text = "\(item.profilePercentage)% profile completeness."
        } */
        
    }
    
    //Attributed text for Button
    func setAttributedTextForButton(firstStr : String, secondStr : String) -> NSMutableAttributedString {
     
        //assigning diffrent fonts to both substrings
        let font1 = UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
        let font2 = UIFont(name: "HelveticaNeue", size: 14.0)!

        let fontColor = UIColor.black
        
        let alignment = NSMutableParagraphStyle()
        alignment.alignment = NSTextAlignment.center
        alignment.lineBreakMode = .byWordWrapping
        
        let attr1 = NSAttributedString(string: firstStr, attributes: [NSAttributedString.Key.font: font1, NSAttributedString.Key.foregroundColor : fontColor, NSAttributedString.Key.paragraphStyle : alignment])
        
        let secondString = String(format: "\n%@", secondStr)
        let attr2 = NSAttributedString(string: secondString, attributes: [NSAttributedString.Key.font : font2, NSAttributedString.Key.foregroundColor : fontColor])

        let mutableAttr = NSMutableAttributedString(attributedString: attr1)
        mutableAttr.append(attr2)
        return mutableAttr

    }
    
    @IBAction func photosBtnPressed(_ sender: UIButton) {
        delegate?.DidPressPhotosBtn(cell: self)
    }
    @IBAction func wallBtnPressed(_ sender: UIButton){
        delegate?.DidPressWallBtn(cell: self)
    }
    
    @IBAction func interestBtnPressed(_ sender: UIButton){
        delegate?.DidPressIntrestBtn(cell: self)
    }
    
    @IBAction func aboutBtnPressed(_ sender: UIButton){
        delegate?.DidPressAboutBtn(cell: self)
    }
    
    @IBAction func editBtnAction() {
        delegate?.DidPressEditProfileBtn(cell: self)
    }
    
    @IBAction func followingBtnAction() {
        delegate?.DidPressFollowingBtn(cell: self)
    }
    
    @IBAction func follwersBtnAction() {
        delegate?.DidPressFollowersBtn(cell: self)
    }
    
    @IBAction func companyBtnAction() {
        delegate?.DidPressCompanyBtn(cell: self)
    }
}
