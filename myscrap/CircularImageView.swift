//
//  CircularImageView.swift
//  myscrap
//
//  Created by MS1 on 5/13/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
class CircularImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    func updateCornerRadius(){
        self.layer.cornerRadius = self.layer.frame.size.height / 2
        self.layer.masksToBounds = true
    }
}
