//
//  OnlineViewerCell.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit


final class OnlineViewerCell: BaseCell{
    
    @IBOutlet weak var profileView: ProfileView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var titleCountry: UILabel!

    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
  
    override func layoutSubviews() {
      
    }
    override func awakeFromNib() {
           super.awakeFromNib()

       }
    func configCell(item: [String:AnyObject]){
        
        let name =    item["name"]! as! String
        let profilePic =    item["likeProfilePic"]! as! String
        let colorCode =  item["colorCode"]! as! String
        let userId =  item["userId"]! as! String
        let designation =  item["designation"]! as! String
        let country =  item["country"]! as! String
        profileView.updateViews(name:name , url: profilePic, colorCode:colorCode)
        self.name.text =  "\(name)"
        if designation.length > 0 && country.length > 0  {
            self.titleCountry.text =  "\(designation)" + " • " + "\(country)"
        }
        else if designation.length > 0 && country.length == 0
        {
            self.titleCountry.text =  "\(designation)"
        }
        else
        {
            self.titleCountry.text =  "\(country)"
        }
      
         }
  
}

