//
//  LandImageViewCRadius.swift
//  myscrap
//
//  Created by MyScrap on 1/14/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

@IBDesignable
class LandImageViewCRadius: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable var cornedRadius: Bool = false{
        didSet{
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius(){
        layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
