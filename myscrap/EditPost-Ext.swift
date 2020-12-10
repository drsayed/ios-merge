//
//  EditPost-Ext.swift
//  myscrap
//
//  Created by MS1 on 12/9/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
extension EditPostVC{
    func keyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = value.cgRectValue.height
        self.bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification){
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}


extension UITextView{
    func textRangeFromNSRange(range:NSRange) -> UITextRange?{
        let beginning = self.beginningOfDocument
        guard let start = self.position(from: beginning, offset: range.location) , let end = self.position(from: start, offset: range.length) else { return nil }
        return self.textRange(from: start, to: end)
    }
}


