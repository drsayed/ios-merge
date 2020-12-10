//
//  MenuVC.swift
//  myscrap
//
//  Created by MS1 on 12/12/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import CoreData
import FacebookLogin
import FBSDKLoginKit
import XMPPFramework

class MenuVC: UIViewController {
    
    //@IBOutlet weak var initialLbl: InitialLabel!
    @IBOutlet weak var intialLbl: UILabel!
    
    
    fileprivate var headerViewHeightConstraint: NSLayoutConstraint?
    var selectedIndex: Int?
    
    var isComingFromBump : Bool = false
    
    fileprivate var dataSource : [MenuItem] = [MenuItem]()
    
    lazy var menuHeaderView: MenuHeaderView = {
        let mv = MenuHeaderView(frame: .zero, name: AuthService.instance.fullName, profilePic: AuthService.instance.profilePic, colorCode: AuthService.instance.colorCode, initial: AuthService.instance.initial!)
        mv.notificationCount = AuthStatus.instance.isLoggedIn ? NotificationService.instance.notificationCount : 0
        mv.messageCount = AuthStatus.instance.isLoggedIn ? NotificationService.instance.messageCount : 0
        mv.profileCount = AuthStatus.instance.isLoggedIn ? NotificationService.instance.profileCount : 0
        
        
        print(mv.profileCount)
        print("Initials :\(AuthService.instance.initial)")
        
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.delegate = self
        return mv
    }()
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = UIColor.white
        view.addSubview(menuHeaderView)
        view.addSubview(tableView)
        if isComingFromBump {
                selectedIndex = 5
        } else {
            selectedIndex = 0
        }
        
        
        headerViewHeightConstraint = menuHeaderView.heightAnchor.constraint(equalToConstant: 175)
        headerViewHeightConstraint?.isActive = true
        menuHeaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuHeaderView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        
        //table View
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
        setupRevealViewController()
        setupTableView()
        setupBadgeCountObservers()
        //intialLbl.text = AuthService.instance.fullName.initials()
    }
    
    private func setupRevealViewController(){
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        self.revealViewController().rearViewRevealOverdraw = 0
        self.revealViewController().bounceBackOnOverdraw = false
        self.revealViewController().stableDragOnOverdraw = true
    }
    private func setupTableView(){
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
    }
    
    private func setupBadgeCountObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(notificationChanged(_:)), name: .notificationCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationChanged(_:)), name: .messageCountChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(menuTableItemsChanded(_:)), name: .visitorsCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(menuTableItemsChanded(_:)), name: .bumpCountChanged, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuVC.signedOut(_:)), name: .userSignedOut, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuVC.moderatorChanged), name: .moderatorChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationChanged(_:)), name: .profileCountChanged, object: nil)
    }
    
    @objc private func moderatorChanged(){
        
        dataSource = MenuItem.getMenuItes()
        tableView.reloadData()
    }
    
    
    @objc private func notificationChanged(_ notification: Notification){
        menuHeaderView.notificationCount =  NotificationService.instance.notificationCount
        print("Message Count : \(String(describing: NotificationService.instance.messageCount))")
        menuHeaderView.messageCount = NotificationService.instance.messageCount
        menuHeaderView.profileCount = NotificationService.instance.profileCount
    }
    
    @objc private func menuTableItemsChanded(_ notification: Notification){
        self.tableView.reloadData()
    }
    
    
    //MARK:- Push View Controller
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        guard !checkisGuest else {
            self.showGuestAlert(); return
        }
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let nav = UINavigationController(rootViewController: vc)
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .notificationCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .bumpCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .visitorsCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userSignedOut, object: nil)
        NotificationCenter.default.removeObserver(self, name: .moderatorChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .profileCountChanged, object: nil)
    }
    
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        let item = dataSource[indexPath.row]
        cell.menuItem = item
        cell.cellSelected = selectedIndex == indexPath.item
        return cell
    }
    
    private func selectAndReload(with indexPath: IndexPath){
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        switch dataSource[indexPath.item].menuTitle {
        case .land:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.LAND, Identifier: LandHomePageVC.id)
        /*case .feed:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.MAIN, Identifier: FeedsVC.id)*/
        case .members:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.MAIN, Identifier: MembersVC.id)
        case .companies:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.COMPANIES, Identifier: CompaniesVC.id)
        case .visitors:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.MAIN, Identifier: VisitorsVC.id, checkisGuest: AuthStatus.instance.isGuest)
        case .nearBy:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.MAIN, Identifier: PeopleVc.id,checkisGuest: AuthStatus.instance.isGuest)
        case .favourites:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.FAVOURITE, Identifier: FavouriteVC.id, checkisGuest: AuthStatus.instance.isGuest)
        case .news:
//            selectAndReload(with: indexPath)
//            pushViewController(storyBoard: StoryBoard.MAIN, Identifier: NewsVC.id)
            print("news is disabled for now")
        case .discover:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.MAIN, Identifier: DiscoverVC.id)
        case .prices:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.MAIN, Identifier: PricesVC.id)
            /*if AuthStatus.instance.isShared{
                selectAndReload(with: indexPath)
                pushViewController(storyBoard: StoryBoard.MAIN, Identifier: PricesVC.id)
            } else {
                processSharing(with: indexPath)
            }*/
        case .inviteFriends:
            inviteFriends()
        case .about:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.ABOUT, Identifier: AboutMyscrapVC.id)
        case .logout:
            self.performLogOut()
        /*case .bump:
            if AuthStatus.instance.isGuest{
                showGuestAlert()
            } else {
                selectAndReload(with: indexPath)
                let vc = BumpedVC()
                vc.title = MenuName.bump.rawValue
                let nav = UINavigationController(rootViewController: vc)
                revealViewController().pushFrontViewController(nav, animated: true)
            }*/
        case .calendar:
            selectAndReload(with: indexPath)
            let vc = CalendarVC()
            vc.title = MenuName.calendar.rawValue
            let nav = UINavigationController(rootViewController: vc)
            revealViewController().pushFrontViewController(nav, animated: true)
        case .report:
            selectAndReload(with: indexPath)
            let vc = ReportedVC()
            vc.title = MenuName.report.rawValue
            let nav = UINavigationController(rootViewController: vc)
            revealViewController().pushFrontViewController(nav, animated: true)
        case .market:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)
        case .mylisting:
            selectAndReload(with: indexPath)
            pushViewController(storyBoard: StoryBoard.MARKET, Identifier: "MyListingsVC", checkisGuest: AuthStatus.instance.isGuest)
//        case .inbox:
//            selectAndReload(with: indexPath)
//            pushViewController(storyBoard: StoryBoard.EMAIL, Identifier: "EmailInboxVC", checkisGuest: AuthStatus.instance.isGuest)
        
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func processSharing(with indexPath: IndexPath){
        
        let alert = UIAlertController(title: "LME | COMEX | SHANGHAI", message: "To get Live Metal Price for free, share this app with one of your friend here.", preferredStyle: .alert)
        let shareAction = UIAlertAction(title: "SHARE", style: .cancel) { [weak self] (action) in
            let activityVC = UIActivityViewController(activityItems: ["MyScrap is an application which helps leveraging your business and linking your profile to active users.\n\nMyScrap empowers users to strengthen recycling business all over the world to outreach effectively that has direct benefits building comprehensive marketing strategy as per clients business need.\n\nMyscrap is accessible, reliable and easy to download in iOS & Android through internet connections without any hassle.\n\nGet it now from https://myscrap.com/login"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self?.view
            activityVC.view.tintColor = UIColor.GREEN_PRIMARY
            
            activityVC.excludedActivityTypes = [ .copyToPasteboard, .print, .saveToCameraRoll, .addToReadingList , .assignToContact , .message, .message]
            
            activityVC.completionWithItemsHandler = {  [weak self] activity, success, items, error in
                if success {
                    AuthStatus.instance.isShared = true
                    self?.selectAndReload(with: indexPath)
                    self?.pushViewController(storyBoard: StoryBoard.MAIN, Identifier: PricesVC.id)
                }
            }
            self?.present(activityVC, animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title: "MAYBE LATER", style: .default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(shareAction)
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        present(alert, animated: true, completion: nil)
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !AuthStatus.instance.isGuest{
            updateMessageCount()
        }
        dataSource = MenuItem.getMenuItes()
        tableView.reloadData()
            NotificationService.instance.getNotificationCount()
    }
    
    
    fileprivate func updateMessageCount(){
//        let app = UIApplication.shared.delegate as! AppDelegate
//        app.persistentContainer.performBackgroundTask { (context) in
//            context.perform {
//                let req: NSFetchRequest<Message> = Message.fetchRequest()
//                req.predicate = NSPredicate(format: "status = %@", "0")
//
//                do {
//                    let result = try context.fetch(req)
//                    NotificationService.instance.messageCount = result.count
//                } catch let err {
//                    print(err.localizedDescription)
//                }
//            }
//        }
        NotificationService.instance.messageCount = 0

    }
    
    //MARK:- Invite Friends
    fileprivate func inviteFriends(){
        let activityVC = UIActivityViewController(activityItems: ["MyScrap is an application which helps leveraging your business and linking your profile to active users.\n\nMyScrap empowers users to strengthen recycling business all over the world to outreach effectively that has direct benefits building comprehensive marketing strategy as per clients business need.\n\nMyscrap is accessible, reliable and easy to download in iOS & Android through internet connections without any hassle.\n\nGet it now from https://myscrap.com/login"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
//        activityVC.popoverPresentationController?.sourceView?.tintColor = Colors.GREEN_PRIMARY
        
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension MenuVC:MenuHeaderViewDeleagate{
    func DidTapOnNotificationIcon() {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            presentViewController(isGuest: AuthStatus.instance.isGuest, storyBoard: StoryBoard.MAIN, identifier: NotificationVC.id)
        }
    }
    
    func DidTapForProfile() {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        }else {
                clearSelection()
             self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: ProfileVC.id, checkisGuest: AuthStatus.instance.isGuest)
        }
    }
    
    func DidTapMessageICon() {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        }else {
            if AuthStatus.instance.isGuest{
                self.showGuestAlert()
            } else {
                let vc = UINavigationController(rootViewController: ChatVC())
                present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK:- Present View Controller
    private func presentViewController(isGuest:Bool, storyBoard: String, identifier: String){
        guard !isGuest else { self.showGuestAlert(); return }
        let vc = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier : identifier)
        let nav = UINavigationController(rootViewController: vc)
      
        self.revealViewController().present(nav, animated: true, completion: nil)
    }
    
    private func clearSelection(){
        if let index = selectedIndex{
            let indexPath = IndexPath(row: index, section: 0)
            selectedIndex = nil
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension MenuVC{
    
    fileprivate func performLogOut(){
        let alert = UIAlertController(title: "", message: "Are you sure to Log out?", preferredStyle: .alert)
        let logout = UIAlertAction(title: "Logout", style: .destructive) { (
            action) in
            //perform logout
            if let window = UIApplication.shared.keyWindow {
               
                
                let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
                overlay.alpha = 0.5
                overlay.backgroundColor = UIColor.black
                window.addSubview(overlay)
                
                
                let av = UIActivityIndicatorView(style: .whiteLarge)
                av.center = overlay.center
                av.startAnimating()
                overlay.addSubview(av)
                
            
                AuthService.instance.logoutUser({ (loggedOut) in
                    if loggedOut{
                        let loginManager = FBSDKLoginManager()                              //Maha manually logout from fb
                        loginManager.logOut() // this is an instance function
                        NotificationCenter.default.post(name: .userSignedOut, object: nil)
                        //AuthService.instance.removeRegistrationDetails(profilePic: UserDefaults.PROFILE_PIC,loggedOut: true)
                        XMPPService.instance.disconnect()
                        XMPPService.instance.offline()
                        av.stopAnimating()
                        overlay.removeFromSuperview()
                    } else {
                        NotificationCenter.default.post(name: .userSignedOut, object: nil)
                        XMPPService.instance.disconnect()
                        XMPPService.instance.offline()
                        av.stopAnimating()
                        overlay.removeFromSuperview()
                    }
                })
            }
        
            // TODO:- ACTIVITY INDICATOR
            

        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logout)
        alert.addAction(cancel)
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func signedOut(_ notification: Notification){
        AuthStatus.instance.isLoggedIn = false
        
//        if let delegate = UIApplication.shared.delegate as? AppDelegate , let window = delegate.window , let signInController = SignInViewController.storyBoardInstance() {
//                window.rootViewController = signInController
//        }
    }
    
 
}
