//
//  EditPostVC.swift
//  myscrap
//
//  Created by MS1 on 7/26/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import AVKit
import AVFoundation

class EditPostVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    typealias DidPost = (Bool) -> Void
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postButoon: UIBarButtonItem!
    @IBOutlet private weak var removeImageBtn: UIButton!
    @IBOutlet private weak var profileView: ProfileView!
    @IBOutlet private weak var nameLabel : NameLabel!
    @IBOutlet private weak var cameraView: CircleView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var mentionsTableView: UITableView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var uploadProgress: UIProgressView!
    
    
    enum PostType{
        case normal
        case event
    }
    
    var postType: PostType = .normal
    
    var eventId: String?
    var eventPost = "1"
    
    var didPost: DidPost?
    
    var postImage: UIImage?
    var postText:String?
    // params to post
    
    let cellId = "cellId"
    var friendId = "0"
    var editPostId = ""
    
    
    var placehoder = "What's on your mind? \nType '@' to tag members."
    
    
    private var dataManager: MentionsTableViewDataManager?
    var mentionsListner : SZMentionsListener?
    
    
    var showVideo = URL(string: "")
    var player = AVPlayer()
    
    convenience init(didPost: @escaping DidPost){
        self.init()
        self.didPost = didPost
    }
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        picker.delegate = self
        picker.allowsEditing = true
        
        mentionsTableView.register(MemberTVC.classForCoder(), forCellReuseIdentifier: "cell")
        mentionsListner = SZMentionsListener(mentionTextView: textView, mentionsManager: self)
    
        if let listner = mentionsListner{
            dataManager = MentionsTableViewDataManager(mentionTableView: mentionsTableView, mentionsListener: listner, mentionTextView: textView)
        }
        
        mentionsTableView.delegate = dataManager
        mentionsTableView.dataSource = dataManager
        cameraView.layer.borderColor = UIColor.lightGray.cgColor
        cameraView.layer.borderWidth = 1.0
        setImage()
        profileView.updateViews(name: AuthService.instance.fullName, url: AuthService.instance.profilePic,  colorCode: AuthService.instance.colorCode)
        nameLabel.text = AuthService.instance.fullName
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        let addPhoto = UITapGestureRecognizer(target: self, action: #selector(addPhoto(_:)))
        addPhoto.numberOfTapsRequired = 1
        self.cameraView.addGestureRecognizer(addPhoto)
        
        textView.placeholder = NSString(string: placehoder)
        
       /*Mention.getMentions { (receivedMentions) in
            DispatchQueue.main.async {
                if let mentions = receivedMentions {
                    self.dataManager?.mentions = mentions
                    //dump(self.dataManager?.mentions)
                }
            }
        }*/
    }

    @objc func changeTextView(){
        togglePostBTn()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.togglePostBTn()
        self.togglePostImage()
        //self.togglePostVideo()
        IQKeyboardManager.sharedManager().enable = false
        self.keyboardObserver()
       
        let storedTextView = UserDefaults.standard.object(forKey: "postText") as? String
        if storedTextView != nil && postText == "" {
            textView.text = storedTextView
        } else {
            print("No textview values stored before")
            textView.text = postText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        friendId = "0"
        editPostId = ""
        postImage = nil
        postText = nil
        postImageView.image = nil
        textView.text = nil
        IQKeyboardManager.sharedManager().enable = true
        self.removeKeyboardObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func togglePostBTn(){
        
        let text = validate(textView: textView)
        if (self.postImageView.image == nil && !text){
            self.postButoon.isEnabled = false
        } else if self.showVideo != URL(string: "") {
            self.postButoon.isEnabled = true
        } else {
            self.postButoon.isEnabled = true
        }
    }
    
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                return false
        }
        return true
    }
    
    
    @IBAction private func closeButton(_ sender: UIButton){
        if postImage == nil && textView.text == "" {
            dismissController()
        } else {
            let alert = UIAlertController(title: "Do you want to discard this post?", message: nil, preferredStyle: .actionSheet)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            let discardAction = UIAlertAction(title: "Discard", style: .destructive, handler: { [unowned self] (action) in
                self.postImage = nil
                self.textView.text = ""
                self.dismissController()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(discardAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func dismissController(){
        self.view.endEditing(true)
        didPost?(true)
        self.dismiss(animated: true, completion: nil)
    }
  
   
    
    private func togglePostImage(){
        if (postImage == nil){
            postImageView.isHidden = true
            removeImageBtn.isHidden = true
        } else {
            postImageView.isHidden = false
            removeImageBtn.isHidden = false
        }
        view.layoutIfNeeded()
    }
    
    private func togglePostVideo() {
        
        if (showVideo == URL(string: "")) {
            uploadProgress.isHidden = true
            videoView.isHidden = true
            playBtn.isHidden = true
            
        } else {
            setupVideoView()
            uploadProgress.isHidden = false
            print("Video url after picked/captured : \(showVideo)")
            videoView.isHidden = false
            playBtn.isHidden = false
            
        }
        view.layoutIfNeeded()
    }
    
    func setupVideoView() {
        //2. Create AVPlayer object
        let asset = AVAsset(url: showVideo!)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        //3. Create AVPlayerLayer object
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds //bounds of the view in which AVPlayer should be displayed
        playerLayer.videoGravity = .resizeAspect
        
        //4. Add playerLayer to view's layer
        self.videoView.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        print("video ended")
        playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        player.seek(to: CMTime.zero)
        playBtn.tag = 0
        //player.play()
    }
    
    private func setImage() {
        if let fdImage = postImage{
            postImageView.image = fdImage
            removeImageBtn.isHidden = false
        }
        if let text = postText{
            textView.text = text
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing()
    }
    
    @IBAction func removeImagePressed(_ sender: UIButton){
        removeImage()
        self.togglePostImage()
        self.togglePostBTn()
        self.togglePostVideo()
    }
    
    func removeImage(){
        self.postImage = nil
        self.postImageView.image = nil
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }
    
    //MARK: -UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        var image : UIImage!
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = img
            postImage = image
            //postImageView.contentMode = .scaleAspectFit
            //postImageView.image = image
            setImage()
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
            postImage = image
            postImageView.contentMode = .scaleAspectFit
            //postImageView.image = image
            setImage()
            
        } else if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            self.showVideo = video
            self.togglePostVideo()
            
        }
        togglePostBTn()
        picker.dismiss(animated: true,completion: nil)
        
        /*
        picker.dismiss(animated: true, completion: nil)
        
         guard let videoUrl = info[UIImagePickerControllerMediaURL] as? URL else {
         return
         }
         //uploadMedia(videoUrl: videoUrl)
         
        guard let videoUrl = info[UIImagePickerControllerMediaURL] as? URL else {
            return
        }
        //uploadMedia(videoUrl: videoUrl)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //multipartFormData.append(fileURL: videoUrl, name: "video")
            //multipartFormData.append(videoUrl, withName: "content")
            let timestamp = NSDate().timeIntervalSince1970
            multipartFormData.append(videoUrl, withName: "content", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
            multipartFormData.append("\(AuthService.instance.userId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "userId")
        }, to: "https://myscrap.com/video/upload_video") { (response) in
            debugPrint(response)
            switch response {
                
            case .success(let request, _, _):
                
                request.responseJSON(completionHandler: { (jsonResponse) in
                    print("Response from json : \(jsonResponse.result.value)")
                })
            case .failure(let error):
                print("Error while upload :\(error)")
            }
        }
        */
    }
    
    @IBAction func videoPlayTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
            //5. Play Video
            player.play()
            sender.tag = 1
        } else {
            playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            sender.tag = 0
            player.pause()
        }
    }
    @objc func addPhoto(_ sender : UIGestureRecognizer){
        if textView.text != nil {
            UserDefaults.standard.set(textView.text, forKey: "postText")
        }
        /*if showVideo != URL(string: "") {
            showVideo = URL(string: "")
            togglePostVideo()
        }*/
        //selectPhoto()
        let Alert = UIAlertController(title: "Pick one option", message: "Choose an option to post into Feeds", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take Photo/Video", style: .default) { [weak self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self!.picker.sourceType = .camera
                self!.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
                self!.picker.showsCameraControls = true
                self!.picker.isToolbarHidden = true
                self!.picker.videoMaximumDuration = TimeInterval(60.0)
                self!.picker.allowsEditing = true
                self!.picker.videoQuality = .typeHigh
                //self?.picker.cameraCaptureMode =  UIImagePickerControllerCameraCaptureMode.photo
                //self?.picker.cameraCaptureMode = .video
                //self?.picker.modalPresentationStyle = .custom
                self!.present(self!.picker,animated: true,completion: nil)
            }
            else
            {
                self?.nocamera()
            }
        }
        /*let photo = UIAlertAction(title: "Gallery", style: .default) { [unowned self] (action) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
            
        }*/
        let photo = UIAlertAction(title: "Photo Library", style: .default) { [unowned self] (action) in
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = ["public.image"]
            self.present(self.picker, animated: true, completion: nil)
            
        }
        let video = UIAlertAction(title: "Video Library", style: .default) { [unowned self] (action) in
            self.picker.sourceType = .photoLibrary
            self.picker.videoMaximumDuration = TimeInterval(60.0)
            self.picker.mediaTypes = ["public.movie"]
            self.present(self.picker, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.addAction(camera)
        Alert.addAction(photo)
        Alert.addAction(video)
        Alert.addAction(cancel)
        Alert.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(Alert, animated: true, completion: nil)
        
    }
    
    //MARK: -UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func nocamera()
    {
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    
    func selectPhoto(){
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 200, height: 200))
        let cameraVC = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] (image, asset) in
            self?.postImage = image
            self?.setImage()
            self?.togglePostBTn()
            self?.dismiss(animated: true, completion: nil)
            self?.togglePostBTn()
        }
        present(cameraVC, animated: true, completion: nil)
    }
    
    
    func postData(){
        if showVideo != URL(string: "") {
            var content = ""
            var tagParms = ""
            if validate(textView: textView){
                content = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                content = content.replacingOccurrences(of: "+", with: "%2B")
            }
            var ipAdress = ""
            if AuthService.instance.getIFAddresses().count >= 1 {
                ipAdress = AuthService.instance.getIFAddresses().description
            }
            
            let dictionary: [[String: String]]?
            var dic = [[String:String]]()
            let item = ["taggedId": "", "taggedUserName":""]
            dic.append(item)
            
            if let listner = mentionsListner{
                var dicts = [[String:String]]()
                let array = listner.mentions
                for obj in array{
                    let item = ["taggedId": obj.mentionObject.mentionId, "taggedUserName":obj.mentionObject.mentionName]
                    dicts.append(item)
                    dump(dicts)
                }
                dictionary = removeDuplicates(dicts)
                dump(dictionary)
                if let tag = dictionary {
                    let dict = ["tagging": tag]
                    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) , let string = String(data: jsonData, encoding: .ascii){
                        tagParms = "\(string)"
                    }
                }
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    //multipartFormData.append(fileURL: videoUrl, name: "video")
                    //multipartFormData.append(videoUrl, withName: "content")
                    let timestamp = NSDate().timeIntervalSince1970
                    multipartFormData.append(self.showVideo!, withName: "userfile", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
                    multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "content")
                    multipartFormData.append("\(AuthService.instance.userId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "userId")
                    multipartFormData.append(API_KEY.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "apiKey")
                    multipartFormData.append(tagParms.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "tagged")
                    multipartFormData.append("\(Int(Date().timeIntervalSince1970))".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "timeStamp")
                    multipartFormData.append(MOBILE_DEVICE.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device")
                    multipartFormData.append(self.friendId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "friendId")
                    multipartFormData.append(ipAdress.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "ipAddress")
                    
                }, to: "https://myscrap.com/video/ios/upload_video") { (response) in
                    debugPrint(response)
                    switch response {
                        
                    case .success(let request, _, _):
                        
                        //Upload Progress
                        request.uploadProgress(closure: { (progress) in
                            let totalBytes = progress.fractionCompleted
                            self.uploadProgress.progress = Float(totalBytes)
                            
                            DispatchQueue.main.async {
                                /*if totalBytes == 1.00000 {
                                 self.hideActivityIndicator()
                                 } else {
                                 //self.showActivityIndicator(with: String(format:"%f", totalBytes))
                                 self.uploadProgress.progress = Float(totalBytes)
                                 //self.showActivityIndicator(with: "Uploading")
                                 }*/
                            }
                        })
                        
                        request.responseJSON(completionHandler: { (jsonResponse) in
                            print("Response from json : \(jsonResponse.result.value)")
                            switch jsonResponse.result {
                            case .success(let value):
                                if let dict = value as? [String: AnyObject] {
                                    if let uploadedVideo = dict["status"] as? String {
                                        if uploadedVideo == "success" {
                                            let fromServer = dict["videoUrl"] as? String
                                            print("Video url : \(fromServer)")
                                            //self.showVideo = URL(string: fromServer!)
                                        }
                                    }
                                }
                                
                            case .failure(_):
                                print("Response error from server")
                            }
                        })
                        
                    case .failure(let error):
                        print("Error while upload :\(error)")
                    }
                }
                
            }
        } else {
            var content = ""
            var feedImage = ""
            if postImageView?.image != nil{
                let imageData: Data = postImageView!.image!.jpegData(compressionQuality: 0.6)!
                let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
                feedImage = imageString
            }
            
            if validate(textView: textView){
                content = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            
            let dictionary: [[String: String]]?
            var dic = [[String:String]]()
            let item = ["taggedId": "", "taggedUserName":""]
            dic.append(item)
            if let listner = mentionsListner{
                var dicts = [[String:String]]()
                let array = listner.mentions
                for obj in array{
                    let item = ["taggedId": obj.mentionObject.mentionId, "taggedUserName":obj.mentionObject.mentionName]
                    dicts.append(item)
                    dump(dicts)
                }
                dictionary = removeDuplicates(dicts)
                dump(dictionary)
                
                let service = DetailService()
                service.insertPost(friendId: friendId, editPostId: editPostId, content: content.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!, feedImage: feedImage,eventId:eventId, tagging: dictionary) { (success) in
                    DispatchQueue.main.async {
                        if success {
                            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                self.dismiss(animated: true, completion: nil)
                                self.didPost?(true)
                            }, completion: nil)
                            self.showMessage(with: "Post Edited Succesfully")
                        } else {
                            //todo :- error
                            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                self.didPost?(false)
                                self.dismiss(animated: true, completion: nil)
                            }, completion: nil)
                        }
                    }
                }
            } else {
                let dictionary: [[String: String]]?
                var dic = [[String:String]]()
                let item = ["taggedId": "", "taggedUserName":""]
                dic.append(item)
                
                let service = DetailService()
                service.insertPost(friendId: friendId, editPostId: editPostId, content: content, feedImage: feedImage,eventId:eventId, tagging: dic) { (success) in
                    DispatchQueue.main.async {
                        if success {
                            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                self.dismiss(animated: true, completion: nil)
                                self.didPost?(true)
                            }, completion: nil)
                            self.showMessage(with: "Post Edited Succesfully")
                        } else {
                            //todo :- error
                            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                self.didPost?(false)
                                self.dismiss(animated: true, completion: nil)
                            }, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func postClicked(_ sender: Any) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if (text != ""  || postImageView.image != nil){
            self.postButoon.isEnabled = false
            showActivityIndicator(with: "")
            self.postData()
        }
    }
    
    static func storyBoardReference() -> EditPostVC? {
        let storyboard = UIStoryboard(name: "POST", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "EditPostVC") as? EditPostVC
    }
    
    deinit {
        print("Edit POST VC DEINITED")
    }

}

extension EditPostVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view{
            if touchedView.isDescendant(of: mentionsTableView){
                return false
            }
        }
        return true
    }
}




extension EditPostVC: MentionsManagerDelegate{
    func textviewsCondition() {
        togglePostBTn()
    }
    func showMentionsListWithString(_ mentionsString: String) {
        mentionsTableView.isHidden = false
        dataManager?.filter(mentionsString)
    }
    
    func hideMentionsList() {
        mentionsTableView.isHidden = true
        dataManager?.filter(nil)
    }
    
    func didHandleMentionOnReturn() -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        togglePostBTn()
    }
    
    
    fileprivate func removeDuplicates(_ arrayOfDicts: [[String: String]]) -> [[String: String]] {
        var removeDuplicates = [[String: String]]()
        var arrOfDict = [String]()
        for dict in arrayOfDicts {
            if let name = dict["taggedId"], !arrOfDict.contains(name) {
                removeDuplicates.append(dict)
                arrOfDict.append(name)
            }
        }
        return removeDuplicates
    }
    
}

