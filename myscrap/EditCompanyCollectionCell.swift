//
//  EditCompanyCollectionCell.swift
//  myscrap
//
//  Created by MyScrap on 16/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class EditCompanyCollectionCell: UICollectionViewCell {
    @IBOutlet weak var label:UILabel!
    @IBOutlet var view: UIView!
    
    
    override func awakeFromNib() {
        
        label.font = Fonts.DESIG_FONT
        label.textColor = UIColor.MyScrapGreen
        view.backgroundColor = UIColor.WHITE_ALPHA
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.MyScrapGreen.cgColor
        view.layer.borderWidth = 1.0
    }
}
