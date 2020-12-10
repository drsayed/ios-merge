//
//  DesignationLabel.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class DesignationLabel: UILabel {

    @IBInspectable
    var titleFont: UIFont = Fonts.DESIG_FONT {
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
