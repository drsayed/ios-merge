//
//  CorneredButton.swift
//  myscrap
//
//  Created by MS1 on 5/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CorneredButton: UIButton {

    
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

class CorneredSlightButton: UIButton {
    
    
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
        
        layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    
    
}

class FbCorneredView: UIView {
    
    
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


