//
//  CommudityFooter.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit


final class LiveFriendCell: BaseCell{
    
    @IBOutlet weak var greenCircle: UIView!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var colorAnimationView: UIView!
    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
    @IBOutlet weak var onlineView: onlineView!
    override func layoutSubviews() {
    //    colorAnimationView.stopBlink()
        //colorAnimationView.animate()
       
    }
    override func awakeFromNib() {
           super.awakeFromNib()
        colorAnimationView.layer.cornerRadius =  colorAnimationView.frame.size.height/2
        colorAnimationView.clipsToBounds = true
        self.profileView.shake(times: 300000000 , direction: ShakeDirection.Horizontal)

//        colorAnimationView.stopBlink()
//        colorAnimationView.animate()
        greenCircle.layer.cornerRadius =  greenCircle.frame.size.height/2
        greenCircle.clipsToBounds = true
       }
    func configCell(item: ActiveUsers){
        profileView.updateViews(name: item.name!, url: item.profilePic!, colorCode: item.colorCode!)
        profileTypeView.isHidden = false
        profileTypeView.label.text = "LIVE"
        let gradientLayer:CAGradientLayer = CAGradientLayer()
           gradientLayer.frame.size = profileTypeView.frame.size
           gradientLayer.colors =
            [UIColor(red: 0.25, green: 0.69, blue: 0.16, alpha: 1.00).cgColor , UIColor.MyScrapGreen.cgColor]
           //Use diffrent colors
    profileTypeView.layer.insertSublayer(gradientLayer, at: 0)
    //  rofileTypeView.backgroundColor =  UIColor.MyScrapGreen
//
//        if item.moderator == "1" {
//            profileTypeView.isHidden = false
//            profileTypeView.label.text = "LIVE"
//            profileTypeView.backgroundColor = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
//        } else {
//            profileTypeView.isHidden = true
//            profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:false, rank:item.rank,isLevel: item.isLevel!, level: item.level!)
//        }
        //profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank)
        onlineView.isHidden = true //!item.online
    }
    func configFeedHeaderCell(item: ActiveUsers) {
        
        profileView.updateViews(name: item.name!, url: item.profilePic!, colorCode: item.colorCode!)
//        if item.moderator == "1" {
//            profileTypeView.isHidden = false
//            profileTypeView.label.text = "MOD"
//            profileTypeView.backgroundColor = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
//        } else {
//            profileTypeView.isHidden = false
//            profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:item.newJoined, rank:item.rank,isLevel: item.isLevel!, level: item.level!)
//        }
        profileTypeView.label.text = "LIVE"
        let gradientLayer:CAGradientLayer = CAGradientLayer()
           gradientLayer.frame.size = profileTypeView.frame.size
           gradientLayer.colors =
            [UIColor(red: 0.25, green: 0.69, blue: 0.16, alpha: 1.00).cgColor , UIColor.MyScrapGreen.cgColor]
           //Use diffrent colors
        profileTypeView.layer.insertSublayer(gradientLayer, at: 0)        /*if item.newJoined == true {
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
        onlineView.isHidden = true // !item.online
//        colorAnimationView.stopBlink()
//        colorAnimationView.animate()
    }
    func addAnimation()  {
       // colorAnimationView.layer.removeAllAnimations()
        colorAnimationView.alpha = 1.0
        UIView.animate(withDuration: 0.5, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: {  self.colorAnimationView.alpha = 0.0
                
            },
            completion: { _ in  self.colorAnimationView.alpha = 1.0
                
            })
    }
}
extension UIView {
    func fadeOut() {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.5, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [self] in self.alpha = 0.0
                
            },
            completion: { [ self] _ in self.alpha = 1.0
                
            })
    }
}
