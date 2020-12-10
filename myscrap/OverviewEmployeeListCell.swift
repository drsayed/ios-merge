//
//  OverviewEmployeeListCell.swift
//  myscrap
//
//  Created by MyScrap on 14/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class OverviewEmployeeListCell: UITableViewCell {

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var compDesigLbl: UILabel!
//    @IBOutlet weak var adminBtn: CorneredButton!
//    @IBOutlet weak var adminWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var adminBtn: UIButton! //CorneredButton!
    @IBOutlet weak var reportBtn : UIButton!
    @IBOutlet weak var adminWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reportBtnWidthConstraint : NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
