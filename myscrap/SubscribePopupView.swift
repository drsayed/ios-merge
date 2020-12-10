//
//  AlertView.swift
//  myscrap
//
//  Created by MyScrap on 15/03/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
import UIKit

class SubscribePopupView: UIView {
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
    func intializeUI()  {
        if let blurrViewe = self.viewWithTag(100) {
             blurrViewe.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blurrViewe.addGestureRecognizer(tap)
        }
        if let borderViewe = self.viewWithTag(200) {
            borderViewe.layer.cornerRadius = 10;
            borderViewe.dropShadow()
        }
        if let sendButton : UIButton = self.viewWithTag(500) as? UIButton {
            sendButton.layer.cornerRadius = 10
            sendButton .addTarget(self, action: #selector(self.sendButtonPressed), for: .touchUpInside) //<- use `#selector(...)`

        }
        if let promoView = self.viewWithTag(300) {
            promoView.layer.cornerRadius = 10
        }
        if let textfield = self.viewWithTag(400) {
                   textfield.layer.cornerRadius = 5
            let myColor : UIColor = UIColor.darkGray
            textfield.layer.borderColor = myColor.cgColor
            textfield.layer.borderWidth = 1.0
            // Create a padding view for padding on left
            textfield.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        textfield.becomeFirstResponder()
//            textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
//            textfield.leftViewMode = .always
           // textfield.peddin
               }
       
    }
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
      // handling code
     if let textfield = self.viewWithTag(400) {
      textfield.resignFirstResponder()
    }
    self.removeFromSuperview()
  }
    
   
    @objc func sendButtonPressed(_ sender: Any) {
    //    parentView.removeFromSuperview()
        if let textfield : UITextField = self.viewWithTag(400) as? UITextField  {
            
            if textfield.text != "" && self.isValidEmail(textfield.text ?? "")  {
                  
              if let textfieldErrorLbl : UILabel = self.viewWithTag(600) as? UILabel  {
                     textfieldErrorLbl.text = ""
                 }
                if let textfield = self.viewWithTag(400) {
                     textfield.resignFirstResponder()
                   }
                NotificationCenter.default.post(name: Notification.Name("SendButtonPressed"), object: nil, userInfo: ["email":textfield.text ?? ""])
            }
            else
             {
                 if let textfieldErrorLbl : UILabel = self.viewWithTag(600) as? UILabel  {
                    textfieldErrorLbl.text = "Please enter valid email"
                }
               
            }
          
            

                     }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}




