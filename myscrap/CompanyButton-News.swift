//
//  CompanyButton-News.swift
//  myscrap
//
//  Created by MS1 on 11/1/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

@IBDesignable
class CompanyButton_News: UIButton {
    var companyName: String = "" {
        didSet{
            configTitle()
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
        setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        titleLabel?.font =  Fonts.likeCountFont
    }
    
    private func configTitle(){
       setTitle(string: companyName)
    }
    
    private func setTitle(string: String){
        setTitle(string, for: .normal)
        setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
    }
}
