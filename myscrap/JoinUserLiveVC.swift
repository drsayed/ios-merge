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
    var liveUserNameValue = ""
    var liveUserImageValue  = ""
    var liveUserProfileColor = ""
    var liveUsertopicValue = ""
    var timer = Timer()

    @IBOutlet weak var liveUserProfile: ProfileView!
    @IBOutlet weak var liveUserName: UILabel!
    @IBOutlet weak var liveUserImage: UIImageView!
    @IBOutlet weak var liveStreamerView: UIView!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var seenIcon: UIImageView!
    @IBOutlet weak var seenView: UIView!
    var layoutConstraintsToAdjust: [NSLayoutConstraint] = []
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    var topicValueText = "No Topic"
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    let webRTCClient: AntMediaClient = AntMediaClient.init()
    
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
        self.navigationController?.navigationBar.isHidden = true
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
      //  self.topicTtitle.text = "Topic :"
        self.topicValue.text = topicValueText
      
        announcementView.layer.cornerRadius =  announcementView.frame.size.height/2
        liveStreamerView.layer.cornerRadius =  liveStreamerView.frame.size.height/2
        liveUserImage.layer.cornerRadius =  liveUserImage.frame.size.height/2

        commentBackground.layer.cornerRadius =  commentBackground.frame.size.height/2
        commentBackground.layer.borderWidth =  3
        commentBackground.layer.borderColor =  UIColor.gray.cgColor
      
        
      
        
        let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        sendCommentButton.setImage(image, for: .normal)
        sendCommentButton.tintColor = UIColor.gray
        commentField.textColor = UIColor.gray
        commentField.delegate = self
        
       
        
        
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
     
        
        seenView.layer.cornerRadius = 5
        seenView.clipsToBounds = true

        layoutConstraintsToAdjust.append(constraintContentHeight)
        webRTCClient.delegate = self
       
        addKeyboardObservers()
        self.setUpCamera()
       
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
     
        // Setup your camera here...
    }
   func addActionAlert ()
   {
 

   }
    
    @IBAction func sendCommentPressed(_ sender: Any) {
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

        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.bounds = screenSize
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.videoPreviewLayer.frame = screenSize
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
    
    @IBAction func cameraTogglePressed(_ sender: Any) {
     //   self.swapCamera()
        webRTCClient.switchCamera()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async { [self] in
            self.liveUserNameText = liveUserNameValue
            self.liveUserImageUrl = liveUserImageValue
            self.userProfileColorCode = liveUserProfileColor
            self.topicValue.text =  liveUsertopicValue
            liveUserProfile.updateViews(name: self.liveUserNameText, url:   self.liveUserImageUrl, colorCode:   self.userProfileColorCode)
            let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinner.mode = MBProgressHUDMode.indeterminate
            spinner.label.text = "Loading..."
        self.startLive()
        }
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
        self.setUserStatucToLive()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        IQKeyboardManager.sharedManager().enable = true
        webRTCClient.stop()
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func toggleMicButttonpressed(_ sender: Any) {
        webRTCClient.toggleAudio()
    }
    @IBAction func closeButtonPressed(_ sender: Any) {

        NotificationCenter.default.post(name: Notification.Name("EndLiveBYOtherUser"), object: nil)
    let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
    spinner.mode = MBProgressHUDMode.indeterminate
      spinner.label.text = "End Live..."
        self.setUserStatusEndLive()
      
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
}
extension JoinUserLiveVC: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> JoinUserLiveVC?{
        return UIStoryboard(name: StoryBoard.LIVE, bundle: nil).instantiateViewController(withIdentifier: JoinUserLiveVC.id) as? JoinUserLiveVC
    }
}
//https://34.207.130.236:5080/WebRTCAppEE/conference.html
extension JoinUserLiveVC {
    
    @objc func startLive()
    { //http://3.85.1.123:5080
        
              print("room\(liveID)")
               //Don't forget to write your server url.
              webRTCClient.setOptions(url: "ws://3.85.1.123:5080/WebRTCAppEE/websocket", streamId: "room\(liveID)", token: "", mode: .play, enableDataChannel: true)
              webRTCClient.setRemoteView(remoteContainer: cameraView, mode: .scaleAspectFill)
              webRTCClient.start()
        
//        webRTCClient.setOptions(url: "http://3.85.1.123:5080/WebRTCAppEE/play.html?name=room1148", streamId: "room\(1148)", token: "room\(liveID)" , mode: .play, enableDataChannel: true)
//        webRTCClient.setLocalView(container: cameraView, mode: .scaleAspectFill)
//        webRTCClient.setRemoteView(remoteContainer: cameraView, mode: .scaleAspectFill)
//        webRTCClient.start()
    }
    @objc func setUserStatucToLive()  {
        DispatchQueue.global(qos:.userInteractive).async { [self] in
        let op = UserLiveOperations()
            op.userViewLive (id: "\(friendId)", liveid: liveID ) { (onlineStat) in
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
                    if let views = onlineStat["viewData"] as? Array<[String:AnyObject]> {
                       
                        numberOfViews.text = "\(views.count)"
                    }
                }
                print(onlineStat)
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
extension JoinUserLiveVC : AntMediaClientDelegate
{
    func clientDidConnect(_ client: AntMediaClient) {
        print("Stream get connected")
        DispatchQueue.main.async { [weak self] in
    //    MBProgressHUD.hide(for: self.view , animated: true)
            self?.videoPreviewLayer.removeFromSuperlayer()
            self?.captureSession.stopRunning()
        }
    }

    
    func clientDidDisconnect(_ message: String) {
        print("Stream get error \(message)")
      //  self.closeButtonPressed((Any).self)

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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.addTimerCall()
            MBProgressHUD.hide(for: self.view , animated: true)
            self.videoPreviewLayer.removeFromSuperlayer()
            self.captureSession.stopRunning()
        }

    }
    
    func playFinished() {
        self.closeButtonPressed((Any).self)
    }
    
    func publishStarted() {
     
        DispatchQueue.main.async { [weak self] in
            MBProgressHUD.hide(for: (self?.view)! , animated: true)
            self?.videoPreviewLayer.removeFromSuperlayer()
            self?.captureSession.stopRunning()
        }
    
    }
    
    func publishFinished() {
        
    }
    
    func disconnected() {
    //    self.closeButtonPressed((Any).self)
    }
    
    func audioSessionDidStartPlayOrRecord() {
        
    }
    
    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        
    }
}

