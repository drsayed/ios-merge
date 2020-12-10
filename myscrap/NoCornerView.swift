//
//  NoCornerView.swift
//  myscrap
//
//  Created by MS1 on 5/20/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class NoCornerView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: UIColor.SHADOW_GRAY, green: UIColor.SHADOW_GRAY, blue: UIColor.SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

}
