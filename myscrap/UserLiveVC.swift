//
//  UserLiveVC.swift
//  myscrap
//
//  Created by Hassan Jaffri on 1/2/21.
//  Copyright © 2021 MyScrap. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import IQKeyboardManagerSwift
import Photos
struct CommentMessage {
    
    var name : String = "Test"
    var userId : String = "Test"
    var profilePic : String = "Test"
    var colorCode : String = "Test"
    var messageId : String = "Test"
    var messageText : String = "Test"
    var friendId : String = ""
    var OnlyForStreamer : String = "0"
    var isJoingingRequest : String = "0"
    var joingingRequestStatus : String = "0"
    var streamStarted : String = "0"
    var requestId : String = "0"
    var timeStamp : Int =  (Int(Date().timeIntervalSince1970))
}
class UserLiveVC: UIViewController,KeyboardAvoidable ,UITextFieldDelegate{

    var isEndLivePressed = false
    var liveID = "0"
    var isFrontCam = true
    var liveComments = [CommentMessage]()
    {
        didSet
        {
            self.reloadComentsView()
        }
        
    }

      
      @IBOutlet var localView: UIView!
 
          
      var remoteViews:[UIView] = []
      
      var viewFree:[Bool] = [true, true, true, true]
       var playerClients:[AntMediaClientConference] = [];

    @IBOutlet weak var smallStreamView: UIView!
    @IBOutlet weak var commentsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTraining: NSLayoutConstraint!
    @IBOutlet weak var liveLableLeading: NSLayoutConstraint!
    @IBOutlet weak var liveLableTraining: NSLayoutConstraint!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var largeCameraContainer: UIView!
    @IBOutlet weak var smallCameraContainer: UIView!
    @IBOutlet weak var commentLeading: NSLayoutConstraint!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var commentViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var liveTimerView: UIView!
    @IBOutlet weak var liveTimerTextLable: UILabel!
    @IBOutlet weak var seenIcon: UIImageView!
    @IBOutlet weak var seenView: UIView!
    @IBOutlet weak var countDown: SFCountdownView!
    var layoutConstraintsToAdjust: [NSLayoutConstraint] = []
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraToggleButton: UIButton!

    @IBOutlet weak var UserCommentsBackground: UIView!
    @IBOutlet weak var userCommentsCollectionView: UICollectionView!

    let joiningVC = StreamerSideJoinRequestPopUp.storyBoardInstance()
    let onlineViewer = OnlineViewersPopUpVC.storyBoardInstance()
    let downloadEndsLivePopup = EndLiveDownloadPopUpVC.storyBoardInstance()
    
    var topicValueText = "No Topic"
    var userJoined = Array<[String:AnyObject]>()
    var userLeft = Array<[String:AnyObject]>()
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    var timer = Timer()
    var liveTimeCount = Timer()
    var liveTimeValue = 0
    var isPlaying : Bool = false
    var playingUserId : String = ""
    @IBOutlet weak var announceImage: UIImageView!
    @IBOutlet weak var commentBackground: UIView!
    var cameraflipedView: UIView = UIView()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
     
        appDelegate.directionDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.likeCommentNotificationReciveLive), name: NSNotification.Name(rawValue: "LikeCommentNotificationReciveLive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.followNotificationReciveLive), name: NSNotification.Name(rawValue: "FollowNotificationReciveLive"), object: nil)

        
        
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
        
        self.navigationController?.navigationBar.isHidden = true
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        self.topicTtitle.text = "Topic :"
        self.topicValue.text = topicValueText
        commentField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        announcementView.layer.cornerRadius =  announcementView.frame.size.height/2
        commentBackground.layer.cornerRadius =  commentBackground.frame.size.height/2
        commentBackground.layer.borderWidth =  3
        commentBackground.layer.borderColor =  UIColor.gray.cgColor
        
        commentField.autocorrectionType = .no
        
        self.countDown.isHidden = true
        
        self.countDown.backgroundAlpha = 0.2;
        self.countDown.countdownColor = UIColor.black;
        self.countDown.countdownFrom = 3;
        self.countDown.finishText = "";
        self.countDown.updateAppearance()
        
  
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.OnlineViewTapped(_:)))

        self.seenView.addGestureRecognizer(tap)

        self.seenView.isUserInteractionEnabled = true
        
        let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        sendCommentButton.setImage(image, for: .normal)
        sendCommentButton.tintColor = UIColor.gray
        commentField.textColor = UIColor.gray
        sendCommentButton.isHidden = true

        commentField.delegate = self
        
        let imageMic = UIImage(named: "ic_mic")?.withRenderingMode(.alwaysTemplate)
        micButton.setImage(imageMic, for: .normal)
        
        let imageMicMute = UIImage(named: "ic_muteMic")?.withRenderingMode(.alwaysTemplate)
        micButton.setImage(imageMicMute, for: .selected)
        micButton.tintColor = UIColor.white
        micButton.drawShadow()
        
        let imageCam = UIImage(named: "ic_rotate_camera")?.withRenderingMode(.alwaysTemplate)
        cameraToggleButton.setImage(imageCam, for: .normal)
        cameraToggleButton.tintColor = UIColor.white
        cameraToggleButton.drawShadow()
        
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
        closebutton.drawShadow()
        smallCameraContainer.isHidden = true
        appDelegate.webRTCViewerClient.delegate = self
        appDelegate.webRTCViewerClient.setRemoteView(remoteContainer: smallStreamView, mode: .scaleAspectFill)
        
        liveTimerView.layer.cornerRadius = 5
        liveTimerView.clipsToBounds = true
        liveTimerView.isHidden = true
        seenView.layer.cornerRadius = 5
        seenView.clipsToBounds = true

        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(tappedOnSmallWindow(tapGestureRecognizer:)))
        smallCameraContainer.isUserInteractionEnabled = true
        smallCameraContainer.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnTopic(tapGestureRecognizer:)))
        announcementView.isUserInteractionEnabled = true
        announcementView.addGestureRecognizer(tapGestureRecognizer)
        layoutConstraintsToAdjust.append(constraintContentHeight)
        //https://34.207.130.236:5080/WebRTCAppEE/peer.html
        self.setUpCamera()
        self.setUpCommentViews()
        addKeyboardObservers()
    
        self.cameraflipedView.frame =  self.largeCameraContainer.frame
        self.cameraflipedView.transform = CGAffineTransform(scaleX: -1, y: 1);
        
        self.FlipFrontCameraSinglelive()
        self.FlipFrontCameraStreamerUser(isFront: true)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
       
    }
    func addNotificcationObserver()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.RecievedMessage(_:)), name: NSNotification.Name(rawValue: "RecievedMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PublishStarted(_:)), name: NSNotification.Name(rawValue: "PublishStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.AppCloseed(_:)), name: NSNotification.Name(rawValue: "AppCloseed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ConnectionEstablished(_:)), name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.CameraToggleSingleLive(_:)), name: NSNotification.Name(rawValue: "CameraToggleSingleLive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.CameraToggleDualLive(_:)), name: NSNotification.Name(rawValue: "CameraToggleDualLive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clientHasErrorInSteam(_:)), name: NSNotification.Name(rawValue: "clientHasError"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.clientHasErrorInSteam(_:)), name: NSNotification.Name(rawValue: "clientDidDisconnect"), object: nil)
        
    }
    func FlipFrontCameraSinglelive()  {
        DispatchQueue.main.async { [weak self] in
            if(self!.isFrontCam)
            {
             self?.cameraView.transform = CGAffineTransform(scaleX: -1, y: 1);
                self?.cameraView.tag = 1
            }
            else{
         self?.cameraView.transform = CGAffineTransform(scaleX: 1, y: 1);
                self?.cameraView.tag = 0
            }
          
        }
    }
    func FlipFrontCameraStreamerUser(isFront : Bool = true)  {
        DispatchQueue.main.async { [weak self] in
            if(isFront)
            {
             self?.smallStreamView.transform = CGAffineTransform(scaleX: -1, y: 1);
                self?.smallStreamView.tag = 1
            }
            else{
             self?.smallStreamView.transform = CGAffineTransform(scaleX: 1, y: 1);
                self?.smallStreamView.tag = 0
            }
          
        }
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
    
    @objc func CameraToggleDualLive(_ notification: NSNotification) {
            print(notification.userInfo ?? "")
        if let dict = notification.userInfo as? [String: AnyObject]{
            if let cameraToggle = dict["CameraToggle"]  as? String {
                if cameraToggle == "1" {

                    DispatchQueue.main.async { [self] in
                    let frontCam = dict["isFrontCam"] as? String ?? "0"
                    if frontCam == "1"
                    {
                        self.FlipFrontCameraStreamerUser(isFront: true)

                    }
                    else
                    {
                        self.FlipFrontCameraStreamerUser(isFront: false)
                    }
                    }
                }
            }

        }
    }
    @objc func CameraToggleSingleLive(_ notification: NSNotification) {
            print(notification.userInfo ?? "")
        if let dict = notification.userInfo as? [String: AnyObject]{
            if let cameraToggle = dict["CameraToggle"]  as? String {
                if cameraToggle == "1" {

                    DispatchQueue.main.async { [self] in
                    let frontCam = dict["isFrontCam"] as? String ?? "0"
                    if frontCam == "1"
                    {
                        if self.smallStreamView.tag != 1 {
                            self.smallStreamView.transform = CGAffineTransform(scaleX: -1, y: 1);
                            self.smallStreamView.tag = 1
                        }

                    }
                    else
                    {
                        if self.smallStreamView.tag != 0 {
                        self.smallStreamView.transform = CGAffineTransform(scaleX: 1, y: 1);
                            self.smallStreamView.tag = 0
                        }
                    }
                    }
                }
            }

        }
    }
    @objc func clientHasErrorInSteam(_ notification: NSNotification) {
        
          
                DispatchQueue.main.async { [self] in
                    if   !self.isEndLivePressed  {
                    if self.liveTimeValue < 5
                    {
                        self.showMessage(with: "Connectivity issue,  live disconnected")
                        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                        spinner.mode = MBProgressHUDMode.indeterminate
                        spinner.label.text = "Disconnecting..."
                        self.setUserStatusEndLive()
                    }
                    else
                    {
                        self.endLiveTimmer()
        
                        if let vc = downloadEndsLivePopup {
                            vc.modalPresentationStyle = .overFullScreen
                            vc.delegate = self
                            if !vc.isModal {
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                    }
 
        }
    }
    @objc func RecievedMessage(_ notification: NSNotification) {
            print(notification.userInfo ?? "")
        if let dict = notification.userInfo as? [String: AnyObject]{
            var comment = CommentMessage()
            comment.messageText = dict["message"] as? String ?? ""
            comment.name = dict["fullName"] as? String ?? ""
            comment.profilePic =  dict["profilePic"] as? String ?? ""
            comment.colorCode =  dict["colorCode"] as? String ?? ""
            comment.userId = dict["userId"] as? String ?? ""
            comment.friendId = dict["friendId"] as? String ?? ""
            comment.isJoingingRequest = dict["isJoingingRequest"] as? String ?? ""
            comment.joingingRequestStatus = dict["joingingRequestStatus"] as? String ?? ""
            comment.streamStarted = dict["StreamStarted"] as? String ?? ""
            
            
            
            if comment.streamStarted == "1" {
                // Play Stream
                playingUserId = dict["userId"] as? String ?? ""
               
                
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.appDelegate.webRTCViewerClient.stop()
//                      var  webRTCViewerClient: AntMediaClient = AntMediaClient.init()
//                        webRTCViewerClient.delegate = self
//                        webRTCViewerClient.setRemoteView(remoteContainer: self.smallStreamView, mode: .scaleAspectFill)
//
//                        self.appDelegate.webRTCViewerClient = webRTCViewerClient
                      self.startConferenceCall(steamId: "stream2room\(self.liveID)")

                  //      self.playJoiningStream()
                    
                }
//                else
//                {
//                  //  self.playJoiningStream(timeStamp:timeStamp)
//                }
                
              
            }
            else{
                self.liveComments.append(comment)
            }

        }
    }
    @objc func AppCloseed(_ notification: NSNotification) {
        DispatchQueue.main.async { [self] in
            self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.popToRootViewController(animated: true)
        }
     }
    @objc func PublishStarted(_ notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
    //    MBProgressHUD.hide(for: self.view , animated: true)
//            self?.videoPreviewLayer.removeFromSuperlayer()
//            self?.captureSession.stopRunning()
            self?.FlipFrontCameraSinglelive()
            
            self?.addTimerCall()
            self?.startLiveTime()
        }
     }
    @objc func ConnectionEstablished(_ notification: NSNotification) {
        self.FlipFrontCameraSinglelive()
     }
    @objc func OnlineViewTapped(_ sender: UITapGestureRecognizer) {
        if userJoined.count > 0 {
            if let vc = onlineViewer {
                vc.modalPresentationStyle = .overFullScreen
                vc.delegateOnlineViewer = self
                vc.userJoined = userJoined
                vc.indexValue = 0
                if !vc.isModal {
                    self.present(vc, animated: true, completion: nil)
                }
            }
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
        }
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("right swipe")
                self.hideAllViewOnSwipe()
                self.hideCommentesView()
            case UISwipeGestureRecognizer.Direction.left:
                print("left swipe")
                self.showAllViewOnSwipe()
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
        let layout = FadingLayout(scrollDirection: .vertical)
      
        self.userCommentsCollectionView.setCollectionViewLayout(layout, animated: false)
        
        self.userCommentsCollectionView.register(LiveUserCommentsCell.Nib, forCellWithReuseIdentifier: LiveUserCommentsCell.identifier)
        self.userCommentsCollectionView.register(ViewerJoinRequestCell.Nib, forCellWithReuseIdentifier: ViewerJoinRequestCell.identifier)
        
//        if let flowLayout = userCommentsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//           }
    }
    @objc func tappedOnSmallWindow(tapGestureRecognizer: UITapGestureRecognizer){
        
        self.videoPreviewLayer.removeFromSuperlayer()
        self.cameraflipedView.removeFromSuperview()
        
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
    @objc func tappedOnTopic(tapGestureRecognizer: UITapGestureRecognizer){

        //self.addTopic()

        // Your action
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
    
        // Setup your camera here...
    }
   func addActionAlert ()
   {
    if  let customAlert = LiveActionAlert.storyBoardInstance()
  {
    customAlert.providesPresentationContextTransitionStyle = true
    customAlert.definesPresentationContext = true
    customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    customAlert.delegate = self
   if !customAlert.isModal {
            self.present(customAlert, animated: true, completion: nil)
        }
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
        if !customAlert.isModal {
             self.present(customAlert, animated: true, completion: nil)
         }
  //   self.present(customAlert, animated: true, completion: nil)
   }

    }
    @IBAction func sendCommentPressed(_ sender: Any) {
        
        if commentField.text!.length > 0 {
            var comment = CommentMessage()
            comment.messageText = commentField.text!
            comment.name = AuthService.instance.fullName
            comment.profilePic = AuthService.instance.profilePic
            comment.colorCode = AuthService.instance.colorCode
            comment.userId = AuthService.instance.userId
            print("Messages Count : \( self.liveComments.count)")
            self.liveComments.append(comment)
            
            let dic = ["fullName": AuthService.instance.fullName,"isJoingingRequest": "0","joingingRequestStatus": "0","OnlyForStreamer": "0","StreamStarted": "0","friendId": "" , "profilePic": AuthService.instance.profilePic , "message": commentField.text!, "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId]
            
    
            /* NSDictionary to NSData */
            let data = NSKeyedArchiver.archivedData(withRootObject: dic)
            appDelegate.webRTCClient.sendData(data: data, binary: false)

            commentField.text = ""
            sendCommentButton.tintColor = UIColor.MyScrapGreen
            sendCommentButton.isHidden = true
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

        self.largeCameraContainer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height+20)
        self.cameraView.frame = self.largeCameraContainer.frame
        self.cameraflipedView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height+40)
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
     //   cameraflipedView.bounds = screenSize
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.videoPreviewLayer.frame =  CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height+40)
        cameraflipedView.layer.addSublayer(videoPreviewLayer)
   //     cameraView.layer.addSublayer(cameraflipedView.layer)
        cameraView.addSubview(cameraflipedView)
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
        self.view.layoutIfNeeded()
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
    private func startLiveTime() {
        MBProgressHUD.hide(for: self.view , animated: true)
        liveTimerView.isHidden = false
        liveTimeCount = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
       }
    private func endLiveTimmer() {
        liveTimeValue = 0
        liveTimerView.isHidden = true
        liveTimeCount.invalidate()
       }
    @objc func currentTime() {
        liveTimeValue += 1
        var liveTimeText = ""
        if liveTimeValue < 10 {
            liveTimeText = "00:0\(liveTimeValue)"
        }
       else if liveTimeValue < 60 {
        liveTimeText = "00:\(liveTimeValue)"
        }
       else{
        let minute = liveTimeValue/60
        let second = liveTimeValue%60
        if minute < 10 &&  second < 10 {
            liveTimeText = "0\(minute):0\(second)"
        }
       else if minute > 10 &&  second < 10 {
            liveTimeText = "\(minute):0\(second)"
        }
       else if minute < 10 &&  second >  10 {
            liveTimeText = "0\(minute):\(second)"
        }
       else  {
            liveTimeText = "\(minute):\(second)"
        }
       }
       
        liveTimerTextLable.text = liveTimeText
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
    
    @IBAction func cameraTogglePressed(_ sender: Any) {
     //   self.swapCamera()
        isFrontCam = !isFrontCam
       
        self.FlipFrontCameraSinglelive()
       
        if(isFrontCam)
        {
         
            let dic = ["CameraToggle":"1","isFrontCam": "1"]

            let data = NSKeyedArchiver.archivedData(withRootObject: dic)
           appDelegate.webRTCClient.sendData(data: data, binary: true)
        }
        else{
            let dic = ["CameraToggle":"1","isFrontCam": "0"]
            let data = NSKeyedArchiver.archivedData(withRootObject: dic)
             appDelegate.webRTCClient.sendData(data: data, binary: true)
        }
        appDelegate.webRTCClient.switchCamera()
       
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
        if(isFrontCam)
        {
         
            let dic = ["CameraToggle":"1","isFrontCam": "1"]

            let data = NSKeyedArchiver.archivedData(withRootObject: dic)
           appDelegate.webRTCClient.sendData(data: data, binary: true)
        }
        else{
            let dic = ["CameraToggle":"1","isFrontCam": "0"]
            let data = NSKeyedArchiver.archivedData(withRootObject: dic)
             appDelegate.webRTCClient.sendData(data: data, binary: true)
        }
        self.liveComments.append(comment)
    }
    func findIfAlreadyLeft(viewers : Array<[String:AnyObject]>) {
        let userJoinedCopy = userJoined
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
     //   self.userJoined.removeAll()
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
        self.findIfAlreadyLeft(viewers: viewers)
        self.findIfAlreadyJoined(viewers: viewers)
    }
    
    @objc func getLiveStatus()  {
        DispatchQueue.global(qos:.userInteractive).async {
        let op = UserLiveOperations()
            op.allUsersLiveStatus (id: "\(AuthService.instance.userId)" , LiveId: self.liveID) { (onlineStat) in
               
                DispatchQueue.main.async { [self] in
                    
                    if let error = onlineStat["error"] as? Bool{
                        if !error{
                            if let views = onlineStat["viewData"] as? Array<[String:AnyObject]> {
                               
                                numberOfViews.text = "\(views.count)"
                                self.findNewJoinORLeft(viewers: views)
                            }
                            else
                            {
                                numberOfViews.text = "\(0)"
                                self.findNewJoinORLeft(viewers: Array<[String : AnyObject]>())
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
                print(onlineStat)
        }
        }
    }
    func addTimerCall()  {
        timer.invalidate() // just in case this button is tapped multiple times

              // start the timer
        timer = Timer.scheduledTimer(timeInterval: 3 , target: self, selector: #selector(self.getLiveStatus), userInfo: nil, repeats: true)

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
    override func didReceiveMemoryWarning() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addNotificcationObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.navigationController?.navigationBar.isHidden = true
        self.revealViewController()?.panGestureRecognizer().isEnabled = false;

        IQKeyboardManager.sharedManager().enable = false
     
        if topicValueText == "Type" {
            self.topicValue.text = "No Topic"
        }
        else{
            self.topicValue.text = topicValueText
        }
        if !appDelegate.webRTCClient.isConnected() {
            DispatchQueue.main.async { [self] in
            self.captureSession.startRunning()
            self.addActionAlert()
            }
        }
        else
        {
            self.reloadComentsView()
//            DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
//                self.captureSession.startRunning()
//                //Step 13
//            }
            
         //   appDelegate.webRTCClient.setLocalView(container: cameraView, mode: .scaleAspectFill)

        }
        
      //  self.reloadCommentsDummyData()
    }
    func reloadCommentsDummyData() {
        self.liveComments.removeAll()
        var comment = CommentMessage()
        comment.messageText = "First Message"
        comment.name = "Javed Mia"
        self.liveComments.append(comment)
        var comment2 = CommentMessage()
        comment2.messageText = "Second Message"
        comment2.name = "Javed Tarekh"
        self.liveComments.append(comment2)
        self.reloadComentsView()
     
    }
   func reloadComentsView()
   {
   DispatchQueue.main.async { [self] in
   if self.userCommentsCollectionView != nil {
       self.userCommentsCollectionView.reloadData()
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
         //  self.userCommentsCollectionView.contentOffset = CGPoint(x: 0, y: self.userCommentsCollectionView.contentSize.height - self.userCommentsCollectionView.bounds.size.height)
    
        

           // ready
       })
   }
   }


   }

     deinit
    {
        IQKeyboardManager.sharedManager().enable = true
     //   appDelegate.webRTCClient.stop()
        removeKeyboardObservers()
        self.navigationController?.navigationBar.isHidden = false
      

    }
    override func viewWillDisappear(_ animated: Bool) {
        joiningVC?.dismiss(animated: false, completion: nil)
        onlineViewer?.dismiss(animated: false, completion: nil)
        self.revealViewController()?.panGestureRecognizer().isEnabled = true;
     
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
      
    }
    @IBAction func toggleMicButttonpressed(_ sender: Any) {
        micButton.isSelected =  !micButton.isSelected
        appDelegate.webRTCClient.toggleAudio()
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.commentField.resignFirstResponder()
        isEndLivePressed = true
        
        self.hideAllViewOnScreen()
        self.addEndActionAlert()
      
    }
    func hideAllViewOnScreen()  {
        commentField.resignFirstResponder()
        commentBackground.isHidden = true
        cameraToggleButton.isHidden = true
        UserCommentsBackground.isHidden = true
        micButton.isHidden = true
        closebutton.isHidden = true
        liveTimerView.isHidden = true
//        livebutton.isHidden = true
//        seenView.isHidden = true
    }
    func hideAllViewOnSwipe()  {
        commentField.resignFirstResponder()
//        commentBackground.isHidden = true
        cameraToggleButton.isHidden = true
//        UserCommentsBackground.isHidden = true
        micButton.isHidden = true
      //  closebutton.isHidden = true
        liveTimerView.isHidden = true
//        livebutton.isHidden = true
//        seenView.isHidden = true
    }
    func showAllViewOnSwipe()  {
        commentBackground.isHidden = false
        cameraToggleButton.isHidden = false
        UserCommentsBackground.isHidden = false
        micButton.isHidden = false
        closebutton.isHidden = false
        liveTimerView.isHidden = false
        livebutton.isHidden = false
        seenView.isHidden = false
    }
    func showAllViewOnScreen()  {
        commentBackground.isHidden = false
        cameraToggleButton.isHidden = false
        UserCommentsBackground.isHidden = false
        micButton.isHidden = false
        closebutton.isHidden = false
        liveTimerView.isHidden = false
//        livebutton.isHidden = false
//        seenView.isHidden = false
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
            self.commentLeading.constant = UIScreen.main.bounds.width
            self.commentTraining.constant = -UIScreen.main.bounds.width
            self.liveLableLeading.constant = UIScreen.main.bounds.width
            self.liveLableTraining.constant = -UIScreen.main.bounds.width
            
                self.view.layoutIfNeeded()
            }
      
      
    }
    func showCommentesView()
    {
      
           // colorAnimationView.layer.removeAllAnimations()
        UIView.animate(withDuration: 1.0) {
            self.commentViewLeadingSpace.constant = 16
            self.commentLeading.constant = 16
            self.commentTraining.constant = 16
            self.liveLableLeading.constant = 16
            self.liveLableTraining.constant = 16
                self.view.layoutIfNeeded()
            }
    }
    @objc func sendRequestPressed(sender : UIButton ) {
        var message  = self.liveComments[sender.tag]
        if !appDelegate.webRTCViewerClient.isConnected() {
          
          
            self.showJoiningPopup(message:message)
        }
        else
        {
            self.showToast(message: "You are already connected")
        }
     
    
        
    }
    func showJoiningPopup(message:CommentMessage)  {
        if let vc = joiningVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.friendId = message.userId
            vc.liveUserNameValue = message.name
            vc.liveUserImageValue  = message.profilePic
            vc.liveUserProfileColor = message.colorCode
        
            if !vc.isModal {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
extension UserLiveVC: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> UserLiveVC?{
        return UIStoryboard(name: StoryBoard.LIVE, bundle: nil).instantiateViewController(withIdentifier: UserLiveVC.id) as? UserLiveVC
    }
}
extension UserLiveVC: SFCountdownViewDelegate
{
    func countdownFinished(_ view: SFCountdownView!) {
        Run.onMainThread {
            
                let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinner.mode = MBProgressHUDMode.indeterminate
                spinner.isUserInteractionEnabled = false
                spinner.label.text = "Connecting..."
         
        }
    }
    
    
}
extension UserLiveVC: CustomAlertViewDelegate {
    
    func okButtonTapped(selectedOption: String, textFieldValue: String) {

            self.countDown.isHidden = false
            self.countDown.start()
           self.countDown.delegate = self
       // }

      //  self.perform(#selector(self.startLive), with: self, afterDelay: 0.0)

        self.perform(#selector(self.setUserStatucToLive), with: self, afterDelay: 0.0)

      
    }
    private func getConnectedWith(streamId : String)
    {
        Run.onMainThread {
            
            if !self.appDelegate.webRTCClient.isConnected() {
            self.appDelegate.webRTCClient = AntMediaClient.init()
            self.appDelegate.setDelegate()
            self.appDelegate.webRTCClient.setOptions(url: Endpoints.LiveUser, streamId: streamId, token: "", mode: AntMediaClientMode.publish, enableDataChannel: true)
            self.appDelegate.webRTCClient.setLocalView(container: self.cameraView, mode: .scaleAspectFill)
            self.appDelegate.webRTCClient.initPeerConnection()
            self.appDelegate.webRTCClient.start()
            self.appDelegate.isStreamer = true
            self.smallCameraContainer.isHidden = true
            }
            
        }
    }
    @objc func startLive()
    {
        
        let streamId = "stream1room\(liveID)"
       // "room\(liveID)" http://3.85.1.123:5080
        // stream1
       // https://sayed.net:5080/WebRTCAppEE/websocket
     //   "ws://3.85.1.123:5080/WebRTCAppEE/websocket"
//        print("stream1room\(liveID)")
//     appDelegate.webRTCClient.setOptions(url: Endpoints.LiveUser , streamId: "stream1room\(liveID)" , token: "", mode: .publish, enableDataChannel: true)
//    appDelegate.webRTCClient.setLocalView(container: cameraView, mode: .scaleAspectFill)
//     appDelegate.webRTCClient.initPeerConnection()
//        appDelegate.webRTCClient.start()
//        appDelegate.isStreamer = true
//       appDelegate.liveID = liveID
//        smallCameraContainer.isHidden = true

        self.getConnectedWith(streamId: streamId)
       // self.startConferenceCall(steamId: streamId)
   
    }
    func startConferenceCall(steamId : String)  {
        
        remoteViews.append(smallStreamView)
        if steamId.contains("stream2room")
        {
            appDelegate.isDualLive = true;
        }else
        {
            appDelegate.isDualLive = false;
        }
        appDelegate.conferenceClient = ConferenceClient.init(serverURL: Endpoints.LiveUser, conferenceClientDelegate: self)
        appDelegate.conferenceClient.joinRoom(roomId: steamId, streamId: steamId)
        
    }
    @objc func setUserStatucToLive()  {
        DispatchQueue.global(qos:.userInteractive).async {
        let op = UserLiveOperations()
            op.userGoLive (id: "\(AuthService.instance.userId)", topic: self.topicValueText ) { (onlineStat) in
                if let online = onlineStat["liveid"] as? String{
                    self.liveID = online
                    DispatchQueue.main.async { [self] in
                    self.startLive()
                    }
                }
              
                print(onlineStat)
        }
        }
    }
    @objc func setUserStatusEndLive()  {
        DispatchQueue.global(qos:.userInteractive).async {
        let op = UserLiveOperations()
            op.userEndLive (id: "\(AuthService.instance.userId)" ) { (onlineStat) in
                DispatchQueue.main.async { [self] in
                    self.showToast(message: "Live has been finished!")
   //            MBProgressHUD.hide(for: self.view , animated: true)
            //        self.cancelButtonTapped()
             self.perform(#selector(self.cancelButtonTapped), with: self, afterDelay: 1.0)

//                    self.navigationController?.navigationBar.isHidden = false
//
//             self.navigationController?.popToRootViewController(animated: true)
                  }
             
                print(onlineStat)
        }
        }
    }
   @objc func cancelButtonTapped() {
        print("cancelButtonTapped")
    Run.onMainThread {
        
//        if self.appDelegate.webRTCClient.isConnected() {
//            self.appDelegate.isStreamerDisconeted = true
//            self.appDelegate.webRTCClient.stop()
//        }
          
        for client in self.playerClients
        {
            client.playerClient.stop();
        }
        if self.appDelegate.conferenceClient != nil
        {
            if self.appDelegate.conferenceClient.streamsInTheRoom.count > 0 {
                self.appDelegate.conferenceClient.leaveRoom()
            }
        }
      
       
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
 
    }
}

extension UIButton {


    func drawShadow() {
     //   self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowColor = UIColor.gray.cgColor;
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 0.0;
    }

}

extension UserLiveVC: EndLiveViewDelegate {
    
    func okEndLiveButtonTapped(selectedOption: String, textFieldValue: String) {
       
        self.endLiveTimmer()
        self.appDelegate.isStreamerDisconeted = true
        if self.appDelegate.webRTCClient.isConnected() {
            self.appDelegate.isStreamerDisconeted = true
        self.appDelegate.webRTCClient.stop()
        }
        if let vc = downloadEndsLivePopup   {
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            if !vc.isModal {
                self.present(vc, animated: true, completion: nil)
            }
       
        }

    }

    func cancelEndLiveButtonTapped() {
        self.showAllViewOnScreen()
    }
}
extension UserLiveVC: OnlineViewersDelegate {
    func onlineUserSelected(FriendID: String, AtIndex: Int) {
        if let vc = FriendVC.storyBoardInstance() {
            vc.friendId = FriendID
            UserDefaults.standard.set(FriendID, forKey: "friendId")
            self.navigationController?.navigationBar.isHidden = false
          //  self.present(vc, animated: true, completion: nil)

        self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
extension UserLiveVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.liveComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
          let message =   self.liveComments[indexPath.row]
            if message.isJoingingRequest == "1" {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewerJoinRequestCell.identifier, for: indexPath) as? ViewerJoinRequestCell else { return UICollectionViewCell()}
                let item = self.liveComments[indexPath.row]
                cell.configCell(item: item )
                if item.userId ==  playingUserId {
                    cell.requestButton.setTitle("Viewed", for: .normal)
                }
                else{
                cell.requestButton.setTitle("View", for: .normal)
                }
                cell.requestButton.tag = indexPath.row
                cell.profileView.isHidden = false
                cell.imagePlaceholder.isHidden = true
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
  
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            guard let collectionView = userCommentsCollectionView else {
//                return
//            }
//
//            let offset = collectionView.contentOffset.y
//            let height = collectionView.frame.size.height
//            let width = collectionView.frame.size.width
//            for cell in collectionView.visibleCells {
//                let left = cell.frame.origin.y
//                if left >= height / 2 {
//                    let top = cell.frame.origin.y
//                    let alpha = (top - offset) / height
//                    cell.alpha = alpha
//                } else {
//                    cell.fadeInCell()
//                }
//            }
//        }
}
extension String {
func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.text = self
    label.font = font
    label.sizeToFit()

    return label.frame.height
 }
}
extension UserLiveVC : StreamerSideJoinRequestDelegate
{
    func acceptJoinRequest(FriendID: String, controller: StreamerSideJoinRequestPopUp) {
        
        let dic = ["fullName": AuthService.instance.fullName,"isJoingingRequest": "1","joingingRequestStatus": "1","OnlyForStreamer": "0","StreamStarted": "0","SpecificUser": "1","friendId": FriendID , "profilePic": AuthService.instance.profilePic , "message": commentField.text!, "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId]
        
        /* NSDictionary to NSData */
        let data = NSKeyedArchiver.archivedData(withRootObject: dic)
        appDelegate.webRTCClient.sendData(data: data, binary: false)
    }
    
    
}
extension UserLiveVC : AntMediaClientDelegate
{
    func remoteStreamStarted(streamId: String) {
        
    }
    
    func remoteStreamRemoved(streamId: String) {
        
    }
    
    func localStreamStarted(streamId: String) {
        
    }
    
    func playStarted(streamId: String) {
        
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = false
//            DispatchQueue.main.async { [self] in
//            self.smallStreamView.transform = CGAffineTransform(scaleX: -1, y: 1);
//            }
            MBProgressHUD.hide(for: self.view , animated: true)
            self.setUserStatusToLive(status: "dual")
            self.isPlaying = true
            self.reloadComentsView()
          //  self.setUserToDualLive()
        }
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playStarted"), object: nil, userInfo: nil)
       
    }
    
    func playFinished(streamId: String) {
        DispatchQueue.main.async { [self] in
            
            smallCameraContainer.tag = 0
            smallStreamView.bounds = smallCameraContainer.bounds
            smallStreamView.frame = CGRect(x: 0, y: 0, width: smallCameraContainer.frame.size.width, height: smallCameraContainer.frame.size.height)
            smallCameraContainer.addSubview(smallStreamView)
            self.viewFree[0] = true;
            self.viewFree[1] = true;
            cameraView.bounds = largeCameraContainer.bounds
            cameraView.frame = CGRect(x: 0, y: 0, width: largeCameraContainer.frame.size.width, height: largeCameraContainer.frame.size.height)
            largeCameraContainer.addSubview(cameraView)
            smallCameraContainer.layoutSubviews()
            smallCameraContainer.layoutIfNeeded()
            largeCameraContainer.layoutSubviews()
            largeCameraContainer.layoutIfNeeded()
            self.isPlaying = false
            self.reloadComentsView()
            smallCameraContainer.isHidden = true
            self.setUserStatusToLive(status: "single")
        }
//        for client in self.playerClients
//        {
//            client.playerClient.stop();
//        }
        appDelegate.playerClient1.stop()
    //    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playFinished"), object: nil, userInfo: nil)
    }
    
    func publishStarted(streamId: String) {
      
    }
    
    func publishFinished(streamId: String) {
        
    }
    
    func disconnected(streamId: String) {
        
    }
    
    func audioSessionDidStartPlayOrRecord(streamId: String) {
        appDelegate.playerClient1.speakerOn()
    }
    
    func streamInformation(streamInfo: [StreamInformation]) {
        
    }
    
    func clientDidConnect(_ client: AntMediaClient) {
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)
      
        
    }
    
    func clientDidDisconnect(_ message: String) {
      print("Stream get error \(message)")
    }
    
    func clientHasError(_ message: String) {
       print("Stream get error \(message)")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clientHasError"), object: nil, userInfo: nil)
        
    }

    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        
//        do {
//
//            let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: data)
//
//            NotificationfCenter.default.post(name: NSNotification.Name(rawValue: "RecievedMessage"), object: nil, userInfo: unarchivedDictionary as? [String: AnyObject])
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
extension UserLiveVC {

    @objc func  playJoiningStream()
    {
        DispatchQueue.main.async { [self]
                let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinner.mode = MBProgressHUDMode.indeterminate
                spinner.isUserInteractionEnabled = false
                spinner.label.text = "Connecting..."
            }
        print("stream2room\(liveID)")
        appDelegate.webRTCViewerClient.setOptions(url: Endpoints.LiveUser , streamId: "stream2room\(liveID)" , token: "", mode: .play, enableDataChannel: true)
     //   appDelegate.webRTCViewerClient.setDebug(true)
        appDelegate.webRTCViewerClient.start()
    }
    @objc func setUserStatusToLive(status:String)  {
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
extension UserLiveVC: ConferenceClientDelegate
{
    public func streamIdToPublish(streamId: String) {
        
//        Run.onMainThread {
//        //
//            //self.appDelegate.webRTCClient.setOptions(url: Endpoints.LiveUser , streamId: streamId , token: "", mode: .publish, enableDataChannel: true)
//            if !self.appDelegate.webRTCClient.isConnected() {
//            self.appDelegate.webRTCClient = AntMediaClient.init()
//            self.appDelegate.setDelegate()
//            self.appDelegate.webRTCClient.setOptions(url: Endpoints.LiveUser, streamId: streamId, token: "", mode: AntMediaClientMode.publish, enableDataChannel: true)
//            self.appDelegate.webRTCClient.setLocalView(container: self.cameraView, mode: .scaleAspectFill)
//            self.appDelegate.webRTCClient.initPeerConnection()
//            self.appDelegate.webRTCClient.start()
//            self.appDelegate.isStreamer = true
//            self.smallCameraContainer.isHidden = true
//            }
            
//        }
           
    }
       
    public func newStreamsJoined(streams: [String]) {
        
        AntMediaClient.printf("Room current capacity: \(playerClients.count)")
        if (playerClients.count == 1) {
            AntMediaClient.printf("Room is full")
            return
        }
        Run.onMainThread {
            
        
            for stream in streams
            {
                AntMediaClient.printf("stream in the room: \(stream)")
                //let playerClient = AntMediaClient.init()
                self.appDelegate.playerClient1.delegate = self;
                self.appDelegate.playerClient1.setOptions(url:  Endpoints.LiveUser , streamId: stream, token: "", mode: AntMediaClientMode.play, enableDataChannel: false)
                
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
                self.appDelegate.playerClient1.setRemoteView(remoteContainer: self.remoteViews[freeIndex], mode: .scaleAspectFill)
                self.appDelegate.playerClient1.initPeerConnection()
                self.appDelegate.playerClient1.start()
                self.remoteViews[freeIndex].isHidden = false
                
                let playerConferenceClient = AntMediaClientConference.init(player: self.appDelegate.playerClient1, index: freeIndex);
                
                self.playerClients.append(playerConferenceClient)
                
            }
        }
       
           
    }
       
    public func streamsLeaved(streams: [String]) {
        
        Run.onMainThread {
        
            var leavedClientIndex:[Int] = []
            for streamId in streams
            {
                for  (clientIndex,conferenceClient) in self.playerClients.enumerated()
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
                self.playerClients.remove(at: index);
            }
        }
    }
}
extension UserLiveVC: EndLiveWithDownloadDelegate
{
    
    func downloadVideo(path : String) {
        self.showMessage(with: "Download begins!")
        let videoImageUrl = path
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let filePath="\(documentsPath)/liveID\(liveID).mp4"
        DispatchQueue.global(qos: .background).sync {
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
    
    func downloadButtonPressed() {
        isEndLivePressed = true
        //  dowloaduRL http://107.22.156.210:5080/WebRTCAppEE/streams/stream2room2409.mp4?token=undefined
        let path = "\(Endpoints.liveDownload)/stream1room\(self.liveID).mp4"
        self.downloadVideo(path: path)
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "End Live..."
        self.setUserStatusEndLive()
    }
    
    func deleteButtonPressed() {
        isEndLivePressed = true
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "End Live..."
        self.setUserStatusEndLive()
    }
    
    
}
extension UserLiveVC :NotificationRedirectionDelegate
{
    func openChatVC(fmodel: FriendModel) {
        let controller = ChatVC()
        let vc = UINavigationController(rootViewController: controller)
        controller.isTapNotifMsg = true
        controller.modalPresentationStyle = .fullScreen
        if !vc.isModal {
        self.present(vc, animated: false) {
            NotificationCenter.default.post(name: Notification.Name.navigate, object: fmodel)
        }
        }
    }
    func openPostDetailsView(postId : String)
    {
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = postId
        if !vc.isModal {
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func openEventDetailsView(eventId : String)
    {
        let vc = EventDetailVC()
        vc.eventId = eventId
        if !vc.isModal {
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func openFriendVCView(friendId : String,isFromCardNoti : String)
    {
        let vc = FriendVC.storyBoardInstance()
        vc!.friendId = friendId
        vc!.isfromCardNoti = isFromCardNoti
        if !vc!.isModal {
        self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    func openCompanyDetailsView(companyId : String)
    {
        let vc = CompanyHeaderModuleVC.storyBoardInstance()
            vc!.companyId = companyId
        if !vc!.isModal {
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    func openMarketDetailsView(userId : String,listingId : String)
    {
        if listingId != ""
        {
            let vc = DetailListingOfferVC.controllerInstance(with: listingId, with1: userId)
            if !vc.isModal {
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
            if let vc = MarketVC.storyBoardInstance(){
                if !vc.isModal {
               self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    func openNotificationsView()
    {
        
    }
    func openJoinLiveVCNotificationsView(userId : String,liveId : String,fName : String,profilePic : String,colorCode : String,liveType : String)
    {
        
    }
    func openFeedsVCView()
    {
        
    }
}
extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if let navigationController = navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if let tabBarController = tabBarController, tabBarController.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
extension UIView {
   func fadeInCell() {
      // Move our fade out code from earlier
    UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
          self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }

    func fadeOutCell() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
          self.alpha = 0.0
           }, completion: nil)
  }
}
class FadingLayout: UICollectionViewFlowLayout,UICollectionViewDelegateFlowLayout {

    //should be 0<fade<1
    private let fadeFactor: CGFloat = 0.5
    private let cellHeight : CGFloat = 60.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(scrollDirection:UICollectionView.ScrollDirection) {
        super.init()
        self.scrollDirection = scrollDirection

    }

    override func prepare() {
        setupLayout()
        super.prepare()
    }

    func setupLayout() {
        self.itemSize = CGSize(width: self.collectionView!.bounds.size.width,height:cellHeight)
        self.minimumLineSpacing = 0
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    func scrollDirectionOver() -> UICollectionView.ScrollDirection {
        return UICollectionView.ScrollDirection.vertical
    }
    //this will fade both top and bottom but can be adjusted
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesSuper: [UICollectionViewLayoutAttributes] = (super.layoutAttributesForElements(in: rect) as [UICollectionViewLayoutAttributes]?)!
        if let attributes = NSArray(array: attributesSuper, copyItems: true) as? [UICollectionViewLayoutAttributes]{
            var visibleRect = CGRect()
            visibleRect.origin = collectionView!.contentOffset
            visibleRect.size = collectionView!.bounds.size
    
            for attrs in attributes {
                
                if attrs.frame.intersects(rect) {
                    let distance = visibleRect.midY - attrs.center.y
                    var normalizedDistance = abs(distance) / (visibleRect.height * fadeFactor)
                    if normalizedDistance < 0.80 {
                        normalizedDistance = 0
                        let fade = 1 - normalizedDistance
                        attrs.alpha = fade
                    }
                    else
                    {
                        let value  = normalizedDistance - 0.8
                        normalizedDistance =  value * 5
                        
                        let fade = 1 - normalizedDistance
                        attrs.alpha = fade
                    }
                  
                   
                }
            
            }
            return attributes
        }else{
            return nil
        }
    }
    //appear and disappear at 0
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
        attributes.alpha = 0
        return attributes
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
        attributes.alpha = 0
        return attributes
    }
}
