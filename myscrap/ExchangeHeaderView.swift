//
//  ExchangeHeaderView.swift
//  myscrap
//
//  Created by MS1 on 10/9/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ExchangeHeaderView: UITableViewCell {
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configHeader(first: String, second: String , third: String, fourth: String){
        lbl1.text = first
        lbl2.text = second
        lbl3.text = third
        lbl4.text = fourth
    }
    
}
