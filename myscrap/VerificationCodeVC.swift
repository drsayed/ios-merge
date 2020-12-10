//
//  VerificationCodeVC.swift
//  myscrap
//
//  Created by MyScrap on 10/26/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class VerificationCodeVC: UIViewController {
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var borderOtpView: CorneredView!
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var verifyBtn: CorneredButton!
    @IBOutlet weak var sendCodeBtn: CorneredButton!
    
    var email = ""
    let service = ForgotPwdService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.emailLbl.text = email
        service.delegate = self
        borderOtpView.layer.cornerRadius = 5
        borderOtpView.layer.borderWidth = 2
        borderOtpView.layer.borderColor = UIColor.MyScrapGreen.cgColor
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationItem.title = "Inbox"
        //navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func verifyOTPTapped(_ sender: UIButton) {
        _ = otpTF.resignFirstResponder()
        if let otp = otpTF.text, otp != ""  {
            if email != "" {
                DispatchQueue.main.async {
                    self.showActivityIndicator(with: "Verifying")             //(Maha Manual edit)
                }
                service.verifyCode(email: emailLbl.text!, otp: otp)
            } else {
                self.showToast(message: "Something went wrong. Please try again!")
            }
        } else {
            //otpTF.showErrorWithText(errorText: "Please enter the Code")
            let alertVC = UIAlertController(title: "OOPS",message: "Please enter the Code.",preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC,animated: true,completion: nil)
        }
    }
    @IBAction func resendOTPTapped(_ sender: UIButton) {
        if email != "" {
            service.sendEmailCode(email: emailLbl.text!)
        } else {
            self.showToast(message: "Something went wrong. Please try again!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "verifyOTP" {
            if let vc = segue.destination as? ReCreatePasswordVC {
                vc.email = self.emailLbl.text!
            }
        }
    }

}
extension VerificationCodeVC : ForgotPwdDelegate {
    func didReceiveResponse(message: String) {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            if message == "Email has been Sent to your Given mail ID." {
                //self.performSegue(withIdentifier: "verifyOTP", sender: self)
                self.showToast(message: "OTP sent again to the email")
            } else if message == "Code entered is expired. Please generate a new Code and try again." {
                let alertVC = UIAlertController(title: "OOPS",message: message,preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            } else if message == "OTP Success" {
                self.performSegue(withIdentifier: "verifyOTP", sender: self)
            }
        }
    }
    
    func didReceiveError(error: String) {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            let alertVC = UIAlertController(title: "OOPS",message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC,animated: true,completion: nil)
        }
    }
}
