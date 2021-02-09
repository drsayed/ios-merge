//
//  SignInViewController.swift
//  myscrap
//
//  Created by MS1 on 5/31/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import CoreData
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import RealmSwift
import Firebase
    
class SignInViewController: BaseVC, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var emailTextField: ACFloatingTextfield!
    @IBOutlet weak var passwordTextField: ACFloatingTextfield!
    @IBOutlet weak var guestUserBtn: UIButton!
    @IBOutlet weak var loginBtn:UIButton!
    @IBOutlet weak var forgotPwdButton:UIButton!
    @IBOutlet weak var noAccountLbl:UILabel!
    @IBOutlet weak var signupBtn:UIButton!
    @IBOutlet weak var gmailSignUp: UIButton!
    
    var email = ""
    var phone = ""
    var password:String!
    var activeField: ACFloatingTextfield?
    var user_lists : Results<Conversation>!
    
    var rightButton  = UIButton(type: .custom)      //Password Show or hide button
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
//        emailTextField.isTracking = true
//        passwordTextField.
    
        try! uiRealm.write {
            uiRealm.delete(uiRealm.objects(UserPrivChat.self))
        }
        
        
        setupViews()
        AuthStatus.instance.isGuest = false
        
        //error object
        var error : NSError?
        
        //setting the error
        //GGLContext.sharedInstance().configureWithError(&error)
        
        //if any error stop execution and print error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        
        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //Get the Database Path
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        //XMPP connection not established, initiating here
        XMPPService.instance.connectEst = false
        
        //Password eye icon
        rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x:0, y:0, width:30, height:30)
        
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = rightButton
        passwordTextField.isSecureTextEntry = true
    }
    
    @objc
    func toggleShowHide(button: UIButton) {
        toggle()
    }
    
    func toggle() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        } else {
            rightButton.setImage(UIImage(named: "password_show") , for: .normal)
        }
    }
    
    //MARK:- VIEW DID DISAPPEAR
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.deletecoredata()
        
        //Getting back the stored credentials
        let storedEmail = UserDefaults.standard.object(forKey: "storedEmail") as? String
        let storedPwd = UserDefaults.standard.object(forKey: "storedPassword") as? String
        
        if storedEmail != "" && storedPwd != "" {
            self.emailTextField.text = storedEmail
            self.passwordTextField.text = storedPwd
            
        } else {
            print("No stored email and password found!!!")
        }
    }
    
    //MARK:- VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(false)
        view.endEditing(true)
    }
    
    //MARK :- VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AuthService.instance.delegate = self
        //emailTextField.becomeFirstResponder()
    }
    
    
    // MARK:- SETUPVIEWS
    private func setupViews(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.autocapitalizationType = .words
        loginBtn.backgroundColor = UIColor.GREEN_PRIMARY
        forgotPwdButton.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        forgotPwdButton.titleLabel?.text = "Forgot Passord ?"
        noAccountLbl.textColor = UIColor.gray
        signupBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        //guestUserBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        loginBtn.titleLabel?.font = Fonts.LOGIN_BTN_FONT
    }
    
    @IBAction func loginbuttonPressed(_ sender: Any) {
        view.endEditing(true)
        
        if (emailTextField.text?.isEmpty)!  && (passwordTextField.text?.isEmpty)! {
            emailTextField.showErrorWithText(errorText: "Phone or Email is required")
            passwordTextField.showErrorWithText(errorText: "Password is required")
        } else if (passwordTextField.text?.isEmpty)!{
            passwordTextField.showErrorWithText(errorText: "Password is required")
        } else if (emailTextField.text?.isEmpty)!{
            emailTextField.showErrorWithText(errorText: "Phone or Email is required")
        }
        else {
            if !isValidEmail(testStr: emailTextField.text!) && isNumeric(phoneNumber: emailTextField.text!) {
                //Phone number is valid
                phone = emailTextField.text!
                self.initiateSignIn()
            } else if isValidEmail(testStr: emailTextField.text!) && !isNumeric(phoneNumber: emailTextField.text!) {
                //Email id is valid
                email = emailTextField.text!
                self.initiateSignIn()
            } else if !isValidEmail(testStr: emailTextField.text!) && !isNumeric(phoneNumber: emailTextField.text!) {
                //Both are not valid have to error text field
                emailTextField.showErrorWithText(errorText: "Enter Valid Phone/Email")
            } else {
                self.showToast(message: "Validation error")
            }
        }
    }
    
    func initiateSignIn() {
        password = passwordTextField.text
        
        //Storing email/phone and password for every time in login
        UserDefaults.standard.set(emailTextField.text!, forKey: "storedEmail")
        UserDefaults.standard.set(password, forKey: "storedPassword")
        
        //            let reachability = Reachability()!
        //            if reachability.connection != .none{
        DispatchQueue.main.async {
            self.showActivityIndicator(with: "Signing In")             //(Maha Manual edit)
        }
        if !AuthService.instance.isDeviceRegistered{
            AuthService.instance.deviceRegistration(completion: { _ in
                if AuthService.instance.isDeviceRegistered{
                    AuthService.instance.SiginInUser(regEmail: self.email, password: self.password, regMobile: self.phone)
                } else {
                    DispatchQueue.main.async {
                    self.showMessage(with: "Device is not registered")
                    }
                }
                
            })
        } else {
            AuthService.instance.SiginInUser(regEmail: self.email, password: self.password, regMobile: self.phone)
        }
    }

    
    @IBAction func ForgotPasswordPressed(_ sender: Any) {
        if let vc = ForgotPasswordVC.storyBoardInstance(){
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let vc = SignUpViewController.storyBoardInstance(){
            //present(vc, animated: true, completion: nil)
            //self.pushViewController(storyBoard: "MAIN", Identifier: SignUpViewController.id)
            //self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func deletecoredata(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<Message> = Message.fetchRequest()
        let fetchRequest2:NSFetchRequest<Member> = Member.fetchRequest()
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2 as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
            try context.execute(batchDeleteRequest2)
            try context.save()
        } catch let err as NSError{
            // Error Handlin
            fatalError("\(err.userInfo)")
        }
    }
    
    
    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isNumeric(phoneNumber: String) -> Bool {
        guard phoneNumber.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+"]
        return Set(phoneNumber).isSubset(of: nums)
    }
    
    /*public func isValidPhoneNumber(phoneNumber: String) -> Bool {
        //let phoneNumberRegex = "(?:(\\+\\d\\d\\s+)?((?:\\(\\d\\d\\)|\\d\\d)\\s+)?)(\\d)"
        // Regex explanation - > \\d 0-9 digits
        // ? ->
        let phoneNumberRegex = "^\\d$"
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        print("No trim required : \(trimmedString)")
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    @IBAction func guestUserClicked(_ sender: UIButton) {
        print("Guest user Clicked")
        AuthStatus.instance.isGuest = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    let loginManager = LoginManager()
    @IBAction func fbLoginTapped(_ sender: Any) {
        //let feed = FeedController()
        loginManager.loginBehavior = .native
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            
            
            switch result {
            case .failed(let error):
                print("facebook error")
                print(error.localizedDescription)
            case .cancelled:
                print("user Cancelled Login")
            case .success(_):
                print("FB get data" )
                
                self.getFBUserData()
            }
        }
    }
    
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
//            let vc = SignInViewController()
//            vc.hidesBottomBarWhenPushed = true
//            self.didSuccessAuthService(status: true)
            //self.pushViewController(storyBoard: StoryBoard.MAIN, Identifier: FeedController.id)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,first_name,last_name,picture.type(large),email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil){
                    print("Result from fb login : \(result)")
                    
                    if let dict = result as? [String: AnyObject], let email = dict["email"] as? String, let fname = dict["first_name"] as? String, let lastname = dict["last_name"] as? String, let fid = dict["id"] as? String{
                        print("email",email,"fname",fname,"lastname",lastname)
                        var url = ""
                        if let imageURL = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                            url = imageURL
                        }
                        //self.didSuccessAuthService(status: true)
                        //AuthService.instance.userId = "1"
                        self.showActivityIndicator(with: "Signinig In With Facebook")
                        
                        LoginManager().logOut()
                        
                        if AuthService.instance.isDeviceRegistered{
                            AuthService.instance.signInWithFacebook(email: email, password: UUID().uuidString, firstName: fname, lastName: lastname, fid: fid, url: url, completion: { (result) in
                                
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                    switch result{
                                    case .Error(let err):
                                        self.hideActivityIndicator()
                                        self.showMessage(with: err)
                                    case .Success(_):
                                        print("Success")
                                        AuthService.instance.isFacebookUser = true
                                        
                                    }
                                }
                            })
                        } else {
                            AuthService.instance.deviceRegistration(completion: { (_) in
                                if AuthService.instance.isDeviceRegistered{
                                    AuthService.instance.signInWithFacebook(email: email, password: UUID().uuidString, firstName: fname, lastName: lastname, fid: fid, url: url, completion: { (result) in
                                        DispatchQueue.main.async {
                                            self.hideActivityIndicator()
                                            switch result{
                                            case .Error(let err):
                                                self.hideActivityIndicator()
                                                self.showMessage(with: err)
                                            case .Success(_):
                                                print("Success")
                                                
                                            }
                                        }
                                    })
                                } else {
                                    self.showMessage(with: "Error")
                                }
                            })
                        }
                    } else if let dict = result as? [String: AnyObject], let fname = dict["first_name"] as? String, let lastname = dict["last_name"] as? String, let fid = dict["id"] as? String{
                        ///If sign in with Mobile number, email will not be fetched from FB so instead email using fid to login
                        print("fname",fname,"lastname",lastname,"FBId",fid)
                        var url = ""
                        if let imageURL = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                            url = imageURL
                        }
                        //self.didSuccessAuthService(status: true)
                        //AuthService.instance.userId = "1"
                        self.showActivityIndicator(with: "Signinig In With Facebook")
                        
                        LoginManager().logOut()
                        
                        if AuthService.instance.isDeviceRegistered{
                            AuthService.instance.signInWithFacebook(email: fid, password: UUID().uuidString, firstName: fname, lastName: lastname, fid: fid, url: url, completion: { (result) in
                                
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                    switch result{
                                    case .Error(let err):
                                        self.hideActivityIndicator()
                                        self.showMessage(with: err)
                                    case .Success(_):
                                        print("Success")
                                        
                                    }
                                }
                            })
                        } else {
                            AuthService.instance.deviceRegistration(completion: { (_) in
                                if AuthService.instance.isDeviceRegistered{
                                    AuthService.instance.signInWithFacebook(email: fid, password: UUID().uuidString, firstName: fname, lastName: lastname, fid: fid, url: url, completion: { (result) in
                                        DispatchQueue.main.async {
                                            self.hideActivityIndicator()
                                            switch result{
                                            case .Error(let err):
                                                self.hideActivityIndicator()
                                                self.showMessage(with: err)
                                            case .Success(_):
                                                print("Success")
                                                
                                            }
                                        }
                                    })
                                } else {
                                    self.showMessage(with: "Error")
                                }
                            })
                        }
                    } else {
                        self.showMessage(with: "Unable to Sign in...")
                    }
                    
                } else {
                    print(error?.localizedDescription)
                    print("Fab error")
                }
            })
        }
    }
    
    //Google Sign up
    @IBAction func gmailSignupTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            
            print("Gmail : \(email)")
        }
    }
    
    //MARK:- Push View Controller
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let rearViewController = MenuTVC()
        let frontNavigationController = UINavigationController(rootViewController: vc)
        let mainRevealController = SWRevealViewController()
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        self.present(mainRevealController, animated: true, completion: {
            NotificationCenter.default.post(name: .userSignedIn, object: nil)
        })
    }
}


// MARK:- Delegates handling network calls
extension SignInViewController: AuthServiceDelegate{
    func didSuccessDeviceRegistration(status: Bool, message: String) {
        DispatchQueue.main.async {
            if status{
                AuthService.instance.SiginInUser(regEmail: self.email, password: self.password, regMobile: self.phone)
            } else {
                self.hideActivityIndicator()
                self.showMessage(with: "Some Error occured please try again!")
            }
        }
    }
    
    
    func didSuccessAuthService(status: Bool) {
        DispatchQueue.main.async {
            if status {
                
                if AuthStatus.instance.isLoggedIn{
                    if let jid = AuthService.instance.userJID {
                        print("User name and ID in Sign in : \(AuthService.instance.firstname), \(AuthService.instance.userId)")
                        if XMPPService.instance.xmppStream?.isConnecting() == false && XMPPService.instance.xmppStream?.isConnected() == false && XMPPService.instance.xmppStream?.isAuthenticating() == false && XMPPService.instance.xmppStream?.isAuthenticated() == false {
                            
                            if !XMPPService.instance.connectEst {
                                XMPPService.instance.connect(with: jid)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    XMPPService.instance.sendOnline()
                                }
                            }
                        } else {
                            print("XMPP already conneccted in Sign in")
                        }
                    }
                }
                
                //Maha added manually to navigate Feed controller after login
                //let protectedPage = self.storyboard?.instantiateViewController(withIdentifier: "FeedsVC") as! FeedsVC
                //let vc = MarketVC.storyBoardInstance()!
                //let protectedPage = self.storyboard?.instantiateViewController(withIdentifier: "LandHomePageVC") as! LandHomePageVC
                let protectedPage = self.storyboard?.instantiateViewController(withIdentifier: "FeedsVC") as! FeedsVC
                //let vc = LandHomePageVC.storyBoardInstance()!
                //Market Adv popup will not show when login
                protectedPage.showPopup = false
                protectedPage.isSignedIn = true
                //protectedPage.showCovidPoll = true
                //vc.isSignedIn = true
                let rearViewController = MenuTVC()
                let protectedNav = UINavigationController(rootViewController: protectedPage)
                //let protectedNav = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = protectedNav
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = mainRevealController
                
                //Registering FCM after signed in
                //FireBase configure
                if !appDelegate.fireBaseConfig {
                    if FirebaseApp.app() == nil {
                        FirebaseApp.configure()
                    }
                    //FirebaseApp.configure()
                    
                    Messaging.messaging().delegate = appDelegate
                    //Firebase Token
                    Messaging.messaging().token { token, error in
                       // Check for error. Otherwise do what you will with token here
                        if let error = error {
                            print("Error fetching FCM registration token: \(error)")
                          } else if let token = token {
                            NotificationService.instance.apnToken = token
                            appDelegate.connectToFcm()
                            NotificationService.instance.updateDeviceToken()
                          }
                    
                    }
                }
                else {
                    
                }
                
                
            } else {
                ///self.hideActivityIndicator()
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showMessage(with: "Some Error occured please try again!")
                }
                
            }
        }
    }
    
    func didFailure(error: String) {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            //self.showMessage(with: error)
            let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    static func storyBoardInstance() -> SignInViewController?{
        let st = UIStoryboard.MAIN
        return st.instantiateViewController(withIdentifier: SignInViewController.id) as? SignInViewController
    }
}


extension SignInViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField as? ACFloatingTextfield
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}


