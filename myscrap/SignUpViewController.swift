//
//  SignUpViewController.swift
//  myscrap
//
//  Created by MS1 on 6/1/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import GoogleSignIn
import FlagPhoneNumber
import Reachability
import Firebase

class SignUpViewController: BaseVC{

    var activeField:ACFloatingTextfield?
    
    @IBOutlet weak var firstNameTxtfld: ACFloatingTextfield!
    @IBOutlet weak var lastNameTxtFld: ACFloatingTextfield!
    @IBOutlet weak var emailTxtFld: ACFloatingTextfield!
    @IBOutlet weak var passwordTxtFld: ACFloatingTextfield!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextBtn:UIButton!
    @IBOutlet weak var loginBtn:UIButton!
    @IBOutlet weak var countryCodeTF: FPNTextField!
    @IBOutlet weak var mobileNoTF: ACFloatingTextfield!
    
    fileprivate var fname:String!
    fileprivate var lname:String!
    fileprivate var mail:String!
    fileprivate var pwd:String!
    fileprivate var counCode:String!
    fileprivate var mobileText:String!

    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        //XMPP connection not established, initiating here
        XMPPService.instance.connectEst = false
        
        // Do any additional setup after loading the view.
        setupKeyboardObservers()
        
        //Setup Textfields
        setupTextfield()
        
        //Setup Buttons
        setupButtons()
        
        let theTap = UITapGestureRecognizer(target: self, action:#selector(scrollViewTapped(_:)))
        scrollView.addGestureRecognizer(theTap)
        
        AuthService.instance.delegate = self
        
        mobileNoTF.delegate = self
        countryCodeTF.delegate = self
        countryCodeTF.setBottomBorder()
        countryCodeTF.parentViewController = self
        countryCodeTF.phoneCodeTextField.text = "+971" + " ▼"
        //countryCodeTF.isUserInteractionEnabled = false
        countryCodeTF.setFlag(for: FPNCountryCode(rawValue: "AE")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.firstNameTxtfld.becomeFirstResponder()
        self.firstNameTxtfld.keyboardType = .default
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func scrollViewTapped(_ recognizer: UIGestureRecognizer) {
        scrollView.endEditing(true)
    }
    
    private func setupTextfield(){
        firstNameTxtfld.delegate = self
        lastNameTxtFld.delegate = self
        emailTxtFld.delegate = self
        passwordTxtFld.delegate = self
    }
    
    private func setupButtons(){
        nextBtn.backgroundColor = UIColor.GREEN_PRIMARY
        loginBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        nextBtn.titleLabel?.font = Fonts.LOGIN_BTN_FONT
    }
    
    private func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name:UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillHide(notification:NSNotification){
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc private func handleKeyboardWillShow(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 10 , right: 0)
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        self.passwordTxtFld.resignFirstResponder()
    
        guard let firstName = firstNameTxtfld.text?.trimmingCharacters(in: .whitespacesAndNewlines) , firstName != "" else { firstNameTxtfld.showErrorWithText(errorText: "Enter First Name");  return }
        guard let lastName = lastNameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) , lastName != "" else { lastNameTxtFld.showErrorWithText(errorText: "Enter Last Name"); return }
        guard let email = emailTxtFld.text , isValidEmail(testStr: email) != false else { emailTxtFld.showErrorWithText(errorText: "Enter Valid Email");  return }
        guard  let password = passwordTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) , password != "" else { passwordTxtFld.showErrorWithText(errorText: "Enter Password")
            return
        }
        guard let mobile = mobileNoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) , mobile != "" else { mobileNoTF.showErrorWithText(errorText: "Enter Mobile number");  return }
        guard let validate = mobileNoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) , validate != "" else { mobileNoTF.showErrorWithText(errorText: "Enter Mobile number");  return }
        
        
//        let reachability = Reachability()!
//        if reachability.connection != .none{
        if network.reachability.isReachable {
            showActivityIndicator(with: "Loading...")
            self.nextBtn.isEnabled = false
            fname = firstName
            lname = lastName
            mail = email
            pwd = password
            mobileText = mobile
            showActivityIndicator(with: "Loading..")
            
            if mobileText.length <= 7 {
                mobileNoTF.showErrorWithText(errorText: "Invalid number");
                self.nextBtn.isEnabled = true
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                
            } else {
                if AuthService.instance.isDeviceRegistered{
                    AuthService.instance.signUpUser(mail: mail, pwd: pwd, fname: fname, lname: lname, ccode: counCode, mobile: mobileText)
                } else {
                    AuthService.instance.deviceRegistration { _ in
                        if AuthService.instance.isDeviceRegistered{
                            AuthService.instance.signUpUser(mail: self.mail, pwd: self.pwd, fname: self.fname, lname: self.lname, ccode: self.counCode, mobile: self.mobileText)
                        }
                    }
                }
            }
//            self.performSegue(withIdentifier: "signupSegue", sender: sender)
        } else {
            self.showMessage(with: "No Interenet Available.")
        }
    }
    @IBAction func signupSetup(_ sender: UIButton) {
        
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "signupSegue" {
//            if let vc = segue.destination as? MainSignUpVC {
//                vc.firstName = fname
//                vc.lastName = lname
//                vc.email = mail
//                vc.pwd = pwd
//
//            }
//        }
//    }
    static func storyBoardInstance() -> SignUpViewController? {
        return UIStoryboard(name: StoryBoard.MAIN, bundle: nil).instantiateViewController(withIdentifier: SignUpViewController.id) as? SignUpViewController
    }
}




extension SignUpViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTxtfld || textField == lastNameTxtFld {
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }
        if textField == mobileNoTF{
            let maxLength = 10
            let minimumLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTxtfld{
            self.lastNameTxtFld.becomeFirstResponder()
        } else if textField == lastNameTxtFld {
            emailTxtFld.becomeFirstResponder()
        } else if textField == emailTxtFld{
            passwordTxtFld.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    fileprivate func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /*func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCodeTF {
            return false; //do not show keyboard nor cursor
        }
        return true;
    }*/
}

/*extension SignUpViewController: AuthServiceDelegate{
    func didFailure(error: String) {
        print(error)
        self.hideActivityIndicator()
        self.showMessage(with: error)
    }
    
    func didSuccessDeviceRegistration(status: Bool, message: String) {
        if status{
            AuthService.instance.isDeviceRegistered = true
            AuthService.instance.signUpUser(mail: mail, pwd: pwd, fname: fname, lname: lname, ccode: <#String#>, mobile: <#String#>)
        } else {
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.showMessage(with: "Some Error Occured. Try again. \(message)")
            }
        }
    }
    
    func didSuccessAuthService(status: Bool) {
        DispatchQueue.main.async {
            if status{
                if let vc = FeedsVC.storyBoardInstance(){
                    self.hideActivityIndicator()
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    self.present(mainRevealController, animated: true, completion: {
                        NotificationCenter.default.post(name: .userSignedIn, object: nil)
                    })
                }
            } else {
                self.hideActivityIndicator()
                self.showMessage(with: "Some Error Occured. Try again")
                //self.nextBtn.isEnabled = true
            }
        }
    }
}*/
extension SignUpViewController: FPNTextFieldDelegate{
    func fpnDidSelectCountry(name: String, dialCode: String, code: String, textField: UITextField) {
        self.counCode = dialCode
        print("This is from Signup", name, dialCode, code)
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print(isValid)
    }
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        //self.countryCodeTF.text = dialCode
        self.counCode = dialCode
        print(name, dialCode, code)
    }
}

extension SignUpViewController: AuthServiceDelegate{
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
            self.nextBtn.isEnabled = true
        }
    }
    
    func didSuccessDeviceRegistration(status: Bool, message: String) {
        if status{
            AuthService.instance.isDeviceRegistered = true
            AuthService.instance.signUpUser(mail: mail, pwd: pwd, fname: fname, lname: lname, ccode: counCode, mobile: mobileText)
        } else {
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.showMessage(with: "Some Error Occured. Try again. \(message)")
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
                        if let vc = FeedsVC.storyBoardInstance(){
                            self.hideActivityIndicator()
                            
                            //Market Adv show pop up
                            vc.showPopup = true
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
                self.showMessage(with: "Some Error Occured. Try again")
                //self.nextBtn.isEnabled = true
                
            }
        }
    }
}
