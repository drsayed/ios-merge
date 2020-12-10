//
//  ConfirmCommudityTableHeader.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class ConfirmCommudityTableHeader: BaseTableCell {


    @IBOutlet weak var companyName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.selecctCompanyButton.setImage(self.selecctCompanyButton.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
//            self.selecctCompanyButton.tintColor = UIColor.black
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
