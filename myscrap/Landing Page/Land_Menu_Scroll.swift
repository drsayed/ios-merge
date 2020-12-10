//
//  Land_Menu_Scroll.swift
//  myscrap
//
//  Created by MyScrap on 1/16/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class Land_Menu_Scroll: BaseCell {
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var menuTxtLbl: UILabel!
    @IBOutlet weak var menuBGView: LandCRadiusView!
    
    var menuActionBlock: (() -> Void)? = nil
    
    @IBAction func menuBtnTapped(_ sender: UIButton) {
        menuActionBlock?()
    }
}
