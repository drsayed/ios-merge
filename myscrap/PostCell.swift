//
//  PostCell.swift
//  myscrap
//
//  Created by MS1 on 5/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit


final class PostCell: UITableViewCell {

    @IBOutlet weak var profileImag:CircularImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImag.setImageWithIndicator(imageURL: AuthService.instance.profilePic)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
