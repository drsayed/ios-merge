//
//  ReceiverCell.swift
//  myscrap
//
//  Created by MS1 on 5/28/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit



final class ReceiverView: UIView{
    @IBOutlet weak var profileImage: CircularImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.topLeft, .topRight, .bottomRight, .bottomLeft], radius: 15)
        
    }
}
