//
//  ConversationVC-KeyBoard-Ext.swift
//  myscrap
//
//  Created by MS1 on 11/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
// MARK:- KEYBOARD OBSERVERS
extension ConvVC {
    //MARK:- KEYBOARD OBSERVERS
    func keyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(ConvVC.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConvVC.keyboardWillShow(_:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConvVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- REMOVE KEYBOARD OBSERVERS
    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
    }
    
    // MARK:- KEYBOARD WILL SHOW
    @objc func keyboardWillShow(_ notification: Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = value.cgRectValue.height
        self.bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.scrollToBottom(anim: true)
        }
    }
    
    //MARK:- KEYBOARD WILL HIDE
    @objc func keyboardWillHide(_ notification: Notification){
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}
