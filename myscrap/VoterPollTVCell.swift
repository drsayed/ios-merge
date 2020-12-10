//
//  VoterPollTVCell.swift
//  myscrap
//
//  Created by MyScrap on 10/10/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import DLRadioButton

class VoterPollTVCell: UITableViewCell {
    
    @IBOutlet weak var voterImageView: UIImageView!
    @IBOutlet weak var voterRadioBtn: DLRadioButton!
    @IBOutlet weak var voterName: UIButton!
    @IBOutlet weak var viewBioBtn: UIButton!
    
    var bioActionBlock : (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code'
        voterRadioBtn.iconSize = 20
        voterRadioBtn.isUserInteractionEnabled = false
        voterName.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func viewBioTapped(_ sender: UIButton) {
        bioActionBlock?()
    }
}
