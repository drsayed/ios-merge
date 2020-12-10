//
//  NameLabel.swift
//  myscrap
//
//  Created by MS1 on 7/20/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class NameLabel: UILabel {

    override func awakeFromNib() {
        
        
        self.font = Fonts.NAME_FONT
        self.textColor = UIColor.BLACK_ALPHA
        self.adjustsFontSizeToFitWidth = true
        
        
    }

}


class TimeLable: UILabel{
    
    override func awakeFromNib() {
        
        self.font = Fonts.TIME_FONT
        self.textColor = UIColor.TIME_COLOR
        
    }
    
}


class InitialLabel: UILabel {
    
    override func awakeFromNib(){
        self.text = ""
        self.textColor = UIColor.WHITE_ALPHA
        self.font = Fonts.DESIG_FONT
        self.textAlignment = NSTextAlignment.center
        
    }
    
}

class RankView:CircleView{
    
    
   
    
}

class RankLabel: UILabel{
    
    
}
class placeholderLabel: UILabel{
    
    override func awakeFromNib() {
        
        setupViews()
    }
    
    func setupViews(){
    
        
        self.textColor = UIColor.gray
    
    }
    
}





