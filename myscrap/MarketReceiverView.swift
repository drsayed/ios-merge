//
//  MarketReceiverView.swift
//  myscrap
//
//  Created by MyScrap on 8/17/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MarketReceiverView: UIView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.bottomLeft, .bottomRight , .topLeft], radius: 16)
    }
}
