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
class JoinUserLiveVC: UIViewController,KeyboardAvoidable ,UITextFieldDelegate{
    
    

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
    fileprivate var profileItem:ProfileData?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraToggleButton: UIButton!
    fileprivate let service = ProfileService()
    fileprivate var serviceFollowing = MemmberModel()
    @IBOutlet weak var largeCameraContainer: UIView!
    @IBOutlet weak var smallCameraContainer: UIView!
    @IBOutlet weak var smallStreamView: UIView!

    
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
        
        helloButton.layer.cornerRadius =  helloButton.frame.size.height/2
        emoji1Button.layer.cornerRadius =  emoji1Button.frame.size.height/2
        emoji2Button.layer.cornerRadius =  emoji2Button.frame.size.height/2
        emoji3Button.layer.cornerRadius =  emoji3Button.frame.size.height/2
        emoji4Button.layer.cornerRadius =  emoji4Button.frame.size.height/2
        emojo5Button.layer.cornerRadius =  emojo5Button.frame.size.height/2

        helloButton.backgroundColor = .darkGray
        emoji1Button.backgroundColor = .darkGray
        emoji2Button.backgroundColor = .darkGray
        emoji3Button.backgroundColor = .darkGray
        emoji4Button.backgroundColor = .darkGray
        emojo5Button.backgroundColor = .darkGray
        
        helloButton.setTitle("Hello", for: .normal)
        emoji1Button.setTitle("😂", for: .normal)
        emoji2Button.setTitle("😍", for: .normal)
        emoji3Button.setTitle("☺️", for: .normal)
        emoji4Button.setTitle("✋🏻", for: .normal)
        emojo5Button.setTitle("👍🏻", for: .normal)
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.playFinished(_:)), name: NSNotification.Name(rawValue: "playFinished"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ConnectionEstablished(_:)), name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playStarted(_:)), name: NSNotification.Name(rawValue: "playStarted"), object: nil)
        
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
//        appDelegate.webRTCClient.setRemoteView(remoteContainer: cameraView, mode: .scaleAspectFill)
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
           
        
            //Step 13
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
            NotificationCenter.default.post(name: Notification.Name("EndLiveBYOtherUser"), object: nil)
            self.closeButtonPressed((Any).self)

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
        NotificationCenter.default.post(name: Notification.Name("EndLiveBYOtherUser"), object: nil)
        self.closeButtonPressed((Any).self)

        }
    @objc func playStarted(_ notification: NSNotification) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.addTimerCall()
            MBProgressHUD.hide(for: self.view , animated: true)
            self.videoPreviewLayer.removeFromSuperlayer()
            self.captureSession.stopRunning()
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
        self.videoPreviewLayer.frame =  cameraView.frame
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
    
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(self)

    }
    @IBAction func EndLivepressed(_ sender: Any)
   {
    if appDelegate.webRTCViewerClient.isConnected() {
        
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
    func showFollowingAlert()  {
        if let vc = LiveUserFollowPopUpVC.storyBoardInstance(){
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
    func showUnFollowingAlert()  {
        if let vc = UnfollowConfirmationPopUpVC.storyBoardInstance(){
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
        if !appDelegate.webRTCViewerClient.isConnected() {
            self.showJoiningPopup()
        }
        else
        {
            self.showToast(message: "You are already connected")
        }
     
        
    }
    func showJoiningPopup()  {
        if let vc = ViewerSideJoinRequestPopUp.storyBoardInstance(){
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
        if let vc = ViewerSideJoinConfirmPopUp.storyBoardInstance(){
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
        appDelegate.webRTCViewerClient.switchCamera()
       
    }
    @IBAction func toggleMicButttonpressed(_ sender: Any) {
        micButton.isSelected =  !micButton.isSelected
        appDelegate.webRTCViewerClient.toggleAudio()
    }
}
extension JoinUserLiveVC: unFollowConfirmDelegate {
   
    func unFollowPressed(FriendID: String) {
       
            self.serviceFollowing.sendUnFollowRequest(friendId: FriendID)
            followingStatus = false
         
            self.reloadComentsView()

        
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
    
    @objc func startLive()
    {
       
        print("room\(liveID)")
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
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                
                cell.requestButton.setTitle("Request", for: .normal)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
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
            self.startJoiningStream()
           }
     
    }
    
  
    
   
}
extension JoinUserLiveVC : AntMediaClientDelegate
{
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
    
    func remoteStreamStarted() {
        
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)

    }
    
    func remoteStreamRemoved() {
        
       
    }
    
    func localStreamStarted() {
        // send message to user that stream started
  
        let dic = ["fullName": AuthService.instance.fullName,"isJoingingRequest": "1","joingingRequestStatus": "1","OnlyForStreamer": "0","StreamStarted": "1","friendId": friendId, "profilePic": AuthService.instance.profilePic , "message": "\(AuthService.instance.fullName) Sent a request to be in your live video.", "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId,"timestamp": timeStampStarted ]
      
        let data = NSKeyedArchiver.archivedData(withRootObject: dic)
        appDelegate.webRTCClient.sendData(data: data, binary: false)
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = false
        micButton.isHidden = false
        cameraToggleButton.isHidden = false
            self.setUserToDualLive()
        }
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)

    }
    
    func playStarted() {
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playStarted"), object: nil, userInfo: nil)
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = false
            self.setUserToDualLive()
            
        }
    }
    func playFinished() {
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = true
            appDelegate.webRTCViewerClient.stop()

        }
    //    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playFinished"), object: nil, userInfo: nil)
    }
    
    func publishStarted() {
     
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PublishStarted"), object: nil, userInfo: nil)

    
    }
    
    func publishFinished() {
        
    }
    
    func disconnected() {
        
    }
    
    func audioSessionDidStartPlayOrRecord() {
        appDelegate.webRTCViewerClient.speakerOn()
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
        print("room\(liveID)")
        timeStampStarted = "\(Int(Date().timeIntervalSince1970))"
        appDelegate.webRTCViewerClient.stop()
        var  webRTCViewerClient: AntMediaClient = AntMediaClient.init()
        webRTCViewerClient.delegate = self
        webRTCViewerClient.setLocalView(container: smallStreamView, mode: .scaleAspectFill)
       self.appDelegate.webRTCViewerClient = webRTCViewerClient
        appDelegate.webRTCViewerClient.setOptions(url: Endpoints.LiveUser , streamId: "stream2room\(liveID)" , token: "", mode: .publish, enableDataChannel: true)
        appDelegate.webRTCViewerClient.setDebug(true)
        appDelegate.webRTCViewerClient.start()
    }
    @objc func playJoiningStream()
    {
        print("room\(liveID)")
        self.appDelegate.webRTCViewerClient.stop()
        
      var  webRTCViewerClient: AntMediaClient = AntMediaClient.init()
        webRTCViewerClient.delegate = self
        webRTCViewerClient.setRemoteView(remoteContainer: self.smallStreamView, mode: .scaleAspectFill)

        self.appDelegate.webRTCViewerClient = webRTCViewerClient
        appDelegate.webRTCViewerClient.setOptions(url: Endpoints.LiveUser , streamId: "stream2room\(liveID)" , token: "", mode: .play, enableDataChannel: true)
        appDelegate.webRTCViewerClient.setDebug(true)
        appDelegate.webRTCViewerClient.start()
    }
    @objc func setUserToDualLive()  {
        DispatchQueue.global(qos:.userInteractive).async { [weak self] in
        let op = UserLiveOperations()
            op.UpdateUsertoDual (id: "\(AuthService.instance.userId)" ) { (onlineStat) in
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
//        self.setUserStatusEndLive()

    }

    func cancelEndLiveButtonTapped() {
     
    }
}
