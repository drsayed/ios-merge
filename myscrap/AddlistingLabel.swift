//
//  AddlistingLabel.swift
//  myscrap
//
//  Created by MyScrap on 7/21/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit


class AddlistingLabel: UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        font = UIFont.systemFont(ofSize: 14)
    }
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: inset))
    }
    
}
