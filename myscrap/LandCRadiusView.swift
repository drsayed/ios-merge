//
//  LandCRadiusView.swift
//  myscrap
//
//  Created by MyScrap on 1/12/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

class LandCRadiusView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius(radius: radius)
    }
    
    @IBInspectable var cornedRadius: Bool = false{
        didSet{
            updateCornerRadius(radius: radius)
        }
    }
    
    @IBInspectable var radius: CGFloat = 0.0{
        didSet{
            updateCornerRadius(radius: radius)
        }
    }
    
    func updateCornerRadius(radius:CGFloat){
        layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
}
