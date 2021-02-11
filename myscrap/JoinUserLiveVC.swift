//
//  JoinUserLiveVC.swift
//  myscrap
//
//  Created by Hassan Jaffri on 1/2/21.
//  Copyright © 2021 MyScrap. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import IQKeyboardManagerSwift
import Starscream

class AntMediaClientConference {
    var playerClient: AntMediaClient;
    var viewIndex: Int;
    
    init(player: AntMediaClient, index: Int) {
        self.playerClient = player;
        self.viewIndex = index
    }
}

class JoinUserLiveVC: UIViewController,KeyboardAvoidable ,UITextFieldDelegate{
    
    @IBOutlet var localView: UIView!

        
    var remoteViews:[UIView] = []
    
    var viewFree:[Bool] = [true, true]
    var orignalSuggessionList :[String] = ["Hello","Hi","How are you","How's your day","Nice to meet you","Hey","What's up!","How are you doing?","Nice","Ok","Bye","Oops!","Yep","Why!?","Great","No"]
    
    var suggessionList :[String] = ["Hello","Hi","How are you","How's your day","Nice to meet you"]
//    {
////        didSet
////        {
////            self.suggessionCollectionView.reloadData()
////        }
//    }

    
    var liveID = ""
    var friendId = ""
    var liveType = ""
    
    var timeStampStarted = ""
    var isNeedToShowFollowing = 0
    var liveUserNameValue = ""
    var liveUserImageValue  = ""
    var liveUserProfileColor = ""
    var liveUsertopicValue = ""
    var followingStatus = false
    var isSentRequest = false
    fileprivate var profileItem:ProfileData?
    @IBOutlet weak var suggessionCollectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraToggleButton: UIButton!
    fileprivate let service = ProfileService()
    fileprivate var serviceFollowing = MemmberModel()
    @IBOutlet weak var largeCameraContainer: UIView!
    @IBOutlet weak var smallCameraContainer: UIView!
    @IBOutlet weak var smallStreamView: UIView!
    let followAlertVC = LiveUserFollowPopUpVC.storyBoardInstance()
    let unfollowAlertVC = UnfollowConfirmationPopUpVC.storyBoardInstance()
    let joiningVC = ViewerSideJoinRequestPopUp.storyBoardInstance()
    let joiningConfirmVC = ViewerSideJoinConfirmPopUp.storyBoardInstance()
    let endLiveFollowAlertVC = EndLiveUserFollowPopUpVC.storyBoardInstance()
    
    var userJoined = Array<[String:AnyObject]>()

    var timer = Timer()
    var liveComments = [CommentMessage]()
    {
        didSet
        {
            self.reloadComentsView()
        }
    }
    
    @IBOutlet weak var helloButton: UIButton!
    @IBOutlet weak var emoji1Button: UIButton!
    @IBOutlet weak var emoji2Button: UIButton!
    @IBOutlet weak var emoji3Button: UIButton!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var emojo5Button: UIButton!
    @IBOutlet weak var emoji4Button: UIButton!
    
    @IBOutlet weak var commentsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var followButtonwidth: NSLayoutConstraint!
    
    @IBOutlet weak var commentViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var UserCommentsBackground: UIView!
    @IBOutlet weak var userCommentsCollectionView: UICollectionView!
    @IBOutlet weak var liveUserProfile: ProfileView!
    @IBOutlet weak var liveUserName: UILabel!
    @IBOutlet weak var liveUserImage: UIImageView!
    var isFrontCam = true

    @IBOutlet weak var liveStreamerView: UIView!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var seenIcon: UIImageView!
    @IBOutlet weak var seenView: UIView!
    var layoutConstraintsToAdjust: [NSLayoutConstraint] = []
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    var topicValueText = "No Topic"
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
//    let webRTCClient: AntMediaClient = AntMediaClient.init()
    
    @IBOutlet weak var announceImage: UIImageView!
    @IBOutlet weak var commentBackground: UIView!
    @IBOutlet weak var topicTtitle: UILabel!
    @IBOutlet weak var announcementView: UIView!
    @IBOutlet weak var topicValue: UILabel!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var cameraType  = CameraType.Front
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var liveLable: UILabel!
    @IBOutlet weak var livebutton: UIButton!
    @IBOutlet weak var closebutton: UIButton!
    var userProfileColorCode = ""
    var liveUserImageUrl = ""
    {
        didSet
        {
          //  self.liveUserImage.setImageWithIndicator(imageURL: liveUserImageUrl)

        }
    }
    var liveUserNameText = ""
    {
        didSet
        {
            self.liveUserName.text = liveUserNameText
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.suggessionCollectionView.delegate = self
        self.suggessionCollectionView.dataSource = self
        
//        if let flowLayout = suggessionCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//           }
        NotificationCenter.default.addObserver(self, selector: #selector(self.likeCommentNotificationReciveLive), name: NSNotification.Name(rawValue: "LikeCommentNotificationReciveLive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.followNotificationReciveLive), name: NSNotification.Name(rawValue: "FollowNotificationReciveLive"), object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnSmallWindow(tapGestureRecognizer:)))
        smallCameraContainer.isUserInteractionEnabled = true
        smallCameraContainer.addGestureRecognizer(tapGestureRecognizer)
        self.navigationController?.navigationBar.isHidden = true
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
      //  self.topicTtitle.text = "Topic :"
        appDelegate.webRTCViewerClient.delegate = self
        self.topicValue.text = topicValueText
        service.delegate = self
        serviceFollowing.delegate = self
        self.followButtonwidth.constant = 0
        followButton.layer.cornerRadius =  followButton.frame.size.height/2
        
//        helloButton.layer.cornerRadius =  helloButton.frame.size.height/2
//        emoji1Button.layer.cornerRadius =  emoji1Button.frame.size.height/2
//        emoji2Button.layer.cornerRadius =  emoji2Button.frame.size.height/2
//        emoji3Button.layer.cornerRadius =  emoji3Button.frame.size.height/2
//        emoji4Button.layer.cornerRadius =  emoji4Button.frame.size.height/2
//        emojo5Button.layer.cornerRadius =  emojo5Button.frame.size.height/2
//
//        helloButton.backgroundColor = .darkGray
//        emoji1Button.backgroundColor = .darkGray
//        emoji2Button.backgroundColor = .darkGray
//        emoji3Button.backgroundColor = .darkGray
//        emoji4Button.backgroundColor = .darkGray
//        emojo5Button.backgroundColor = .darkGray
//
//        helloButton.setTitle("Hello", for: .normal)
//        emoji1Button.setTitle("😂", for: .normal)
//        emoji2Button.setTitle("😍", for: .normal)
//        emoji3Button.setTitle("☺️", for: .normal)
//        emoji4Button.setTitle("✋🏻", for: .normal)
//        emojo5Button.setTitle("👍🏻", for: .normal)
        
        announcementView.layer.cornerRadius =  announcementView.frame.size.height/2
        liveStreamerView.layer.cornerRadius =  liveStreamerView.frame.size.height/2
        liveUserImage.layer.cornerRadius =  liveUserImage.frame.size.height/2

        commentBackground.layer.cornerRadius =  commentBackground.frame.size.height/2
        commentBackground.layer.borderWidth =  3
        commentBackground.layer.borderColor =  UIColor.gray.cgColor
      
        
        commentField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        sendCommentButton.setImage(image, for: .normal)
        //sendCommentButton.tintColor = UIColor.gray
        sendCommentButton.tintColor = UIColor.MyScrapGreen
        sendCommentButton.isHidden = true

        commentField.textColor = UIColor.gray
        commentField.delegate = self
        
        closebutton.drawShadow()
        
        
        self.announceImage.image =  UIImage.fontAwesomeIcon(name: .bullhorn, style: .solid, textColor: UIColor.white , size: CGSize(width: 30, height: 30))
        
        let imageSeen = UIImage(named: "ic_seen")?.withRenderingMode(.alwaysTemplate)
        self.seenIcon.image = imageSeen
        self.seenIcon.tintColor = .white
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
           gradientLayer.frame.size = livebutton.frame.size
           gradientLayer.colors =
            [UIColor(red: 0.25, green: 0.69, blue: 0.16, alpha: 1.00).cgColor , UIColor.MyScrapGreen.cgColor]
           //Use diffrent colors
        livebutton.layer.addSublayer(gradientLayer)
        livebutton.layer.cornerRadius = 5
        livebutton.clipsToBounds = true
        livebutton.drawShadow()
     
        
        seenView.layer.cornerRadius = 5
        seenView.clipsToBounds = true

        layoutConstraintsToAdjust.append(constraintContentHeight)
        //webRTCClient.delegate = self
        let imageMic = UIImage(named: "ic_mic")?.withRenderingMode(.alwaysTemplate)
        micButton.setImage(imageMic, for: .normal)
        
        let imageMicMute = UIImage(named: "ic_muteMic")?.withRenderingMode(.alwaysTemplate)
        micButton.setImage(imageMicMute, for: .selected)
        micButton.tintColor = UIColor.white
        micButton.drawShadow()
        micButton.isHidden = true
        
        let imageCam = UIImage(named: "ic_rotate_camera")?.withRenderingMode(.alwaysTemplate)
        cameraToggleButton.setImage(imageCam, for: .normal)
        cameraToggleButton.tintColor = UIColor.white
        cameraToggleButton.drawShadow()
        cameraToggleButton.isHidden = true
        appDelegate.webRTCViewerClient.stop()
        addKeyboardObservers()
        self.setUpCamera()
        self.setUpCommentViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        liveStreamerView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.RecievedMessage(_:)), name: NSNotification.Name(rawValue: "RecievedMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PublishStarted(_:)), name: NSNotification.Name(rawValue: "PublishStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.AppCloseed(_:)), name: NSNotification.Name(rawValue: "AppCloseed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.remoteStreamRemoved(_:)), name: NSNotification.Name(rawValue: "playFinished"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ConnectionEstablished(_:)), name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playStarted(_:)), name: NSNotification.Name(rawValue: "playStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.remoteStreamRemoved(_:)), name: NSNotification.Name(rawValue: "remoteStreamRemoved"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clientHasErrorInSteam(_:)), name: NSNotification.Name(rawValue: "clientHasError"), object: nil)
       
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.isUserInteractionEnabled = false
        spinner.label.text = "Loading..."
       appDelegate.webRTCClient.setRemoteView(remoteContainer: cameraView, mode: .scaleAspectFill)
        smallCameraContainer.isHidden = true
    appDelegate.webRTCViewerClient.setLocalView(container: smallStreamView, mode: .scaleAspectFill)
        
        self.smallStreamView.transform = CGAffineTransform(scaleX: -1, y: 1);
        self.cameraView.transform = CGAffineTransform(scaleX: -1, y: 1);
//        appDelegate.webRTCClient.setRemoteView(remoteContainer: cameraView, mode: .scaleAspectFill)
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
           
        
            //Step 13
        }
    }
    func updateSuggessionList()  {
        suggessionList.removeAll()
        repeat {
            let  message = orignalSuggessionList.randomItem()!
            if !suggessionList.contains(message)   {
                suggessionList.append(message)
            }
        } while suggessionList.count<5

    }
    @objc  func followNotificationReciveLive(notification: NSNotification) {

      if let useriD = notification.userInfo?["UserId"] as? String  {
      // do something with your image
        if let vc = FriendVC.storyBoardInstance() {
        vc.friendId = useriD
        
        vc.isfromCardNoti = ""
            self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
        }
      }
     else
      {
        if let useriD = notification.userInfo?["UserId"] as? Int  {
        // do something with your image
          if let vc = FriendVC.storyBoardInstance() {
          vc.friendId = "\(useriD)"
          
          vc.isfromCardNoti = ""
            self.navigationController?.navigationBar.isHidden = false
          self.navigationController?.pushViewController(vc, animated: true)
          }
        }
        
      }
     }
    
    @objc  func likeCommentNotificationReciveLive(notification: NSNotification) {

      if let posttID = notification.userInfo?["PostID"] as? String {
      // do something with your image
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = posttID
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
      }
        else
      {
        if let posttID = notification.userInfo?["PostID"] as? Int {
        // do something with your image
          let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
          vc.postId = "\(posttID)"
            self.navigationController?.navigationBar.isHidden = false
          self.navigationController?.pushViewController(vc, animated: true)
        }
      }
     }
    @objc func tappedOnSmallWindow(tapGestureRecognizer: UITapGestureRecognizer){

        if smallCameraContainer.tag == 0 {
            smallCameraContainer.tag = 1
            cameraView.bounds = smallCameraContainer.bounds
            cameraView.frame = CGRect(x: 0, y: 0, width: smallCameraContainer.frame.size.width, height: smallCameraContainer.frame.size.height)
            smallCameraContainer.addSubview(cameraView)
            
            smallStreamView.bounds = largeCameraContainer.bounds
            smallStreamView.frame = CGRect(x: 0, y: 0, width: largeCameraContainer.frame.size.width, height: largeCameraContainer.frame.size.height)
            largeCameraContainer.addSubview(smallStreamView)
            
            smallCameraContainer.layoutSubviews()
            smallCameraContainer.layoutIfNeeded()
            largeCameraContainer.layoutSubviews()
            largeCameraContainer.layoutIfNeeded()
            
            //appDelegate.webRTCViewerClient.start()
        }
        else
        {
            smallCameraContainer.tag = 0
            smallStreamView.bounds = smallCameraContainer.bounds
            smallStreamView.frame = CGRect(x: 0, y: 0, width: smallCameraContainer.frame.size.width, height: smallCameraContainer.frame.size.height)
            smallCameraContainer.addSubview(smallStreamView)
            
            cameraView.bounds = largeCameraContainer.bounds
            cameraView.frame = CGRect(x: 0, y: 0, width: largeCameraContainer.frame.size.width, height: largeCameraContainer.frame.size.height)
            largeCameraContainer.addSubview(cameraView)
            smallCameraContainer.layoutSubviews()
            smallCameraContainer.layoutIfNeeded()
            largeCameraContainer.layoutSubviews()
            largeCameraContainer.layoutIfNeeded()
        }
        self.view.layoutIfNeeded()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.showFollowingAlert()
    }
    @objc func RecievedMessage(_ notification: NSNotification) {
            print(notification.userInfo ?? "")
        if let dict = notification.userInfo as? [String: AnyObject]{
            if let isForStreamer = dict["OnlyForStreamer"]  as? String {
                if isForStreamer == "0" {
                    
                    var comment = CommentMessage()
                    comment.messageText = dict["message"] as? String ?? ""
                    comment.name = dict["fullName"] as? String ?? ""
                    comment.profilePic =  dict["profilePic"] as? String ?? ""
                    comment.colorCode =  dict["colorCode"] as? String ?? ""
                    comment.userId = dict["userId"] as? String ?? ""
                    comment.friendId = dict["friendId"] as? String ?? ""
                    comment.isJoingingRequest = dict["isJoingingRequest"] as? String ?? ""
                    comment.joingingRequestStatus = dict["joingingRequestStatus"] as? String ?? ""
                    let streamStarted = dict["StreamStarted"] as? String ?? "0"
                    let specificUser = dict["SpecificUser"] as? String ?? "0"
                    if comment.isJoingingRequest == "1" && comment.friendId == AuthService.instance.userId {
                        DispatchQueue.main.async { [self] in
                        self.showJoinConfirmationPopup()
                        }
                    }
                    else
                    {
                        if streamStarted == "1" {
                            // Play Other Stream
                          
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                   //call any function
                                self.playJoiningStream()
                               }
                        }
                        else{
                            if specificUser != "1" {
                            self.liveComments.append(comment)
                            }
                            
                        }
                    }
                   
                }
            }
            else{
            var comment = CommentMessage()
            comment.messageText = dict["message"] as? String ?? ""
            comment.name = dict["fullName"] as? String ?? ""
            comment.profilePic =  dict["profilePic"] as? String ?? ""
            comment.colorCode =  dict["colorCode"] as? String ?? ""
            comment.userId = dict["userId"] as? String ?? ""
            comment.friendId = dict["friendId"] as? String ?? ""
            comment.isJoingingRequest = dict["isJoingingRequest"] as? String ?? ""
            comment.joingingRequestStatus = dict["joingingRequestStatus"] as? String ?? ""
                let streamStarted = dict["StreamStarted"] as? String ?? "0"
                let specificUser = dict["SpecificUser"] as? String ?? "0"
                if comment.isJoingingRequest == "1" && comment.friendId == AuthService.instance.userId {
                    DispatchQueue.main.async { [self] in
                    self.showJoinConfirmationPopup()
                    }
                }
                else
                {
                    if streamStarted == "1" {
                        // Play Other Stream
                      
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                               //call any function
                            self.playJoiningStream()
                           }
                    }
                    else{
                        if specificUser != "1" {
                        self.liveComments.append(comment)
                        }
                        
                    }
                }
        }
        }
    }
    @objc func AppCloseed(_ notification: NSNotification) {
        DispatchQueue.main.async { [self] in
       //     NotificationCenter.default.post(name: Notification.Name("EndLiveBYOtherUser"), object: nil)
           // self.closeButtonPressed((Any).self)

        }
     }
    @objc func PublishStarted(_ notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            MBProgressHUD.hide(for: (self?.view)! , animated: true)
            self?.videoPreviewLayer.removeFromSuperlayer()
            self?.captureSession.stopRunning()
        }
    
     }
    
    
    @objc func playFinished(_ notification: NSNotification) {
//        self.remoteStreamRemoved(<#T##notification: NSNotification##NSNotification#>)
    //    NotificationCenter.default.post(name: Notification.Name("EndLiveBYOtherUser"), object: nil)
    //    self.closeButtonPressed((Any).self)

        }
    @objc func playStarted(_ notification: NSNotification) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.addTimerCall()
            MBProgressHUD.hide(for: self.view , animated: true)
            self.videoPreviewLayer.removeFromSuperlayer()
            self.captureSession.stopRunning()
        }

    }
    @objc func remoteStreamRemoved(_ notification: NSNotification) {
        DispatchQueue.main.async { [self] in
            self.showEndFollowingAlert()
           // self.closeButtonPressed(UIButton())
       // self.setUserStatusToLive(status: "s")
        }
    }
    
    @objc func clientHasErrorInSteam(_ notification: NSNotification) {
        NotificationCenter.default.post(name: Notification.Name("EndLiveBYOtherUser"), object: nil)
        self.closeButtonPressed((Any).self)

    }
    
    @objc func ConnectionEstablished(_ notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
    //    MBProgressHUD.hide(for: self.view , animated: true)
            self?.videoPreviewLayer.removeFromSuperlayer()
            self?.captureSession.stopRunning()
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.length > 0 {
            sendCommentButton.tintColor = UIColor.MyScrapGreen
            sendCommentButton.isHidden = false

        }
        else{
            sendCommentButton.tintColor = UIColor.MyScrapGreen
            sendCommentButton.isHidden = true

           // sendCommentButton.tintColor = UIColor.gray
        }
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("right swipe")
                self.hideCommentesView()
            case UISwipeGestureRecognizer.Direction.left:
                print("left swipe")
                self.showCommentesView()
            default:
                print("other swipe")
            }
        }
    }
    private func setUpCommentViews()
    {
        self.userCommentsCollectionView.delegate = self
        self.userCommentsCollectionView.dataSource = self
        self.userCommentsCollectionView.register(LiveUserCommentsCell.Nib, forCellWithReuseIdentifier: LiveUserCommentsCell.identifier)
        self.userCommentsCollectionView.register(ViewerJoinRequestCell.Nib, forCellWithReuseIdentifier: ViewerJoinRequestCell.identifier)
        
        
        self.userCommentsCollectionView.register(LiveUserFollowCell.Nib, forCellWithReuseIdentifier: LiveUserFollowCell.identifier)
        
//        if let flowLayout = userCommentsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//           }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
     
        // Setup your camera here...
    }
   func addActionAlert ()
   {
 

   }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        if !followingStatus
        {
            self.serviceFollowing.sendFollowRequest(friendId: self.friendId)
            let message = "Started Following" //"Successfully started following"
            showToast(message: message)
            followingStatus = true
            self.reloadComentsView()
        }
    }
    func sendSuggestionMessage(message:String)  {
    
        var comment = CommentMessage()
        comment.messageText = message
        comment.name = AuthService.instance.fullName
        comment.profilePic = AuthService.instance.profilePic
        comment.colorCode = AuthService.instance.colorCode
        comment.userId = AuthService.instance.userId
        self.liveComments.append(comment)
        let dic = ["fullName": AuthService.instance.fullName,"isJoingingRequest": "0","joingingRequestStatus": "0","OnlyForStreamer": "0","friendId": friendId, "profilePic": AuthService.instance.profilePic ,"StreamStarted": "0", "message": message , "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId]
        
        let data = NSKeyedArchiver.archivedData(withRootObject: dic)
        appDelegate.webRTCClient.sendData(data: data, binary: false)
    }
    @IBAction func EmojiButtonsPressed(_ sender: UIButton) {
        var message = ""
        if sender.tag == 1 {
            message  = "Hello"
        }
       else if sender.tag == 2 {
        message = "😂"
        }
       else if sender.tag == 3 {
        message = "😍"
        }
       else if sender.tag == 4 {
        message = "☺️"

        }
       else if sender.tag == 5 {
        message = "✋🏻"
        }
       else if sender.tag == 6 {
        message = "👍🏻"
        }
        var comment = CommentMessage()
        comment.messageText = message
        comment.name = AuthService.instance.fullName
        comment.profilePic = AuthService.instance.profilePic
        comment.colorCode = AuthService.instance.colorCode
        comment.userId = AuthService.instance.userId
        self.liveComments.append(comment)
        let dic = ["fullName": AuthService.instance.fullName,"isJoingingRequest": "0","joingingRequestStatus": "0","OnlyForStreamer": "0","friendId": friendId, "profilePic": AuthService.instance.profilePic ,"StreamStarted": "0", "message": message , "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId]
        
        let data = NSKeyedArchiver.archivedData(withRootObject: dic)
        appDelegate.webRTCClient.sendData(data: data, binary: false)
    }
    @IBAction func sendCommentPressed(_ sender: Any) {
        
        if commentField.text!.length > 0 {
            var comment = CommentMessage()
            comment.messageText = commentField.text!
            comment.name = AuthService.instance.fullName
            comment.profilePic = AuthService.instance.profilePic
            comment.colorCode = AuthService.instance.colorCode
            comment.userId = AuthService.instance.userId
            self.liveComments.append(comment)
            
            
            let dic = ["fullName": AuthService.instance.fullName,"isJoingingRequest": "0","joingingRequestStatus": "0","OnlyForStreamer": "0","friendId": friendId, "profilePic": AuthService.instance.profilePic ,"StreamStarted": "0", "message": commentField.text! , "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId]
            
            let data = NSKeyedArchiver.archivedData(withRootObject: dic)
            appDelegate.webRTCClient.sendData(data: data, binary: false)
            commentField.text = ""
            sendCommentButton.tintColor = UIColor.MyScrapGreen
            sendCommentButton.isHidden = true

         //   sendCommentButton.tintColor = UIColor.gray

        }
        
    }
    func setUpCamera ()
    {

        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera , for: AVMediaType.video, position: .front)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            stillImageOutput = AVCapturePhotoOutput()
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    
    }
    func setupLivePreview() {
        
    
        let screenSize = UIScreen.main.bounds
        largeCameraContainer.frame =  CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height+20)
        cameraView.frame =  largeCameraContainer.frame
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
       // self.cameraView.bounds = screenSize
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.videoPreviewLayer.frame =  CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height+40)
      //  cameraView.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
        //Step12
    }
    /// Swap camera and reconfigures camera session with new input
    fileprivate func swapCamera() {

        // Get current input
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }

        // Begin new session configuration and defer commit
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        // Create new capture device
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }

        // Create new capture input
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            print(error.localizedDescription)
            return
        }

        // Swap capture device inputs
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }

    /// Create new capture device with requested position
    fileprivate func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {

        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices

        //if let devices = devices {
            for device in devices {
                if device.position == position {
                    return device
                }
            }
        //}

        return nil
    }
    func addLeftUser(dict:[String: AnyObject])  {
        var comment = CommentMessage()
        comment.messageText = "Left!"
        comment.name = dict["name"]! as! String
        comment.profilePic =  dict["likeProfilePic"]! as! String
        comment.colorCode =  dict["colorCode"]! as! String
        comment.userId = dict["userId"]! as! String
        self.liveComments.append(comment)
    }
    func addJoinedUser(dict:[String: AnyObject])  {
        
        var comment = CommentMessage()
        comment.messageText = "Joined!"
        comment.name = dict["name"]! as! String
        comment.profilePic =  dict["likeProfilePic"]! as! String
        comment.colorCode =  dict["colorCode"]! as! String
        comment.userId = dict["userId"]! as! String
        self.liveComments.append(comment)
        if comment.userId == AuthService.instance.userId {
            if liveType == "single" {
            self.addRequestMessageData()
            }
        }
    
    }
    func findIfAlreadyLeft(viewers : Array<[String:AnyObject]>) {
        let userJoinedCopy = userJoined
        var removeIds = [String]()
        for i in 0..<userJoinedCopy.count {
              let dict = userJoinedCopy[i]
            var isFound = false
            for viewer in viewers {
                if dict["userId"] as! String == viewer["userId"] as! String {
                    isFound = true
                }
            }
            if !isFound {
                self.removeLeftObject(dict: dict)//                userJoined.remove(at: i)

            }
        }
    
        
        
    }
    func removeLeftObject (dict : [String:AnyObject])
    {
        for i in 0..<userJoined.count {
            let obj = userJoined[i]
            if dict["userId"] as! String == obj["userId"] as! String {
                userJoined.remove(at: i)
                return
            }
        }
    }
    func findIfAlreadyJoined(viewers : Array<[String:AnyObject]>) {
      //  self.userJoined.removeAll()
        for dict in viewers {
            var isFound = false
            for viewer in userJoined {
                if dict["userId"] as! String == viewer["userId"] as! String {
                    isFound = true
                }
            }
            if !isFound {
                userJoined.append(dict)
                self.addJoinedUser(dict: dict)
            }
        }
    }
    func findNewJoinORLeft(viewers : Array<[String:AnyObject]>)  {
        self.findIfAlreadyJoined(viewers: viewers)
       self.findIfAlreadyLeft(viewers: viewers)
    }
   
    @objc func keyboardWillAppear() {
        //Do something here
        self.commentsViewHeight.constant = 200
        self.reloadComentsView()
    }

    @objc func keyboardWillDisappear() {
        //Do something here
        self.commentsViewHeight.constant = 240
        self.reloadComentsView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.suggessionCollectionView.reloadData()
        self.startLive()
        self.reloadComentsView()
        self.getProfile()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        DispatchQueue.main.async { [self] in
            self.liveUserNameText = liveUserNameValue
            self.liveUserImageUrl = liveUserImageValue
            self.userProfileColorCode = liveUserProfileColor
            if topicValueText == "Topic" {
                self.topicValue.text = "No Topic"
            }
            else{
                self.topicValue.text = topicValueText
            }
            liveUserProfile.updateViews(name: self.liveUserNameText, url:   self.liveUserImageUrl, colorCode:   self.userProfileColorCode)
           
        }
        self.navigationController?.navigationBar.isHidden = true
        IQKeyboardManager.sharedManager().enable = false
      
        if topicValueText == "Topic" {
            self.topicValue.text = "No Topic"
        }
        else{
            self.topicValue.text = topicValueText
        }
       
        self.setUserStatucToLive()
      //  self.reloadCommentsDummyData()

    }
    func addRequestMessageData() {
       // self.liveComments.removeAll()
        var comment = CommentMessage()
        comment.messageText = "Sent a request to be in \(liveUserNameValue)'s live video."
        comment.name = ""
        comment.isJoingingRequest = "1"
        comment.friendId =  friendId
        comment.joingingRequestStatus =  "0"
        self.liveComments.append(comment)
     
    }
   func reloadComentsView()
    {
    DispatchQueue.main.async { [self] in
        
        if !followingStatus
        {
            self.followButtonwidth.constant = 30
        }
        else{
            self.followButtonwidth.constant = 0
        }
        
    if self.userCommentsCollectionView != nil {
        self.userCommentsCollectionView.reloadData()
        self.userCommentsCollectionView.contentOffset = CGPoint(x: 0, y: self.userCommentsCollectionView.contentSize.height - self.userCommentsCollectionView.bounds.size.height)
        self.userCommentsCollectionView.performBatchUpdates(nil, completion: {
            (result) in
            if self.userCommentsCollectionView.contentSize.height < 240
            {
                commentsViewHeight.constant =  self.userCommentsCollectionView.contentSize.height
            }
            else
            {
                commentsViewHeight.constant = 240
                self.userCommentsCollectionView.contentOffset = CGPoint(x: 0, y: self.userCommentsCollectionView.contentSize.height - self.userCommentsCollectionView.bounds.size.height)
            }
            
            // ready
        })
    }
    }
 

    }
    deinit {
        self.captureSession.stopRunning()
        IQKeyboardManager.sharedManager().enable = true
        appDelegate.webRTCClient.stop()
        removeKeyboardObservers()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        followAlertVC?.dismiss(animated: false, completion: nil)
        unfollowAlertVC?.dismiss(animated: false, completion: nil)
        joiningVC?.dismiss(animated: false, completion: nil)
        joiningConfirmVC?.dismiss(animated: false, completion: nil)
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(self)

    }
    @IBAction func EndLivepressed(_ sender: Any)
   {
        if appDelegate.playerClients.count == 2{
        
        self.addEndActionAlert()
    }
    else
    {
        self.closeButtonPressed((Any).self)
        
    }
   
   }
    func addEndActionAlert ()
    {
     if  let customAlert = EndLiveAlart.storyBoardInstance()
   {
     customAlert.providesPresentationContextTransitionStyle = true
     customAlert.definesPresentationContext = true
     customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
     customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
     customAlert.delegate = self
     self.present(customAlert, animated: true, completion: nil)
   }

    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {

        
            
            NotificationCenter.default.post(name: Notification.Name("EndLiveBYOtherUser"), object: nil)
            DispatchQueue.main.async { [self] in
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
          spinner.label.text = "End Live..."
            self.setUserStatusEndLive()
            }
        
       
        
      
        
    }
    @IBAction func goLiveButtonPressed(_ sender: Any) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
   
    func hideCommentesView()
    {
      
           // colorAnimationView.layer.removeAllAnimations()
        UIView.animate(withDuration: 1.0) {
            self.commentViewLeadingSpace.constant = UIScreen.main.bounds.width
                self.view.layoutIfNeeded()
            }
      
      
    }
    func showCommentesView()
    {
      
           // colorAnimationView.layer.removeAllAnimations()
        UIView.animate(withDuration: 1.0) {
            self.commentViewLeadingSpace.constant = 16
                self.view.layoutIfNeeded()
            }
    }
    private func getProfile() {
     
        DispatchQueue.global(qos:.userInteractive).async {
            self.service.getMainPage(friendId: self.friendId)
        }
        //service.getFriendProfile(friendId: friendId, notId: notId)
        
    }
    func showEndFollowingAlert()  {
        if let vc = endLiveFollowAlertVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.friendId = friendId
            vc.liveUserNameValue = liveUserNameValue
            vc.liveUserImageValue  = liveUserImageValue
            vc.liveUserProfileColor = liveUserProfileColor
            vc.liveUsertopicValue = liveUsertopicValue
            vc.followingStatus = followingStatus
            vc.profileItem = profileItem
            vc.showCloseButton = true
            self.present(vc, animated: true, completion: nil)
        }
    }
    func showFollowingAlert(showCloseButton:Bool = false)  {
        if let vc = followAlertVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.friendId = friendId
            vc.liveUserNameValue = liveUserNameValue
            vc.liveUserImageValue  = liveUserImageValue
            vc.liveUserProfileColor = liveUserProfileColor
            vc.liveUsertopicValue = liveUsertopicValue
            vc.followingStatus = followingStatus
            vc.profileItem = profileItem
            vc.showCloseButton = showCloseButton
            self.present(vc, animated: true, completion: nil)
        }
    }
    func showUnFollowingAlert()  {
        if let vc = unfollowAlertVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.friendId = friendId
            vc.liveUserNameValue = liveUserNameValue
            vc.liveUserImageValue  = liveUserImageValue
            vc.liveUserProfileColor = liveUserProfileColor
            vc.liveUsertopicValue = liveUsertopicValue
            vc.followingStatus = followingStatus
            vc.profileItem = profileItem

            self.present(vc, animated: true, completion: nil)
        }
    }
    @objc func sendRequestPressed() {
        print("Button Clicked")
      //  self.liveComments[sender.tag].messageId
        if !isSentRequest {
            if !appDelegate.webRTCViewerClient.isConnected() {
                isSentRequest = true
                self.showJoiningPopup()
                self.reloadComentsView()
            }
            else
            {
                self.showToast(message: "You are already connected")
            }
        }
        else{
            self.showToast(message: "You have already sent request")
        }
        
     
        
    }
    func showJoiningPopup()  {
        if let vc = joiningVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.friendId = friendId
            vc.liveUserNameValue = liveUserNameValue
            vc.liveUserImageValue  = liveUserImageValue
            vc.liveUserProfileColor = liveUserProfileColor
            vc.liveUsertopicValue = liveUsertopicValue
            vc.followingStatus = followingStatus
            vc.profileItem = profileItem
            self.present(vc, animated: true, completion: nil)
        }
    }
    func showJoinConfirmationPopup()  {
        if let vc = joiningConfirmVC{
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.friendId = friendId
            vc.liveUserNameValue = liveUserNameValue
            vc.liveUserImageValue  = liveUserImageValue
            vc.liveUserProfileColor = liveUserProfileColor
            vc.liveUsertopicValue = liveUsertopicValue
            vc.followingStatus = followingStatus
            vc.profileItem = profileItem
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func cameraTogglePressed(_ sender: Any) {
     //   self.swapCamera()
        isFrontCam = !isFrontCam
        if(isFrontCam)
        {
            self.smallStreamView.transform = CGAffineTransform(scaleX: -1, y: 1);
        }
        else{
            self.smallStreamView.transform = CGAffineTransform(scaleX: 1, y: 1);
        }
        appDelegate.playerClient2.switchCamera()
       
    }
    @IBAction func toggleMicButttonpressed(_ sender: Any) {
        micButton.isSelected =  !micButton.isSelected
        appDelegate.playerClient2.toggleAudio()
    }
}
extension JoinUserLiveVC: unFollowConfirmDelegate {
   
    func unFollowPressed(FriendID: String) {
       
            self.serviceFollowing.sendUnFollowRequest(friendId: FriendID)
            followingStatus = false
         
            self.reloadComentsView()

        
    }
}

extension JoinUserLiveVC: EndLiveUserFollowDelegate {

    func endLiveCloseFollowingPressed()  {
        
        NotificationCenter.default.post(name: Notification.Name("EndLiveBYOtherUser"), object: nil)
        DispatchQueue.main.async { [self] in
    let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
    spinner.mode = MBProgressHUDMode.indeterminate
      spinner.label.text = "End Live..."
        self.setUserStatusEndLive()
        }
    }
    func endLiveFollowButtonpressed(FriendID: String, toFollowStatus: Int, controller: EndLiveUserFollowPopUpVC) {
        if toFollowStatus == 0 {
            self.serviceFollowing.sendFollowRequest(friendId: FriendID)
           // let message = "Started Following" //"Successfully started following"
          //  showToast(message: message)
            followingStatus = true
            self.reloadComentsView()
            controller.dismiss(animated: true, completion: nil)
        }
        else
        {
            // Show Unfollow popup
            controller.dismiss(animated: true, completion: {
                self.showUnFollowingAlert()
            })
        
            
            
            
        }
    }

    
    func endLiveChatButtonpressed(FriendID: String, toFollowStatus: Int) {
        
        performConversationVC(friendId: friendId, profileName: liveUserNameValue, colorCode: userProfileColorCode, profileImage: liveUserImageUrl , jid: (profileItem?.jid)!, listingId: "", listingTitle: "", listingType: "", listingImg: "")
    }
    func endLiveFollowerCountPressed(FriendID : String)
    {
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
    func endLiveFollowingCountPressed(FriendID : String)
    {
        if self.profileItem!.followingCount != 0 {
            var followingsStr = "Following"
            if self.profileItem!.followersCount == 1 {
                followingsStr = "Following"
            }
            self.redirectToFollowersView(title: String(format: "%d %@", self.profileItem!.followingCount,followingsStr), isFromFollowers: false)
        }
    }

}
extension JoinUserLiveVC: LiveUserFollowDelegate {
    
    func followButtonpressed(FriendID: String, toFollowStatus: Int, controller: LiveUserFollowPopUpVC) {
        if toFollowStatus == 0 {
            self.serviceFollowing.sendFollowRequest(friendId: FriendID)
           // let message = "Started Following" //"Successfully started following"
          //  showToast(message: message)
            followingStatus = true
            self.reloadComentsView()
            controller.dismiss(animated: true, completion: nil)
        }
        else
        {
            // Show Unfollow popup
            controller.dismiss(animated: true, completion: {
                self.showUnFollowingAlert()
            })
        
            
            
            
        }
    }

    
    func chatButtonpressed(FriendID: String, toFollowStatus: Int) {
        
        performConversationVC(friendId: friendId, profileName: liveUserNameValue, colorCode: userProfileColorCode, profileImage: liveUserImageUrl , jid: (profileItem?.jid)!, listingId: "", listingTitle: "", listingType: "", listingImg: "")
    }
    func followerCountPressed(FriendID : String)
    {
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
    func FollowingCountPressed(FriendID : String)
    {
        if self.profileItem!.followingCount != 0 {
            var followingsStr = "Following"
            if self.profileItem!.followersCount == 1 {
                followingsStr = "Following"
            }
            self.redirectToFollowersView(title: String(format: "%d %@", self.profileItem!.followingCount,followingsStr), isFromFollowers: false)
        }
    }
    func redirectToFollowersView(title: String, isFromFollowers: Bool) {
        let vc = LikesController()
        vc.title = title
        vc.followUserId = friendId
        vc.isFollower = isFromFollowers
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension JoinUserLiveVC: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> JoinUserLiveVC?{
        return UIStoryboard(name: StoryBoard.LIVE, bundle: nil).instantiateViewController(withIdentifier: JoinUserLiveVC.id) as? JoinUserLiveVC
    }
}
//https://34.207.130.236:5080/WebRTCAppEE/conference.html
extension JoinUserLiveVC {
    
    func joinConferenceCall()  {
        
        let joiningRoom = "stream1room\(liveID)"
        let streamId = "stream2room\(liveID)"
        remoteViews.append(cameraView)
        remoteViews.append(smallStreamView)
        AntMediaClient.setDebug(true)
        appDelegate.conferenceClient = ConferenceClient.init(serverURL: Endpoints.LiveUser, conferenceClientDelegate: self)
        appDelegate.conferenceClient.joinRoom(roomId: joiningRoom, streamId: streamId)
        
    }
    @objc func startLive()
    {
       
     print("live Type is : \(liveType)")
//
       // self.joinConferenceCall()
        appDelegate.webRTCClient.setOptions(url: Endpoints.LiveUser , streamId: "stream1room\(liveID)" , token: "", mode: .play, enableDataChannel: true)
        appDelegate.isStreamer = false
        appDelegate.liveID = liveID
        appDelegate.webRTCClient.setDebug(true)
        appDelegate.webRTCClient.start()

     
        if liveType != "single" {
            self.playJoiningStream()
        }
        
    }
    @objc func setUserStatucToLive()  {
        DispatchQueue.global(qos:.userInteractive).async { [self] in
        let op = UserLiveOperations()
            op.userViewLive (id: "\(AuthService.instance.userId)", liveid: liveID ) { (onlineStat) in
                if let online = onlineStat["liveid"] as? String{
                 //   self.liveID = online
                
                }

                print(onlineStat)
        }
        }
    }
    func addTimerCall()  {
        timer.invalidate() // just in case this button is tapped multiple times

              // start the timer
        timer = Timer.scheduledTimer(timeInterval: 3 , target: self, selector: #selector(self.getLiveStatus), userInfo: nil, repeats: true)

    }
    @objc func getLiveStatus()  {
        DispatchQueue.global(qos:.userInteractive).async { [self] in
        let op = UserLiveOperations()
            op.allUsersLiveStatus (id: "\(AuthService.instance.userId)" , LiveId: liveID) { (onlineStat) in
               
                DispatchQueue.main.async { [self] in
                    
                    if let error = onlineStat["error"] as? Bool{
                        if !error{
                            if let views = onlineStat["viewData"] as? Array<[String:AnyObject]> {
                               
                                numberOfViews.text = "\(views.count)"
                                self.findNewJoinORLeft(viewers: views)
                            }
                        }
                        else
                        {
                            numberOfViews.text = "\(0)"
                            self.findNewJoinORLeft(viewers: Array<[String : AnyObject]>())

                        }
                    }
                    print(onlineStat)
                }
              
        }
        }
    }
    @objc func setUserStatusEndLive()  {
        DispatchQueue.global(qos:.userInteractive).async {
        let op = UserLiveOperations()
            op.userEndViewLive(id: "\(AuthService.instance.userId)", liveid: self.liveID) { (onlineStat) in
                DispatchQueue.main.async { [self] in
              MBProgressHUD.hide(for: self.view , animated: true)
                   
                    self.navigationController?.navigationBar.isHidden = false
                    self.showToast(message: "Live has been finished!")
                    for client in self.appDelegate.playerClients
                    {
                        client.playerClient.stop();
                    }
                   if self.appDelegate.conferenceClient != nil
                    {
                    self.appDelegate.conferenceClient.leaveRoom()
                    }
                    appDelegate.webRTCClient.stop()
                self.navigationController?.popToRootViewController(animated: true)
                  }
             
                print(onlineStat)
        }
        }
    }
    func cancelButtonTapped() {
        print("cancelButtonTapped")
        self.navigationController?.navigationBar.isHidden = false

        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension JoinUserLiveVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == suggessionCollectionView {
       return 1
        }
        else
        {
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == suggessionCollectionView {
            print("Suggession Count : \(suggessionList.count)")
            return suggessionList.count
        }
        else{
        if section == 0 {
            guard let _ = profileItem else { return 0}
            if isNeedToShowFollowing == 1 {
                return 1
            }
          else
            {
                return 0
            }
        }
        else{
        return self.liveComments.count
        }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == suggessionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveSuggessionCell.identifier, for: indexPath) as? LiveSuggessionCell else {
                
                return UICollectionViewCell()
                
            }
            cell.configCell( item: self.suggessionList[indexPath.row] )
            return cell
            
        }
        else{
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveUserFollowCell.identifier, for: indexPath) as? LiveUserFollowCell else { return UICollectionViewCell()}
            cell.configCell(followStatus: followingStatus, name: liveUserNameValue , profilePic: liveUserImageUrl , colorCode: liveUserProfileColor )
            return cell
        }
        else{
        
          let message =   self.liveComments[indexPath.row]
            if message.isJoingingRequest == "1" {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewerJoinRequestCell.identifier, for: indexPath) as? ViewerJoinRequestCell else { return UICollectionViewCell()}
                cell.configCell(item: self.liveComments[indexPath.row] )
                if isSentRequest {
                    cell.requestButton.setTitle("Requested", for: .normal)
                }
                else
                {
                    cell.requestButton.setTitle("Request", for: .normal)
                }
                cell.profileView.isHidden = true
                cell.imagePlaceholder.isHidden = false
               
                cell.requestButton.tag = indexPath.row
                cell.requestButton.addTarget(self, action:#selector(self.sendRequestPressed), for: .touchUpInside)
                
                    cell.setNeedsLayout()
                    cell.layoutIfNeeded()
                return cell
            }
            else{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveUserCommentsCell.identifier, for: indexPath) as? LiveUserCommentsCell else { return UICollectionViewCell()}
        cell.configCell(item: self.liveComments[indexPath.row] )
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        return cell
            }
        }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        if collectionView == suggessionCollectionView {
           // return UICollectionViewFlowLayout.automaticSize
            let message =  self.suggessionList[indexPath.row]
          
            return CGSize(width:message.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16)), height: 40)
        }
        else{
            
        if indexPath.section == 0 {
            return CGSize(width:self.userCommentsCollectionView.frame.size.width, height: 50)
        }
        else{
            //let width = self.frame.width
            let message =   self.liveComments[indexPath.row]
              if message.isJoingingRequest == "1" {
                return CGSize(width:self.userCommentsCollectionView.frame.size.width, height: 50)
              }
            else
              {
           
            let  textString = self.liveComments[indexPath.row].messageText
            var height = textString.height(constraintedWidth: self.userCommentsCollectionView.frame.size.width-38, font: UIFont.systemFont(ofSize: 13) )
            if height < 30
            {
                height = 30
            }
            else
            {
                height = height+10
            }
            return CGSize(width:self.userCommentsCollectionView.frame.size.width, height: height)
              }
        }
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
                // No insets for header in section 0
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        else
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == suggessionCollectionView {
            self.sendSuggestionMessage(message: self.suggessionList[indexPath.row])
            self.updateSuggessionList()
            suggessionCollectionView.reloadData()
            suggessionCollectionView.invalidateIntrinsicContentSize()
            suggessionCollectionView.layoutIfNeeded()
        }
        else{
        if indexPath.section == 0 {
            if !followingStatus
            {
                
                self.serviceFollowing.sendFollowRequest(friendId: self.friendId)
                let message = "Started Following" //"Successfully started following"
                showToast(message: message)
                
                followingStatus = true
                self.reloadComentsView()
            }
            else
            {
                self.showFollowingAlert()
            }
        }
        }
}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }

}
extension JoinUserLiveVC : ProfileServiceDelegate{
    
    func DidReceiveError(error: String) {
    }
    
    func DidReceiveProfileData(item: ProfileData) {
        
        DispatchQueue.main.sync {
            
            self.profileItem = item
//            self.profileItem?.profilePic = liveUserProfile
//            self.profileItem?.colorCode = liveUserProfileColor
//            self.profileItem?.name = liveUserName

            if profileItem?.followStatusType != 2
            {
                self.followButtonwidth.constant = 30
                followingStatus = false
                isNeedToShowFollowing = 1
            }
            else{
                self.followButtonwidth.constant = 0
                followingStatus = true
                isNeedToShowFollowing = 0

            }
            self.userCommentsCollectionView.reloadData()
            self.reloadComentsView()
          //  self.collectionView.reloadData()
            //self.stopRefreshing()
        }
    }
    
    func DidReceiveFeedItems(items: [FeedV2Item],pictureItems: [PictureURL]) {
        
    }
    
}
extension JoinUserLiveVC : MemberDelegate{
    func DidReceivedData(data: [MemberItem]) {
        DispatchQueue.main.async {
            self.getProfile()
        }
    }
    
    func DidReceivedError(error: String) {
        print(error)
        //if self.active.isAnimating{ self.active.stopAnimating() }
        DispatchQueue.main.async {
         
        }
        
        
    }
}
extension JoinUserLiveVC : ViewerSideJoinRequestDelegate{
    
    func SendRequestPressed(FriendID: String, controller: ViewerSideJoinRequestPopUp) {
        
        let dic = ["fullName": AuthService.instance.fullName,"isJoingingRequest": "1","joingingRequestStatus": "0","OnlyForStreamer": "1","friendId": friendId, "profilePic": AuthService.instance.profilePic ,"StreamStarted": "0", "message": "\(AuthService.instance.fullName) Sent a request to be in your live video.", "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId]
        
        let data = NSKeyedArchiver.archivedData(withRootObject: dic)
        appDelegate.webRTCClient.sendData(data: data, binary: false)
    }
    
   
}
extension JoinUserLiveVC : ViewerSideJoinConfirmDelegate{
    
    func acceptJoinRequest(FriendID: String, controller: ViewerSideJoinConfirmPopUp) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               //call any function
          //  self.startJoiningStream()
            self.joinConferenceCall()
           }
     
    }
    
  
    
   
}
extension JoinUserLiveVC : AntMediaClientDelegate
{
    
    func remoteStreamStarted(streamId: String) {
        
    }
    
    func remoteStreamRemoved(streamId: String) {
        DispatchQueue.main.async { [self] in
            self.showEndFollowingAlert()
           // self.closeButtonPressed(UIButton())
       // self.setUserStatusToLive(status: "s")
        }
    }
    
    func localStreamStarted(streamId: String) {
        // send message to user that stream started
  
        let dic = ["fullName": AuthService.instance.fullName,"isJoingingRequest": "1","joingingRequestStatus": "1","OnlyForStreamer": "0","StreamStarted": "1","friendId": friendId, "profilePic": AuthService.instance.profilePic , "message": "\(AuthService.instance.fullName) Sent a request to be in your live video.", "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId,"timestamp": timeStampStarted ]
      
        let data = NSKeyedArchiver.archivedData(withRootObject: dic)
        appDelegate.webRTCClient.sendData(data: data, binary: false)
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = false
        micButton.isHidden = false
        cameraToggleButton.isHidden = false
            MBProgressHUD.hide(for: self.view , animated: true)

            if appDelegate.playerClient1.isConnected()
            {
                self.setUserStatusToLive(status: "dual")
            }
        }
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)

    }
    
    func playStarted(streamId: String) {
        //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playStarted"), object: nil, userInfo: nil)
           DispatchQueue.main.async { [self] in
               smallCameraContainer.isHidden = false
               MBProgressHUD.hide(for: self.view , animated: true)
            if appDelegate.playerClient1.isConnected()
            {
                self.setUserStatusToLive(status: "dual")
            }
             
               
           }
       }
    
    func playFinished(streamId: String) {
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = true
          //  appDelegate.webRTCViewerClient.stop()
         //   self.setUserStatusToLive(status: "single")
            self.showEndFollowingAlert()
        }
    //    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playFinished"), object: nil, userInfo: nil)
    }
    
    func publishStarted(streamId: String) {
        DispatchQueue.main.async { [self] in
        self.cameraView.transform = CGAffineTransform(scaleX: -1, y: 1);
        }
    }
    
    func publishFinished(streamId: String) {
        
    }
    
    func disconnected(streamId: String) {
        
    }
    
    func audioSessionDidStartPlayOrRecord(streamId: String) {
        if streamId.contains("stream1room")
        {
            appDelegate.playerClient1.speakerOn()
        }
        else
        {
            appDelegate.playerClient2.speakerOn()
        }
    }
    
    func streamInformation(streamInfo: [StreamInformation]) {
        
    }
    func clientDidConnect(_ client: AntMediaClient) {
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)
      
        
    }
    
    func clientDidDisconnect(_ message: String) {
      //  print("Stream get error \(message)")
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = true
        micButton.isHidden = true
        cameraToggleButton.isHidden = true
            appDelegate.webRTCViewerClient.stop()
        }
    }
    
    func clientHasError(_ message: String) {
//        print("Stream get error \(message)")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clientHasError"), object: nil, userInfo: nil)
    }
 
    
 
    
    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        
//        do {
//
//            let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: data)
//
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecievedMessage"), object: nil, userInfo: unarchivedDictionary as? [String: AnyObject])
//
//
//
//
//        }
//        catch{
//            print(error)
//        }
}
}
//https://34.207.130.236:5080/WebRTCAppEE/conference.html
extension JoinUserLiveVC {

    @objc func startJoiningStream()
    {
        DispatchQueue.main.async { [self]
                let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinner.mode = MBProgressHUDMode.indeterminate
                spinner.isUserInteractionEnabled = false
                spinner.label.text = "Connecting..."
            }
    
        print("room\(liveID)")
        timeStampStarted = "\(Int(Date().timeIntervalSince1970))"
       // appDelegate.webRTCViewerClient.stop()
        self.joinConferenceCall()
//        var  webRTCViewerClient: AntMediaClient = AntMediaClient.init()
//        webRTCViewerClient.delegate = self
//        webRTCViewerClient.setLocalView(container: smallStreamView, mode: .scaleAspectFill)
//       self.appDelegate.webRTCViewerClient = webRTCViewerClient
//        appDelegate.webRTCViewerClient.setOptions(url: Endpoints.LiveUser , streamId: "stream2room\(liveID)" , token: "", mode: .publish, enableDataChannel: true)
//        appDelegate.webRTCViewerClient.setDebug(true)
//        appDelegate.webRTCViewerClient.start()
        
    }
    @objc func playJoiningStream()
    {
        DispatchQueue.main.async { [self]
                let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinner.mode = MBProgressHUDMode.indeterminate
                spinner.isUserInteractionEnabled = false
                spinner.label.text = "Connecting..."
            }
        print("room\(liveID)")
        self.appDelegate.playerClient2 = AntMediaClient.init()
        self.appDelegate.playerClient2.delegate = self
        self.appDelegate.playerClient2.setRemoteView(remoteContainer: self.smallStreamView, mode: .scaleAspectFill)
        self.appDelegate.playerClient2.setOptions(url: Endpoints.LiveUser , streamId: "stream2room\(liveID)" , token: "", mode: .play, enableDataChannel: true)
        self.appDelegate.playerClient2.setDebug(true)
        self.appDelegate.playerClient2.start()
    }
    @objc func setUserStatusToLive(status : String)  {
        DispatchQueue.global(qos:.userInteractive).async { [weak self] in
        let op = UserLiveOperations()
            op.UpdateUserStatus (id: "\(AuthService.instance.userId)",Status: status ) { (onlineStat) in
                print(onlineStat)
        }
        }
    }
    @objc func setUserStatusEndDualLive()  {
        DispatchQueue.global(qos:.userInteractive).async {
        let op = UserLiveOperations()
            op.userEndViewLive(id: "\(AuthService.instance.userId)", liveid: self.liveID) { (onlineStat) in
                DispatchQueue.main.async { [self] in
              MBProgressHUD.hide(for: self.view , animated: true)
                    appDelegate.webRTCViewerClient.stop()
                  }
             
                print(onlineStat)
        }
        }
    }
}
extension JoinUserLiveVC: EndLiveViewDelegate {
    
    func okEndLiveButtonTapped(selectedOption: String, textFieldValue: String) {
        appDelegate.webRTCViewerClient.stop()
//        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
//        spinner.mode = MBProgressHUDMode.indeterminate
//        spinner.label.text = "End Live..."
        self.setUserStatusEndLive()

    }

    func cancelEndLiveButtonTapped() {
     
    }
}
extension JoinUserLiveVC: ConferenceClientDelegate
{
    public func streamIdToPublish(streamId: String) {
        
        Run.onMainThread {
            
                AntMediaClient.printf("stream in the room: \(streamId)")
            let playerClient2 = AntMediaClient.init()
            playerClient2.delegate = self;
            playerClient2.setOptions(url:  Endpoints.LiveUser , streamId: streamId, token: "", mode: AntMediaClientMode.publish, enableDataChannel: false)
                
                var freeIndex: Int = -1
                for (index,free) in self.viewFree.enumerated() {
                    if (free) {
                        freeIndex = index;
                        self.viewFree[index] = false;
                        break;
                    }
                }
                if (freeIndex == -1) {
                    AntMediaClient.printf("Problem in free view index")
                }
             //   playerClient.setRemoteView(remoteContainer: )
            playerClient2.setLocalView(container: self.remoteViews[freeIndex], mode: .scaleAspectFill)
            playerClient2.initPeerConnection()
            playerClient2.start()
            self.remoteViews[freeIndex].isHidden = false
                let playerConferenceClient = AntMediaClientConference.init(player: playerClient2, index: freeIndex);
            self.appDelegate.playerClients.append(playerConferenceClient)
            self.appDelegate.playerClient2 = playerClient2
            }
            //
//            self.appDelegate.webRTCClient.stop()
//                //self.appDelegate.webRTCClient.setOptions(url: Endpoints.LiveUser , streamId: streamId , token: "", mode: .publish, enableDataChannel: true)
//                self.appDelegate.webRTCClient.setOptions(url: Endpoints.LiveUser, streamId: streamId, token: "", mode: AntMediaClientMode.publish, enableDataChannel: false)
//            self.appDelegate.webRTCClient.setLocalView(container: self.cameraView, mode: .scaleAspectFill)
//                self.appDelegate.webRTCClient.initPeerConnection()
//                self.appDelegate.webRTCClient.start()
//                self.appDelegate.isStreamer = true
//                self.smallCameraContainer.isHidden = true
                
            
           
    }
       
    public func newStreamsJoined(streams: [String]) {
        
        AntMediaClient.printf("Room current capacity: \(self.appDelegate.playerClients.count)")
        if (self.appDelegate.playerClients.count == 1) {
            AntMediaClient.printf("Room is full")
            return
        }
        Run.onMainThread {
            
        
            for stream in streams
            {
                AntMediaClient.printf("stream in the room: \(stream)")
                
                let playerClient1 = AntMediaClient.init()
                playerClient1.delegate = self;
                playerClient1.setOptions(url:  Endpoints.LiveUser , streamId: stream, token: "", mode: AntMediaClientMode.play, enableDataChannel: false)
                
                var freeIndex: Int = -1
                for (index,free) in self.viewFree.enumerated() {
                    if (free) {
                        freeIndex = index;
                        self.viewFree[index] = false;
                        break;
                    }
                }
                if (freeIndex == -1) {
                    AntMediaClient.printf("Problem in free view index")
                }
             //   playerClient.setRemoteView(remoteContainer: )
                playerClient1.setRemoteView(remoteContainer: self.remoteViews[freeIndex], mode: .scaleAspectFill)
                playerClient1.initPeerConnection()
                playerClient1.start()
                self.remoteViews[freeIndex].isHidden = false
                
                let playerConferenceClient = AntMediaClientConference.init(player: playerClient1, index: freeIndex);
                
                self.appDelegate.playerClients.append(playerConferenceClient)
                self.appDelegate.playerClient1 = playerClient1
            }
        }
       
           
    }
       
    public func streamsLeaved(streams: [String]) {
        
        Run.onMainThread {
            var leavedClientIndex:[Int] = []
            for streamId in streams
            {
                for  (clientIndex,conferenceClient) in self.appDelegate.playerClients.enumerated()
                {
                    if (conferenceClient.playerClient.getStreamId() == streamId) {
                        conferenceClient.playerClient.stop();
                        self.remoteViews[conferenceClient.viewIndex].isHidden = true
                        self.viewFree[conferenceClient.viewIndex] = true
                        leavedClientIndex.append(clientIndex)
                        break;
                    }
                }
            }
            
            for index in leavedClientIndex {
                self.appDelegate.playerClients.remove(at: index);
            }
        }
    }
}
extension Array {
    func randomItem() -> String? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return (self[index] as! String)
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
