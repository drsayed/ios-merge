//
//  Toast.swift
//  myscrap
//
//  Created by MS1 on 6/20/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{
    
    func showToast(message:String){
        
        let size: CGSize = message.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 13)!])
        
     
        let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.width / 2) - (size.width + 20 ) / 2   , y: self.view.frame.height - 100, width: size.width + 20, height: 30))
      
    
        
        toastLabel.backgroundColor = UIColor.BLACK_ALPHA
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        toastLabel.font = UIFont(name: "HelveticaNeue", size: 13)
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10.0
        toastLabel.clipsToBounds = true
        self.view.bringSubviewToFront(toastLabel)
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.5
        }) { (isCompleted) in
            
            toastLabel.removeFromSuperview()
        }
        
        
    }
    
    
}
