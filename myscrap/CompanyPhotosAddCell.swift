//
//  CompanyPhotosAddCell.swift
//  myscrap
//
//  Created by MyScrap on 16/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import Gallery

class CompanyPhotosAddCell: UICollectionViewCell {
    
    @IBOutlet weak var outerView: CorneredView!
    @IBOutlet weak var companyImageView: UIImageView!
    
    var image: Image? {
        didSet{
            print("company cell image show")
            if let item = image{
                item.resolve { (image) in
                    if let img = image {
                        self.companyImageView.image = img
                    }
                }
            } else {
                companyImageView.image =  #imageLiteral(resourceName: "add-bg")
            }
        }
    }
    
    override func awakeFromNib() {
        outerView.layer.borderWidth = 0.5
        outerView.layer.borderColor = UIColor.darkGray.cgColor
    }
}
