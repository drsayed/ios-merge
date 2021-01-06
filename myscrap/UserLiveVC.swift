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
class UserLiveVC: UIViewController,KeyboardAvoidable ,UITextFieldDelegate{

    var liveID = "0"
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var liveTimerView: UIView!
    @IBOutlet weak var liveTimerTextLable: UILabel!
    @IBOutlet weak var seenIcon: UIImageView!
    @IBOutlet weak var seenView: UIView!
    @IBOutlet weak var countDown: SFCountdownView!
    var layoutConstraintsToAdjust: [NSLayoutConstraint] = []
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var micButton: UIButton!
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
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.videoPreviewLayer.frame = self.cameraView.bounds
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
            op.allUsersLiveStatus (id: "\(AuthService.instance.userId)" ) { (onlineStat) in
//                if let online = onlineStat["liveid"] as? String{
//                    self.liveID = online
//                    self.perform(#selector(self.startLive), with: self, afterDelay: 0.0)
//
//                }
                DispatchQueue.main.async { [self] in
                    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
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
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        IQKeyboardManager.sharedManager().enable = true
        webRTCClient.stop()
        self.navigationController?.navigationBar.isHidden = false
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
        webRTCClient.setOptions(url: "ws://3.85.1.123:5080/WebRTCAppEE/websocket", streamId: "room\(liveID)" , token: "", mode: .publish, enableDataChannel: true)
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
//              MBProgressHUD.hide(for: self.view , animated: true)
                  
             self.navigationController?.popToRootViewController(animated: true)
                  }
             
                print(onlineStat)
        }
        }
    }
    func cancelButtonTapped() {
        print("cancelButtonTapped")
        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension UserLiveVC : AntMediaClientDelegate
{
    func clientDidConnect(_ client: AntMediaClient) {
        print("Stream get connected")
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
