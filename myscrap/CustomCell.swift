//
//  CustomCell.swift
//  myscrap
//
//  Created by MyScrap on 12/30/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class CustomCell: BaseCell {
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var customLbl: UILabel!
    
    override func awakeFromNib() {
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 15
    }
}

class TopAlertCell: BaseCell {
    @IBOutlet weak var customLbl: UILabel!
    
    override func awakeFromNib() {
        
    }
}
