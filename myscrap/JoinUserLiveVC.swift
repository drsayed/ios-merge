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
    var userJoined = Array<[String:AnyObject]>()

    var timer = Timer()
    var liveComments = [CommentMessage]()
    {
        didSet
        {
            self.reloadComentsView()
        }
    }
    @IBOutlet weak var commentViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var UserCommentsBackground: UIView!
    @IBOutlet weak var userCommentsCollectionView: UICollectionView!
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
      
        
        commentField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        sendCommentButton.setImage(image, for: .normal)
        sendCommentButton.tintColor = UIColor.gray
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
        webRTCClient.delegate = self
       
        addKeyboardObservers()
        self.setUpCamera()
        self.setUpCommentViews()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.length > 0 {
            sendCommentButton.tintColor = UIColor.MyScrapGreen
        }
        else{
            sendCommentButton.tintColor = UIColor.gray
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
    
    @IBAction func sendCommentPressed(_ sender: Any) {
        
        if commentField.text!.length > 0 {
            var comment = CommentMessage()
            comment.messageText = commentField.text!
            comment.name = AuthService.instance.fullName
            comment.profilePic = AuthService.instance.profilePic
            comment.colorCode = AuthService.instance.colorCode
            comment.userId = AuthService.instance.userId
            self.liveComments.append(comment)
            
            let dic = ["fullName": AuthService.instance.fullName, "profilePic": AuthService.instance.profilePic , "message": commentField.text!, "colorCode": AuthService.instance.colorCode, "userId": AuthService.instance.userId]
            
            let data = NSKeyedArchiver.archivedData(withRootObject: dic)
            webRTCClient.sendData(data: data, binary: false)
            commentField.text = ""
            sendCommentButton.tintColor = UIColor.gray

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
        for i in 0..<userJoined.count {
              let dict = userJoined[i]
            var isFound = false
            for viewer in viewers {
                if dict["userId"] as! String == viewer["userId"] as! String {
                    isFound = true
                }
            }
            if !isFound {
                self.addLeftUser(dict: dict)
                userJoined.remove(at: i)

            }
        }
    }
    func findIfAlreadyJoined(viewers : Array<[String:AnyObject]>) {
    
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
      //  self.findIfAlreadyLeft(viewers: viewers)
    }
    @IBAction func cameraTogglePressed(_ sender: Any) {
     //   self.swapCamera()
        webRTCClient.switchCamera()

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
            let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinner.mode = MBProgressHUDMode.indeterminate
            spinner.isUserInteractionEnabled = false
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
            self.userCommentsCollectionView.contentOffset = CGPoint(x: 0, y: self.userCommentsCollectionView.contentSize.height - self.userCommentsCollectionView.bounds.size.height)
            
            if  self.userCommentsCollectionView.contentSize.height > self.userCommentsCollectionView.bounds.size.height
            {
                self.userCommentsCollectionView.flashScrollIndicators()
            }
            // ready
        })
    }
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
        webRTCClient.toggleAudio()
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
    deinit {
        removeKeyboardObservers()
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
        webRTCClient.setOptions(url: Endpoints.LiveUser, streamId: "room\(liveID)", token: "", mode: .play, enableDataChannel: true)
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
  // self.closeButtonPressed((Any).self)

    }
    
    func clientHasError(_ message: String) {
        print("Stream get error \(message)")
    }
    
    func remoteStreamStarted() {
        
    }
    
    func remoteStreamRemoved() {
        self.closeButtonPressed((Any).self)
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
    //    self.closeButtonPressed((Any).self)
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
  // self.closeButtonPressed((Any).self)
    }
    
    func audioSessionDidStartPlayOrRecord() {
        
    }
    
    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        
        do {
            
            let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: data)

                    if let dict = unarchivedDictionary as? [String: AnyObject]{
                        var comment = CommentMessage()
                        comment.messageText = dict["message"]! as! String
                        comment.name = dict["fullName"]! as! String
                        comment.profilePic =  dict["profilePic"]! as! String
                        comment.colorCode =  dict["colorCode"]! as! String
                        comment.userId = dict["userId"]! as! String
                        
                        self.liveComments.append(comment)
    
                    }
                } catch{
                    print(error)
                }
        }
}
extension JoinUserLiveVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
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
