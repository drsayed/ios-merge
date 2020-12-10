//
//  ForexPricesTVCell.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class ForexPricesTVCell: BaseTableCell {

    @IBOutlet weak var lbl1: PricesLabel!
    @IBOutlet weak var lbl2: PricesLabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
