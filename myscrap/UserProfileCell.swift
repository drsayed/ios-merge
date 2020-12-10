//
//  UserProfileCell.swift
//  myscrap
//
//  Created by MS1 on 11/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

@objc
protocol ProfileCellDelegate: class{
    func DidPressCompanyBtn(cell: BaseCell)
    func DidPressIntrestBtn(cell: BaseCell)
    func DidPressAboutBtn(cell: BaseCell)
    func DidPressPhotosBtn(cell: BaseCell)
    @objc optional func DidPressCall(cell: BaseCell,sender:UIButton)
    func DidPressChat(cell: BaseCell)
    func DidPressEmail(cell: BaseCell)
    func DidPressFavourite(cell: BaseCell)
    @objc optional func DidPressLike()
}

class UserProfileCell: BaseCell {
    
    weak var delegate: ProfileCellDelegate?
    
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var companyBtn: UIButton!
    
    @IBOutlet weak var sliderView: UIView?
    @IBOutlet weak var profileSlider: UISlider?
    @IBOutlet weak var profileCompleteLbl: UILabel?
    
    
    
    
    
    func configCell(item: ProfileData){
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
        AuthService.instance.colorCode = item.colorCode
        profileTypeView.checkType = ProfileTypeScore(isAdmin: false, isMod: item.moderator, isNew: item.newJoined, rank: item.rank, isLevel: item.isLevel, level: item.level)
        scoreLbl.text = "\(item.score) Score"
        nameLbl.text = item.name
        designationLbl.text = item.designation
        companyBtn.setTitle(item.company, for: .normal)
        if item.profilePercentage == 100 || item.profilePercentage == 0 {
            sliderView?.isHidden = true
            profileCompleteLbl?.isHidden = true
        } else {
            sliderView?.isHidden = false
            profileCompleteLbl?.isHidden = false
            profileSlider?.setValue(Float(item.profilePercentage), animated: true)
            profileCompleteLbl?.text = "\(item.profilePercentage)% profile completeness."
        }
        
    }
    
    @IBAction func photosBtnPressed(_ sender: UIButton) {
        delegate?.DidPressPhotosBtn(cell: self)
    }
    @IBAction func companyBtnPressed(_ sender: UIButton){
        delegate?.DidPressCompanyBtn(cell: self)
    }
    
    @IBAction func interestBtnPressed(_ sender: UIButton){
        delegate?.DidPressIntrestBtn(cell: self)
    }
    
    @IBAction func aboutBtnPressed(_ sender: UIButton){
        delegate?.DidPressAboutBtn(cell: self)
    }
}




