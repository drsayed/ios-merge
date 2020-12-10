//
//  ForgotPasswordVC.swift
//  myscrap
//
//  Created by MS1 on 6/1/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ADCountryPicker

class ForgotPasswordVC: BaseVC,UITextFieldDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailInsteadBtn: UIButton!
    @IBOutlet weak var countryBorderView: CorneredView!
    @IBOutlet weak var countryLblHeight: NSLayoutConstraint!
    @IBOutlet weak var countryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectCountryTF: UITextField!
    @IBOutlet weak var phoneLbl: UILabel!
    
    @IBOutlet weak var borderMailView: CorneredView!
    @IBOutlet weak var mailTxtFld: UITextField!
    @IBOutlet weak var getCodeBtn: UIButton!
    
    var countrycode = ""
    
    var phoneVerification = true
    var emailId = ""
    var emailCode = ""
    var phoneNumber = ""
    var phoneExist = false
    
    let service = ForgotPwdService()
    let count_picker = ADCountryPicker()
    
    var bottomLine = CALayer()
    var dropDownBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        hideKeyboardWhenTappedAround()
        mailTxtFld.keyboardType = .phonePad
        
        let img = UIImage(named: "drop_down")?.withRenderingMode(.alwaysTemplate)
        dropDownBtn.setImage(img , for: .normal)
        dropDownBtn.tintColor = UIColor.black
        dropDownBtn.addTarget(self, action: #selector(showCountryList), for: .touchUpInside)
        dropDownBtn.frame = CGRect(x:0, y:0, width:30, height:35)
        selectCountryTF.rightViewMode = .always
        selectCountryTF.rightView = dropDownBtn
        
        selectCountryTF.delegate = self
        selectCountryTF.text = "United Arab Emirates (+971)"
        
        
        //Country picker customize
        /// delegate
        count_picker.delegate = self
        
        /// Optionally, set this to display the country calling codes after the names
        count_picker.showCallingCodes = true
        
        /// Flag to indicate whether country flags should be shown on the picker. Defaults to true
        count_picker.showFlags = true
        
        /// The nav bar title to show on picker view
        count_picker.pickerTitle = "Select the country"
        
        /// Flag to indicate whether the defaultCountryCode should be used even if region can be deteremined. Defaults to false
        count_picker.forceDefaultCountryCode = false
        
        /// The text color of the alphabet scrollbar. Defaults to black
        count_picker.alphabetScrollBarTintColor = UIColor.black
        
        /// The background color of the alphabet scrollar. Default to clear color
        count_picker.alphabetScrollBarBackgroundColor = UIColor.clear
        
        /// The tint color of the close icon in presented pickers. Defaults to black
        count_picker.closeButtonTintColor = UIColor.white
        
        /// The font of the country name list
        count_picker.font = UIFont(name: "Helvetica Neue", size: 15)
        
        /// The height of the flags shown. Default to 40px
        count_picker.flagHeight = 40
        
        /// Flag to indicate if the navigation bar should be hidden when search becomes active. Defaults to true
        count_picker.hidesNavigationBarWhenPresentingSearch = true
        
        /// The background color of the searchbar. Defaults to lightGray
        count_picker.searchBarBackgroundColor = UIColor.lightGray
        
        mailTxtFld.delegate = self
        
        getCodeBtn.backgroundColor = UIColor.GREEN_PRIMARY
        getCodeBtn.titleLabel?.font = Fonts.LOGIN_BTN_FONT
        
        countryBorderView.layer.cornerRadius = 5
        countryBorderView.layer.borderWidth = 2
        countryBorderView.layer.borderColor = UIColor.MyScrapGreen.cgColor
        
        borderMailView.layer.cornerRadius = 5
        borderMailView.layer.borderWidth = 2
        borderMailView.layer.borderColor = UIColor.MyScrapGreen.cgColor
        
        service.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //_ = mailTxtFld.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @objc
    func showCountryList(button: UIButton){
        let pickerNavigationController = UINavigationController(rootViewController: count_picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func emailInsteadBtn(_ sender: UIButton) {
        mailTxtFld.text = ""
        if sender.tag == 0 {
            sender.tag = 1
            phoneVerification = false
            titleLbl.text = "What's your email?"
            emailInsteadBtn.setTitle("Reset password with phone instead", for: .normal)
            countryLblHeight.constant = 0
            countryViewHeight.constant = 0
            phoneLbl.text = " Enter email address "
            mailTxtFld.keyboardType = .emailAddress
        } else {
            sender.tag = 0
            phoneVerification = true
            titleLbl.text = "What's your phone number?"
            emailInsteadBtn.setTitle("Reset password with email instead", for: .normal)
            countryLblHeight.constant = 14
            countryViewHeight.constant = 55
            phoneLbl.text = " Enter phone number "
            mailTxtFld.keyboardType = .phonePad
        }
    }
    @IBAction func getCodeBtnPressed(_ sender: Any) {
        if phoneVerification {
            if let phone = mailTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) , phone != "" {
                showActivityIndicator(with: "Sending...")
                phoneNumber = phone
                if countrycode == "" {
                    countrycode = "+971"
                }
                //DispatchQueue.main.async {
                    self.getAndVerifyPhone()
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if !appDelegate.fireBaseConfig {
                        
                        if FirebaseApp.app() == nil {
                            FirebaseApp.configure()
                        }
                    }
                    
                //}
            } else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                let alertVC = UIAlertController(title: "OOPS",message: "Please enter the phone number.",preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            }
            
        } else {
            
            
            if let email = mailTxtFld.text, email != "" , isValidEmail(testStr: email) {
                DispatchQueue.main.async {
                    self.showActivityIndicator(with: "Checking")             //(Maha Manual edit)
                }
                getAndVerifyEmail()
            } else if mailTxtFld.text != "" {
                //mailTxtFld.showErrorWithText(errorText: "Please enter a valid email.")
                let alertVC = UIAlertController(title: "OOPS",message: "Please enter the email.",preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            } else {
                let alertVC = UIAlertController(title: "OOPS",message: "Please enter a valid email.",preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            }
        }
    }
    
    func getAndVerifyEmail() {
        emailId = self.mailTxtFld.text!
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
                                    self?.performSegue(withIdentifier: "sendOTP", sender: self)
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

    func getAndVerifyPhone() {
        let service = APIService()
        service.endPoint = Endpoints.VERIFY_EMAIL_OR_PHONE
        service.params = "reg_email=&reg_mobile=\(phoneNumber)&countryCode=\(countrycode)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                let error = dict["error"] as! Bool
                if !error {
                    let status = dict["status"] as! String
                    if status == "Phone number exist"  {
                        self?.phoneExist = true
                        DispatchQueue.main.async {
                            let phoneNumber = self!.countrycode + (self?.mailTxtFld.text!)!
                            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                                if let error = error {
                                    DispatchQueue.main.async {
                                        self?.hideActivityIndicator()
                                    }
                                    print("My phone : \(phoneNumber)")
                                    print("error from Firebase: \(error.localizedDescription)")
                                    //let alertVC = UIAlertController(title: "OOPS",message: error.localizedDescription, preferredStyle: .alert)
                                    let alertVC = UIAlertController(title: "OOPS",message: "Not a valid phone number", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                                    alertVC.addAction(okAction)
                                    self?.present(alertVC,animated: true,completion: nil)
                                    return
                                } else {
                                    
                                    self?.performSegue(withIdentifier: "sendOTP", sender: self)
                                    UserDefaults.standard.set(verificationID, forKey: "FPauthVerificationID")
                                    DispatchQueue.main.async {
                                        self?.hideActivityIndicator()
                                    }
                                }
                                // Sign in using the verificationID and the code sent to the user
                                // ...
                                
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.hideActivityIndicator()
                        }
                        let alert = UIAlertController(title: "OOPS", message: status, preferredStyle: .alert)
                        alert.view.tintColor = UIColor.GREEN_PRIMARY
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                            //self.dismiss(animated: true, completion: nil)
                        }))
                        self?.present(alert, animated: true, completion: nil)
                        self?.phoneExist = false
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self?.hideActivityIndicator()
                    }
                    let status = dict["status"] as! String
                    
                    let alert = UIAlertController(title: "OOPS", message: status, preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        //self.dismiss(animated: true, completion: nil)
                    }))
                    self?.present(alert, animated: true, completion: nil)
                    self?.phoneExist = false
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                }
                let alert = UIAlertController(title: "Server Error", message: error, preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    //self.dismiss(animated: true, completion: nil)
                }))
                self?.present(alert, animated: true, completion: nil)
                self?.phoneExist = false
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    static func storyBoardInstance() -> ForgotPasswordVC?{
        return UIStoryboard(name: StoryBoard.MAIN, bundle: nil).instantiateViewController(withIdentifier: ForgotPasswordVC.id) as? ForgotPasswordVC
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sendOTP" {
            /*if let vc = segue.destination as? VerificationCodeVC {
                vc.email = self.mailTxtFld.text!
            }*/
            if let vc = segue.destination as? FPVerificationVC {
                vc.phoneVerification = phoneVerification
                if phoneVerification {
                    vc.comb_phone = countrycode + "-" + mailTxtFld.text!
                    vc.phoneNumber = countrycode + mailTxtFld.text!
                } else {
                    vc.emailId = mailTxtFld.text!
                    vc.emailCode = self.emailCode
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == mailTxtFld {
            if phoneVerification {
                
            } else {
                if let email = mailTxtFld.text, email != "" , isValidEmail(testStr: email) {
                    service.sendEmailCode(email: email)
                } else if mailTxtFld.text != "" {
                    //mailTxtFld.showErrorWithText(errorText: "Please enter a valid email.")
                    let alertVC = UIAlertController(title: "OOPS",message: "Please enter the email.",preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC,animated: true,completion: nil)
                } else {
                    let alertVC = UIAlertController(title: "OOPS",message: "Please enter a valid email.",preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC,animated: true,completion: nil)
                }
            }
            
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mailTxtFld{
            if phoneVerification {
                let maxLength = 10
                let minimumLength = 7
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            } else {
                return true
            }
            
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == selectCountryTF{
            let pickerNavigationController = UINavigationController(rootViewController: count_picker)
            self.present(pickerNavigationController, animated: true, completion: nil)
            return false
        }
        return true
    }

}
extension ForgotPasswordVC : ForgotPwdDelegate {
    func didReceiveResponse(message: String) {
        DispatchQueue.main.async {
            if message == "Email has been Sent to your Given mail ID." {
                self.hideActivityIndicator()
                self.performSegue(withIdentifier: "sendOTP", sender: self)
            }
        }
    }
    
    func didReceiveError(error: String) {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            let alertVC = UIAlertController(title: "OOPS",message: error,preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC,animated: true,completion: nil)
        }
    }
}
extension ForgotPasswordVC : ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print("Picker value Name : \(name) \nCode : \(code) \nDial code : \(dialCode)")
        selectCountryTF.text = name + " (" + dialCode + ")"
        countrycode = dialCode
        self.dismiss(animated: true, completion: nil)
    }
}
