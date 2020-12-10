 //
//  ProfileCell.swift
//  myscrap
//
//  Created by MS1 on 5/23/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
final class ProfileCell: UITableViewCell {
    

    @IBOutlet weak var profileView: ProfileView!

    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var topLbl:UILabel!
    @IBOutlet weak var scoreLbl:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var designationLabel:UILabel!
    @IBOutlet weak var cmpnyLbl:UILabel!
    @IBOutlet weak var interestBtn:UIButton!
    @IBOutlet weak var aboutBtn:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        
        

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
            
            topView.backgroundColor = UIColor.GREEN_PRIMARY
            topLbl.text = "TOP \(profile.rank)"
        }
        
        scoreLbl.textColor = UIColor.gray

        
        if profile.score == ""{
         
            scoreLbl.text = "No Score"
        } else {
            
            scoreLbl.text = "\(profile.score) Score"
        }
        

        print(profile.userId)
        
        
        let name = UserDefaults.standard.value(forKey: "firstname") as! String?
        let lastNm = UserDefaults.standard.value(forKey: "lastname") as! String?
        
        let fullname = "\(name!) \(lastNm!)"
        
        print(UserDefaults.standard.value(forKey: "userid") as! String)
        
        if profile.userId == UserDefaults.standard.value(forKey: "userid") as! String{
            
            nameLabel.text = fullname
        } else {
            
            nameLabel.text = profile.name
        }
        
        
        if profile.userId == UserDefaults.standard.value(forKey: "userid") as! String{
            
            
            profileView.updateViews(name: fullname, url: profile.profilePic, colorCode: profile.colorCode)
            
        } else {
            
            profileView.updateViews(name: profile.name, url: profile.profilePic, colorCode: profile.colorCode)
            
            
            print(profile.profilePic)
            
        }
        

        
        
        designationLabel.text = profile.designation


        

        cmpnyLbl.text = profile.company
 
        
   
    }
    
    
    


}
