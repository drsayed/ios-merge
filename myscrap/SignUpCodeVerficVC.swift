//
//  SignUpCodeVerficVC.swift
//  myscrap
//
//  Created by MyScrap on 12/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpCodeVerficVC: UIViewController {

    
    @IBOutlet weak var codeSentTo: UILabel!
    @IBOutlet weak var phoneOrEmailLbl: UILabel!
    
    
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var sixthTF: UITextField!
    
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var getEmailCode: UIButton!
    @IBOutlet weak var emailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var proceedBtn: CorneredButton!
    
    var first_name = ""
    var last_name = ""
    var email = ""
    var password = ""
    var lat = ""
    var long = ""
    
    var countrycode = ""
    var sep_phone = ""
    
    var comb_phone = ""
    var phoneNumber = ""
    
    var emailVerification = false
    var phoneVerification = false
    
    var emailCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        hideKeyboardWhenTappedAround()
        phoneOrEmailLbl.text = comb_phone
        phoneVerification = true
        getEmailCode.isHidden = true
        emailHeightConstraint.constant = 0
        AuthService.instance.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupTextField()
    }
    
    @IBAction func resendBtnTapped(_ sender: UIButton) {
        if phoneVerification {
            self.showActivityIndicator(with: "Code Resending...")
            let phoneNumber = comb_phone.replacingOccurrences(of: "-", with: "")
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    
                    print("My phone : \(phoneNumber)")
                    print("error from Firebase: \(error.localizedDescription)")
                    let alertVC = UIAlertController(title: "OOPS",message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC,animated: true,completion: nil)
                    return
                } else {
                    self.showToast(message: "Code Resended to your phone")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    self.resendBtn.setTitleColor(UIColor(hexString: "#999999"), for: .normal)
                    self.resendBtn.isEnabled = false
                    self.getEmailCode.isHidden = false
                    self.emailHeightConstraint.constant = 26
                    self.phoneVerification = true
                }
            }
        } else {
            self.phoneVerification = false
            getAndVerifyEmail()
        }
        
    }
    @IBAction func getCodeEmailTapped(_ sender: UIButton) {
        if phoneVerification {
            self.getEmailCode.isHidden = true
            self.emailHeightConstraint.constant = 0
            codeSentTo.text = "Code has been sent to your email address."
            phoneOrEmailLbl.text = email
            self.getAndVerifyEmail()
            self.phoneVerification = false
            
        }
        
    }
    
    func getAndVerifyEmail() {
        let service = APIService()
        service.endPoint = Endpoints.SIGNUP_EMAIL_GET_CODE
        service.params = "reg_email=\(self.email)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                let error = dict["error"] as! Bool
                DispatchQueue.main.async {
                    if !error {
                        if let code = dict["code"] as? Int {
                            
                            self?.emailCode = String(format: "%d", code)
                            let alert = UIAlertController(title: "", message: "Verification code has been sent to your email", preferredStyle: .alert)
                            alert.view.tintColor = UIColor.GREEN_PRIMARY
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                                //self.dismiss(animated: true, completion: nil)
                                self?.resendBtn.setTitleColor(UIColor.MyScrapGreen, for: .normal)
                                self?.resendBtn.isEnabled = true
                            }))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let status = dict["status"] as! String
                        
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
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func verifySignupBtnTapped(_ sender: UIButton) {
        self.showActivityIndicator(with: "Verifying")
        if phoneVerification {
            phoneNumber = comb_phone.replacingOccurrences(of: "-", with: "")
            let first_code = firstTF.text! + secondTF.text! + thirdTF.text!
            let second_code = fourthTF.text! + fifthTF.text! + sixthTF.text!
            let comb_code = first_code + second_code
            if comb_code != "" {
                
                let verificationID = UserDefaults.standard.object(forKey: "authVerificationID") as? String
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
                        if AuthService.instance.isDeviceRegistered{
                            AuthService.instance.signupV1Updated(mail: self.email, pwd: self.password, fname: self.first_name, lname: self.last_name, ccode: self.countrycode, mobile: self.sep_phone, lat: self.lat, long: self.long, company: "", mobileVerify: true, emailVerify: false)
                            //AuthService.instance.signUpUserUpdated(mail: self.email, pwd: self.password, fname: self.first_name, lname: self.last_name, ccode: self.countrycode, mobile: self.sep_phone, lat: self.lat, long: self.long, company: "")
                        } else {
                            AuthService.instance.deviceRegistration { _ in
                                if AuthService.instance.isDeviceRegistered{
                                    AuthService.instance.signupV1Updated(mail: self.email, pwd: self.password, fname: self.first_name, lname: self.last_name, ccode: self.countrycode, mobile: self.sep_phone, lat: self.lat, long: self.long, company: "", mobileVerify: true, emailVerify: false)
                                    //AuthService.instance.signUpUserUpdated(mail: self.email, pwd: self.password, fname: self.first_name, lname: self.last_name, ccode: self.countrycode, mobile: self.sep_phone, lat: self.lat, long: self.long, company: "")
                                }
                            }
                        }
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
                    
                    if AuthService.instance.isDeviceRegistered{
                        AuthService.instance.signupV1Updated(mail: self.email, pwd: self.password, fname: self.first_name, lname: self.last_name, ccode: self.countrycode, mobile: self.sep_phone, lat: self.lat, long: self.long, company: "", mobileVerify: false, emailVerify: true)
                    } else {
                        AuthService.instance.deviceRegistration { _ in
                            if AuthService.instance.isDeviceRegistered{
                                AuthService.instance.signupV1Updated(mail: self.email, pwd: self.password, fname: self.first_name, lname: self.last_name, ccode: self.countrycode, mobile: self.sep_phone, lat: self.lat, long: self.long, company: "", mobileVerify: false, emailVerify: true)
                            }
                        }
                    }
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
                    proceedBtn.sendActions(for: .touchUpInside)
                default:
                    break
                }
            } else {
                print("Textfield doesn't have values")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SignUpCodeVerficVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
extension SignUpCodeVerficVC: AuthServiceDelegate{
    func didFailure(error: String) {
        DispatchQueue.main.async {
            print(error)
            self.hideActivityIndicator()
            let alert = UIAlertController(title: "Registration Failed", message: error, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                //self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didSuccessDeviceRegistration(status: Bool, message: String) {
        if status{
            AuthService.instance.isDeviceRegistered = true
            AuthService.instance.signUpUserUpdated(mail: self.email, pwd: self.password, fname: self.first_name, lname: self.last_name, ccode: self.countrycode, mobile: self.sep_phone, lat: self.lat, long: self.long, company: "")
        } else {
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                let alert = UIAlertController(title: "Registration Failed", message: message, preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    //self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                //self.showMessage(with: "Some Error Occured. Try again. \(message)")
            }
        }
    }
    
    func didSuccessAuthService(status: Bool) {
        DispatchQueue.main.async {
            if status{
                if XMPPService.instance.xmppStream?.isConnecting() == false && XMPPService.instance.xmppStream?.isConnected() == false && XMPPService.instance.xmppStream?.isAuthenticating() == false && XMPPService.instance.xmppStream?.isAuthenticated() == false {
                    
                    if !XMPPService.instance.connectEst {
                        if let jid = AuthService.instance.userJID {
                            DispatchQueue.main.async {
                                print("^^^&&&&Connecting XMPP while SIGN UP @@@@####")
                                print(jid)
                                print(AuthService.instance.password)
                                XMPPService.instance.connect(with: jid)
                            }
                            
                            /*if XMPPService.instance.xmppStream?.isConnected() == false {
                             print("1st time connecting")
                             XMPPService.instance.connect(with: jid)           //Because in app delegate while app wake up 1st time trying to connect server
                             }*/
                            
                        }
                        //let vc = FeedsVC.storyBoardInstance()
                        //let vc = MarketVC.storyBoardInstance()
                        if self.phoneVerification {
                            //Storing Phone number and password for every time while Signing up
                            UserDefaults.standard.set(self.phoneNumber, forKey: "storedEmail")
                            UserDefaults.standard.set(self.password, forKey: "storedPassword")
                        } else {
                            //Storing Email and password
                            UserDefaults.standard.set(self.email, forKey: "storedEmail")
                            UserDefaults.standard.set(self.password, forKey: "storedPassword")
                        }
                        if let vc = FeedsVC.storyBoardInstance(){
                        //if let vc = LandHomePageVC.storyBoardInstance(){
                            self.hideActivityIndicator()
                            
                            //Market Adv show pop up
                            vc.showPopup = true
                            //Show COVID Poll Pop up
                            //vc.showCovidPoll = true
                            let rearViewController = MenuTVC()
                            let frontNavigationController = UINavigationController(rootViewController: vc)
                            let mainRevealController = SWRevealViewController()
                            mainRevealController.rearViewController = rearViewController
                            mainRevealController.frontViewController = frontNavigationController
                            self.present(mainRevealController, animated: true, completion: {
                                NotificationCenter.default.post(name: .userSignedIn, object: nil)
                            })
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            //Registering FCM after signed in
                            //FireBase configure
                            if !appDelegate.fireBaseConfig {
                                
                                if FirebaseApp.app() == nil {
                                    FirebaseApp.configure()
                                }
                                
                                Messaging.messaging().delegate = appDelegate
                                //Firebase Token
                                Messaging.messaging().token { token, error in
                                    if let error = error {
                                        print("Error fetching FCM registration token: \(error)")
                                      } else if let token = token {
                                        print("FCM registration token: \(token)")
                                        appDelegate.connectToFcm()
                                        NotificationService.instance.apnToken = token
                                        NotificationService.instance.updateDeviceToken()
                                      }
                                   // Check for error. Otherwise do what you will with token here
                                    
                                }
                             
                                
                                
                            }
                        }
                    }
                }
                
            } else {
                self.hideActivityIndicator()
                print("This will not triggered any more")
                //self.showMessage(with: "Some Error Occured. Try again, Failed to create account")
                let alert = UIAlertController(title: "Registration Failed", message: "Server Error, Try to create account with alternate option", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    //self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                //self.nextBtn.isEnabled = true
                
            }
        }
    }
}
