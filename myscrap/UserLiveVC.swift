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
import Starscream
struct CommentMessage {
    var name : String = "Test"
    var userId : String = "Test"
    var profilePic : String = "Test"
    var colorCode : String = "Test"
    var messageId : String = "Test"
    var messageText : String = "Test"
    var timeStamp : Int =  (Int(Date().timeIntervalSince1970))
}
class UserLiveVC: UIViewController,KeyboardAvoidable ,UITextFieldDelegate{

    var liveID = "0"
    var liveComments = [CommentMessage]()
    {
        didSet
        {
            self.reloadComentsView()
        }
    }
    @IBOutlet weak var numberOfViews: UILabel!
    
    @IBOutlet weak var commentViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var liveTimerView: UIView!
    @IBOutlet weak var liveTimerTextLable: UILabel!
    @IBOutlet weak var seenIcon: UIImageView!
    @IBOutlet weak var seenView: UIView!
    @IBOutlet weak var countDown: SFCountdownView!
    var layoutConstraintsToAdjust: [NSLayoutConstraint] = []
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var UserCommentsBackground: UIView!
    @IBOutlet weak var userCommentsCollectionView: UICollectionView!

    var topicValueText = "No Topic"
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    let webRTCClient: AntMediaClient = AntMediaClient.init()
    var timer = Timer()
    var liveTimeCount = Timer()
    var liveTimeValue = 0
    @IBOutlet weak var announceImage: UIImageView!
    @IBOutlet weak var commentBackground: UIView!
    @IBOutlet weak var topicTtitle: UILabel!
    @IBOutlet weak var announcementView: UIView!
    @IBOutlet weak var topicValue: UILabel!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var cameraType  = CameraType.Front
    @IBOutlet weak var cameraToggleButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var liveLable: UILabel!
    @IBOutlet weak var livebutton: UIButton!
    @IBOutlet weak var closebutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        self.topicTtitle.text = "Topic :"
        self.topicValue.text = topicValueText
      
        announcementView.layer.cornerRadius =  announcementView.frame.size.height/2
        commentBackground.layer.cornerRadius =  commentBackground.frame.size.height/2
        commentBackground.layer.borderWidth =  3
        commentBackground.layer.borderColor =  UIColor.gray.cgColor
        self.countDown.isHidden = true
        
        self.countDown.backgroundAlpha = 0.2;
        self.countDown.countdownColor = UIColor.black;
        self.countDown.countdownFrom = 3;
        self.countDown.finishText = "";
        self.countDown.updateAppearance()
        
        let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        sendCommentButton.setImage(image, for: .normal)
        sendCommentButton.tintColor = UIColor.gray
        commentField.textColor = UIColor.gray
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
        
        let imageAnnounce = UIImage(named: "announce")?.withRenderingMode(.alwaysTemplate)
        self.announceImage.image = imageAnnounce
        self.announceImage.tintColor = .white
        
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
        
        liveTimerView.layer.cornerRadius = 5
        liveTimerView.clipsToBounds = true
        liveTimerView.isHidden = true
        seenView.layer.cornerRadius = 5
        seenView.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnTopic(tapGestureRecognizer:)))
        announcementView.isUserInteractionEnabled = true
        announcementView.addGestureRecognizer(tapGestureRecognizer)
        layoutConstraintsToAdjust.append(constraintContentHeight)
        webRTCClient.delegate = self
        //https://34.207.130.236:5080/WebRTCAppEE/peer.html
        self.setUpCamera()
        addKeyboardObservers()
        self.setUpCommentViews()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
       
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
//        if let flowLayout = userCommentsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//           }
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
            comment.name = "Javed Tarekh"
            self.liveComments.append(comment)
            commentField.text = ""
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

        self.cameraView.bounds = screenSize
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.videoPreviewLayer.frame = screenSize
        cameraView.layer.addSublayer(videoPreviewLayer)
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
        webRTCClient.switchCamera()

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
                            }
                        }
                        else
                        {
                            numberOfViews.text = "\(0)"
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
        self.reloadComentsView()
    }

    @objc func keyboardWillDisappear() {
        //Do something here
        self.reloadComentsView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.navigationController?.navigationBar.isHidden = true
        IQKeyboardManager.sharedManager().enable = false
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
        if topicValueText == "Topic" {
            self.topicValue.text = "No Topic"
        }
        else{
            self.topicValue.text = topicValueText
        }
      
        self.addActionAlert()
        self.reloadCommentsDummyData()
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
    if self.userCommentsCollectionView != nil {
        self.userCommentsCollectionView.reloadData()
        self.userCommentsCollectionView.performBatchUpdates(nil, completion: {
            (result) in
            self.userCommentsCollectionView.contentOffset = CGPoint(x: 0, y: self.userCommentsCollectionView.contentSize.height - self.userCommentsCollectionView.bounds.size.height)
            // ready
        })
    }
    
 

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        IQKeyboardManager.sharedManager().enable = true
        webRTCClient.stop()
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(self)

    }
    @IBAction func toggleMicButttonpressed(_ sender: Any) {
        micButton.isSelected =  !micButton.isSelected
        webRTCClient.toggleAudio()
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
    deinit {
        removeKeyboardObservers()
    }
    func hideCommentesView()
    {
      
           // colorAnimationView.layer.removeAllAnimations()
        UIView.animate(withDuration: 2.0) {
            self.commentViewLeadingSpace.constant = UIScreen.main.bounds.width
                self.view.layoutIfNeeded()
            }
      
      
    }
    func showCommentesView()
    {
      
           // colorAnimationView.layer.removeAllAnimations()
        UIView.animate(withDuration: 2.0) {
            self.commentViewLeadingSpace.constant = 16
                self.view.layoutIfNeeded()
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
        webRTCClient.setOptions(url: Endpoints.LiveUser , streamId: "room\(liveID)" , token: "", mode: .publish, enableDataChannel: true)
         webRTCClient.setLocalView(container: cameraView, mode: .scaleAspectFill)
       // webRTCClient.setMultiPeerMode(enable: true, mode: "join")
       webRTCClient.initPeerConnection()
        
        webRTCClient.connectWebSocket()
        webRTCClient.start()
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
//              MBProgressHUD.hide(for: self.view , animated: true)
                    self.navigationController?.navigationBar.isHidden = false

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
extension UserLiveVC : AntMediaClientDelegate
{
    func clientDidConnect(_ client: AntMediaClient) {
        print("Stream get connected")
        DispatchQueue.main.async { [weak self] in
        self?.cameraView.transform = CGAffineTransform(scaleX: -1, y: 1);
        }
    }
    
    func clientDidDisconnect(_ message: String) {
        print("Stream get error \(message)")
    }
    
    func clientHasError(_ message: String) {
        print("Stream get error \(message)")
    }
    
    func remoteStreamStarted() {
      
    }
    
    func remoteStreamRemoved() {
        
    }
    
    func localStreamStarted() {
        
    }
    
    func playStarted() {
        
    }
    
    func playFinished() {
        
    }
    
    func publishStarted() {
     
        DispatchQueue.main.async { [weak self] in
    //    MBProgressHUD.hide(for: self.view , animated: true)
            self?.videoPreviewLayer.removeFromSuperlayer()
            self?.captureSession.stopRunning()

            self?.addTimerCall()
            self?.startLiveTime()
        }
    
    }
    
    func publishFinished() {
        
    }
    
    func disconnected() {
        
    }
    
    func audioSessionDidStartPlayOrRecord() {
        webRTCClient.speakerOn()
    }
    
    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        
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
extension UserLiveVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.liveComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveUserCommentsCell.identifier, for: indexPath) as? LiveUserCommentsCell else { return UICollectionViewCell()}
        cell.configCell(item: self.liveComments[indexPath.row] )
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width:self.userCommentsCollectionView.frame.size.width, height: 30)
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
