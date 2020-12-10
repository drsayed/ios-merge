//
//  MenuCell.swift
//  myscrap
//
//  Created by MS1 on 12/13/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class MenuCell: BaseTVC{
    
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            contentView.backgroundColor = selected ? UIColor.GREEN_ALPHA : UIColor.white
            menuImageView.tintColor = selected ? UIColor.GREEN_PRIMARY : UIColor.darkGray
            menuLabel.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
        }
    }
    
    var menuItem: MenuItem?{
        didSet{
            guard let menu = menuItem else { return }
            menuLabel.text = menu.menuTitle.rawValue
            if let image = UIImage(named: menu.imageName){
                menuImageView.image = image.withRenderingMode(.alwaysTemplate)
            } else {
                menuImageView.image = nil
            }
            /*if menu.menuTitle == .bump {
                if let bumpCount = NotificationService.instance.bumpCount , bumpCount != 0 , AuthStatus.instance.isLoggedIn{
                    badgeLabel.isHidden = false
                    badgeLabel.text = "\(bumpCount)"
                } else {
                    badgeLabel.isHidden = true
                }
            } else*/ if menu.menuTitle == .visitors{
                if let vistorCount = NotificationService.instance.visitorsCount , vistorCount != 0 , AuthStatus.instance.isLoggedIn {
                    badgeLabel.isHidden = false
                    badgeLabel.text = "\(vistorCount)"
                } else {
                    badgeLabel.isHidden = true
                }
            } else if menu.menuTitle == .report{
                if let moderatorCount = NotificationService.instance.moderatorCount , moderatorCount != 0 , AuthStatus.instance.isLoggedIn {
                    badgeLabel.isHidden = false
                    badgeLabel.text = "\(moderatorCount)"
                } else {
                    badgeLabel.isHidden = true
                }
            }else {
                badgeLabel.isHidden = true
            }
        }
    }
    
    private let menuImageView : UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let menuLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.textColor = UIColor.BLACK_ALPHA
        return lbl
    }()
    
    let badgeLabel: BadgeSwift = {
        let lbl = BadgeSwift()
        lbl.text = "1"
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 13)!
        lbl.badgeColor = UIColor.rgbColor(red: 66, green: 183, blue: 42)
        return lbl
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(menuImageView)
        addSubview(menuLabel)
        addSubview(badgeLabel)
        
        addConstraintWithFormat(format: "H:|-20-[v0(30)]-20-[v1]-8-[v2]-16-|", options: .alignAllCenterY, views: menuImageView,menuLabel, badgeLabel)
        addConstraintWithFormat(format: "V:|-11-[v0(30)]", views: menuImageView)
        contentView.backgroundColor = UIColor.GREEN_ALPHA
    }
    
}
