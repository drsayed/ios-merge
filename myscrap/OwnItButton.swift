//
//  OwnItButton.swift
//  myscrap
//
//  Created by MS1 on 11/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class OwnItButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 3.0
        clipsToBounds = true
    }
}
