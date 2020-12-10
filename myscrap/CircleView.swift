//
//  CircleView.swift
//  myscrap
//
//  Created by MS1 on 6/12/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit


@IBDesignable class CircleView: UIView {

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
    }

}
