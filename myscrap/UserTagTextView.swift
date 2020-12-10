//
//  UserTagTextView.swift
//  myscrap
//
//  Created by MS1 on 12/5/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class UserTagTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY]
        self.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        self.backgroundColor = UIColor.white
    }
    
}

