//
//  NewsSubHeadingLabel.swift
//  myscrap
//
//  Created by MS1 on 11/1/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

import UIKit

@IBDesignable
class NewsSubHeadingLabel: UILabel {
    
    @IBInspectable
    var titleFont: UIFont = Fonts.newsSubHeadingFont {
        didSet{
            setupViews()
        }
    }
    
    @IBInspectable
    var color: UIColor = UIColor.BLACK_ALPHA {
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
        textColor = color
        font = titleFont
    }
    
}
