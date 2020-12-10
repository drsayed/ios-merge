//
//  ShareImageButton.swift
//  myscrap
//
//  Created by MyScrap on 9/15/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

@IBDesignable
class ShareImageButton: UIButton {
    
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
        setImage(#imageLiteral(resourceName: "share24"), for: .normal)
        tintColor = UIColor.BLACK_ALPHA
    }
    
}
@IBDesignable
class ShareImageV2Button: UIButton {
    
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
        setImage(#imageLiteral(resourceName: "share_72x72"), for: .normal)
        tintColor = UIColor.BLACK_ALPHA
    }
    
}
