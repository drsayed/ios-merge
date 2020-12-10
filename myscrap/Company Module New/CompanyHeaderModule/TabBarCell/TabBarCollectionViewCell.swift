//
//  tabBarCollectionViewCell.swift
//  StickeyHeaderiOS
//
//  Created by Sowndharya M on 06/01/18.
//  Copyright © 2018 Sowndharya M. All rights reserved.
//

import UIKit

let TabBarCollectionViewCellID = "TabBarCollectionViewCell"

class TabBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tabNameLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        /*
         *  To avoid compression of labels, the below code must be present.
         */
        contentView.backgroundColor = UIColor.white
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.tabNameLabel.backgroundColor =  UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
    }
}
