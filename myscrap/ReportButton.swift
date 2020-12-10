//
//  ReportButton.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

@IBDesignable
class ReportButton: UIButton {

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
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //withRenderingMode(.alwaysTemplate)withRenderingMode(.alwaysTemplate)
        setImage(#imageLiteral(resourceName: "report_72x72"), for: .normal)
        tintColor = UIColor.BLACK_ALPHA
    }
}

@IBDesignable
class ReportImgV2Button: UIButton {
    
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
     //   contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        setImage(#imageLiteral(resourceName: "report_72x72"), for: .normal)
        tintColor = UIColor.BLACK_ALPHA
    }
}
