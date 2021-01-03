//
//  UserProfileVC.swift
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
class UserFeedsVC: BaseVC, FriendControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var profileImgView: CircularImageView!
    @IBOutlet weak var profileView: CircleView!
    
    var loadMore  = false
    var isRefreshing = false
    var visibleCellIndex = IndexPath()

    var task : URLSessionTask?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    fileprivate var isInitiallyLoaded = false
    
    var profileItem : ProfileData?
//    var dataSource = [FeedV2Item]()
    var dataSourceV2 = [FeedV2Item]()
    fileprivate var pictureItems = [PictureURL]()
    
    let service = ProfileService()
    
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
       // NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("VideoPlayedChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("SharedOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("SharedClosed"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("DeletedVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("PauseAllVideos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableScroll), name: Notification.Name("EnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableScroll), name: Notification.Name("DisableScroll"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("PauseAllProfileVideos"), object: nil)
        
        setupViews()
        service.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(refreshControl)
        collectionView.isScrollEnabled = false
    }
    @objc
    func enableScroll(){
        collectionView.isScrollEnabled = true
    }
    @objc func disableScroll(){
        collectionView.isScrollEnabled = false
    }
    @objc func pauseVisibleVideos()  {
        
        for videoParentCell in collectionView.visibleCells   {
            
                var indexPathNotVisible = collectionView!.indexPath(for: videoParentCell)
            
            if let videoParentwithoutTextCell = videoParentCell as? UserFeedVideoCell
            {
                for videoCell in videoParentwithoutTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? UserFeedVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            if let videoParentTextCell = videoParentCell as? UserFeedLandScapVideoCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            if let videoParentTextCell = videoParentCell as? UserFeedLandScapVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            }
        
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("PlayMyCurrentVideo"), object: nil)

        //if dataSource.count == 0 {
            self.activityIndicator.startAnimating()
            self.getProfile()
        //}
        
//        profileView.backgroundColor = UIColor(hexString: AuthService.instance.colorCode)
        
        //initialLbl.text = ""
        
//        if let url = URL(string: AuthService.instance.profilePic){
//            if AuthService.instance.profilePic != "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
//                profileImgView.sd_setImage(with: url, completed: nil)
//
//            } else {
//
//            }
//            //profileImgView.sd_setImage(with: url, completed: nil)
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pauseVisibleVideos()
      
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlayMyCurrentVideo"), object: nil)
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
        NotificationCenter.default.removeObserver(self, name: .videoDownloaded, object: nil)
        
//            if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplLandscVideoCell {
//                //cell.player.isMuted = true
//                //if videoCell.player.timeControlStatus == .playing {
//                    videoCell.player.isMuted = true
//                    if  videoCell.player.isMuted {
//                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                    } else {
//                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                    }
//                    videoCell.player.pause()
//                    videoCell.player.actionAtItemEnd = .pause
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                //}
//            }
//            if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplPortrVideoTextCell {
//                //cell.player.isMuted = true
//               //if videoCell.player.timeControlStatus == .playing {
//                    videoCell.player.isMuted = true
//                    if  videoCell.player.isMuted {
//                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                    } else {
//                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                    }
//                    videoCell.player.pause()
//                    videoCell.player.actionAtItemEnd = .pause
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                //}
//            }
//            if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplLandsVideoTextCell {
//                //cell.player.isMuted = true
//                //if videoCell.player.timeControlStatus == .playing {
//                    videoCell.player.isMuted = true
//                    if  videoCell.player.isMuted {
//                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                    } else {
//                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                    }
//                    videoCell.player.pause()
//                    videoCell.player.actionAtItemEnd = .pause
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                //}
//            }
//        }
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
    
    @objc func playingVideoDidEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            //Video time be set to 0
            
            /*-----------------------------------------------*/
            playerItem.seek(to: CMTime.zero) { (reachedEnd) in
                if reachedEnd {
                    print("Visible video started")
                }
            }
        }
    }
    
    @objc func pausedVideoDidEnd(notification: Notification) {
        
        if let player = notification.object as? AVPlayer {
            print("Visible video ended")
            player.pause()
            
            /*let playerItem = player.currentItem
            let currentItem = player.currentItem?.currentTime()
            playerItem!.seek(to: currentItem!) { (reachedPause) in
                if reachedPause {
                    print("Paused video started")
                    player.pause()
                }
            }*/
        }
    }
    
    //MARK:- Setup Views
    private func setupViews(){
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
//        collectionView.register(UserProfileCell.Nib, forCellWithReuseIdentifier: UserProfileCell.identifier)
        collectionView.register(MyProfileCollectionViewCell.Nib, forCellWithReuseIdentifier: MyProfileCollectionViewCell.identifier)
        
        collectionView.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        collectionView.register(UserFeedTextCell.Nib, forCellWithReuseIdentifier: UserFeedTextCell.identifier)
        collectionView.register(UserFeedImageCell.Nib, forCellWithReuseIdentifier: UserFeedImageCell.identifier)
        collectionView.register(UserFeedImageTextCell.Nib, forCellWithReuseIdentifier: UserFeedImageTextCell.identifier)
        collectionView.register(UserFeedVideoCell.Nib, forCellWithReuseIdentifier: UserFeedVideoCell.identifier)
collectionView.register(UserFeedVideoTextCell.Nib, forCellWithReuseIdentifier: UserFeedVideoTextCell.identifier)
        collectionView.register(UserFeedLandScapVideoCell.Nib, forCellWithReuseIdentifier: UserFeedLandScapVideoCell.identifier)
        collectionView.register(UserFeedLandScapVideoTextCell.Nib, forCellWithReuseIdentifier: UserFeedLandScapVideoTextCell.identifier)


    }
    
    @objc func handleRefresh(){
        //if activityIndicator.isAnimating { activityIndicator.stopAnimating() }
        //isRefreshing = true
        self.getProfile()
    }
    
    func getProfile(){
        //service.getUserProfile(pageLoad: "\(dataSource.count)")
        service.getUserProfile(pageLoad: "0")
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
    
    @IBAction func settingsClicked(_ sender: UIButton){
        let alertConroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editProfileAction = UIAlertAction(title: "Edit Profile", style: .default) { [weak self] _ in
            self?.performEditProfile()
        }
        let changePassWordAction = UIAlertAction(title: "Change Password", style: .default) {[weak self] _ in
            self?.performChangePassword()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertConroller.view.tintColor = UIColor.GREEN_PRIMARY
        
     //   alertConroller.addAction(editProfileAction)
        alertConroller.addAction(changePassWordAction)
        alertConroller.addAction(cancelAction)
        present(alertConroller, animated: true, completion: nil)
        
    }
    private func performEditProfile(){
        if let vc = EditProfileController.storyBoardInstance(){
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func performChangePassword(){
        if let vc = ChangePasswordVC.storyBoardInstance(){
            self.navigationController?.pushViewController(vc, animated: true)
            //let nav = UINavigationController(rootViewController: vc)
            //present(nav, animated: true, completion: nil)
        }
    }
    
}

extension UserFeedsVC: EditProfileDelegate{
    func didUpdateProfile() {
        self.profileItem = nil
        self.dataSourceV2 = [FeedV2Item]()
        self.loadMore = true
        collectionView.reloadData()
        self.isInitiallyLoaded = false
        self.activityIndicator.startAnimating()
        self.getProfile()
    }
}


extension UserFeedsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        if let portrateCell = cell as? UserFeedVideoCell {
         
            for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
              
            //cell.player.isMuted = true
            //if videoCell.player.timeControlStatus == .playing {
                videoCell.playerView.isMuted = true
                if  videoCell.player.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoCell.pause()
//                videoCell.player.actionAtItemEnd = .pause
//                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
          }
        }
        else if let portrateCell = cell as? UserFeedVideoTextCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                  
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                    videoCell.playerView.isMuted = true
                    if  videoCell.player.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    videoCell.pause()
    //                videoCell.player.actionAtItemEnd = .pause
    //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                //}
            }
        }
        else if let portrateCell = cell as? UserFeedLandScapVideoCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                  
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                    videoCell.playerView.isMuted = true
                    if  videoCell.player.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    videoCell.pause()
    //                videoCell.player.actionAtItemEnd = .pause
    //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                //}
            }
        }
            else if let portrateCell = cell as? UserFeedLandScapVideoTextCell {
                 
                    for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                      
                    //cell.player.isMuted = true
                    //if videoCell.player.timeControlStatus == .playing {
                        videoCell.playerView.isMuted = true
                        if  videoCell.player.isMuted {
                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                        } else {
                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                        }
                        videoCell.pause()
        //                videoCell.player.actionAtItemEnd = .pause
        //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                    }
                }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            //let visibleCell = collectionView.dequeReusableCell(forIndexPath: indexPath) as?  FeedVideoTextCell
                //NotificationCenter.default.post(name:.videoCellPlay, object: nil)
                let muteImg = #imageLiteral(resourceName: "mute-60x60")
                let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
                let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                
                if let portrateCell = cell as? UserFeedVideoCell {
                 
                    for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                          
                        //cell.player.isMuted = true
                        //if videoCell.player.timeControlStatus == .playing {
                        var muteVideo : Bool = false
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
                      //  videoCell.resume()
                         
                        //}
                    }
                }
                else if let portrateCell = cell as? UserFeedVideoTextCell {
                     
                        for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                            
                            //cell.player.isMuted = true
                            //if videoCell.player.timeControlStatus == .playing {
                            var muteVideo : Bool = false

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
                           // videoCell.resume()
                            //}
                        }
                    }
                else if let portrateCell = cell as? UserFeedLandScapVideoCell {
                     
                        for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                            
                            //cell.player.isMuted = true
                            //if videoCell.player.timeControlStatus == .playing {
                            var muteVideo : Bool = false

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
                          //  videoCell.resume()
                            //}
                        }
                }
                else if let portrateCell = cell as? UserFeedLandScapVideoTextCell {
                     
                        for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                            
                            //cell.player.isMuted = true
                            //if videoCell.player.timeControlStatus == .playing {
                            var muteVideo : Bool = false

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
                          //  videoCell.resume()
                            //}
                        }
                }
            cell.layoutSubviews()
            cell.layoutIfNeeded()
     
            
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
            
            let data  = dataSourceV2[indexPath.item]
            switch data.userCellType{
            /*case .feedNewUserCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedNewUserCell.identifier, for: indexPath) as? FeedNewUserCell else { return UICollectionViewCell()}
                cell.delegate = self
                cell.item = data
                return cell*/
            case .userFeedTextCell:
             
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTextCell.identifier, for: indexPath) as? FeedTextCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                //cell.delegate = self
                cell.newItem = data
                cell.SetLikeCountButton()
                cell.reportBtn.isHidden = true
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                cell.reportStackView.isHidden = true

                return cell
                
//                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserFeedTextCell.identifier, for: indexPath) as? UserFeedTextCell else { return UICollectionViewCell()}
//                cell.updatedDelegate = self
//                cell.newItem = data
//                cell.SetLikeCountButton()
//                return cell
            case .userFeedImageCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserFeedImageCell.identifier, for: indexPath) as? UserFeedImageCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.refreshTable()
                cell.SetLikeCountButton()
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    for imageCell in cell.feedImages.visibleCells   {
                       let image = imageCell as! CompanyImageslCell
                        UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                        cell.dwnldBtn.isEnabled = true
                        }
                }
                return cell
            case .userFeedImageTextCell:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserFeedImageTextCell.identifier, for: indexPath) as! UserFeedImageTextCell
                cell.updatedDelegate = self
                cell.newItem = data
                 cell.refreshTable()
                cell.SetLikeCountButton()
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    for imageCell in cell.feedImages.visibleCells   {
                       let image = imageCell as! CompanyImageslCell
                        UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                        cell.dwnldBtn.isEnabled = true
                        }
                }
                return cell
                 case .feedPortrVideoCell:
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserFeedVideoCell.identifier, for: indexPath) as? UserFeedVideoCell else { return UICollectionViewCell()}
                              cell.updatedDelegate = self
                              cell.newItem = data
                    
                    cell.delegateVideoChange  =   self

                              cell.refreshTable()
                    cell.SetLikeCountButton()
  
                                cell.layoutIfNeeded()
                              return cell
            case .feedLandsVideoCell:
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserFeedLandScapVideoCell.identifier, for: indexPath) as? UserFeedLandScapVideoCell else { return UICollectionViewCell()}
                         cell.updatedDelegate = self
                         cell.newItem = data
                cell.delegateVideoChange  =   self
                         cell.refreshTable()
                cell.SetLikeCountButton()

                           cell.layoutIfNeeded()
                         return cell
                case .feedPortrVideoTextCell:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserFeedVideoTextCell.identifier, for: indexPath) as? UserFeedVideoTextCell else { return UICollectionViewCell()}
                    cell.updatedDelegate = self
                    cell.newItem = data
                    cell.delegateVideoChange  =   self

                    cell.refreshTable()
                    cell.SetLikeCountButton()
                      cell.layoutIfNeeded()
                    return cell
            case .feedLandsVideoTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserFeedLandScapVideoTextCell.identifier, for: indexPath) as? UserFeedLandScapVideoTextCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.delegateVideoChange  =   self

                cell.refreshTable()
                cell.SetLikeCountButton()
                  cell.layoutIfNeeded()
                return cell
            default:
                return UICollectionViewCell()
            }
            
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
            print("Datasource count in my own profile : \(dataSourceV2.count)")
            return dataSourceV2.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.textLbl.text = "No Social Activity"
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        return cell
    }
    func pauseAllVideos(indexPath : IndexPath)  {
        
        for videoParentCell in collectionView.visibleCells   {
            
                var indexPathNotVisible = collectionView!.indexPath(for: videoParentCell)
            if indexPath != indexPathNotVisible {
            
            if let videoParentwithoutTextCell = videoParentCell as? UserFeedVideoCell
            {
                for videoCell in videoParentwithoutTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? UserFeedVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
                if let videoParentTextCell = videoParentCell as? UserFeedLandScapVideoCell
                {
                    for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                        print("You can stop play the video from here")
                            videoCell.pause()

                    }
                }
                if let videoParentTextCell = videoParentCell as? UserFeedLandScapVideoTextCell
                {
                    for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                        print("You can stop play the video from here")
                            videoCell.pause()

                    }
                }

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
                self.pauseAllVideos(indexPath: indexPath)
                if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? UserFeedVideoCell
                 {
                    let data  = dataSourceV2[indexPath.item]

                    for videoCell in collectionViewCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    

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
                            let visibleRect = CGRect(origin: collectionViewCell.videosCollection.contentOffset, size: collectionViewCell.videosCollection.bounds.size)
                            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                            let visibleIndexPath = collectionViewCell.videosCollection.indexPathForItem(at: visiblePoint)
                           
                            videoCell.resume()
                           
                        }
                          //  videoCell.resume()

                    }
                    self.pauseAllVideos(indexPath: indexPath)
                    collectionViewCell.UpdateLable()

                 }
               else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? UserFeedVideoTextCell
               {
                let data  = dataSourceV2[indexPath.item]
                  for videoCell in collectionViewCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                  
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
                        videoCell.resume()
                       
                    }

                  }
                self.pauseAllVideos(indexPath: indexPath)
                collectionViewCell.UpdateLable()

               }
               else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? UserFeedLandScapVideoCell
               {
                let data  = dataSourceV2[indexPath.item]
                  for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
                  
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
                        videoCell.resume()
                       
                    }

                  }
                self.pauseAllVideos(indexPath: indexPath)
                collectionViewCell.UpdateLable()

               }
               else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? UserFeedLandScapVideoTextCell
               {
                let data  = dataSourceV2[indexPath.item]
                  for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
                  
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
                        videoCell.resume()
                       
                    }

                  }
                self.pauseAllVideos(indexPath: indexPath)
                collectionViewCell.UpdateLable()

               }
        }
        else
             {
                self.pauseVisibleVideos()
             }
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.scrollViewDidEndScrolling()
//
//    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
//        if !dataSourceV2.isEmpty{
//            let currentOffset = scrollView.contentOffset.y
//            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//            let deltaOffset = maximumOffset - currentOffset
//            if deltaOffset <= 0 {
//                if loadMore{
//                    loadMore = false
//                    service.getUserProfile(pageLoad: "\(dataSourceV2.count)")
//                }
//            }
//        }
//
        
        
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            //let screenSize = UIScreen.main.bounds
            if scrollView.contentOffset.y <= 2 {
                self.collectionView.isScrollEnabled = false
            }
        else
            {
                self.collectionView.isScrollEnabled = true
            }
            
        }else{
           
            // Dragging up
        }
        self.scrollViewDidEndScrolling()
      
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//
//
//
//        var visibleRect = CGRect()
//                visibleRect.origin = scrollView.contentOffset
//                visibleRect.size = scrollView.bounds.size
//
//
//                let muteImg = #imageLiteral(resourceName: "mute-60x60")
//                let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//
//                let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
//                let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//                //print("minY : \(visibleRect.minY) \nmidY : \(visibleRect.midY) \nmaxY : \(visibleRect.maxY)")
//
//                let cgPoint = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.maxY)
//
//
//                guard let indexPath = collectionView.indexPathForItem(at: cgPoint) else { return}
//                //let storedIndexPath = self.visibleCellIndex
//                let visibleCellIndexPath = self.collectionView.indexPathsForVisibleItems
//                var centerIndexPath = IndexPath(row: NSNotFound, section: NSNotFound)
//                //let centerPoint   = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.minY)
//                //guard let centerIndexPath: IndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
//                for allIndex in visibleCellIndexPath {
//                    if visibleCellIndexPath.count == 0 {
//                        centerIndexPath = IndexPath(row: dataSourceV2.count - 1, section: 1)
//                    } else {
//                        centerIndexPath = allIndex
//                    }
//                    print("Visible index path :\(centerIndexPath)")
//                }
//
//
//                print("Get Center IndexPath : \(centerIndexPath) \nCurrent IndexPath :\(indexPath)")
//        if centerIndexPath < indexPath {
//            //I can get the previous cell now
//
//            if let portrateCell = self.collectionView.cellForItem(at: centerIndexPath) as? UserFeedVideoCell {
//                //previous cell is video
//                var cellVisibRect = portrateCell.frame
//                cellVisibRect.size = portrateCell.bounds.size
//
//                let cellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Lands Text: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 300
//
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                let screenSize = UIScreen.main.bounds
//                let screenHeight = screenSize.height
//                for videoCell in portrateCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
//
//
//                if y <= 300 || y > maxY { //For landscape ==> 3
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = true
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//
//                        videoCell.player.pause()
//                    }
//                } else if y > 300 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
////                        let timeScale = CMTimeScale(NSEC_PER_SEC)
////                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                         videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                         let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                         let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                         let secs = Int(duration - currentTime)
//                         videoCell.playBackTimeLbl.isHidden = false
//                         videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                         /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                         videoCell.playBackTimeLbl.isHidden = true
//                         if let timeObserverToken = videoCell.timeObserverToken {
//                         videoCell.player.removeTimeObserver(timeObserverToken)
//                         videoCell.timeObserverToken = nil
//                         }
//                         }*/
//                         }
//                         }*/
//
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            }
//          else if let portrateCell = self.collectionView.cellForItem(at: centerIndexPath) as? UserFeedVideoTextCell {
//                //previous cell is video
//                var cellVisibRect = portrateCell.frame
//                cellVisibRect.size = portrateCell.bounds.size
//
//                let cellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Lands Text: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 300
//
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                let screenSize = UIScreen.main.bounds
//                let screenHeight = screenSize.height
//                for videoCell in portrateCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
//
//
//                if y <= 300 || y > maxY { //For landscape ==> 3
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = true
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//
//                        videoCell.player.pause()
//                    }
//                } else if y > 300 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
////                        let timeScale = CMTimeScale(NSEC_PER_SEC)
////                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                         videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                         let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                         let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                         let secs = Int(duration - currentTime)
//                         videoCell.playBackTimeLbl.isHidden = false
//                         videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                         /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                         videoCell.playBackTimeLbl.isHidden = true
//                         if let timeObserverToken = videoCell.timeObserverToken {
//                         videoCell.player.removeTimeObserver(timeObserverToken)
//                         videoCell.timeObserverToken = nil
//                         }
//                         }*/
//                         }
//                         }*/
//
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            }
//        }
//        else {
//            if let portrateCell = self.collectionView.cellForItem(at: centerIndexPath) as? UserFeedVideoCell {
//                //previous cell is video
//                var cellVisibRect = portrateCell.frame
//                cellVisibRect.size = portrateCell.bounds.size
//
//                let cellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Lands Text: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 150
//
//                for videoCell in portrateCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
//
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                if y <= 800 { //For landscape ==> 3
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//                        videoCell.player.isMuted = true
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                        videoCell.player.pause()
//
//                    }
//                } else if y > 800 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
////                        let timeScale = CMTimeScale(NSEC_PER_SEC)
////                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                         videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                         let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                         let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                         let secs = Int(duration - currentTime)
//                         videoCell.playBackTimeLbl.isHidden = false
//                         videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                         /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                         videoCell.playBackTimeLbl.isHidden = true
//                         if let timeObserverToken = videoCell.timeObserverToken {
//                         videoCell.player.removeTimeObserver(timeObserverToken)
//                         videoCell.timeObserverToken = nil
//                         }
//                         }*/
//                         }
//                         }*/
//
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            }
//            else if let portrateCell = self.collectionView.cellForItem(at: centerIndexPath) as? UserFeedVideoTextCell {
//                //previous cell is video
//                var cellVisibRect = portrateCell.frame
//                cellVisibRect.size = portrateCell.bounds.size
//
//                let cellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Portrait text video: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 150
//
//                for videoCell in portrateCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                if y >= 1150 { //<=
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
////                        if muteValue == "1"
////                        {
////                            videoCell.player.isMuted = false
////                        }
////                         else
////                        {
////                            videoCell.player.isMuted = true
////                        }
//                        videoCell.player.isMuted = true
//
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                        videoCell.player.pause()
//
//                    }
//                } else if y < 1150 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
////                        let timeScale = CMTimeScale(NSEC_PER_SEC)
////                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                         videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                         let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                         let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//                         print("Duration : \(duration)")
//                         let secs = Int(duration - currentTime)
//                         videoCell.playBackTimeLbl.isHidden = false
//                         videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                         /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                         videoCell.playBackTimeLbl.isHidden = true
//                         if let timeObserverToken = videoCell.timeObserverToken {
//                         videoCell.player.removeTimeObserver(timeObserverToken)
//                         videoCell.timeObserverToken = nil
//                         }
//                         }*/
//                         }
//                         }*/
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            }
//        }
//
//
//        /*
//
//        //While scrolling the collection this function will triggered
//
//        var visibleRect = CGRect()
//        visibleRect.origin = scrollView.contentOffset
//        visibleRect.size = scrollView.bounds.size
//
//
//        let muteImg = #imageLiteral(resourceName: "mute-60x60")
//        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//
//        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
//        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        //print("minY : \(visibleRect.minY) \nmidY : \(visibleRect.midY) \nmaxY : \(visibleRect.maxY)")
//
//        let cgPoint = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.maxY)
//
//
//        guard let indexPath = collectionView.indexPathForItem(at: cgPoint) else { return}
//        //let storedIndexPath = self.visibleCellIndex
//        let visibleCellIndexPath = self.collectionView.indexPathsForVisibleItems
//        var centerIndexPath = IndexPath(row: NSNotFound, section: NSNotFound)
//        //let centerPoint   = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.minY)
//        //guard let centerIndexPath: IndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
//        for allIndex in visibleCellIndexPath {
//            if visibleCellIndexPath.count == 0 {
//                centerIndexPath = IndexPath(row: feedDatasource.count - 1, section: 1)
//            } else {
//                centerIndexPath = allIndex
//            }
//            print("Visible index path :\(centerIndexPath)")
//        }
//
//
//        print("Get Center IndexPath : \(centerIndexPath) \nCurrent IndexPath :\(indexPath)")
//        if centerIndexPath < indexPath {
//            //I can get the previous cell now
//            if let videoCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplLandsVideoTextCell {
//                //previous cell is video
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Lands Text: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 150
//
//
////                if y >= -150 &&  y <= 150{
////                    print("You can stop playing the video from here")
////                }
//                if y <= 150 { //<=
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                        videoCell.player.pause()
//
//                    }
//                } else if y > 150 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//
//
//                            videoCell.player.actionAtItemEnd = .none
//                            NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            else if let videoCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplPortrVideoTextCell {
//                            //previous cell is video
//                            var cellVisibRect = videoCell.frame
//                            cellVisibRect.size = videoCell.bounds.size
//
//                            let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY) //maxY
//                            let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                            let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                            let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                            print("Previous Y of Cell is Portrait text video: \(rectCell.y)")
//                            //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                            let y = rectCell.y
//                            let maxY = y + 150
//
//
//            //                if y >= -150 &&  y <= 150{
//            //                    print("You can stop playing the video from here")
//            //                }
//                            if y <= 150 { //<=
//                                print("You can stop play the video from here")
//                                if videoCell.player.timeControlStatus == .playing {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    videoCell.player.actionAtItemEnd = .pause
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                                    videoCell.player.pause()
//
//                                }
//                            } else if y > 150 {
//                                print("Reverse scroll you can play")
//                                if videoCell.player.timeControlStatus == .paused {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    let timeScale = CMTimeScale(NSEC_PER_SEC)
//                                    let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                                    /*if videoCell.player.currentItem?.status == .readyToPlay {
//                                        videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                            let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                            let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//                                            print("Duration : \(duration)")
//                                            let secs = Int(duration - currentTime)
//                                            videoCell.playBackTimeLbl.isHidden = false
//                                            videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                                videoCell.playBackTimeLbl.isHidden = true
//                                                if let timeObserverToken = videoCell.timeObserverToken {
//                                                    videoCell.player.removeTimeObserver(timeObserverToken)
//                                                    videoCell.timeObserverToken = nil
//                                                }
//                                            }*/
//                                        }
//                                    }*/
//
//
//
//                                    videoCell.player.actionAtItemEnd = .none
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                                    videoCell.player.play()
//                                }
//                            }
//                        }
//            else if let videoCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplLandscVideoCell {
//                            //previous cell is video
//                            var cellVisibRect = videoCell.frame
//                            cellVisibRect.size = videoCell.bounds.size
//
//                            let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY) //maxY
//                            let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                            let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                            let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                            print("Previous Y of Cell is Landscape video: \(rectCell.y)")
//                            //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                            let y = rectCell.y
//                            let maxY = y + 150
//
//
//            //                if y >= -150 &&  y <= 150{
//            //                    print("You can stop playing the video from here")
//            //                }
//                            if y <= 150 { //<=
//                                print("You can stop play the video from here")
//                                if videoCell.player.timeControlStatus == .playing {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    videoCell.player.actionAtItemEnd = .pause
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                                    videoCell.player.pause()
//
//                                }
//                            } else if y > 150 {
//                                print("Reverse scroll you can play")
//                                if videoCell.player.timeControlStatus == .paused {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    let timeScale = CMTimeScale(NSEC_PER_SEC)
//                                    let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                                    /*if videoCell.player.currentItem?.status == .readyToPlay {
//                                        videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                            let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                            let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//                                            print("Duration : \(duration)")
//                                            let secs = Int(duration - currentTime)
//                                            videoCell.playBackTimeLbl.isHidden = false
//                                            videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                                videoCell.playBackTimeLbl.isHidden = true
//                                                if let timeObserverToken = videoCell.timeObserverToken {
//                                                    videoCell.player.removeTimeObserver(timeObserverToken)
//                                                    videoCell.timeObserverToken = nil
//                                                }
//                                            }*/
//                                        }
//                                    }*/
//
//
//
//                                    videoCell.player.actionAtItemEnd = .none
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                                    videoCell.player.play()
//                                }
//                            }
//                        }
//            else if let videoCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplPortraitVideoCell {
//                            //previous cell is video
//                            var cellVisibRect = videoCell.frame
//                            cellVisibRect.size = videoCell.bounds.size
//
//                            let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY) //maxY
//                            let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                            let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                            let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                            print("Previous Y of Cell is Portrait video: \(rectCell.y)")
//                            //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                            let y = rectCell.y
//                            let maxY = y + 150
//
//
//            //                if y >= -150 &&  y <= 150{
//            //                    print("You can stop playing the video from here")
//            //                }
//                            if y <= 150 { //<=
//                                print("You can stop play the video from here")
//                                if videoCell.player.timeControlStatus == .playing {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    videoCell.player.actionAtItemEnd = .pause
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                                    videoCell.player.pause()
//
//                                }
//                            } else if y > 150 {
//                                print("Reverse scroll you can play")
//                                if videoCell.player.timeControlStatus == .paused {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    let timeScale = CMTimeScale(NSEC_PER_SEC)
//                                    let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                                    /*if videoCell.player.currentItem?.status == .readyToPlay {
//                                        videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                            let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                            let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//                                            print("Duration : \(duration)")
//                                            let secs = Int(duration - currentTime)
//                                            videoCell.playBackTimeLbl.isHidden = false
//                                            videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                                videoCell.playBackTimeLbl.isHidden = true
//                                                if let timeObserverToken = videoCell.timeObserverToken {
//                                                    videoCell.player.removeTimeObserver(timeObserverToken)
//                                                    videoCell.timeObserverToken = nil
//                                                }
//                                            }*/
//                                        }
//                                    }*/
//
//
//
//                                    videoCell.player.actionAtItemEnd = .none
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                                    videoCell.player.play()
//                                }
//                            }
//                        }
//                //Checking for next cell also contains video
//            else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandsVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let y = rectCell.y
//                print("Next cell Land text video Y postion is : \(y)")
//            } else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let y = rectCell.y
//                print("Next cell Portr text video Y postion is : \(y)")
//            }  else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplPortraitVideoCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let y = rectCell.y
//                print("Next cell portr video Y postion is : \(y)")
//            } else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandscVideoCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let y = rectCell.y
//                print("Next cell lands video Y postion is : \(y)")
//            }
//
//        } /*else if centerIndexPath == indexPath{
//            if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandsVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Y of Cell is Lands Text: \(rectCell.y)")
//                //print("max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y - 150
//
//
//                /*if y >= -150 &&  y <= 150{
//                    print("You can start play the video from here")
//                }*/
//                if y <= 400 { //y <= 150 edited : 05:20 PM Apr 29th 20'20
//                    print("You can start play the video from here")
//                    if videoCell.player.rate >= 0 {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//                        videoCell.player.play()
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                } else if y > 400 {
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                    }
//                }
//            }
//            else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Y of Cell is Portrait text: \(rectCell.y)")
//                //print("max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y - 150
//
//
//                /*if y >= -150 &&  y <= 150{
//                    print("You can start play the video from here")
//                }*/
//                if y <= 400 { //y <= 150 edited : 05:20 PM Apr 29th 20'20
//                    print("You can start play the video from here")
//                    if videoCell.player.rate >= 0 {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                } else if y > 400 {
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                    }
//                }
//            }
//            else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandscVideoCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Y of Cell is Land: \(rectCell.y)")
//                //print("max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y - 150
//
//
//                /*if y >= -150 &&  y <= 150{
//                    print("You can start play the video from here")
//                }*/
//                if y <= 400 { //y <= 150 edited : 05:20 PM Apr 29th 20'20
//                    print("You can start play the video from here")
//                    if videoCell.player.rate >= 0 {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                } else if y > 400 {
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                    }
//                }
//            }
//            else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplPortraitVideoCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Y of Cell is Portrait: \(rectCell.y)")
//                //print("max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y - 150
//
//
//                /*if y >= -150 &&  y <= 150{
//                    print("You can start play the video from here")
//                }*/
//                if y <= 400 { //y <= 150 edited : 05:20 PM Apr 29th 20'20
//                    print("You can start play the video from here")
//                    if videoCell.player.rate >= 0 {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                } else if y > 400 {
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                    }
//                }
//            }
//        }*/
//        /*else if centerIndexPath > indexPath {
//            //I can get the next cell now
//            if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandsVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//
//
//                print("Next Y of Cell is: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 150
//
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                if y <= 150 { //<=
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                        //NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(cell:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//
//                    } else if y >= rectCell.y {
//                        print("Reverse scroll you can play")
//                        if videoCell.player.timeControlStatus == .paused {
//                            videoCell.player.isMuted = muteVideo
//                            if  videoCell.player.isMuted {
//                                videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                            } else {
//                                videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                            }
//                            videoCell.player.play()
//                            videoCell.player.actionAtItemEnd = .none
//                            NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                                NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        }
//                    }
//
//                }
//            }
//        }*/
// */
//
//    }
    
}

extension UserFeedsVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
            let item = dataSourceV2[indexPath.item]
            let width = view.frame.width
            switch item.userCellType{
            case .userFeedImageCell:
               let height = FeedsHeight.heightForImageCellV2(item: item, width: width)
                return CGSize(width: width, height: height)
            case .userFeedImageTextCell:
                let height = FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
                return CGSize(width: width, height: height)
                case .feedPortrVideoCell:
                   let height = FeedsHeight.heightForPortraitVideoCellV2(item: item, width: width)
                    return CGSize(width: width, height: height)
            case .feedLandsVideoCell:
                let  height = FeedsHeight.heightForLandsVideoCellV2(item: item, width: width)
                return CGSize(width: width, height: height )
                case .feedPortrVideoTextCell:
                  let  height = FeedsHeight.heightForPortraitVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                    print("Video Cell height : \(height)")
                    return CGSize(width: width, height: height )    //height + 30
            case .feedLandsVideoTextCell:
                let  height = FeedsHeight.heightForLandsVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                print("Video Cell height : \(height)")
                return CGSize(width: width, height: height )
            default:
                let height = FeedsHeight.heightforUserFeedTextCellV2(item: item , labelWidth: width - 16)
                return CGSize(width: width , height: height)
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
   
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    static func storyBoardInstance() -> ProfileVC? {
        let st = UIStoryboard(name: StoryBoard.PROFILE, bundle: nil)
        return st.instantiateViewController(withIdentifier: ProfileVC.id) as? ProfileVC
    }
}

extension UserFeedsVC: ProfileServiceDelegate{
    func DidReceiveError(error: String) {
        print("error")
    }
    
    func DidReceiveProfileData(item: ProfileData) {
        
        
        //if !isRefreshing{
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
                if self.activityIndicator.isAnimating { self.activityIndicator.stopAnimating() }
                self.profileItem = item
                self.collectionView.reloadData()
            }
        //}
    }
//    func DidReceiveUserFeedsData(item: [FeedV2Item]) {
//        DispatchQueue.main.async {
//           self.dataSourceV2 = item
//            print("Ds count : \(self.dataSourceV2.last?.postuserId),  count :\(self.dataSourceV2.count)")
//            self.isInitiallyLoaded = true
//            if self.activityIndicator.isAnimating {
//                self.activityIndicator.stopAnimating()
//            }
//            self.collectionView.reloadData()
//        }
//    }
    func DidReceiveFeedItems(items: [FeedV2Item], pictureItems: [PictureURL]) {
            DispatchQueue.main.async {
                self.dataSourceV2 = items
                self.loadMore = true
                print("Ds count : \(self.dataSourceV2.last?.postuserId),  count :\(self.dataSourceV2.count)")
                self.isInitiallyLoaded = true
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                self.pictureItems = pictureItems
                self.collectionView.reloadData()
                self.collectionView.performBatchUpdates(nil, completion: {
                    (result) in
                    // ready
                    self.pauseVisibleVideos()
                })
                
              
            }
        }
}


extension UserFeedsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: false) {
            if let vc = EditPostVC.storyBoardReference(){
                let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                vc.postImage = chosenImage
                self.present(navBarOnModal, animated: true, completion: nil)
            }
        }
    }
}

// Helper functions
extension UserFeedsVC{
    
    //MARK:- COMPANY VC
    private func goToCompanyVC(){
        guard let profile = profileItem else { return }
        /*if let vc = CompanyProfileVC.storyBoardInstance(){
            vc.companyId = profile.companyId
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
       /* if  let vc = CompanyDetailVC.storyBoardInstance() {
            
            vc.companyId = profile.companyId
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        } */
        if  let vc = CompanyHeaderModuleVC.storyBoardInstance() {
            vc.title = profile.companyName
            vc.companyId = profile.companyId
            UserDefaults.standard.set(vc.title, forKey: "companyName")
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- INTEREST VC
    private func goToInterestVC(){
        let vc = InterestsVC()
        if let interest = profileItem?.inter.sorted() , let roles = profileItem?.roles.sorted(){
            let obj = Interests()
            vc.commoditiesArray = obj.getUserCommodities(input: interest)
            vc.rolesArray = obj.getUserRoles(input: roles)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- ABOUTVC
    private func goToAboutVC(){
        guard let profile = profileItem else { return }
        
          let vc = UIStoryboard(name: StoryBoard.PROFILE , bundle: nil).instantiateViewController(withIdentifier: AboutUserVC.id) as! AboutUserVC
       // let vc = AboutUserVC()
        vc.profileItem = profile
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/*
extension UserProfileVC: ProfileCellDelegate{
    func DidPressPhotosBtn(cell: BaseCell) {
        guard let profile = profileItem else { return }
        if let vc = PhotosUserVC.storyBoardInstance(){
            vc.configPictureURL(profileItem: profile, dataSource: pictureItems)
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
    
    func DidPressEmail(cell: BaseCell) {
        //
    }
    
    func DidPressChat(cell: BaseCell) {
        //
    }
    
    func DidPressFavourite(cell: BaseCell) {
        //
    }
} */

extension UserFeedsVC {
    fileprivate func performDetailsController(obj: FeedItem){
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = obj.postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func performLikeVC(obj: FeedItem){
        let vc = LikesController()
        vc.id = obj.postId
        vc.title = "Likes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func toPostVC(){
        
        if let vc = AddPostV2Controller.storyBoardReference(){
             vc.postText = ""
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)

                 vc.didPost = { success, isVideoPosted in
                   print("returned")
                             }
            navBarOnModal.modalPresentationStyle = .overFullScreen
            self.present(navBarOnModal, animated: true, completion: nil)

                         }

                         self.collectionView.reloadData()
            }
//        if let vc = EditPostVC.storyBoardReference(){
//            let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
//            vc.didPost = { success in
//                print("returned")
//            }
//            self.present(navBarOnModal, animated: true, completion: nil)
//        }
//        self.collectionView.reloadData()
//    }
    
    fileprivate func toCamera(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

//extension UserProfileVC: FeedsDelegate{
//    var feedsV2DataSource: [FeedV2Item] {
//        get {
//            return dataSourceV2
//        }
//        set {
//            dataSourceV2 = newValue
//        }
//    }
//
//    var feedCollectionView: UICollectionView {
//        return collectionView
//    }
//
//    var feedsDataSource: [FeedItem] {
//        get {
//            return dataSource
//        }
//        set {
//            dataSource = newValue
//        }
//    }
//}
extension UserFeedsVC: UpdatedFeedsDelegate {
    var feedsV2DataSource: [FeedV2Item] {
        get {
            print("feedsv2DS : \(dataSourceV2)")
            return dataSourceV2
        }
        set {
            dataSourceV2 = newValue
        }
    }
    func didTapForFriendView(id: String) {
        performFriendView(friendId: id)
    }
    var feedCollectionView: UICollectionView {
        return collectionView
    }

    func didTapDeleteOwnPost(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest { showGuestAlert() } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { [unowned self] (report) in
                if let vc = EditPostVC.storyBoardReference(){
                    vc.title = "Edit Post"
                    if let imageTextCell = cell as? FeedImageTextCell{
                        vc.postImage = imageTextCell.feedImage.image
                    }
                    if let imageCell = cell as? FeedImageCell{
                        vc.postImage = imageCell.feedImage.image
                    }
                    let text = item.status
                    vc.postText = text
                    vc.editPostId = item.postId
                    vc.didPost = { succes in
                        print("returned")
                    }
                    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                    self.present(navBarOnModal, animated: true, completion: nil)
                    //self.feedCollectionView.reloadData()
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { [unowned self] (report) in
                //print("DS feeds : \(self.feedsV2DataSource.count)")
                //print("indexpath :\(indexPath.item)")
                //dump(self.feedsV2DataSource)
                
                NotificationCenter.default.post(name: Notification.Name("DeletedVideo"), object: nil)


                self.feedsV2DataSource.remove(at: indexPath.item)
                self.feedV2Service.deletePost(postId: item.postId, albumId: item.albumId)
                self.feedCollectionView.performBatchUpdates({
                    self.feedCollectionView.deleteItems(at: [indexPath])
                }, completion: nil)
                
                print("DS after delete : \(self.feedsV2DataSource.count)")
                self.showToast(message: "Post Deleted")

                self.collectionView.reloadData()
                //self.feedCollectionView.reloadItems(at: [indexPath])
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = UIColor.GREEN_PRIMARY
            present(actionSheet, animated: true, completion: nil)
            
            self.activityIndicator.startAnimating()
            self.refreshControl.beginRefreshing()
            self.handleRefresh()
        }
    }
}

extension UserFeedsVC : MyProfileCellDelegate {
    func DidPressAboutBtn(cell: BaseCell) {
        goToAboutVC()
    }
    
    func DidPressWallBtn(cell: BaseCell) {
        
    }
    
    func DidPressIntrestBtn(cell: BaseCell) {
        goToInterestVC()
    }
    
    func DidPressPhotosBtn(cell: BaseCell) {
//        guard let profile = profileItem else { return }
//        if let vc = PhotosUserVC.storyBoardInstance(){
//            vc.configPictureURL(profileItem: profile, dataSource: pictureItems)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        if let vc = PhotosVC.storyBoardInstance(){
        
            vc.feedItemsV2 = self.dataSourceV2
            vc.isFromMyProfile = true
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
    func DidPressFollowingBtn(cell: BaseCell) {
        if self.profileItem?.followingCount != nil {
            if self.profileItem!.followingCount != 0 {
                var followingStr = "Followings"
                if self.profileItem!.followingCount == 1 {
                    followingStr = "Following"
                }

                self.redirectToFollowersView(title: String(format: "%d %@", self.profileItem!.followingCount,followingStr), isFromFollowers: false)
            }
        }
    }
    
    func DidPressFollowersBtn(cell: BaseCell) {
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
    
    func DidPressEditProfileBtn(cell: BaseCell) {
        self.performEditProfile()
    }
    
    func DidPressCompanyBtn(cell: BaseCell) {
        
    }

    func redirectToFollowersView(title: String, isFromFollowers: Bool) {
       
        if self.profileItem?.userId != "" {
            let vc = LikesController()
            vc.title = title
            vc.followUserId = self.profileItem?.userId
            vc.isFollower = isFromFollowers
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
extension UserFeedsVC : UserFeedVideoDelegate
{
    func UserVideoFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func UserFeedVideoChanged() {
      //  self.pauseVisibleVideos()
        self.scrollViewDidEndScrolling()
    }
    

}
extension UserFeedsVC : UserFeedTextVideoDelegate
{
    func UserVideoTextFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func UserFeedTextVideoChanged() {
      //  self.pauseVisibleVideos()
        self.scrollViewDidEndScrolling()
    }
    

    
    
}
extension UserFeedsVC : UserFeedLandScapVideoDelegate
{
    func UserLandScapVideoFullscreenPressed(player: AVPlayer) {
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func UserFeedLandScapVideoChanged() {
       // self.pauseVisibleVideos()
        self.scrollViewDidEndScrolling()

    }

}
extension UserFeedsVC : UserFeedLandScapTextVideoDelegate
{
    func UserLandScapVideoTextFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func UserFeedLandScapTextVideoChanged() {
        self.pauseVisibleVideos()
        self.scrollViewDidEndScrolling()
    }

   
}
extension UserFeedsVC: UIScrollViewDelegate{
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if (actualPosition.y > 0){
                // Dragging down
            }else{
                // Dragging up
            }
        }
}
extension UserFeedsVC : AVPlayerViewControllerDelegate
{
    func playerViewController(_: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator)
    {
        
        self.scrollViewDidEndScrolling()
    }
}
