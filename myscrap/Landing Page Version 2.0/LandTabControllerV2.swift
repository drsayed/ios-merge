//
//  LandTabControllerV2.swift
//  myscrap
//
//  Created by MyScrap on 2/2/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class LandTabControllerV2: UITabBarController {

    override func viewDidLoad() {
      
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    
    static func storyBoardInstance() -> LandTabControllerV2?{
        let st = UIStoryboard.LAND
        return st.instantiateViewController(withIdentifier: LandTabControllerV2.id) as? LandTabControllerV2
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
