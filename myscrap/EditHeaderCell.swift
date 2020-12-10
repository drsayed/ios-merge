//
//  EditHeaderCell.swift
//  myscrap
//
//  Created by MS1 on 2/5/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
import UIKit

class EditHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var label:UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        label.textColor = UIColor.darkGray
        self.backgroundColor = UIColor.BACKGROUND_GRAY
        label.font = Fonts.descriptionFont
        
    }
    
    
}
