//
//  TimeLabel.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit


@IBDesignable
class TimeLabel: UILabel {
    @IBInspectable
    var titleFont: UIFont = Fonts.TIME_FONT! {
        didSet{
            setupViews()
        }
    }
    
    @IBInspectable
    var color: UIColor = UIColor.gray {
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

@IBDesignable
class LandTimeLabel: UILabel {
    @IBInspectable
    var titleFont: UIFont = Fonts.LAND_TIME_FONT! {
        didSet{
            setupViews()
        }
    }
    
    @IBInspectable
    var color: UIColor = UIColor.gray {
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
