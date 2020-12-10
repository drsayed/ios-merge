//
//  LandHomePageVC.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class LandHomePageVC: BaseRevealVC, FriendControllerDelegate {

    @IBOutlet weak var spinnerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var dataSource = [LandingItems]()
    fileprivate var onlineDSource = [LOnlineItems]()
    fileprivate var feedsDSource = [LFeedsItem]()
    fileprivate var marketDSource = [LMarketItems]()
    fileprivate var menuDSource = [LMenuItems]()
    fileprivate var service = LandingService()
    
    fileprivate var isRefreshControl = false
    
    /*First time while login the app this api get called
     Get data from API and stores into Realm DB */
    var roastItems = [RoasterItems]()
    let roastHistory = RoasterHistory()
    var isSignedIn = false
    
    fileprivate lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = UIColor.MyScrapGreen
        //rc.attributedTitle = NSAttributedString(string: "PULL DOWN TO REFRESH", attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 14)!, NSAttributedStringKey.foregroundColor : UIColor.MyScrapGreen])
        rc.addTarget(self, action:
            #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    @objc
    fileprivate func handleRefresh(){
        if network.reachability.isReachable == true {
            
            isRefreshControl = true
            self.getLandingData(completion: { _ in
                print(self.dataSource[1].dataFeeds.count, "Landing items count ")
            })
            
        } else {
            self.showToast(message: "No internet connection")
        }
        
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //MarketADShowPopup
    var showPopup = false
    

    var fromDetailedFeeds = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.spinnerHeightConstraint.constant = 58
        self.spinner.startAnimating()
        //self.refreshControl.beginRefreshing()
        
        //self.handleRefresh()
        //getLandingData(completion: {_ in })
        getLandingData(completion: { error in
            if error {
                print("No Data in Landing page")
            } else {
                print(self.dataSource[1].dataFeeds.count, "Landing items count ")
                self.collectionView.refreshControl = self.refreshControl
            }
        })
        setupCV()
        
        //Showing Market AD POPUP here
        if showPopup {
            self.showingMarketPopup()
        }
        
        if isSignedIn {
            let group = DispatchGroup()
            group.enter()
            self.getRoasterHistory(completion: { _ in       //self.feedDataSource.count
                group.leave()
            })
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if fromDetailedFeeds {
            if !self.spinner.isAnimating && !refreshControl.isRefreshing {
                self.spinner.isHidden = false
                self.spinnerHeightConstraint.constant = 58
                self.spinner.startAnimating()
                //self.refreshContol.beginRefreshing()
                self.handleRefresh()
            }
        }
    }
    
    func getLandingData(completion: @escaping (Bool) -> ()) {
        //service.delegate = self
        //service.getLandingData()
        service.getLandingData { (result) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
                //if self.spinner.isAnimating { self.spinner.stopAnimating() }
                if self.isRefreshControl{
                    self.dataSource = [LandingItems]()
                    self.isRefreshControl = false
                    self.spinnerHeightConstraint.constant = 0
                    self.spinner.isHidden = true
                }
                if self.spinner.isAnimating {
                    self.spinnerHeightConstraint.constant = 0
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                }
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Landing data count",self.dataSource.count)
                    let newData = data
                    //newData.removeDuplicates()
                    self.dataSource = newData
                    self.collectionView.reloadData()
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    completion(true)
                }
            }
        }
    }
    
    
    func getRoasterHistory(completion: @escaping (Bool) -> ()) {
        print("Get roaster history from api")
        roastHistory.getRoasterHistory()
    }
    
    func showingMarketPopup() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketAdvPopUpVC") as! MarketAdvPopUpVC
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func setupCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //collectionView.register(Land_Online_OverAllCell.Nib, forCellWithReuseIdentifier: Land_Online_OverAllCell.identifier)
        //collectionView.register(Land_Feeds_OverAllCell.Nib, forCellWithReuseIdentifier: Land_Feeds_OverAllCell.identifier)
        //collectionView.register(Land_Market_OverAllCell.Nib, forCellWithReuseIdentifier: Land_Market_OverAllCell.identifier)
        //collectionView.register(Land_Menu_OverAllCell.Nib, forCellWithReuseIdentifier: Land_Menu_OverAllCell.identifier)
    }
    static func storyBoardInstance() -> LandHomePageVC? {
        let sb = UIStoryboard.LAND
        return sb.instantiateViewController(withIdentifier: LandHomePageVC.id) as? LandHomePageVC
    }
    
    func performLikeVC(postId: String){
        let vc = LikesController()
        vc.title = "Likes"
        vc.id = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension LandHomePageVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*if section == 0 {
            if onlineDSource.count != 0 {
                return 1
            }else {
                return 0
            }
        } else if section == 1 {
            if feedsDSource.count != 0 {
                return 1
            } else {
                return 0
            }
        } else if section == 2 {
            if marketDSource.count != 0 {
                return 1
            } else{
                return 0
            }
        } else if section == 3 {
            if onlineDSource.count != 0 && feedsDSource.count != 0 && marketDSource.count != 0 {
                return 1
            } else {
                return 0
            }
        }*/
        if dataSource.count != 0 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let onlineData = onlineDSource[indexPath.item]
        //let feedsData = feedsDSource[indexPath.item]
        //let marketData = marketDSource[indexPath.item]
        let onlineData = dataSource[0]
        let feedsData = dataSource[1]
        let marketData = dataSource[2]
        let menuData = dataSource[3]
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Online_OverAllCell", for: indexPath) as? Land_Online_OverAllCell else { return UICollectionViewCell()}
            cell.item = onlineData
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Feeds_OverAllCell", for: indexPath) as? Land_Feeds_OverAllCell else { return UICollectionViewCell()}
            cell.item = feedsData
            cell.delegate = self
            
            return cell
        } else if indexPath.section == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Market_OverAllCell", for: indexPath) as? Land_Market_OverAllCell else { return UICollectionViewCell()}
            cell.item = marketData
            cell.delegate = self
            cell.viewAllActionBlock = {
                if let vc = MarketVC.storyBoardInstance() {
                    if AuthStatus.instance.isGuest{
                        print("Guest user")
                        self.showGuestAlert()
                    } else {
                        self.appDelegate.isAppLaunching = false
                        self.appDelegate.isLandMenuSelected = false
                        self.appDelegate.isFeedMenuSelected = false
                        self.appDelegate.isMarketMenuSelected = true
                        self.appDelegate.isPricesMenuSelected = false
                        self.appDelegate.isChatMenuSelected = false
                        self.appDelegate.isDiscoverMenuSelected = false
                        self.appDelegate.isCompanyMenuSelected = false
                        self.appDelegate.isMembersMenuSelected = false
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Menu_OverAllCell", for: indexPath) as? Land_Menu_OverAllCell else { return UICollectionViewCell()}
            cell.item = menuData
            cell.delegate = self
            return cell
        }
        /*let data  = dataSource[indexPath.item]
        print("Collection view height :\(collectionView.height)")
        print("Initialized cell type : \(data.cellType)")
        switch data.cellType{
        case .userOnline:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Online_OverAllCell", for: indexPath) as? Land_Online_OverAllCell else { return UICollectionViewCell()}
            cell.item = data
            cell.delegate = self
            return cell
        case .feeds:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Feeds_OverAllCell", for: indexPath) as? Land_Feeds_OverAllCell else { return UICollectionViewCell()}
            cell.item = data
            cell.delegate = self
            return cell
        case .market:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Market_OverAllCell", for: indexPath) as? Land_Market_OverAllCell else { return UICollectionViewCell()}
            cell.item = data
            cell.delegate = self
            return cell
        case .none:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Menu_OverAllCell", for: indexPath) as? Land_Menu_OverAllCell else { return UICollectionViewCell()}
            
            return cell
        }*/
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell tapped in landing")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("Fetching Cell height and width")
        if indexPath.section == 0 {
            print("Online user cell")
            return CGSize(width: self.view.frame.width, height: 71)
        } else if indexPath.section == 1 {
            print("Feeds Cell")
            return CGSize(width: self.view.frame.width, height: 481)
        } else if indexPath.section == 2 {
            print("Market cell")
            return CGSize(width: self.view.frame.width, height: 275)
        } else {
            print("Menu cell")
            return CGSize(width: self.view.frame.width, height: 100)
        }
        
        /*let data  = dataSource[indexPath.item]
         print("Initialized cell type : \(data.cellType)")
        switch data.cellType{
        case .userOnline:
            return CGSize(width: self.view.frame.width, height: 71)
        case .feeds:
            return CGSize(width: self.view.frame.width, height: 341)
        case .market:
            return CGSize(width: self.view.frame.width, height: 275)
        case .none:
            return CGSize(width: self.view.frame.width, height: 100)
        }*/
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension LandHomePageVC : LandOnlineScrollDelegate {
    func didTapUserProfile(userId: String) {
        //self.performFriendView(friendId: userId)
    }
    
    func didTapOnlineUser(friendId: String, name: String, colorCode: String, profileImage: String, jid: String) {
        performConversationVC(friendId: friendId, profileName: name, colorCode: colorCode, profileImage: profileImage, jid: jid, listingId: "", listingTitle: "", listingType: "", listingImg: "")
    }
    
}
extension LandHomePageVC : LandingDelegate {
    func didReceiveData(mainDSource: [LandingItems] ,onlineUsers: [LOnlineItems], feeds: [LFeedsItem], market: [LMarketItems], menu: [LMenuItems]) {
        DispatchQueue.main.async {
            self.dataSource = mainDSource
            self.onlineDSource = onlineUsers
            self.feedsDSource = feeds
            self.marketDSource = market
            self.menuDSource = menu
            //dump(self.dataSource)
            //print("feeds data : \(self.dataSource.count)")
            if self.isRefreshControl{
                self.isRefreshControl = false
                /*let fIndex = IndexSet(integer: 0)
                let sIndex = IndexSet(integer: 1)
                let tIndex = IndexSet(integer: 2)
                
                
                self.collectionView.reloadSections(fIndex)
                self.collectionView.reloadSections(sIndex)
                self.collectionView.reloadSections(tIndex)*/
                self.collectionView.reloadData()
            } else {
                self.collectionView.reloadData()
            }
            
            self.spinnerHeightConstraint.constant = 0
            if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
            self.spinner.stopAnimating()
        }
    }
    
    func didReceivedFailure(error: String) {
        print("No data found")
    }
}
extension LandHomePageVC: LandMarketScrollDelegate {
    func didShareBtnTapped(sender: Any, listingId: String, userId: String, image: UIImage, imageURL: NSURL) {
        print("This will not trigger")
    }
    
    func didTapMUserProfile(userId: String) {
        self.performFriendView(friendId: userId)
    }
    
    func didTapMarketView(listingId: String, userId: String) {
        let vc = DetailListingOfferVC.controllerInstance(with:  listingId, with1: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension LandHomePageVC : LandFeedsDelegate {
    func didTapFeedsData(postId: String) {
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapFUserProfile(userId: String) {
        self.performFriendView(friendId: userId)
    }
    
    func didTapSeeAll() {
        /*if let vc = FeedsVC.storyBoardInstance(){
            let rearViewController = MenuTVC()
            let frontNavigationController = UINavigationController(rootViewController: vc)
            let mainRevealController = SWRevealViewController()
            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = frontNavigationController
            self.present(mainRevealController, animated: true, completion: {
                NotificationCenter.default.post(name: .userSignedIn, object: nil)
            })
        }*/
        self.appDelegate.isAppLaunching = false
        self.appDelegate.isLandMenuSelected = false
        self.appDelegate.isFeedMenuSelected = true
        self.appDelegate.isMarketMenuSelected = false
        self.appDelegate.isPricesMenuSelected = false
        self.appDelegate.isChatMenuSelected = false
        self.appDelegate.isDiscoverMenuSelected = false
        self.appDelegate.isCompanyMenuSelected = false
        self.appDelegate.isMembersMenuSelected = false
        pushViewController(storyBoard: StoryBoard.MAIN, Identifier: FeedsVC.id)
    }
    
    func didTapLikeOrComment(postId: String){
        self.performLikeVC(postId: postId)
    }
    
    func triggerGuestAlert() {
        showGuestAlert()
    }
    
    func didTap(url: String){
        
        if url.isValidEmail(){
            if MFMailComposeViewController.canSendMail(){
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([url])
                present(mail, animated: true, completion: nil)
            }
        } else {
            var urlString = url
            if urlString.lowercased().hasPrefix("http://")==false && urlString.lowercased().hasPrefix("https://")==false {
                urlString = "http://".appending(urlString)
            }
            if let urlAddress = URL(string: urlString){
                let safariViewController = SFSafariViewController(url: urlAddress)
                present(safariViewController, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        guard !checkisGuest else {
            self.showGuestAlert(); return
        }
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let nav = UINavigationController(rootViewController: vc)
        revealViewController().pushFrontViewController(nav, animated: true)
    }
}
extension LandHomePageVC : LandMenuDelegate {
    func didTapPrices() {
        
        self.appDelegate.isAppLaunching = false
        self.appDelegate.isLandMenuSelected = false
        self.appDelegate.isFeedMenuSelected = false
        self.appDelegate.isMarketMenuSelected = false
        self.appDelegate.isPricesMenuSelected = true
        self.appDelegate.isChatMenuSelected = false
        self.appDelegate.isDiscoverMenuSelected = false
        self.appDelegate.isCompanyMenuSelected = false
        self.appDelegate.isMembersMenuSelected = false
        pushViewController(storyBoard: StoryBoard.MAIN, Identifier: PricesVC.id)
    }
    
    func didTapChat() {
        
        self.appDelegate.isAppLaunching = false
        self.appDelegate.isLandMenuSelected = false
        self.appDelegate.isFeedMenuSelected = false
        self.appDelegate.isMarketMenuSelected = false
        self.appDelegate.isPricesMenuSelected = false
        self.appDelegate.isChatMenuSelected = true
        self.appDelegate.isDiscoverMenuSelected = false
        self.appDelegate.isCompanyMenuSelected = false
        self.appDelegate.isMembersMenuSelected = false
        self.pushViewController(storyBoard: StoryBoard.CHAT, Identifier: ChatVC.id, checkisGuest: AuthStatus.instance.isGuest)
    }
    
    func didTapDiscover() {
        
        self.appDelegate.isAppLaunching = false
        self.appDelegate.isLandMenuSelected = false
        self.appDelegate.isFeedMenuSelected = false
        self.appDelegate.isMarketMenuSelected = false
        self.appDelegate.isPricesMenuSelected = false
        self.appDelegate.isChatMenuSelected = false
        self.appDelegate.isDiscoverMenuSelected = true
        self.appDelegate.isCompanyMenuSelected = false
        self.appDelegate.isMembersMenuSelected = false
        pushViewController(storyBoard: StoryBoard.MAIN, Identifier: DiscoverVC.id)
    }
    
    func didTapCompany() {
        
        self.appDelegate.isAppLaunching = false
        self.appDelegate.isLandMenuSelected = false
        self.appDelegate.isFeedMenuSelected = false
        self.appDelegate.isMarketMenuSelected = false
        self.appDelegate.isPricesMenuSelected = false
        self.appDelegate.isChatMenuSelected = false
        self.appDelegate.isDiscoverMenuSelected = false
        self.appDelegate.isCompanyMenuSelected = true
        self.appDelegate.isMembersMenuSelected = false
        pushViewController(storyBoard: StoryBoard.COMPANIES, Identifier: CompaniesVC.id)
    }
    
    func didTapMembers() {
        
        self.appDelegate.isAppLaunching = false
        self.appDelegate.isLandMenuSelected = false
        self.appDelegate.isFeedMenuSelected = false
        self.appDelegate.isMarketMenuSelected = false
        self.appDelegate.isPricesMenuSelected = false
        self.appDelegate.isChatMenuSelected = false
        self.appDelegate.isDiscoverMenuSelected = false
        self.appDelegate.isCompanyMenuSelected = false
        self.appDelegate.isMembersMenuSelected = true
        pushViewController(storyBoard: StoryBoard.MAIN, Identifier: MembersVC.id)
    }
}

