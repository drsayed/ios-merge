//
//  FPVerificationVC.swift
//  myscrap
//
//  Created by MyScrap on 1/7/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FPVerificationVC: UIViewController {

    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var codeSentLbl: UILabel!
    
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var sixthTF: UITextField!
    
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var verifyBtn: CorneredButton!
    
    var emailId = ""
    var emailCode = ""
    var phoneVerification = false
    var countrycode = ""
    var sep_phone = ""
    var phoneNumber = ""
    var comb_phone = ""
    
    let service = ForgotPwdService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        hideKeyboardWhenTappedAround()
        setupTextField()
        if phoneVerification {
            self.phoneLbl.text = comb_phone
            self.codeSentLbl.text = "We sent code to your phone number"
        } else {
            self.phoneLbl.text = emailId
            self.codeSentLbl.text = "We sent code to your email address"
        }
        
        service.delegate = self
    }
    @IBAction func resendCodeTapped(_ sender: UIButton) {
        if phoneVerification {
            self.showActivityIndicator(with: "Resending...")
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    print("My phone : \(self.phoneNumber)")
                    print("error from Firebase: \(error.localizedDescription)")
                    let alertVC = UIAlertController(title: "OOPS",message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC,animated: true,completion: nil)
                    return
                } else {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    //self.performSegue(withIdentifier: "sendOTP", sender: self)
                    UserDefaults.standard.set(verificationID, forKey: "FPauthVerificationID")
                    self.resendBtn.setTitleColor(UIColor(hexString: "#999999"), for: .normal)
                    self.resendBtn.isEnabled = false
                    let alertVC = UIAlertController(title: "SUCCESS",message: "Code has been Resended to the phone number", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC,animated: true,completion: nil)
                }
            }
        } else {
            //service.sendEmailCode(email: emailId)
            getAndVerifyEmail()
        }
    }
    
    func getAndVerifyEmail() {
        let service = APIService()
        service.endPoint = Endpoints.VERIFY_EMAIL_OR_PHONE
        service.params = "reg_email=\(emailId)&reg_mobile=&countryCode="
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                let error = dict["error"] as! Bool
                if !error {
                    let status = dict["status"] as! String
                    if status == "Send Code to Email"  {
                        if let code = dict["code"] as? Int {
                            DispatchQueue.main.async {
                                self?.hideActivityIndicator()
                                self?.emailCode = String(format: "%d", code)
                                let alert = UIAlertController(title: "", message: "Verification code has been sent to your email", preferredStyle: .alert)
                                alert.view.tintColor = UIColor.GREEN_PRIMARY
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                                    
                                }))
                                self?.present(alert, animated: true, completion: nil)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.hideActivityIndicator()
                            let alert = UIAlertController(title: "OOPS", message: status, preferredStyle: .alert)
                            alert.view.tintColor = UIColor.GREEN_PRIMARY
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                                //self.dismiss(animated: true, completion: nil)
                            }))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                } else {
                    let status = dict["status"] as! String
                    DispatchQueue.main.async {
                        self?.hideActivityIndicator()
                        
                        let alert = UIAlertController(title: "OOPS", message: status, preferredStyle: .alert)
                        alert.view.tintColor = UIColor.GREEN_PRIMARY
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                            //self.dismiss(animated: true, completion: nil)
                        }))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    
                    let alert = UIAlertController(title: "Server Error", message: error, preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        //self.dismiss(animated: true, completion: nil)
                    }))
                    self?.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    @IBAction func verifyBtnTapped(_ sender: UIButton) {
        self.showActivityIndicator(with: "Verifying")
        if phoneVerification {
            phoneNumber = comb_phone.replacingOccurrences(of: "-", with: "")
            let first_code = firstTF.text! + secondTF.text! + thirdTF.text!
            let second_code = fourthTF.text! + fifthTF.text! + sixthTF.text!
            let comb_code = first_code + second_code
            if comb_code != "" {
                
                let verificationID = UserDefaults.standard.object(forKey: "FPauthVerificationID") as? String
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
                                                                         verificationCode: comb_code)
                Auth.auth().signIn(with: credential) { authData, error in
                    if ((error) != nil) {
                        // Handles error
                        print("Wrong code entered: \(error?.localizedDescription)")
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                        }
                        let alertVC = UIAlertController(title: "OOPS",message: "Invalid Code", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                        alertVC.addAction(okAction)
                        self.present(alertVC,animated: true,completion: nil)
                        return
                    } else {
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                        }
                        self.performSegue(withIdentifier: "verifyOTP", sender: self)
                    }
                }
                //}
            } else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                let alertVC = UIAlertController(title: "OOPS",message: "Enter Valid Code", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            }
        } else {
            //Email verification
            let first_code = firstTF.text! + secondTF.text! + thirdTF.text!
            let second_code = fourthTF.text! + fifthTF.text! + sixthTF.text!
            let comb_code = first_code + second_code
            if comb_code != "" {
                if emailCode == comb_code {
                    //service.sendEmailCode(email: emailId)
                    //Email code and text field numbers were matched
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    self.performSegue(withIdentifier: "verifyOTP", sender: self)
                } else {
                    print("Email code doesn't match")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    let alertVC = UIAlertController(title: "OOPS",message: "Verification Code doesn't Match.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC,animated: true,completion: nil)
                }
            } else {
                print("TextField have some empty values")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                let alertVC = UIAlertController(title: "OOPS",message: "Enter Valid Code", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            }
        }
    }
    
    func setupTextField() {
        
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0.0, y: firstTF.frame.height - 1, width: firstTF.frame.width, height: 1.0)
        bottomLine1.backgroundColor = UIColor.black.cgColor
        firstTF.borderStyle = UITextField.BorderStyle.none
        firstTF.layer.addSublayer(bottomLine1)
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: firstTF.frame.height - 1, width: firstTF.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.black.cgColor
        secondTF.borderStyle = UITextField.BorderStyle.none
        secondTF.layer.addSublayer(bottomLine2)
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0.0, y: firstTF.frame.height - 1, width: firstTF.frame.width, height: 1.0)
        bottomLine3.backgroundColor = UIColor.black.cgColor
        thirdTF.borderStyle = UITextField.BorderStyle.none
        thirdTF.layer.addSublayer(bottomLine3)
        let bottomLine4 = CALayer()
        bottomLine4.frame = CGRect(x: 0.0, y: firstTF.frame.height - 1, width: firstTF.frame.width, height: 1.0)
        bottomLine4.backgroundColor = UIColor.black.cgColor
        fourthTF.borderStyle = UITextField.BorderStyle.none
        fourthTF.layer.addSublayer(bottomLine4)
        let bottomLine5 = CALayer()
        bottomLine5.frame = CGRect(x: 0.0, y: firstTF.frame.height - 1, width: firstTF.frame.width, height: 1.0)
        bottomLine5.backgroundColor = UIColor.black.cgColor
        fifthTF.borderStyle = UITextField.BorderStyle.none
        fifthTF.layer.addSublayer(bottomLine5)
        let bottomLine6 = CALayer()
        bottomLine6.frame = CGRect(x: 0.0, y: firstTF.frame.height - 1, width: firstTF.frame.width, height: 1.0)
        bottomLine6.backgroundColor = UIColor.black.cgColor
        sixthTF.borderStyle = UITextField.BorderStyle.none
        sixthTF.layer.addSublayer(bottomLine6)
        
        firstTF.delegate = self
        if #available(iOS 12.0, *) {
            firstTF.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
            print("One time code will not be fetched")
        }
        firstTF.becomeFirstResponder()
        secondTF.delegate = self
        thirdTF.delegate = self
        fourthTF.delegate = self
        fifthTF.delegate = self
        sixthTF.delegate = self
        
        firstTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        secondTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        thirdTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        fourthTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        fifthTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        sixthTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        if let text = textField.text {
            // here check you text field's input Type
            if #available(iOS 12.0, *) {
                if textField.textContentType == UITextContentType.oneTimeCode{
                    
                    //here split the text to your four text fields
                    if let otpCode = textField.text, otpCode.count > 5{
                        
                        textField.text = String(otpCode[otpCode.startIndex])
                        firstTF.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 1)])
                        secondTF.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 2)])
                        thirdTF.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 3)])
                        fourthTF.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 4)])
                        fifthTF.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 5)])
                        sixthTF.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 6)])
                    } else {
                        print("Receiving error... otp")
                    }
                }
            } else {
                // Fallback on earlier versions
                print("One time code can't fetched in change event")
            }
            if text.utf16.count >= 1 {
                switch textField {
                case firstTF:
                    secondTF.becomeFirstResponder()
                case secondTF:
                    thirdTF.becomeFirstResponder()
                case thirdTF:
                    fourthTF.becomeFirstResponder()
                case fourthTF:
                    fifthTF.becomeFirstResponder()
                case fifthTF:
                    sixthTF.becomeFirstResponder()
                case sixthTF:
                    sixthTF.resignFirstResponder()
                    verifyBtn.sendActions(for: .touchUpInside)
                default:
                    break
                }
            } else {
                print("Textfield doesn't have values")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "verifyOTP" {
            if let vc = segue.destination as? ReCreatePasswordVC {
                vc.email = self.phoneLbl.text!.replacingOccurrences(of: "-", with: "")
            }
        }
    }
    
}
extension FPVerificationVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
extension FPVerificationVC : ForgotPwdDelegate {
    func didReceiveResponse(message: String) {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            if message == "Email has been Sent to your Given mail ID." {
                //self.performSegue(withIdentifier: "verifyOTP", sender: self)
                self.showToast(message: "Code resended to your email")
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

