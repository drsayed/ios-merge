//
//  MyProfileWallVC.swift
//  myscrap
//
//  Created by Apple on 12/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class MyProfileWallVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        
    }

}
