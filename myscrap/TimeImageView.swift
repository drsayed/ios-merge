//
//  TimeImageView.swift
//  myscrap
//
//  Created by MS1 on 11/2/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class TimeImageView: UIImageView {
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
        image = #imageLiteral(resourceName: "ic_access_time_black_48dp").withRenderingMode(.alwaysTemplate)
        tintColor = UIColor.BLACK_ALPHA
    }
}
