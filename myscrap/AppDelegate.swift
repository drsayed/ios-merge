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
import Starscream
let uiRealm = try! Realm()
let network: NetworkManager = NetworkManager.sharedInstance
public typealias SimpleClosure = (() -> ())

protocol NotificationRedirectionDelegate : class {
    func openPostDetailsView(postId : String)
    func openEventDetailsView(eventId : String)
    func openFriendVCView(friendId : String,isFromCardNoti : String)
    func openCompanyDetailsView(companyId : String)
    func openMarketDetailsView(userId : String,listingId : String)
    func openNotificationsView()
    func openJoinLiveVCNotificationsView(userId : String,liveId : String,fName : String,profilePic : String,colorCode : String,liveType : String)
    func openFeedsVCView()
    

}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, MessagingDelegate,GIDSignInDelegate {
    let center = UNUserNotificationCenter.current()
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var bgTask : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var ping : XMPPPing!
    var webRTCClient: AntMediaClient = AntMediaClient.init()
    var webRTCViewerClient: AntMediaClient = AntMediaClient.init()
    var playerClients:[AntMediaClientConference] = [];
    weak var directionDelegate : NotificationRedirectionDelegate?

    var playerClient1: AntMediaClient = AntMediaClient.init()
    var playerClient2: AntMediaClient = AntMediaClient.init()
    
    var conferenceClient: ConferenceClient!
    
    var liveID = ""
    var isStreamer = false
    var isDualLive = false
    var isStreamerDisconeted = false
    var xmppAutoPing: XMPPAutoPing!
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    var fireBaseConfig = false
    var isLandMenuSelected = false
    var isFeedMenuSelected = false
    var isMarketMenuSelected = false
    var isPricesMenuSelected = false
    var isChatMenuSelected = false
    var isDiscoverMenuSelected = false
    var isCompanyMenuSelected = false
    var isMembersMenuSelected = false
    var isAppLaunching = false
    fileprivate let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "log")
    var tagCallTimer: Timer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        self.registerForNotifications(application)
        //If Logged then only can register for FCM
        if AuthStatus.instance.isLoggedIn {
            isAppLaunching = true
            self.registerForNotifications(application)
            FirebaseApp.configure()
            UserDefaults.standard.setValue("0", forKey: "MuteValue")
            Messaging.messaging().delegate = self
            fireBaseConfig = true
        }
        
        webRTCClient.delegate = self
//        playerClient1.delegate = self
//        playerClient2.delegate = self
        
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
       setupIQKeyBoardManager()
        setupLocation()
        AuthStatus.instance.isGuest = false
        setupNavigationBar()
        self.checkUpdateVersion()
        // Initialize Google sign-in
        GIDSignIn.sharedInstance().clientID = "1016788342618-v7jk56j1vcpsk1oncdluvv74t69vs81h.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        //Connecting XMPP when app launches
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
            
        }
        
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
        } else {
            print("Url path is wrong")
        }
        self.window?.makeKeyAndVisible()
        return true
        
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
        
    }
    
    @objc
    func reachabilityChanged(_ note: Notification){
        
    }
    
    private func stopNetworkReachable(){
        
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        //stopNetworkReachable()
        if webRTCClient.isConnected() {
            self.setUserStatusEndLive()
            self.webRTCClient.stop()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AppCloseed"), object: nil, userInfo: nil)
  
        }
      
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
        if webRTCClient.isConnected() {
            self.setUserStatusEndLive()
            self.webRTCClient.stop()
        }
      
        self.saveContext()
    }
    
    func handleNotificationWhenAppIsKilled(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Check if launched from the remote notification and application is close
        if let remoteNotification = launchOptions?[.remoteNotification] as?  [AnyHashable : Any] {
            // Handle your app navigation accordingly and update the webservice as per information on the app.
            let jid = AuthService.instance.userJID
            
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "myscrap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
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
    
    @objc func setUserStatusEndLive()  {
        if isStreamer {
            DispatchQueue.global(qos:.userInteractive).async {
            let op = UserLiveOperations()
                op.userEndLive (id: "\(AuthService.instance.userId)" ) { (onlineStat) in
                    for client in self.playerClients
                    {
                        client.playerClient.stop();
                    }
                    self.conferenceClient.leaveRoom()
              
                    print(onlineStat)
            }
            }
        }
        else{
            DispatchQueue.global(qos:.userInteractive).async {
            let op = UserLiveOperations()
                op.userEndViewLive(id: "\(AuthService.instance.userId)", liveid: self.liveID) { (onlineStat) in
                    for client in self.playerClients
                    {
                        client.playerClient.stop();
                    }
                    self.conferenceClient.leaveRoom()
                    print(onlineStat)
            }
            }
        }
       
    }
   
    
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
        }
    }
    fileprivate func goBackground(){
        
        let app = UIApplication.shared
        
        bgTask = app.beginBackgroundTask(expirationHandler: {
            if AuthStatus.instance.isLoggedIn == false {
                
                XMPPService.instance.offline()
                XMPPService.instance.disconnect()
                self.endBackgroundTask()
                
            } else {
                print("Voip were expiring")
                XMPPService.instance.offline()
                
            }
        })
        
        
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
extension AppDelegate : AntMediaClientDelegate
{
    func remoteStreamStarted(streamId: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)
    }
    
    func remoteStreamRemoved(streamId: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "remoteStreamRemoved"), object: nil, userInfo: nil)
    }
    
    func localStreamStarted(streamId: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)

    }
    
    func playStarted(streamId: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playStarted"), object: nil, userInfo: nil)
    }
    
    func playFinished(streamId: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playFinished"), object: nil, userInfo: nil)
    }
    
    func publishStarted(streamId: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PublishStarted"), object: nil, userInfo: nil)
    }
    
    func publishFinished(streamId: String) {
    }
    
    func disconnected(streamId: String) {
        if streamId.contains("stream1room") {
            if !self.isStreamerDisconeted {
                webRTCClient.stop()
            }
        }
    }
    
    func audioSessionDidStartPlayOrRecord(streamId: String) {
        webRTCClient.speakerOn()
    }
    
    func streamInformation(streamInfo: [StreamInformation]) {
        
    }
    func clientDidConnect(_ client: AntMediaClient) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)
      
        
    }
    
    func clientDidDisconnect(_ message: String) {
        print("Stream get error \(message)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clientDidDisconnect"), object: nil, userInfo: nil)
    }
    
    func clientHasError(_ message: String) {
        print("Stream get error \(message)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clientHasError"), object: nil, userInfo: nil)
    }

    
    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        
        if binary {

            let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: data)
            if isDualLive {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CameraToggleDualLive"), object: nil, userInfo: unarchivedDictionary as? [String: AnyObject])
            }
            else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CameraToggleSingleLive"), object: nil, userInfo: unarchivedDictionary as? [String: AnyObject])
            }
            

        }
        else{
        do {

            let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: data)

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecievedMessage"), object: nil, userInfo: unarchivedDictionary as? [String: AnyObject])
        

            
                
        }
        catch{
            print(error)
        }
        }
}
}
