//
//  EditCollectionCell.swift
//  myscrap
//
//  Created by MS1 on 2/5/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
final class EditCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var label:UILabel!
    @IBOutlet var view: UIView!
    
    
    override func awakeFromNib() {
        
        label.font = Fonts.DESIG_FONT
        label.textColor = UIColor.BLACK_ALPHA
        view.backgroundColor = UIColor.WHITE_ALPHA
        view.layer.cornerRadius = 2.0
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1.0
    }
    
}
