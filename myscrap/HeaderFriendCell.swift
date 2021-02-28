//
//  CommudityFooter.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit


final class HeaderFriendCell: BaseCell{
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
    @IBOutlet weak var onlineView: onlineView!
    
    override func awakeFromNib() {
           super.awakeFromNib()
        profileView.layer.cornerRadius = profileView.frame.size.height/2
       // self.profileView.shake(times: 300000000 , direction: ShakeDirection.Horizontal)

       }
    
    func configCell(item: ActiveUsers){
        profileView.updateViews(name: item.name!, url: item.profilePic!, colorCode: item.colorCode!)
        if item.moderator == "1" {
            profileTypeView.isHidden = false
            profileTypeView.label.text = "MOD"
            profileTypeView.backgroundColor = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
        } else {
            profileTypeView.isHidden = true
            profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:false, rank:item.rank,isLevel: item.isLevel!, level: item.level!)
        }
        //profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank)
        onlineView.isHidden = !item.online
    }
    func configFeedHeaderCell(item: ActiveUsers) {
        
        profileView.updateViews(name: item.name!, url: item.profilePic!, colorCode: item.colorCode!)
        if item.moderator == "1" {
            profileTypeView.isHidden = false
            profileTypeView.label.text = "MOD"
            profileTypeView.backgroundColor = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
        } else {
            profileTypeView.isHidden = false
            profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:item.newJoined, rank:item.rank,isLevel: item.isLevel!, level: item.level!)
        }
        /*if item.newJoined == true {
            print("User name on scroll : \(item.name)")
            profileTypeView.isHidden = false
            profileTypeView.label.text = "NEW"
            profileTypeView.backgroundColor = UIColor.NEW_COLOR
        }
        if item.moderator == "0" && item.newJoined == false {
            profileTypeView.isHidden = true
        }*/
        profileTypeView.translatesAutoresizingMaskIntoConstraints = false
//                profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank)
        onlineView.isHidden = !item.online
    }
}
