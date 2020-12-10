//
//  KeyboardAvoidable.swift
//  myscrap
//
//  Created by MS1 on 7/3/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardAvoidable:class {
    
    func addKeyboardObservers(customBlock: ((CGFloat) -> Void)?)
    func removeKeyboardObservers()
    var layoutConstraintsToAdjust: [NSLayoutConstraint] { get }
}

var KeyboardShowObserverObjectKey: UInt8 = 1
var KeyboardHideObserverObjectKey: UInt8 = 2
var keyboardInputchangeObjectKey: UInt8 = 3

extension KeyboardAvoidable where Self: UIViewController {
    
    var keyboardShowObserverObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self,
                                            &KeyboardShowObserverObjectKey) as? NSObjectProtocol
        }
        set {
            
            objc_setAssociatedObject(self,
                                     &KeyboardShowObserverObjectKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    //
    var keyboardInputObserVerObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self,
                                            &keyboardInputchangeObjectKey) as? NSObjectProtocol
        }
        set {
            
            objc_setAssociatedObject(self,
                                     &keyboardInputchangeObjectKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    //
    
    
    var keyboardHideObserverObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self,
                                            &KeyboardHideObserverObjectKey) as? NSObjectProtocol
        }
        set {
            
            objc_setAssociatedObject(self,
                                     &KeyboardHideObserverObjectKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addKeyboardObservers(customBlock: ((CGFloat) -> Void)? = nil) {
        
//        keyboardInputObserVerObject = NotificationCenter.default.addObserver(forName: .uikeyboa,object: nil,queue: nil) { [weak self] notification in {
//
//            }
        UIResponder.keyboardWillChangeFrameNotification
        
        keyboardInputObserVerObject = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil, using: { [weak self] notification in
            guard let height = self?.getKeyboardHeightFrom(notification: notification) else { return }
            
            /*
            if let customBlock = customBlock { customBlock(height)
                return
            }  */
            
            self?.layoutConstraintsToAdjust.forEach {
                
                if #available(iOS 11.0, *) {
                    if let strongSelf = self {
                        $0.constant = height - strongSelf.view.safeAreaInsets.bottom
                    }
                } else {
                    // Fallback on earlier versions
                    $0.constant = height
                }
                
                
            }
            
            UIView.animate(withDuration: 0.2){
                self?.view.layoutIfNeeded()
            }
        })
        
        keyboardShowObserverObject = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,object: nil,queue: nil) { [weak self] notification in
                                                                                
        guard let height = self?.getKeyboardHeightFrom(notification: notification) else { return }
                                                                                
            if let customBlock = customBlock { customBlock(height)
                return
            }
                                                                                
                                                                                self?.layoutConstraintsToAdjust.forEach {
                                                                                    $0.constant = height
                                                                                }
                                                                                
                                                                                UIView.animate(withDuration: 0.2){
                                                                                    self?.view.layoutIfNeeded()
                                                                                }
        }
        
        keyboardHideObserverObject = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                                            object: nil,
                                                                            queue: nil) { [weak self] notification in
                                                                                
                                                                                if let customBlock = customBlock {
                                                                                    customBlock(0)
                                                                                    return
                                                                                }
                                                                                
                                                                                self?.layoutConstraintsToAdjust.forEach {
                                                                                    $0.constant = 0
                                                                                }
                                                                                
                                                                                UIView.animate(withDuration: 0.2){
                                                                                    self?.view.layoutIfNeeded()
                                                                                }
        }
    }
    
    private func getKeyboardHeightFrom(notification: Notification) -> CGFloat {
        guard let info = notification.userInfo else { return .leastNormalMagnitude }
        guard let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return .leastNormalMagnitude }
        let keyboardSize = value.cgRectValue.size
        return keyboardSize.height
    }
    
    func removeKeyboardObservers() {
        if let keyboardShowObserverObject = keyboardShowObserverObject {
            NotificationCenter.default.removeObserver(keyboardShowObserverObject)
        }
        if let keyboardHideObserverObject = keyboardHideObserverObject {
            NotificationCenter.default.removeObserver(keyboardHideObserverObject)
        }
        keyboardShowObserverObject = nil
        keyboardHideObserverObject = nil
    }
}
