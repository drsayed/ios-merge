//
//  SeperatorView.swift
//  myscrap
//
//  Created by MS1 on 7/20/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
@IBDesignable
final class SeperatorView: UIView {
    
    @IBInspectable
    var seperatorColor: UIColor = UIColor.seperatorColor {
        didSet{
            configure()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    private func configure(){
        self.backgroundColor = seperatorColor
    }
    
    private func setupViews(){
        self.backgroundColor = seperatorColor
    }
}





