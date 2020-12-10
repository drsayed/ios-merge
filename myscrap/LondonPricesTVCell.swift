//
//  LondonPricesTVCell.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class LondonPricesTVCell: BaseTableCell {

    @IBOutlet weak var lbl1: PricesLabel!
    @IBOutlet weak var lbl2: PricesLabel!
    @IBOutlet weak var lbl3: PricesLabel!
    @IBOutlet weak var lbl4: PricesLabel!
    @IBOutlet weak var lbl5: PricesLabel!
    @IBOutlet weak var blurLbl: BlurredLabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet var titleBackground: UIView!
   @IBOutlet var changeIndicator: UIImageView!
   @IBOutlet weak var blurImage: UIView!
//
    @IBOutlet weak var blurView3: UIView!
    @IBOutlet weak var blurView2: UIView!
    @IBOutlet weak var blurView1: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
            // self.blurLbl.blur()
        // Initialization code
//              blurImage.blurRadius = 8
//              blurImage.colorTint = .clear
//              blurImage.colorTintAlpha = 0.4
        
//        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
//            let effectView = UIVisualEffectView(effect: blur)
//        effectView.frame = CGRect(x: 0, y: 0, width: self.blurImage.frame.size.width, height: self.blurImage.frame.size.height)
//        self.blurImage.addSubview(effectView)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
