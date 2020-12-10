//
//  LeftSliderView.swift
//  myscrap
//
//  Created by MS1 on 11/1/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class LeftSliderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews(){
        
    }
}


final class RightSliderView: LeftSliderView{
    
    override func setupViews(){
        
    }
}
