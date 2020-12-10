//
//  CommodityButton.swift
//  myscrap
//
//  Created by MS1 on 5/22/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CommodityButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        
//        self.layer.cornerRadius = 1
//        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 2.0
//        
//        self.layer.masksToBounds = true
        
        self.titleLabel!.numberOfLines = 1
        self.titleLabel!.minimumScaleFactor = 0.01
        self.titleLabel!.adjustsFontSizeToFitWidth = true
        self.titleLabel!.lineBreakMode = NSLineBreakMode.byClipping
    }
    

}
