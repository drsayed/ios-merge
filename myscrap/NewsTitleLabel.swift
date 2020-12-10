//
//  NewsTitleLabel.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
@IBDesignable
class NewsTitleLabel: UILabel {

    @IBInspectable var titleFont: UIFont = Fonts.newsTitleFont {
        didSet{
            setupViews()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.BLACK_ALPHA {
        didSet{
            setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    private func setupViews(){
        text = "NEWS"
        textColor = color
        font = titleFont
    }
}


