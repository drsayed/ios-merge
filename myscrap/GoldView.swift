//
//  GoldView.swift
//  myscrap
//
//  Created by MS1 on 7/4/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

@IBDesignable class GoldView: UIView {

        override func layoutSubviews() {
            super.layoutSubviews()
            updateCornerRadius()
        }
        
        @IBInspectable var rounded: Bool = false{
            didSet{
                updateCornerRadius()
            }
        }
    
        func updateCornerRadius(){
            layer.cornerRadius = layer.frame.height / 2
            self.clipsToBounds = true
            self.layer.borderWidth = 3.0
            self.layer.borderColor = UIColor.init(hexString: "#FFB300").cgColor
            self.layer.backgroundColor = UIColor.init(hexString: "#FFC107").cgColor
        }
}
