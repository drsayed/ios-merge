//
//  PrivacyVC.swift
//  myscrap
//
//  Created by MS1 on 10/26/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class PrivacyVC: BaseVC {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        let terms = TermsAndConditions()
        textView.tintColor = UIColor.GREEN_PRIMARY
        textView.attributedText = terms.privacyAttributedString
        let img = #imageLiteral(resourceName: "myScrapLong").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.GREEN_PRIMARY
        imageView.image = img
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("PauseAllProfileVideos"), object: nil)

    }
}
