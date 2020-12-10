//
//  AdminViewEmployeeTVCell.swift
//  myscrap
//
//  Created by MyScrap on 18/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class AdminViewEmployeeTVCell: UITableViewCell {

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var compDesigLbl: UILabel!
    @IBOutlet weak var adminBtn: CorneredButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
