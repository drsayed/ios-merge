//
//  AlertView.swift
//  myscrap
//
//  Created by MyScrap on 15/03/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
import UIKit

protocol AlartMessagePopupViewDelegate: class {
    func openEditProfileView()
}

class AlartMessagePopupView: UIView {
  //  static let instance = LMEBlurView()
    
  weak var delegate: AlartMessagePopupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)
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
             blurrViewe.alpha = 0.5
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        blurrViewe.addGestureRecognizer(tap)
        }
        if let borderViewe = self.viewWithTag(200) {
            borderViewe.layer.cornerRadius = 10;
            borderViewe.dropShadow()
        }
        if let editButton : UIButton = self.viewWithTag(500) as? UIButton {
            editButton.layer.cornerRadius = 10
            editButton.addTarget(self, action: #selector(self.editButtonPressed), for: .touchUpInside) //<- use `#selector(...)`

        }
        if let closeButton : UIButton = self.viewWithTag(300) as? UIButton {
                   closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside) //<- use `#selector(...)`

               }
    
       
    }
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
      // handling code
   
  
  }
    
    @objc func closeButtonPressed(_ sender: Any) {
          self.removeFromSuperview()
    }
    @objc func editButtonPressed(_ sender: Any) {
    //    parentView.removeFromSuperview()
       
        if let openEditProfileView = delegate?.openEditProfileView {
            openEditProfileView()
        }
        else
        {
            NotificationCenter.default.post(name: Notification.Name("editButtonPressed"), object: nil, userInfo: ["edit":"1"])

        }
        
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}




