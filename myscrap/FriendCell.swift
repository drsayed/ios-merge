//
//  FriendCell.swift
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//


/*
import UIKit

final class FriendCell: UITableViewCell {
    
    
    @IBOutlet weak var profileView:ProfileView!

    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var topLbl:UILabel!
    @IBOutlet weak var scoreLbl:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var designationLabel:UILabel!
    @IBOutlet weak var cmpnyLbl:UILabel!

    @IBOutlet weak var interestBtn:UIButton!
    @IBOutlet weak var aboutBtn:UIButton!
    @IBOutlet weak var chatBtn:UIButton!
    
    @IBOutlet weak var favouriteBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        

        
        
// MARK :- SCORELABEL UI
    
    scoreLbl.textColor = UIColor.gray
    scoreLbl.font = Fonts.DESIG_FONT
    
// MARK:- NAME LABEL UI
    nameLabel.textColor = Colors.BLACK_ALPHA
    nameLabel.font = Fonts.NAME_FONT

// MARK:- DESIGNATION LABEL UI
        
    designationLabel.textColor = Colors.BLACK_ALPHA
    designationLabel.font = Fonts.DESIG_FONT
    
// MARK:- COMPANY LABEL UI
        
    cmpnyLbl.font = UIFont(name: "HelveticaNeue", size: 13)
    cmpnyLbl.textColor = Colors.GREEN_PRIMARY
        
        
// MARK:- INTEREST ABOUT BUTTON UI
        
    interestBtn.setTitleColor(Colors.BLACK_ALPHA, for: .normal)
    aboutBtn.setTitleColor(Colors.BLACK_ALPHA, for: .normal)

// MARK:- CHAT BUTTON UI
        
    chatBtn.backgroundColor = Colors.GREEN_PRIMARY
    chatBtn.setTitleColor(UIColor.white.withAlphaComponent(0.95), for: .normal)
    chatBtn.titleLabel?.font = Fonts.DESIG_FONT



    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configCell(profile: ProfileData){
        
        
        
        if Int(profile.rank)! > 10 {
            
            topLbl.isHidden = true
            topView.isHidden = true
            
        } else{
            
            topView.isHidden = false
            topLbl.isHidden = false
            
            topView.backgroundColor = Colors.GREEN_PRIMARY
            topLbl.text = "Top \(profile.rank)"
        }   
        

        
        if profile.score == ""{
            
            scoreLbl.text = "No Score"
        } else {
            
            scoreLbl.text = "\(profile.score) Score"
        }
        
        
        nameLabel.text = profile.name
        designationLabel.text = profile.designation
        cmpnyLbl.text = profile.company
       
        
        profileView.updateViews(name: profile.name, url: profile.profilePic, colorCode: profile.colorCode)
        
        
        
        
        let favImg = #imageLiteral(resourceName: "fav").withRenderingMode(.alwaysTemplate)
        let fav = #imageLiteral(resourceName: "fav1").withRenderingMode(.alwaysTemplate)
        
        print("modaaa")
        print(profile.userId)
        print(profile.friendStatus)
        
        
        if profile.friendStatus == 3{
            
            
            favouriteBtn.tintColor = Colors.GREEN_PRIMARY
            favouriteBtn.setImage(favImg, for: .normal)
            
        } else {
            favouriteBtn.tintColor = Colors.BLACK_ALPHA
            favouriteBtn.setImage(fav, for: .normal)
        }

    }


}
*/
