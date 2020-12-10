//
//  CompanyCell.swift
//  myscrap
//
//  Created by MS1 on 10/21/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CompanyCell: BaseCell {
    
    var item: CompanyItem? {
        
        didSet{
            guard let company = item else { return }
            nameLbl.text = company.name
            typeLbl.text = company.category
            countryLbl.text = company.country
            imageView.setImageWithIndicator(imageURL: company.image)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLbl.font = Fonts.NAME_FONT
        nameLbl.textColor = UIColor.BLACK_ALPHA
        countryLbl.font = Fonts.DESIG_FONT
        countryLbl.textColor = UIColor.BLACK_ALPHA
        typeLbl.font = Fonts.DESIG_FONT
        typeLbl.textColor = UIColor.BLACK_ALPHA
        nameLbl.numberOfLines = 2
        
        imageView.contentMode = .scaleAspectFill
    }

}
