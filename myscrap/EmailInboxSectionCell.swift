//
//  EmailInboxSectionCell.swift
//  myscrap
//
//  Created by MyScrap on 2/4/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class EmailInboxSectionCell: UITableViewCell {

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var openImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
