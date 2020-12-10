//
//  ViewMailSectionCell.swift
//  myscrap
//
//  Created by MyScrap on 2/7/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class ViewMailSectionCell: UICollectionViewCell {
    
    @IBOutlet weak var circleView: ProfileView!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        circleView.backgroundColor = UIColor.MyScrapGreen
    }
    
    
    
}
