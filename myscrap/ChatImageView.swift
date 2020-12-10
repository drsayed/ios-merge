//
//  ChatImageView.swift
//  myscrap
//
//  Created by MS1 on 11/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ChatImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
    func setupViews(){
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        backgroundColor = UIColor.IMAGE_BG_COLOR
        contentMode = .scaleAspectFill
    }
    
}
