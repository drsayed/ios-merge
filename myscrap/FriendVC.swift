//
//  FriendVC.swift
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class FriendVC:BaseVC{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var horizontalBar: UIView!
    @IBOutlet weak var horizontalBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalBarLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutView: UIView!
   var currentSelectedTab = 0
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    var friendId : String = ""
    var isfromCardNoti : String = ""
    var notificationId : String = ""
    fileprivate var picture = [PictureURL]()
     var dropDown = DropDown()
    //var titleArray = [ "WALL", "PHOTOS" ,"ABOUT"]
    var titleArray = ["WALL","PHOTOS","ABOUT"]
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    fileprivate let service = ProfileService()
    fileprivate var profileItem:ProfileData?
    var likeCount : Int?
    //var delegate: MemberProfileCellDelegate?
    
                             
    private var data: ProfileService?{
        didSet{
            if let _ = data?.imageList{
                reloadCollectionViews()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        currentSelectedTab = 0
        service.delegate = self
        scrollView.delegate = self
        mainScrollView.delegate = self
       
        scrollViewHeight.constant = CGFloat(self.getSizeConstant())

        setupViews()
        horizontalBarLeftConstraint?.constant = 0
        horizontalBarWidthConstraint?.constant = self.view.frame.width / CGFloat(titleArray.count)

//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
//            swipeUp.direction = .up
//            self.view.addGestureRecognizer(swipeUp)
//
//            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
//            swipeDown.direction = .down
//            self.view.addGestureRecognizer(swipeDown)
    }
//    @objc func handleGesture(_ gesture: UISwipeGestureRecognizer)  {
//       if gesture.direction == .right {
//            print("Swipe Right")
//       }
//       else if gesture.direction == .left {
//            print("Swipe Left")
//       }
//       else if gesture.direction == .up {
//            print("Swipe Up")
//       }
//       else if gesture.direction == .down {
//            print("Swipe Down")
//       }
//    }
    func getSizeConstant() -> Int {
        if DeviceType.IS_IPHONE_5 {
            return 460;
        }
       else if DeviceType.IS_IPHONE_6_8 {
            return 558;
        }
       else if DeviceType.IS_IPHONE_6_8P {
            return 630;
        }
       else if DeviceType.IS_IPHONE_X {
            return 650;
        }
       else if DeviceType.IS_IPHONE_XR_SMAX {
            return 727;
        }
        return 558;
    }
    @objc func sendShowPhoneRequest()
    {
        dropDown.hide()
        print("Friend ID : \(friendId)")
                 let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                             spinner.mode = MBProgressHUDMode.indeterminate
                             spinner.label.text = "Requesting..."
        self.sendCardShowRequestToFriend(friendId: friendId,Type: "1")
    }
    @objc func sendShowAlreadyPhoneRequested()
    {
        dropDown.hide()
        self.showToast(message: "Your request already has been sent")

//        print("Friend ID : \(friendId)")
//                 let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
//                             spinner.mode = MBProgressHUDMode.indeterminate
//                             spinner.label.text = "Requesting..."
//        self.sendCardShowRequestToFriend(friendId: friendId,Type: "1")
    }

      func sendCardShowRequestToFriend(friendId: String, Type: String) {
          let service = APIService()
          service.endPoint =  Endpoints.Send_ShowRequest_Friend
          service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=\(friendId)&type=\(Type)"
          print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
          service.getDataWith { [weak self] (result) in
              switch result{
              case .Success(let dict):
                         if let error = dict["error"] as? Bool{
                      if !error{
                            DispatchQueue.main.async {
                              MBProgressHUD.hide(for: (self?.view)!, animated: true)
                                self?.showToast(message: "Request has been sent")
                                self?.getProfile()
                          }
                           
                     //     delegate?.DidReceiveStories(item: items)
                      } else {
                            DispatchQueue.main.async {
                                  MBProgressHUD.hide(for: (self?.view)!, animated: true)
                          self?.showToast(message: dict["status"] as? String ?? "Error in sending request")
                          }
                        //  delegate?.DidReceiveError(error: "Received Error in JSON Result...!")
                      }
                  }
              case .Error(let error):
                    DispatchQueue.main.async {
                          MBProgressHUD.hide(for: (self?.view)!, animated: true)
                  self?.showToast(message: error)
                  }
              }
          }
      }
    @objc private func handleRefresh(_ sender: UIRefreshControl){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        getProfile()
    }
    
    //MARK:- Setup Views
    private func setupViews(){
        //collectionView.register(FriendProfileCell.Nib, forCellWithReuseIdentifier: FriendProfileCell.identifier)
        collectionView.register(MemberProfileCell.Nib, forCellWithReuseIdentifier: MemberProfileCell.identifier)
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        collectionView.register(NewsBarCell.self)
        //collectionView.register(UserProfileCell.Nib, forCellWithReuseIdentifier: UserProfileCell.identifier)
        //collectionView.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        //collectionView.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        //collectionView.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if currentSelectedTab == 0 {
            NotificationCenter.default.post(name: Notification.Name("PlayUserCurrentVideo"), object: nil)
        }
        else
        {
            NotificationCenter.default.post(name: Notification.Name("PauseAllProfileVideos"), object: nil)

        }

        
        self.navigationController?.navigationBar.tintColor = .white
       // self.navigationItem.title = ""
        //self.navigationItem.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""

       // self.navigationItem.rightBarButtonItem!.tintColor = .white
        self.activityIndicator.startAnimating()
        getProfile()
        if isfromCardNoti == "1" {
            
            let Device = UIDevice.current
            let iosVersion = NSString(string: Device.systemVersion).doubleValue

            let iOS14 = iosVersion >= 14
            if iOS14 {
                
                DispatchQueue.main.async {
                    let xOffset = self.scrollView.frame.width * CGFloat(2)
                    let point = CGPoint(x: xOffset, y: 0)
                    self.scrollView.setContentOffset(point, animated: true)
                }
            //  self.collectionPage.reloadData()
            }
            else
            {
                DispatchQueue.main.async {
                    let xOffset = self.scrollView.frame.width * CGFloat(2)
                    let point = CGPoint(x: xOffset, y: 0)
                    self.scrollView.setContentOffset(point, animated: true)
                
                  //  self.collectionView.scrollToItem(at:IndexPath(item: 2, section: 1), at: .left, animated: false)
              // self.collectionPage.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        //            self.collectionPage.setNeedsLayout()
            }
             // self.collectionPage.reloadData()
            }
            
            
            
            
         
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("PauseAllProfileVideos"), object: nil)

    }
    private func getProfile() {
        var notId = ""
        if notificationId != ""{
            notId = "&notId=\(notificationId)"
        }
        service.getMainPage(friendId: friendId)
        //service.getFriendProfile(friendId: friendId, notId: notId)
        
    }
    
    private func reloadCollectionViews(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        self.collectionView.reloadData()
    }

    private func handleFollowUser() {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let profile = profileItem  else { return }
                                  
            if profile.followersCount != 0 {
                profile.followersCount = profile.followersCount + 1
            }
            
            let member = MemmberModel()
            let indexPath = IndexPath(item: 0, section: 0)
            print("Friend ID in friend VC: \(profile.memUserId)")
            if profile.followStatus == true { // UnFollow
//                member.followUser(friendId: profile.memUserId, action: "")
            } else {
                profile.followStatusType = 2
                member.sendFollowRequest(friendId: profile.memUserId)
             
                let message = "Started Following" //"Successfully started following"
                showToast(message: message)
            }
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    private func handleUnFollowUser() {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let profile = profileItem  else { return }
                                  
            if profile.followersCount != 0 {
                profile.followersCount = profile.followersCount - 1
            }
            
            let member = MemmberModel()
            let indexPath = IndexPath(item: 0, section: 0)
            print("Friend ID in friend VC: \(profile.memUserId)")
 
                profile.followStatusType = 0
                member.sendUnFollowRequest(friendId: profile.memUserId)
             
                let message = "UnFollow Request has been Sent" //"Successfully started following"
              //  showToast(message: message)
            
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    private func handleFavourite(){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let profile = profileItem  else { return }
            profile.isFav = !profile.isFav
            let member = MemmberModel()
            let indexPath = IndexPath(item: 0, section: 0)
            print("Friend ID in friend VC: \(profile.memUserId)")
            if profile.isFav == true {
                member.clickFav(friendId: profile.memUserId, action: "fav")
            } else {
                member.clickFav(friendId: profile.memUserId, action: "unfav")
            }
            //member.postFavourite(friendId: profile.memUserId)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    private func handleLike(){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let profile = profileItem  else { return }
            profile.isLike = !profile.isLike
            
            if self.profileItem!.isLike{
                self.profileItem!.likes += 1
            } else {
                self.profileItem!.likes -= 1
            }
            
            let member = MemmberModel()
            //let indexPath = IndexPath(item: 0, section: 0)
            print("Friend ID in friend VC: \(profile.memUserId)")
            
            if profile.isLike == true {
                member.clickLike(friendId: profile.memUserId, action: "like")
            } else {
                member.clickLike(friendId: profile.memUserId, action: "dislike")
            }
            
        }
    }
    
    private func goToCompanyVC(){
        guard let profile = profileItem else { return }
//        if let vc = CompanyProfileVC.storyBoardInstance(){
//            print("Company neha ID : \(profile.companyId)")
//            vc.companyId = profile.companyId
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
   /*     if  let vc = CompanyDetailVC.storyBoardInstance() {
            vc.title = profile.companyName
            vc.companyId = profile.companyId
            
            UserDefaults.standard.set(vc.title, forKey: "companyName")
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        */
        if  let vc = CompanyHeaderModuleVC.storyBoardInstance() {
            vc.title = profile.companyName
            vc.companyId = profile.companyId
            UserDefaults.standard.set(vc.title, forKey: "companyName")
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    static func heightForImageCell(item: FeedItem , width: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 496
        let bottomSpacing: CGFloat = 0
        let bottomContentHeight: CGFloat = width
        //let likeHeight : CGFloat = 35
        //let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + bottomContentHeight
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    
    /*private func fetchData(){
        let service = ProfileService()
        print("My friend : \(friendId)")
        if friendId != "" {
            
            service.viewListing(with: friendId) { (result) in
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.stopAnimating()
                }
                switch result{
                case .success(let data):
                    self.data = data
                    print("Grid Data : \(data)")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }*/
    
}

extension FriendVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
        let num = CGFloat(titleArray.count)
        horizontalBarLeftConstraint?.constant = self.scrollView.contentOffset.x / num
//        let index = 0
//        let indexPath = IndexPath(item: Int(index), section: 1)
//        let cell:NewsBarCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
//        if indexPath.row == 0 {
//            cell.label.textColor = UIColor.BLACK_ALPHA
//        }
        print(self.scrollView.contentOffset)
        }
        else if scrollView == self.mainScrollView
        {
            let screenRect = UIScreen.main.bounds
            let screenWidth = screenRect.size.width
            let screenHeight = screenRect.size.height
            
            if scrollView.contentOffset.y < collectionView.frame.size.height-100 {
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

            }
          
          
            if scrollView.contentOffset.y >= (self.collectionView.frame.size.height -  (40 + 12)) {
                    NotificationCenter.default.post(name: Notification.Name("EnableScroll"), object: nil)
                }
            else
                {
                    NotificationCenter.default.post(name: Notification.Name("DisableScroll"), object: nil)
                }
                // Dragging up
            
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 1)
        let cell:NewsBarCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        if indexPath.item != 0 {
            NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
        }
        currentSelectedTab = indexPath.item
//        else
//        {
//            NotificationCenter.default.post(name: Notification.Name("PlayVideoFromTab"), object: nil)
//
//        }
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

extension FriendVC : ProfileServiceDelegate{
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            print("error")
            self.collectionView.reloadData()
        }
    }
    
    func DidReceiveProfileData(item: ProfileData) {
        
        DispatchQueue.main.sync {
            
            self.profileItem = item
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            self.collectionView.reloadData()
            //self.stopRefreshing()
        }
    }
    
    func DidReceiveFeedItems(items: [FeedV2Item],pictureItems: [PictureURL]) {
        /*DispatchQueue.main.async {
            
            self.picture = pictureItems
            print("Now on picture \(self.picture)")
            self.collectionView.reloadData()
            //self.stopRefreshing()
        }*/
    }
    
    private func stopRefreshing(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
    }
}

extension FriendVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("index path \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            collectionView.layer.masksToBounds = false
            collectionView.layer.shadowOpacity = 0.5
            collectionView.layer.shadowRadius = 5.0
            collectionView.layer.shadowOffset = CGSize.zero
            collectionView.layer.shadowColor = UIColor.darkGray.cgColor
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberProfileCell.identifier, for: indexPath) as!
            MemberProfileCell
            print("Data grid : \(service.imageList)")
            cell.configure(with: service)
            //cell.sliderView.delegate = self
            view.layoutIfNeeded()
            if let item = profileItem {
                cell.configCell(item: item)
                cell.delegate = self      //For not showing black screen while tapping profile photo this line commented by maha
                stopRefreshing()
                
                /*if profileItem != nil && !picture.isEmpty {
                    let vc = PhotosVC()
                    print("Profile item : \(item), Picture : \(picture)")
                    vc.configPictureURL(profileItem: item, dataSource: picture)
                    
                    //vc.collectionView.reloadData()
                }*/
                
            }
            return cell
        } else {
            
            let cell: NewsBarCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
            cell.isHidden = true
            horizontalBar.isHidden = true
            if profileItem != nil {
                cell.isHidden = false
                horizontalBar.isHidden = false
            }
            
            cell.backgroundColor =  UIColor.black.withAlphaComponent(0.1)
            
            
            /*if indexPath.row == 0 {
                cell.label.textColor = UIColor.GREEN_PRIMARY
                cell.label.isHighlighted = true
            }*/
            cell.label.font = UIFont(name: "HelveticaNeue-Medium", size: 17)!
            cell.label.text = titleArray[indexPath.item]
            return cell
            /*let data  = feedItems[indexPath.item]
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
             default:
             return UICollectionViewCell()
             }*/
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            guard let _ = profileItem else { return 0}
            return 1
        } else {
            return titleArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.textLbl.text = "No Social Activity"
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let xOffset = self.scrollView.frame.width * CGFloat(indexPath.item)
            let point = CGPoint(x: xOffset, y: 0)
            if indexPath.item != 0 {
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
            }
            currentSelectedTab = indexPath.item
//            else
//            {
//                NotificationCenter.default.post(name: Notification.Name("PlayVideoFromFriedsTab"), object: nil)
 //           }
            self.scrollView.setContentOffset(point, animated: true)
        }
    }
    
    func scrollToNextCell(){
        
        //get cell size
        let cellSize = view.frame.size
        
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset
        
        if collectionView.contentSize.width <= collectionView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collectionView.scrollRectToVisible(r, animated: true)
            
        } else {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collectionView.scrollRectToVisible(r, animated: true);
        }
        
    }
    
    func presentGallery(photos: [MarketPhotoViewable], initialPhoto: MarketPhotoViewable){
        
        let gallery = MarketPhotosController(photos: photos, initialPhoto: initialPhoto, referenceView: nil)
        self.present(gallery, animated: true, completion: nil)
    }
    
}

extension FriendVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let cell: MemberProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberProfileCell.identifier, for: indexPath) as! MemberProfileCell
            let screenRect = UIScreen.main.bounds
            let screenWidth = screenRect.size.width
            let screenHeight = screenRect.size.height
            print("Member's Profile cell height : \(view.frame.height)")
            
            return CGSize(width: view.frame.width, height: 600)
            
        } else {
            let num = CGFloat(titleArray.count)
            print("Aboooout width : \(collectionView.bounds.width / num)")
            return CGSize(width: collectionView.bounds.width / num, height: 40)
            
         /*let item = feedItems[indexPath.item]
         let width = view.frame.width
         switch item.cellType{
         case .feedImageCell:
         let height = FeedsHeight.heightForImageCell(item: item, width: width)
         return CGSize(width: width, height: height)
         case .feedImageTextCell:
         let height = FeedsHeight.heightForImageTextCell(item: item, width: width, labelWidth: width - 16)
         return CGSize(width: width, height: height)
         default:
         let height = FeedsHeight.heightforFeedTextCell(item: item , labelWidth: width - 16)
         return CGSize(width: width , height: height)
         }*/
            
         }
        
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
     if section == 1 && isInitiallyLoaded == true && feedItems.count == 0 {
     return CGSize(width: self.view.frame.width, height: view.frame.height - 300)
     }
     return CGSize.zero
     }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FriendVC: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> FriendVC?{
        return UIStoryboard(name: StoryBoard.PROFILE, bundle: nil).instantiateViewController(withIdentifier: FriendVC.id) as? FriendVC
    }
}

extension FriendVC: FriendControllerDelegate{
    /*var feedCollectionView: UICollectionView {
        return collectionView
    }
     
    var feedsDataSource: [FeedItem] {
        get {
            return feedItems
        }
        set {
            feedItems = newValue
        }
    }*/
}

extension FriendVC: MSSliderDelegate {
    
    func didSelect(photo: Images, in photos: [Images]) {
        if photos.count > 0 {
            let vc = MarketPhotosController()
            vc.photo = photo
            presentGallery(photos: photos, initialPhoto: photo)
        }
    }
}

extension FriendVC: MemberProfileCellDelegate{
    
     func redirectToFollowersView(title: String, isFromFollowers: Bool) {
         let vc = LikesController()
         vc.title = title
         vc.followUserId = friendId
         vc.isFollower = isFromFollowers
         self.navigationController?.pushViewController(vc, animated: true)
     }

     func DidPressFollowers(cell: MemberProfileCell) {
         
         if self.profileItem?.followersCount != nil {
             if self.profileItem!.followersCount != 0 {
                 var followerStr = "Followers"
                 if self.profileItem!.followersCount == 1 {
                     followerStr = "Follower"
                 }
                 self.redirectToFollowersView(title: String(format: "%d %@", self.profileItem!.followersCount,followerStr), isFromFollowers: true)
             }
         }
     }
     
     func DidPressFollowings(cell: MemberProfileCell) {
                 
         if self.profileItem?.followingCount != nil {
             if self.profileItem!.followingCount != 0 {
                var followingsStr = "Following"
                if self.profileItem!.followersCount == 1 {
                    followingsStr = "Following"
                }
                 self.redirectToFollowersView(title: String(format: "%d %@", self.profileItem!.followingCount,followingsStr), isFromFollowers: false)
             }
         }
     }
     
     func DidPressFollowUser(cell: MemberProfileCell) { // Follow User Button
        guard let profile = profileItem  else { return }
        if profile.followStatusType == 2 {
            
            if let vc = UnFollowPopUpVC.storyBoardInstance(){
                vc.friendName = profile.memName
                vc.modalPresentationStyle = .overFullScreen
                vc.delegateUnfollow = self
                vc.indexValue = 0
                vc.friendID = friendId
                self.present(vc, animated: true, completion: nil)
            }
            
//            let alertConroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//            let changePassWordAction = UIAlertAction(title: "Unfollow \(profile.memName)", style: .destructive) {[weak self] _ in
//                self!.handleUnFollowUser()
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alertConroller.view.tintColor = UIColor.GREEN_PRIMARY
//           // alertConroller.addAction(editProfileAction)
//            alertConroller.addAction(changePassWordAction)
//            alertConroller.addAction(cancelAction)
//            present(alertConroller, animated: true, completion: nil)
//
            
            
        }
        else
        {
            self.handleFollowUser()
        }
      
     }
    
    func DidPressCompanyBtn(cell: BaseCell) {
        goToCompanyVC()
    }
    func DidPressLike(cell: MemberProfileCell) {
        DispatchQueue.main.async {
            print("Liked status : \(self.profileItem!.isLike)")
            
            
            self.handleLike()
            self.collectionView.reloadData()
        }
        
        
       /*if cell.likesLbl.text == " \((profileItem?.likes)!) Likes" {
            if cell.likeBtn.isLiked == true {
                cell.likesLbl.text = " \((profileItem?.likes)! - 1) Likes"
                //likeCount = (profileItem?.likes)! - 1
                UserDefaults.standard.set((profileItem?.likes)! - 1, forKey: "likeCount")
                //UserDefaults.standard.set(profileItem?.likes, forKey: "likeCount")
                cell.likeBtn.isLiked = !(profileItem?.isLike)!
                print("11111111111111")
            } else {
                cell.likesLbl.text = " \((profileItem?.likes)! + 1) Likes"
                UserDefaults.standard.set((profileItem?.likes)! + 1, forKey: "likeCount")
                //UserDefaults.standard.set(profileItem?.likes, forKey: "likeCount")
                likeCount = (profileItem?.likes)! + 1
                cell.likeBtn.isLiked = !(profileItem?.isLike)!
                print("222222222222")
            }
        }
        else {
            
            //var count:Int? = Int(cell.likesLbl.text!)
            //print("Like count in label : \(String(describing: count))")
        let count = UserDefaults.standard.integer(forKey: "likeCount")
            if cell.likeBtn.isLiked == true {
                
                let c = count - 1
                cell.likesLbl.text = " \(c) Likes"
                UserDefaults.standard.set(c, forKey: "likeCount")
                cell.likeBtn.isLiked = !(profileItem?.isLike)!
                print("Label 1 : \(String(describing: cell.likesLbl.text))")
            } else {
                let c = count + 1
                cell.likesLbl.text = " \(c) Likes"
                UserDefaults.standard.set(c, forKey: "likeCount")
                cell.likeBtn.isLiked = !(profileItem?.isLike)!
                print("Label 2 else: \(String(describing: cell.likesLbl.text))")
            }
        }*/
 
        
        
    }
    
    func DidPressChat(cell: BaseCell) {
        
        guard  let profile = profileItem , let jid = profile.jid else {
            print("No Jid")
            return
        }
        print("Friend chat id: ",jid, "Friend ID : \(friendId), Name : \(profile.memName)")
        var profilePic = ""
        if profile.profilePic == "" {
            profilePic = service.imageList![0]
        }
        else
        {
             profilePic = "https://myscrap.com/style/images/user_profile/\(profile.profilePic)"
        }
     
        
        performConversationVC(friendId: friendId, profileName: profile.memName, colorCode: profile.colorCode, profileImage: profilePic, jid: jid, listingId: "", listingTitle: "", listingType: "", listingImg: "")
    }
    
    func DidPressFavourite(cell: BaseCell) {
        handleFavourite()
    }
    
    func DidPressEmail(cell: BaseCell) {
        if !AuthStatus.instance.isGuest{
            if let item = profileItem, let email = item.memEmail{
                self.sendMail(with: email)
            }
        } else {
            self.showGuestAlert()
        }
        print("Email Tapped")
    }
    
    func sendMail(with email: String){
        print("Email is : \(email.isValidEmail())")
        if MFMailComposeViewController.canSendMail() , email.isValidEmail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setToRecipients([email])
            present(mail, animated: true, completion: nil)
        } else if !email.isValidEmail() {
            showToast(message: "User doesn't provide valid Email")
        } else {
            showToast(message: "Login your email with Mail App and try again!")
        }
    }
    
    func DidPressCall(cell: BaseCell,sender:UIButton) {
        
       dropDown = DropDown()
        dropDown.anchorView = sender
       dropDown.dataSource = ["Office: 45349543345", "Mobile:y5834589345 "]
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().cellHeight = 60
        dropDown.width = 200
        dropDown.dropDownWidth = 200

        dropDown.cellNib = UINib(nibName: "MobilePhoneDropDownCell", bundle: nil)

       
        var office = profileItem?.offPhone.replacingOccurrences(of: " ", with: "")
        var personal = profileItem?.personalPhone.replacingOccurrences(of: " ", with: "")
        
        //office = office?.replacingOccurrences(of: "+", with: "")
        //personal = personal?.replacingOccurrences(of: "+", with: "")
        
        
        print("Office number : \(office!), Personal number : \(personal!)")
        if office != "" && personal == "" {
            
        
         dropDown.dataSource = ["Office :\(office ?? "")"]
            dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
               guard let cell = cell as? MobilePhoneDropDownCell else { return }
                cell.sendButtonPresseed.isHidden = true
          
            }
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if office!.contains("+") {
                    
                    if let url = URL(string: "telprompt://" + office!) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("Office phone number is not valid : \(office!)")
                    }
                } else {
                    //office = "+" + office!
                    if let url = URL(string: "telprompt://" + office!) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("Office phone number is not valid : \(office!)")
                    }
                }
            }
            
            dropDown.show()
            

        } else if personal != "" && office == "" {
            
            if self.profileItem?.showPhone == "1"  {
                dropDown.dataSource = ["Mobile: "]

            }
            else
            {
                dropDown.dataSource = ["Mobile: \(personal ?? "")"]
            }
            

            dropDown.customCellConfiguration = { [self] (index: Index, item: String, cell: DropDownCell) -> Void in
               guard let cell = cell as? MobilePhoneDropDownCell else { return }
                if self.profileItem?.showPhone == "1"
                    {
                    cell.sendButtonPresseed.isHidden = false
                    if profileItem?.phonereq == "" {
                        cell.sendButtonPresseed.setTitle("Send Request", for: .normal)
                        cell.sendButtonPresseed.addTarget(self, action: #selector(self.sendShowPhoneRequest), for: .touchUpInside)
                    }
                    else
                    {
                        cell.sendButtonPresseed.setTitle("Requested", for: .normal)
                        cell.sendButtonPresseed.addTarget(self, action: #selector(self.sendShowAlreadyPhoneRequested), for: .touchUpInside)

                    }
                       
                  

                    }
                    else
                    {
                        cell.sendButtonPresseed.isHidden = true
                    }
               // Setup your custom UI components
               //cell.logoImageView.image = UIImage(named: "logo_\(index)")
            }
            dropDown.show()

                } else if office != "" && personal != "" {
                    
                    
                    if self.profileItem?.showPhone == "1"  {
                        dropDown.dataSource = ["Office: \(office ?? "")","Mobile:"]

                    }
                    else
                    {
                        dropDown.dataSource = ["Office: \(office ?? "")","Mobile: \(personal ?? "")"]
                    }
                    dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                       guard let cell = cell as? MobilePhoneDropDownCell else { return }
                        if index == 0 {
                            cell.sendButtonPresseed.isHidden = true
                        }
                       else if index == 1 {
                        if self.profileItem?.showPhone == "1"
                            {
                                cell.sendButtonPresseed.isHidden = false
                            cell.sendButtonPresseed.addTarget(self, action: #selector(self.sendShowPhoneRequest), for: .touchUpInside)
                            }
                            else
                            {
                                cell.sendButtonPresseed.isHidden = true
                            }
                           
                        }
                       // Setup your custom UI components
                       //cell.logoImageView.image = UIImage(named: "logo_\(index)")
                    }
                    dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                     
                         if index == 0 {
                            if self.profileItem?.showPhone == "1"
                                {
                            }
                            else
                            {
                                if personal!.contains("+"){
                                                   if let url = URL(string: "telprompt://\(personal!)") {
                                                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                   } else {
                                                       print("Office phone is not valid one:\(personal!)")
                                                   }
                                               } else {
                                                   //personal = "+" + personal!
                                                   if let url = URL(string: "telprompt://\(personal!)") {
                                                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                   } else {
                                                       print("Office phone is not valid one:\(personal!)")
                                                   }
                            }
                            }
                        }
                       else if index == 1 {
                            if office!.contains("+") {
                                
                                if let url = URL(string: "telprompt://" + office!) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    print("Office phone number is not valid : \(office!)")
                                }
                            } else {
                                //office = "+" + office!
                                if let url = URL(string: "telprompt://" + office!) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    print("Office phone number is not valid : \(office!)")
                                }
                            }
                        }
                        }
                       
                    dropDown.show()
                    
        }
        else if profileItem?.personalPhone == "" && profileItem?.offPhone == "" {
            /*let alert = UIAlertController(title: "NULL", message: "Oops! no phone number found", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)*/
            print("Phone numbers are not available")
        } else {
            print("call button can't able to click")
        }
    }
}



/*class FriendVC:BaseVC{
    
    
    var friendId : String = ""
    var notificationId : String = ""
    fileprivate var isInitiallyLoaded = false
    @IBOutlet weak var bottomView: UIView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var profileImgView: CircularImageView!
    @IBOutlet weak var profileView: CircleView!
    @IBOutlet weak var postLbl: UILabel!
    
    fileprivate let service = ProfileService()
    fileprivate let feedService = FeedModel()
    
    fileprivate var feedItems = [FeedItem]()
    fileprivate var profileItem:ProfileData?
    fileprivate var picture = [PictureURL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        bottomView.isHidden = true
        setupViews()
    }
    
    
    @objc private func handleRefresh(_ sender: UIRefreshControl){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        getProfile()
    }
    
    //MARK:- Setup Views
    private func setupViews(){
        //collectionView.register(FriendProfileCell.Nib, forCellWithReuseIdentifier: FriendProfileCell.identifier)
        collectionView.register(MemberProfileCell.Nib, forCellWithReuseIdentifier: MemberProfileCell.identifier)
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        //collectionView.register(UserProfileCell.Nib, forCellWithReuseIdentifier: UserProfileCell.identifier)
        //collectionView.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        //collectionView.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        //collectionView.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if feedItems.count == 0 {
            self.activityIndicator.startAnimating()
            getProfile()
        }
    }
    
    private func getProfile() {
        var notId = ""
        if notificationId != ""{
            notId = "&notId=\(notificationId)"
        }
        service.getFriendProfile(friendId: friendId, notId: notId)
    }
    //MARK :- CAMERA BTN CLICKED
    @IBAction func cameraClicked(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isGuest"){
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

extension FriendVC : ProfileServiceDelegate{
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            print("error")
            self.collectionView.reloadData()
        }
    }
    
    func DidReceiveProfileData(item: ProfileData) {
        DispatchQueue.main.sync {
            self.stopRefreshing()
            self.profileItem = item
            initialLbl.text = AuthService.instance.fullName.initials()
            profileView.backgroundColor = UIColor(hexString: AuthService.instance.colorCode)
            if let url = URL(string: AuthService.instance.profilePic) {
                profileImgView.sd_setImage(with: url, completed: nil)
            }
            postLbl.text = "Write Something to \(item.name)"
            self.bottomView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            self.collectionView.reloadData()
        }
    }
    
    func DidReceiveFeedItems(items: [FeedItem],pictureItems: [PictureURL]) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            self.feedItems = items
            self.picture = pictureItems
            self.collectionView.reloadData()
        }
    }
    
    private func stopRefreshing(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
    }
}


extension FriendVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberProfileCell.identifier, for: indexPath) as!
            MemberProfileCell
            if let item = profileItem{
                cell.configCell(item: item)
                //cell.delegate = self
            }
            return cell
        } else {
            
            /*let data  = feedItems[indexPath.item]
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
            default:
                return UICollectionViewCell()
            }*/
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            guard let _ = profileItem else { return 0}
            return 1
        } else {
            return feedItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.textLbl.text = "No Social Activity"
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        return cell
    }
    
}

extension FriendVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: view.frame.height)
            //return CGSize(width: view.frame.width, height: 278 + 35)
        } /*else {
            let item = feedItems[indexPath.item]
            let width = view.frame.width
            switch item.cellType{
            case .feedImageCell:
                let height = FeedsHeight.heightForImageCell(item: item, width: width)
                return CGSize(width: width, height: height)
            case .feedImageTextCell:
                let height = FeedsHeight.heightForImageTextCell(item: item, width: width, labelWidth: width - 16)
                return CGSize(width: width, height: height)
            default:
                let height = FeedsHeight.heightforFeedTextCell(item: item , labelWidth: width - 16)
                return CGSize(width: width , height: height)
            }
            
        }*/
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 && isInitiallyLoaded == true && feedItems.count == 0 {
            return CGSize(width: self.view.frame.width, height: view.frame.height - 300)
        }
        return CGSize.zero
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
extension FriendVC: ProfileCellDelegate{
    func DidPressPhotosBtn(cell: BaseCell) {
        if let vc = PhotosVC.storyBoardInstance(){
            vc.configPictureURL(profileItem: profileItem, dataSource: picture)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func DidPressCompanyBtn(cell: BaseCell) {
        goToCompanyVC()
    }
    
    func DidPressIntrestBtn(cell: BaseCell) {
        goToInterestVC()
    }
    
    func DidPressAboutBtn(cell: BaseCell) {
        goToAboutVC()
    }
    
    func DidPressChat(cell: BaseCell) {
        
        guard  let profile = profileItem , let jid = profile.jid else {
            print("No Jid")
            return
        }
        print("Friend chat id: ",jid)
        
        performConversationVC(friendId: friendId, profileName: profile.name, colorCode: profile.colorCode, profileImage: profile.profilePic, jid: jid)
    }
    
    func DidPressFavourite(cell: BaseCell) {
        handleFavourite()
    }
    
    
}








// Helper functions
extension FriendVC{
    
    //MARK:- COMPANY VC
    private func goToCompanyVC(){
        guard let profile = profileItem else { return }
        if let vc = CompanyProfileVC.storyBoardInstance(){
            vc.companyId = profile.companyId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- INTEREST VC
    private func goToInterestVC(){
        let vc = InterestsVC()
        if let interest = profileItem?.interest.sorted() , let roles = profileItem?.roles.sorted(){
            let obj = Interests()
            vc.commoditiesArray = obj.getUserCommodities(input: interest)
            vc.rolesArray = obj.getUserRoles(input: roles)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- ABOUTVC
    private func goToAboutVC(){
        guard let profile = profileItem else { return }
        let vc = AboutProfileController()
        vc.profileItem = profile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
    
    private func handleFavourite(){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let profile = profileItem  else { return }
            profile.isFavourite = !profile.isFavourite
            let member = MemmberModel()
            let indexPath = IndexPath(item: 0, section: 0)
            member.postFavourite(friendId: profile.userId)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
}

extension FriendVC {
    fileprivate func performDetailsController(obj: FeedItem){
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = obj.postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func performLikeVC(obj: FeedItem){
        
        let vc = LikesController()
        vc.title = "Likes"
        vc.id = obj.postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func toPostVC(){
        guard let profile = profileItem, let vc = EditPostVC.storyBoardReference() else { return }
            vc.friendId = friendId
            vc.title = "Post on \(profile.name) Profile."
            vc.didPost = { success in
                print("returned")
            }
            let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
            self.present(navBarOnModal, animated: true, completion: nil)
    }
    
    fileprivate func toCamera(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    fileprivate func gotoFriendView(friendId: String){
        performFriendView(friendId: friendId)
    }
}

extension FriendVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        dismiss(animated: false) {
            if let vc = EditPostVC.storyBoardReference() {
                let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                vc.friendId = self.friendId
                vc.postImage = chosenImage
                self.present(navBarOnModal, animated: true, completion: nil)
            }
        }
    }
    
    static func storyBoardInstance() -> FriendVC?{
        return UIStoryboard(name: StoryBoard.PROFILE, bundle: nil).instantiateViewController(withIdentifier: FriendVC.id) as? FriendVC
    }
}

extension FriendVC: FeedsDelegate, FriendControllerDelegate{
    var feedCollectionView: UICollectionView {
        return collectionView
    }
    
    var feedsDataSource: [FeedItem] {
        get {
            return feedItems
        }
        set {
            feedItems = newValue
        }
    }
}
*/
extension FriendVC: UnFollowDelegate{
    func UnFollowPressed(FriendID: String, AtIndex: Int) {
        self.handleUnFollowUser()
    }
   
   
}


