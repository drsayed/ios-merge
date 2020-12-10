//
//  PricesLabel.swift
//  myscrap
//
//  Created by MS1 on 11/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
class PricesLabel: UILabel{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupviews()
    }
    
    private func setupviews(){
        textColor = UIColor.BLACK_ALPHA
        font = UIFont(name: "HelveticaNeue", size: 13)!
    }
    
}
