//
//  CompanyProfileCell.swift
//  myscrap
//
//  Created by MS1 on 11/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CompanyProfileCell: BaseCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var companyTypeLbl : UILabel!
    @IBOutlet weak var likeBtn: OwnItButton!
    @IBOutlet weak var ownItBtn: OwnItButton!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var interestBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    weak var delegate: ProfileCellDelegate?
    
    var companyProfile: CompanyProfileItem? {
        didSet{
            guard let item = companyProfile else { return }
            configCell(item: item)
        }
    }
    
    
    private func configCell(item: CompanyProfileItem){
        
        if item.companyImage == "" || item.companyImage == "https://myscrap.com/" {
            imageView.image = #imageLiteral(resourceName: "company")
        } else {
            imageView.setImageWithIndicator(imageURL: item.companyImage ?? "")
        }
        
        
        
        let title = item.isFollowing ? "Liked" : "Like"
        likeBtn.setTitle(title, for: .normal)
        titleLbl.text = item.companyName
        companyTypeLbl.text = item.companyType
        if !item.isEmployee{
            ownItBtn.isHidden = true
        } else {
            if item.ownerUserId == "0" {
                ownItBtn.isHidden = false
                ownItBtn.setTitle("Own It", for: .normal)
            } else if item.ownerUserId == AuthService.instance.userId {
                ownItBtn.isHidden = false
                ownItBtn.setTitle("Disown", for: .normal)
            } else{
                ownItBtn.isHidden = true
            }
        }
        
        let favImg = #imageLiteral(resourceName: "fav").withRenderingMode(.alwaysTemplate)
        let fav = #imageLiteral(resourceName: "fav1").withRenderingMode(.alwaysTemplate)
        
        if item.isFavourite {
            favBtn.setImage(favImg, for: .normal)
            favBtn.tintColor = UIColor.GREEN_PRIMARY
        } else {
            favBtn.setImage(fav, for: .normal)
            favBtn.tintColor = UIColor.BLACK_ALPHA
        }
    }
    
    @IBAction private func photosBtnPressed(_ sender: UIButton){
        delegate?.DidPressPhotosBtn(cell: self)
    }
    
    @IBAction private func aboutBtnPressed(_ sender: UIButton){
        delegate?.DidPressAboutBtn(cell: self)
    }
    
    @IBAction private func intrestBtnPressed(_ sender: UIButton){
        delegate?.DidPressIntrestBtn(cell: self)
    }
    @IBAction func favBtnPressed(_ sender: Any) {
        delegate?.DidPressFavourite(cell: self)
    }
    @IBAction func likeBtnPressed(_ sender: UIButton){
        delegate?.DidPressLike?()
    }
    
}

