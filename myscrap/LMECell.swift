//
//  LMECell.swift
//  myscrap
//
//  Created by MS1 on 11/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import AnimatedBlurLabel

class LMECell: BaseTableCell {
    
    @IBOutlet weak var lbl1: PricesLabel!
    @IBOutlet weak var lbl2: PricesLabel!
    @IBOutlet weak var lbl3: PricesLabel!
    @IBOutlet weak var lbl4: PricesLabel!
    
    func configCell(item: LMEItem?){
        guard let unwrappedItem = item else { return }
        lbl1.text = " \(unwrappedItem.title)"
        lbl2.text = unwrappedItem.month
        lbl3.text = unwrappedItem.last
        lbl4.attributedText = unwrappedItem.change
        if unwrappedItem.symbol == "+" {
            lbl1.backgroundColor = UIColor.LMEBgGreen
            lbl1.textColor = UIColor.white
        } else if unwrappedItem.symbol == "-"{
            lbl1.backgroundColor = UIColor.LMEBgRed
            lbl1.textColor = UIColor.white
        } else {
            lbl1.backgroundColor = UIColor.clear
            lbl1.textColor = UIColor.BLACK_ALPHA
        }
    }
    
    func configLMECell(item: ShowLMEItem?) {
        guard let unwrappedItem = item else { return }
        lbl1.text = " \(unwrappedItem.name)"
        lbl2.text = unwrappedItem.month
        lbl3.text = unwrappedItem.lastt
        lbl4.attributedText = unwrappedItem.change
        if unwrappedItem.symbol == "+" {
            lbl1.backgroundColor = UIColor.LMEBgGreen
            lbl1.textColor = UIColor.white
        } else if unwrappedItem.symbol == "-" {
            lbl1.backgroundColor = UIColor.LMEBgRed
            lbl1.textColor = UIColor.white
        } else {
            lbl1.backgroundColor = UIColor.clear
            lbl1.textColor = UIColor.BLACK_ALPHA
        }
    }
    
}
