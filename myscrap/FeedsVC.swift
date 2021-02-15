//
//  FeedsVC.swift
//  myscrap
//
//  Created by MyScrap on 3/17/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import BTNavigationDropdownMenu
import XMPPFramework
import RealmSwift
import Social
import Reachability
import StoreKit
import Photos
import UserNotifications
import AVKit
import AVFoundation
import DKImagePickerController

class FeedsVC: BaseRevealVC, FriendControllerDelegate{
    
    fileprivate var feedDatasource = [FeedV2Item]()
    fileprivate var feedService = FeedV2Model()
    fileprivate var memberDataSource = [ActiveUsers]()
    fileprivate var memberService = MemmberModel()
    fileprivate var storiesDataSource = [StoriesList]()
    fileprivate var storiesService = StoriesModel()
    fileprivate var loadMore = true
    fileprivate var reachedEnd = false
    fileprivate var chosenImage: UIImage?
    @IBOutlet weak var liveButton: UIButton!
    var headerCell : FeedVCHeadeer?
    @IBOutlet weak var headerCellHeight: NSLayoutConstraint!
    var   profileEditPopUp = AlartMessagePopupView()
    let picker = UIImagePickerController()
    
    @IBOutlet weak var headerView: UIView!
    //    let dispatchGroup = DispatchGroup()
    
    var feedOperation:BlockOperation?
    var nearFriendOperation: BlockOperation?
    var locationAndDeviceOperation: BlockOperation?
    var userSignedInOperation: BlockOperation?
    var profileItem : ProfileData?
    let service = ProfileService()
    let percentageNew = Int()
    var floaty = Floaty()
    var gameTimer: Timer!
    var feedsManualCount = 0
    
    var durationTimer: Timer?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var active: UIActivityIndicatorView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var profileImgView: CircularImageView!
    @IBOutlet weak var profileView: CircleView!
    @IBOutlet weak var topSpinner: NVActivityIndicatorView!
    @IBOutlet weak var topLoader: UIActivityIndicatorView!
    @IBOutlet weak var topSpinnerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSpinnerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadMoreSpinner: NVActivityIndicatorView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    
    var feed_Offline : Results<FeedLoadDB>!
    
    /*First time while login the app this api get called
     Get data from API and stores into Realm DB */
    var roastItems = [RoasterItems]()
    let roastHistory = RoasterHistory()
    
    //MarketADShowPopup
    var showPopup = false
    //Show Covid Poll Popup
    var showCovidPoll = false
    //Comment Inserted in detail feeds
    var isCommentInserted = false
    var fromDetailedFeeds = false
    var isSignedIn = false
    var isScrollToAD = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var index = IndexPath()
    var visibleCellIndex = IndexPath()
    //var landsVidTextVisibIndexPath = IndexPath()
    var muteVideo = true
    var timerRefreshActiveUser = Timer()
    //Model Class service
    fileprivate var covidService = CovidPollService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        
        self.addObserverNotifications()
        self.configureHeaderView()
        setupViews()
        if isSignedIn {
            active.startAnimating()
        } else {
            if !self.topLoader.isAnimating && !refreshContol.isRefreshing {
                self.topSpinnerHeightConstraint.constant = 58
                self.topLoader.startAnimating()
                //self.refreshContol.beginRefreshing()
                //    self.handleRefresh()
            }
        }
        self.getAllFeedsData()
        self.processLocation()
        self.marketPOpUP()
        self.getCovid19Pol()
        self.getRoasterData()
        self.collectionView.isHidden = true
        
        view.endEditing(true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//               //call any function
//            self.startTimeToGetUser()
//           }

    }
    @IBAction func liveButtonPressed(_ sender: Any) {
        if let vc = LiveTopicVC.storyBoardInstance() {
               self.navigationController?.pushViewController(vc, animated: true)
            }
        
    }
    private func getAllFeedsData(){
        DispatchQueue.global(qos:.userInteractive).async {
            self.getFeeds(pageLoad: 0, completion: { _ in       //self.feedDataSource.count
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        }
        self.getAllOnlineUsersData()
    }
    @objc private func getAllOnlineUsersData(){
        DispatchQueue.global(qos:.userInteractive).async {
            self.memberService.getOnlineFriends(completion: { (members) in
                DispatchQueue.main.async {
                    self.memberDataSource = members
                    self.headerCell!.datasource = self.memberDataSource
                    self.headerCellHeight.constant = 100
                //    UIView.performWithoutAnimation {
                    self.headerCell!.collectionView.reloadData()
                    self.headerCell!.collectionView.performBatchUpdates(nil, completion: {
                        (result) in
                   self.headerCell!.addAnimationIfNeeded()
                    })
                  
                 //    }
                  
                }
            })
        }
    }
    private func processLocation(){
        DispatchQueue.global(qos:.userInteractive).async {
            LocationService.sharedInstance.processLocation()
        }
    }
    private func marketPOpUP(){
        //Showing Market AD POPUP here
        if showPopup {
            self.showingMarketPopup()
        }
    }
    private func getCovid19Pol(){
        if showCovidPoll {
            DispatchQueue.global(qos:.userInteractive).async {
                //Showing COVID-19 Poll
                //Removed and not using
                
                self.covidService.delegate = self
                self.covidService.getPollStatusForMe()
                
            }
        }
    }
    private func getRoasterData(){
        if isSignedIn {
            DispatchQueue.global(qos:.userInteractive).async {
                //Showing COVID-19 Poll
                //Removed and not using
                
                self.getRoasterHistory(completion: { _ in       //self.feedDataSource.count
                    //group.leave()
                })
                
            }
        }
    }
    private func configureHeaderView(){
        
        self.headerCellHeight.constant = 0
        self.headerCell =  UINib(nibName: "FeedVCHeadeer", bundle: nil).instantiate(withOwner: nil, options: nil)[0]  as! FeedVCHeadeer
        self.headerCell!.datasource = self.memberDataSource
        self.headerCell!.delegate = self
        UIView.performWithoutAnimation {
            self.headerCell!.collectionView.reloadData()
         }
        self.headerCell!.addAnimationIfNeeded()
        self.headerView.addSubview( self.headerCell!)
    }
    private func addObserverNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("SharedOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("SharedClosed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("DeletedVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("PauseAllVideos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAllFeedsData), name: Notification.Name("DeletedUserOwnVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getAllFeedsOnly), name: NSNotification.Name(rawValue: "ReloadFeedsData"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLiveUserData), name: Notification.Name("EndLiveBYOtherUser"), object: nil)
        
        
    }
    @objc func OpenEditProfileView(notification: Notification) {
        //              profileEditPopUp.removeFromSuperview()
        //          self.gotoEditProfilePopup()
        // activityIndicator.stopAnimating()
    }
    func getRoasterHistory(completion: @escaping (Bool) -> ()) {
        print("Get roaster history from api")
        roastHistory.getRoasterHistory()
        roastHistory.delegate = self
    }
    
    func insertChatIntoDB() {
        
    }
    
    @objc func runTimedCode() {
        if XMPPService.instance.isConnected == true && XMPPService.instance.isAuthenticated == true{
            setupFloaty()
            gameTimer.invalidate()
            //showMessage(with: "Xmpp Connected")
        } else {
            print("XMPP not connected/ not authenticated")
        }
    }
    
    func getProfile(){
        print("HEre")
        service.getUserProfile(pageLoad: "\(feedDatasource.count)")
    }
    
    func showingMarketPopup() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketAdvPopUpVC") as! MarketAdvPopUpVC
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func showingCovidPollPopup() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CovidPollPopupVC") as! CovidPollPopupVC
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        popOverVC.didPoll = { success in
            if success{
                if !self.topLoader.isAnimating {
                    self.topSpinnerHeightConstraint.constant = 58
                    self.topLoader.startAnimating()
                }
                self.active.startAnimating()
                self.refreshContol.beginRefreshing()
                self.handleRefresh()
                //  self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
            }
        }
    }
    
    func gotoEditProfilePopup() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfilePopupVC") as! EditProfilePopupVC
        self.addChild(popOverVC)
        let mainScreen = UIScreen.main.bounds
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: mainScreen.width, height: mainScreen.height)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        popOverVC.didRemove = {success in
            if success{
                self.postBtn.isEnabled = true
                self.cameraBtn.isEnabled = true
            }
        }
    }
    
    private func setupFloaty(){
        
        let liveView = CircleView()
        liveView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(liveView)
        
        let liveLbl = UILabel()
        liveLbl.translatesAutoresizingMaskIntoConstraints = false
        liveView.addSubview(liveLbl)
        let margin = view.layoutMarginsGuide
        
        liveView.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: 0).isActive = true
        liveView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -70).isActive = true
        liveView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        liveView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        liveView.backgroundColor = UIColor(hexString: "#ed1b24")
        
        liveLbl.centerXAnchor.constraint(equalTo: liveView.centerXAnchor).isActive = true
        liveLbl.centerYAnchor.constraint(equalTo: liveView.centerYAnchor).isActive = true
        liveLbl.font = UIFont(name: "HelveticaNeue", size: 16)
        liveLbl.text = "Live"
        liveLbl.textColor = UIColor.white
        
        DispatchQueue.main.async {
            let tap = UITapGestureRecognizer(target: self, action:#selector(self.liveTap(_:)))
            tap.numberOfTapsRequired  = 1
            liveView.addGestureRecognizer(tap)
        }
        
        
        gameTimer.invalidate()
    }
    
    @objc func liveTap(_ recognizer: UIGestureRecognizer) {
        if let vc = LiveDiscussion.storyBoardInstance() {
            if AuthStatus.instance.isGuest{
                print("Guest user")
                self.showGuestAlert()
            } else {
                print("Live btn pressed")
                print("this is  sparta!!!!!!!!")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    private func setupLoading(){
        // feedOperation?.start()
        self.getAllFeedsData()
        
    }
    
    fileprivate var isRefreshControl = false
    
    fileprivate lazy var refreshContol : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = UIColor.MyScrapGreen
        rc.addTarget(self, action:
                        #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    @objc
    fileprivate func handleRefresh(){
        if network.reachability.isReachable == true {
            if active.isAnimating {
                active.stopAnimating() }
            isRefreshControl = true
            self.getAllFeedsData()
            self.getAllOnlineUsersData()
            
        } else {
            self.showToast(message: "No internet connection")
        }
        
    }
    @objc
    fileprivate func getAllFeedsOnly(){
        if network.reachability.isReachable == true {
            if active.isAnimating {
                active.stopAnimating() }
            isRefreshControl = true
            self.getAllFeedsData()
            
        } else {
            self.showToast(message: "No internet connection")
        }
        
    }
    
    func objectExist(id: String) -> Bool {
        return uiRealm.object(ofType: FeedLoadDB.self, forPrimaryKey: id) != nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false) 
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
          
          
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        //Load Local feeds
        
        
        if AuthStatus.instance.isLoggedIn {
            self.usersignedIn()
        }
        if AuthService.instance.colorCode != nil ?? "" && AuthService.instance.profilePic != nil ?? "" && AuthService.instance.profilePic != "https://myscrap.com/style/images/icons/no-profile-pic-female.png"{
            profileView.backgroundColor = UIColor(hexString: AuthService.instance.colorCode)
            initialLbl.text = AuthService.instance.fullName.initials()
            print("Feed in IF Initials :\(String(describing: initialLbl.text)), \(AuthService.instance.profilePic)")
            profileImgView.sd_setImage(with: URL(string: AuthService.instance.profilePic), completed: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(FeedsVC.userSignedIn(_:)), name: Notification.Name.userSignedIn, object: nil)
        }
        else {
            profileView.backgroundColor = UIColor(hexString: AuthService.instance.colorCode)
            initialLbl.text = AuthService.instance.fullName.initials()
            print("Feed in Else Initials :\(String(describing: initialLbl.text))")
            profileImgView.sd_setImage(with: URL(string: "Blank"), completed: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(FeedsVC.userSignedIn(_:)), name: Notification.Name.userSignedIn, object: nil)
        }
        
        let profileTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ProfileBtnTap(tapGesture:)))
        profileTap.numberOfTapsRequired = 1
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(profileTap)
        
        if network.reachability.isReachable == false {
            getOfflineFeeds()
        }
        
        
        //Add observer for downloading video
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoDownloadNotify(_:)), name: .videoDownloaded, object: nil)
        self.scrollViewDidEndScrolling()
        headerCell?.collectionView.reloadData()
       
    }
    @objc func ProfileBtnTap(tapGesture:UITapGestureRecognizer) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        }else {
            if let vc = ProfileVC.storyBoardInstance() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func getOfflineFeeds() {
        var feedItem = [FeedV2Item]()
        self.feed_Offline = uiRealm.objects(FeedLoadDB.self)
        if let jsonString = self.feed_Offline.last?.feedString {
            let data = jsonString.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:AnyObject]
                {
                    print(jsonArray) // use the json here
                    if let feedsData = jsonArray["feedsData"] as? [[String:AnyObject]]{
                        
                        for feeds in feedsData{
                            let feed = FeedV2Item(FeedDict: feeds)
                            feedItem.append(feed)
                        }
                        self.feedDatasource = feedItem
                        self.collectionView.reloadData()
                        self.collectionView.collectionViewLayout.invalidateLayout()
                        
                        if isScrollToAD {
                            //   self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 1), at: [.centeredHorizontally,.centeredVertically], animated: true)
                        }
                    }
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pauseVisibleVideos()
        NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
        NotificationCenter.default.removeObserver(self, name: .videoDownloaded, object: nil)
        self.stopTimer()
    }
    
    
    
    private func setupViews(){
        
        //Top Spinner
        self.topSpinner.type = .lineSpinFadeLoader
        self.topSpinner.color = .MyScrapGreen
        self.topSpinnerHeightConstraint.constant = 0
        
        //Load More Spinner
        self.loadMoreSpinner.type = .ballScaleMultiple
        self.loadMoreSpinner.color = .MyScrapGreen
        self.bottomSpinnerViewHeightConstraint.constant = 0
        
        collectionView.refreshControl = refreshContol
        collectionView.alwaysBounceVertical = true;
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FeedPollResultCell.Nib, forCellWithReuseIdentifier: FeedPollResultCell.identifier)
        collectionView.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        collectionView.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        collectionView.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
        
        collectionView.register(LandScapVideoCell.Nib, forCellWithReuseIdentifier: LandScapVideoCell.identifier)
        collectionView.register(LandScapVideoTextCell.Nib, forCellWithReuseIdentifier: LandScapVideoTextCell.identifier)
        
        collectionView.register(EmplPortraitVideoCell.Nib, forCellWithReuseIdentifier: EmplPortraitVideoCell.identifier)
        collectionView.register(EmplLandscVideoCell.Nib, forCellWithReuseIdentifier: EmplLandscVideoCell.identifier)
        collectionView.register(EmplPortrVideoTextCell.Nib, forCellWithReuseIdentifier: EmplPortrVideoTextCell.identifier)
        collectionView.register(EmplLandsVideoTextCell.Nib, forCellWithReuseIdentifier: EmplLandsVideoTextCell.identifier)
        collectionView.register(AdvertismentCell.Nib, forCellWithReuseIdentifier: AdvertismentCell.identifier)
        collectionView.register(MarketScrollCell.Nib, forCellWithReuseIdentifier: MarketScrollCell.identifier)
        collectionView.register(NewUserScrollCell.Nib, forCellWithReuseIdentifier: NewUserScrollCell.identifier)
        collectionView.register(NewsScrollCell.Nib, forCellWithReuseIdentifier: NewsScrollCell.identifier)
        collectionView.register(CompanyOfMonthCell.Nib, forCellWithReuseIdentifier: CompanyOfMonthCell.identifier)
        collectionView.register(PersonOfWeek.Nib, forCellWithReuseIdentifier: PersonOfWeek.identifier)
        collectionView.register(PersonWeekScrollCell.Nib, forCellWithReuseIdentifier: PersonWeekScrollCell.identifier)
        collectionView.register(VotingScrollCell.Nib, forCellWithReuseIdentifier: VotingScrollCell.identifier)
        
    }
    
    private func getFeeds(pageLoad: Int, completion: @escaping (Bool) -> () ){
        feedService.getAllFeeds(pageLoad: "\(pageLoad)") { (result) in
            DispatchQueue.main.async {
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    self.feedDatasource = [FeedV2Item]()
                    self.isRefreshControl = false
                }
                if self.topLoader.isAnimating {
                    self.topSpinnerHeightConstraint.constant = 0
                    self.topLoader.stopAnimating()
                }
                self.collectionView.isHidden = false
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Feed data count",self.feedDatasource.count)
                    self.feedsManualCount = self.feedDatasource.count
                    let newData = data
                    //newData.removeDuplicates()
                    self.feedDatasource = newData
                    self.collectionView.reloadData()
                    //  self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.loadMore = true
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    private func getFeedsMore(pageLoad: Int, completion: @escaping (Bool) -> () ){
        feedService.getAllFeeds(pageLoad: "\(pageLoad)") { (result) in
            DispatchQueue.main.async {
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    self.feedDatasource = [FeedV2Item]()
                    self.isRefreshControl = false
                }
                if self.loadMoreSpinner.isAnimating {
                    self.bottomSpinnerViewHeightConstraint.constant = 0
                    self.loadMoreSpinner.stopAnimating()
                }
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Feed data count",self.feedDatasource.count)
                    self.feedsManualCount = self.feedDatasource.count
                    var newData = self.feedDatasource + data
                    //newData.removeDuplicates()
                    self.feedDatasource = newData
                    self.collectionView.reloadData()
                    //  self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    completion(true)
                }
            }
        }
    }
    
    func loadParticularFeed(pageLoad: Int, completion: @escaping (Bool) -> () ){
        feedService.getAllFeeds(pageLoad: "\(pageLoad)") { (result) in
            DispatchQueue.main.async {
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Feed data count",self.feedDatasource.count)
                    self.feedsManualCount = self.feedDatasource.count
                    let newData = data
                    //newData.removeDuplicates()
                    self.feedDatasource = newData
                    //self.collectionView.reloadData()
                    completion(true)
                }
            }
        }
    }
    
    //MARK :- CAMERA BTN CLICKED
    @IBAction func cameraClicked(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            
            if network.reachability.isReachable == true {
                if AuthStatus.instance.isGuest{
                    self.showGuestAlert()
                } else {
                    
                    postBtn.isEnabled = true
                    cameraBtn.isEnabled = true
                    self.toCamera()
                }
                //  }
            } else {
                self.showToast(message: "No internet connection")
            }
        }
        else{
            self.nocamera()
        }
    }
    func nocamera()
    {
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    // MARK :- POST BUTTON FUNCTION
    @IBAction func postBtnClicked(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            if AuthStatus.instance.isGuest{
                self.showGuestAlert()
            } else {
                if feedDatasource.count != 0 {
                    UserDefaults.standard.set("", forKey: "postText")
                    
                    postBtn.isEnabled = true
                    cameraBtn.isEnabled = true
                    self.toPostVC()
                    //}
                } else {
                    //To prevent crash
                    print("Post will not redirected")
                }
                
            }
        } else {
            self.showToast(message: "No internet connection")
        }
    }
    func performFriendView(friendId: String){
        if network.reachability.isReachable == true {
            switch friendId {
            case nil:
                return
            case "":
                return
            case AuthService.instance.userId:
                if let vc = ProfileVC.storyBoardInstance() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:
                if let vc = FriendVC.storyBoardInstance() {
                    vc.friendId = friendId
                    UserDefaults.standard.set(friendId, forKey: "friendId")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            self.showToast(message: "No internet connection")
        }
        
    }
    @objc func statusManager(_ notification: Notification) {
    }
    private func startTimeToGetUser() {
        timerRefreshActiveUser.invalidate()
        timerRefreshActiveUser = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector:#selector(self.getAllOnlineUsersData) , userInfo: nil, repeats: true)
    }
    private func stopTimer() {
       
        timerRefreshActiveUser.invalidate()
    }
}

extension FeedsVC: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        CheckCellStatus.PauseCellifNededOnFeedPage(cell:cell)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("count of feeds \(feedDatasource.count)")
        if feedDatasource.count != 0 {
            if feedsManualCount < feedDatasource.count {
                self.loadMore = true
            }
            return feedDatasource.count
        } else {
            return 0
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data  = feedDatasource[indexPath.item]
        print("Initialized cell type : \(data.cellType)")
        switch data.cellType{
        case .covidPoll:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedPollResultCell.identifier, for: indexPath) as? FeedPollResultCell else { return UICollectionViewCell()}
            cell.item = data
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTextCell.identifier, for: indexPath) as? FeedTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.SetLikeCountButton()
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedImageCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.refreshImagesCollection()
            cell.SetLikeCountButton()
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.feedImages.visibleCells   {
                    let image = imageCell as! CompanyImageslCell
                    UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                    cell.dwnldBtn.isEnabled = true
                }
                
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedImageTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageTextCell.identifier, for: indexPath) as? FeedImageTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.refreshImagesCollection()
            cell.SetLikeCountButton()
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.feedImages.visibleCells   {
                    let image = imageCell as! CompanyImageslCell
                    UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                    cell.dwnldBtn.isEnabled = true
                }
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedVideoCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortraitVideoCell.identifier, for: indexPath) as? EmplPortraitVideoCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.refreshTable()

            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
            }
            cell.playBtnAction = {
                let urlString = data.videoUrl
                let videoURL = URL(string: urlString)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.videosCollection.visibleCells   {
                    let videoCell = imageCell as! PortraitVideoCell
                    self.downloadVideo(path: videoCell.newVedio!.video)
                    cell.dwnldBtn.isEnabled = true
                    cell.dwnldBtn.isEnabled = true
                }
                
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedVideoTextCell:
            return UICollectionViewCell()
        case .ads:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertismentCell.identifier, for: indexPath) as? AdvertismentCell else { return UICollectionViewCell()}
            cell.item = data
            cell.sliderAdImageView.delegate = self
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .market:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketScrollCell.identifier, for: indexPath) as? MarketScrollCell else { return UICollectionViewCell()}
            cell.item = data
            cell.delegate = self
            cell.offlineActionBlock = {
                self.showToast(message: "No internet connection")
            }
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
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .userFeedTextCell:
            return UICollectionViewCell()
        case .userFeedImageCell:
            return UICollectionViewCell()
        case .userFeedImageTextCell:
            return UICollectionViewCell()
        case .newUser:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewUserScrollCell.identifier, for: indexPath) as? NewUserScrollCell else { return UICollectionViewCell()}
            cell.item = data
            cell.delegate = self
            cell.offlineActionBlock = {
                self.showToast(message: "No internet connection")
            }
            cell.viewAllActionBlock = {
                if let vc = MembersVC.storyBoardInstance() {
                    if AuthStatus.instance.isGuest{
                        print("Guest user")
                        self.showGuestAlert()
                    } else {
                        
                        self.appDelegate.isAppLaunching = false
                        self.appDelegate.isLandMenuSelected = false
                        self.appDelegate.isFeedMenuSelected = false
                        self.appDelegate.isMarketMenuSelected = false
                        self.appDelegate.isPricesMenuSelected = false
                        self.appDelegate.isChatMenuSelected = false
                        self.appDelegate.isDiscoverMenuSelected = false
                        self.appDelegate.isCompanyMenuSelected = false
                        self.appDelegate.isMembersMenuSelected = true
                        vc.orderBy = "newuser"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .news:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsScrollCell.identifier, for: indexPath) as? NewsScrollCell else { return UICollectionViewCell()}
            cell.item = data
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .companyMonth:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyOfMonthCell.identifier, for: indexPath) as? CompanyOfMonthCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.item = data
            cell.offlineActionBlock = {
                self.showToast(message: "No internet connection")
            }
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .personWeek:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonOfWeek.identifier, for: indexPath) as? PersonOfWeek else { return UICollectionViewCell()}
            cell.offlineActionBlock = {
                self.showToast(message: "No internet connection")
            }
            cell.updatedDelegate = self
            cell.item = data
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .vote:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VotingScrollCell.identifier, for: indexPath) as? VotingScrollCell else { return UICollectionViewCell()}
            cell.item = data
            cell.delegate = self
            cell.viewAllActionBlock = {
                if let vc = VoterPollScreenVC.storyBoardInstance() {
                    if AuthStatus.instance.isGuest{
                        print("Guest user")
                        self.showGuestAlert()
                    } else {
                        //let indexPath = IndexPath(row: 0, section: 0)
                        //vc.selectedIndex = indexPath
                        vc.navigationItem.title = "Poll"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .personWeekScroll:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonWeekScrollCell.identifier, for: indexPath) as? PersonWeekScrollCell else { return UICollectionViewCell()}
            cell.item = data
            cell.delegate = self
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedPortrVideoCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortraitVideoCell.identifier, for: indexPath) as? EmplPortraitVideoCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.delegateVideoChange = self
            
            cell.refreshTable()
            cell.SetLikeCountButton()
            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
            }
            cell.playBtnAction = {
                let urlString = data.videoUrl
                let videoURL = URL(string: urlString)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.videosCollection.visibleCells   {
                    let videoCell = imageCell as! PortraitVideoCell
                    self.downloadVideo(path: videoCell.newVedio!.video)
                    cell.dwnldBtn.isEnabled = true
                    cell.dwnldBtn.isEnabled = true
                }
                
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedLandsVideoCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandScapVideoCell.identifier, for: indexPath) as? LandScapVideoCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.delegateVideoChange = self
            
            cell.refreshTable()
            cell.SetLikeCountButton()
            
            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
            }
            cell.playBtnAction = {
                let urlString = data.videoUrl
                let videoURL = URL(string: urlString)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.videosCollection.visibleCells   {
                    let videoCell = imageCell as! LandScapCell
                    self.downloadVideo(path: videoCell.newVedio!.video)
                    cell.dwnldBtn.isEnabled = true
                    cell.dwnldBtn.isEnabled = true
                }
                
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedPortrVideoTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortrVideoTextCell.identifier, for: indexPath) as? EmplPortrVideoTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.delegateVideoChange = self
            
            cell.refreshTable()
            cell.SetLikeCountButton()
            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
            }
            cell.playBtnAction = {
                let urlString = data.videoUrl
                let videoURL = URL(string: urlString)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.videosCollection.visibleCells   {
                    let videoCell = imageCell as! PortraitVideoCell
                    self.downloadVideo(path: videoCell.newVedio!.video)
                    cell.dwnldBtn.isEnabled = true
                }
                
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            cell.layoutSubviews()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case .feedLandsVideoTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandScapVideoTextCell.identifier, for: indexPath) as? LandScapVideoTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.delegateVideoChange = self
            
            cell.refreshTable()
            cell.SetLikeCountButton()
            
            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
            }
            cell.playBtnAction = {
                let urlString = data.videoUrl
                let videoURL = URL(string: urlString)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.videosCollection.visibleCells   {
                    let videoCell = imageCell as! LandScapCell
                    self.downloadVideo(path: videoCell.newVedio!.video)
                    cell.dwnldBtn.isEnabled = true
                }
                
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            cell.layoutSubviews()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        }
        //}
    }
    
    func downloadVideo(path : String) {
        self.showMessage(with: "Download begins!")
        let videoImageUrl = path
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let filePath="\(documentsPath)/MSVIDEO.mp4"
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoImageUrl),
               let urlData = NSData(contentsOf: url) {
                
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            
                            DispatchQueue.main.async {
                                //Triggering the videoDownloadNotify method.
                                NotificationCenter.default.post(name: .videoDownloaded, object: nil)
                            }
                        } else {
                            if let dwnldError = error {
                                DispatchQueue.main.async {
                                    print("Download Failed : \(dwnldError.localizedDescription)")
                                    self.showMessage(with: "Failed to download the video")
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func updateMuteBtn() {
    }
    
    
    @objc func videoDownloadNotify(_ notification: Notification){
        print("Video saved!")
        
        //self.showMessage(with: "Video Downloaded")
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let userActions = "User Actions"
        
        content.title = "MyScrap"
        content.body = "Video downloaded to the Gallery"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions
        
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    @objc func feed_image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let centerPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        
        if let portrateCell = cell as? EmplPortraitVideoCell {
            
            for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                
                let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                if muteValue == "1"
                {
                    muteVideo =  false
                }
                else
                {
                    muteVideo =  true
                }
                videoCell.playerView.isMuted = muteVideo
                if  videoCell.playerView.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                let item = feedDatasource[indexPath.item]
                if item.isReported {
                    videoCell.pause()
                }
                else
                {
                    let point = portrateCell.videosCollection.convert(portrateCell.videosCollection.center, to: self.view)
                    let buttonAbsoluteFrame = portrateCell.videosCollection.convert(portrateCell.videosCollection.bounds, to: self.view)
                    
                    
                    if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                        // Point lies inside the bounds.
                        videoCell.resume()
                    }
                    // videoCell.resume()
                }
                //}
            }
        }
        else if let portrateCell = cell as? EmplPortrVideoTextCell {
            
            for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                if muteValue == "1"
                {
                    muteVideo =  false
                }
                else
                {
                    muteVideo =  true
                }
                videoCell.playerView.isMuted = muteVideo
                if  videoCell.playerView.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                let item = feedDatasource[indexPath.item]
                if item.isReported {
                    videoCell.pause()
                }
                else
                {
                    let point = portrateCell.videosCollection.convert(portrateCell.videosCollection.center, to: self.view)
                    let buttonAbsoluteFrame = portrateCell.videosCollection.convert(portrateCell.videosCollection.bounds, to: self.view)
                    
                    
                    if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                        // Point lies inside the bounds.
                        videoCell.resume()
                    }
                }
                
                //}
            }
        }
        
        else if let portrateCell = cell as? LandScapVideoCell {
            
            for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                if muteValue == "1"
                {
                    muteVideo =  false
                }
                else
                {
                    muteVideo =  true
                }
                videoCell.playerView.isMuted = muteVideo
                if  videoCell.playerView.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                let item = feedDatasource[indexPath.item]
                if item.isReported {
                    videoCell.pause()
                }
                else
                {
                    let point = portrateCell.videosCollection.convert(portrateCell.videosCollection.center, to: self.view)
                    let buttonAbsoluteFrame = portrateCell.videosCollection.convert(portrateCell.videosCollection.bounds, to: self.view)
                    
                    
                    if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                        // Point lies inside the bounds.
                        videoCell.resume()
                    }
                }
                
                //}
            }
        }
        
        else if let portrateCell = cell as? LandScapVideoTextCell {
            
            for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                if muteValue == "1"
                {
                    muteVideo =  false
                }
                else
                {
                    muteVideo =  true
                }
                videoCell.playerView.isMuted = muteVideo
                if  videoCell.playerView.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                let item = feedDatasource[indexPath.item]
                if item.isReported {
                    videoCell.pause()
                }
                else
                {
                    let point = portrateCell.videosCollection.convert(portrateCell.videosCollection.center, to: self.view)
                    let buttonAbsoluteFrame = portrateCell.videosCollection.convert(portrateCell.videosCollection.bounds, to: self.view)
                    
                    
                    if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                        // Point lies inside the bounds.
                        videoCell.resume()
                    }
                }
                
                //}
            }
        }
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        
        
    }
    
    
    
    
}
extension FeedsVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0.0, height: 0.0)
    }
    //#7after api loaded
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let width = screenWidth //self.view.frame.width
        
        let item = feedDatasource[indexPath.item]
        print("Get the raw values",item.cellType.rawValue)
        var height : CGFloat = 0
        //#8
        switch item.cellType{
        case .feedTextCell:
            height = FeedsHeight.heightforFeedTextCellV2(item: item , labelWidth: width - 16)
            return CGSize(width: width , height: height)
        case .feedImageCell:
            height = FeedsHeight.heightForImageCellV2(item: item, width: width)
            return   CGSize(width: width, height: height)
        case .feedImageTextCell:
            height = FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
            return CGSize(width: width, height: height)
        case .feedVideoCell:
            return CGSize(width: 0, height: 0)
        case .feedVideoTextCell:
            
            return CGSize(width: 0, height: 0)
        case .ads:
            let height = messageHeight(for: item.description)
            print("height of ad : \(height)")
            return CGSize(width: width, height: height + 400)  //469 //500 //362
        case .market:
            print("Width of market scroll: \(width)")
            return CGSize(width: width, height: 330)    //355
        case .userFeedTextCell:
            return CGSize(width: 0, height: 0)
        case .userFeedImageCell:
            return CGSize(width: 0, height: 0)
        case .userFeedImageTextCell:
            return CGSize(width: 0, height: 0)
        case .newUser:
            return CGSize(width: width, height: 355)
        case .news:
            return CGSize(width: width, height: 355)
        case .companyMonth:
            
            height = FeedsHeight.heightForCompanyOfMonthCellV2(item: item, labelWidth: width - 16)  //Aligning width by omitting (leading & trailing)
            print("Height of COM cell : \(height)")
            return CGSize(width: width, height: height)
        case .personWeek:
            height = FeedsHeight.heightForPersonOfWeekCellV2(item: item, labelWidth: width - 16)  //Aligning width by omitting (leading & trailing)
            print("Height of POW cell : \(height)")
            return CGSize(width: width, height: height)
        case .vote:
            return CGSize(width: width, height: 290)    //260
        case .personWeekScroll:
            return CGSize(width: width, height: 290)
        case .covidPoll:
            return CGSize(width: width, height: 365)
        case .feedLandsVideoCell:
            height = FeedsHeight.heightForLandsVideoCellV2(item: item, width: width)
            return CGSize(width: width, height: height )
        case .feedPortrVideoCell:
            height = FeedsHeight.heightForPortraitVideoCellV2(item: item, width: width)
            return   CGSize(width: width, height: height )
        case .feedPortrVideoTextCell:
            height = FeedsHeight.heightForPortraitVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
            print("Video Cell height : \(height)")
            return  CGSize(width: width, height: height )    //height + 30
        case .feedLandsVideoTextCell:
            height = FeedsHeight.heightForLandsVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
            print("Video Cell height : \(height)")
            return  CGSize(width: width, height: height )    //height + 30
        }
        
    }
    @objc func refreshLiveUserData()
    {
        DispatchQueue.main.async {
            //self.pauseVisibleVideos()
            
            if !self.topLoader.isAnimating && !self.refreshContol.isRefreshing {
//                self.topSpinnerHeightConstraint.constant = 58
//                self.topLoader.startAnimating()
                //self.active.startAnimating()
                self.getAllOnlineUsersData()
            }
        }
    }
    @objc func refreshAllFeedsData()
    {
        DispatchQueue.main.async {
            self.pauseVisibleVideos()
            
            if !self.topLoader.isAnimating && !self.refreshContol.isRefreshing {
                self.topSpinnerHeightConstraint.constant = 58
                self.topLoader.startAnimating()
                self.active.startAnimating()
                //self.refreshContol.beginRefreshing()
                self.handleRefresh()
            }
        }
    }
    @objc func pauseVisibleVideos()  {
        
        for videoParentCell in collectionView.visibleCells   {
            CheckCellStatus.PauseCellifNededOnFeedPage(cell:videoParentCell)
        }
    
    }
    func pauseAllVideos(indexPath : IndexPath)  {
        
        for videoParentCell in collectionView.visibleCells   {
            var indexPathNotVisible = collectionView!.indexPath(for: videoParentCell)
            if indexPath != indexPathNotVisible {
                CheckCellStatus.PauseCellifNededOnFeedPage(cell:videoParentCell)
            }
        }
    }
    @objc func scrollViewDidEndScrolling() {
        
        let centerPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        let collectionViewCenterPoint = self.view.convert(centerPoint, to: collectionView)
        
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        var muteVideo : Bool = false
        
        if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
            
            
            
            if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? EmplPortraitVideoCell
            {
                
                let data  = feedDatasource[indexPath.item]
                
                for videoCell in collectionViewCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    
                    //  videoCell.backgroundColor = .red
                    
                    let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                    if muteValue == "1"
                    {
                        muteVideo =  false
                    }
                    else
                    {
                        muteVideo =  true
                    }
                    videoCell.playerView.isMuted = muteVideo
                    if  videoCell.playerView.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    if data.isReported {
                        videoCell.pause()
                    }
                    else
                    {
                        var point = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.center, to: self.view)
                        let buttonAbsoluteFrame = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.bounds, to: self.view)
                        
                        
                        if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                            // Point lies inside the bounds.
                            videoCell.resume()
                        }
                        else
                        {
                            videoCell.pause()
                        }
                        
                        
                    }
                    
                    
                    self.pauseAllVideos(indexPath: indexPath)
                }
                collectionViewCell.UpdateLable()
            }
            else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell
            {
                for videoCell in collectionViewCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    //  videoCell.backgroundColor = .red
                    let data  = feedDatasource[indexPath.item]
                    let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                    if muteValue == "1"
                    {
                        muteVideo =  false
                    }
                    else
                    {
                        muteVideo =  true
                    }
                    videoCell.playerView.isMuted = muteVideo
                    if  videoCell.playerView.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    
                    if data.isReported {
                        videoCell.pause()
                    }
                    else
                    {
                        var point = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.center, to: self.view)
                        let buttonAbsoluteFrame = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.bounds, to: self.view)
                        
                        
                        if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                            // Point lies inside the bounds.
                            videoCell.resume()
                        }
                        else
                        {
                            videoCell.pause()
                        }
                        
                    }
                    
                    self.pauseAllVideos(indexPath: indexPath)
                }
                collectionViewCell.UpdateLable()
            }
            else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? LandScapVideoCell
            {
                for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
                    //  videoCell.backgroundColor = .red
                    let data  = feedDatasource[indexPath.item]
                    let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                    if muteValue == "1"
                    {
                        muteVideo =  false
                    }
                    else
                    {
                        muteVideo =  true
                    }
                    videoCell.playerView.isMuted = muteVideo
                    if  videoCell.playerView.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    
                    if data.isReported {
                        videoCell.pause()
                    }
                    else
                    {
                        var point = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.center, to: self.view)
                        let buttonAbsoluteFrame = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.bounds, to: self.view)
                        
                        
                        if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                            // Point lies inside the bounds.
                            videoCell.resume()
                        }
                        else
                        {
                            videoCell.pause()
                        }
                        
                        
                    }
                    
                    self.pauseAllVideos(indexPath: indexPath)
                }
                collectionViewCell.UpdateLable()
            }
            else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? LandScapVideoTextCell
            {
                for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
                    //  videoCell.backgroundColor = .red
                    let data  = feedDatasource[indexPath.item]
                    let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                    if muteValue == "1"
                    {
                        muteVideo =  false
                    }
                    else
                    {
                        muteVideo =  true
                    }
                    videoCell.playerView.isMuted = muteVideo
                    if  videoCell.playerView.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    
                    if data.isReported {
                        videoCell.pause()
                    }
                    else
                    {
                        var point = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.center, to: self.view)
                        let buttonAbsoluteFrame = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.bounds, to: self.view)
                        
                        
                        if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                            // Point lies inside the bounds.
                            videoCell.resume()
                        }
                        else
                        {
                            videoCell.pause()
                        }
                        
                        
                    }
                    
                    
                    self.pauseAllVideos(indexPath: indexPath)
                }
                collectionViewCell.UpdateLable()
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !feedDatasource.isEmpty{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                if loadMore{
                    if !loadMoreSpinner.isAnimating {
                        if !isScrollToAD {
                            self.bottomSpinnerViewHeightConstraint.constant = 58
                            self.loadMoreSpinner.startAnimating()
                        }
                    }
                    loadMore = false
                    self.getFeedsMore(pageLoad: feedDatasource.count, completion: { _ in })
                }
            }
            
            
            var visibleRect = CGRect()
            visibleRect.origin = scrollView.contentOffset
            visibleRect.size = scrollView.bounds.size
            
            
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            //print("minY : \(visibleRect.minY) \nmidY : \(visibleRect.midY) \nmaxY : \(visibleRect.maxY)")
            
            let cgPoint = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.maxY)
            
            
            guard let indexPath = collectionView.indexPathForItem(at: cgPoint) else { return}
            //let storedIndexPath = self.visibleCellIndex
            let visibleCellIndexPath = self.collectionView.indexPathsForVisibleItems
            // var centerIndexPath = IndexPath(row: NSNotFound, section: NSNotFound)
            let centerPoint   = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.minY)
            guard var centerIndexPath: IndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
            for allIndex in visibleCellIndexPath {
                if visibleCellIndexPath.count == 0 {
                    centerIndexPath = IndexPath(row: feedDatasource.count - 1, section: 1)
                } else {
                    centerIndexPath = allIndex
                }
                print("Visible index path :\(centerIndexPath)")
            }
            
            
            let scrollVelocity = collectionView.panGestureRecognizer.velocity(in: collectionView.superview)
            if (scrollVelocity.y > 0.0) {
                print("going down")
                
                
                
            } else if (scrollVelocity.y < 0.0) {
                print("going up")
            }
            self.scrollViewDidEndScrolling()
            
            print("Get Center IndexPath : \(centerIndexPath) \nCurrent IndexPath :\(indexPath)")
            
        }
    }
    
    
    fileprivate func messageHeight(for text: String) -> CGFloat{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "HelveticaNeue", size: 14)!
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth:CGFloat = 130 //240 default
        let maxsize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxsize)
        return neededSize.height
    }
    func presentGallery(photos: [MarketPhotoViewable], initialPhoto: MarketPhotoViewable){
        
        let gallery = MarketPhotosController(photos: photos, initialPhoto: initialPhoto, referenceView: nil)
        self.present(gallery, animated: true, completion: nil)
    }
}
extension FeedsVC : MarketScrollDelegate {
    func didShareBtnTapped(sender: Any,listingId: String,userId : String, image: UIImage, imageURL: NSURL) {
        let encodedListId = listingId.toBase64()
        //let id = Int(listingId)!
        let firstActivityItem = "The product posted in Myscrap, Check out the link below"
        let secondActivityItem : NSURL = NSURL(string: "https://myscrap.com/ms/market/\(encodedListId)")!
        //let secondActivityItem : NSURL = NSURL(string: "iOSMyScrapApp://myscrap.com/marketLists/\(id)/userId\(userId)")!
        
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: [])
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    func didTapUserProfile(userId: String) {
        self.performFriendView(friendId: userId)
    }
    
    func didTapMarketView(listingId: String, userId: String) {
        let vc = DetailListingOfferVC.controllerInstance(with:  listingId, with1: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FeedsVC: VoteScrollDelegate {
    
    func didTapVoteView(index: Int, voterId: String) {
        let vc = VoterPollScreenVC.storyBoardInstance()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func didTapVoterBio(index: Int, voterId: String) {
        
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = voterId
            vc.selectedIndex = index
            vc.navigationItem.title = "Vote For Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func didShareBtnTapped(sender: Any, voterId: String, voterName: String) {
        let encodedVoterId = voterId.toBase64()
        
        let secondActivityItem : NSURL = NSURL(string: "https://myscrap.com/ms/vote/\(encodedVoterId)")!
        
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [secondActivityItem], applicationActivities: [])
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
extension FeedsVC: POWScrollDelegate {
    func didShareBtnTapped(sender: Any, powId: String) {
        let encodedPOWId = powId.toBase64()
        //let id = Int(listingId)!
        let firstActivityItem = "The product posted in Myscrap, Check out the link below"
        let secondActivityItem : NSURL = NSURL(string: "https://myscrap.com/msweekperson/\(encodedPOWId)")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: [])
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapPOWView(powId: String, userId: String) {
        let vc = FeedsPOWDetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.powId = powId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension FeedsVC: NewUserDelegate {
    func didTapProfile(userId: String) {
        self.performFriendView(friendId: userId)
    }
    
}
extension FeedsVC: FeedVCHeaderCellDelegate{
    
    
    func tappedFriendSeelected (activeuser: ActiveUsers, isLive: Bool) {
        if isLive {
            if let vc = JoinUserLiveVC.storyBoardInstance() {
                  vc.friendId = activeuser.userid!
                  vc.liveID = activeuser.liveId!
                vc.liveUserNameValue  = activeuser.name!
                vc.liveUserImageValue  = activeuser.profilePic!
                vc.liveUserProfileColor  = activeuser.colorCode!
                vc.liveUsertopicValue  = activeuser.topic!
                vc.liveType  = activeuser.liveType!

                   self.navigationController?.pushViewController(vc, animated: true)
                }
        }
        else{
            performFriendView(friendId: activeuser.userid!)
      }
    }

    
}

extension FeedsVC: OnlineDelegate{
    func DidReceivedData(data: [ActiveUsers]) {
        DispatchQueue.main.async {
            //self.headerView.remov
            self.memberDataSource = data
            if  self.memberDataSource.count > 0
            {
                self.headerCellHeight.constant = 100
                self.headerCell!.datasource = self.memberDataSource
                UIView.performWithoutAnimation {
                    self.headerCell!.collectionView.reloadData()
                 }
                self.headerCell!.addAnimationIfNeeded()
            }
            else
            {
                self.headerCellHeight.constant = 0
                
            }
            
        }
    }
    
    func DidReceivedError(error: String) {
        print("error")
    }
}
extension FeedsVC: MSSliderDelegate {
    func didSelect(photo: Images, in photos: [Images]) {
        let vc = MarketPhotosController()
        vc.photo = photo
        presentGallery(photos: photos, initialPhoto: photo)
    }
}

extension FeedsVC {
    fileprivate func performDetailsController(obj: FeedV2Item){
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        //  vc.feedV2Item = obj;
        vc.postId = obj.postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func toPostVC(){
        
        if let vc = AddPostV2Controller.storyBoardReference(){
            vc.didPost = { success, isVideoPosted in
                if success{
                    vc.dismiss(animated: true, completion: nil)
                    
                    DispatchQueue.main.async {
                        self.showToast(message: "Post uploaded")
                    }
                    self.postBtn.isEnabled = true
                    self.cameraBtn.isEnabled = true
                    //                    self.active.isHidden = false
                    if !self.topLoader.isAnimating {
                        self.topSpinnerHeightConstraint.constant = 58
                        self.topLoader.startAnimating()
                    }
                    
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    self.getFeeds(pageLoad: 0, completion: {_ in })
                    
                } else {
                    self.showToast(message: "Failed to Post")
                }
                if isVideoPosted {
                    //Show Rate and Review MyScrap
                    DispatchQueue.main.async {
                        self.showToast(message: "Post uploaded")
                    }
                    if #available(iOS 10.3, *) {
                        SKStoreReviewController.requestReview()
                    } else {
                        // Fallback on earlier versions
                        // Try any other 3rd party or manual method here.
                        
                        let appId = "id1233167019?ls=1"
                        let appUrl = "itms-apps://itunes.apple.com/app/" + appId
                        let url = URL(string: appUrl)!
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
            let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
            if #available(iOS 13.0, *) {
                navBarOnModal.modalPresentationStyle = .fullScreen
            }
            self.present(navBarOnModal, animated: true, completion: nil)
        }
    }
    
    fileprivate func toCamera(){
        checkCameraStatus()
    }
    
    private func checkCameraStatus(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized: callCamera()
        case .notDetermined: requestAccess()
        default : alertPromptToAllowCameraSettings()
        }
    }
    
    private func requestAccess(){
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if granted {
                DispatchQueue.main.async {
                    self.callCamera()
                }
            }
        }
    }
    
    private func callCamera(){
        
        let Alert = UIAlertController(title: "Pick one option", message: "Choose an option to post into Feeds", preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Photo", style: .default) { [unowned self] (action) in
            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos
            pickerController.sourceType = .camera
            pickerController.maxSelectableCount=1;
            pickerController.showsCancelButton = true;
            pickerController.showsEmptyAlbums = false;
            pickerController.allowMultipleTypes = false;
            //                                pickerController.defaultSelectedAssets = self.videosToPosts;
            var imagesToPosts : [DKAsset] = [DKAsset]()
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                print("didSelectAssets")
                print(assets)
                imagesToPosts.removeAll()
                for asset in assets {
                    imagesToPosts.append(asset)
                }
                if let vc = AddPostV2Controller.storyBoardReference() {
                    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                    vc.imagesToPosts = imagesToPosts
                    vc.isImage = true
                    vc.isVideo = false
                    vc.refreshImages()
                    vc.didPost = { success, isVideoPosted in
                        if success{
                            vc.dismiss(animated: true, completion: nil)
                            
                            DispatchQueue.main.async {
                                self.showToast(message: "Post uploaded")
                            }
                            self.postBtn.isEnabled = true
                            self.cameraBtn.isEnabled = true
                            //                    self.active.isHidden = false
                            if !self.topLoader.isAnimating {
                                self.topSpinnerHeightConstraint.constant = 58
                                self.topLoader.startAnimating()
                            }
                            //  self.active.startAnimating()
                            // self.refreshContol.beginRefreshing()
                            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                            
                            self.getFeeds(pageLoad: 0, completion: {_ in })
                            
                            
                            // self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
                        } else {
                            self.showToast(message: "Failed to Post")
                        }
                        if isVideoPosted {
                            //Show Rate and Review MyScrap
                            DispatchQueue.main.async {
                                self.showToast(message: "Post uploaded")
                            }
                            if #available(iOS 10.3, *) {
                                SKStoreReviewController.requestReview()
                            } else {
                                // Fallback on earlier versions
                                // Try any other 3rd party or manual method here.
                                
                                let appId = "id1233167019?ls=1"
                                let appUrl = "itms-apps://itunes.apple.com/app/" + appId
                                let url = URL(string: appUrl)!
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }
                    }
                    if #available(iOS 13.0, *) {
                        navBarOnModal.modalPresentationStyle = .fullScreen
                    }
                    self.present(navBarOnModal, animated: true, completion: nil)
                }
            }
            pickerController.modalPresentationStyle = .overFullScreen
          //  self.present(pickerController, animated:false, completion: nil)
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let video = UIAlertAction(title: "Video", style: .default) { [unowned self] (action) in
            
            self.picker.sourceType = .camera
            self.picker.mediaTypes = ["public.movie"]
            self.picker.showsCameraControls = true
            self.picker.isToolbarHidden = true
            self.picker.delegate = self
            self.picker.videoMaximumDuration = TimeInterval(65.0)
            self.picker.allowsEditing = true
            self.picker.cameraCaptureMode = .video
            self.picker.videoQuality = .type640x480
            
            self.present(self.picker,animated: true,completion: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.addAction(photo)
        Alert.addAction(video)
        Alert.addAction(cancel)
        Alert.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(Alert, animated: true, completion: nil)
        
    }
    
    private func alertPromptToAllowCameraSettings(){
        AlertService.instance.showCameraSettingsURL(in: self)
    }
    
}

extension FeedsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            dismiss(animated: false) {
                /*if let vc = EditPostVC.storyBoardReference() {
                 let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                 vc.showVideo = video
                 self.present(navBarOnModal, animated: true, completion: nil)
                 }*/
                if picker.sourceType == .camera {
                    UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(video.path)
                    // Handle a movie capture
                    UISaveVideoAtPathToSavedPhotosAlbum(video.path,self,#selector(self.video(_:didFinishSavingWithError:contextInfo:)),nil)
                }
                if let vc = AddPostV2Controller.storyBoardReference() {
                    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                    vc.videoPickedUrl = video
                    vc.isImage = false
                    vc.isVideo = true
                    vc.didPost = { success, isVideoPosted in
                        if success{
                            vc.dismiss(animated: true, completion: nil)
                            
                            DispatchQueue.main.async {
                                self.showToast(message: "Post uploaded")
                            }
                            self.postBtn.isEnabled = true
                            self.cameraBtn.isEnabled = true
                            //                    self.active.isHidden = false
                            if !self.topLoader.isAnimating {
                                self.topSpinnerHeightConstraint.constant = 58
                                self.topLoader.startAnimating()
                            }
                            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                            
                            self.getFeeds(pageLoad: 0, completion: {_ in })
                            
                        } else {
                            self.showToast(message: "Failed to Post")
                        }
                        if isVideoPosted {
                            //Show Rate and Review MyScrap
                            DispatchQueue.main.async {
                                self.showToast(message: "Post uploaded")
                            }
                            if #available(iOS 10.3, *) {
                                SKStoreReviewController.requestReview()
                            } else {
                                // Fallback on earlier versions
                                // Try any other 3rd party or manual method here.
                                
                                let appId = "id1233167019?ls=1"
                                let appUrl = "itms-apps://itunes.apple.com/app/" + appId
                                let url = URL(string: appUrl)!
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }
                    }
                    if #available(iOS 13.0, *) {
                        navBarOnModal.modalPresentationStyle = .fullScreen
                    }
                    self.present(navBarOnModal, animated: true, completion: nil)
                }
            }
        }
        
    }
    //Save photo into Photos
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            print("Store image into Photos error: \(error)")
        } else {
            
            print("Image stored into Photos!!")
        }
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        
        print(message)
    }
}



extension FeedsVC : UpdatedFeedsDelegate {
    //#2#7api after count
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return feedDatasource
        }
        set {
            feedDatasource = newValue
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView
    }
    
    func didTapEditV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest { showGuestAlert() } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { [unowned self] (report) in
                if let vc = AddPostV2Controller.storyBoardReference(){
                    vc.title = "Edit Post"
                    if let imageTextCell = cell as? FeedImageTextCell{
                        vc.isImage = true
                        vc.postImage = imageTextCell.feedImage.image
                    } else if let imageCell = cell as? FeedImageCell{
                        vc.isImage = true
                        vc.postImage = imageCell.feedImage.image
                    } else if let portraitCell = cell as? EmplPortraitVideoCell {
                        vc.isVideo = true
                        vc.videoPickedUrl = URL(string: item.videoUrl)
                    } else if let landsCell = cell  as? EmplLandscVideoCell {
                        vc.isVideo = true
                        vc.videoPickedUrl = URL(string: item.videoUrl)
                    } else if let portTextCell = cell  as? EmplPortrVideoTextCell {
                        vc.isVideo = true
                        vc.videoPickedUrl = URL(string: item.videoUrl)
                    } else if let landsTextCell = cell  as? EmplLandsVideoTextCell {
                        vc.isVideo = true
                        vc.videoPickedUrl = URL(string: item.videoUrl)
                    }
                    
                    let text = item.status
                    vc.postText = text
                    if text == "" {
                        UserDefaults.standard.set("", forKey: "postText")
                    }
                    vc.editPostId = item.postId
                    print("Post Id : \(vc.editPostId)")
                    vc.didPost = { succes, isVideoPosted in
                        print("returned")
                        if !self.topLoader.isAnimating {
                            self.topSpinnerHeightConstraint.constant = 58
                            self.topLoader.startAnimating()
                        }
                        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        
                        self.getFeeds(pageLoad: 0, completion: {_ in })
                    }
                    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                    if #available(iOS 13.0, *) {
                        navBarOnModal.modalPresentationStyle = .fullScreen
                    }
                    self.present(navBarOnModal, animated: true, completion: nil)
                    
                }
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { [unowned self] (report) in
                
                if let portraitCell = cell as? EmplPortraitVideoCell {
                    portraitCell.player.isMuted = true
                    portraitCell.player.pause()
                    portraitCell.player.actionAtItemEnd = .pause
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: portraitCell.player.currentItem)
                    portraitCell.playerLayer.player = nil
                    portraitCell.playerLayer.removeFromSuperlayer()
                } else if let landsCell = cell  as? EmplLandscVideoCell {
                    landsCell.player.isMuted = true
                    landsCell.player.pause()
                    landsCell.player.actionAtItemEnd = .pause
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: landsCell.player.currentItem)
                    landsCell.playerLayer.player = nil
                    landsCell.playerLayer.removeFromSuperlayer()
                } else if let portTextCell = cell  as? EmplPortrVideoTextCell {
                    portTextCell.player.isMuted = true
                    portTextCell.player.pause()
                    portTextCell.player.actionAtItemEnd = .pause
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: portTextCell.player.currentItem)
                    portTextCell.playerLayer.player = nil
                    portTextCell.playerLayer.removeFromSuperlayer()
                } else if let landsTextCell = cell  as? EmplLandsVideoTextCell {
                    landsTextCell.player.isMuted = true
                    landsTextCell.player.rate = 0
                    landsTextCell.player.pause()
                    landsTextCell.player.actionAtItemEnd = .pause
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: landsTextCell.player.currentItem)
                    landsTextCell.playerLayer.player = nil
                    landsTextCell.playerLayer.removeFromSuperlayer()
                }
                self.feedsV2DataSource.remove(at: indexPath.item)
                self.feedV2Service.deletePost(postId: item.postId, albumId: item.albumId)
                self.feedCollectionView.performBatchUpdates({
                    self.feedCollectionView.deleteItems(at: [indexPath])
                }, completion: nil)
                self.showToast(message: "Post Deleted")
                if !self.topLoader.isAnimating {
                    self.topSpinnerHeightConstraint.constant = 58
                    self.topLoader.startAnimating()
                    //overlay.removeFromSuperview()
                }
                self.active.startAnimating()
                self.refreshContol.beginRefreshing()
                self.handleRefresh()
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = UIColor.GREEN_PRIMARY
            present(actionSheet, animated: true, completion: nil)
        }
    }
}

extension FeedsVC {
    static func storyBoardInstance() -> FeedsVC? {
        let sb = UIStoryboard.MAIN
        return sb.instantiateViewController(withIdentifier: FeedsVC.id) as? FeedsVC
    }
}

extension FeedsVC{
    
    @objc func userSignedIn(_ notification: Notification){
        userSignedInOperation = BlockOperation{
            self.usersignedIn()
        }
        userSignedInOperation?.start()
    }
    
    func usersignedIn(){
        NotificationService.instance.getNotificationCount()
        LocationService.sharedInstance.setupLocationManager()
        
    }
}
extension FeedsVC: FloatyDelegate{
    func emptyFloatySelected(_ floaty: Floaty) {
        if let vc = LiveDiscussion.storyBoardInstance() {
            if AuthStatus.instance.isGuest{
                self.showGuestAlert()
            } else {
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
}
extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
extension FeedsVC: CovidServiceDelegate {
    func DidGetPollStatus(isPollDone: Bool) {
        DispatchQueue.main.async {
            //Checking whether i have voted already or not
            if !isPollDone {
                self.showingCovidPollPopup()
            }
        }
    }
    
    func DidReceiveCovidResponse(status: String) {
        DispatchQueue.main.async {
            print("This will not trigger here!!")
        }
    }
    
    func DidReceivedCovidError(error: String) {
        DispatchQueue.main.async {
            self.showToast(message: error)
        }
        
    }
}
extension FeedsVC: RoasterServiceDelegate {
    func DidReceivedData(data: [RoasterItems]) {
        let writeQueue = DispatchQueue(label: "background", qos: .background, attributes: [.concurrent])
        writeQueue.async {
            let startTime = CFAbsoluteTimeGetCurrent()
            autoreleasepool {
                var realmBatches = [UserPrivChat]()
                let realm = try! Realm()
                
                print(realm.configuration.fileURL!)
                
                for obj in data{
                    
                    //Market Message fetch
                    //Converting String to JSON
                    var type = ""
                    var title = ""
                    var rate = ""
                    var listingId = ""
                    
                    if obj.stanzaType == "marketAdv" {
                        let jsonString = obj.body
                        let jsondata = jsonString.data(using: .utf8)!
                        do {
                            if let jsonArray = try JSONSerialization.jsonObject(with: jsondata, options : .allowFragments) as? [String:String] {
                                //print("Converted json string",jsonArray) // use the json here
                                if let recType = jsonArray["type"] {
                                    if recType == "0" || recType == "SELL" {
                                        type = "SELL"
                                    } else if recType == "1" || recType == "BUY"{
                                        type = "BUY"
                                    }
                                }
                                if let recTitle = jsonArray["title"]{
                                    title = recTitle
                                }
                                if let recRate = jsonArray["rate"]{
                                    rate = recRate
                                }
                                if let recListingID = jsonArray["listingId"] {
                                    listingId = recListingID
                                }
                            } /*else {
                             print("bad json")
                             }*/
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                    
                    let roastChat = UserPrivChat()
                    var userJID = ""
                    if AuthService.instance.userJID!.contains("@myscrap.com") {
                        userJID = AuthService.instance.userJID!
                    } else {
                        userJID = AuthService.instance.userJID! + "@myscrap.com"
                    }
                    //print("FromJID :\(obj.fromJID) , ToJID : \(obj.toJID)")
                    if obj.fromJID == userJID  || obj.toJID == userJID {
                        if obj.fromId == AuthService.instance.userId {
                            //Message sent by me
                            roastChat.conversationId = obj.fromId + obj.userId
                            roastChat.fromJID = obj.fromJID
                            roastChat.toJID = obj.toJID
                            roastChat.body = obj.body
                            roastChat.stanza = obj.stanza
                            roastChat.fromUserId = obj.fromId
                            roastChat.toUserId = obj.userId
                            roastChat.fromImageUrl = obj.fImage
                            roastChat.toImageUrl = obj.uImage
                            roastChat.fromUserName = obj.fName
                            roastChat.toUserName = obj.uName
                            roastChat.fromColorCode = obj.fColor
                            roastChat.toColorCode = obj.uColor
                            roastChat.messageType = obj.type
                            // Updated with previous commented line to get the actual sender and receiver time
                            if obj.sentReceiveTimeStamp != "" {
                                roastChat.timeStamp = obj.sentReceiveTimeStamp
                                let intTimeStamp = Int64(obj.sentReceiveTimeStamp)
                                if intTimeStamp != nil {
                                    // get the current date and time
                                    let currentDateTime = Date(milliseconds: intTimeStamp!)
                                    // initialize the date formatter and set the style
                                    let formatter = DateFormatter()
                                    //formatter.timeZone = TimeZone(abbreviation: "GMT")
                                    //formatter.dateFormat = "dd-MMM, HH:mm"        //24 hrs
                                    formatter.dateFormat = "dd-MMM, h:mm a"     //12 hrs
                                    roastChat.time = formatter.string(from: currentDateTime)
                                } else {
                                    print("Timestamp can't convert to INT64 because it's not in correct format")
                                }
                            } else {
                                roastChat.timeStamp = obj.messageTimeMM
                                roastChat.time = obj.messageTime
                            }
                            roastChat.readCount = 1
                            roastChat.stanzaType = obj.stanzaType
                            roastChat.marketUrl = obj.marketUrl
                            roastChat.type = type
                            roastChat.title = title
                            roastChat.rate = ""
                            roastChat.listingId = listingId
                            roastChat.msgStatus = "received"
                            realmBatches.append(roastChat)
                            
                        } else if obj.userId == AuthService.instance.userId {
                            //Message received to me
                            roastChat.conversationId = obj.userId + obj.fromId
                            roastChat.fromJID = obj.fromJID
                            roastChat.toJID = obj.toJID
                            roastChat.body = obj.body
                            roastChat.stanza = obj.stanza
                            roastChat.fromUserId = obj.fromId
                            roastChat.toUserId = obj.userId
                            roastChat.fromImageUrl = obj.fImage
                            roastChat.toImageUrl = obj.uImage
                            roastChat.fromUserName = obj.fName
                            roastChat.toUserName = obj.uName
                            roastChat.fromColorCode = obj.fColor
                            roastChat.toColorCode = obj.uColor
                            roastChat.messageType = obj.type
                            // Updated with previous commented line to get the actual sender and receiver time
                            if obj.sentReceiveTimeStamp != "" {
                                roastChat.timeStamp = obj.sentReceiveTimeStamp
                                let intTimeStamp = Int64(obj.sentReceiveTimeStamp)
                                if intTimeStamp != nil {
                                    // get the current date and time
                                    let currentDateTime = Date(milliseconds: intTimeStamp!)
                                    // initialize the date formatter and set the style
                                    let formatter = DateFormatter()
                                    //formatter.timeZone = TimeZone(abbreviation: "GMT")
                                    //formatter.dateFormat = "dd-MMM, HH:mm"        //24 hrs
                                    formatter.dateFormat = "dd-MMM, h:mm a"     //12 hrs
                                    roastChat.time = formatter.string(from: currentDateTime)
                                } else {
                                    print("Timestamp can't convert to INT64 because it's not in correct format")
                                }
                            } else {
                                roastChat.timeStamp = obj.messageTimeMM
                                roastChat.time = obj.messageTime
                            }
                            roastChat.readCount = 1
                            roastChat.stanzaType = obj.stanzaType
                            roastChat.marketUrl = obj.marketUrl
                            roastChat.type = type
                            roastChat.title = title
                            roastChat.rate = ""
                            roastChat.listingId = listingId
                            realmBatches.append(roastChat)
                            
                            
                        } else if obj.toJID == "livechatdiscussion@conference.myscrap.com" {
                            // Chance for livechat as ToJID
                            print("This will not handle in DB because TOJID is live chat")
                            //For storing Livechat to DB
                        } else if obj.stanza.contains("/Spark ") {
                            print("Message from spark user")
                        } /*else {
                         print("Some weird thing happened in db")
                         }*/
                    } else {
                        print("This will not handle in DB because user JID is not me")
                    }
                }
                try! realm.write {
                    realm.add(realmBatches)
                }
                print("background Thread Time \(CFAbsoluteTimeGetCurrent() - startTime)")
                
            }
            
        }
    }
    
    
}
extension FeedsVC : AlartMessagePopupViewDelegate
{
    func openEditProfileView() {
        self.gotoEditProfilePopup()
    }
    
    
}
extension FeedsVC : PortraitVideoDelegate
{
    func PortraitVideoFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func PortraitVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    
    
}
extension FeedsVC : PortraitVideoTextDelegate
{
    func PortraitTextVideoFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func PortraitTextVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    
    
}
extension FeedsVC : LandScapVideoDelegate
{
    func LandScapVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    
    func LandScapVideoFullScreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
extension FeedsVC : LandScapVideoTextDelegate
{
    func LandScapTextVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    func LandScapVideoTextFullScreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
extension FeedsVC : AVPlayerViewControllerDelegate
{
    func playerViewController(_: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator)
    {
        self.scrollViewDidEndScrolling()
    }
}
