//
//  ForexTitleTVCell.swift
//  myscrap
//
//  Created by MyScrap on 17/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class ForexTitleTVCell: BaseTableCell {
    
    @IBOutlet weak var titleLbl: PricesLabel!
    @IBOutlet weak var lastUpdateLbl: PricesLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
