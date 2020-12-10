//
//  GeneralInformationVC.swift
//  myscrap
//
//  Created by MS1 on 10/26/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class GeneralInformationVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        
        let terms = TermsAndConditions()
        textView.attributedText = terms.disclaimerString
    }
}
