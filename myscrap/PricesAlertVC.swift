//
//  PricesAlertVC.swift
//  myscrap
//
//  Created by MyScrap on 6/13/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PricesAlertVC: UIViewController{
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var textfield: UITextField!
    
    typealias Alert = (String) -> Void
    
    var alert : Alert?
    
    var bottomHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupViews()
        addKeyBoardObserver()
    }
    
    private func setupViews(){
        let height = (view.frame.height - 195) / 2
        bottomConstraint.constant = height
        bottomHeight = height
        innerView.layer.cornerRadius = 3
        innerView.layer.masksToBounds = true
        innerView.performShadow()
        textfield.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    static func storyBoardInstance() -> PricesAlertVC? {
        let st = UIStoryboard.MAIN.instantiateViewController(withIdentifier: PricesAlertVC.id) as? PricesAlertVC
        return st
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        textfield.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton){
        guard let text = textfield.text, isValidEmail(testStr: text) else {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email address and try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            present(alert, animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
        if let al = alert{
            al(text)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    
    
    
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
                    strongSelf.bottomConstraint.constant = strongSelf.bottomHeight
                } else {
                    if let height = endFrame?.size.height {
                        if #available(iOS 11.0, *) {
                            strongSelf.bottomConstraint.constant = (height  - strongSelf.view.safeAreaInsets.bottom) + 40
                        } else {
                            strongSelf.bottomConstraint.constant = height + 40
                        }
                    } else {
                        strongSelf.bottomConstraint.constant = 0.0 + strongSelf.bottomHeight
                    }
                }
                
                //                                let oldYContentOffset = strongSelf.scrollView.contentOffset.y
                //                                let oldTableViewHeight = strongSelf.scrollView.bounds.size.height
                
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve, animations: {
                                strongSelf.view.layoutIfNeeded()
                                
                }, completion: nil)
            }
        }
    }
    
    func removeKeyBoardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        removeKeyBoardObserver()
        print("Removed Prices Alert VC")
    }
    
}

private extension UIView{
    func performShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
