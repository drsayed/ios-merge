//
//  NotificationService.swift
//  myscrap
//
//  Created by MS1 on 12/27/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift
final class NotificationService{
    
    static let instance = NotificationService()
    
    private let defaults = UserDefaults.standard
    
    
    var voipToken: String?{
        get {
            return defaults.value(forKey: UserDefaults.VOIP_TOKEN) as? String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.VOIP_TOKEN)
        }
    }
    
    
    
    
    var apnToken: String?{
        get {
            return defaults.value(forKey: UserDefaults.DEVICE_TOKEN) as? String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.DEVICE_TOKEN)
        }
    }
    var udidToken: String?{
        get {
            return defaults.value(forKey: UserDefaults.DEVICE_UDID) as? String
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.DEVICE_UDID)
        }
    }
    
    var profileCount: Int?{
        get {
            if AuthStatus.instance.isLoggedIn{
                return defaults.value(forKey: UserDefaults.PROFILE_COUNT) as? Int
            } else {
                return 0
            }
        } set {
            if AuthStatus.instance.isLoggedIn{
                defaults.set(newValue, forKey: UserDefaults.PROFILE_COUNT)
                NotificationCenter.default.post(name: .profileCountChanged, object: nil)
            } else {
                defaults.set(0, forKey: UserDefaults.PROFILE_COUNT)
            }
        }
    }
    
    var profilePercentage: Int?{
        get {
            return defaults.value(forKey: UserDefaults.PROFILE_PERCENTAGE) as? Int
        } set {
            if AuthStatus.instance.isLoggedIn{
                defaults.set(newValue, forKey: UserDefaults.PROFILE_PERCENTAGE)
            } else {
                defaults.set(0, forKey: UserDefaults.PROFILE_PERCENTAGE)
            }
        }
    }
    
    
    
    var notificationCount: Int?{
        get {
            return defaults.value(forKey: UserDefaults.NOTIFICATION_COUNT) as? Int
        }
        set{
            if AuthStatus.instance.isLoggedIn {
                 defaults.set(newValue, forKey: UserDefaults.NOTIFICATION_COUNT)
            } else {
                defaults.set(0, forKey: UserDefaults.NOTIFICATION_COUNT)
            }
            
            NotificationCenter.default.post(name: .notificationCountChanged, object: nil)
            setupApplicationBadgeNumber()
        }
    }
    

    var visitorsCount: Int?{
        get {
            return defaults.value(forKey: UserDefaults.VISITORS_COUNT) as? Int
        }
        set {
            if AuthStatus.instance.isLoggedIn {
                defaults.set(newValue, forKey: UserDefaults.VISITORS_COUNT)
            } else {
                defaults.set(0, forKey: UserDefaults.VISITORS_COUNT)
            }
            NotificationCenter.default.post(name: .visitorsCountChanged, object: nil)
            setupApplicationBadgeNumber()
        }
    }
    
    var moderatorCount: Int? {
        get {
            return defaults.value(forKey: UserDefaults.MODERATOR_COUNT) as? Int
        }
        set {
            if AuthStatus.instance.isLoggedIn {
                defaults.set(newValue, forKey: UserDefaults.MODERATOR_COUNT)
            } else {
                defaults.set(0, forKey: UserDefaults.MODERATOR_COUNT)
            }
            NotificationCenter.default.post(name: .visitorsCountChanged, object: nil)
            setupApplicationBadgeNumber()
        }
    }
    
    
    
    var bumpCount: Int?{
        get {
            return defaults.value(forKey: UserDefaults.BUMP_COUNT) as? Int
        }
        set {
            if AuthStatus.instance.isLoggedIn {
                defaults.set(newValue, forKey: UserDefaults.BUMP_COUNT)
            } else {
                defaults.set(0, forKey: UserDefaults.BUMP_COUNT)
            }
            NotificationCenter.default.post(name: .bumpCountChanged, object: nil)
            setupApplicationBadgeNumber()
            
        }
    }
    
    var messageCount: Int? {
        get {
            return defaults.value(forKey: UserDefaults.MESSAGE_COUNT) as? Int
        } set {
            if AuthStatus.instance.isLoggedIn {
                defaults.set(newValue, forKey: UserDefaults.MESSAGE_COUNT)
            } else {
                defaults.set(0, forKey: UserDefaults.MESSAGE_COUNT)
            }
            setupApplicationBadgeNumber()
        }
    }
    
    
    var isMemberAlertNotified: Bool{
        get{
            return defaults.bool(forKey: UserDefaults.MEMBER_ALERT_NOTIFIED)
        } set{
            defaults.set(newValue, forKey: UserDefaults.MEMBER_ALERT_NOTIFIED)
        }
        
    }
    
    func getNotificationCount(){
        if AuthStatus.instance.isLoggedIn {
            let service = APIService()
            service.endPoint = Endpoints.NOTIFICATION_COUNT_URL
            service.params = "userId=\(AuthService.instance.userId)"
            print("NOTIFiCATION PARAMS : \(service.params)")
            service.getDataWith { (result) in
                switch result{
                case .Success(let dict):
                    DispatchQueue.main.async {
                        if let error = dict["error"] as? Bool{
                            
                            print("Value of dict in Notificaiton Service",dict)
                            if !error{
                                if let visitorsCount = dict["viewersCount"] as? Int{
                                    self.visitorsCount = visitorsCount
                                }
                                if let bumpCount = dict["bumpedCount"] as? Int{
                                    self.bumpCount = bumpCount
                                }
                                if let notificationCount = dict["notificationCount"] as? Int {
                                    self.notificationCount = notificationCount
                                }
                                
                                if let isModerator = dict["isModerator"] as? String{
                                    AuthStatus.instance.isModeraor = isModerator == "1" ? true : false
                                }
                                if let isModeratorCount = dict["moderatorCount"] as? Int{
                                    AuthStatus.instance.isModeraor = isModeratorCount == 1 ? true : false
                                }
                                if let moderatorCount = dict["companyReportCount"] as? Int{
                                    self.moderatorCount = moderatorCount
                                }
                                if let profileCount = dict["profileCount"] as? Int{
                                    self.profileCount = profileCount
                                }
                                if let messageCount = dict["messageCount"] as? Int{
                                    self.messageCount = messageCount
                                }
                            }
                        }
                    }
                case .Error(_):
                    print("Error in getting notification Count")
                }
            }
        } else {
            visitorsCount = 0
            notificationCount = 0
            bumpCount = 0
            messageCount = 0
            UIApplication.shared.applicationIconBadgeNumber = 0

        }
    }
    
    var totalCount: Int{
        let notCount = notificationCount ?? 0
        let visitorCount = visitorsCount ?? 0
        let bumCount = bumpCount ?? 0
        let msgCount = messageCount ?? 0
        
        return notCount + visitorCount + bumCount + msgCount
    }
    
    
    private func setupApplicationBadgeNumber(){
        var appCount = 0
        
        if let notificationCount = notificationCount{
            appCount += notificationCount
        }
        
        if let visitorsCount = visitorsCount {
           // appCount += visitorsCount
        }
        
        if let bumpCount = bumpCount{
            appCount += bumpCount
        }
        
        if let messageCount = messageCount {
            var readMsg_count : Int!
            //This function calls when tapping menu
            DispatchQueue.main.async {
            readMsg_count = try! Realm().objects(UserPrivChat.self).filter("readCount == 0").count
            appCount += readMsg_count
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = appCount
        }
        
    }
    
     func clearnotification(){
        notificationCount = 0
        visitorsCount = 0
        bumpCount = 0
        messageCount = 0
        AuthStatus.instance.isModeraor = false
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func updateDeviceToken(){
        
        if AuthStatus.instance.isLoggedIn {
            let service = APIService()
            service.endPoint = Endpoints.FCM_UPDATE_URL
            
          //  let params = "userId=\(AuthService.instance.userId)&gcmCode=\(NotificationService.instance.apnToken ?? "No Device Token")&apiKey=\(API_KEY)&voipCode=\(NotificationService.instance.voipToken ?? "No voip token received")"
            let params = "userId=\(AuthService.instance.userId)&gcmCode=\(NotificationService.instance.apnToken ?? "No Device Token")&apiKey=\(API_KEY)&voipCode=\(NotificationService.instance.voipToken ?? "No voip token received")&deviceUDID=\(NotificationService.instance.udidToken ?? "No UDID token received")"
            service.params = params
            service.getDataWith(completion: { (result) in
                switch result{
                case .Success(_):
                    print("success")
                case .Error(_):
                    print("error")
                }
            })
        }
    }
    

}
