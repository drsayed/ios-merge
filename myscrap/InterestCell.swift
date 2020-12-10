//
//  InterestCell.swift
//  myscrap
//
//  Created by MS1 on 1/16/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class InterestCell: BaseCell {

    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.textColor = UIColor.white.withAlphaComponent(0.95)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive  = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive  = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10.0
        self.layer.backgroundColor = UIColor.GREEN_PRIMARY.cgColor
    }
}

