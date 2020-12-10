//
//  ActiveUsersCell.swift
//  myscrap
//
//  Created by MyScrap on 4/25/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class ActiveUsersCell: BaseTableCell {
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var onlineView: CircleView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
