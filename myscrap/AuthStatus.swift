//
//  AuthStatus.swift
//  myscrap
//
//  Created by MS1 on 12/21/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import CoreData

enum LMEStatus: Int{
    case unsubscribed = 0
    case requested = 1
    case subscribed = 2
}

final class AuthStatus{
    
    
    
    
    static let instance = AuthStatus()
    
    let defaults = UserDefaults.standard

    
    var lmeStatus: LMEStatus{
        get {
            if let int = defaults.value(forKey: UserDefaults.lmeStatus) as? Int {
                return LMEStatus(rawValue: int) ?? .unsubscribed
            } else {
                return .unsubscribed
            }
        }
    }
    
    var setLMEStatus: Int?{
        get {
            return defaults.value(forKeyPath: UserDefaults.lmeStatus) as? Int
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.lmeStatus)
        }
    }

    var apiKey : String? {
        get {
            return defaults.value(forKey: UserDefaults.API_KEY) as? String
        } set {
            defaults.set(newValue, forKey: UserDefaults.API_KEY)
        }
    }
    
    var isLmeSubscribed: Bool{
        get {
            return defaults.bool(forKey: UserDefaults.isLmeSubscribed)
        } set {
            defaults.set(newValue, forKey: UserDefaults.isLmeSubscribed)
        }
    }
    
    
    var isApiKeyRegistered: Bool{
        get {
            return defaults.bool(forKey: UserDefaults.API_REGISTERED)
        }
        set{
            defaults.set(newValue, forKey: UserDefaults.API_REGISTERED)
        }
    }
    
    
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: UserDefaults.LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.LOGGED_IN_KEY)
            if newValue == false {
                //XMPPService.instance.offline()
                //XMPPService.instance.xmppStream?.disconnect()
                NotificationService.instance.isMemberAlertNotified = false
                AuthStatus.instance.isShared = false
                NotificationService.instance.clearnotification()
                AuthService.instance.userId = "3"
                AuthService.instance.userJID = ""
                AuthStatus.instance.setLMEStatus = 0
                DispatchQueue.main.async {
                    let del = UIApplication.shared.delegate as! AppDelegate
                    del.clearCoreDataStore()
                    del.setSignInViewController()
                }
            }
        }
    }
    
    
    var isGuest: Bool{
        get {
            return defaults.bool(forKey: UserDefaults.IS_GUEST)
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.IS_GUEST)
            if newValue == true{
                DispatchQueue.main.async {
                    if let del = UIApplication.shared.delegate as? AppDelegate{
                        del.setGuestVC()
                        AuthService.instance.registerSignInDetails(email: "", firstName: "Guest", lastName: "User", password: "", profilePic: "", bigProfilePic: "", userId: "3", colorCode: "#bdbdbd", loggedIn: false, followersCount: 0)
                    }
                }
            }
            
            
        }
    }
    
    var isShared: Bool {
        get {
            return defaults.bool(forKey: UserDefaults.IS_SHARED)
        } set {
            defaults.set(newValue, forKey: UserDefaults.IS_SHARED)
            sharePrice()
        }
    }
    
    var isUpdatedOnline:Bool{
        get {
            return defaults.bool(forKey: UserDefaults.IS_UPDATED_ONLINE)
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.IS_UPDATED_ONLINE)
        }
    }

    
    var isModeraor: Bool{
        get {
            return defaults.bool(forKey: UserDefaults.IS_MODERATOR)
        } set {
            if isModeraor != newValue{
                defaults.set(newValue, forKey: UserDefaults.IS_MODERATOR)
                NotificationCenter.default.post(name: Notification.Name.moderatorChanged, object: nil)
            }
        }
    }
    
    private func sharePrice(){
        if AuthStatus.instance.isLoggedIn && isShared {
            let service = APIService()
            service.endPoint = Endpoints.PRICES_URL
            service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&share=1"
            service.getDataWith { (result) in
                switch result {
                case .Success(let dict):
                    print("success in share")
                    print(dict)
                case .Error(let _):
                    print("errror in share")
                }
            }
        }
    }
}
