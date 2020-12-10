//
//  LiveDiscussion.swift
//  myscrap
//
//  Created by MyScrap on 12/29/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import BTNavigationDropdownMenu
import XMPPFramework

enum GrpMsgSwitch {
    case Add
    case Delete
}
class LiveDiscussion: BaseRevealVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageInputView: LiveInputView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackBottom: NSLayoutConstraint!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    
    
    //OnlineMembers
    @IBOutlet weak var onlineCollectionView: UICollectionView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var onlineUserView: CircleView!
    @IBOutlet weak var onlineProfileView: ProfileView!
    @IBOutlet weak var onlineInitialLabel: UILabel!
    @IBOutlet weak var onlinProfileImageView: UIImageView!
    @IBOutlet weak var grpuserBtn: UIButton!
    @IBOutlet weak var noOfOnlineMemLbl: UILabel!
    @IBOutlet weak var closeLiveBtn: UIButton!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userView: CircleView!
    @IBOutlet weak var firstUserIV: UIImageView!
    @IBOutlet weak var firstView: CircleView!
    @IBOutlet weak var secUserIV: UIImageView!
    @IBOutlet weak var secView: CircleView!
    @IBOutlet weak var thirdUserIV: UIImageView!
    @IBOutlet weak var thirdView: CircleView!
    @IBOutlet weak var fourthUserIV: UIImageView!
    @IBOutlet weak var fourthView: CircleView!
    @IBOutlet weak var fifthUserIV: UIImageView!
    @IBOutlet weak var fifthView: CircleView!
    
    
    //Topic
    @IBOutlet weak var topicCircleView: CircleView!
    @IBOutlet weak var topicIconBtn: UIButton!
    @IBOutlet weak var leftTopicLbl: UILabel!
    @IBOutlet weak var nameTULbl: UILabel!
    
    //Message Input view
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var profileCircleView: CircleView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var profileIV: CircularImageView!
    @IBOutlet weak var msgInputView: ReceiverView!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var msgTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var heartCircleVIew: CircleView!
    @IBOutlet weak var likeCircleView: CircleView!
    @IBOutlet weak var menuCircleView: CircleView!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    
    var shouldScrollToBottom = false
    
    var msgText = [""]
    var fromUser = [""]
    var uName = [""]
    var uColor = [""]
    var uRank = [""]
    var timer: Timer!
    
    var name = ""
    var topicSubject = ""
    
    var service = OnlinePresenceModel()
    var dataSource = [OnlinePresence]()
    weak var delegate : OnlinePresenceModelDelegate?
    
    var xmppStream: XMPPStream?
    let picker = UIImagePickerController()
    
    var onlineArray = [[String]]()
    var imgArray = [""]
    var nameArray = [""]
    var onlineDict = [[String:[String : String]]]()
    var updatedDict = [[String:[String : String]]]()
    //var onlineNameArray = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.onlineProfileView.isHidden = true
        self.noOfOnlineMemLbl.text = "0"
        
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        //picker.allowsEditing = true
        
        /*let items = ["Feeds", "Live Discussion"]
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView:(self.navigationController?.view)!, title: BTTitle.index(1), items: items)
        self.navigationItem.titleView = menuView
        //menuView.arrowTintColor = UIColor.white
        menuView.cellTextLabelAlignment = .left
        menuView.cellTextLabelColor = UIColor.MyScrapGreen
        menuView.menuTitleColor = UIColor.white
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("I am here so this is my stuff")
            
            if items[indexPath] == "Live Discussion" {
                print("I'm in live discussion")
                //self!.present(controller!, animated: true, completion: nil)
            } else {
                print("In Feeds module")
                let vc = FeedsVC.storyBoardInstance()!
                let rearViewController = MenuTVC()
                let frontNavigationController = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                self?.present(mainRevealController, animated: true, completion: {
                    //NotificationCenter.default.post(name: .userSignedIn, object: nil)
                })
            }
        }*/
        
        mainView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        messageInputView.backgroundColor = .clear
 
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        //KeyboardShow or Hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //Setup
        setupCollectionView()
        //setupInputView()
        setupTap()
        setupTopView()
        setupBottomView()
        /**
        Ad Image clickable
        **/
        let tap = UITapGestureRecognizer(target: self, action: #selector(LiveDiscussion.tapDetected))
        tap.numberOfTapsRequired = 1
        adImageView.isUserInteractionEnabled = true
        adImageView.addGestureRecognizer(tap)
    }
    
    func setupTopView() {
        onlineUserView.layer.borderWidth = 0.5
        onlineUserView.layer.borderColor = UIColor.white.cgColor
        onlineUserView.layer.shadowColor = UIColor.white.cgColor
        onlineUserView.layer.shadowOffset = CGSize.zero
        onlineUserView.layer.shadowOpacity = 1
        onlineUserView.layer.shadowRadius = 10
        onlineUserView.layer.masksToBounds = true
        
        /*userView.layer.borderWidth = 0.5
        userView.layer.borderColor = UIColor.white.cgColor
        userView.layer.shadowColor = UIColor.white.cgColor
        userView.layer.shadowOffset = CGSize.zero
        userView.layer.shadowOpacity = 1
        userView.layer.shadowRadius = 10
        userView.layer.masksToBounds = true*/
        
        
        grpuserBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 13, style: .solid)
        grpuserBtn.setTitle(String.fontAwesomeIcon(name: .users), for: .normal)
        
        topicIconBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 12, style: .solid)
        topicIconBtn.setTitle(String.fontAwesomeIcon(name: .bullhorn), for: .normal)
        
        /*firstView.layer.borderWidth = 0.5
        firstView.layer.borderColor = UIColor.white.cgColor
        firstView.layer.shadowColor = UIColor.white.cgColor
        firstView.layer.shadowOffset = CGSize.zero
        firstView.layer.shadowOpacity = 1
        firstView.layer.shadowRadius = 10
        firstView.layer.masksToBounds = true
        
        secView.layer.borderWidth = 0.5
        secView.layer.borderColor = UIColor.white.cgColor
        secView.layer.shadowColor = UIColor.white.cgColor
        secView.layer.shadowOffset = CGSize.zero
        secView.layer.shadowOpacity = 1
        secView.layer.shadowRadius = 10
        secView.layer.masksToBounds = true
        
        thirdView.layer.borderWidth = 0.5
        thirdView.layer.borderColor = UIColor.white.cgColor
        thirdView.layer.shadowColor = UIColor.white.cgColor
        thirdView.layer.shadowOffset = CGSize.zero
        thirdView.layer.shadowOpacity = 1
        thirdView.layer.shadowRadius = 10
        thirdView.layer.masksToBounds = true
        
        fourthView.layer.borderWidth = 0.5
        fourthView.layer.borderColor = UIColor.white.cgColor
        fourthView.layer.shadowColor = UIColor.white.cgColor
        fourthView.layer.shadowOffset = CGSize.zero
        fourthView.layer.shadowOpacity = 1
        fourthView.layer.shadowRadius = 10
        fourthView.layer.masksToBounds = true
        
        fifthView.layer.borderWidth = 0.5
        fifthView.layer.borderColor = UIColor.white.cgColor
        fifthView.layer.shadowColor = UIColor.white.cgColor
        fifthView.layer.shadowOffset = CGSize.zero
        fifthView.layer.shadowOpacity = 1
        fifthView.layer.shadowRadius = 10
        fifthView.layer.masksToBounds = true*/
        
        /*userImageView.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        firstUserIV.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        secUserIV.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        thirdUserIV.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        fourthUserIV.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        fifthUserIV.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
         */
        
        //Topic view
        topicCircleView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        leftTopicLbl.textColor = UIColor(hexString: "#f4ef5d").withAlphaComponent(1.0)
        let attrs = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 12), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#7cd8cb").withAlphaComponent(1.0)]
        let attributedString = NSMutableAttributedString(string: "BMR Conference", attributes:attrs)
        let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(1.0)]
        let attributedString1 = NSMutableAttributedString(string: " By Emma Stone", attributes:attrs1)
        attributedString.append(attributedString1)
        nameTULbl.attributedText = attributedString
    }
    
    func setupBottomView() {
        profileCircleView.backgroundColor = UIColor(hexString: AuthService.instance.colorCode)
        profileCircleView.layer.borderColor = UIColor.white.cgColor
        profileCircleView.layer.borderWidth = 0.5
        profileIV.sd_setImage(with: URL(string: AuthService.instance.profilePic), completed: nil)
        initialLbl.text = AuthService.instance.initial
        
        
        //Textview
        msgTextView.text = "Chat with everyone"
        msgTextView.textColor = .lightGray
        
        //Send button
        let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        sendBtn.setImage(image, for: .normal)
        sendBtn.tintColor = UIColor.lightGray
        sendBtn.isEnabled = false
        
        //SideButtons
        heartBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        heartBtn.setTitle(String.fontAwesomeIcon(name: .heart), for: .normal)
        
        likeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        likeBtn.setTitle(String.fontAwesomeIcon(name: .thumbsUp), for: .normal)
        
        menuBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        menuBtn.setTitle(String.fontAwesomeIcon(name: .ellipsisV), for: .normal)
    }
    
    func setupTextView() {
        msgTextView.delegate = self
        //msgTextView.isScrollEnabled = false
        msgTextView.sizeToFit()
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .lightGray
            sendBtn.isEnabled = false
        }
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = ""
            //textView.isEditable = false
            textView.textColor = UIColor.black
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = UIColor.lightGray
            sendBtn.isEnabled = false
            
        }
        return true
    }
    
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /*if textView.text == " " {
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .lightGray
            sendBtn.isEnabled = false
        } /*else if textView.text.isEmpty {
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .lightGray
            sendBtn.isEnabled = false
        }*/ else if textView.text == nil {
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .lightGray
            sendBtn.isEnabled = false
        } else if textView.text == "" {
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .lightGray
            sendBtn.isEnabled = false
        }
        else {
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .MyScrapGreen
            sendBtn.isEnabled = true
        }*/
        if validate(textView: textView) {
            // do something
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .MyScrapGreen
            sendBtn.isEnabled = true
        } else {
            // do something else
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .lightGray
            sendBtn.isEnabled = false
        }
        return true
        
        
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ""
            //textView.isEditable = false
            textView.textColor = UIColor.black
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = UIColor.lightGray
            sendBtn.isEnabled = false
            
        } else {
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = .MyScrapGreen
            sendBtn.isEnabled = true
        }
//        let fixedWidth = textView.frame.size.width
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        let isOverSize = textView.contentSize.height >= msgTVHeightConstraint.constant
//        textView.isScrollEnabled = isOverSize
//        msgTVHeightConstraint.isActive = isOverSize
//        if isOverSize {
//
//            textView.height = 80
//        } else {
//            textView.isScrollEnabled = isOverSize
//            //textView.height = textView.contentSize.height
//        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Chat with everyone"
            //textView.isEditable = false
            textView.textColor = UIColor.lightGray
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = UIColor.lightGray
            sendBtn.isEnabled = false
        }
    }
    
    //MARK: -UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        var image : UIImage!
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = img
            bgImage.contentMode = .scaleAspectFill
            bgImage.image = image
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
            bgImage.contentMode = .scaleAspectFill
            bgImage.image = image
        }
        picker.dismiss(animated: true,completion: nil)
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

    /**
     Timer called
     **/
    @objc func runTimedCode() {
        timer.invalidate()
        //XMPPService.instance.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    /**
    Tapped Ad Image
    **/
    @objc func tapDetected() {
        if let url = URL(string: "http://www.sayedmetal.com/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    deinit {
        print("deinited conversation vc")
        removeKeyBoardObserver()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("Height : \(keyboardSize.height)")
            print("Bottom constant : \(bottomConstraint.constant)")
            if bottomConstraint.constant == 0 {
                UIView.animate(withDuration: 0.1) {
                     
                    self.bottomConstraint.constant -= keyboardSize.height
                    print("Bottom constraint : \(self.bottomConstraint.constant)")
                    if self.msgText != [""] {
                        self.scrollToBottom()
                    }
                    
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if bottomConstraint.constant != 0 {
            UIView.animate(withDuration: 0.1) {
                self.bottomConstraint.constant = 0
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        //Add member presence in live
        addMembers()
        XMPPService.instance.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        //XMPPService.instance.addMembers()
        //sendOnline()
        getBackgroundWall()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        offline()
        UserDefaults.standard.set(false, forKey: "joinedStatus")
        IQKeyboardManager.sharedManager().enable = true
        self.onlineDict.removeAll()
        removeKeyBoardObserver()
        
    }
    func setupCollectionView() {
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func setupInputView() {
        messageInputView.inputTextView.placeholder = "Say Hi..."
        messageInputView.delegate = self
    }
    private func setupTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(setresponding))
        tap.numberOfTapsRequired = 1
        collectionView.addGestureRecognizer(tap)
    }
    @objc
    private func setresponding(){
        msgTextView.resignFirstResponder()
    }
    func sendOnlineAPI(jid: String) {
        service.delegate = self
        service.sendPresence(xmppUserId: jid)
    }
    func sendOfflineAPI(jid: String) {
        service.delegate = self
        service.sendOffline(xmppUserId: jid)
    }
    //using
    @IBAction func sendMsgTapped(_ sender: UIButton) {
        let rank = Int(AuthService.instance.userRank)
        let newJoined = AuthService.instance.isNewJoined
        print("rank in did send : \(rank!), new joined : \(newJoined) , Message : \(msgTextView.text!)")
        if newJoined == true && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank : \(rank!)")
            self.sendGrpMsg(text: msgTextView.text, uColor: UIColor.NEW_COLOR.toHex!, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        } else if newJoined == false && rank! <= 9 {
            print("Color : \(AuthService.instance.colorCode), Rank count : \(rank!)")
            self.sendGrpMsg(text: msgTextView.text, uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "Top \(rank!)")
        } else if newJoined == false && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank count else : \(rank!)")
            self.sendGrpMsg(text: msgTextView.text, uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        }
    }
    
    @IBAction func heartBtnTapped(_ sender: UIButton) {
        let rank = Int(AuthService.instance.userRank)
        let newJoined = AuthService.instance.isNewJoined
        print("rank in did send : \(rank!), new joined : \(newJoined) , Message : ❤)")
        if newJoined == true && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank : \(rank!)")
            self.sendGrpMsg(text: "❤", uColor: UIColor.NEW_COLOR.toHex!, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        } else if newJoined == false && rank! <= 9 {
            print("Color : \(AuthService.instance.colorCode), Rank count : \(rank!)")
            self.sendGrpMsg(text: "❤", uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "Top \(rank!)")
        } else if newJoined == false && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank count else : \(rank!)")
            self.sendGrpMsg(text: "❤", uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        }
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        
        let rank = Int(AuthService.instance.userRank)
        let newJoined = AuthService.instance.isNewJoined
        print("rank in did send : \(rank!), new joined : \(newJoined) , Message : 👍)")
        if newJoined == true && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank : \(rank!)")
            self.sendGrpMsg(text: "👍", uColor: UIColor.NEW_COLOR.toHex!, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        } else if newJoined == false && rank! <= 9 {
            print("Color : \(AuthService.instance.colorCode), Rank count : \(rank!)")
            self.sendGrpMsg(text: "👍", uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "Top \(rank!)")
        } else if newJoined == false && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank count else : \(rank!)")
            self.sendGrpMsg(text: "👍", uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        }
    }
    
    @IBAction func menuBtnTapped(_ sender: UIButton) {
        let outer_alert = UIAlertController(title: "Customize the LIVE", message: nil, preferredStyle: .actionSheet)
        let name = UIAlertAction(title: "Topic", style: .default) { (action) in
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertView") as! CustomAlertView
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
        }
//        UIAlertAction(title: "Change Wallpaper", style: .default) { (<#UIAlertAction#>) in
//            <#code#>
//        }
        let country = UIAlertAction(title: "Change Wallpaper", style: .default) { (action) in
//            self.picker.sourceType = .photoLibrary
//            self.present(self.picker, animated: true, completion: nil)
            /*let Alert = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
            let name = UIAlertAction(title: "Camera", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera)
                {
                    self.picker.sourceType = UIImagePickerControllerSourceType.camera
                    self.picker.cameraCaptureMode =  UIImagePickerControllerCameraCaptureMode.photo
                    self.picker.modalPresentationStyle = .custom
                    self.present(self.picker,animated: true,completion: nil)
                }
                else
                {
                    self.nocamera()
                }
            }
            let country = UIAlertAction(title: "Gallery", style: .default) { (action) in
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
                
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            Alert.addAction(name)
            Alert.addAction(country)
            Alert.addAction(cancel)
            Alert.view.tintColor = UIColor.GREEN_PRIMARY
            self.present(Alert, animated: true, completion: nil)*/
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "BGWallListView") as! BGWallListView
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        outer_alert.addAction(name)
        outer_alert.addAction(country)
        outer_alert.addAction(cancel)
        outer_alert.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(outer_alert, animated: true, completion: nil)
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        let vc = FeedsVC.storyBoardInstance()!
        let rearViewController = MenuTVC()
        let frontNavigationController = UINavigationController(rootViewController: vc)
        let mainRevealController = SWRevealViewController()
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        self.present(mainRevealController, animated: true, completion: {
            //NotificationCenter.default.post(name: .userSignedIn, object: nil)
        })
    }
    /*
    Collection View
    */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == onlineCollectionView {
            return 1
        } else {
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == onlineCollectionView {
            if self.updatedDict.last?.count != nil {
                if self.updatedDict.last!.count == 0 {
                    return 0
                }
                else {
                    for dict in updatedDict {
                        print("For in dict : \(dict)")
                    }
                    print("Dictionary count : \(self.updatedDict.count)")
                    return self.updatedDict.count
                }
            } else {
                return 0
            }
        } else {
            if section == 0 {
                return 1
            }
            else {
                if msgText == [""]{
                    return 0
                } else {
                    return msgText.count
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == onlineCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "live_members", for: indexPath) as! LiveOnlineScrollCell
            let inside = updatedDict[indexPath.item]
            print("Initials fetch : \(inside)")
            let initi = inside.filter { (get_inside) -> Bool in
                let userIDArray = get_inside.value
                let profilePic = userIDArray["profilePic"]
                let initals = userIDArray["name"]
                
                print("Profile Picture : \(profilePic!)")
                if profilePic != "" {
                    cell.initialLbl.text = initals!
                    cell.profileImageView.isHidden = false
                    cell.profileView.layer.borderColor = UIColor.white.cgColor
                    cell.profileView.layer.borderWidth = 1
                    cell.profileImageView.sd_setImage(with: URL(string: profilePic!), completed: nil)
                } else {
                    cell.profileView.layer.borderColor = UIColor.white.cgColor
                    cell.profileView.layer.borderWidth = 1
                    cell.profileImageView.isHidden = true
                    cell.initialLbl.text = initals!
                }
                
                
                return true
            }
            
            //cell.initialLbl.text =
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopAlertCell", for: indexPath) as! TopAlertCell
                return cell
            } else {
                if msgText != [""] {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveReceiver", for: indexPath) as! LiveReceiver
                    cell.receiverView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    if msgText[indexPath.item].contains("changed the TOPIC") {
                        let attrs = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 16), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#b3b5b4").withAlphaComponent(1.0)]
                        let attributedString = NSMutableAttributedString(string:uName[indexPath.item] + ": ", attributes:attrs)
                        let msg = msgText[indexPath.item]
                        let char = msg.range(of: "changed the TOPIC as ")
                        
                        let first = msg[msg.startIndex..<char!.upperBound]
                        let changeColor = msg[char!.upperBound..<msg.endIndex]
                        print("show value of subject change : \(changeColor)")
                        let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(1.0)]
                        let attributedString1 = NSMutableAttributedString(string:String(first), attributes:attrs1)
                        attributedString.append(attributedString1)
                        let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#7cd8cb").withAlphaComponent(1.0)]
                        let attributedString2 = NSMutableAttributedString(string:String(changeColor), attributes:attrs2)
                        attributedString.append(attributedString2)
                        
                        cell.messageLabel.attributedText = attributedString
                    } else if msgText[indexPath.item].contains("joined the LIVE") {
                        let attrs = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 16), NSAttributedString.Key.foregroundColor : UIColor(hexString: "b3b5b4").withAlphaComponent(1.0)]
                        let attributedString = NSMutableAttributedString(string:uName[indexPath.item] + ": ", attributes:attrs)
                        let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "f4ef5d").withAlphaComponent(1.0)]
                        let attributedString1 = NSMutableAttributedString(string:msgText[indexPath.item], attributes:attrs1)
                        attributedString.append(attributedString1)
                        
                        cell.messageLabel.attributedText = attributedString
                    } else if msgText[indexPath.item].contains("left the LIVE") {
                        let attrs = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 16), NSAttributedString.Key.foregroundColor : UIColor(hexString: "b3b5b4").withAlphaComponent(1.0)]
                        let attributedString = NSMutableAttributedString(string:uName[indexPath.item] + ": ", attributes:attrs)
                        let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "f4ef5d").withAlphaComponent(1.0)]
                        let attributedString1 = NSMutableAttributedString(string:msgText[indexPath.item], attributes:attrs1)
                        attributedString.append(attributedString1)
                        
                        cell.messageLabel.attributedText = attributedString
                    } else {
                        let attrs = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 16), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#b3b5b4").withAlphaComponent(1.0)]
                        let attributedString = NSMutableAttributedString(string:uName[indexPath.item] + ": ", attributes:attrs)
                        let attrs1 = [NSAttributedString.Key.foregroundColor :UIColor.white.withAlphaComponent(1.0)]
                        let attributedString1 = NSMutableAttributedString(string:msgText[indexPath.item], attributes:attrs1)
                        attributedString.append(attributedString1)
                        
                        cell.messageLabel.attributedText = attributedString
                    }
                    
                    print("Rank in cell :\(uRank[indexPath.row])")
                    let rank = Int(uRank[indexPath.row])
                    let strRank = uRank[indexPath.row]
                    if rank ?? 11 >= 10 {
                        if rank == 1 {
                            cell.topRankIV.image = UIImage(named: "top1")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 2 {
                            cell.topRankIV.image = UIImage(named: "top2")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 3 {
                            cell.topRankIV.image = UIImage(named: "top3")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 4 {
                            cell.topRankIV.image = UIImage(named: "top4")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 5 {
                            cell.topRankIV.image = UIImage(named: "top5")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 6 {
                            cell.topRankIV.image = UIImage(named: "top6")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 7 {
                            cell.topRankIV.image = UIImage(named: "top7")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 8 {
                            cell.topRankIV.image = UIImage(named: "top8")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 9 {
                            cell.topRankIV.image = UIImage(named: "top9")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        } else if rank == 10 {
                            cell.topRankIV.image = UIImage(named: "top10")
                            cell.topRankIV.isHidden = false
                            cell.circlePoints.isHidden = true
                            cell.pointsLbl.isHidden = true
                        }
                        
                    } else if strRank == "NEW" && strRank == "MOD" {
                        cell.topRankIV.isHidden = true
                        cell.circlePoints.isHidden = false
                        cell.pointsLbl.isHidden = false
                        cell.circlePoints.backgroundColor = UIColor(hexString: uColor[indexPath.item])
                        cell.pointsLbl.textColor = UIColor.white.withAlphaComponent(1.0)
                        cell.pointsLbl.text = strRank
                    } else {
                        cell.topRankIV.isHidden = true
                        cell.circlePoints.isHidden = false
                        cell.pointsLbl.isHidden = false
                        cell.circlePoints.backgroundColor = UIColor(hexString: uColor[indexPath.item])
                        cell.pointsLbl.textColor = UIColor.white.withAlphaComponent(1.0)
                        cell.pointsLbl.text = uRank[indexPath.item]
                    }
                    return cell
                } else {
                    return UICollectionViewCell()
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == onlineCollectionView {
            return CGSize(width: 30, height: 30)
        } else {
            if indexPath.section == 0 {
                return CGSize(width: self.view.frame.width, height: 91)
            }
            else {
                if msgText != [""] {
                    let new = uName[indexPath.item] + ": " + msgText[indexPath.item]
                    print("New : \(new)")
                    let trimMsg = new.trimmingCharacters(in: .whitespacesAndNewlines)
                    let height = messageHeight(for: trimMsg)
                    print("height of the cell : \(height)")
                    return CGSize(width: self.view.frame.width, height: height + 18)
                    
                }
                else {
                    return CGSize(width: 0, height: 0)
                }
            }
        }
    }
    fileprivate func messageHeight(for text: String) -> CGFloat{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "HelveticaNeue", size: 16)!
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth:CGFloat = 240
        let maxsize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxsize)
        return neededSize.height
    }

    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.msgText != [""] {
                let indexPath = IndexPath(row: self.msgText.count-1, section: 1)
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            } else {
                print("Scrolling not possible")
            }
        }
    }
    static func storyBoardInstance() -> LiveDiscussion?{
        let st = UIStoryboard.LIVE
        return st.instantiateViewController(withIdentifier: LiveDiscussion.id) as? LiveDiscussion
    }
    func sendGrpMsg(text : String, uColor: String, uName: String, userId: String, uimage: String, urank: String) {
        let xmppRoomMemoryStorage = XMPPRoomMemoryStorage()
        let xmppJid = XMPPJID(string: "livechatdiscussion@conference.myscrap.com")
        
        let xmppRoom = XMPPRoom(roomStorage: xmppRoomMemoryStorage!, jid: xmppJid!, dispatchQueue: DispatchQueue.main)
        xmppRoom!.activate(XMPPService.instance.xmppStream!)
        xmppRoom!.sendMessage(withBody: text, uColor: uColor, uName: uName, userId: userId, uimage: "", urank: urank)
        print("Message : \(text), Fromid : \(userId), XmppRoom :\(String(describing: xmppRoom))")
        if msgTextView.text != "Chat with everyone" {
            msgTextView.text = ""
            //msgTextView.textColor = .lightGray
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            sendBtn.setImage(image, for: .normal)
            sendBtn.tintColor = UIColor.lightGray
            sendBtn.isEnabled = false
        } else {
            print("Sent heart or like")
        }
    }
    func addMembers() {
        let xmppRoomMemoryStorage = XMPPRoomMemoryStorage()
        let xmppJid = XMPPJID(string: "livechatdiscussion@conference.myscrap.com")
        let xmppRoom = XMPPRoom.init(roomStorage: xmppRoomMemoryStorage!, jid: xmppJid!,dispatchQueue: DispatchQueue.main)
        xmppRoom!.activate(XMPPService.instance.xmppStream!)
        xmppRoom!.addDelegate(self, delegateQueue: DispatchQueue.main)
        //let today = Date()
        //let dateSince = Calendar.current.date(byAdding: .day, value: -5, to: today)!
        //let history = XMLElement(name: "history")
        //history.addAttribute(withName: "maxstanzas", stringValue: "50")
        xmppRoom!.join(usingNickname: (XMPPService.instance.xmppStream?.myJID?.user)!, history: nil)
        let member = XMPPService.instance.xmppStream?.myJID
        xmppRoom!.editPrivileges([XMPPRoom.item(withAffiliation: "admin", jid: member)])
        //dump(history)
        xmppRoom!.fetchConfigurationForm()
        xmppRoom!.configureRoom(usingOptions: nil)
        
        print("Me joined, User Name : \((XMPPService.instance.xmppStream?.myJID?.user)!)")
    }
    
    func changeRoomSubject(room: XMPPRoom, newsubject: String) {
        
//        if newsubject.length == 0 {
//            var block: () -> () = {
//                autoreleasepool {
                    //XMPPLogTrace();
                    /*
                     <message
                     from='wiccarocks@shakespeare.lit/laptop'
                     id='lh2bs617'
                     to='coven@chat.shakespeare.lit'
                     type='groupchat'>
                     <subject>Fire Burn and Cauldron Bubble!</subject>
                     </message>
                     */
        let subject = XMLElement.element(withName: "subject", stringValue: newsubject) as? XMLElement
                    
        let message = XMPPMessage()
        message?.addAttribute(withName: "to", stringValue: "livechatdiscussion@conference.myscrap.com")
        message?.addAttribute(withName: "type", stringValue: "groupchat")
        message?.addAttribute(withName: "id", stringValue: (XMPPService.instance.xmppStream?.generateUUID())!)
                    
        if let subject = subject {
            message?.addChild(subject)
        }
        XMPPService.instance.xmppStream?.send(message)
                    
                    
        let x = XMPPElement(name: "x", xmlns: "jabber:x:data")
                    x?.addAttribute(withName: "type", stringValue: "submit")
                    
        // Fields
                    
        let field1 = XMPPElement(name: "field")
        field1.addAttribute(withName: "var", stringValue: "FORM_TYPE")
                    
        if let element = XMLElement.element(withName: "value", stringValue: "http://jabber.org/protocol/muc#roomconfig") as? XMLNode {
            field1.addChild(element)
        }
        let fieldify = field1
        x?.addChild(fieldify)
                    
        let field2 = XMPPElement(name: "field")
        field2.addAttribute(withName: "var", stringValue: "muc#roomconfig_changesubject")
        field2.addAttribute(withName: "label", stringValue: newsubject)
        if let element = XMLElement.element(withName: "value") as? XMLNode {
            
            field2.addChild(element)
        }
//                    if let element = XMLElement.element(withName: "value", stringValue: newsubject) as? XMLNode {
//                        
//                    }
        x?.addChild(field2)
                    
        room.configureRoom(usingOptions: x)
//                }
//            }
//        }
    }
    
    func sendTopicMsg(topic: String) {
        let rank = Int(AuthService.instance.userRank)
        let newJoined = AuthService.instance.isNewJoined
        print("rank in did send : \(rank!), new joined : \(newJoined) , Message : ❤)")
        if newJoined == true && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank : \(rank!)")
            self.sendGrpMsg(text: "changed the TOPIC as \"\(topic)\"", uColor: UIColor.NEW_COLOR.toHex!, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        } else if newJoined == false && rank! <= 9 {
            print("Color : \(AuthService.instance.colorCode), Rank count : \(rank!)")
            self.sendGrpMsg(text: "changed the TOPIC as \"\(topic)\"", uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "Top \(rank!)")
        } else if newJoined == false && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank count else : \(rank!)")
            self.sendGrpMsg(text: "changed the TOPIC as \"\(topic)\"", uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        }
    }
    
    func updateBGWall() {
        let rank = Int(AuthService.instance.userRank)
        let newJoined = AuthService.instance.isNewJoined
        print("rank in did send : \(rank!), new joined : \(newJoined) , Message : ❤)")
        if newJoined == true && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank : \(rank!)")
            self.sendGrpMsg(text: "changed the Wall Picture", uColor: UIColor.NEW_COLOR.toHex!, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        } else if newJoined == false && rank! <= 9 {
            print("Color : \(AuthService.instance.colorCode), Rank count : \(rank!)")
            self.sendGrpMsg(text: "changed the Wall Picture", uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "Top \(rank!)")
        } else if newJoined == false && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank count else : \(rank!)")
            self.sendGrpMsg(text: "changed the Wall Picture", uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        }
    }
    
    func offline(){
        if XMPPService.instance.isConnected == true {
            
            let xmppJid = XMPPJID(string: "livechatdiscussion@conference.myscrap.com/" + (XMPPService.instance.xmppStream?.myJID?.user)!)
            let p = XMPPPresence(type: "unavailable", to: xmppJid)
            
            XMPPService.instance.xmppStream?.send(p)
            print("Offline presence : \(String(describing: p))")
        } else {
            print("Need to connect with Xmpp server in offline")
        }
    }
    
    func getBackgroundWall(){
        let service = APIService()
        service.endPoint = Endpoints.BG_WALL_GET
        
        service.params = "apiKey=\(API_KEY)"
        service.getDataWith(completion: { (result) in
            switch result{
            case .Success(let dict):
                DispatchQueue.main.async {
                    print("Dict in Live :\(dict)")
                    if let data = dict["data"] as? [String: AnyObject]{
                        if let bgImage = data["bgImage"] as? String {
                            self.bgImage.sd_setImage(with: URL(string: bgImage), completed: nil)
                        }
                    }
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    print("Failed to fetch image \(error)")
                    self.bgImage.image = UIImage(named: "live_bg_img")
                }
            }
        })
    }
}
extension LiveDiscussion: KeyBoardManagable {
    var layoutConstraintToAdjust: NSLayoutConstraint {
        return bottomConstraint
    }
    var scrollView: UIScrollView {
        return collectionView
    }
}

extension LiveDiscussion: MSInputViewDelegate {
    func didPressAddButton() {
        
    }
    func  didPressCameraButton() {
        
    }
    func didPressSendButton(with text: String) {
        let rank = Int(AuthService.instance.userRank)
        let newJoined = AuthService.instance.isNewJoined
        print("rank in did send : \(rank!), new joined : \(newJoined) , Message : \(text)")
        if newJoined == true && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank : \(rank!)")
            self.sendGrpMsg(text: text, uColor: UIColor.NEW_COLOR.toHex!, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        } else if newJoined == false && rank! <= 9 {
            print("Color : \(AuthService.instance.colorCode), Rank count : \(rank!)")
            self.sendGrpMsg(text: text, uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "Top \(rank!)")
        } else if newJoined == false && rank! > 10 {
            print("Color : \(AuthService.instance.colorCode), Rank count else : \(rank!)")
            self.sendGrpMsg(text: text, uColor: AuthService.instance.colorCode, uName: AuthService.instance.fullName, userId: AuthService.instance.userId, uimage: "", urank: "1")
        }
    }
}
extension LiveDiscussion : XMPPStreamDelegate {
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        print("Message received in group chat : \(message!)")
        if let msg = message {
            if let subject = msg.subject() {
                if subject != "" {
                    if let jid = msg.from()?.resource {
                        print("Topic By : \(jid)")
                        topicSubject = subject
                        self.service.getUserData(xmppUserId: jid)
                    } else {
                        print("User not authorised to change the subject")
                    }
                }
            } else {
                print("Subject topic is nil")
            }
        }
        
        if let msg = message {
            if let body = msg.body() {
                if body.contains("changed the Wall Picture") {
                let from = msg.from()?.resource
                if from == AuthService.instance.userJID {
                    print("Do nothing")
                } else {
                    self.getBackgroundWall()
                }
            }
            }
        }
        var newbody = ""
        var newdata : DDXMLElement?
        var newuColor = ""
        var newuRank = ""
        var newuName = ""
        var newfromId = "";
        if let fromId = message?.from().resource {
            newfromId = fromId
        }
        
        if let body = message?.body() {
            newbody = body
        }
        
        if let data = message?.elements(forName: "data").first {
            newdata = data
            
            if let uName = newdata!.attributeStringValue(forName: XMPPAttributes.uName) {
                print("Received user name from Xmpp live : \(uName)")
                let myName = AuthService.instance.firstname + " " + AuthService.instance.lastName
                if uName == myName {
                    newuName = "Me"
                } else {
                    newuName = uName
                }
            }
            if let uRank = newdata!.attributeStringValue(forName: XMPPAttributes.uRank) {
                newuRank = uRank
            }
            if let uColor = newdata!.attributeStringValue(forName: XMPPAttributes.uColor) {
                newuColor = uColor
            }
            
            if newbody != "" && newuName != "" && newuRank != "" && newuColor != "" && newfromId != "" {
                if msgText == [""] && uName == [""] && uRank == [""] && uColor == [""] && fromUser == [""] {
                    self.msgText.remove(at: 0)
                    self.uName.remove(at: 0)
                    self.uRank.remove(at: 0)
                    self.uColor.remove(at: 0)
                    self.fromUser.remove(at: 0)
                    
                    self.msgText.insert(newbody, at: 0)
                    self.uName.insert(newuName, at: 0)
                    self.uRank.insert(newuRank, at: 0)
                    self.uColor.insert(newuColor, at: 0)
                    self.fromUser.insert(newfromId, at: 0)
                    //self.collectionView.reloadData()
                } else {
                    self.msgText.append(newbody)
                    self.uName.append(newuName)
                    self.uRank.append(newuRank)
                    self.uColor.append(newuColor)
                    self.fromUser.append(newfromId)
                    print("Message in live \(self.msgText)")
                }
                self.collectionView.reloadData()
                scrollToBottom()
            }
        }
    }
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!) {
        if let msg = message {
            print("Group message sent : \(msg)")
        }
    }
    func xmppStream(_ sender: XMPPStream!, didFailToSend message: XMPPMessage!, error: Error!) {
        if let err = error {
            showMessage(with: "Failed to send message : \(err.localizedDescription)")
        }
    }
//    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool {
//        if iq.isResultIQ() {
//            if iq.lastActivitySeconds() == 0 {
//                print("User is online in the group")
//            } else {
//                print("User left the group")
//            }
//        }
//        return false
//    }
    func xmppStream(_ sender: XMPPStream!, didSend presence: XMPPPresence!) {
        print("send Live room Presence : \(String(describing: presence))")
    }
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        if presence.type() == "available" {
            print("Group user is online : \(String(describing: presence.from()?.resource))")
            let jid = (presence.from()?.resource)!
            self.sendOnlineAPI(jid: jid)
            print("Receive Online Presence : \(presence!)")
        }
        if presence.type() == "unavailable" {
            let jid = (presence.from()?.resource)!
            print("\(jid) becomes offline")
            self.sendOfflineAPI(jid: jid)
            print("Receive Offline Presence : \(presence!)")
        }
    }
}
extension LiveDiscussion : XMPPRoomDelegate {
    func xmppRoomDidCreate(_ sender: XMPPRoom) {
        print("Room : Created")
    }
    
    func xmppRoomDidJoin(_ sender: XMPPRoom) {
        print("Room : Joined")
        let xmppJid = XMPPService.instance.xmppStream?.myJID
        sender.inviteUser(xmppJid!, withMessage: "")
        print("Joined Status : \(sender.isJoined)")
        sender.fetchConfigurationForm()
    }
    
    func xmppRoom(_ sender: XMPPRoom, didFetchConfigurationForm configForm: DDXMLElement) {
        print("Room Config Form : Fetched")
        let xmppJid = XMPPService.instance.xmppStream?.myJID
        let newForm = configForm.copy() as! DDXMLElement
        
        for field in newForm.elements(forName: "field") {
            if let _var = field.attributeStringValue(forName: "var") {
                switch _var {
                case "muc#roomconfig_persistentroom" :
                    field.remove(forName: "value")
                    field.addChild(DDXMLElement(name: "value", numberValue: 1))
                    //                case "muc#roomconfig_membersonly" :
                    //                    field.remove(forName: "value")
                //                    field.addChild(DDXMLElement(name: "value", numberValue: 1))
                case "muc#roomconfig_roomname" :
                    field.remove(forName: "value")
                    field.addChild(DDXMLElement(name: "value", stringValue: "livechatdiscussion"))
                case "muc#roomconfig_roomadmins":
                    field.remove(forName: "value")
                    field.addChild(DDXMLElement(name: "value", stringValue: AuthService.instance.userJID! + "@myscrap.com"))
                //field.add
                default:
                    break
                }
            }
        }
        sender.configureRoom(usingOptions: newForm)
    }
    
    func xmppRoom(_ sender: XMPPRoom, didConfigure iqResult: XMPPIQ) {
        print("Room configured")
        //self.delegate?.putMessages(message: arrayBody, fromId : arrayFrom, uName: arrayuName, uColor: arrayuColor, uRank: arrayuRank)
    }
}
extension LiveDiscussion: OnlinePresenceModelDelegate {
    func didReceiveUserData(data: [OnlinePresence]) {
        DispatchQueue.main.async {
            self.name = data.last!.first_name + " " + data.last!.last_name
            if self.name != "" {
                self.leftTopicLbl.textColor = UIColor(hexString: "#f4ef5d").withAlphaComponent(1.0)
                let attrs = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 12), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#7cd8cb").withAlphaComponent(1.0)]
                let attributedString = NSMutableAttributedString(string: self.topicSubject, attributes:attrs)
                let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(1.0)]
                let attributedString1 = NSMutableAttributedString(string: " By \(self.name)", attributes:attrs1)
                attributedString.append(attributedString1)
                self.nameTULbl.attributedText = attributedString
            } else {
                print("Fetching userdata error in LIVE")
            }
        }
    }
    
    func didReceivedFailure(error: String) {
        print("Error found send presence :\(error)")
    }
    
    func didReceiveData(data: [OnlinePresence]) {
        DispatchQueue.main.async {
            let rank = Int((data.last?.rank)!)
            print("Rank in did receive : \(rank!)")
            if self.msgText == [""] {
                self.msgText.remove(at: 0)
                self.uName.remove(at: 0)
                self.uRank.remove(at: 0)
                self.uColor.remove(at: 0)
                self.fromUser.remove(at: 0)
            }
            if data.last?.first_name == AuthService.instance.firstname {
                self.uName.append("Me")
                self.msgText.append("joined the LIVE")
                if rank! < 9 {
                    self.uRank.append("Top " + (data.last?.rank)!)
                } else {
                    self.uRank.append(("1"))
                }
                self.uColor.append((data.last?.colorcode)!)
                AuthService.instance.userRank = "\(rank!)"
                self.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
            } else {
                //Doing online members Scroll
                let name = (data.last?.first_name)! + " " + (data.last?.last_name)!
                let initials = name.initials()
                self.nameArray.append(initials)
                let profile = data.last?.profilePic
                let color = data.last?.colorcode
                self.imgArray.append(profile!)
                
                let userId = data.last!.userId
                let fetchName: [String: String] = ["name": initials, "profilePic": profile!, "colorCode": color!]
                let dict = ["\(userId)": fetchName]
                
                self.onlineDict.append(dict)
                self.updatedDict.append(dict)
                
                for (index,dict) in self.onlineDict.enumerated() {
                    let lastArray = dict.keys.sorted().last.map({ ($0, dict[$0]!) })
                    print("Last element in Dictionary : \(lastArray!)")
                    
                }
                print("After appended Dict : \(self.onlineDict) count: \(self.onlineDict.count)")
                //self.updatedDict = self.onlineDict
                self.noOfOnlineMemLbl.text = String(self.updatedDict.count)
                if self.updatedDict.count > 1 {
                    self.onlineProfileView.isHidden = false
                    let lastDict = self.updatedDict.popLast()
                    if lastDict != nil {
                        //self.updatedDict = [lastDict!]
                        //print("New updated array : \(self.updatedDict)")
                        print("Dictionary has more than one value")
                        self.onlineProfileView.backgroundColor = UIColor(hexString: color!)
                        self.onlineProfileView.layer.borderWidth = 1
                        self.onlineProfileView.layer.borderColor = UIColor.white.cgColor
                        
                        if profile == "" {
                            self.onlinProfileImageView.isHidden = true
                            self.onlineInitialLabel.text = initials
                        } else {
                            self.onlinProfileImageView.isHidden = false
                            self.onlinProfileImageView.sd_setImage(with: URL(string: profile!), completed: nil)
                            self.onlineInitialLabel.text = initials
                        }
                        self.onlineCollectionView.reloadData()
                    } else {
                        print("No last element in dict")
                    }
                } else if self.updatedDict.count == 1 {
                    self.onlineProfileView.isHidden = false
                    print("Dictionay has 1 value , collection view will not updated.")
                    self.onlineProfileView.backgroundColor = UIColor(hexString: color!)
                    self.onlineProfileView.layer.borderWidth = 1
                    self.onlineProfileView.layer.borderColor = UIColor.white.cgColor
                    
                    if profile == "" {
                        self.onlinProfileImageView.isHidden = true
                        self.onlineInitialLabel.text = initials
                    } else {
                        self.onlinProfileImageView.isHidden = false
                        self.onlinProfileImageView.sd_setImage(with: URL(string: profile!), completed: nil)
                        self.onlineInitialLabel.text = initials
                    }
                    
                } else {
                    self.onlineProfileView.isHidden = true
                    print("Dictionary value is less than 1")
                }
                
                //self.onlineDict.append(fetchName)
                
                print("Dictiionaries :\(self.updatedDict)")
                
                
                
                //**
                self.uName.append(name)
                self.msgText.append("joined the LIVE")
                if rank! < 9 {
                    self.uRank.append("Top " + (data.last?.rank)!)
                } else {
                    self.uRank.append(("1"))
                }
                self.uColor.append((data.last?.colorcode)!)
            }
            self.collectionView.reloadData()
            self.scrollToBottom()
        }
        
        
    }
    func didReceiveOfflineData(data: [OnlinePresence]) {
        DispatchQueue.main.async {
            let rank = Int((data.last?.rank)!)
            print("Rank in offline : \(rank!)")
            if data.last?.first_name == AuthService.instance.firstname {
                self.uName.append("Me")
                self.msgText.append("left the LIVE")
                if rank! < 9 {
                    self.uRank.append("Top " + (data.last?.rank)!)
                } else {
                    self.uRank.append(("1"))
                }
                self.uColor.append((data.last?.colorcode)!)
                AuthService.instance.userRank = "\(rank!)"
            } else {
                //Doing online members Scroll
                let name = (data.last?.first_name)! + " " + (data.last?.last_name)!
                let initials = name.initials()
                let id = data.last!.userId
                //self.nameArray.remove(at: <#T##Int#>)
                let profile = data.last?.profilePic
                self.imgArray.append(profile!)
                
                
                let fetchName: [String: String] = ["name": initials, "profilePic": profile!]
                /*for var dict in self.onlineDict {
                    for (index,var path) in dict.enumerated() {
                        print("Index :\(index), path :\(path)")
                        if path.key == id {
                            //path.value.removeValue(forKey: "userId")
                            //dict.removeValue(forKey: id)
                            if let value = dict.removeValue(forKey: id) {
                                print("The value \(value) was removed")
                            } else {
                                print("No values found for that key")
                            }
                            //print("Value : \(path.value.removeValue(forKey: "4637"))")
                            //let key = path.key
                            //let new_dict = [key : value]
                            
                            self.onlineDict[index] = dict
                            self.onlineDict.remove(at: index)
                            //path.removeValue(forKey: userId)
//                            dict[userId] = path
//                            let finalValue = dict[userId]
//                            self.onlineDict = [dict]
                            //self.onlineDict = dict
                            print("Removed dictionary :\(self.onlineDict), count : \(self.onlineDict.count)")
                        } else {
                            print("Couldn't removed")
                        }
                    }
                }*/
                for (index, var dict) in self.updatedDict.enumerated() {
                    for new in dict {
                        if new.key == id {
                            if let value = dict.removeValue(forKey: id) {
                                print("The value \(value) was removed")
                                dict[id] = nil
                                self.updatedDict[index] = dict
                            }
                            else {
                                print("No values found for that key")
                            }
                            print("Index value in live : \(index)")
                            
                            print("Removed dictionary :\(self.updatedDict), count : \(self.updatedDict.count)")
                            if self.updatedDict.contains([:]) || self.updatedDict.isEmpty {
                                print("True in onlineDict")
                                self.updatedDict.remove(at: index)
                            }
                            let filteredDict = self.updatedDict.filter{!$0.values.contains([:])}
                            print("Filtered Dict: \(filteredDict), count :\(self.updatedDict.count)")
                        } else {
                            print("Couldn't removed")
                            if self.onlineInitialLabel.text == initials {
                                if self.updatedDict.count == 0 {
                                    print("No update update count = 0")
                                    self.onlineProfileView.isHidden = true
                                } else if self.updatedDict.count >= 1 {
                                    self.onlineProfileView.isHidden = false
                                    let lastDict = self.updatedDict.last
                                    if lastDict != nil {
                                        for new in lastDict! {
                                            let valueArray = new.value
                                            for array in valueArray {
                                                if array.key == "name" {
                                                    self.onlineInitialLabel.text = array.value
                                                } else if array.key == "profilePic" {
                                                    if array.value != "" {
                                                        self.onlinProfileImageView.isHidden = false
                                                        self.onlinProfileImageView.sd_setImage(with: URL(string: array.value), completed: nil)
                                                    } else {
                                                        self.onlinProfileImageView.isHidden = true
                                                        if array.key == "name" {
                                                            self.onlineInitialLabel.text = array.value
                                                        }
                                                        print("No profile img in offline data")
                                                    }
                                                } else if array.key == "colorCode" {
                                                    self.onlineProfileView.backgroundColor = UIColor(hexString: array.value)
                                                    self.onlineProfileView.layer.borderWidth = 1
                                                    self.onlineProfileView.layer.borderColor = UIColor.white.cgColor
                                                }
                                                self.updatedDict.popLast()
                                                
                                            }
                                        }
                                        print("Fetching updated count after removing last value : \(self.updatedDict.count), \(self.updatedDict)")
                                    } else {
                                        print("No element in updated dictionary")
                                    }
                                } else {
                                    print("will not happen")
                                }
                            } else {
                                print("Removing element and online view are not same")
                            }
                        }
                    }
                }
                
                self.onlineCollectionView.reloadData()
//                for var dict in self.onlineDict {
//                    dict.key = "\(userId)"
//                    dict.value = fetchName
//                    print("dict value in for : \(dict)")
//                }
//                for dict in self.onlineDict {
//                    for (in_name, path) in dict {
//
//                    }
//                }
                //self.onlineDict
                
                //**
                self.uName.append(name)
                self.msgText.append("left the LIVE")
                if rank! < 9 {
                    self.uRank.append("Top " + (data.last?.rank)!)
                } else {
                    self.uRank.append(("1"))
                }
                self.uColor.append((data.last?.colorcode)!)
            }
            self.collectionView.reloadData()
            self.scrollToBottom()
        }
    }
}
extension LiveDiscussion: CustomAlertViewDelegate {
    
    func okButtonTapped(selectedOption: String, textFieldValue: String) {
        print("okButtonTapped with \(selectedOption) option selected")
        print("TextField has value: \(textFieldValue)")
        let xmppRoomMemoryStorage = XMPPRoomMemoryStorage()
        let xmppJid = XMPPJID(string: "livechatdiscussion@conference.myscrap.com")
        
        let xmppRoom = XMPPRoom(roomStorage: xmppRoomMemoryStorage!, jid: xmppJid!, dispatchQueue: DispatchQueue.main)
        xmppRoom!.activate(XMPPService.instance.xmppStream!)
        self.changeRoomSubject(room: xmppRoom!, newsubject: textFieldValue)
        self.sendTopicMsg(topic: textFieldValue)
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}
extension LiveDiscussion: BGWallListDelegate {
    func getBGWall(image: String) {
        bgImage.sd_setImage(with: URL(string: image), completed: nil)
    }
    
    func uploadDone(status: Bool) {
        if status == true {
            updateBGWall()
        }
    }
    
    
}
