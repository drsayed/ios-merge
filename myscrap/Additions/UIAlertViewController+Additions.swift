//
//  UIAlertViewController+Additions.swift
//  MyScrap
//
//  Created by Apple on 09/09/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "", message: message as String, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    func showPopUpAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }

}
