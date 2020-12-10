//
//  AuthService.swift
//  myscrap
//
//  Created by MS1 on 9/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

protocol AuthServiceDelegate: class {
    func didSuccessDeviceRegistration(status: Bool, message: String)
    func didSuccessAuthService(status: Bool)
    func didFailure(error: String)
}

final class AuthService{
    
    weak var delegate: AuthServiceDelegate?
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isCoreDataCleared: Bool{
        get {
            return defaults.bool(forKey: UserDefaults.isCoreDataCleared)
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.isCoreDataCleared)
        }
        
    }
    
    var currentJID: String? {
        get {
            return defaults.value(forKey: UserDefaults.CURRENT_JID) as? String
        } set {
            defaults.set(newValue, forKey: UserDefaults.CURRENT_JID)
        }
    }
    
    
    var userId: String {
        get {
            return defaults.value(forKey: UserDefaults.USER_ID) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.USER_ID)
        }
    }
    var profilePic: String{
        get {
            return defaults.value(forKey: UserDefaults.PROFILE_PIC) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.PROFILE_PIC)
        }
    }
    var bigProfilePic: String?{
        get {
            return defaults.value(forKey: UserDefaults.BIG_PROFILE_PIC) as? String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.BIG_PROFILE_PIC)
        }
    }
    var email: String{
        get {
            return defaults.value(forKey: UserDefaults.EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.EMAIL)
        }
    }
    var mobile: String{
        get {
            return defaults.value(forKey: UserDefaults.MOBILE) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.MOBILE)
        }
    }
    var firstname: String{
        get {
            return defaults.value(forKey: UserDefaults.FIRST_NAME) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.FIRST_NAME)
        }
    }
    var lastName: String{
        get {
            return defaults.value(forKey: UserDefaults.LAST_NAME) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.LAST_NAME)
        }
    }
    var password: String{
        get {
            return defaults.value(forKey: UserDefaults.PASSWORD) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.PASSWORD)
        }
    }
    var colorCode: String{
        get {
            return defaults.value(forKey: UserDefaults.COLOR_CODE) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.COLOR_CODE)
        }
    }
    var logUserRank: String{
        get {
            return defaults.value(forKey: UserDefaults.LOG_USER_RANK) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.LOG_USER_RANK)
        }
    }
    var logScore: String{
        get {
            return defaults.value(forKey: UserDefaults.LOG_SCORE) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.LOG_SCORE)
        }
    }
    var followersPoints: Int{
        get {
            return defaults.value(forKey: UserDefaults.FOLLOWERS_COUNT) as? Int ?? 0
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.FOLLOWERS_COUNT)
        }
    }
    var userRank: String{
        get {
            return defaults.value(forKey: UserDefaults.USER_RANK) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.USER_RANK)
        }
    }
    var company: String{
        get {
            return defaults.value(forKey: UserDefaults.COMPANY) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.COMPANY)
        }
    }
    var companyId: String{
        get {
            return defaults.value(forKey: UserDefaults.COMPANY_ID) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.COMPANY_ID)
        }
    }
    var companyCountryID: String{
        get {
            return defaults.value(forKey: UserDefaults.COMPANY_COUNTRY_ID) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.COMPANY_COUNTRY_ID)
        }
    }
    var designation: String{
        get {
            return defaults.value(forKey: UserDefaults.DESIGNATION) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.DESIGNATION)
        }
    }
    var isNewJoined: Bool{
        get {
            return defaults.bool(forKey: "newJoined")
        }
        set {
            defaults.set(newValue, forKey: "newJoined")
        }
    }
    var isFacebookUser: Bool{
        get {
            return defaults.bool(forKey: "facebookUser")
        }
        set {
            defaults.set(newValue, forKey: "facebookUser")
        }
    }
    var isDeviceRegistered: Bool{
            get {
                return defaults.bool(forKey: "mobilesecurity")
            }
            set {
                defaults.set(newValue, forKey: "mobilesecurity")
            }
    }
    
    var isFCMUpdated: Bool{
        get {
            return defaults.bool(forKey: "isFCMUpdated")
        }
        set {
            defaults.set(newValue, forKey: "isFCMUpdated")
        }
    }
    
    var userJID: String? {
        get {
            return defaults.value(forKey: UserDefaults.XMPPJID) as? String
        } set {
            defaults.set(newValue, forKey: UserDefaults.XMPPJID)
        }
    }
    
    /*var removeData: Bool? {
        get {
            return defaults.bool(forKey: UserDefaults.IS_LOGGED_OUT)
        } set {
            defaults.set(newValue, forKey: UserDefaults.IS_LOGGED_OUT)
        }
    }*/
    
    
    var fullName: String{
        return "\(firstname) \(lastName)"
    }
    
    var initial: String? {
        print("Now shiit: \(fullName.initials())")
        return "\(fullName.initials())"
    }
    /*func removeRegistrationDetails(profilePic: String,loggedOut: Bool) {
        if loggedOut == true && profilePic == "" {
            
        }
        else if loggedOut == true && profilePic == UserDefaults.PROFILE_PIC {
            defaults.removeObject(forKey: UserDefaults.PROFILE_PIC)
            removeData = loggedOut
            print("Removed profile image", removeData)
        }
        
    }*/
    
    private func updateRegistrationDetails(email: String, mobile: String, firstName: String, lastName: String, password: String, profilePic: String, bigProfilePic: String,userId: String, colorCode: String, loggedIn: Bool, userJID: String? = nil, userRank: String, company: String, designation : String, points: String, companyId: String, followersCount: Int){
        self.email = email
        self.mobile = mobile
        self.firstname = firstName
        self.lastName = lastName
        self.password = password
        self.profilePic = profilePic
        self.bigProfilePic = bigProfilePic
        self.userId = userId
        self.colorCode = colorCode
        self.userJID = userJID
        self.logUserRank = userRank
        self.company = company
        self.designation = designation
        self.logScore = points
        self.companyId  = companyId
        AuthStatus.instance.isLoggedIn = loggedIn
        self.followersPoints = followersCount
    }
    
    
    func registerSignInDetails(email: String, firstName: String, lastName: String, password: String, profilePic: String, bigProfilePic : String,userId: String, colorCode: String, loggedIn: Bool, userJID: String? = nil, followersCount: Int){
        self.email = email
        self.firstname = firstName
        self.lastName = lastName
        self.password = password
        self.profilePic = profilePic
        self.bigProfilePic = bigProfilePic
        self.userId = userId
        self.colorCode = colorCode
        self.userJID = userJID
        self.followersPoints = followersCount

        
//        print(loggedIn)

    }
    
    
    //MARK:- DEVICE REGISTRATION
    func deviceRegistration(completion: @escaping (Bool) -> () ){
        let service = APIService()
        service.endPoint = Endpoints.MOBILE_SECURITY_URL
        service.params = "apiKey=\(API_KEY)&mobileDevice=\(MOBILE_DEVICE)&mobileBrand=\(BRAND_NAME)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                let status = dict["status"] as? String
                if let error = dict["error"] as? Bool{
                    if !error{
                        AuthService.instance.isDeviceRegistered = true
                        completion(true)
                    } else {
                        self!.showToast(message: status!)
                        print("Device not registered : \(String(describing: status))")
                        completion(false)
                    }
                } else {
                    self!.showToast(message: status!)
                    print("Device not registered : \(String(describing: status))")
                    completion(false)
                }
                case .Error(_):
                    
                completion(false)
            }
        }
    }
    
    
    
    //MARK:- SIGN IN FUNCTION
    func SiginInUser(regEmail: String, password: String, regMobile: String){
        let service = APIService()
        service.endPoint = Endpoints.LOGIN_URL_UPDATED
        let addr = getIFAddresses()
        var ip = ""
        print("ip address found : \(addr)")
        if addr.count > 0 {
            ip = addr.first!
            print("fetched & sent : \(ip)")
        }
        print(service.endPoint)
        
        //service.params = "ipAddress=\(ip)&userName=\(userName)&password=\(password)&device=\(MOBILE_DEVICE)&apiKey=\(API_KEY)"
        //regMobile -> email/phone
        service.params = "ipAddress=\(ip)&regEmail=\(regEmail)&password=\(password)&device=\(MOBILE_DEVICE)&apiKey=\(API_KEY)&regMobile=\(regMobile)".replacingOccurrences(of: "+", with: "%2B")
        print(service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                let error = dict["error"] as? Bool
                let status = dict["status"] as? String
                if error!{
                    print(status as Any)
                    self?.delegate?.didFailure(error: status!)
                } else {
                    
                    self?.handleAuthDetails(json: dict)             //JID stored here while Signup, SignIn
                    /*First time while login the app this api get called
                     Get data from API and stores into Realm DB */
                    //self?.getRoasterHistory()
                    //self?.delegate?.didSuccessAuthService(status: true)                       //Maha added here
                    
                    print("Signed in")
                }
                
            case .Error(let error):
                print(error)
                self?.delegate?.didFailure(error: error)
            }
        }
    }
    
    //MARK:- SIGN UP FUNCTION
    //IN USE
    func signupV1Updated(mail: String, pwd: String, fname: String, lname:String, ccode:String, mobile:String, lat: String, long:String, company: String, mobileVerify: Bool, emailVerify: Bool) {
        let service = APIService()
        service.endPoint = Endpoints.SIGNUP_V1_UPDATED
        let addr = getIFAddresses()
        var ip = ""
        print("count", addr.count)
        if addr.count > 0 {
            ip = addr.description
        }
        service.params = "ipAddress=\(ip)&email=\(mail)&password=\(pwd)&firstName=\(fname)&lastName=\(lname)&apiKey=\(API_KEY)&countryCode=\(ccode)&mobile=\(mobile)&device=\(MOBILE_DEVICE)&company=\(company)&latitude=\(lat)&longitude=\(long)&mobileVerify=\(mobileVerify)&emailVerify=\(emailVerify)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                let error = dict["error"] as! Bool
                let status = dict["status"] as! String
                if !error{
                    self?.handleAuthDetails(json: dict)
                    print("Updated register API",dict, service.params)
                } else {
                    print("Status Error : \(status)")
                    self?.delegate?.didFailure(error: status)
                    //self?.delegate?.didSuccessAuthService(status: false)
                }
            case .Error(let error):
                self?.delegate?.didFailure(error: error)
                //self?.delegate?.didSuccessAuthService(status: false)
            }
        }
    }
    
    
    //Not using
    func signUpUser(mail: String, pwd: String, fname: String, lname:String, ccode:String, mobile:String){
        let service = APIService()
        service.endPoint = Endpoints.REGISTER_URL
        let addr = getIFAddresses()
        var ip = ""
        print("count", addr.count)
        if addr.count < 0 {
            ip = addr.description
        }
//        service.params = "ipAddress\(ip)&email=\(mail)&password=\(pwd)&firstName=\(fname)&lastName=\(lname)&apiKey=\(API_KEY)&countryCode=\(ccode)&mobile=\(mobile)"
        service.params = "ipAddress=\(ip)&email=\(mail)&password=\(pwd)&firstName=\(fname)&lastName=\(lname)&apiKey=\(API_KEY)&countryCode=\(ccode)&mobile=\(mobile)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleAuthDetails(json: dict)
                print("Confused",dict, service.params)
                let error = dict["error"] as! Bool
//                let status = dict["status"] as! String
                if error == true {
//                    print("Error while sign up :\(status)")
//                    self?.delegate?.didFailure(error: status)
                    //calling delete in handleAuthdetails if error occured so not added
                } else {
                    //self?.delegate?.didSuccessAuthService(status: true)                       //Maha added here
                    //NotificationService.instance.updateDeviceToken()
                }
            case .Error(let error):
                //self?.delegate?.didSuccessAuthService(status: false)
                self?.delegate?.didFailure(error: error)
            }
        }
    }
    
    //
    private func handleDeviceDetails(json: [String: AnyObject]){
        if let error = json["error"] as? Bool{
            if !error{
                AuthService.instance.isDeviceRegistered = true
                delegate?.didSuccessDeviceRegistration(status: true, message: "Device Registered")
            } else {
                self.delegate?.didSuccessDeviceRegistration(status: false, message: "Failed Device Registration")
            }
        } else {
            self.delegate?.didSuccessDeviceRegistration(status: false, message: "Failed Device Registration")
        }
    }
    
    //Not using
    //UPDATED SIGN UP API with LAT, LONG, COMPANY
    func signUpUserUpdated(mail: String, pwd: String, fname: String, lname:String, ccode:String, mobile:String, lat: String, long:String, company: String) {
        let service = APIService()
        service.endPoint = Endpoints.SIGNUP_USER_UPDATED
        let addr = getIFAddresses()
        var ip = ""
        print("count", addr.count)
        if addr.count > 0 {
            ip = addr.description
        }
        service.params = "ipAddress=\(ip)&email=\(mail)&password=\(pwd)&firstName=\(fname)&lastName=\(lname)&apiKey=\(API_KEY)&countryCode=\(ccode)&mobile=\(mobile)&device=\(MOBILE_DEVICE)&company=\(company)&latitude=\(lat)&longitude=\(long)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleAuthDetails(json: dict)
                print("Updated register API",dict, service.params)
                let error = dict["error"] as! Bool
                //                let status = dict["status"] as! String
                if error == true {
                    //                    print("Error while sign up :\(status)")
                    //                    self?.delegate?.didFailure(error: status)
                    //calling delete in handleAuthdetails if error occured so not added
                } else {
                    //self?.delegate?.didSuccessAuthService(status: true)                       //Maha added here
                    //NotificationService.instance.updateDeviceToken()
                }
            case .Error(let error):
                //self?.delegate?.didSuccessAuthService(status: false)
                self?.delegate?.didFailure(error: error)
            }
        }
    }
    
    func signInWithFacebook(email: String, password: String, firstName: String, lastName: String,fid: String,url: String,completion: @escaping (APIResult<[String:AnyObject]>) -> ()) {
        //delegate?.didSuccessAuthService(status: true)
        //let feedVC = FeedController()
        //feedVC.showActivityIndicator(with: "Signinig In With Facebook")
        
        let service = APIService()
        service.endPoint = Endpoints.REGISTER_URL
        var ip = ""
        let addr = getIFAddresses()
        print("Count \(addr.count)")
//        let newurl = "http://graph.facebook.com/"+fid+"/picture?height=500&width=500"
//        print("Image : \(newurl)")
        if addr.count > 0 {
            ip = addr.description
            print("IP Get \(ip)")
        }
        else {
            print("This part")
        }
        
        service.params = "ipAddress=\(addr[0])&email=\(email.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&password=\(password.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&firstName=\(firstName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&lastName=\(lastName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&apiKey=\(API_KEY)&fId=\(fid)&url=\(url)"
        print("URL : \(url)")
        print("Params", service.params)
        print("End point", service.endPoint)
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                print("Show me", result)
                if let error = dict["error"] as? Bool, error == true, let status = dict["status"] as? String{
                    print("\n IP : \(addr[0]), \n email : \(email), \n password : \(password), \n first name : \(firstName), \n last name : \(lastName), \n apikey : \(API_KEY), \n Facebook ID : \(fid), \n url : \(url)")
                    print("Dict error \(error)")
                    completion(APIResult.Error(status))
                    if status == "Email address is not valid"{
                        completion(APIResult.Error("Valid username should be described"))
                    }
                    else if status == "" {
                        
                    }
                    else {
                        
                    }
                    return
                } else {
                    //self.getRoasterHistory()
                    //NotificationService.instance.updateDeviceToken()
                    self.handleAuthDetails(json: dict)
                }
            case .Error(_):
                completion(APIResult.Error("Error! Try Again."))
            }
        }
        
    }
    
    
    private func handleAuthDetails(json: [String: AnyObject]){
        
        var userid = ""
        var colorcode = ""
        var firstname = ""
        var lastname = ""
        var mail = ""
        var mob = ""
        var passw = ""
        var profile = ""
        var bigPic = ""
        var userjid = ""
        var rank = ""
        var comp = ""
        var desig = ""
        var pts = ""
        var companyId = ""
        let status = json["status"] as? String
        
        if let error = json["error"] as? Bool{
            
            if !error{
                if let userdict = json["userData"] as? [String:AnyObject]{
                    if let uid = userdict["userId"] as? String{
                        userid = uid
                    }
                    if let fname = userdict["firstName"] as? String{
                        firstname = fname
                    }
                    if let lname = userdict["lastName"] as? String{
                        lastname = lname
                    }
                    if let mobile = userdict["mobile"] as? String {
                        mob = mobile
                    }
                    if let email = userdict["email"] as? String{
                        mail = email
                    }
                    if let pwd = userdict["password"] as? String{
                        passw = pwd
                    }
                    if let pro = userdict["profilePic"] as? String{
                        profile = pro
                    }
                    if let bigPro = userdict["bigProfilePic"] as? String{
                        bigPic = bigPro
                    }
                    if let color = userdict["colorCode"] as? String{
                        colorcode = color
                    }
                    if let jId = userdict["jId"] as? String{
                        userjid = jId
                        print("User JID while sign up/ signin :\(userjid)")
                    }
                    if let userRank = userdict["userRank"] as? String{
                        rank = userRank
                    }
                    if let company = userdict["company"] as? String{
                        comp = company
                    }
                    if let companyID = userdict["companyId"] as? String{
                      companyId = companyID
                    }
                    if let designation = userdict["designation"] as? String{
                        desig = designation
                    }
                    if let points = userdict["points"] as? String {
                        pts = points
                    }
                    
                    let followersCount = JSONUtils.GetIntFromObject(object: userdict, key: "followercount")
                    
                    self.updateRegistrationDetails(email: mail, mobile: mob,firstName: firstname, lastName: lastname, password: passw, profilePic: profile, bigProfilePic: bigPic, userId: userid, colorCode: colorcode, loggedIn: true, userJID: userjid,userRank :rank, company: comp, designation : desig, points: pts,companyId: companyId,followersCount: followersCount)
                    
                    if let isShared = userdict["isShared"] as? String {
                        AuthStatus.instance.isShared = isShared == "1"
                    }
                    
                    if let lmesubscription = userdict["lmeSubscription"] as? String , let intValue = Int(lmesubscription) {
                        AuthStatus.instance.setLMEStatus = intValue
                    }
                    
                    delegate?.didSuccessAuthService(status: true)                         //Maha edited and added individually to sign up and signin
                }
            } else {
                //delegate?.didSuccessAuthService(status: false)
                DispatchQueue.main.async {
                    self.delegate?.didFailure(error: status!)
                }
                
            }
        } else {
//            delegate?.didSuccessAuthService(status: false)
            DispatchQueue.main.async {
                self.delegate?.didFailure(error: status!)
            }
        }
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                        print("Address \(address)")
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        return addresses
    }
    
    
    typealias successCompletion = (Bool) -> ()
    
    func logoutUser(_ completion: @escaping successCompletion){
    
        let service = APIService()
        service.endPoint = Endpoints.LOGOUT_USER
        service.params = "userId=\(AuthService.instance.userId)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                    
                }
            case .Error(_):
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    typealias changePasswordCompletion = (Bool, String?) -> ()
    
    func changePassword(currentPassword: String, newPassword: String,  _ completion: @escaping changePasswordCompletion){
        let service = APIService()
        service.endPoint = Endpoints.CHANGE_PASSWORD_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&curPassword=\(currentPassword)&newPassword=\(newPassword)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let status = dict["status"] as? String
                if let error = dict["error"] as? Bool{
                    if !error{
                        if let changePasswordData = dict["changePasswordData"] as? String{
                            if changePasswordData == newPassword{
                                completion(true, changePasswordData)
                            } else {
                                //changePasswordData = error
                                completion(false, "Password doesn't matched, Server error..")
                            }
                        }
                    } else {
                        completion(false, "Something Error Happened, Please try again later. API error")
                    }
                } else{
                    completion(false, "Something Error Happened, Please try again later.")
                }
            case.Error(let error):
                completion(false, error)
            }
        }
    }
    
    func showToast(message:String){
        
        let size: CGSize = message.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 13)!])
        
        let vc = SignInViewController()
        let toastLabel = UILabel(frame: CGRect(x: (vc.view.frame.width / 2) - (size.width + 20 ) / 2   , y: vc.view.frame.height - 100, width: size.width + 20, height: 30))
        
        
        
        toastLabel.backgroundColor = UIColor.BLACK_ALPHA
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        toastLabel.font = UIFont(name: "HelveticaNeue", size: 13)
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10.0
        toastLabel.clipsToBounds = true
        vc.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.5
        }) { (isCompleted) in
            
            toastLabel.removeFromSuperview()
        }
        
        
    }
    
}


enum SignInResult<T,U>{
    case success(T)
    case failure(U)
}



