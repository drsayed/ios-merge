//
//  CorneredView.swift
//  myscrap
//
//  Created by MS1 on 5/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CorneredView: UIView {

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
        
        layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
class EachCorneredView: UIView {
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        roundCorners(corners: [.topLeft, .topRight], radius: 15)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
class LandCorneredView: UIView {
    
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
        
        layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
}
