//
//  ExchangeCell.swift
//  myscrap
//
//  Created by MS1 on 10/9/17.
//  Copyright © 2017 sayedmetal. All rights reserved.
//

import UIKit
final class PricesCell: UITableViewCell{
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        lbl1.textColor = BLACK_ALPHA
        lbl2.textColor = BLACK_ALPHA
        lbl3.textColor = BLACK_ALPHA
        lbl4.textColor = BLACK_ALPHA
        lbl1.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        lbl2.font = UIFont(name: "HelveticaNeue", size: 12)
        lbl3.font = UIFont(name: "HelveticaNeue", size: 12)
        lbl4.font = UIFont(name: "HelveticaNeue", size: 12)
    }
    /*
    func configCell(exchange: ExchangeItem){
        lbl1.text = exchange.type
        lbl2.text = exchange.contract
        print("modaaa \(exchange.last)")
        lbl3.text = exchange.last
        if exchange.symbol == .minus{
            self.lbl4.textColor = UIColor.red
            self.lbl4.text = "\(exchange.change)⬇︎"
        } else if exchange.symbol == .plus{
            self.lbl4.textColor = GREEN_PRIMARY
            self.lbl4.text = "\(exchange.change)⬆︎"
        } else {
            self.lbl4.textColor = BLACK_ALPHA
            self.lbl4.text = "-"
        }
    } */
}
