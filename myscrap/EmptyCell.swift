//
//  EmptyCell.swift
//  myscrap
//
//  Created by MS1 on 6/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

final class EmptyCell: UITableViewCell {
    
    @IBOutlet weak var emptyImg:UIImageView!
    @IBOutlet weak var emptyLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        emptyLabel.font = Fonts.NAME_FONT
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
}
