//
//  CommudityFooter.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit


final class LiveFriendCell: BaseCell{
    
    @IBOutlet weak var rippleHight: NSLayoutConstraint!
    @IBOutlet weak var vieweToAnimate: UIView!
    @IBOutlet weak var rippleWidth: NSLayoutConstraint!
    @IBOutlet weak var rippleView: UIView!
    @IBOutlet weak var profileViewWidth: NSLayoutConstraint!
    @IBOutlet weak var profileViewhieght: NSLayoutConstraint!
    @IBOutlet weak var greenCircle: UIView!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var colorAnimationView: UIView!
    @IBOutlet weak var openLiveButton: UIButton!
    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
    @IBOutlet weak var onlineView: onlineView!
    override func layoutSubviews() {
    //    colorAnimationView.stopBlink()
        //colorAnimationView.animate()
       
    }
    override func awakeFromNib() {
           super.awakeFromNib()
        profileView.layer.cornerRadius = profileView.frame.size.height/2
       // profileView.image.layer.cornerRadius = profileView.image.frame.size.height/2
        colorAnimationView.layer.cornerRadius =  colorAnimationView.frame.size.height/2
        colorAnimationView.layer.borderWidth = 2
        colorAnimationView.layer.borderColor = UIColor.white.cgColor
        
        vieweToAnimate.layer.cornerRadius =  vieweToAnimate.frame.size.height/2
        vieweToAnimate.layer.borderWidth = 0.5
        vieweToAnimate.layer.borderColor = UIColor.white.cgColor
        colorAnimationView.clipsToBounds = true
        self.profileViewhieght.constant = 50
        self.profileViewWidth.constant = 50
        self.vieweToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)

        self.vieweToAnimate.layer.masksToBounds = true
        vieweToAnimate.isUserInteractionEnabled = true
        colorAnimationView.isUserInteractionEnabled = true
        profileView.image.isUserInteractionEnabled = true

        greenCircle.layer.cornerRadius =  greenCircle.frame.size.height/2
        rippleView.layer.cornerRadius =  rippleView.frame.size.height/2
        greenCircle.clipsToBounds = true
       
        
       }
    override func prepareForReuse() {
        self.profileView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.colorAnimationView.alpha = 1.0
        self.profileViewhieght.constant = 50
        self.profileViewWidth.constant = 50
        self.rippleHight.constant = 50
        self.rippleWidth.constant = 50
      //  self.layoutIfNeeded()
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
       // rippleView.removeAllAnimations()
        self.profileViewhieght.constant = 50
        self.profileViewWidth.constant = 50
        self.rippleHight.constant = 50
        self.rippleWidth.constant = 50
        rippleView.layer.removeAllAnimations()
        vieweToAnimate.layer.removeAllAnimations()
        self.layoutIfNeeded()
        vieweToAnimate.alpha = 1.0
        self.vieweToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.vieweToAnimate.shake(times: 300000000 , direction: ShakeDirection.Horizontal)
        rippleView.addRippleAnimation(color: UIColor.darkGray, duration: 1.5, rippleCount: 3, rippleDistance: nil, startReset: false, handler: { animation in
        })
   //     self.vieweToAnimate.shake(times: 300000000 , direction: ShakeDirection.Horizontal)

//        UIView.animate(withDuration: 0.5, //Time duration you want,
//            delay: 0.0,
//            options: [.curveEaseInOut, .autoreverse, .repeat],
//            animations: {  self.colorAnimationView.alpha = 0.0
//                
//            },
//            completion: { _ in  self.colorAnimationView.alpha = 1.0
//                
//            })
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
