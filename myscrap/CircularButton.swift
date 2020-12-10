//
//  CircularButton.swift
//  myscrap
//
//  Created by MS1 on 5/13/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CircularButton: UIButton {

    override func awakeFromNib() {
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
        
    }
    

}
