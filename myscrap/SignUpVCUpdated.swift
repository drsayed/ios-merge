//
//  SignUpVCUpdated.swift
//  myscrap
//
//  Created by MyScrap on 11/21/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import Reachability
import Firebase
import CoreLocation
import FirebaseAuth

class SignUpVCUpdated: BaseVC {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fNameTF: ACFloatingTextfield!
    @IBOutlet weak var lNameTF: ACFloatingTextfield!
    @IBOutlet weak var emailTF: ACFloatingTextfield!
    @IBOutlet weak var showCompanyListTF: ACFloatingTextfield!
    @IBOutlet weak var diallerCodeTF: FPNTextField!
    @IBOutlet weak var mobileNoTF: ACFloatingTextfield!
    @IBOutlet weak var pwdTF: ACFloatingTextfield!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var signUpBtn: CorneredButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    fileprivate var fname:String!
    fileprivate var lname:String!
    fileprivate var mail:String!
    fileprivate var pwd:String!
    fileprivate var company:String!
    fileprivate var companyId:String!
    fileprivate var locationON:Bool!
    fileprivate var cur_lat:String!
    fileprivate var cur_long:String!
    fileprivate var counCode:String!
    fileprivate var mobileText:String!
    
    var selectedCompany: SignUPCompanyItem?{
        didSet{
            if let item = selectedCompany{
                showCompanyListTF.text = item.name
            } else {
                showCompanyListTF.text = ""
            }
        }
    }
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    
    fileprivate var isLocationEnabled: Bool{
        return LocationService.sharedInstance.isLocationEnabled()
    }
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var rightButton  = UIButton(type: .custom)      //Password Show or hide button
    var dropDownBtn = UIButton(type: .custom)
    
    var emailExist = false
    
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
        
        let theTap = UITapGestureRecognizer(target: self, action:#selector(scrollViewTapped(_:)))
        scrollView.addGestureRecognizer(theTap)
        
        //AuthService.instance.delegate = self
        
        //Phone number will be in next view controller for code verification implementation design change in Dec/17/19
        /*
        mobileNoTF.delegate = self
        diallerCodeTF.delegate = self
        diallerCodeTF.setBottomBorder()
        diallerCodeTF.parentViewController = self
        diallerCodeTF.phoneCodeTextField.text = "+971" + " ▼"
        diallerCodeTF.setFlag(for: FPNCountryCode(rawValue: "AE")!)*/
        
        
    }
    
    @objc func locationAuthorisationChanged(){
        if !isLocationEnabled {
            let alertController = UIAlertController(title: "", message: "To continue sign-up please turn on location.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            locationON = isLocationEnabled
            locationSwitch.isOn = false
        } else {
            locationON = isLocationEnabled
            locationSwitch.isOn = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fNameTF.becomeFirstResponder()
        self.fNameTF.keyboardType = .default
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        view.endEditing(true)
        
        //emailTF.text =  nil
        //pwdTF.text = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Fetching the location access
        locationAuthorisationChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(locationAuthorisationChanged), name: .locationAuthorisationChanged, object: nil)
        
        locManager.requestWhenInUseAuthorization()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func scrollViewTapped(_ recognizer: UIGestureRecognizer) {
        scrollView.endEditing(true)
    }
    
    private func setupTextfield(){
        fNameTF.delegate = self
        lNameTF.delegate = self
        emailTF.delegate = self
        pwdTF.delegate = self
        
        //Password eye icon
        rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x:0, y:0, width:30, height:30)
        
        //Company Drop Down icon
        //dropDownBtn.setImage(UIImage(named: "drop_down") , for: .normal)
        //dropDownBtn.addTarget(self, action: #selector(showCompanyList), for: .touchUpInside)
        //dropDownBtn.frame = CGRect(x:0, y:0, width:30, height:30)
        //showCompanyListTF.rightViewMode = .always
        //showCompanyListTF.rightView = dropDownBtn
        
        pwdTF.rightViewMode = .always
        pwdTF.rightView = rightButton
        pwdTF.isSecureTextEntry = true
        
        //showCompanyListTF.delegate = self
    }
    
    @objc
    func toggleShowHide(button: UIButton) {
        toggle()
    }
    
    func toggle() {
        pwdTF.isSecureTextEntry = !pwdTF.isSecureTextEntry
        if pwdTF.isSecureTextEntry {
            rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        } else {
            rightButton.setImage(UIImage(named: "password_show") , for: .normal)
        }
    }
    /*@objc
    func showCompanyList(button: UIButton){
        let vc = AddCompanyListVC()
        vc.selection = { [weak self] (item, vc) in
            vc.searchController.isActive = false
            vc.dismiss(animated: true, completion: {
                //self?.origin = item
                self?.selectedCompany = item
                self?.companyId = item.id
            })
        }
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }*/
    
    
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
    
    @IBAction func locationSwitchTap(_ sender: UISwitch) {
        locationAuthorisationChanged()
    }
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        guard let email = emailTF.text , isValidEmail(testStr: email) != false else {
            
            emailTF.showErrorWithText(errorText: "Enter Valid Email");
            return
        }
        self.pwdTF.resignFirstResponder()
        
        guard let firstName = fNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) , firstName != "" else { fNameTF.showErrorWithText(errorText: "Enter First Name");  return }
        guard let lastName = lNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) , lastName != "" else { lNameTF.showErrorWithText(errorText: "Enter Last Name"); return }
        
        guard  let password = pwdTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) , password != "" else { pwdTF.showErrorWithText(errorText: "Enter Password")
            return
        }
        self.showActivityIndicator(with: "Loading..")
        
        checkPhoneExists { (exists) in
            if !exists {
                DispatchQueue.main.async {
                    if !self.locationON {
                        self.hideActivityIndicator()
                        let alert = UIAlertController(title: "OOPS", message: "Location Service should be turned ON, Please Allow access.", preferredStyle: .alert)
                        alert.view.tintColor = UIColor.GREEN_PRIMARY
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                            //self.dismiss(animated: true, completion: nil)
                            //self.locationAuthorisationChanged()
                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                            if let currentLocation = self.locManager.location {
                                print(currentLocation.coordinate.latitude)
                                print(currentLocation.coordinate.longitude)
                                let lat = String(currentLocation.coordinate.latitude)
                                let long = String(currentLocation.coordinate.longitude)
                                self.cur_lat = lat
                                self.cur_long = long
                                if network.reachability.isReachable {
                                    self.fname = firstName
                                    self.lname = lastName
                                    self.mail = email
                                    self.pwd = password
                                    if self.cur_lat == "" && self.cur_long == "" {
                                        self.hideActivityIndicator()
                                        let alert = UIAlertController(title: "OOPS", message: "Location Service should be turned ON, Please Allow access.", preferredStyle: .alert)
                                        alert.view.tintColor = UIColor.GREEN_PRIMARY
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                                            //self.dismiss(animated: true, completion: nil)
                                            //self.locationAuthorisationChanged()
                                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    } else {
                                        if !exists {
                                            if self.emailExist {
                                                self.hideActivityIndicator()
                                                self.emailTF.showErrorWithText(errorText: "Already Email registered")
                                            } else {
                                                //Success
                                                self.hideActivityIndicator()
                                                self.performSegue(withIdentifier: "getSmsOTP", sender: self)
                                            }
                                        } else {
                                            //Success
                                            self.hideActivityIndicator()
                                            self.performSegue(withIdentifier: "getSmsOTP", sender: self)
                                        }
                                    }
                                } else {
                                    self.showMessage(with: "No Interenet Available.")
                                }
                            }
                        } else {
                            self.hideActivityIndicator()
                            let alert = UIAlertController(title: "OOPS", message: "Location Service should be turned ON, Please Allow access.", preferredStyle: .alert)
                            alert.view.tintColor = UIColor.GREEN_PRIMARY
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                                //self.dismiss(animated: true, completion: nil)
                                //self.locationAuthorisationChanged()
                                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            self.cur_lat = ""
                            self.cur_long = ""
                        }
                    }
                }
            } else {
                print("This will not triggered in email exists")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                self.emailTF.showErrorWithText(errorText: "Already Email registered")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "getSmsOTP" {
            let vc = segue.destination as? SignUpPhoneVC
            vc!.first_name = self.fname
            vc!.last_name = self.lname
            vc!.password = self.pwd
            vc!.email = self.mail
            vc!.lat = self.cur_lat
            vc!.long = self.cur_long
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    static func storyBoardInstance() -> SignUpViewController? {
        return UIStoryboard(name: StoryBoard.MAIN, bundle: nil).instantiateViewController(withIdentifier: SignUpViewController.id) as? SignUpViewController
    }
    
    public func isValidPassword(pwd: String) -> Bool {
        //6 characters
        //1 uppercase alphabet
        //1 lowercase alphabet
        //1 special character
        //1 numeral
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
        let testPwd =  NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return testPwd.evaluate(with: pwd)
    }
    typealias completionHandler = (_ exist: Bool) -> ()
    func checkPhoneExists(completion: @escaping completionHandler){
        //This function is to check the email already used in MyScrap. It will works vice versa manner
        
        let service = APIService()
        service.endPoint = Endpoints.SEND_PASSWORD_CODE
        
        service.params = "reg_email=\(self.emailTF.text!)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool {
                    if !error {
                        DispatchQueue.main.async {
                            self?.hideActivityIndicator()
                            self?.emailTF.showErrorWithText(errorText: "Already Email registered")
                        }
                        //return true
                        completion(true)
                        self?.emailExist = true
                    } else {
                        //return false
                        completion(false)
                        self?.emailExist = false
                    }
                }
            case .Error(let error):
                //self?.emailTF.showErrorWithText(errorText: "Already Email registered")
                completion(false)
                self?.emailExist = false
            }
        }
    }
    /*func checkEmailExists(email : String){
        //This function is to check the email already used in MyScrap. It will works vice versa manner
        
        let service = APIService()
        service.endPoint = Endpoints.SEND_PASSWORD_CODE
        service.params = "reg_email=\(email)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool {
                    if !error {
                        DispatchQueue.main.async {
                            self?.emailTF.showErrorWithText(errorText: "Already Email registered")
                        }
                        
                        self?.emailExist = true
                    } else {
                        self?.emailExist = false
                    }
                }
            case .Error(let error):
                //self?.emailTF.showErrorWithText(errorText: "Already Email registered")
                self?.emailExist = false
            }
        }
    }*/
    
    
}
extension SignUpVCUpdated: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fNameTF || textField == lNameTF {
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
        
        if textField == fNameTF{
            self.lNameTF.becomeFirstResponder()
        } else if textField == lNameTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF{
            if emailTF.text != "" && isValidEmail(testStr: emailTF.text!) {
                //self.checkEmailExists(email: self.emailTF.text!)
                checkPhoneExists { (exists) in
                    if !exists {
                        print("User can use this email")
                    } else {
                        print("This will not triggered in email exists")
                    }
                }
                            
            }
            pwdTF.becomeFirstResponder()
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     
        if textField == showCompanyListTF{
            let vc = AddCompanyListVC()
            vc.selection = { [weak self] (item, vc) in
                vc.searchController.isActive = false
                vc.dismiss(animated: true, completion: {
                    //self?.origin = item
                    self?.selectedCompany = item
                    self?.companyId = item.id
                })
            }
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return false
        }
        return true
     }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF {
            if emailTF.text != "" && isValidEmail(testStr: emailTF.text!) {
                //self.checkEmailExists(email: self.emailTF.text!)
                checkPhoneExists { (exists) in
                    if !exists {
                        print("User can use this email")
                    } else {
                        print("This will not triggered in email exists")
                    }
                }
            }
        }
    }
}
extension SignUpVCUpdated: FPNTextFieldDelegate{
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

extension SignUpVCUpdated: AuthServiceDelegate{
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
class UIShowHideTextField: UITextField {
    
    let rightButton  = UIButton(type: .custom)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        let rightButton  = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "password_show") , for: .normal)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x:0, y:0, width:30, height:30)
        
        rightViewMode = .always
        rightView = rightButton
        isSecureTextEntry = true
    }
    
    @objc
    func toggleShowHide(button: UIButton) {
        toggle()
    }
    
    func toggle() {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            rightButton.setImage(UIImage(named: "password_show") , for: .normal)
        } else {
            rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        }
    }
    
}
