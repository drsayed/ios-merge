//
//  LikeCountCell.swift
//  myscrap
//
//  Created by MS1 on 6/21/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

final class LikeCountCell: UITableViewCell {

    @IBOutlet weak var likeImage:UIImageView!
    @IBOutlet weak var likesLabel:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
