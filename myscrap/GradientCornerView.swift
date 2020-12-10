//
//  GradientCornerView.swift
//  myscrap
//
//  Created by MyScrap on 1/14/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

@IBDesignable
class GradientCornerView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
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
