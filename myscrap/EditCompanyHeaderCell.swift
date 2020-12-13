//
//  EditCompanyHeaderCell.swift
//  myscrap
//
//  Created by MyScrap on 16/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class EditCompanyHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var label:UILabel!
    
    @IBOutlet weak var downArrowButton:UIButton!
    
    @IBOutlet weak var topSeparatorLabel : UILabel!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        label.textColor = UIColor.darkGray
        //label.font = Fonts.descriptionFont
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        
        topSeparatorLabel.backgroundColor = UIColor.lightGray

    }
    
}
