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

    var timeStamp : Int =  (Int(Date().timeIntervalSince1970))
}
class UserLiveVC: UIViewController,KeyboardAvoidable ,UITextFieldDelegate{

    var liveID = "0"
    var isFrontCam = true
    var liveComments = [CommentMessage]()
    {
        didSet
        {
            self.reloadComentsView()
        }
    }
    @IBOutlet weak var smallStreamView: UIView!
    @IBOutlet weak var commentsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var largeCameraContainer: UIView!
    @IBOutlet weak var smallCameraContainer: UIView!
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

    var topicValueText = "No Topic"
    var userJoined = Array<[String:AnyObject]>()
    var userLeft = Array<[String:AnyObject]>()
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    var timer = Timer()
    var liveTimeCount = Timer()
    var liveTimeValue = 0
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.RecievedMessage(_:)), name: NSNotification.Name(rawValue: "RecievedMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PublishStarted(_:)), name: NSNotification.Name(rawValue: "PublishStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.AppCloseed(_:)), name: NSNotification.Name(rawValue: "AppCloseed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ConnectionEstablished(_:)), name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil)
        
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
        self.cameraView.transform = CGAffineTransform(scaleX: -1, y: 1);
        self.cameraflipedView.frame =  self.largeCameraContainer.frame
        self.cameraflipedView.transform = CGAffineTransform(scaleX: -1, y: 1);
     //   self.videoPreviewLayer.customMirror

        //self..transform = CGAffineTransform(scaleX: -1, y: 1);
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
       
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
               
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.appDelegate.webRTCViewerClient.stop()
                      var  webRTCViewerClient: AntMediaClient = AntMediaClient.init()
                        webRTCViewerClient.delegate = self
                        webRTCViewerClient.setRemoteView(remoteContainer: self.smallStreamView, mode: .scaleAspectFill)

                        self.appDelegate.webRTCViewerClient = webRTCViewerClient
                        self.playJoiningStream()
                    
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
            if(self!.isFrontCam)
            {
                self?.cameraView.transform = CGAffineTransform(scaleX: -1, y: 1);
            }
            else{
                self?.cameraView.transform = CGAffineTransform(scaleX: 1, y: 1);
            }
            
            self?.addTimerCall()
            self?.startLiveTime()
        }
     }
    @objc func ConnectionEstablished(_ notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            if(self!.isFrontCam)
            {
                self?.cameraView.transform = CGAffineTransform(scaleX: -1, y: 1);
            }
            else{
                self?.cameraView.transform = CGAffineTransform(scaleX: 1, y: 1);
            }
          
        }
     }
    @objc func OnlineViewTapped(_ sender: UITapGestureRecognizer) {
        if userJoined.count > 0 {
            if let vc = OnlineViewersPopUpVC.storyBoardInstance(){
                vc.modalPresentationStyle = .overFullScreen
                vc.delegateOnlineViewer = self
                vc.userJoined = userJoined
                vc.indexValue = 0
                self.present(vc, animated: true, completion: nil)
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
    self.present(customAlert, animated: true, completion: nil)
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
        self.cameraflipedView.frame = self.largeCameraContainer.frame
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
     //   cameraflipedView.bounds = screenSize
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.videoPreviewLayer.frame = self.largeCameraContainer.frame
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
        if(isFrontCam)
        {
            self.cameraView.transform = CGAffineTransform(scaleX: -1, y: 1);
        }
        else{
            self.cameraView.transform = CGAffineTransform(scaleX: 1, y: 1);
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
        
        self.liveComments.append(comment)
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
        self.findIfAlreadyJoined(viewers: viewers)
      self.findIfAlreadyLeft(viewers: viewers)
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.navigationController?.navigationBar.isHidden = true
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
        appDelegate.webRTCClient.stop()
        removeKeyboardObservers()
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(self)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
      
    }
    @IBAction func toggleMicButttonpressed(_ sender: Any) {
        micButton.isSelected =  !micButton.isSelected
        appDelegate.webRTCClient.toggleAudio()
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.addEndActionAlert()
      
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
    @objc func sendRequestPressed(sender : UIButton ) {
        
        if !appDelegate.webRTCViewerClient.isConnected() {
            let message  = self.liveComments[sender.tag]
            self.showJoiningPopup(message:message)
        }
        else
        {
            self.showToast(message: "You are already connected")
        }
     
    
        
    }
    func showJoiningPopup(message:CommentMessage)  {
        if let vc = StreamerSideJoinRequestPopUp.storyBoardInstance(){
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.friendId = message.userId
            vc.liveUserNameValue = message.name
            vc.liveUserImageValue  = message.profilePic
            vc.liveUserProfileColor = message.colorCode
        
            self.present(vc, animated: true, completion: nil)
        }
    }
}
extension UserLiveVC: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> UserLiveVC?{
        return UIStoryboard(name: StoryBoard.LIVE, bundle: nil).instantiateViewController(withIdentifier: UserLiveVC.id) as? UserLiveVC
    }
}
extension UserLiveVC: CustomAlertViewDelegate {
    
    func okButtonTapped(selectedOption: String, textFieldValue: String) {

            self.countDown.isHidden = false
            self.countDown.start()
       // }

      //  self.perform(#selector(self.startLive), with: self, afterDelay: 0.0)

        self.perform(#selector(self.setUserStatucToLive), with: self, afterDelay: 0.0)

      
    }
    @objc func startLive()
    {
       // "room\(liveID)" http://3.85.1.123:5080
        // stream1
       // https://sayed.net:5080/WebRTCAppEE/websocket
     //   "ws://3.85.1.123:5080/WebRTCAppEE/websocket"
        print("stream1room\(liveID)")
        appDelegate.webRTCClient.setOptions(url: Endpoints.LiveUser , streamId: "stream1room\(liveID)" , token: "", mode: .publish, enableDataChannel: true)
       appDelegate.webRTCClient.setLocalView(container: cameraView, mode: .scaleAspectFill)
        
     
        
        appDelegate.isStreamer = true
        appDelegate.liveID = liveID
     //   appDelegate.webRTCClient.setRemoteView(remoteContainer: cameraView, mode: .scaleAspectFill)
        smallCameraContainer.isHidden = true

       // webRTCClient.setMultiPeerMode(enable: true, mode: "join")
      //  appDelegate.webRTCClient.setMultiPeerMode(enable: true, mode: "join")
     //   appDelegate.webRTCClient.initPeerConnection()
        appDelegate.webRTCClient.setDebug(true)
      //  appDelegate.webRTCClient.connectWebSocket()
        appDelegate.webRTCClient.start()
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
        
       appDelegate.webRTCClient.stop()
    self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
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
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "End Live..."
        self.setUserStatusEndLive()

    }

    func cancelEndLiveButtonTapped() {
     
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
                cell.configCell(item: self.liveComments[indexPath.row] )
                
                cell.requestButton.setTitle("View", for: .normal)
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
    
    func remoteStreamStarted() {
      
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)

    }
    
    func remoteStreamRemoved() {
      
    }
    
    func localStreamStarted() {
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionEstablished"), object: nil, userInfo: nil)

    }
    
    func playStarted() {
        
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = false
            self.setUserToDualLive()
        }
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playStarted"), object: nil, userInfo: nil)
       
    }
    func playFinished() {
        DispatchQueue.main.async { [self] in
            smallCameraContainer.isHidden = true
        }
        appDelegate.webRTCViewerClient.stop()
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
    //    webRTCClient.speakerOn()
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
extension UserLiveVC {

    @objc func  playJoiningStream()
    {
        print("stream2room\(liveID)")
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
