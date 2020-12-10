//
//  AlertService.swift
//  myscrap
//
//  Created by MyScrap on 5/12/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


class AlertService{
    
    static let instance = AlertService()
    
    func showCameraSettingsURL(in vc: UIViewController){
        let alert = UIAlertController(title: "Camera Access is required to capture & share photos to MyScrap.", message: "Please allow Camera access", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .default, handler: { (alert) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(in vc: UIViewController , title: String?, message: String?, actions: [UIAlertAction] ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        actions.forEach { (actn) in
            alert.addAction(actn)
        }
        vc.present(alert, animated: true, completion: nil)
    }

}
