//
//  MarketReceiverCell.swift
//  myscrap
//
//  Created by MyScrap on 8/17/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MarketReceiverCell: BaseCell {
    @IBOutlet weak var receiverView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var marketImageView: UIImageView!
    @IBOutlet weak var marketTypeLbl: UILabel!
    @IBOutlet weak var marketTitleLbl: UILabel!
    @IBOutlet weak var receivedTimeLbl: UILabel!
    
    override func awakeFromNib() {
        receiverView.layer.cornerRadius = 5
        receiverView.layer.masksToBounds = true
        
        innerView.layer.cornerRadius = 2
        innerView.clipsToBounds = true
        
        receivedTimeLbl.text = ""
        
    }
    
}
