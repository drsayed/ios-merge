//
//  CompanyRatingCell.swift
//  myscrap
//
//  Created by MyScrap on 6/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import Cosmos

class CompanyRatingCell: UITableViewCell {
    
    @IBOutlet weak var maxRateLbl : UILabel!
    @IBOutlet weak var star : CosmosView!
    @IBOutlet weak var designationLbl : UILabel!
    @IBOutlet weak var verifiedLbl : UILabel!
    @IBOutlet weak var verifiedImg : UIButton!
    @IBOutlet weak var yearsLbl : UILabel!
    @IBOutlet weak var yearsImg : UIButton!
    @IBOutlet weak var affliBtn : CorneredButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        star.text = "(2)"
        star.rating = 5
        
        affliBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        affliBtn.layer.borderWidth = 0.5
        print("Cell : \(self.designationLbl)")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
