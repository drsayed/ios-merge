//
//  EditButton.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class EditButton: UIButton {
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
        setImage(#imageLiteral(resourceName: "ellipsis2").withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = UIColor.BLACK_ALPHA
    }
}

class ShareButton: UIButton {
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
        setImage(#imageLiteral(resourceName: "invite_friends").withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = UIColor.BLACK_ALPHA
    }
}
