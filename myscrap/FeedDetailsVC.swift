//
//  FeedDetailsVC.swift
//  myscrap
//
//  Created by MS1 on 11/21/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import IQKeyboardManagerSwift
import AVKit
import AVFoundation
import Photos
import UserNotifications

class DetailsVC: BaseCVC , FriendControllerDelegate, UINavigationControllerDelegate{
    
    private var isFirstLayout: Bool = false
    let av = UIActivityIndicatorView(style: .whiteLarge)
    
    
    
    private lazy var commentInputView: MSInputView = { [unowned self] in
        let iv = MSInputView()
        iv.delegate = self
        iv.inputTextView.placeholder = "Write a Comment..."
        return iv
    }()
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var inputAccessoryView: UIView?{
        return commentInputView
    }
    
    //fileprivate var feedItem: FeedItem?
    /* API V2.0 */
     var feedV2Item: FeedV2Item?
    fileprivate var likesDataSource = [MemberItem]()
    var commentDataSource = [CommentItem]()
    
    fileprivate var feedService = FeedModel()
    fileprivate var service = DetailService()
    
    fileprivate let commentHeader = "commentHeader"
    
    var   profileEditPopUp = AlartMessagePopupView()
    
    var postId = ""
    var notificationId = ""
    
    
    var index = IndexPath()
    var visibleCellIndex = IndexPath()
//    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    fileprivate var isRefreshControl = false
    
    var isCommentInserted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        navigationController?.delegate = self
          NotificationCenter.default.addObserver(self, selector: #selector(self.OpenEditProfileView(notification:)), name: Notification.Name("editButtonPressed"), object: nil)
        setupCollectionView()
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
            ])
        
        
        if feedV2Item == nil{
            self.activityIndicator.startAnimating()
        }
        getDetails()
        service.delegate = self
    }
    @objc func OpenEditProfileView(notification: Notification) {
               profileEditPopUp.removeFromSuperview()
          self.gotoEditProfilePopup()
            // let vc = UIStoryboard(name: StoryBoard.PROFILE , bundle: nil).instantiateViewController(withIdentifier: EditProfileController.id) as! EditProfileController
               //   self.navigationController?.pushViewController(vc, animated: true)
                  // activityIndicator.stopAnimating()
             }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
        UserDefaults.standard.set(true, forKey: "NONeedToPlay")
      //  UserDefaults.standard.set(true, forKey: "\(postId)Seen")
        UserDefaults.standard.set(true, forKey: "\(notificationId)Seen")

        IQKeyboardManager.sharedManager().enable = false
        self.getDetails()
        //Add observer for downloading video
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoDownloadNotify(_:)), name: .videoDownloaded, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(false, forKey: "NONeedToPlay")
        IQKeyboardManager.sharedManager().enable = false
        NotificationCenter.default.removeObserver(self, name: .videoDownloaded, object: nil)
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplPortraitVideoCell {
            //cell.player.isMuted = true
            if videoCell.player.timeControlStatus == .playing {
                videoCell.player.isMuted = true
                if  videoCell.player.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoCell.player.pause()
                videoCell.player.actionAtItemEnd = .pause
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
            }
        }
        if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplLandscVideoCell {
            //cell.player.isMuted = true
            if videoCell.player.timeControlStatus == .playing {
                videoCell.player.isMuted = true
                if  videoCell.player.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoCell.player.pause()
                videoCell.player.actionAtItemEnd = .pause
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
            }
        }
        if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplPortrVideoTextCell {
            //cell.player.isMuted = true
           if videoCell.player.timeControlStatus == .playing {
                videoCell.player.isMuted = true
                if  videoCell.player.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoCell.player.pause()
                videoCell.player.actionAtItemEnd = .pause
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
            }
        }
        if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplLandsVideoTextCell {
            //cell.player.isMuted = true
            if videoCell.player.timeControlStatus == .playing {
                videoCell.player.isMuted = true
                if  videoCell.player.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoCell.player.pause()
                videoCell.player.actionAtItemEnd = .pause
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
            }
        }
    }
    
    private func endEditing(){
        
    }
    
    private func setupCollectionView(){
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        collectionView?.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        collectionView?.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
        //collectionView?.register(FeedVideoCell.Nib, forCellWithReuseIdentifier: FeedVideoCell.identifier)
        //collectionView?.register(FeedVideoTextCell.Nib, forCellWithReuseIdentifier: FeedVideoTextCell.identifier)
        
        collectionView.register(FeedDetailVideoTextCell.Nib, forCellWithReuseIdentifier: FeedDetailVideoTextCell.identifier)

        collectionView.register(FeedDetailVideoCell.Nib, forCellWithReuseIdentifier: FeedDetailVideoCell.identifier)
        collectionView.register(EmplLandscVideoCell.Nib, forCellWithReuseIdentifier: EmplLandscVideoCell.identifier)
        collectionView.register(EmplPortrVideoTextCell.Nib, forCellWithReuseIdentifier: EmplPortrVideoTextCell.identifier)
        collectionView.register(EmplLandsVideoTextCell.Nib, forCellWithReuseIdentifier: EmplLandsVideoTextCell.identifier)
        collectionView?.register(FeedNewUserCell.Nib, forCellWithReuseIdentifier: FeedNewUserCell.identifier)
        collectionView?.register(NewswithImageCell.Nib, forCellWithReuseIdentifier: NewswithImageCell.identifier)
        collectionView?.register(NewsTextCell.Nib, forCellWithReuseIdentifier: NewsTextCell.identifier)
        collectionView?.register(CommentCollectionCell.Nib, forCellWithReuseIdentifier: CommentCollectionCell.identifier)
        collectionView?.register(LikesCountCell.Nib, forCellWithReuseIdentifier: LikesCountCell.identifier)
        collectionView?.register(CompanyOfMonthCell.Nib, forCellWithReuseIdentifier: CompanyOfMonthCell.identifier)
        collectionView?.register(PersonOfWeek.Nib, forCellWithReuseIdentifier: PersonOfWeek.identifier)
        collectionView?.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: commentHeader)
        collectionView?.keyboardDismissMode = .interactive
        let tap = UITapGestureRecognizer(target: self, action: #selector(cvTapped))
        tap.numberOfTapsRequired = 1
        collectionView?.addGestureRecognizer(tap)
        collectionView?.refreshControl = refreshControl
    }
    
    
    @objc
    private func cvTapped(){
        commentInputView.inputTextView.resignFirstResponder()
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl){
        if activityIndicator.isAnimating{
            self.activityIndicator.stopAnimating()
        }
        self.getDetails()
    }
    
    fileprivate func getDetails(){
        service.getDetails(postId: postId)
    }
    
    func gotoEditProfilePopup() {
        commentInputView.isUserInteractionEnabled = true
            profileEditPopUp.removeFromSuperview()
              let vc = UIStoryboard(name: StoryBoard.PROFILE , bundle: nil).instantiateViewController(withIdentifier: EditProfileController.id) as! EditProfileController
              vc.isNeedToDismiss = true
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func insertComment(comment: String, editId: String? = nil){
        guard let feed = feedV2Item else { return }
        
        if let window = UIApplication.shared.keyWindow {
            let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            window.addSubview(overlay)
            
            av.center = overlay.center
            av.startAnimating()
            overlay.addSubview(av)
            
            service.insertDetailComment(postId: feed.postId, postedUserId: feed.postedUserId, comment: comment, editId: editId) {[weak self] (callbackComment) in
                DispatchQueue.main.async {
                    self?.av.stopAnimating()
                    overlay.removeFromSuperview()
                    if let cmt = callbackComment {
                        self?.commentDataSource = cmt
                        self?.collectionView?.reloadData()
                        self?.collectionView?.scrollToLastItem(animated: false)
                        self?.isCommentInserted = true
                    }
                }
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? FeedsVC {
            vc.isCommentInserted = isCommentInserted
            vc.fromDetailedFeeds = true
        } else if let vc = viewController as? LandHomePageVC {
            vc.fromDetailedFeeds = true
        }
    }
    
    static func controllerInstance(postId: String) -> DetailsVC {
        let layout = UICollectionViewFlowLayout()
        let vc = DetailsVC(collectionViewLayout: layout)
        vc.postId = postId
        return vc
    }
}


extension UICollectionView{
    func scrollToLastItem(animated: Bool = true){
        let lastSection = self.numberOfSections - 1
        let lastItem = numberOfItems(inSection: lastSection)
        let ip = IndexPath(item: lastItem - 1, section: lastSection)
        scrollToItem(at: ip, at: .bottom, animated: animated)
    }
}

extension DetailsVC{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch  section {
        case 0:
            guard let _ = feedV2Item else { return 0 }
            return 1
        case 1:
            let returnNum = likesDataSource.isEmpty ? 0 : 1
            return returnNum
        default:
            return commentDataSource.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let item = feedV2Item else { return }
            let vc = LikesController()
            vc.id = item.postId
            vc.title = "Likes"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let userId = commentDataSource[indexPath.row].userId
            performFriendView(friendId: userId)
            //commentInputView.becomeFirstResponder()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let data = feedV2Item else { return UICollectionViewCell() }
            switch data.cellType{
            case .covidPoll:
                return UICollectionViewCell()
            case .feedImageCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.inDetailView = true
                cell.refreshImagesCollection()
                cell.commentBtnAction = {
                    self.commentInputView.inputTextView.becomeFirstResponder()
                    self.collectionView?.scrollToLastItem(animated: false)
                }
                cell.addCommentAction = {
                   // self.gotoEditProfilePopup()
                
                    self.profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                    self.profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                    self.profileEditPopUp.intializeUI()
                      self.view.addSubview(self.profileEditPopUp)
                }
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    for imageCell in cell.feedImages.visibleCells   {
                       let image = imageCell as! CompanyImageslCell
                        UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                        cell.dwnldBtn.isEnabled = true
                        }
                }
                cell.likeBtnAction = {
                    self.likePressed()
                }
                return cell
            case .feedImageTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageTextCell.identifier, for: indexPath) as? FeedImageTextCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                 cell.refreshImagesCollection()
                cell.inDetailView = true
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    for imageCell in cell.feedImages.visibleCells   {
                       let image = imageCell as! CompanyImageslCell
                        UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                        cell.dwnldBtn.isEnabled = true
                        }
                }
                cell.commentBtnAction = {
                    self.commentInputView.inputTextView.becomeFirstResponder()
                    self.collectionView?.scrollToLastItem(animated: false)
                }
                cell.addCommentAction = {
                    //self.gotoEditProfilePopup()
                
                    self.profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                    self.profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                    self.self.profileEditPopUp.intializeUI()
                    self.view.addSubview(self.profileEditPopUp)
                }
                cell.likeBtnAction = {
                    self.likePressed()
                }
                return cell
            case .feedTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTextCell.identifier, for: indexPath) as? FeedTextCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.inDetailView = true
                cell.commentBtnAction = {
                    
                    self.commentInputView.inputTextView.becomeFirstResponder()
                    self.collectionView?.scrollToLastItem(animated: false)
                    //self.collectionView?.scrollToLastItem(animated: true)
                }
                cell.addCommentAction = {
                        //self.gotoEditProfilePopup()
                    
                        self.profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                        self.profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                        self.self.profileEditPopUp.intializeUI()
               self.view.addSubview(self.profileEditPopUp)
                    }
                cell.likeBtnAction = {
                    self.likePressed()
                }
            return cell
            case .feedVideoCell:
                /*guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedVideoCell.identifier, for: indexPath) as? FeedVideoCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.inDetailView = true
                cell.commentBtnAction = {
                    self.commentInputView.inputTextView.becomeFirstResponder()
                    self.collectionView?.scrollToLastItem(animated: false)
                }
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    self.downloadVideo(path: data.downloadVideoUrl)
                    cell.dwnldBtn.isEnabled = true
                }
                cell.likeBtnAction = {
                    self.likePressed()
                }
                /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                videoTap.numberOfTapsRequired = 1
                cell.thumbnailImg.isUserInteractionEnabled = true
                cell.thumbnailImg.addGestureRecognizer(videoTap)
                cell.thumbnailImg.tag = indexPath.row*/
                
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
                    self.downloadVideo(path: data.downloadVideoUrl)
                    cell.dwnldBtn.isEnabled = true
                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                return cell*/
                return UICollectionViewCell()
            case .feedVideoTextCell:
                /*guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedVideoTextCell.identifier, for: indexPath) as? FeedVideoTextCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.inDetailView = true
                cell.commentBtnAction = {
                    self.commentInputView.inputTextView.becomeFirstResponder()
                    self.collectionView?.scrollToLastItem(animated: false)
                }
                cell.likeBtnAction = {
                    self.likePressed()
                }
                /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                videoTap.numberOfTapsRequired = 1
                cell.thumbnailImg.isUserInteractionEnabled = true
                cell.thumbnailImg.addGestureRecognizer(videoTap)
                cell.thumbnailImg.tag = indexPath.row*/
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
                    self.downloadVideo(path: data.downloadVideoUrl)
                    cell.dwnldBtn.isEnabled = true
                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                return cell*/
                return UICollectionViewCell()
            case .companyMonth:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyOfMonthCell.identifier, for: indexPath) as? CompanyOfMonthCell else { return UICollectionViewCell()}
                cell.item = data
                return cell
            case .personWeek:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonOfWeek.identifier, for: indexPath) as? PersonOfWeek else { return UICollectionViewCell()}
                //cell.item = data
                return cell
            case .market:
                return UICollectionViewCell()
            case .ads:
                return UICollectionViewCell()
            case .userFeedTextCell:
                return UICollectionViewCell()
            case .userFeedImageCell:
                return UICollectionViewCell()
            case .userFeedImageTextCell:
                return UICollectionViewCell()
            case .newUser:
                return UICollectionViewCell()
            case .news:
                return UICollectionViewCell()
            case .vote:
                return UICollectionViewCell()
            case .personWeekScroll:
                return UICollectionViewCell()
            case .feedPortrVideoCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedDetailVideoCell.identifier, for: indexPath) as? FeedDetailVideoCell else { return UICollectionViewCell()}
               // self.visibleCellIndex = indexPath
                cell.updatedDelegate = self
                cell.newItem = data
                cell.inDetailView = true
                cell.refreshTable()
                  cell.videoPlayerDelegate = self
       //     cell.videosCountView.isHidden = true
             //   cell.thumbnailImg.isHidden = false
              //  cell.playBtn.isHidden = false

//                cell.player.play()
//                cell.player.actionAtItemEnd = .none
//                NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  cell.player.currentItem)
                cell.commentBtnAction = {
                    self.commentInputView.inputTextView.becomeFirstResponder()
                    self.collectionView?.scrollToLastItem(animated: false)
                }
                cell.addCommentAction = {
                        //self.gotoEditProfilePopup()
                    
                        self.profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                        self.profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                        self.self.profileEditPopUp.intializeUI()
                self.view.addSubview(self.profileEditPopUp)
                    }
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    self.downloadVideo(path: data.downloadVideoUrl)
                    cell.dwnldBtn.isEnabled = true
                }
                cell.likeBtnAction = {
                    self.likePressed()
                }
                /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                videoTap.numberOfTapsRequired = 1
                cell.thumbnailImg.isUserInteractionEnabled = true
                cell.thumbnailImg.addGestureRecognizer(videoTap)
                cell.thumbnailImg.tag = indexPath.row*/
                
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
                    self.downloadVideo(path: data.downloadVideoUrl)
                    cell.dwnldBtn.isEnabled = true
                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                NotificationCenter.default.post(name:.videoCellPlay, object: nil)
                cell.layoutIfNeeded()
                return cell
            case .feedLandsVideoCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedDetailVideoCell.identifier, for: indexPath) as? FeedDetailVideoCell else { return UICollectionViewCell()}
               // self.visibleCellIndex = indexPath
                cell.updatedDelegate = self
                cell.newItem = data
                cell.inDetailView = true
                cell.refreshTable()
                  cell.videoPlayerDelegate = self
       //     cell.videosCountView.isHidden = true
             //   cell.thumbnailImg.isHidden = false
              //  cell.playBtn.isHidden = false

//                cell.player.play()
//                cell.player.actionAtItemEnd = .none
//                NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  cell.player.currentItem)
                cell.commentBtnAction = {
                    self.commentInputView.inputTextView.becomeFirstResponder()
                    self.collectionView?.scrollToLastItem(animated: false)
                }
                cell.addCommentAction = {
                        //self.gotoEditProfilePopup()
                    
                        self.profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                        self.profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                        self.self.profileEditPopUp.intializeUI()
                self.view.addSubview(self.profileEditPopUp)
                    }
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    self.downloadVideo(path: data.downloadVideoUrl)
                    cell.dwnldBtn.isEnabled = true
                }
                cell.likeBtnAction = {
                    self.likePressed()
                }
                /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                videoTap.numberOfTapsRequired = 1
                cell.thumbnailImg.isUserInteractionEnabled = true
                cell.thumbnailImg.addGestureRecognizer(videoTap)
                cell.thumbnailImg.tag = indexPath.row*/
                
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
                    self.downloadVideo(path: data.downloadVideoUrl)
                    cell.dwnldBtn.isEnabled = true
                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                NotificationCenter.default.post(name:.videoCellPlay, object: nil)
                cell.layoutIfNeeded()
                return cell
            case .feedPortrVideoTextCell:
                 guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedDetailVideoTextCell.identifier, for: indexPath) as? FeedDetailVideoTextCell else { return UICollectionViewCell()}
                               // self.visibleCellIndex = indexPath
                                cell.updatedDelegate = self
                                cell.newItem = data
                                cell.inDetailView = true
                 cell.videoPlayerDelegate = self
//                            cell.videosCountView.isHidden = true
//                                cell.thumbnailImg.isHidden = false
//                                cell.playBtn.isHidden = false
                 cell.refreshTable()

                //                cell.player.play()
                //                cell.player.actionAtItemEnd = .none
                //                NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
                //                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  cell.player.currentItem)
                                cell.commentBtnAction = {
                                    self.commentInputView.inputTextView.becomeFirstResponder()
                                    self.collectionView?.scrollToLastItem(animated: false)
                                }
                                cell.addCommentAction = {
                                        //self.gotoEditProfilePopup()
                                    
                                        self.profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                                        self.profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                                        self.self.profileEditPopUp.intializeUI()
                                self.view.addSubview(self.profileEditPopUp)
                                    }
                                cell.dwnldBtnAction = {
                                    cell.dwnldBtn.isEnabled = false
                                    self.downloadVideo(path: data.downloadVideoUrl)
                                    cell.dwnldBtn.isEnabled = true
                                }
                                cell.likeBtnAction = {
                                    self.likePressed()
                                }
                                /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                                videoTap.numberOfTapsRequired = 1
                                cell.thumbnailImg.isUserInteractionEnabled = true
                                cell.thumbnailImg.addGestureRecognizer(videoTap)
                                cell.thumbnailImg.tag = indexPath.row*/
                                
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
                                    self.downloadVideo(path: data.downloadVideoUrl)
                                    cell.dwnldBtn.isEnabled = true
                                }
                                cell.offlineBtnAction = {
                                    self.showToast(message: "No internet connection")
                                }
                                NotificationCenter.default.post(name:.videoCellPlay, object: nil)
                cell.layoutIfNeeded()
                  return cell
            case .feedLandsVideoTextCell:
                 guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedDetailVideoTextCell.identifier, for: indexPath) as? FeedDetailVideoTextCell else { return UICollectionViewCell()}
                               // self.visibleCellIndex = indexPath
                                cell.updatedDelegate = self
                                cell.newItem = data
                                cell.inDetailView = true
                 cell.videoPlayerDelegate = self
//                            cell.videosCountView.isHidden = true
//                                cell.thumbnailImg.isHidden = false
//                                cell.playBtn.isHidden = false
                 cell.refreshTable()

                //                cell.player.play()
                //                cell.player.actionAtItemEnd = .none
                //                NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
                //                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  cell.player.currentItem)
                                cell.commentBtnAction = {
                                    self.commentInputView.inputTextView.becomeFirstResponder()
                                    self.collectionView?.scrollToLastItem(animated: false)
                                }
                                cell.addCommentAction = {
                                        //self.gotoEditProfilePopup()
                                    
                                        self.profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                                        self.profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                                        self.self.profileEditPopUp.intializeUI()
                                self.view.addSubview(self.profileEditPopUp)
                                    }
                                cell.dwnldBtnAction = {
                                    cell.dwnldBtn.isEnabled = false
                                    self.downloadVideo(path: data.downloadVideoUrl)
                                    cell.dwnldBtn.isEnabled = true
                                }
                                cell.likeBtnAction = {
                                    self.likePressed()
                                }
                                /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                                videoTap.numberOfTapsRequired = 1
                                cell.thumbnailImg.isUserInteractionEnabled = true
                                cell.thumbnailImg.addGestureRecognizer(videoTap)
                                cell.thumbnailImg.tag = indexPath.row*/
                                
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
                                    self.downloadVideo(path: data.downloadVideoUrl)
                                    cell.dwnldBtn.isEnabled = true
                                }
                                cell.offlineBtnAction = {
                                    self.showToast(message: "No internet connection")
                                }
                                NotificationCenter.default.post(name:.videoCellPlay, object: nil)
                cell.layoutIfNeeded()
                  return cell
            
            }
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesCountCell.identifier, for: indexPath) as? LikesCountCell else { return UICollectionViewCell() }
            cell.configCell(item: feedV2Item)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionCell.identifier, for: indexPath) as? CommentCollectionCell else { return UICollectionViewCell()}
            cell.item = commentDataSource[indexPath.item]
            cell.configcell(item: commentDataSource[indexPath.item])
            cell.delegate = self
            return cell
        }
    }
    @objc func videoViewTapped(tapGesture: UITapGestureRecognizer) {
        let data = feedV2Item
        let urlString = data?.videoUrl
        let videoURL = URL(string: urlString ?? "")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    func downloadVideo(path : String) {
        self.showToast(message: "Download begins!")
        let videoImageUrl = path
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoImageUrl),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/MSVIDEO.mp4"
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
        if let cell = collectionView.cellForItem(at: index) as? EmplPortraitVideoCell {
            
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if cell.player.isMuted {
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplLandscVideoCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if cell.player.isMuted {
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplPortrVideoTextCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if cell.player.isMuted {
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplLandsVideoTextCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if cell.player.isMuted {
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
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
    
    @objc func playingVideoDidEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero) { (reachedEnd) in
                if reachedEnd {
                    print("Visible video started")
                }
            }
        }
    }
}

extension DetailsVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        if indexPath.section == 0 {
            guard let item = feedV2Item else { return CGSize.zero }
            let width = screenWidth
            switch item.cellType{
            case .covidPoll:
                return CGSize(width: 0, height: 0)
            case .feedTextCell:
                let height = FeedsHeight.heightforDetailFeedTextCellV2(item: item , labelWidth: width - 16)
                if item.likeCount == 0 && item.commentCount == 0 && item.status.contains("http") {
                    return CGSize(width: width , height: height - 38)
                } else if item.likeCount == 0 && item.commentCount == 0 {
                    return CGSize(width: width , height: height)
                } else {
                    return CGSize(width: width , height: height - 35)
                }
            case .feedImageCell:
                let height = FeedsHeight.heightForImageCellV2(item: item, width: width)
                if item.likeCount == 0 && item.commentCount == 0 && item.status.contains("http") {
                    return CGSize(width: width , height: height - 38)
                } else if item.likeCount == 0 && item.commentCount == 0 {
                    return CGSize(width: width , height: height)
                } else {
                    return CGSize(width: width , height: height - 35)
                }
            case .feedImageTextCell:
                let height = FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
                if item.likeCount == 0 && item.commentCount == 0 && item.status.contains("http") {
                    return CGSize(width: width , height: height - 38)
                } else if item.likeCount == 0 && item.commentCount == 0 {
                    return CGSize(width: width , height: height)
                } else {
                    return CGSize(width: width , height: height - 35)
                }
            case .feedVideoCell:
                /*let height = FeedsHeight.heightForDetailVideoCellV2(item: item, width: width)
                return CGSize(width: width, height: height + 30)*/
                return CGSize(width: 0, height: 0)
            case .feedVideoTextCell:
                /*let height = FeedsHeight.heightForDetailVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                return CGSize(width: width, height: height + 15)*/
                return CGSize(width: 0, height: 0)
            case .companyMonth:
                let height = FeedsHeight.heightForCompanyOfMonthCellV2(item: item, labelWidth: width - 16)  //Aligning width by omitting (leading & trailing)
                return CGSize(width: width, height: height)
            case .personWeek:
                return CGSize(width: 0, height: 0)
            case .ads:
                return CGSize(width: 0, height: 0)
            case .market:
                return CGSize(width: 0, height: 0)
            case .userFeedTextCell:
                return CGSize(width: 0, height: 0)
            case .userFeedImageCell:
                return CGSize(width: 0, height: 0)
            case .userFeedImageTextCell:
                return CGSize(width: 0, height: 0)
            case .newUser:
                return CGSize(width: 0, height: 0)
            case .news:
                return CGSize(width: 0, height: 0)
            case .vote:
                return CGSize(width: 0, height: 0)
            case .personWeekScroll:
                return CGSize(width: 0, height: 0)
            case .feedPortrVideoCell:
                var height = FeedsHeight.heightForPortraitVideoCellV2(item: item, width: width)
                if !(item.likeCount == 0 ){
                    height -= 35
                }
                else{
                    height += 35
                }
                return CGSize(width: width, height: height )
            case .feedLandsVideoCell:
                var height = FeedsHeight.heightForPortraitVideoCellV2(item: item, width: width)
                if !(item.likeCount == 0 ){
                    height -= 35
                }
                else{
                    height += 35
                }
                return CGSize(width: width, height: height)
            case .feedPortrVideoTextCell:
                var height = FeedsHeight.heightForPortraitVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                if !(item.likeCount == 0 ){
                    height -= 35
                }
                else{
                    height += 35
                }
                print("Video Cell height : \(height)")
                return CGSize(width: width, height: height)    //height + 30
            case .feedLandsVideoTextCell:
                var height = FeedsHeight.heightForPortraitVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                if !(item.likeCount == 0 ){
                    height -= 35
                }
                else{
                    height += 35
                }
                print("Video Cell height : \(height)")
                return CGSize(width: width, height: height )    //height + 30
            
            }
        } else if indexPath.section == 1 {
            return CGSize(width: self.view.frame.width, height: 37)
        } else {
            let width = screenWidth
            let height = FeedsHeight.heightForCommentFeedsV2(item: commentDataSource[indexPath.item], labelWidth: width)
            print("height for comment text : \(height)")
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 8 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return section == 0 ? 8 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section{
        case 0:
            return UIEdgeInsets.zero
        default:
            return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        }
    }
}


extension DetailsVC {
    fileprivate func performDetailsController(obj: FeedItem){
        
        let vc = DetailsVC()
        vc.postId = obj.postId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    fileprivate func performLikeVC(obj: FeedItem){
        let vc = LikesController()
        vc.id = obj.postId
        vc.title = "Likes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func likePressed() {
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.getDetails()
        }
        
    }
}

extension DetailsVC: DetailDelegate{
    func DidReceivePOWDetails(feed: FeedV2Item?, comment: [CommentPOWItem]) {
        print("POW will not get fired")
    }
    
    func DidReceiveCMDetails(feed: FeedV2Item?, comment: [CommentCMItem]) {
        print("This will not get fired")
    }
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            print("error: \(error)")
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            let alertVC = UIAlertController(title: "Removed!!",message: "This post has been removed by the user.",preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default) { [unowned self] (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertVC.addAction(okAction)
            self.present(alertVC,animated: true,completion: nil)
        }
    }
    
    func DidReceiveDetails(feed: FeedV2Item?, members: [MemberItem], comment: [CommentItem]) {
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
            if self.isRefreshControl{
                self.isRefreshControl = false
            }
            self.feedV2Item = feed
            self.likesDataSource = members
            self.commentDataSource = comment
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            self.collectionView?.reloadData()
        }
    }
}


extension DetailsVC: MSInputViewDelegate{
    func didPressCameraButton() {
        
    }
    
    func didPressAddButton() {
        
    }
    
    
    func didPressSendButton(with text: String) {
        
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        }
        else {
            let profilePic = AuthService.instance.profilePic
            let email = AuthService.instance.email
            let mobile = AuthService.instance.mobile
            if (profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || profilePic == "") || (mobile == "" || email == ""){
                //User can't add comment
                commentInputView.inputTextView.resignFirstResponder()
                commentInputView.isUserInteractionEnabled = false
                profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                                     profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                                     profileEditPopUp.intializeUI()
                                     self.view.addSubview(profileEditPopUp)
            //    self.gotoEditProfilePopup()
            } else {
                self.insertComment(comment: text)
            }
            
        }
    }
}

extension DetailsVC: UpdatedFeedsDelegate{
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return [feedV2Item!]
        }
        set {
            feedV2Item = newValue.first
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView!
    }
    
    func didTapImageViewV2(atIndex: Int, item: FeedV2Item) {
    guard !(item.pictureURL.isEmpty) else { return }
           let vc = AlbumVC(index: atIndex, dataSource: item.pictureURL)
           vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil )
           
    }
    
    func didTapEditV2(item: FeedV2Item, cell: UICollectionViewCell) {
        print("Edit button Pressed")
        if AuthStatus.instance.isGuest { showGuestAlert() } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { [unowned self] (report) in
                if let vc = EditPostVC.storyBoardReference(){
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
                print("DS feeds : \(self.feedsV2DataSource)")
                dump(self.feedsV2DataSource)
                self.feedsV2DataSource.remove(at: indexPath.item)
                self.feedV2Service.deletePost(postId: item.postId, albumId: item.albumId)
                self.feedCollectionView.performBatchUpdates({
                    self.feedCollectionView.deleteItems(at: [indexPath])
                }, completion: nil)
                self.showToast(message: "Post Deleted")
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = UIColor.GREEN_PRIMARY
            present(actionSheet, animated: true, completion: nil)
        }
    }
  
}

extension DetailsVC: VideoPlayerDelegate{
    
    func playVedio(url: String) {
             let urlString = url
                   let videoURL = URL(string: urlString)
                   let player = AVPlayer(url: videoURL!)
                   let playerViewController = AVPlayerViewController()
                   playerViewController.player = player
                   self.present(playerViewController, animated: true) {
                       playerViewController.player!.play()
                   }
    }
    
}
extension DetailsVC: VideoTextPlayerDelegate{
    
    func playTextVedio(url: String) {
             let urlString = url
                   let videoURL = URL(string: urlString)
                   let player = AVPlayer(url: videoURL!)
                   let playerViewController = AVPlayerViewController()
                   playerViewController.player = player
                   self.present(playerViewController, animated: true) {
                       playerViewController.player!.play()
                   }
    }
    
}
extension DetailsVC: CommentCollectionCellDelegate{}
