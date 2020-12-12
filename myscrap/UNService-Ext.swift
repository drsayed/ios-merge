//
//  UNService-Ext.swift
//  myscrap
//
//  Created by MyScrap on 5/14/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseInstanceID
import Firebase
import NotificationBannerSwift
import os.log
import FirebaseMessaging

enum UnNotificationType: String{
    
    case editprofile = "editprofile"
    case price = "price"
    case profile = "profile"
    
    case market = "market"
    case marketmpost = "market/mpost"
    case members = "members"
    case visitor = "visitor"
    case company = "company"
    case feeds = "feeds"
    case notification = "notification"
    case post = "post"
    case user = "user"
    case User = "User"
    case numberaccept = "numberaccept"
    case cardaccept = "cardaccept"
    case cardreject = "cardreject"
    case numberreject = "numberreject"
    case card = "card"
    case number = "number"
    case bumped = "bumped"
    case doubleComment = "doubleComment"
    case missedActivity = "missedActivity"
    case event = "event"
    case chat = "chat"
    case listingChatReq = "chat_req_sent"
    case listingChatAck = "chat_req_ack"
    case other
}


struct UnNotificationKeys{
    static let data = "data"
    static let body = "body"
    static let notificationType = "notType"
    static let notificationID = "notId"
    static let postId = "postId"
    static let friendId = "friendId"
    static let companyId = "companyId"
    static let listingId = "listingId"
    static let listingid = "listingid"

    //chat
    static let fname = "friendName"
    static let colorCode = "colorCode"
    static let profilePic = "profilePic"
    static let jid = "jid"
    static let userId = "userId"
    
}





extension AppDelegate:   UNUserNotificationCenterDelegate {
    
    func registerForNotifications(_ application: UIApplication){
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        self.center.delegate = self
        application.registerForRemoteNotifications()
        
//        if #available(iOS 10.0, *) {
//                let center = UNUserNotificationCenter.current()
//                center.delegate = self
//                center.requestAuthorization(options: [.badge, .alert, .sound]) {
//                    (granted, error) in
//                    if granted {
//                        DispatchQueue.main.async {
//                            self.center.delegate = self
//                            application.registerForRemoteNotifications()
//                            //UIApplication.shared.registerForRemoteNotifications()
//                        }
//                    } else {
//                        //print("APNS Registration failed")
//                        //print("Error: \(String(describing: error?.localizedDescription))")
//                    }
//                }
//            } else {
//                let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
//                let setting = UIUserNotificationSettings(types: type, categories: nil)
//                application.registerUserNotificationSettings(setting)
//                self.center.delegate = self
//                application.registerForRemoteNotifications()
//                //UIApplication.shared.registerForRemoteNotifications()
//            }
//        let options : UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, err) in
//            if success {
//                DispatchQueue.main.async {
//                    self.center.delegate = self
//                    application.registerForRemoteNotifications()
//                }
//            }
//        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to regisgter remote notification \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
      
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
       print("New Tocken is : \(token)")
        NotificationService.instance.udidToken = token
       // Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
             //  Messaging.messaging().apnsToken = deviceToken
               InstanceID.instanceID().instanceID { (result, error) in
                   if let error = error {
                      // Log.Error("Error fetching remote instance ID: \(error)")
                   } else if let result = result {
                  //     Log.Info("Remote instance ID token: \(result.token)")
                    //   LocalStorage.set(result.token, "dacDeviceToken")
                    NotificationService.instance.apnToken = result.token
                    self.connectToFcm()

                   }
               }
             //  Messaging.messaging().shouldEstablishDirectChannel = true

       // let remoteNotificationToken = deviceToken.map{ String(format: "%02.2hhx", $0 )}.joined()
        
        self.voipRegistration()
        
    }
    
   
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//            print("remoteMessage: \(remoteMessage)")
//    }
    func applicationReceivedRemoteMessage(_ remoteMessage:
                                            Messaging) {
        print("Received data message: \(remoteMessage)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //When app killed notification will triggered this method
        debugPrint("didReceiveRemoteNotification without bg fetch: \(userInfo)")
        NotificationService.instance.notificationCount = NotificationService.instance.notificationCount! + 1
        DispatchQueue.main.async {
            NSLog("This is background")
            
        }
        //XMPPService.instance.offline()
        XMPPService.instance.disconnect()
        XMPPService.instance.connectEst = false
        
        if AuthStatus.instance.isLoggedIn {
            
            
            
            let remote_message = userInfo
            let name = remote_message["name"] as? String ?? ""
            let friendId = remote_message["friendId"] as? String ?? ""
            //let notId = remote_message["notId"] as? String ?? ""
            let flag = remote_message["flag"] as? String ?? ""
            //let text = remote_message["text"] as? String ?? ""
            let id = remote_message["id"] as? String ?? ""
            let profilepic = remote_message["profilepic"] as? String ?? ""
            let postId = remote_message["postId"] as? String ?? ""
            //let companyId = remote_message["companyId"] as? String ?? ""
            let type = remote_message["type"] as? String ?? ""
            let title = remote_message["title"] as? String ?? ""
            let content_notif = remote_message["content"] as? String ?? ""
            let listingId = remote_message["listingId"] as? String ?? ""
            let listingid = remote_message["listingid"] as? String ?? ""
            let notificationID = remote_message["notId"] as? String ?? ""
            //let from = remote_message["from"] as? String ?? ""
            //let notificationcount = remote_message["notificationcount"] as? String ?? ""
            let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "log")
            os_log("willPresent %{public}@", log: log, type)
            os_log("willPresent %{public}@", log: log, type: .default, type)
            os_log("Type fetched = %@", type)
            print("Type fetched : \(type)")
            
            if type == "app_updates" {
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = content_notif
                
                content.userInfo = [
                    "data" : [ UnNotificationKeys.notificationType : type, UnNotificationKeys.jid : friendId, UnNotificationKeys.fname : name, UnNotificationKeys.colorCode : "", UnNotificationKeys.listingId : listingId, UnNotificationKeys.listingid : listingid,UnNotificationKeys.notificationID : notificationID, UnNotificationKeys.profilePic : profilepic, UnNotificationKeys.userId : id
                    ]
                ]
                content.sound = UNNotificationSound.default
                let req = UNNotificationRequest(identifier: flag, content: content, trigger: nil)
                
                
                center.add(req) { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                    }
                }
            } else if type == "xmppOfflineMessageNot" {
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = ""
                content.body = "New Message received"
                
                content.userInfo = [
                    "data" : [ UnNotificationKeys.notificationType : type, UnNotificationKeys.jid : "", UnNotificationKeys.fname : name, UnNotificationKeys.colorCode : "", UnNotificationKeys.profilePic : "", UnNotificationKeys.userId : ""
                    ]
                ]
                content.sound = UNNotificationSound.default
                let req = UNNotificationRequest(identifier: flag, content: content, trigger: nil)
                
                
                center.add(req) { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                    }
                }
            } else if type == "post" && postId != ""{
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = ""
                content.body = content_notif
                
                content.userInfo = [
                        "data" : [ UnNotificationKeys.notificationType : type, UnNotificationKeys.jid : friendId, UnNotificationKeys.fname : name, UnNotificationKeys.colorCode : "", UnNotificationKeys.notificationID : notificationID, UnNotificationKeys.profilePic : profilepic, UnNotificationKeys.userId : id, UnNotificationKeys.postId : postId
                        ]
                ]
                
                content.sound = UNNotificationSound.default
                let req = UNNotificationRequest(identifier: flag, content: content, trigger: nil)
                
                
                center.add(req) { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                    }
                }
            } else {
                //Default message if type is not available
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = ""
                content.body = "New message received"
                
                content.userInfo = [
                    "data" : [ UnNotificationKeys.notificationType : "", UnNotificationKeys.jid : "", UnNotificationKeys.fname : "MyScrap", UnNotificationKeys.colorCode : "", UnNotificationKeys.profilePic : "", UnNotificationKeys.userId : ""
                    ]
                ]
                content.sound = UNNotificationSound.default
                let req = UNNotificationRequest(identifier: flag, content: content, trigger: nil)
                
                
                center.add(req) { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            //Notification will not be triggered because User not logged to Myscrap
            print("User not logged to Myscrap")
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //App is foreground message received here then will move to present handler
        print("Receive remote notification, setting gcm Message ID")
        let gcmMessageIDKey = "gcm.message_id"
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        let message = userInfo
        let name = message["name"] as? String ?? ""
        let companyId = message["companyId"] as? String ?? ""
        let postId = message["postId"] as? String ?? ""
        let text = message["text"] as? String ?? ""
        let listingId = message["listingId"] as? String ?? ""
        let listingid = message["listingid"] as? String ?? ""
        let notificationID = message["notId"] as? String ?? ""

        let sound = message["sound"] as? String ?? ""
        let type = message["type"] as? String ?? ""
        let flag = message["flag"] as? String ?? ""
        var content_notif = message["content"] as? String ?? ""
        if let aps = message["aps"] as? [String:AnyObject] {
            print(aps)
            let contavail = aps["content_available"] as? AnyObject
            print("body :", contavail)
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = ""
            content.body = "New message received"
            
            content.userInfo = [
                "data" : [ UnNotificationKeys.notificationType : "", UnNotificationKeys.jid : "", UnNotificationKeys.fname : "MyScrap", UnNotificationKeys.colorCode : "",UnNotificationKeys.listingId : listingId,UnNotificationKeys.listingid : listingid,UnNotificationKeys.notificationID : "\(notificationID)", UnNotificationKeys.profilePic : "", UnNotificationKeys.userId : ""
                ]
            ]
            content.sound = UNNotificationSound.default
            let req = UNNotificationRequest(identifier: flag, content: content, trigger: nil)
            
            
            center.add(req) { (err) in
                if let error = err {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("aps not found")
        }
        
        
        
        if type == "xmppOfflineMessageNot" {
            
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = ""
            content.body = content_notif
            
            content.userInfo = [
                "data" : [ UnNotificationKeys.notificationType : type, UnNotificationKeys.jid : "", UnNotificationKeys.fname : name, UnNotificationKeys.colorCode : "",UnNotificationKeys.listingId : listingId,UnNotificationKeys.listingid : listingid,UnNotificationKeys.notificationID : "\(notificationID)", UnNotificationKeys.profilePic : "", UnNotificationKeys.userId : ""
                ]
            ]
            content.sound = UNNotificationSound.default
            let req = UNNotificationRequest(identifier: flag, content: content, trigger: nil)
            
            
            center.add(req) { (err) in
                if let error = err {
                    print(error.localizedDescription)
                }
            }
        }
        
        print("Back ground remote fetch")
        //DispatchQueue.main.async{
        //let app = UIApplication.shared
        
        //bgTask = app.beginBackgroundTask(expirationHandler: {
        if application.applicationState == .background {
            
            //XMPPService.instance.disconnect()
            //XMPPService.instance.connectEst = false
            
            if let id = AuthService.instance.userJID {
                
                if XMPPService.instance.isConnected == false {
                    if !XMPPService.instance.connectEst {
                        print("Started connecting XMPP ... in remote")
                        XMPPService.instance.connect(with: id)
                        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        //XMPPService.instance.sendOnline()
                        
                        //}
                        //self.endBackgroundTask()
                    }
                } else {
                    print("Already XMPP connected remotely")
                }
            }
        }
        
        //})
        //}
        
        // Print full message.
        print(userInfo)
        print("Foreground notification test : \(UIBackgroundFetchResult.newData)")
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken!]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        //Assigning the firebase registeration token as apnToken
        NotificationService.instance.apnToken = fcmToken
        NotificationService.instance.updateDeviceToken()
        print("Stored FCM : \(NotificationService.instance.apnToken)")
    }
    
    //MARK: FCM Token Refreshed
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//         guard let fcmToken = fcmToken else { return }
//         print("Firebase registration token: \(fcmToken)")
//    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
   
//    func applicationReceivedRemoteMessage(_ remoteMessage:
//                                            FirebaseMessaging) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
    
    // Receive data message on iOS 10 devices while app is in the foreground.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        NSLog("remoteMessage: \(remoteMessage.appData)")
//        print("Print receive message : \(remoteMessage.appData)")
//
//        let message = remoteMessage.appData
//        let name = message["name"] as? String ?? ""
//        let friendId = message["friendId"] as? String ?? ""
//        let notId = message["notId"] as? String ?? ""
//        let flag = message["flag"] as? String ?? ""
//        let text = message["text"] as? String ?? ""
//        let id = message["id"] as? String ?? ""
//        let profilepic = message["profilepic"] as? String ?? ""
//        let postId = message["postId"] as? String ?? ""
//        let companyId = message["companyId"] as? String ?? ""
//        let type = message["type"] as? String ?? ""
//        let listingId = message["listingId"] as? String ?? ""
//        let title = message["title"] as? String ?? ""
//        let content_notif = message["content"] as? String ?? ""
//        let from = message["from"] as? String ?? ""
//        let notificationcount = message["notificationcount"] as? String ?? ""
//
//        print(" \nName : \(name), \nFriendId : \(friendId), \nNotifID : \(notId), \nFlag : \(flag), \nText :\(text), \nID : \(id), \nProfile Picture : \(profilepic), \nPostID : \(postId), \nCompanyId : \(companyId), \nType : \(type), \nTitle : \(title), \nContent : \(content_notif), \nFrom : \(from), \nNotification Count : \(notificationcount)")
//        /*
//        if type == "xmppOfflineMessageNot" {
//            let center = UNUserNotificationCenter.current()
//            let content = UNMutableNotificationContent()
//            content.title = title
//            content.body = content_notif
//
//            content.userInfo = [
//                "data" : [ UnNotificationKeys.notificationType : type, UnNotificationKeys.jid : friendId, UnNotificationKeys.fname : name, UnNotificationKeys.colorCode : "", UnNotificationKeys.profilePic : profilepic, UnNotificationKeys.userId : id
//                ]
//            ]
//            content.sound = UNNotificationSound.default()
//            let req = UNNotificationRequest(identifier: flag, content: content, trigger: nil)
//
//
//            center.add(req) { (err) in
//                if let error = err {
//                    print(error.localizedDescription)
//                }
//            }
//        }*/
//
//        //Banner in navigation bar
//        //let banner = NotificationBanner(title: content_notif, style: .success, colors: CustomBannerColors())
//        //banner.show()
//
//
//        if content_notif != "" {
//            let center = UNUserNotificationCenter.current()
//            let content = UNMutableNotificationContent()
//            content.title = name            //title
//            content.body = content_notif
//
//            if type == "post" && postId != "" {
//                content.userInfo = [
//                    "data" : [ UnNotificationKeys.notificationType : type, UnNotificationKeys.jid : friendId, UnNotificationKeys.fname : name, UnNotificationKeys.colorCode : "", UnNotificationKeys.profilePic : profilepic, UnNotificationKeys.userId : id, UnNotificationKeys.postId : postId
//                    ]
//                ]
//            } else {
//                content.userInfo = [
//                    "data" : [ UnNotificationKeys.notificationType : type, UnNotificationKeys.jid : friendId, UnNotificationKeys.fname : name, UnNotificationKeys.colorCode : "", UnNotificationKeys.listingId : listingId, UnNotificationKeys.profilePic : profilepic, UnNotificationKeys.userId : id
//                    ]
//                ]
//            }
//
//            content.sound = UNNotificationSound.default
//            let req = UNNotificationRequest(identifier: flag, content: content, trigger: nil)
//
//
//            center.add(req) { (err) in
//                if let error = err {
//                    print(error.localizedDescription)
//                }
//            }
//        } else {
//            print("unfav and unlike will not triggered")
//        }
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        //
        print("Remote Notification received on foreground : \(notification.request.content.userInfo)")
        let userInfo = notification.request.content.userInfo
        print("Content : \(notification.request.content)")
        NSLog("[UserNotificationCenter] willPresentNotification: \(userInfo)")
        
        let vc = UIApplication.shared.topMostViewController()
        let v = vc as? ConversationVC
        let currentjid = v?.jid
        if let data = userInfo[UnNotificationKeys.data] as? [String: AnyObject],
            let jid = data[UnNotificationKeys.jid] as? String,
            jid == currentjid {
                completionHandler([.sound])
            }
         else {
            if let vc = UIApplication.shared.topMostViewController(),
                let _ = vc as? ChatVC{
                completionHandler([.alert, .sound, .badge])
            } else {
                //Foreground notification received without type : "" specified
                completionHandler([.alert, .sound, .badge])
            }
        }
    }
    //Notification handling for iOS 10
      @available(iOS 10.0, *)
      func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        //
        print("Remote Notification received on foreground : \(notification.request.content.userInfo)")
        let userInfo = notification.request.content.userInfo
        print("Content : \(notification.request.content)")
        NSLog("[UserNotificationCenter] willPresentNotification: \(userInfo)")
        
        let vc = UIApplication.shared.topMostViewController()
        let v = vc as? ConversationVC
        let currentjid = v?.jid
        if let data = userInfo[UnNotificationKeys.data] as? [String: AnyObject],
            let jid = data[UnNotificationKeys.jid] as? String,
            jid == currentjid {
                completionHandler([.sound])
            }
         else {
            if let vc = UIApplication.shared.topMostViewController(),
                let _ = vc as? ChatVC{
                completionHandler([.alert, .sound, .badge])
            } else {
                //Foreground notification received without type : "" specified
                completionHandler([.alert, .sound, .badge])
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        print("notification tapped ")
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] didReceiveResponse: \(userInfo)")
        
        print(response.notification.request.identifier)
        
        var notificationType: UnNotificationType = .other
        var postId: String?
        var userId: String?
        var companyId : String?
        
        //chat
        
        var fName: String?
        var colorCode: String?
        var profilePic: String?
        var jid: String?
        var chatUserId: String?
        var listingId: String?
        var listingid: String?
        var notificationId = ""
        let notificationBody =   response.notification.request.content.body as? String
      
        
        print("User info after tapped : ",userInfo)
        
        if let data = userInfo[UnNotificationKeys.data] as? [String: AnyObject], let type = data[UnNotificationKeys.notificationType] as? String{

            print("Data from user info",data)
            
            notificationType = UnNotificationType(rawValue: type) ?? .other
            
            if let pid = data[UnNotificationKeys.postId] as? String{
                postId = pid
            }
            if let notID = data[UnNotificationKeys.notificationID] as? String{
                notificationId = notID
            }
            else
            {
                if let notID = data[UnNotificationKeys.notificationID] as? Int{
                    notificationId = "\(notID)"
                }
            }
          
            
            if let listId = data[UnNotificationKeys.listingId] as? String{
                listingId = listId
            }
            if let listid = data[UnNotificationKeys.listingid] as? String{
                listingid = listid
            }
            
            if let uid = data[UnNotificationKeys.friendId] as? String{
                userId = uid
            }
            if let cid = data[UnNotificationKeys.companyId] as? String{
                companyId = cid
            }
            
            if let fnm = data[UnNotificationKeys.fname] as? String{
                fName = fnm
            }
            
            if let cCode = data[UnNotificationKeys.colorCode] as? String{
                colorCode = cCode
            }
            if let propic = data[UnNotificationKeys.profilePic] as? String{
                profilePic = propic
            }
            if let jd = data[UnNotificationKeys.jid] as? String{
                jid = jd
            }
            if let uid = data[UnNotificationKeys.userId] as? String{
                chatUserId = uid
            }
        }
        
        
        switch notificationType {
        case .post,.doubleComment:
            if let id = postId  {
                let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
                vc.postId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")
                navController?.pushViewController(vc, animated: true)
            }
            else
            {
            if let vc = NotificationVC.storyBoardInstance(){
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                navController?.present(nav, animated: true, completion: nil)
            }
            }
        case .event:
            if let id = postId{
                let vc = EventDetailVC()
                vc.eventId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                navController?.pushViewController(vc, animated: true)
            }
        case .bumped:
            print("Bump notification has been removed manually by MAHA on Nov 20/2019 ")
            //setBumpVC()           removed the bump notification manually base on the requirements
        case .card:
            if let id = userId, let vc = FriendVC.storyBoardInstance(){
                vc.friendId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                vc.isfromCardNoti = "1"
                self.navController?.pushViewController(vc, animated: true)
            }
        case .number:
            if let id = userId, let vc = FriendVC.storyBoardInstance(){
                vc.friendId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                vc.isfromCardNoti = ""
                self.navController?.pushViewController(vc, animated: true)
            }
        case .cardaccept:
            if let id = userId, let vc = FriendVC.storyBoardInstance(){
                vc.friendId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                vc.isfromCardNoti = "1"
                self.navController?.pushViewController(vc, animated: true)
            }
   
        case .numberaccept:
            if let id = userId, let vc = FriendVC.storyBoardInstance(){
                vc.friendId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                vc.isfromCardNoti = ""
                self.navController?.pushViewController(vc, animated: true)
            }
        case .cardreject:
            if let id = userId, let vc = FriendVC.storyBoardInstance(){
                vc.friendId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")
                vc.isfromCardNoti = "1"
                self.navController?.pushViewController(vc, animated: true)
            }
        case .numberreject:
            if let id = userId, let vc = FriendVC.storyBoardInstance(){
                vc.friendId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                vc.isfromCardNoti = ""
                self.navController?.pushViewController(vc, animated: true)
            }
        case .user:
            if notificationBody!.contains("business card")
            {
                if let id = userId, let vc = FriendVC.storyBoardInstance(){
                    vc.friendId = id
                    UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")
                    vc.isfromCardNoti = "1"
                    self.navController?.pushViewController(vc, animated: true)
                }
            }
            else{
                if let id = userId, let vc = FriendVC.storyBoardInstance(){
                    vc.friendId = id
                    UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                    vc.isfromCardNoti = ""
                    self.navController?.pushViewController(vc, animated: true)
                }
            }
        case .User:
            if notificationBody!.contains("business card")
            {
                if let id = userId, let vc = FriendVC.storyBoardInstance(){
                    vc.friendId = id
                    UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                    vc.isfromCardNoti = "1"
                    self.navController?.pushViewController(vc, animated: true)
                }
            }
            else{
                if let id = userId, let vc = FriendVC.storyBoardInstance(){
                    vc.friendId = id
                    UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                    vc.isfromCardNoti = ""
                    self.navController?.pushViewController(vc, animated: true)
                }
            }
           
        case .company:
            if  let id = companyId, let vc = CompanyHeaderModuleVC.storyBoardInstance() { //CompanyDetailVC.storyBoardInstance() {
                vc.companyId = id
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                UserDefaults.standard.set(vc.companyId, forKey: "companyId")
                self.navController?.pushViewController(vc, animated: true)
            }
        case .marketmpost:
            if  let listingID = listingId{
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                let vc = DetailListingOfferVC.controllerInstance(with: listingID, with1: userId)
                self.navController?.pushViewController(vc, animated: true)
            }
            else
            {
                if  let listingiD = listingid{
                    UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                    let vc = DetailListingOfferVC.controllerInstance(with: listingiD, with1: userId)
                    self.navController?.pushViewController(vc, animated: true)
                }
                else
                {
                if let vc = MarketVC.storyBoardInstance(){
                    UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                    self.navController?.pushViewController(vc, animated: true)

                }
                }
            }
        case .market:
            if  let listingID = listingId{
                let vc = DetailListingOfferVC.controllerInstance(with: listingID, with1: userId)
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                self.navController?.pushViewController(vc, animated: true)
            }
            else
            {
                if  let listingiD = listingid{
                    UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                    let vc = DetailListingOfferVC.controllerInstance(with: listingiD, with1: userId)
                    self.navController?.pushViewController(vc, animated: true)
                }
                else
                {
                if let vc = MarketVC.storyBoardInstance(){
                    UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                    self.navController?.pushViewController(vc, animated: true)

                }
                }
            }
      
        case .chat:
            
            if let fid = chatUserId, let fnm = fName, let cCode = colorCode, let propic = profilePic, let jd = jid {
                let fmodel = FriendModel(id: fid, profileName: fnm, colorCode: cCode, profileImg: propic, jid: jd)
                if let vc = UIApplication.shared.topMostViewController(), let v = vc as? ConversationVC{
                    v.navigationController?.popViewController(animated: true)
                } else {
                    let controller = ChatVC()
                    let vc = UINavigationController(rootViewController: controller)
                    controller.isTapNotifMsg = true
                    controller.modalPresentationStyle = .fullScreen

                    self.getRearViewController().present(vc, animated: false) {
                        NotificationCenter.default.post(name: Notification.Name.navigate, object: fmodel)
                    }
                    //NotificationCenter.default.post(name: Notification.Name.navigate, object: fmodel)
                    //self.pushViewController(storyBoard: StoryBoard.CHAT, Identifier: ChatVC.id, checkisGuest: AuthStatus.instance.isGuest)
                }
            }
        case .listingChatReq, .listingChatAck:
            if let vc = NotificationVC.storyBoardInstance(){
                UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                navController?.present(nav, animated: true, completion: nil)
            }
        case .notification:
            if let vc = NotificationVC.storyBoardInstance(){
                
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                navController?.present(nav, animated: true, completion: nil)
            }
        default:
            print("go to notification vc")
            
            /*if let vc = NotificationVC.storyBoardInstance(){
                let nav = UINavigationController(rootViewController: vc)
                navController?.present(nav, animated: true, completion: nil)
            }*/
            let protectedPage = FeedsVC.storyBoardInstance()!
            let rearViewController = MenuTVC()
            let protectedNav = UINavigationController(rootViewController: protectedPage)
            let mainRevealController = SWRevealViewController()
            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = protectedNav
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.window?.rootViewController = mainRevealController
        }
        
        
        
        
        completionHandler()
        
    }
    
    var navController : UINavigationController? {
        return self.getRearViewController().navigationController
    }
    
    private func setBumpVC(){
        let vc = BumpedVC()
        let rearViewController = MenuTVC()
        rearViewController.isComingFromBump = true
        let frontNavigationController = UINavigationController(rootViewController: vc)
        let mainRevealController = SWRevealViewController()
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        window?.rootViewController = mainRevealController
    }
    
}
class CustomBannerColors: BannerColorsProtocol {
    
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        
        case .success:    // Your custom .success color
            return UIColor(red: 35/255, green: 107/255, blue: 41/255, alpha: 1.0)
        case .danger:
            return UIColor(red: 35/255, green: 107/255, blue: 41/255, alpha: 1.0)
        case .info:
            return UIColor(red: 35/255, green: 107/255, blue: 41/255, alpha: 1.0)
        case .none:
            return UIColor(red: 35/255, green: 107/255, blue: 41/255, alpha: 1.0)
        case .warning:
            return UIColor(red: 35/255, green: 107/255, blue: 41/255, alpha: 1.0)
        }
    }
}
