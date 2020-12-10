//
//  ReportedView.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ReportedView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    private func setupViews(){
       // self.alpha = 0.08
    }
    
}
