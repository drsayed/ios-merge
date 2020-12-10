//
//  KeyBoardManagable.swift
//  myscrap
//
//  Created by MyScrap on 5/3/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol KeyBoardManagable: class {
    func addKeyBoardObserver()
    func removeKeyBoardObserver()
    var layoutConstraintToAdjust: NSLayoutConstraint { get }
    var scrollView: UIScrollView { get }
}




extension KeyBoardManagable where Self: UIViewController {
    
    func addKeyBoardObserver(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] (notification) in
            if let userInfo = notification.userInfo   {
                print("Key in @@")
                
                guard let strongSelf = self else { return }
                
                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?  NSValue)?.cgRectValue
                let endframeY = endFrame?.origin.y ?? 0
                let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                let animationCurve : UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
                if endframeY >= UIScreen.main.bounds.size.height {
//                    self.bottomConstraint.constant = 0
                    self?.layoutConstraintToAdjust.constant = 0
                } else {
                    if let height = endFrame?.size.height {
                        if #available(iOS 11.0, *) {
                            strongSelf.layoutConstraintToAdjust.constant = height  - strongSelf.view.safeAreaInsets.bottom
                            print("Key in value \(strongSelf.layoutConstraintToAdjust.constant)")
                        } else {
                            strongSelf.layoutConstraintToAdjust.constant = height
                        }
                    } else {
                        strongSelf.layoutConstraintToAdjust.constant = 0.0
                    }
                }
                
                let oldYContentOffset = strongSelf.scrollView.contentOffset.y
                let oldTableViewHeight = strongSelf.scrollView.bounds.size.height
                
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve, animations: {
                                strongSelf.view.layoutIfNeeded()
                                
                                let newCollectionViewHeight = strongSelf.scrollView.bounds.size.height
                                let collectionViewHeightDifference = newCollectionViewHeight - oldTableViewHeight
                                var newYContentOffset = oldYContentOffset - collectionViewHeightDifference
                                
                                let contentSizeHeight = strongSelf.scrollView.contentSize.height
                                let possibleBottomYOffset = contentSizeHeight - newCollectionViewHeight
                                newYContentOffset = min(newYContentOffset, possibleBottomYOffset)
                                
                                let possibleTopMost:CGFloat = 0
                                newYContentOffset = max(possibleTopMost, newYContentOffset)
                                
                                
                                let newTableViewContentOffset = CGPoint(x: strongSelf.scrollView.contentOffset.x, y: newYContentOffset)
                                strongSelf.scrollView.contentOffset = newTableViewContentOffset
                                
                                
                }, completion: nil)
            }
        }
    }
    
    func removeKeyBoardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
}



