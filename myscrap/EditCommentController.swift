//
//  EditCommentController.swift
//  myscrap
//
//  Created by MyScrap on 6/4/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class EditCommentController: UIViewController {


    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var layoutConstraintToAdjust: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UITextView!
    @IBOutlet weak var innerView: UIView!
    
    typealias closure = (CommentItem) -> ()
    
    var commentClosure: closure?
    
    var item : CommentItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        addKeyBoardObserver()
        
        
        scrollView.text = item?.comment
        scrollView.becomeFirstResponder()
        
        scrollView.layer.cornerRadius = 3
        scrollView.layer.masksToBounds = true
        
        scrollView.layer.borderColor = UIColor.seperatorColor.cgColor
        scrollView.layer.borderWidth = 1.0
        
        innerView.layer.cornerRadius = 5
        innerView.layer.masksToBounds = true
        innerView.layer.borderColor = UIColor.seperatorColor.cgColor
        innerView.layer.borderWidth = 1.0
        
    }

    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton){
        item?.comment = scrollView.text
        if let cls = commentClosure, let it = item, it.comment != "" {
            cls(it)
            dismiss(animated: true, completion: nil)
        }
    }
    
    static func storyBoardInstance() -> EditCommentController? {
        return UIStoryboard.Comment.instantiateViewController(withIdentifier: EditCommentController.id) as? EditCommentController
    }
    
    
    
    deinit {
        print("deinited Edit Comment Controller")
        removeKeyBoardObserver()
    }

}


extension EditCommentController{
    
    
    func addKeyBoardObserver(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] (notification) in
            if let userInfo = notification.userInfo   {
                
                guard let strongSelf = self else { return }
                
                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?  NSValue)?.cgRectValue
                let endframeY = endFrame?.origin.y ?? 0
                let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                let animationCurve : UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
                if endframeY >= UIScreen.main.bounds.size.height {
                    //                    self.bottomConstraint.constant = 0
                    self?.layoutConstraintToAdjust.constant = 0 + 20
                } else {
                    if let height = endFrame?.size.height {
                        if #available(iOS 11.0, *) {
                            strongSelf.layoutConstraintToAdjust.constant = (height  - strongSelf.view.safeAreaInsets.bottom) + 20
                        } else {
                            strongSelf.layoutConstraintToAdjust.constant = height + 20
                        }
                    } else {
                        strongSelf.layoutConstraintToAdjust.constant = 0.0 + 20
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
