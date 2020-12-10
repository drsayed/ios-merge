//
//  DetailsVC-KeyBoardHelpers.swift
//  myscrap
//
//  Created by MS1 on 11/22/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//


import Foundation

protocol KeyboardObserversForInputView: class{
    
    var MSCollectionView: UICollectionView { get set  }
    
    func addKeyBoardObservers()
    
    func removeKeyBoardObservers()
    
}

extension KeyboardObserversForInputView where Self:  UIViewController {
    
    func addKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.handleKeyboardDidChangeState(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.handleTextViewDidBeginEditing(_:)), name: .UITextViewTextDidBeginEditing, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.adjustScrollViewInset), name: .UIDeviceOrientationDidChange, object: nil)
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { notification in
            
            //
            
        }
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidBeginEditingNotification, object: nil, queue: nil) { (notification) in
            //
        }
        
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { (notification) in
            //
        }
        
        
    }
    
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
}




/*
import Foundation

// MARK:- KEYBOARD OBSERVERS
extension DetailsVC{
    
    func observeKeyboards(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardInputChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardInputChanged(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardInputChanged(_ notification : Notification){
        
        if let userInfo = notification.userInfo{
            print(userInfo)
        }
        
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = value.cgRectValue.height
        self.bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.view.layoutIfNeeded()
            
            /*
            let collectionViewContentHeight: CGFloat = self.collectionView.contentSize.height
            let collectionViewFrameHeightAfterInserts: CGFloat = self.collectionView.frame.size.height - (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom)
            if collectionViewContentHeight > collectionViewFrameHeightAfterInserts {
                self.collectionView.setContentOffset(CGPoint(x: 0, y: self.collectionView.contentSize.height - self.collectionView.frame.size.height), animated: true)
            } */
        }

    }
    
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = value.cgRectValue.height
        self.bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            let collectionViewContentHeight: CGFloat = self.collectionView.contentSize.height
            let collectionViewFrameHeightAfterInserts: CGFloat = self.collectionView.frame.size.height - (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom)
            if collectionViewContentHeight > collectionViewFrameHeightAfterInserts {
                self.collectionView.setContentOffset(CGPoint(x: 0, y: self.collectionView.contentSize.height - self.collectionView.frame.size.height), animated: true)
            }
        }
    }
    
   
    
    @objc private func keyboardWillHide(_ notification: Notification){
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}
*/
