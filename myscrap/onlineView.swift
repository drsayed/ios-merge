//
//  onlineView.swift
//  myscrap
//
//  Created by Mac on 7/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class onlineView: UIView {
    let greenView = CircleView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.layer.frame.width / 2
        
        greenView.frame = CGRect(x: 2, y: 2, width: self.frame.width - 4, height: self.frame.height - 4)
        
        greenView.backgroundColor = UIColor.init(hexString: "#FF42B72A")
        
        self.addSubview(greenView)
  
    }

}
