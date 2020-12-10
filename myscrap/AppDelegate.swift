//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation
import PushKit
import IQKeyboardManagerSwift
import CocoaLumberjack
import GoogleSignIn
import RealmSwift
import XMPPFramework
import Reachability
import Firebase
import os.log
import AVKit
import AVFoundation

let uiRealm = try! Realm()
let network: NetworkManager = NetworkManager.sharedInstance

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, MessagingDelegate,GIDSignInDelegate {
    
//    let reachabillity = Reachability()!
    let center = UNUserNotificationCenter.current()
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var bgTask : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var ping : XMPPPing!
    var xmppAutoPing: XMPPAutoPing!
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)

    var fireBaseConfig = false
    
    //Other modules from FEED/Landing Menu selection custom
    var isLandMenuSelected = false
    var isFeedMenuSelected = false
    var isMarketMenuSelected = false
    var isPricesMenuSelected = false
    var isChatMenuSelected = false
    var isDiscoverMenuSelected = false
    var isCompanyMenuSelected = false
    var isMembersMenuSelected = false
    var isAppLaunching = false

    
    //OS log while background fetch
    fileprivate let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "log")
    
    var tagCallTimer: Timer?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        self.registerForNotifications(application)
        //If Logged then only can register for FCM
        if AuthStatus.instance.isLoggedIn {
            isAppLaunching = true
            self.registerForNotifications(application)
            //FireBase configure
            FirebaseApp.configure()
            UserDefaults.standard.setValue("0", forKey: "MuteValue")

            Messaging.messaging().delegate = self
            //Firebase Token
//            Messaging.messaging().token { token, error in
//                if let error = error {
//                    print("Error fetching FCM registration token: \(error)")
//                  } else if let token = token {
//                    print("FCM registration token: \(token)")
//                    NotificationService.instance.apnToken = token
//                    self.connectToFcm()
//                  }
//               // Check for error. Otherwise do what you will with token here
//
//            }
         
           
            fireBaseConfig = true
        }
        
        if launchOptions != nil {
            //opened from a push notification when the app is closed
            if AuthStatus.instance.isLoggedIn {
                let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
                self.application(application, didReceiveRemoteNotification: remoteNotification)
            }
            
            //Get background Music play
             do{
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)
            }catch{
                //some meaningful exception handling
                print("Can't get the background play back music")
            }
            
        }
        else {
            //opened app without a push notification.
            print("push notification not received while opening app")
        }
        handleNotificationWhenAppIsKilled(launchOptions)
        
        
        NotificationService.instance.messageCount = 0

        if !AuthService.instance.isCoreDataCleared {
            clearCoreDataStore()
            AuthService.instance.isCoreDataCleared = true
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
//        DDLog.add(DDTTYLogger.sharedInstance, with: DDLogLevel.all)
        print("Core Data File location:- \(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last! as String)\n")
        
        setupIQKeyBoardManager()
        setupLocation()
        AuthStatus.instance.isGuest = false
        setupNavigationBar()
        self.checkUpdateVersion()
        
        // Initialize Google sign-in
        GIDSignIn.sharedInstance().clientID = "1016788342618-v7jk56j1vcpsk1oncdluvv74t69vs81h.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        /*do {
            try Network.reachability = Reachability(hostname: "www.google.com")
            /*if AuthStatus.instance.isLoggedIn {
                print("User name and ID in reachability: \(AuthService.instance.firstname), \(AuthService.instance.userId)")
                if  let id = AuthService.instance.userJID {
                    print("Connect method called in App delegate")
                    XMPPService.instance.connect(with: id)
                }
            }*/
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }*/
        
        //Connecting XMPP when app launches
        //if application.applicationState == .active {
        if !AuthStatus.instance.isLoggedIn {
            print("User is not logged in XMPP will connect while signing in")
        } else {
            //Every time app launches from feeds xmpp start establish connection from here
            XMPPService.instance.connectEst = false
            if !XMPPService.instance.connectEst {
                if let jid = AuthService.instance.userJID {
                    print("User name and ID in did launch application: \(AuthService.instance.firstname), \(AuthService.instance.userId) connecting XMPP .... ")
                    if XMPPService.instance.xmppStream?.isConnecting() == false || XMPPService.instance.xmppStream?.isConnected() == false  || XMPPService.instance.xmppStream?.isAuthenticating() == false {
                        XMPPService.instance.connect(with: jid)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            XMPPService.instance.sendOnline()
                        }
                    } else {
                        print("XMPP already conneccted in app become active")
                    }
                }
            }
        }
        
        //}
        
        //If internet reconnected then it starts new xmpp connection only from here
        network.reachability.whenReachable = { reachability in
            if AuthStatus.instance.isLoggedIn {
                //XMPPService.instance.connectEst = false
                if !XMPPService.instance.connectEst {
                    print("User name and ID in reachability: \(AuthService.instance.firstname), \(AuthService.instance.userId)")
                    if  let id = AuthService.instance.userJID {
                        print("Connect method called in App delegate")
                        XMPPService.instance.connect(with: id)
                    }
                }
            }
        }
        
        network.reachability.whenUnreachable = { reachability in
            XMPPService.instance.connectEst = false
            XMPPService.instance.disconnect()
            //XMPPService.instance.offline()
            //XMPPService.instance.xmppStream?.asyncSocket.disconnect()
        }
        
        if AuthStatus.instance.isLoggedIn {
            ///Tag lists api every 24 hours
            tagCallTimer = Timer.scheduledTimer(timeInterval: 86400, target: self, selector: #selector(runTimeCode), userInfo: nil, repeats: true)
            
        }
        
        return true
    }
    
    @objc func runTimeCode() {
        Mention.getMentions { (_) in }
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        print(#function)
      
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
              } else if let token = token {
                print("FCM registration token: \(token)")
                NotificationService.instance.apnToken = token
                NotificationService.instance.updateDeviceToken()
                
              }
           // Check for error. Otherwise do what you will with token here
            
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
     //   connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
    
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("url \(url)")
        print("url host :\(url.host!)")
        print("url path :\(url.path)")
        
        
        let urlPath : String = url.path
        let urlHost : String = url.host!
        
        if(urlHost != "myscrap.com")
        {
            print("Host is not correct")
            return false
        }
        
        if urlPath.contains("/marketLists") {
            
            let urlValue = urlPath
            
            let listRange = urlValue.range(of: "/marketLists/")
            let userRange = urlValue.range(of: "/userId")
            let market = urlValue[listRange!.lowerBound..<userRange!.lowerBound]
            let user = urlValue[userRange!.lowerBound..<urlValue.endIndex]
            let trimMarket = market.replacingOccurrences(of: "/marketLists/", with: "")
            let trimUser = user.replacingOccurrences(of: "/userId", with: "")
            print("Trim listing id : \(trimMarket), \nTrim User id :\(trimUser)")
            
            if AuthStatus.instance.isLoggedIn {
                let marketvc = DetailListingOfferVC.controllerInstance(with: trimMarket, with1: trimUser)
                //let vc = FeedsVC.storyBoardInstance()!
                let vc = MarketVC.storyBoardInstance()!
                let rearViewController = MenuTVC()
                let frontNavigationController = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                //mainRevealController.panGestureRecognizer()?.isEnabled = true
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                setRootViewController(mainRevealController)
                frontNavigationController.pushViewController(marketvc, animated: true)
            } else {
                setRootViewController(SignInViewController.storyBoardInstance()!)
            }
        } else {
            print("Url path is wrong")
        }
        self.window?.makeKeyAndVisible()
        return true
        //return GIDSignIn.sharedInstance().handle(url as URL?,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        print("Continue User Activity called: ")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url.absoluteString)
            //handle url and open whatever page you want to open.
            let urlPath : String = url.path
            let urlHost : String = url.host!
            
            if(urlHost != "myscrap.com")
            {
                print("Host is not correct")
                return false
            }
            
            if urlPath.contains("/ms/market/") {
                
                let urlValue = urlPath
                
                let listRange = urlValue.range(of: "/ms/market/")
                
                let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
                
                let trimMarket = market.replacingOccurrences(of: "/ms/market/", with: "")
                var decodedListId = ""
                print("Trim listing id : \(decodedListId)")
                
                if AuthStatus.instance.isLoggedIn {
                    if trimMarket.fromBase64() == nil {
                        decodedListId = trimMarket
                    } else {
                        decodedListId = trimMarket.fromBase64()!
                    }
                    let marketvc = DetailListingOfferVC.controllerInstance(with: decodedListId, with1: "")
                    //let vc = FeedsVC.storyBoardInstance()!
                    let vc = MarketVC.storyBoardInstance()!
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    setRootViewController(mainRevealController)
                    frontNavigationController.pushViewController(marketvc, animated: true)
                } else {
                    setRootViewController(SignInViewController.storyBoardInstance()!)
                }
            } else if urlPath.contains("/ms/feedpost/") {
                let urlValue = urlPath
                
                let listRange = urlValue.range(of: "/ms/feedpost/")
                
                let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
                
                let trimMarket = market.replacingOccurrences(of: "/ms/feedpost/", with: "")
                var decodedListId = ""
                
                
                if AuthStatus.instance.isLoggedIn {
                    if trimMarket.fromBase64() == nil {
                        decodedListId = trimMarket
                        print("Trim post id : \(decodedListId)")
                    } else {
                        decodedListId = trimMarket.fromBase64()!
                        print("Trim post id : \(decodedListId)")
                    }
                    let marketvc = DetailsVC.controllerInstance(postId: decodedListId)
                    //let vc = MarketVC.storyBoardInstance()!
                    let vc = FeedsVC.storyBoardInstance()!
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    setRootViewController(mainRevealController)
                    frontNavigationController.pushViewController(marketvc, animated: true)
                } else {
                    setRootViewController(SignInViewController.storyBoardInstance()!)
                }
            } else if urlPath.contains("/ms/video/") {
                let urlValue = urlPath
                
                let listRange = urlValue.range(of: "/ms/video/")
                
                let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
                
                let trimMarket = market.replacingOccurrences(of: "/ms/video/", with: "")
                var decodedListId = ""
                
                
                if AuthStatus.instance.isLoggedIn {
                    if trimMarket.fromBase64() == nil {
                        decodedListId = trimMarket
                        print("Trim post id : \(decodedListId)")
                    } else {
                        decodedListId = trimMarket.fromBase64()!
                        print("Trim post id : \(decodedListId)")
                    }
                    let marketvc = DetailsVC.controllerInstance(postId: decodedListId)
                    //let vc = MarketVC.storyBoardInstance()!
                    let vc = FeedsVC.storyBoardInstance()!
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    setRootViewController(mainRevealController)
                    frontNavigationController.pushViewController(marketvc, animated: true)
                } else {
                    setRootViewController(SignInViewController.storyBoardInstance()!)
                }
            }
            else if urlPath.contains("/msmonthcompany/") {
                let urlValue = urlPath
                
                let listRange = urlValue.range(of: "/msmonthcompany/")
                
                let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
                
                let trimMarket = market.replacingOccurrences(of: "/msmonthcompany/", with: "")
                var decodedListId = ""
                
                
                if AuthStatus.instance.isLoggedIn {
                    if trimMarket.fromBase64() == nil {
                        decodedListId = trimMarket
                        print("Trim company of month id : \(decodedListId)")
                    } else {
                        decodedListId = trimMarket.fromBase64()!
                        print("Trim company of month id : \(decodedListId)")
                    }
                    let marketvc = FeedsCMDetailsVC.controllerInstance(cmId: decodedListId)
                    let vc = FeedsVC.storyBoardInstance()!
                    //let vc = MarketVC.storyBoardInstance()!
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    setRootViewController(mainRevealController)
                    frontNavigationController.pushViewController(marketvc, animated: true)
                } else {
                    setRootViewController(SignInViewController.storyBoardInstance()!)
                }
            } else if urlPath.contains("/msweekperson/") {
                let urlValue = urlPath
                
                let listRange = urlValue.range(of: "/msweekperson/")
                
                let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
                
                let trimMarket = market.replacingOccurrences(of: "/msweekperson/", with: "")
                var decodedListId = ""
                
                
                if AuthStatus.instance.isLoggedIn {
                    if trimMarket.fromBase64() == nil {
                        decodedListId = trimMarket
                        print("Trim person of pow id : \(decodedListId)")
                    } else {
                        decodedListId = trimMarket.fromBase64()!
                        print("Trim person of pow id : \(decodedListId)")
                    }
                    let marketvc = FeedsPOWDetailsVC.controllerInstance(powId: decodedListId)
                    let vc = FeedsVC.storyBoardInstance()!
                    //let vc = MarketVC.storyBoardInstance()!
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    setRootViewController(mainRevealController)
                    frontNavigationController.pushViewController(marketvc, animated: true)
                } else {
                    setRootViewController(SignInViewController.storyBoardInstance()!)
                }
            } else if urlPath.contains("/ms/vote/") {
                let urlValue = urlPath
                
                let listRange = urlValue.range(of: "/ms/vote/")
                
                let voteRange = urlValue[listRange!.lowerBound..<urlValue.endIndex]
                
                let trimVote = voteRange.replacingOccurrences(of: "/ms/vote/", with: "")
                var decodedListId = ""
                
                
                if AuthStatus.instance.isLoggedIn {
                    if urlValue.contains("/ms/vote/poll") {
                        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Vote", bundle: nil)
                        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "VoterPollScreenVC") as! VoterPollScreenVC
                        homePage.voterId = decodedListId
                        
                        let vc = FeedsVC.storyBoardInstance()!
                        //let vc = MarketVC.storyBoardInstance()!
                        let rearViewController = MenuTVC()
                        let frontNavigationController = UINavigationController(rootViewController: vc)
                        let mainRevealController = SWRevealViewController()
                        mainRevealController.rearViewController = rearViewController
                        mainRevealController.frontViewController = frontNavigationController
                        setRootViewController(mainRevealController)
                        frontNavigationController.pushViewController(homePage, animated: true)
                    } else {
                        if trimVote.fromBase64() == nil {
                            decodedListId = trimVote
                            print("Trim voter id without base64: \(decodedListId)")
                        } else {
                            decodedListId = trimVote.fromBase64()!
                            print("Trim voter id decoded : \(decodedListId)")
                        }
                        /*let marketvc = ViewBioVoteVC.controllerInstance(voterId: decodedListId)
                        let vc = FeedsVC.storyBoardInstance()!
                        //let vc = MarketVC.storyBoardInstance()!
                        let rearViewController = MenuTVC()
                        let frontNavigationController = UINavigationController(rootViewController: vc)
                        let mainRevealController = SWRevealViewController()
                        mainRevealController.rearViewController = rearViewController
                        mainRevealController.frontViewController = frontNavigationController
                        setRootViewController(mainRevealController)
                        frontNavigationController.pushViewController(marketvc, animated: true)*/
                        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Vote", bundle: nil)
                        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
                        homePage.voterId = decodedListId
                        
                        let vc = FeedsVC.storyBoardInstance()!
                        //let vc = MarketVC.storyBoardInstance()!
                        let rearViewController = MenuTVC()
                        let frontNavigationController = UINavigationController(rootViewController: vc)
                        let mainRevealController = SWRevealViewController()
                        mainRevealController.rearViewController = rearViewController
                        mainRevealController.frontViewController = frontNavigationController
                        setRootViewController(mainRevealController)
                        frontNavigationController.pushViewController(homePage, animated: true)
                        //self.window?.rootViewController = nav
                    }
                    
                } else {
                    setRootViewController(SignInViewController.storyBoardInstance()!)
                }
            }
            self.window?.makeKeyAndVisible()
            return true
        }
        return true
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
        }
    }
    
    func setupWindow(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        setupInitialViewController()
    }
    
    
    func clearCoreDataStore(){
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            for i in 0...delegate.persistentContainer.managedObjectModel.entities.count-1 {
                let entity = delegate.persistentContainer.managedObjectModel.entities[i]
                do {
                    let query = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                    let deleterequest = NSBatchDeleteRequest(fetchRequest: query)
                    try context.execute(deleterequest)
                    try context.save()
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                    abort()
                }
            }
    }
    
    private func setupNetworkReachable(){
        /*NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachabillity)
        do {
            try reachabillity.startNotifier()
        } catch {
            print("Could not start notifier")
        }*/
    }
    
    @objc
    func reachabilityChanged(_ note: Notification){
        /*guard let reachability = note.object as? Reachability else { return }
        switch reachability.connection {
        case .wifi,.cellular:
            if AuthStatus.instance.isLoggedIn {
                print("User name and ID in reachability: \(AuthService.instance.firstname), \(AuthService.instance.userId)")
                if  let id = AuthService.instance.userJID {
                    print("Connect method called in App delegate")
                    XMPPService.instance.connect(with: id)
                }
            }
        default:
            print("not reachable")
        }*/
    }
    
    private func stopNetworkReachable(){
//        reachabillity.stopNotifier()
//        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachabillity)
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        //stopNetworkReachable()
        if AuthStatus.instance.isLoggedIn {
          //  goBackground()
            self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                    self.endBackgroundUpdateTask()
                })
        } else {
            //comment xmpp on 11/march/2020 -> reverted back
            XMPPService.instance.offline()
            XMPPService.instance.disconnect()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        self.endBackgroundUpdateTask()
        if AuthStatus.instance.isLoggedIn{
            //uncomment xmpp on 11/march/2020 -> reverted back 12/March
            let jid = AuthService.instance.userJID
                print("User name and ID in did active: \(AuthService.instance.firstname), \(AuthService.instance.userId)")
            if XMPPService.instance.xmppStream?.isConnecting() == false && XMPPService.instance.isConnected == false && XMPPService.instance.xmppStream?.isAuthenticating() == false && XMPPService.instance.xmppStream?.isAuthenticated() == false {
             //   XMPPService.instance.disconnect()
                  //  XMPPService.instance.connect(with: jid!)
                  //  XMPPService.instance.enableBackgroundingOnSocket
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        XMPPService.instance.sendOnline()
                    }
                } else {
                    print("XMPP already conneccted in app become active")
                }
            
            NotificationService.instance.getNotificationCount()
        }
        LocationService.sharedInstance.setupLocationManager()
        //Updating the user location
        LocationService.sharedInstance.processLocation()
        setupNetworkReachable()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(false, forKey: "isGuest")
        //commenting to test 11/march/2020 - >reverted back 12/March
        XMPPService.instance.offline()
        XMPPService.instance.disconnect()
        self.saveContext()
    }
    
    func handleNotificationWhenAppIsKilled(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Check if launched from the remote notification and application is close
        if let remoteNotification = launchOptions?[.remoteNotification] as?  [AnyHashable : Any] {
            // Handle your app navigation accordingly and update the webservice as per information on the app.
            let jid = AuthService.instance.userJID
            /*if XMPPService.instance.isConnected == false {
                XMPPService.instance.connect(with: jid!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    XMPPService.instance.sendOnline()
                }
            } else {
                print("XMPP already in connect at back ground voip")
            }*/
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "myscrap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}




extension AppDelegate{
    
    // MARK:- SETUP NAVIGATION BARS
    fileprivate func setupNavigationBar(){
        UINavigationBar.appearance().barTintColor = UIColor(red: 33/255.0, green: 108/255.0, blue: 41/255.0, alpha: 0.1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barStyle = .black
        UIApplication.shared.statusBarStyle = .lightContent
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.WHITE_ALPHA,
            NSAttributedString.Key.font : Fonts.NAVIGATION_FONT!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
}



// MARK:- INITIAL VIEW CONTROLLER
extension AppDelegate{
    
     func setupInitialViewController(){
        
        if !AuthStatus.instance.isApiKeyRegistered{
            AuthService.instance.isDeviceRegistered = false
            AuthStatus.instance.apiKey = UIDevice.current.identifierForVendor?.uuidString.lowercased()
            AuthStatus.instance.isApiKeyRegistered = true
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            setSignInViewController()
        } else {
            if AuthStatus.instance.isLoggedIn{
                let _ = getRearViewController()
                //initializeLandingPage()
            } else {
                setSignInViewController()
            }
        }
    }
    
    func initializeLandingPage() {
        //setRootViewController(VideoPlayerVC.storyBoardInstance()!)
        /*window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let storyboard = UIStoryboard.init(name: "Land", bundle: nil)
        
        // controller identifier sets up in storyboard utilities
        // panel (on the right), it called Storyboard ID
        let viewController = storyboard.instantiateViewController(withIdentifier: "LandTabControllerV2") as! LandTabControllerV2
        
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
        window?.makeKeyAndVisible()
        window?.rootViewController = viewController*/
    }
    
    
    func setSignInViewController(){
        setRootViewController(SignInViewController.storyBoardInstance()!)
    }
    
    func getRearViewController() -> UIViewController{
        //let vc = LandHomePageVC.storyBoardInstance()!
        let vc = FeedsVC.storyBoardInstance()!
        //let vc = MarketVC.storyBoardInstance()!
        //Setting up Covid Poll shown while launching the app
        //vc.showCovidPoll = true
        let rearViewController = MenuTVC()
        let frontNavigationController = UINavigationController(rootViewController: vc)
        let mainRevealController = SWRevealViewController()
        mainRevealController.panGestureRecognizer()?.isEnabled = true
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        setRootViewController(mainRevealController)
        return vc
    }
    
    private func setRootViewController(_ viewController: UIViewController){
        window?.rootViewController = viewController
    }
    
    func setGuestVC(){
        //let vc = LandHomePageVC.storyBoardInstance()!
        let vc = FeedsVC.storyBoardInstance()!
        //let vc = MarketVC.storyBoardInstance()!
        let rearViewController = MenuTVC()
        let frontNavigationController = UINavigationController(rootViewController: vc)
        let mainRevealController = SWRevealViewController()
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        setRootViewController(mainRevealController)
    }
}
extension AppDelegate{
    
    fileprivate func setupIQKeyBoardManager(){
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
//        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 20
    }
    
    fileprivate func setupLocation(){
        locationManager.requestWhenInUseAuthorization()
        LocationService.sharedInstance.setupLocationManager()
        UserDefaults.standard.set(false, forKey: "locationSended")
    }

    func performFriendView(friendId: String){
        //let vc = FeedsVC.storyBoardInstance()
        //let vc = MarketVC.storyBoardInstance()
        if let vc = FeedsVC.storyBoardInstance(){
        //if let vc = LandHomePageVC.storyBoardInstance(){
            switch friendId {
            case nil:
                return
            case "":
                return
            default:
                let rearViewController = MenuTVC()
                let frontNavigationController = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                self.window!.rootViewController = mainRevealController
                self.window?.makeKeyAndVisible()//
                if let vc = FriendVC.storyBoardInstance() {
                    rearViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

// MARK:- Push Notifications

// Voip Functions
extension AppDelegate: PKPushRegistryDelegate {
    private func runAfterDelay(_ delay: Double, closure: @escaping () -> Void){
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    @available(iOS 8.0, *)
    func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {
        // Process the received push


    }
    func getMember(with messageId: String, context: NSManagedObjectContext) -> Member?{
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "msgId = %@", messageId)
        fetchRequest.fetchLimit = 1
        do {

            guard let message = try context.fetch(fetchRequest).first , let member = message.member  else { return nil }
            return member

        } catch {
            print("error executing")
            return nil
        }
    }
    
    
    func pushRegistry(_ registry: PKPushRegistry,  IncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        DispatchQueue.main.async {
            
            if UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive {
                print("processing background")
             //   self.goBackground()
            }
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let token = pushCredentials.token.map{ String(format: "%02.2hhx", $0 )}.joined()
        print("Push kit device token",token)
        NotificationService.instance.voipToken = token
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        debugPrint("i'm in pushkit handled")
    }
    
    func voipRegistration(){
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        if #available(iOS 11.0, *) {
            voipRegistry.desiredPushTypes = [PKPushType.voIP]
        } else {
            // Fallback on earlier versions
        }
    }
    

//    - (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
//    NSLog(@"VoIP - got Push with payload: %@ and Type: %@", payload.dictionaryPayload, type);
//
//    NSDictionary *dictAps = [payload.dictionaryPayload valueForKey:@"aps"];
//    if ([dictAps valueForKey:@"content-available"] != nil) {
//    NSLog(@"Silent VoIP");
//
//    //Fetch payload info and create local notification and fire that local notification.
//    UILocalNotification *voipNotification = [[UILocalNotification alloc] init];
//    voipNotification.alertTitle = @"Silent VoIP";
//    voipNotification.alertBody = [dictAps valueForKey:@"alert"];
//    voipNotification.soundName = UILocalNotificationDefaultSoundName;
//    [[UIApplication sharedApplication] presentLocalNotificationNow:voipNotification];
//
//    //Call xmpp connection method here.
//    if (xmppStream == nil) { [self setupStream]; }
//    if ([xmppStream isDisconnected]) { [self connect]; }
//    }
//    }
//
//    - (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
//    NSLog(@"VoIP - device Token: %@", credentials.token);
//
//    NSString *newToken = credentials.token.description;
//    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    NSLog(@"VoIP token is: %@", newToken);
//    [obj_DataModel setVoIPToken:newToken]; //Store token in somewhere for further use.
//    }
    //Note :- Commenting Background Run ==> #Prevent the App termination after 3 minutes -> reverted back 12/march
    
    fileprivate func goBackground(){
        
        let app = UIApplication.shared
        
        bgTask = app.beginBackgroundTask(expirationHandler: {
            if AuthStatus.instance.isLoggedIn == false {
                //if XMPPService.instance.xmppStream?.isConnecting() == false || XMPPService.instance.xmppStream?.isConnected() == false  || XMPPService.instance.xmppStream?.isAuthenticating() == false {
                    
                    XMPPService.instance.offline()
                    XMPPService.instance.disconnect()
                    self.endBackgroundTask()
                //}

            } else {
                print("Voip were expiring")
                XMPPService.instance.offline()
             //   XMPPService.instance.disconnect()
                //To prevent crash commented on Nov13/19
                //let jid = AuthService.instance.userJID
                //if XMPPService.instance.xmppStream?.isConnecting() == false || XMPPService.instance.xmppStream?.isConnected() == false  || XMPPService.instance.xmppStream?.isAuthenticating() == false {
                    //if !XMPPService.instance.connectEst {
                        //XMPPService.instance.connect(with: jid!)
                        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            //XMPPService.instance.sendOnline()
                        //}
                    //} else {
                      //  print("XMPP connection started already")
                    //}
                //} else {
                  //  print("XMPP already in connect at back ground voip")
               // }
            }
        })
        
        /*let app = UIApplication.shared
        var bgTask : UIBackgroundTaskIdentifier = 0
        bgTask = app.beginBackgroundTask(expirationHandler: {
            XMPPService.instance.offline()
            XMPPService.instance.disconnect()
            print("Voip were expiring")
            app.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskInvalid
        })*/
        
        
        if AuthStatus.instance.isLoggedIn {
            if let jid = AuthService.instance.userJID {
                if network.reachability.isReachable == true {
                    print("User name and ID in background: \(AuthService.instance.firstname), \(AuthService.instance.userId)")
                    if XMPPService.instance.xmppStream?.isConnecting() == false && XMPPService.instance.xmppStream?.isConnected() == false && XMPPService.instance.xmppStream?.isAuthenticating() == false && XMPPService.instance.xmppStream?.isAuthenticated() == false{
                        if !XMPPService.instance.connectEst {
                            XMPPService.instance.connect(with: jid)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                XMPPService.instance.sendOnline()
                            }
                        }
                        
                    } else {
                        print("XMPP already in connect at back ground")
                    }
                }
                network.reachability.whenUnreachable = { reachability in
                    if XMPPService.instance.xmppStream?.isConnecting() == false || XMPPService.instance.xmppStream?.isConnected() == false  || XMPPService.instance.xmppStream?.isAuthenticating() == false {
                        XMPPService.instance.connectEst = false
                        XMPPService.instance.disconnect()
                        XMPPService.instance.offline()
                    } else {
                        print("Couldn't disconnect from xmpp sever")
                    }
                    
                }
            }
        }
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        let app = UIApplication.shared
        app.endBackgroundTask(bgTask)
        bgTask = UIBackgroundTaskIdentifier.invalid
    }
 
}
