//
//  LiveUserFollowCell.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit


final class LiveUserFollowCell: BaseCell{
    
    @IBOutlet weak var darkBackground: UIView!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var followIndicator: UIButton!
    
    @IBOutlet weak var nameAndMessahe: UILabel!
    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
  
    override func layoutSubviews() {
        self.darkBackground.layer.cornerRadius =  5
        self.darkBackground.clipsToBounds = true
       
    }
    override func awakeFromNib() {
           super.awakeFromNib()

       }
    func configCell(followStatus : Bool , name: String , profilePic: String , colorCode: String ){
        profileView.updateViews(name:name, url: profilePic, colorCode: colorCode)
        if followStatus {
            self.nameAndMessahe.text =  "Following"
            followIndicator.setTitle("", for: .normal)
            followIndicator.setImage( UIImage.fontAwesomeIcon(name: .check, style: .solid, textColor: UIColor.white , size: CGSize(width: 30, height: 30)), for: .normal)
        }
        else
        {
            self.nameAndMessahe.text =  "Follow"
            followIndicator.setTitle("", for: .normal)
            followIndicator.setImage( UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: UIColor.white , size: CGSize(width: 30, height: 30)), for: .normal)
        }
         }
  
}

