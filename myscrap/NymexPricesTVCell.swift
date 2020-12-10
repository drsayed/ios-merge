//
//  ShangaiPricesTVCell.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class NymexPricesTVCell: BaseTableCell {

    @IBOutlet weak var lbl1: PricesLabel!
    @IBOutlet weak var lbl2: PricesLabel!
    @IBOutlet weak var lbl4: PricesLabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet var titleBackground: UIView!
    @IBOutlet var changeIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

