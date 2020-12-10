//
//  VotingResultTVCell.swift
//  myscrap
//
//  Created by MyScrap on 8/8/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class VotingResultTVCell: BaseTableCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var percentBarView: UIView!
    @IBOutlet weak var percentBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var percentBackBar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
