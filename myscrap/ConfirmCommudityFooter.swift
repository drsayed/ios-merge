//
//  ConfirmCommudityFooter.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class ConfirmCommudityFooter: BaseTableCell {

   
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var submitPriceButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
      
        submitPriceButton.layer.cornerRadius = 5
         editButton.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
