//
//  EventGoingView.swift
//  myscrap
//
//  Created by MS1 on 1/20/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class EventGoingView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("EventGoingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
