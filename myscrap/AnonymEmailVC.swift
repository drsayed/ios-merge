//
//  AnonymEmailVC.swift
//  myscrap
//
//  Created by MyScrap on 1/27/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import Alamofire

class AnonymEmailVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var listing_id = ""
    var user_id = ""
    var service = EmailService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        service.eDelegate = self
        setupTextView()
        sendBtn.clipsToBounds = true
        sendBtn.layer.cornerRadius = 5
        self.popupView.clipsToBounds = true
        self.popupView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
       self.showAnimate()
        closeBtn.clipsToBounds = true
        closeBtn.layer.cornerRadius = 5
        print("Listng id : \(listing_id), User id :\(user_id)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    func setupTextView() {
        bodyTextView.delegate = self
        
        bodyTextView.clipsToBounds = true
        bodyTextView.layer.cornerRadius = 5
        let color = UIColor.lightGray
        bodyTextView.layer.borderColor = color.cgColor
        bodyTextView.layer.borderWidth = 1
        
        bodyTextView.text = "Write the message.."
        bodyTextView.textColor = .lightGray
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write the message.."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        let spinner = MBProgressHUD.showAdded(to: popupView, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Sending Mail"
        let trim = bodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        service.sendEmail(userId: user_id,subj: subjectTextField.text!, body: trim, listingID: listing_id)
    }
    @IBAction func dismissVC(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    static func storyBoardInstance() -> AnonymEmailVC? {
        let st = UIStoryboard.Email
        return st.instantiateViewController(withIdentifier: AnonymEmailVC.id) as? AnonymEmailVC
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension AnonymEmailVC: EmailServiceDelegate {
    func DidReceiveViewMail(data: [ViewMailLists]) {
        print("This won't work in anonym")
    }
    
    func DidReceiveMailData(data: [MailData]) {
        print("Did receive email Data will not work here")
    }
    
    func DidReceivedData(array: [EmailInboxLists]) {
        print("Did receive email will not work here")
    }
    
    func DidReceivedError(error: String) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.popupView, animated: true)
            self.showMessage(with: error)
            self.removeAnimate()
            print("Error in Compose email : \(error)")
        }
    }
    
    func DidSentMail(data: String) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.popupView, animated: true)
            self.showMessage(with: data)
            self.removeAnimate()
        }
        
    }
    
    
    
    
}
