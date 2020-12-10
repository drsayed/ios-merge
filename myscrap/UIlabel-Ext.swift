//
//  UIlabel-Ext.swift
//  myscrap
//
//  Created by MyScrap on 5/23/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

extension UILabel{
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
}
