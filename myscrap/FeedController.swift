//
//  FeedController.swift
//  myscrap
//
//  Created by MS1 on 2/20/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation
import BTNavigationDropdownMenu
import XMPPFramework

class FeedController:BaseRevealVC, FriendControllerDelegate {
    
    fileprivate var feedDatasource = [FeedItem]()
    fileprivate var feedService = FeedModel()
    fileprivate var memberDataSource = [MemberItem]()
    fileprivate var memberService = MemmberModel()
    fileprivate var storiesDataSource = [StoriesList]()
    fileprivate var storiesService = StoriesModel()
    fileprivate var loadMore = true
    fileprivate var chosenImage: UIImage?
    
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
    
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var  active: UIActivityIndicatorView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var profileImgView: CircularImageView!
    @IBOutlet weak var profileView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        //Navigationbar Dropdown
//        let items = ["Feeds", "Live Discussion"]
//
//        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.index(0), items: items)
//
//        self.navigationItem.titleView = menuView
//        //menuView.arrowTintColor = UIColor.white
//        menuView.cellTextLabelAlignment = .left
//        menuView.cellTextLabelColor = UIColor.MyScrapGreen
//        menuView.menuTitleColor = UIColor.white
//        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
//
//            if items[indexPath] == "Live Discussion" {
//                print("Did select item at index: 22222 \(indexPath)")
//
//                let controller = self?.storyboard?.instantiateViewController(withIdentifier: "LiveDiscussion")
//                let rearViewController = MenuVC()
//                let frontNavigationController = UINavigationController(rootViewController: controller!)
//                let mainRevealController = SWRevealViewController()
//                mainRevealController.rearViewController = rearViewController
//                mainRevealController.frontViewController = frontNavigationController
//                self?.present(mainRevealController, animated: true, completion: {
//                    //NotificationCenter.default.post(name: .userSignedIn, object: nil)
//                })
//
//                if XMPPService.instance.isConnected == true {
//                    XMPPService.instance.addMembers()
//                } else {
//                    print("Xmpp still not connected")
//                }
//
//            } else {
//                print("I'm in Feeds module")
//
//                if XMPPService.instance.isConnected == true {
//                    XMPPService.instance.offline()
//                } else {
//                    print("Xmpp still not connected")
//                }
//
//            }
//
//            //self.selectedCellLabel.text = items[indexPath]
//        }
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        collectionView.refreshControl = refreshContol
        setupViews()
        
        active.startAnimating()
        
        print("hi get profile percent")
        getProfile()
        storiesService.getStories()         //Get recent stories feeds
        //Calling story delegate
        storiesService.delegate = self
        feedOperation = BlockOperation {
            print("hello")
            let group = DispatchGroup()
            group.enter()
            self.getFeeds(pageLoad: self.feedDatasource.count, completion: { _ in
                group.leave()
            })
            group.notify(queue: .main, execute: {
                print("groupleaved")
                self.nearFriendOperation?.start()
                self.locationAndDeviceOperation?.start()
            })
        }
        
        nearFriendOperation = BlockOperation {
            print("nearfriend operation taking place")
            self.memberService.getNearFriends(completion: { (members) in
                DispatchQueue.main.async {
                    self.memberDataSource = members
                    self.collectionView.performBatchUpdates({
                        let indexSet = IndexSet(integer: 0)
                        self.collectionView.reloadSections(indexSet)
                    }, completion: nil)
                }
            })
        }
        
        locationAndDeviceOperation = BlockOperation {
            NotificationService.instance.updateDeviceToken()
            LocationService.sharedInstance.processLocation()
        }
        view.endEditing(true)
        
        setupLoading()

        //Group chat fetching
        //XMPPService.instance.delegate = self
        
    }
    /**
    Timer called
    **/
    @objc func runTimedCode() {
        if XMPPService.instance.isConnected == true {
            setupFloaty()
            gameTimer.invalidate()
            //showMessage(with: "Xmpp Connected")
        }
    }
    
    func getProfile(){
        print("HEre")
        service.getUserProfile(pageLoad: "\(feedDatasource.count)")
    }
    
    private func setupFloaty(){
        floaty.respondsToKeyboard = false
        floaty.paddingX = 20
        floaty.paddingY = 70
        floaty.title.text = "Live"
//        floaty.buttonImage = #imageLiteral(resourceName: "Chat-0")
        print("Floating text Width and height : \(floaty.title.width), \(floaty.title.height)")
        floaty.hasShadow = true
        floaty.buttonColor = UIColor(hexString: "#ed1b24")
        floaty.fabDelegate = self
        
        
        
        self.view.addSubview(floaty)
        gameTimer.invalidate()
    }
    
    private func setupLoading(){
        feedOperation?.start()
//        nearFriendOperation?.addDependency(feedOperation!)
//        locationAndDeviceOperation?.addDependency(feedOperation!)
//        nearFriendOperation?.start()
    }
    
    fileprivate var isRefreshControl = false
    
    
    fileprivate lazy var refreshContol : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    @objc
    fileprivate func handleRefresh(){
        if active.isAnimating { active.stopAnimating() }
        isRefreshControl = true
        getFeeds(pageLoad: 0, completion: {_ in })
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if AuthStatus.instance.isLoggedIn {
            self.usersignedIn()
        }
        if AuthService.instance.colorCode != nil ?? "" && AuthService.instance.profilePic != nil ?? ""{
            profileView.backgroundColor = UIColor(hexString: AuthService.instance.colorCode)
            initialLbl.text = AuthService.instance.fullName.initials()
            print("Feed in IF Initials :\(String(describing: initialLbl.text)), \(AuthService.instance.profilePic)")
            profileImgView.sd_setImage(with: URL(string: AuthService.instance.profilePic), completed: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(FeedController.userSignedIn(_:)), name: Notification.Name.userSignedIn, object: nil)
        }
        else {
            profileView.backgroundColor = UIColor(hexString: AuthService.instance.colorCode)
            initialLbl.text = AuthService.instance.fullName.initials()
            print("Feed in Else Initials :\(String(describing: initialLbl.text))")
            profileImgView.sd_setImage(with: URL(string: "Blank"), completed: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(FeedController.userSignedIn(_:)), name: Notification.Name.userSignedIn, object: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
    }
    
    
    private func setupViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UpdateProfileViewCell.Nib, forCellWithReuseIdentifier: "UpdateProfileViewCell")
        collectionView.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        collectionView.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        collectionView.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
        collectionView.register(FeedNewUserCell.Nib, forCellWithReuseIdentifier: FeedNewUserCell.identifier)
        collectionView.register(NewswithImageCell.Nib, forCellWithReuseIdentifier: NewswithImageCell.identifier)
        collectionView.register(NewsTextCell.Nib, forCellWithReuseIdentifier: NewsTextCell.identifier)
        collectionView.register(FeedEventCell.Nib, forCellWithReuseIdentifier: FeedEventCell.identifier)
        collectionView.registerNibLoadable(FeedListingCell.self)
        
    }
    
    private func getFeeds(pageLoad: Int, completion: @escaping (Bool) -> () ){
        feedService.getFeeds(pageLoad: "\(pageLoad)") { (result) in
            DispatchQueue.main.async {
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    self.feedDatasource = [FeedItem]()
                    self.isRefreshControl = false
                }
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    var newData = self.feedDatasource + data
                    newData.removeDuplicates()
                    self.feedDatasource = newData
                    self.collectionView.reloadData()
                    self.loadMore = true
                    print("&&&&&&&&&&&")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    //MARK :- CAMERA BTN CLICKED
    @IBAction func cameraClicked(_ sender: UIButton) {
        if AuthStatus.instance.isGuest{
            self.showGuestAlert()
        } else {
            self.toCamera()
        }
    }
    
    // MARK :- POST BUTTON FUNCTION
    @IBAction func postBtnClicked(_ sender: UIButton) {
        if AuthStatus.instance.isGuest{
            self.showGuestAlert()
        } else {
            self.toPostVC()
        }
    }
}
extension FeedController: StoriesModelDelegate {
    func DidReceiveError(error: String) {
        print("Error in stories while fetching : \(error)")
    }
    
    func DidReceiveStories(item: [StoriesList]) {
        DispatchQueue.main.async {
            self.storiesDataSource = item
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integer: 0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
        }
    }
}
extension FeedController: UICollectionViewDelegate{
    
}

extension FeedController:  UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        /*else if section == 1 {
            return 1
        }*/
        else if section == 1 {
            return 1
        }
        else {
            return feedDatasource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if indexPath.section == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedHeaderCell", for: indexPath) as? FeedHeaderCell else { return UICollectionViewCell() }
//            cell.datasource = memberDataSource
//            cell.delegate = self
            cell.collectionView.reloadData()
            return cell
         }
         /*else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoriesFeedsCell", for: indexPath) as? StoriesFeedsCell
                else { return UICollectionViewCell() }
            cell.datasource = storiesDataSource
            cell.delegate = self
            cell.collectionView.reloadData()
            return cell
         }*/
         else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpdateProfileViewCell", for: indexPath) as? UpdateProfileViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.completeBtn.layer.cornerRadius = 3
            cell.completeBtn.clipsToBounds = true
            
            //cell.completerBtnPressed(self)
            return cell
         } else {
            let data  = feedDatasource[indexPath.item]
            switch data.cellType{
            case .feedNewUserCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedNewUserCell.identifier, for: indexPath) as? FeedNewUserCell else { return UICollectionViewCell()}
                cell.delegate = self
                cell.item = data
                return cell
            case .feedTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTextCell.identifier, for: indexPath) as? FeedTextCell else { return UICollectionViewCell()}
                cell.delegate = self
                cell.item = data
                return cell
            case .feedImageCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell()}
                cell.delegate = self
                cell.item = data
                return cell
            case .feedImageTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageTextCell.identifier, for: indexPath) as? FeedImageTextCell else { return UICollectionViewCell()}
                cell.delegate = self
                cell.item = data
                return cell
            case .newsTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsTextCell.identifier, for: indexPath) as? NewsTextCell else { return UICollectionViewCell()}
                cell.configCell(item: data)
                cell.feedItem = data
                cell.delegate = self
                return cell
            case .newsImageCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewswithImageCell.identifier, for: indexPath) as? NewswithImageCell else { return UICollectionViewCell()}
                cell.configCell(item: data)
                cell.feedItem = data
                cell.delegate = self
                return cell
            case .eventCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedEventCell.identifier, for: indexPath) as? FeedEventCell else { return UICollectionViewCell()}
                cell.delegate = self
                cell.item = data
                return cell
            case .feedListingCell:
                let cell : FeedListingCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                cell.listingFeed = data
                print("Market list : \(cell.listingFeed)")
                return cell
            case .userFeedImageTextCell:
                print("Image text")
            case .userFeedImageCell:
                print("Image")
            case .userFeedTextCell:
                print("Text")
            }
            return UICollectionViewCell()
        }
        
    }
    
    
    
    @objc func tapViewMored(_ indexPath: IndexPath){
        
    }
}
    





extension FeedController: UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        //let percentage = UserDefaults.standard.integer(forKey: "proPer")
        let close = UserDefaults.standard.bool(forKey: "closeBtn")
        //var percentage = 100
        if indexPath.section == 1 {
            if AuthStatus.instance.isGuest{
                return CGSize(width: width , height: 0)
            }//Edited percentage = 0
            else if percentageNew == 100 {
                print("Profile percentinside: \(percentageNew)")
                return CGSize(width: view.frame.width, height: 0)
            }
            else {
                let cell = collectionView.cellForItem(at: indexPath )
                if close == true {
                    UserDefaults.standard.set(false, forKey: "closeBtn")
                    print("Getting in ")
                    return CGSize(width: width, height: 0)
                }
                else {
                    cell?.isHidden = false
                    print("Profile percent outside: \(percentageNew)")
                    return CGSize(width: width , height: 119)
                }
                
            }
            //return CGSize(width: width, height: 0)
            
        } else if indexPath.section == 0 {
            if !memberDataSource.isEmpty{
                return CGSize(width: width , height: 90)
            } else {
                return CGSize(width: width , height: 0)
            }
        }
        /*else if indexPath.section == 1 {
            let width = self.view.frame.width
            return CGSize(width: width, height: 243)
        }*/
        else {
            let item = feedDatasource[indexPath.item]
            print(item.cellType.rawValue)
            var height : CGFloat = 0
            switch item.cellType{
            case .feedNewUserCell:
                height = FeedsHeight.heightForNewUserCell(item: item, viewWidth: width)
                return CGSize(width: width , height: height)
            case .feedTextCell:
                height = FeedsHeight.heightforFeedTextCell(item: item , labelWidth: width - 16)
                return CGSize(width: width , height: height)
            case .feedImageCell:
                height = FeedsHeight.heightForImageCell(item: item, width: width)
                return CGSize(width: width, height: height)
            case .feedImageTextCell:
                height = FeedsHeight.heightForImageTextCell(item: item, width: width, labelWidth: width - 16)
                return CGSize(width: width, height: height)
            case .newsTextCell:
                height = FeedsHeight.heightForNewsTextCell(item: item, labelWidth: width - 16)
                return CGSize(width: width, height: height)
            case .newsImageCell:
                height = FeedsHeight.heightForNewsImageCell(item: item, labelWidth: width - 16)
                return CGSize(width: width, height: height)
            case .eventCell:
                height = FeedsHeight.heightForImageTextCell(item: item, width: width, labelWidth: width - 16)
                return CGSize(width: width, height: height)
            case .feedListingCell:
                print("Index path for crashing",indexPath.item)
                if indexPath.item == 0 {
                    return CGSize(width: width, height: 0)
                }
                else {
                    if item.listingFeed == nil {
                        print("Height and width is zero")
                        return CGSize(width: 0, height: 0)
                    }
                    else {
                        print("if nil : \(item.listingFeed!.attributedStatus)")
                        if item.listingFeed?.listingImg == "" || item.listingFeed?.listingImg == "https://myscrap.com/uploads/listing_img/no-image.png" {
                            height = FeedsHeight.heightForListingFeedTextCell(width: width, text: item.listingFeed!.attributedStatus, labelWidth: width)
                            print("Cell height : \(height)")
                            return CGSize(width: width, height:  height / 2)
                        } else {
                            height = FeedsHeight.heightForListingFeedCell(width: width, text: item.listingFeed!.attributedStatus, labelWidth: width - 16)
                            return CGSize(width: width, height:  height + 25)       //Changed the height from height - 1
                        }
                    }
                }
            case .userFeedImageTextCell:
                print("Image text")
                return CGSize(width: 0, height: 0)
            case .userFeedImageCell:
                print("Image")
                return CGSize(width: 0, height: 0)
            case .userFeedTextCell:
                print("Text")
                return CGSize(width: 0, height: 0)
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
                    loadMore = false
                    self.getFeeds(pageLoad: feedDatasource.count, completion: { _ in })
                }
            }
        }
    }
}

extension FeedController: FeedHeaderCellDelegate{
    func tappedFriend(friendId: String) {
        performFriendView(friendId: friendId)
    }
}

extension FeedController: MemberDelegate{
    func DidReceivedData(data: [MemberItem]) {
        DispatchQueue.main.async {
            self.memberDataSource = data
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integer: 0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
        }
    }
    
    func DidReceivedError(error: String) {
        print("error")
    }
}



extension FeedController: FeedsNewsDelegate{
    func DidTapLikeCount(cell: NewsTextCell) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            if let indexPath = collectionView.indexPathForItem(at: cell.center) {
                let obj = feedDatasource[indexPath.item]
//                performLikeVC(for: obj)
                performLikeVC(for: obj.postId)
            }
        }
    }
    
    func PerformLike(cell: NewsTextCell) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            if let indexpath = collectionView.indexPathForItem(at: cell.center){
                let obj = feedDatasource[indexpath.item]
                obj.likeStatus = !obj.likeStatus
                if obj.likeStatus{
                    obj.likeCount += 1
                } else {
                    obj.likeCount -= 1
                }
                collectionView.reloadItems(at: [indexpath])
                feedService.postLike(postId: obj.postId, frinedId: obj.postedUserId)
            }
        }
    }
    
    func PerformContinueReading(cell: NewsTextCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center) {
            let obj = feedDatasource[indexPath.item]
            obj.isCellExpanded = true
            collectionView.performBatchUpdates({
                self.collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    func PerformDetailNews(cell: NewsTextCell) {
        if !AuthStatus.instance.isGuest {
            print("News is disabled")
//            if let indexPath = collectionView.indexPathForItem(at: cell.center){
//                let obj = feedDatasource[indexPath.row]
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SingleNewsVC") as! SingleNewsVC
//                vc.newsId = obj.postId
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        } else {
            showGuestAlert()
        }
    }
    
    func PerformComapny(cell: NewsTextCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center){
            let obj = feedDatasource[indexPath.row]
            if let url = URL(string: obj.publisherUrl){
                let vc = SFSafariViewController(url: url)
                vc.preferredBarTintColor = UIColor.GREEN_PRIMARY
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}



extension FeedController {
    fileprivate func performDetailsController(obj: FeedItem){        
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = obj.postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    
    fileprivate func toPostVC(){
        if let vc = EditPostVC.storyBoardReference(){
            vc.didPost = { success in
                if success{
                    self.refreshContol.beginRefreshing()
                    self.handleRefresh()
                }
            }
            let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
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
                self.callCamera()
            }
        }
    }
    
    private func callCamera(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func alertPromptToAllowCameraSettings(){
        AlertService.instance.showCameraSettingsURL(in: self)
    }
    
}

extension FeedController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: false) {
            if let vc = EditPostVC.storyBoardReference() {
                let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                vc.postImage = chosenImage
                self.present(navBarOnModal, animated: true, completion: nil)
            }
        }
    }
}



extension FeedController : FeedsDelegate {
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return feedsV2DataSource
        }
        set {
            //nothing
        }
    }
    
    
    var feedsDataSource: [FeedItem] {
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
}

extension FeedController {
    
    static func storyBoardInstance() -> FeedController? {
        let sb = UIStoryboard.MAIN
        return sb.instantiateViewController(withIdentifier: FeedController.id) as? FeedController
    }
    
}

extension FeedController{
    
    @objc func userSignedIn(_ notification: Notification){
        userSignedInOperation = BlockOperation{
            self.usersignedIn()
        }
        userSignedInOperation?.addDependency(feedOperation!)
        userSignedInOperation?.start()
    }
    
    func usersignedIn(){
        NotificationService.instance.getNotificationCount()
        LocationService.sharedInstance.setupLocationManager()
        if let jid = AuthService.instance.userJID {
            print(jid)
            print(AuthService.instance.password)
            
            XMPPService.instance.connect(with: jid)
        }
    }
}
extension FeedController: FloatyDelegate{
    func emptyFloatySelected(_ floaty: Floaty) {
        if let vc = LiveDiscussion.storyBoardInstance() {
            if AuthStatus.instance.isGuest{
                print("Guest user")
                self.showGuestAlert()
            } else {
                print("Live btn pressed")
//                let joined = UserDefaults.standard.bool(forKey: "joinedStatus")
//                if  joined == true {
//                    XMPPService.instance.addMembers()
                    print("this is  sparta!!!!!!!!")
                    
//                } else {
//                    print("Xmpp still not connected")
//                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        
    }
}
