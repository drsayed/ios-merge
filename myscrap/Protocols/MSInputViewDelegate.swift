//
//  MSInputViewDelegate.swift
//  MSInputView
//
//  Created by MyScrap on 3/17/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

public protocol MSInputViewDelegate: class{
//
//    var MSCollectionView: UICollectionView { get }
//
//    var MSCollectionViewBottomInset: CGFloat { get set }
//
//    var msInputView: MSInputView { get }
//
//    var scrollsToBottomOnKeybordBeginsEditing: Bool { get }
//
//    var maintainPositionOnKeyboardFrameChanged: Bool { get }
    
    func didPressSendButton(with text: String)
    func didPressCameraButton()
    func didPressAddButton()

//    func addKeyBoardObservers()
//
//    func removeKeyBoardObservers()
//
//    var iPhoneXBottomInset: CGFloat { get }
//
//    var keyboardOffsetFrame: CGRect { get }
    
}

/*
extension MSInputViewDelegate where Self: UIViewController {
    
    public var iPhoneXBottomInset: CGFloat {
        if #available(iOS 11.0, *) {
            guard UIScreen.main.nativeBounds.height == 2436 else { return 0 }
            return view.safeAreaInsets.bottom
        }
        return 0
    }
    
    public var keyboardOffsetFrame: CGRect {
        guard let inputFrame = inputAccessoryView?.frame else { return .zero }
        return CGRect(origin: inputFrame.origin, size: CGSize(width: inputFrame.width, height: inputFrame.height - iPhoneXBottomInset))
    }

    public func addKeyBoardObservers(){
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: nil) {[unowned self] (notification) in
            //
            
            guard let keyboardEndFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            if (keyboardEndFrame.origin.y + keyboardEndFrame.size.height) > UIScreen.main.bounds.height {
                // Hardware keyboard is found
                self.MSCollectionViewBottomInset = self.view.frame.size.height - keyboardEndFrame.origin.y - self.iPhoneXBottomInset
            } else {
                //Software keyboard is found
                let afterBottomInset = keyboardEndFrame.height > self.keyboardOffsetFrame.height ? (keyboardEndFrame.height - self.iPhoneXBottomInset) : self.keyboardOffsetFrame.height
                let differenceOfBottomInset = afterBottomInset - self.MSCollectionViewBottomInset
                
                if self.maintainPositionOnKeyboardFrameChanged && differenceOfBottomInset != 0 {
                    let contentOffset = CGPoint(x: self.MSCollectionView.contentOffset.x, y: self.MSCollectionView.contentOffset.y + differenceOfBottomInset)
                    self.MSCollectionView.setContentOffset(contentOffset, animated: false)
                }
                
                self.MSCollectionViewBottomInset = afterBottomInset
            }
        }
        
        NotificationCenter.default.addObserver(forName: .UITextViewTextDidBeginEditing, object: nil, queue: nil) {  [unowned self] notification in
            
            if self.scrollsToBottomOnKeybordBeginsEditing {
                guard let inputTextView = notification.object as? InputTextView, inputTextView === self.msInputView.inputTextView else { return }
                self.MSCollectionView.scrollToBottom(animated: true)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .UIDeviceOrientationDidChange, object: nil, queue: nil) { (notification) in
            //
        }
        
    }
    
    public func removeKeyBoardObservers(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
}


public extension UICollectionView{
    
        func scrollToBottom(animated: Bool = false) {
            let collectionViewContentHeight = collectionViewLayout.collectionViewContentSize.height
    
            performBatchUpdates(nil) { _ in
                
                let rect = CGRect(x: 0.0, y: collectionViewContentHeight - 1.0 , width: 1.0, height: 1.0)
                
                self.scrollRectToVisible(rect, animated: animated)
                
            }
        }
    
}  */


