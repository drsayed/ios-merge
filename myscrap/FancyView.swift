//
//  FancyView.swift
//  myscrap
//
//  Created by MS1 on 5/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class FancyView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    
    func setupView() {

        layer.shadowColor = UIColor(red: UIColor.SHADOW_GRAY, green: UIColor.SHADOW_GRAY, blue: UIColor.SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
}
