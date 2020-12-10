//
//  AlertView.swift
//  myscrap
//
//  Created by MyScrap on 15/03/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
import UIKit

class LMEBlurView: UIView {
    //  static let instance = LMEBlurView()
    
    @IBOutlet weak var blurrViewe: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LMEBlurView", owner: self, options: nil)
        //  commonInit()
    }
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    func addBlurreffect()  {
//        if let customBlurEffectView = self.viewWithTag(100) as? CustomBlurEffectView  {
//            // customBlurEffectView.backgroundColor = .clear
//            customBlurEffectView.blurRadius = 8
//            customBlurEffectView.colorTint = .clear
//            customBlurEffectView.colorTintAlpha = 0.4
//
//        }
        if let subButton : UIButton = self.viewWithTag(250) as? UIButton {
            subButton.layer.cornerRadius = 10
            subButton.addTarget(self, action: #selector(self.SubButtonPressed), for: .touchUpInside) //<- use `#selector(...)`
            subButton.dropShadow(shadowColor: .black, fillColor: subButton.backgroundColor ?? UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00), opacity: 0.2, offset: CGSize(width: 0.0, height: 1.0), radius: 10)
        }
        if let promoView = self.viewWithTag(300) {
            promoView.layer.cornerRadius = 10
            promoView.dropShadow(shadowColor: .black, fillColor: promoView.backgroundColor ?? UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00), opacity: 0.2, offset: CGSize(width: 0.0, height: 1.0), radius: 10)
        }
        if let textfield = self.viewWithTag(400) {
            textfield.layer.cornerRadius = 5
            textfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
            
        }
        if let applyButton : UIButton = self.viewWithTag(500) as? UIButton {
            applyButton.addTarget(self, action: #selector(self.ApplyButtonPressed), for: .touchUpInside) //<- use `#selector(...)`
            
        }
    }
    
    
    enum AlertType {
        case success
        case failure
    }
    
    //    func showAlert(title: String, message: String, alertType: AlertType) {
    //        self.titleLbl.text = title
    //        self.messageLbl.text = message
    //        switch alertType {
    //        case .success:
    //            img.image = UIImage(named: "Success")
    //            doneBtn.backgroundColor = #colorLiteral(red: 0.1649596691, green: 0.4849149585, blue: 0.2121850848, alpha: 1)
    //        case .failure:
    //            img.image = UIImage(named: "Failure")
    //            doneBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    //        }
    //        UIApplication.shared.keyWindow?.addSubview(parentView)
    //    }
    @objc func SubButtonPressed(_ sender: Any) {
        //    parentView.removeFromSuperview()
        if let textfield = self.viewWithTag(400) {
            textfield.resignFirstResponder()
        }
        NotificationCenter.default.post(name: Notification.Name("SubScrribeButtonPressed"), object: nil, userInfo: ["SubData":"0"])
    }
    @objc func ApplyButtonPressed(_ sender: Any) {
        //    parentView.removeFromSuperview()
        if let textfield : UITextField = self.viewWithTag(400) as? UITextField  {
            
            textfield.resignFirstResponder()
            
            NotificationCenter.default.post(name: Notification.Name("ApplyButtonPressed"), object: nil, userInfo: ["code":textfield.text ?? ""])
            
            
        }
    }
}

