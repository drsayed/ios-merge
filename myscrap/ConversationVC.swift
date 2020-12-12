//
//  ConversationVC.swift
//  myscrap
//
//  Created by MyScrap on 5/3/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import XMPPFramework
import RealmSwift
import Alamofire
import Reachability
import SDWebImage
import AVKit
import AVFoundation
import DKImagePickerController
class ConversationVC: UIViewController, FriendControllerDelegate  , UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    var pageLoad = 0
    var isLoading = false
    
    var xmppStream = XMPPService.instance.xmppStream
    let picker = UIImagePickerController()
    static let instance = ConversationVC()
    var userCompany : String = ""
    var userCountry : String = ""
    var onlineStatus : String = ""
    let network: NetworkManager = NetworkManager.sharedInstance
    
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyLbl: UILabel!
    
    //Market Post POP UP Top
    @IBOutlet weak var marketViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var marketImageView: UIImageView!
    @IBOutlet weak var marketTypeLbl: UILabel!
    @IBOutlet weak var marketTitleLbl: UILabel!
    @IBOutlet weak var marketSendBtn: CorneredSlightButton!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageInputView: MSChatInputView!
    
    //User details to get Profile details in Navigation Bar
    var runUpdateTimer : String = "1"
    var friendId : String = ""
    var recvjid : String = ""
    var profileName : String = ""
    var colorCode : String = ""
    var profileImage : String = ""
    var jid : String = ""
    
    //Market VIEW
    var listingId = ""
    var listingTitle = ""
    var listingType = ""
    var listingImg = ""
    
    var msg_lists : Results<UserPrivChat>!
    
//    var member: Member!
//    fileprivate var dataSource = [MessageModel]()
//    let msgOperation = MessageOperation()
    
    lazy var profileView : CircleView = {
        let pv = CircleView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = UIColor(hexString: colorCode)
        return pv
    }()
    
    lazy var initialLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        lbl.text = profileName.initials()
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()
    lazy var profileImageView: CircularImageView = {
        let pv = CircularImageView()
        pv.contentMode = .scaleAspectFill
        if let url = URL(string: profileImage) {
            
            if profileImage != "https://myscrap.com/style/images/icons/no-profile-pic-female.png" && profileImage != "https://myscrap.com/style/images/icons/no_image.png" && profileImage != "https://myscrap.com/style/images/icons/profile.png" {
                pv.sd_setImage(with: url, completed: nil)
            }
        }
        return pv
    }()
    lazy var statusImageView: CircularImageView = {
        let pv = CircularImageView()
        pv.contentMode = .scaleAspectFill
        let sendImage = UIImage(named: "icOnline" , in: InputGlobal.instance.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        pv.image = sendImage
        return pv
    }()
    let stackView : UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sv.axis = .vertical
        return sv
    }()
    
    let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15)!
        return lbl
    }()
     let profileButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        let sendImage = UIImage(named: "profileArrow", in: InputGlobal.instance.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        btn.setImage(sendImage, for: .normal)
        return btn
    }()

    let onlineLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.lightGray
        lbl.text = ""
        lbl.font = UIFont(name: "HelveticaNeue", size: 12)!
        return lbl
    }()
    lazy var offlineView : CircleView = {
        let pv = CircleView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = UIColor.white
        return pv
    }()
    var timer = Timer()
    var timerLableUpdate = Timer()
    var companyId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        print("Im in conv module", jid.replacingOccurrences(of: "", with: " "), friendId)
        picker.delegate = self
        picker.allowsEditing = true
        companyLbl.text = ""
        companyView.isHidden = true
        
        //Setup Page
        removeBackButtonTitle()
        setupViews()
        setupTap()
        setupNavView()
        addKeyBoardObserver()
        
        //Market POST View show or hide function
        marketViewShoworHide()
        
        //XMPP
        let jidString = jid.replacingOccurrences(of: "", with: " ")
        let name = profileName
        print(" XMPP data in conversation vc :", jidString, "@", XMPPLoginManager.default.domain + "/iOS", name)
        XMPPService.instance.addUser(with: jidString + "@" + XMPPLoginManager.default.domain + "/iOS", nickname: name)
        XMPPService.instance.getArchiveMessages(with: jid)
        NotificationCenter.default.addObserver(self, selector: #selector(handledLoadMessage(notif:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOfflineSend(notif:)), name: NSNotification.Name(rawValue: "sendOffline"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deliveryReceipt(notif:)), name: NSNotification.Name(rawValue: "msgID"), object: nil)
        
        //Not using
        //NotificationCenter.default.addObserver(self,selector: #selector(statusManager),name: .flagsChanged,object: nil)
        //        fetchFromRemote(load: pageLoad)
        //        setupConstraints()
        //setupMsgObservers()
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

    //    self.navigationController?.navigationBar.frame  = CGRect(x: -20, y: (self.navigationController?.navigationBar.frame.origin.y)!, width: (self.navigationController?.navigationBar.frame.size.width)!, height: (self.navigationController?.navigationBar.frame.size.height)!)
        
        let homeButton = UIButton(frame: CGRect(x: 8, y: 0, width: 20, height: 15))
         homeButton.setBackgroundImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
         homeButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        homeButton.setTitleColor(.white, for: .normal)
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeButton)
        
      //  let leftBarButtonItem = self.navigationItem.leftBarButtonItem
//                if let leftBarButtonItemView = leftBarButtonItem?.value(forKey: "view") as? UIView {
//                    //You should ask your window to convert your frame to his frames.
//                    leftBarButtonItemView.frame = CGRect(x: 30, y:  leftBarButtonItemView.frame.origin.y, width: leftBarButtonItemView.frame.size.width, height: leftBarButtonItemView.frame.size.height)
//                    if let rect = UIApplication.shared.keyWindow?.convert(leftBarButtonItemView.frame, from: nil) {
//
//                    }
//                }
//
        IQKeyboardManager.sharedManager().enable = false
        //scrollToBottomInitially()
        
        //XMPP DELEGATE triggered
        XMPPService.instance.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        //Triggered API for status of user
        getUserDesig()
        checkOnline()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(checkOnline), userInfo: nil, repeats: true)
        
      //  timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(checkOnlineStatus), userInfo: nil, repeats: true)
        
        //Getting all chat history message from Realm
        loadChatMessages()
        
        //Notusing
        //        setupMsgObservers()
    }
    @objc private func profileButtonTapped(){
        if let vc = FriendVC.storyBoardInstance() {
            vc.friendId = friendId
            UserDefaults.standard.set(friendId, forKey: "friendId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc private func emojiButtonTapped(){
      
    }
    @objc  func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    func verifyUrl (urlString: String?) -> Bool {
       if let urlString = urlString {
           if let url = NSURL(string: urlString) {
               return UIApplication.shared.canOpenURL(url as URL)
           }
       }
       return false
   }
   
    func marketViewShoworHide() {
        if listingId != "" || listingTitle != "" || listingType != "" || listingImg != "" {
            self.marketViewHeightConstraint.constant = 152
            self.marketTitleLbl.text = listingTitle.uppercased()
            self.marketTypeLbl.text = listingType.uppercased()
            self.marketImageView.sd_setImage(with: URL(string: listingImg), completed: nil)
        } else {
            self.marketViewHeightConstraint.constant = 0
            self.marketTitleLbl.text = listingTitle
            self.marketTypeLbl.text = listingType
            self.marketImageView.isHidden = true
            
          //  messageInputView.inputTextView.becomeFirstResponder()
        }
    }

    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    //Realm
    func loadChatMessages() {
        let converId = AuthService.instance.userId + friendId
        print("Friend Id while entered : \(converId)")
        self.msg_lists = uiRealm.objects(UserPrivChat.self).filter("conversationId == '\(converId)'").sorted(byKeyPath: "timeStamp", ascending: true)
        print("Message lists :\(msg_lists), count : \(msg_lists.count)")
        for lists in msg_lists {
            try! uiRealm.write {
                lists.readCount = 1
                //uiRealm.add(lists, update: true)
                uiRealm.add(lists)
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollToBottom()
        }
        
    }
    
    @objc func handledLoadMessage(notif: Notification){
        
         let converId = AuthService.instance.userId + friendId
         msg_lists = uiRealm.objects(UserPrivChat.self).filter("conversationId == '\(converId)'").sorted(byKeyPath: "timeStamp", ascending: true)
         for lists in msg_lists {
//            try! uiRealm.write {
                lists.readCount = 1
                //uiRealm.add(lists, update: true)
            uiRealm.add(lists)
//            }
         }
         collectionView.reloadData()
         scrollToBottom()
        //loadChatMessages()
        
    }
    
    @objc func deliveryReceipt(notif: Notification) {
//        DispatchQueue.main.async {
            let converId = AuthService.instance.userId + self.friendId
            print("Friend Id while delivery receipt handle : \(converId)")
            self.msg_lists = uiRealm.objects(UserPrivChat.self).filter("conversationId == '\(converId)'").sorted(byKeyPath: "timeStamp", ascending: true)
            for lists in self.msg_lists {
                print("Message status : \(lists.msgStatus)")
                
                //Manually make as double tick for the purpose when there is a lack in get previous messageID = ""
                lists.msgStatus = "receive"
                //uiRealm.add(lists, update: true)
                uiRealm.add(lists)
                //can remove this code at any time
            }
            self.collectionView.reloadData()
            self.scrollToBottom()
//        }
    }
    
    @objc func handleOfflineSend(notif: Notification) {
        print("I'm here in offline send")
        XMPPService.instance.sendOfflineMessage()
    }
    
    private func scrollToBottom(){
        if !msg_lists.isEmpty{
            let ip = IndexPath(item: msg_lists.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: ip, at: .bottom, animated: false)
        }
    }
    
    func readDetails()
    {
        let converId = AuthService.instance.userId + friendId
        print("Friend Id while received : \(converId)")
        msg_lists = uiRealm.objects(UserPrivChat.self).filter("conversationId == '\(converId)'").sorted(byKeyPath: "timeStamp", ascending: true)
        collectionView.reloadData()
        scrollToBottom()
        print("Msg description lists : \(msg_lists)")
    }
    
    func updateUserInterface(msgText : String, stanzaType: String, type : String, title: String, marketUrl : String) {
        //Database creation //Insert Messages
        let chat = UserPrivChat()
        //Networks fails
        if network.reachability.isReachable == false {
            try! uiRealm.write {
                chat.conversationId = AuthService.instance.userId + friendId
                chat.fromJID = AuthService.instance.userJID!
                chat.toJID = jid.replacingOccurrences(of: "", with: " ")
                chat.body = msgText
                let timeStamp = String(Date().toMillis())
                chat.timeStamp = timeStamp
                // get the current date and time
                let currentDateTime = Date()
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                //formatter.dateFormat = "F"
                formatter.dateFormat = "MMM dd, h:mm a"     //12 hrs
//                formatter.timeStyle = .short
//                formatter.dateStyle = .medium
                chat.time = formatter.string(from: currentDateTime)
                chat.fromUserId = AuthService.instance.userId
                chat.toUserId = friendId
                chat.fromUserName = AuthService.instance.fullName
                chat.toUserName = profileName
                chat.fromImageUrl = AuthService.instance.profilePic
                chat.toImageUrl = profileImage
                chat.fromColorCode = AuthService.instance.colorCode
                chat.toColorCode = colorCode
                chat.signalId = timeStamp
                chat.messageType = "sent"
                chat.offlineFlag = true
                chat.syncFlag = false
                chat.msgStatus = "offline"
                chat.readCount = 1
                chat.stanzaType = stanzaType
                chat.marketUrl = marketUrl
                chat.type = type
                chat.title = title
                chat.rate = ""
                chat.listingId = listingId
                uiRealm.add(chat)
                self.readDetails()
            }
        } else if network.reachability.isReachableViaWWAN == true {
            //XMPPService.instance.sendOfflineMessage()
            let timeStamp = String(Date().toMillis())
            try! uiRealm.write {
                chat.conversationId = AuthService.instance.userId + friendId
                chat.fromJID = AuthService.instance.userJID!
                chat.toJID = jid.replacingOccurrences(of: "", with: " ")
                chat.body = msgText
                
                chat.timeStamp = timeStamp
                // get the current date and time
                let currentDateTime = Date()
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, h:mm a"     //12 hrs
                //formatter.dateFormat = "dd-MMM, HH:mm"
//                formatter.timeStyle = .short
//                formatter.dateStyle = .medium
                chat.time = formatter.string(from: currentDateTime)
                chat.fromUserId = AuthService.instance.userId
                chat.toUserId = friendId
                chat.fromUserName = AuthService.instance.fullName
                chat.toUserName = profileName
                chat.fromImageUrl = AuthService.instance.profilePic
                chat.toImageUrl = profileImage
                chat.fromColorCode = AuthService.instance.colorCode
                chat.toColorCode = colorCode
                chat.signalId = timeStamp
                chat.messageType = "sent"
                chat.offlineFlag = true
                chat.syncFlag = false
                chat.msgStatus = "offline"
                chat.readCount = 1
                chat.stanzaType = stanzaType
                chat.marketUrl = marketUrl
                chat.type = type
                chat.title = title
                chat.rate = ""
                chat.listingId = listingId
                uiRealm.add(chat)
                self.readDetails()
                //print("1 row inserted by sent !! : \(chat.key_id)")
            }
            if XMPPService.instance.isConnected {
                XMPPService.instance.sendMessage(with: msgText, to: jid, userId: friendId, fromId: AuthService.instance.userId, uImage: profileImage, fImage: AuthService.instance.profilePic, uName: profileName, fName: AuthService.instance.fullName, uColor: colorCode, fColor: AuthService.instance.colorCode, stanzaType: stanzaType, marketUrl: marketUrl, sentReceiveTimeStamp: timeStamp)
            } else {
                self.showToast(message: "Xmpp not connected")
                print("Message is now offline because of xmpp not connected")
            }
        } else if network.reachability.isReachableViaWiFi == true {
            //XMPPService.instance.sendOfflineMessage()
            let timeStamp = String(Date().toMillis())
            try! uiRealm.write {
                chat.conversationId = AuthService.instance.userId + friendId
                chat.fromJID = AuthService.instance.userJID!
                chat.toJID = jid.replacingOccurrences(of: "", with: " ")
                chat.body = msgText
                
                chat.timeStamp = timeStamp
                // get the current date and time
                let currentDateTime = Date()
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                //formatter.dateFormat = "dd-MMM, HH:mm"
                formatter.dateFormat = "MMM dd, h:mm a"     //12 hrs
                chat.time = formatter.string(from: currentDateTime)
                chat.fromUserId = AuthService.instance.userId
                chat.toUserId = friendId
                chat.fromUserName = AuthService.instance.fullName
                chat.toUserName = profileName
                chat.fromImageUrl = AuthService.instance.profilePic
                chat.toImageUrl = profileImage
                chat.fromColorCode = AuthService.instance.colorCode
                chat.toColorCode = colorCode
                chat.signalId = timeStamp
                chat.messageType = "sent"
                chat.offlineFlag = true
                chat.syncFlag = false
                chat.msgStatus = "offline"
                chat.readCount = 1
                chat.stanzaType = stanzaType
                chat.marketUrl = marketUrl
                chat.type = type
                chat.title = title
                chat.rate = ""
                chat.listingId = listingId
                uiRealm.add(chat)
                self.readDetails()
            }
            if XMPPService.instance.isConnected {
                XMPPService.instance.sendMessage(with: msgText, to: jid, userId: friendId, fromId: AuthService.instance.userId, uImage: profileImage, fImage: AuthService.instance.profilePic, uName: profileName, fName: AuthService.instance.fullName, uColor: colorCode, fColor: AuthService.instance.colorCode, stanzaType: stanzaType, marketUrl: marketUrl, sentReceiveTimeStamp: timeStamp)
            } else {
                self.showToast(message: "Xmpp not connected")
                print("Message is now offline because of xmpp not connected")
            }
        } else {
            print("Internet connection issue")
        }
        
    }
    
    //Send Market Message by User Manually
    @IBAction func marketSendBtnTapped(_ sender: UIButton) {
        //Customising body content
        //Title&Rate&Image format
        
        let json: [String:String]  =
            [
                "type": marketTypeLbl.text!,
                "title": marketTitleLbl.text!,
                "rate": "",
                "listingId": listingId
            ]
        
        do {
            let data =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
            marketViewHeightConstraint.constant = 0
            updateUserInterface(msgText : convertedString!, stanzaType: "marketAdv", type : marketTypeLbl.text!, title: marketTitleLbl.text!, marketUrl : listingImg)
            //updateUserInterface(msgText : marketTypeLbl.text! + "&" + marketTitleLbl.text! + "&" + listingId, type: "marketAdv", marketUrl : listingImg)
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
    private func setupViews(){
        //Company Top View Setup
        companyView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(setupCompanyTap))
        tap.numberOfTapsRequired = 1
        companyView.addGestureRecognizer(tap)
        
        //Collectionview Setup
        collectionView.delegate = self
        collectionView.dataSource = self
        messageInputView.sendButton.isHidden = true
        messageInputView.cameraButton.isHidden = false
        //Message Bar Setup
        messageInputView.inputTextView.placeholder = "Write a Message"
        messageInputView.delegate = self
        messageInputView.inputTextView.delegate = self
    }
    
    @objc
    func setupCompanyTap(){
        if let id = companyId, id != "", id != "0", let vc = CompanyProfileVC.storyBoardInstance(){
            print(id)
            vc.companyId = id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("no company id")
        }
        if  let id = companyId, id != "", id != "0", let vc = CompanyHeaderModuleVC.storyBoardInstance() { //let vc = CompanyDetailVC.storyBoardInstance() {
            vc.companyId = id
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        print("deinited conversation vc")
        removeMsgObservers()
        removeKeyBoardObserver()
    }
    
    private func setupNavView(){
        
        let titleView = UIView()
        titleView.backgroundColor = UIColor.clear
        titleView.autoresizingMask = .flexibleWidth
        titleView.frame = CGRect(x: -50 , y: 0, width: 400, height: 38)
        
        titleView.addSubview(profileView)
        profileView.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
        
      
        
        titleView.addSubview(initialLbl)
        initialLbl.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
        
        titleView.addSubview(profileImageView)
        profileImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
     
        
        offlineView.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        titleView.addSubview(statusImageView)
        titleView.addSubview(offlineView)
        offlineView.isHidden = true
        titleView.bringSubviewToFront(offlineView)
        statusImageView.frame = CGRect(x: profileImageView.frame.origin.x+profileImageView.frame.size.width-10, y: profileImageView.frame.origin.y+profileImageView.frame.size.height-10, width: 10, height: 10)
        offlineView.center = statusImageView.center
        statusImageView.isHidden = true
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(onlineLbl)
        titleView.addSubview(stackView)
        stackView.frame = CGRect(x: titleView.frame.height + 5, y: 0, width: titleView.frame.width - titleView.frame.height - 5 , height: titleView.frame.height)
        
        profileButton.frame = CGRect(x: 0, y: 0 , width:120, height: 60)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: profileButton)
        barButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem!.tintColor = .white
        self.navigationController?.navigationBar.tintColor = .white

      //  titleView.addSubview(profileButton)
        
        titleView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedtitleView))
        tap.numberOfTapsRequired = 1
        titleView.addGestureRecognizer(tap)
        
        
        self.navigationItem.titleView = titleView
    
    //s    self.navigationController?.navigationBar.frame =  CGRect( x:-20, y: self.navigationController?.navigationBar.frame.origin.y, width: self.navigationController?.navigationBar.frame.size.width  , height: self.navigationController?.navigationBar.frame.size.height)
       // [self.navigationController.navigationBar setFrame:CGRectMake(x, y, width, height)];

        nameLbl.text = profileName
    }
    
    @objc
    private func tappedtitleView(){
        performFriendView(friendId: friendId)
    }
    
    func removeMsgObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(setresponding))
        tap.numberOfTapsRequired = 1
        collectionView.addGestureRecognizer(tap)
    }
    
    @objc
    private func setresponding(){
        messageInputView.inputTextView.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        XMPPService.instance.xmppStream?.removeDelegate(self, delegateQueue: DispatchQueue.main)
        IQKeyboardManager.sharedManager().enable = true
        removeKeyBoardObserver()
        timer.invalidate()
        timerLableUpdate.invalidate()
        removeMsgObservers()
      

        //        checkJidandSettoSeen()
    }
    
    var shouldScrollToBottom = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func scrollToBottomInitially(){
        if collectionView.contentSize.height > collectionView.frame.size.height {
            var offset : CGPoint
            
            if #available(iOS 11.0, *) {
                offset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.frame.inset(by: collectionView.safeAreaInsets).height)
            } else {
                offset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.frame.size.height)
            }
            self.collectionView.setContentOffset(offset, animated: false)
            shouldScrollToBottom = false
            
        }
    }
    
    //Chat Topview online status will be initiated here
    @objc
    private func checkOnline(){
        let op = MessageOperation()
        op.checkOnline(id: friendId) { (onlineStat) in
            
            var userOnline = ""
            if let online = onlineStat["onlineStatusInMili"] as? String{
                
                userOnline = "\(online)"
            }
            else
            {
                if let online = onlineStat["onlineStatusInMili"] as? Int64{
                    
                    userOnline = "\(online)"
                }
            }
            self.updateOnlineStatus(onlineStat: userOnline)
            self.updateOnlineStatusIcon(onlineStat: userOnline)
            
        }
        getUserDesig()
     
    }
    func updateOnlineStatusIcon(onlineStat: String) {
        
        var userOnline = ""
        
        var online : Int64 = 0
        if onlineStat == "" {
           online = 560482320900000
        }
        else{
            online = Int64(onlineStat)!
        }
        
            let date = Date(milliseconds: online)
            let dateFormatter = DateFormatter()
        
            let calendar = Calendar.current
        let currentDate         = self.getCurrentLocalDate()

            let flags = NSCalendar.Unit.day
            let diffInDays = Calendar.current.dateComponents([.day], from: date, to: currentDate  as Date).day
            
        let diffComponents = Calendar.current.dateComponents([.hour], from: date, to: currentDate)
        var hours = diffComponents.hour
        if hours! < 0 {
            hours = -(hours!)
        }
        
            if online == 1  {
                userOnline = "0"
            }
            else if calendar.isDateInToday(date)  {
                userOnline = "1"
            }
            else  if hours! < 720
            {
                userOnline = "2"
            }
            else{
                userOnline = ""
            }
            
        
        
            DispatchQueue.main.async {
                self.statusImageView.isHidden = false
                self.offlineView.isHidden = true
                
            if userOnline == "0"{
            let sendImage = UIImage(named: "icOnline" , in: InputGlobal.instance.bundle, compatibleWith: nil)//?.withRenderingMode(.alwaysTemplate)

                self.statusImageView.image = sendImage
                self.statusImageView.layer.borderWidth = 1
                self.statusImageView.layer.borderColor = UIColor.white.cgColor
                //self.statusImageView.tintColor = UIColor.MyScrapGreen
            }
           else if userOnline == "1"{
            let sendImage = UIImage(named: "icOnline" , in: InputGlobal.instance.bundle, compatibleWith: nil)//?.withRenderingMode(.alwaysTemplate)

            self.statusImageView.image = sendImage
            self.statusImageView.layer.borderWidth = 1
            self.statusImageView.layer.borderColor = UIColor.white.cgColor
            self.offlineView.isHidden = false
           // self.statusImageView.tintColor = UIColor.clear
            }
           else if userOnline == "2"{
            let sendImage = UIImage(named: "away" , in: InputGlobal.instance.bundle, compatibleWith: nil)//?.withRenderingMode(.alwaysTemplate)

            self.statusImageView.image = sendImage
            //self.statusImageView.tintColor = UIColor.clear
            self.statusImageView.layer.borderWidth = 1
            self.statusImageView.layer.borderColor = UIColor.white.cgColor
            }
           else {
            let sendImage = UIImage(named: "icOnline" , in: InputGlobal.instance.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)

            self.statusImageView.image = sendImage
            self.statusImageView.tintColor = UIColor.clear
            self.statusImageView.isHidden = true
            }
        }
        
     
    }
    
    func getUserDesig(){
        let api = APIService()
        api.endPoint = Endpoints.USER_DESIG_FOR_CHAT
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&chatRoomId=\(friendId)&timeZone=\(TimeZone.current.identifier)"
        api.getDataWith { [weak self](result) in
            switch result{
            case .Success(let dict):
                self?.updateUserStatus(dict: dict)
            case .Error(_):
                print("Error")
            }
        }
    }
    
    fileprivate func updateUserStatus(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                if let json = dict["userOnlineStatusdata"] as? [String:AnyObject] {
                    var userDesignation = ""
                    var userCompany = ""
                    var companyId = ""
                    var userCountry = ""
                    
                    
                    if let desig = json["userDesignation"] as? String{
                        userDesignation = desig
                    }
                    if let company = json["userCompany"] as? String{
                        userCompany = company
                        self.userCompany = userCompany
                    }
                    if let comId = json["companyId"] as? String{
                        companyId = comId
                    }
                    if let cntry = json["userCountry"] as? String{
                        userCountry = cntry
                        self.userCountry = userCountry
                    }
//                    self.timerLableUpdate.invalidate()
//                    self.timerLableUpdate = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateLableData), userInfo: nil, repeats: true)
                    
                    self.updateUserDesignation(userDesignation: userDesignation, company: userCompany, country: userCountry, companyId: companyId)
                }
            }
        }
    }
    
    func updateOnlineStatus(onlineStat: String) {
        var online : Int64 = 0
        
        if onlineStat == "" {
           online = 560482320900000
        }
        else{
            online = Int64(onlineStat)!
        }
       

        var userOnline = ""
        
            if online == 1 {
                userOnline = "Online"
            } else {
                //last seen
                let date = Date(milliseconds: online)
                var epocTime = TimeInterval(online)

                let date2 = NSDate(timeIntervalSince1970: epocTime) as Date
                
                let date3 = Date(timeIntervalSince1970: epocTime)

                
                let dateFormatter = DateFormatter()
                let calendar = Calendar.current
                
                let currentDate         = self.getCurrentLocalDate()

                let flags = NSCalendar.Unit.day
                let diffInDays = Calendar.current.dateComponents([.day], from: date, to: currentDate  as Date).day
                
                let diffComponents = Calendar.current.dateComponents([.hour], from: date, to: currentDate)
                var hours = diffComponents.hour
                if hours! < 0 {
                    hours = -(hours!)
                }
                
                if calendar.isDateInToday(date)  {
                    dateFormatter.dateFormat = "hh:mm a"
                    userOnline = "last seen today at " + dateFormatter.string(from: date)
                } else if calendar.isDateInYesterday(date){
                    dateFormatter.dateFormat = "hh:mm a"
                    userOnline = "last seen yesterday at " + dateFormatter.string(from: date)
                } else if diffInDays! <= 7 {
                    dateFormatter.dateFormat = "hh:mm a"
                    let day = date.dayOfWeek(date: date)
                    userOnline = "last seen " + day! + " at " + dateFormatter.string(from: date)
                }
                else {
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let time = date.splitDateTime()
                    userOnline = "last seen " + dateFormatter.string(from: date) + " at " + time!
                }
            }

        DispatchQueue.main.async {
            if(userOnline == "Online")
            {
                if self.userCompany == "" &&   self.userCountry == ""
                {
                    self.onlineLbl.text  =  ""
                }
                else
                {
                if self.userCompany == "" {
                    
                    self.onlineLbl.text  =  "\(self.userCountry)"
                }
                else  if self.userCountry == "" {
                        
                        self.onlineLbl.text  =  "\(self.userCompany)"
                    }
                else{
                    self.onlineLbl.text  = "\(self.userCompany)" + " • \(self.userCountry)"
                }
                }
            }
            else
            {
                self.onlineStatus = userOnline
                
                if self.runUpdateTimer == "1" {
                if self.userCompany == "" &&   self.userCountry == ""
                {
                    self.onlineLbl.text  =  userOnline
                }
                else
                {
                if self.userCompany == "" {
                    
                    self.onlineLbl.text  =  "\(self.userCountry)"
                }
                else  if self.userCountry == "" {
                        
                        self.onlineLbl.text  =  "\(self.userCompany)"
                    }
                else{
                    self.onlineLbl.text  = "\(self.userCompany)" + " • \(self.userCountry)"
                }
                    
                        self.runUpdateTimer = "0"
                        self.timerLableUpdate.invalidate()
                        self.timerLableUpdate = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateLableData), userInfo: nil, repeats: true)
                    }
             
                    
                }
            }
            
            
           
        }
    }
    @objc func  updateLableData()  {
        if self.onlineLbl.text == self.onlineStatus {
            if self.userCompany == "" {
                
                self.onlineLbl.text  =  "\(self.userCountry)"
            }
            else  if self.userCountry == "" {
                    
                    self.onlineLbl.text  =  "\(self.userCompany)"
                }
            else{
                self.onlineLbl.text  = "\(self.userCompany)" + " • \(self.userCountry)"
            }
            
        }
        else
        {
            self.onlineLbl.text  = onlineStatus
        }
  
    }
    func updateUserDesignation(userDesignation: String, company: String, country: String, companyId: String){
        DispatchQueue.main.async {
            self.companyId = companyId
            UIView.animate(withDuration: 0.3, animations: {
                
                var titleText = ""
                titleText += userDesignation
                if company != ""{
                    titleText += " • \(company)"
                }
                if country != "" {
                    titleText += " • \(country)"
                }
                self.companyView.isHidden = true
                self.companyLbl.text = titleText
            })
        }
    }
    
    static func storyBoardInstance() -> ConversationVC? {
        let st = UIStoryboard.chat
        return st.instantiateViewController(withIdentifier: ConversationVC.id) as? ConversationVC
    }
    private func alertPromptToAllowCameraSettings(){
        AlertService.instance.showCameraSettingsURL(in: self)
    }
    
    @objc func checkCameraStatus(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized: callCamera()
        case .notDetermined: requestAccess()
        default : alertPromptToAllowCameraSettings()
        }
    }
    
    @objc func requestAccess(){
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if granted {
                DispatchQueue.main.async {
                    self.callCamera()
                }
            }
        }
    }
    @objc func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    @objc func callCamera ()
    {
        
        
        
           //     destination.pickerController = pickerController
               self.picker.sourceType = .camera
                 self.picker.mediaTypes = ["public.image"]
              self.picker.modalPresentationStyle = .overFullScreen
                 self.present(self.picker, animated: true, completion: nil)
//
        
        
        
//        let pickerController = DKImagePickerController()
//        pickerController.assetType = .allPhotos
//        pickerController.sourceType = .camera
//        pickerController.maxSelectableCount=1;
//        pickerController.showsCancelButton = true;
//        pickerController.showsEmptyAlbums = false;
//        pickerController.allowMultipleTypes = false;
////                                pickerController.defaultSelectedAssets = self.videosToPosts;
//        var imagesToPosts : [DKAsset] = [DKAsset]()
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            print("didSelectAssets")
//            print(assets)
//            var imageData = assets[0]
//            var url = imageData.originalAsset
//            imageData.fetchOriginalImage(completeBlock: { [self] image, info in
//                if let img = image {
//                    let fixOrientationImage=img.fixOrientation()
//                    var imageString = self.convertImageToBase64String(img: fixOrientationImage)
//                    self.uploadImageForChat(image: imageString)
////                    var imageAsset = imageData as? AVURLAsset
////                    if info?["PHImageFileURLKey"] != nil {
////                        let path = info?["PHImageFileURLKey"] as? URL
////                               print(path) //here you get complete URL
////                    }
//                  //  updateUserInterface(msgText : url?.absoluteString ?? "", stanzaType: "imageAttach", type : "", title: "",marketUrl : "")
//
//                    //if let urlAsset = imageData as? AVURLAsset {
////
////                        updateUserInterface(msgText : urlAsset.url.absoluteString, stanzaType: "imageAttach", type : "", title: "",marketUrl : "")
////                    }
//
//
//                    // cell.postImageView.image = fixOrientationImage
//
//                }
//            })
//            self.imagesToPosts.removeAll()
//            for asset in assets {
//                self.imagesToPosts.append(asset)
//            }
            
        
//        }
//        pickerController.modalPresentationStyle = .overFullScreen
//        self.present(pickerController, animated:false, completion: nil)
        //   destination.pickerController = pickerController
        //            self.picker.sourceType = .photoLibrary
        //            self.picker.mediaTypes = ["public.image"]
        //           // self.present(self.picker, animated: true, completion: nil)
        //            let pickerController = DKImagePickerController()
        //            pickerController.assetType = .allPhotos
        
        //
        //            self.presentViewController(pickerController, animated: true) {}
        //
        //          //  destination.pickerController = pickerController
        //             self.present(pickerController, animated: true, completion: nil)
    }
    //MARK: -UIImagePickerControllerDelegate
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        if picker.sourceType == .camera {
            guard let image = info[.editedImage] as? UIImage else {
                    print("No image found")
                    return
                }

            
            
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return  }

                let fileName = "tempImage.jpg"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
              

                //Checks if file exists, removes it if so.
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileURL.path)
                        print("Removed old image")
                    } catch let removeError {
                        print("couldn't remove file at path", removeError)
                    }

                }
            
            let imgData2 = image.jpegData(compressionQuality: 0.7)
            let img1stBase64: String = (imgData2?.base64EncodedString(options: .lineLength64Characters))!

            self.uploadImageForChat(image: img1stBase64)
            
       //     self.saveImage(fileURL: fileURL, image: image)
            
                // print out the image size as a test
                print(image.size)
        }
        else{
            if let video = info[UIImagePickerController.InfoKey.imageURL] as? URL {
             
                guard let image = info[.editedImage] as? UIImage else {
                        print("No image found")
                        return
                    }

                let imgData2 = image.jpegData(compressionQuality: 0.7)
                let img1stBase64: String = (imgData2?.base64EncodedString(options: .lineLength64Characters))!

                self.uploadImageForChat(image: img1stBase64)
                
                
                //                  //  var imageAsset = imageData as? AVURLAsset
           
               //updateUserIfnterface(msgText : imageAsset!.url.absoluteString, stanzaType: "imageAttach", type : "", title: "",marketUrl : "")
                
                
                    // print out the image size as a test
                    print(image.size)
                //  UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(video.path)
                  // Hanzdle a movie capture
                
              }
        }
        
        
        picker.dismiss(animated: true,completion: nil)
        
        
    }
    //Save photo into Photos
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            /*let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: "OK", style: .default))
             present(ac, animated: true)*/
            print("Store image into Photos error: \(error)")
        } else {
            /*let ac = UIAlertController(title: "Saved!", message: "Your captured picture has been saved to your photos.", preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: "OK", style: .default))
             present(ac, animated: true)*/
            print("Image stored into Photos!!")
        }
    }
    
    //Save Video into Photos
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        /*let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
         present(alert, animated: true, completion: nil)*/
        print(message)
    }
    
    
    //MARK: -UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageFromGallery()
    {
        
        
        self.picker.sourceType = .photoLibrary
          self.picker.mediaTypes = ["public.image"]
        self.picker.modalPresentationStyle = .overFullScreen
          self.present(self.picker, animated: true, completion: nil)
        
//        let pickerController = DKImagePickerController()
//        pickerController.assetType = .allPhotos
//        pickerController.maxSelectableCount = 1 ;
//        pickerController.showsCancelButton = true;
//        pickerController.showsEmptyAlbums = false;
//        pickerController.allowMultipleTypes = false;
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            print("didSelectAssets")
//            print(assets)
//            var imageData = assets[0]
//            if let url = imageData.localTemporaryPath {
//                print(url.absoluteString)
//            }
//
//            imageData.fetchOriginalImage(completeBlock: { [self] image, info in
//                if let img = image {
//                    let fixOrientationImage=img.fixOrientation()
//                    var imageString = self.convertImageToBase64String(img: fixOrientationImage)
//                  //  var imageAsset = imageData as? AVURLAsset
//                    self.uploadImageForChat(image: imageString)
//                  //  updateUserInterface(msgText : imageAsset!.url.absoluteString, stanzaType: "imageAttach", type : "", title: "",marketUrl : "")
//                    // cell.postImageView.image = fixOrientationImage
//
//                }
//            })
//            self.imagesToPosts.removeAll()
//            for asset in assets {
//                self.imagesToPosts.append(asset)
//            }
            
        
//        }
//        pickerController.modalPresentationStyle = .overFullScreen
//        self.present(pickerController, animated: true, completion: nil)
        //   destination.pickerController = pickerController
        //            self.picker.sourceType = .photoLibrary
        //            self.picker.mediaTypes = ["public.image"]
        //           // self.present(self.picker, animated: true, completion: nil)
        //            let pickerController = DKImagePickerController()
        //            pickerController.assetType = .allPhotos
        
        //
        //            self.presentViewController(pickerController, animated: true) {}
        //
        //          //  destination.pickerController = pickerController
        //             self.present(pickerController, animated: true, completion: nil)
    }
    func saveImage(fileURL: URL, image: UIImage) -> Bool {
        
        guard let data = image.jpegData(compressionQuality: 1) else { return false  }
        
            do {
                try data.write(to: fileURL)
                return true
            } catch let error {
                return false
                print("error saving file with error", error)
            }
    }
    func uploadImageForChat(image : String)  {
        
        var ipAdress = ""
        if AuthService.instance.getIFAddresses().count >= 1 {
            ipAdress = AuthService.instance.getIFAddresses().description
        }
        let service = APIService()
        service.endPoint = Endpoints.USER_Image_Upload
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&image=\(image)&device=\(MOBILE_DEVICE)&ipAddress=\(ipAdress)"

        print(service.params)
   
        service.getDataWith {(result) in
            switch result{
            case .Success(let dict):
                print(dict)
                let responseObject = dict as? [String: AnyObject]
                var dataObject = responseObject?["data"]  as? [[String:AnyObject]]
                if let data = dataObject?.last?["photos"] {
                    print(data)
                    DispatchQueue.main.async {
                    self.updateUserInterface(msgText : data as? String ?? "", stanzaType: "imageAttach", type : "", title: "",marketUrl : "")
                    }
                }
            case .Error(let error):
                print(error)
               
            }
        }
    }
    func getCurrentLocalDate()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
}

extension ConversationVC: KeyBoardManagable {
    var layoutConstraintToAdjust: NSLayoutConstraint {
        return bottomConstraint
    }
    
    var scrollView: UIScrollView {
        return collectionView
    }
}

extension ConversationVC: UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let lists = msg_lists {
            print("Count of messages for CV : \(lists.count)")
            return lists.count
        }
        return 0
//        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let message = dataSource[indexPath.item]
//        switch  message.isSender {
//        case true:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderCell
//            cell.messageLbl.text = message.text
//            return cell
//        case false:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
//            cell.messageLabel.text = message.text
//            return cell
//        }
        let row = msg_lists[(indexPath as IndexPath).row]
        if row.fromUserId == AuthService.instance.userId &&  (row.stanzaType == "imageAttach" ||  row.stanzaType == "") {
            if row.stanzaType == "imageAttach" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
                
                cell.imageView.setImageWithIndicator(imageURL: row.body)
                let viewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(imageTapped(tapGesture:)))
                viewTap.numberOfTapsRequired = 1
                cell.imageView.isUserInteractionEnabled = true
                cell.imageView.tag = indexPath.row
                cell.imageView.addGestureRecognizer(viewTap)
                print("Message and flag : \(row.body), \(row.offlineFlag)")
                //cell.setRead(status: status)
                cell.setMsgStatus(status: row.msgStatus)
                let dbTime = row.time
                let format = DateFormatter()
                let range = dbTime.range(of: ", ")
                let valueDate = dbTime[dbTime.startIndex..<range!.lowerBound]
                let valueTime = dbTime[range!.lowerBound..<dbTime.endIndex]
                let finalTime = valueTime.replacingOccurrences(of: ", ", with: "")
                print("comma before : \(valueDate), comma after : \(finalTime)")
                let date = Date()
                format.dateFormat = "MMM dd"
                let today = format.string(from: date)
//                if valueDate == today {
//                    cell.timeLbl.text = String(finalTime)
//                } else {
//                    cell.timeLbl.text = row.time
//                }
                cell.timeLbl.text = row.time
                print("time in sender : \(cell.timeLbl.text!)")
                return cell
            }
            else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderCell
                cell.messageLbl.text = row.body
                
                print("Message and flag : \(row.body), \(row.offlineFlag)")
                //cell.setRead(status: status)
                cell.setMsgStatus(status: row.msgStatus)
                let dbTime = row.time
                let format = DateFormatter()
                let range = dbTime.range(of: ", ")
                let valueDate = dbTime[dbTime.startIndex..<range!.lowerBound]
                let valueTime = dbTime[range!.lowerBound..<dbTime.endIndex]
                let finalTime = valueTime.replacingOccurrences(of: ", ", with: "")
                print("comma before : \(valueDate), comma after : \(finalTime)")
                let date = Date()
                format.dateFormat = "dd-MMM"
                let today = format.string(from: date)
//                if valueDate == today {
//                    cell.statusLbl.text = String(finalTime)
//                } else {
//                    cell.statusLbl.text = row.time
//                }
                cell.statusLbl.text = row.time
                print("time in sender : \(cell.statusLbl.text!)")
                return cell
            }
         
        } else if row.fromUserId != AuthService.instance.userId &&  (row.stanzaType == "imageAttach" ||  row.stanzaType == "") {
            if row.stanzaType == "imageAttach"  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiverImageCell", for: indexPath) as! ReceiverImageCell
           
                cell.profileView.updateViews(name: row.fromUserName , url: profileImage , colorCode: row.fromColorCode)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileButtonTapped))
                cell.profileView.addGestureRecognizer(tap)
                cell.profileView.isUserInteractionEnabled = true
                
             cell.imageView.setImageWithIndicator(imageURL: row.body)
                
                let viewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(imageTapped(tapGesture:)))
                viewTap.numberOfTapsRequired = 1
                cell.imageView.isUserInteractionEnabled = true
                cell.imageView.tag = indexPath.row
                cell.imageView.addGestureRecognizer(viewTap)
//                if let url = URL(string: profileImage) {
//                    if profileImage != "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
//                        cell.profileImage.sd_setImage(with: url, completed: nil)
//                    }
//                }
                let dbTime = row.time
                let format = DateFormatter()
                let range = dbTime.range(of: ", ")
                let valueDate = dbTime[dbTime.startIndex..<range!.lowerBound]
                let valueTime = dbTime[range!.lowerBound..<dbTime.endIndex]
                let finalTime = valueTime.replacingOccurrences(of: ", ", with: "")
                print("comma before : \(valueDate), comma after : \(finalTime)")
                let date = Date()
                format.dateFormat = "dd-MMM"
                let today = format.string(from: date)
//                if valueDate == today {
//                    cell.timeLbl.text = String(finalTime)
//                } else {
//                    cell.timeLbl.text = row.time
//                }
                cell.timeLbl.text = row.time
                print("time in receiver : \(cell.timeLbl.text!)")
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
                cell.messageLabel.text = row.body
                cell.profileView.updateViews(name: row.fromUserName , url: profileImage , colorCode: row.fromColorCode)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileButtonTapped))
                cell.profileView.addGestureRecognizer(tap)
                cell.profileView.isUserInteractionEnabled = true
//                cell.profileImage.contentMode = .scaleAspectFill
//                if let url = URL(string: profileImage) {
//                    if profileImage != "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
//                        cell.profileImage.sd_setImage(with: url, completed: nil)
//                    }
//                }
                let dbTime = row.time
                let format = DateFormatter()
                let range = dbTime.range(of: ", ")
                let valueDate = dbTime[dbTime.startIndex..<range!.lowerBound]
                let valueTime = dbTime[range!.lowerBound..<dbTime.endIndex]
                let finalTime = valueTime.replacingOccurrences(of: ", ", with: "")
                print("comma before : \(valueDate), comma after : \(finalTime)")
                let date = Date()
                format.dateFormat = "dd-MMM"
                let today = format.string(from: date)
//                if valueDate == today {
//                    cell.statusLbl.text = String(finalTime)
//                } else {
//                    cell.statusLbl.text = row.time
//                }
                cell.statusLbl.text = row.time
                print("time in receiver : \(cell.statusLbl.text!)")
                return cell
            }
           
        } else if row.stanzaType == "marketAdv" && row.fromUserId == AuthService.instance.userId {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketSenderCell", for: indexPath) as! MarketSenderCell
            //Spliting values from body of the message
            //let body = row.body
            //let sepArray = body.components(separatedBy: "&")
            //let typeRec = sepArray[0]
            //let title = sepArray[1]
            //let _ = sepArray[2]
            
            cell.marketTypeLbl.text = row.type.uppercased()
            cell.marketTitleLbl.text = row.title.uppercased()
            
            let image = row.marketUrl
            cell.marketImageView.sd_setImage(with: URL(string: image), completed: nil)
            
            cell.setMsgStatus(status: row.msgStatus)
            let dbTime = row.time
            let format = DateFormatter()
            let range = dbTime.range(of: ", ")
            let valueDate = dbTime[dbTime.startIndex..<range!.lowerBound]
            let valueTime = dbTime[range!.lowerBound..<dbTime.endIndex]
            let finalTime = valueTime.replacingOccurrences(of: ", ", with: "")
            print("comma before : \(valueDate), comma after : \(finalTime)")
            let date = Date()
            format.dateFormat = "dd-MMM"
            let today = format.string(from: date)
//            if valueDate == today {
//                cell.timeLbl.text = String(finalTime)
//            } else {
//                cell.timeLbl.text = row.time
//            }
            cell.timeLbl.text = row.time
            print("time in market sender : \(cell.timeLbl.text!)")
            
            let viewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(tapGesture:)))
            viewTap.numberOfTapsRequired = 1
            cell.innerView.isUserInteractionEnabled = true
            cell.innerView.tag = indexPath.row
            cell.innerView.addGestureRecognizer(viewTap)
            
            return cell
        } else if row.stanzaType == "marketAdv" && row.fromUserId != AuthService.instance.userId {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketReceiverCell", for: indexPath) as! MarketReceiverCell
            //let body = row.body
            //let sepArray = body.components(separatedBy: "&")
            //let type = sepArray[0]
            //let title = sepArray[1]
            //let _ = sepArray[2]
            
            /*let downloadURL = URL(string: image)
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                if let error = error {
                    print("Error while downloading : \(error), Status :\(status), url :\(String(describing: downloadURL))")
                    cell.marketImageView.image =  #imageLiteral(resourceName: "no-image")
                } else {
                    SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                    cell.marketImageView.image = image
                }
            })*/
            
            cell.marketTypeLbl.text = row.type.uppercased()
            cell.marketTitleLbl.text = row.title.uppercased()
            let image = row.marketUrl
            cell.marketImageView.sd_setImage(with: URL(string: image), completed: nil)
            
            let dbTime = row.time
            let format = DateFormatter()
            let range = dbTime.range(of: ", ")
            let valueDate = dbTime[dbTime.startIndex..<range!.lowerBound]
            let valueTime = dbTime[range!.lowerBound..<dbTime.endIndex]
            let finalTime = valueTime.replacingOccurrences(of: ", ", with: "")
            print("comma before : \(valueDate), comma after : \(finalTime)")
            let date = Date()
            format.dateFormat = "dd-MMM"
            let today = format.string(from: date)
//            if valueDate == today {
//                cell.receivedTimeLbl.text = String(finalTime)
//            } else {
//                cell.receivedTimeLbl.text = row.time
//            }
            cell.receivedTimeLbl.text = row.time
            print("time in market receiver : \(cell.receivedTimeLbl.text!)")
            
            let viewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(tapGesture:)))
            viewTap.numberOfTapsRequired = 1
            cell.innerView.isUserInteractionEnabled = true
            cell.innerView.tag = indexPath.row
            cell.innerView.addGestureRecognizer(viewTap)
            
            return cell
        } else {
            
            if row.stanzaType == "imageAttach"  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
                
                cell.imageView.setImageWithIndicator(imageURL: row.body)
                print("Message and flag : \(row.body), \(row.offlineFlag)")
                //cell.setRead(status: status)
                cell.setMsgStatus(status: row.msgStatus)
                let dbTime = row.time
                let format = DateFormatter()
                let range = dbTime.range(of: ", ")
                let valueDate = dbTime[dbTime.startIndex..<range!.lowerBound]
                let valueTime = dbTime[range!.lowerBound..<dbTime.endIndex]
                let finalTime = valueTime.replacingOccurrences(of: ", ", with: "")
                print("comma before : \(valueDate), comma after : \(finalTime)")
                let date = Date()
                format.dateFormat = "dd-MMM"
                let today = format.string(from: date)
//                if valueDate == today {
//                    cell.timeLbl.text = String(finalTime)
//                } else {
//                    cell.timeLbl.text = row.time
//                }
                cell.timeLbl.text = row.time
                print("time in sender : \(cell.timeLbl.text!)")
                return cell
            }
            else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderCell
                cell.messageLbl.text = row.body
                
                print("Message and flag : \(row.body), \(row.offlineFlag)")
                //cell.setRead(status: status)
                cell.setMsgStatus(status: row.msgStatus)
                let dbTime = row.time
                let format = DateFormatter()
                let range = dbTime.range(of: ", ")
                let valueDate = dbTime[dbTime.startIndex..<range!.lowerBound]
                let valueTime = dbTime[range!.lowerBound..<dbTime.endIndex]
                let finalTime = valueTime.replacingOccurrences(of: ", ", with: "")
                print("comma before : \(valueDate), comma after : \(finalTime)")
                let date = Date()
                format.dateFormat = "dd-MMM"
                let today = format.string(from: date)
//                if valueDate == today {
//                    cell.statusLbl.text = String(finalTime)
//                } else {
//                    cell.statusLbl.text = row.time
//                }
                cell.statusLbl.text = row.time
                print("time in sender : \(cell.statusLbl.text!)")
                return cell
            }
         
        }
    }
    @objc func imageTapped(tapGesture:UITapGestureRecognizer) {
        
        let indexPath = tapGesture.view!.tag
        let row = msg_lists[indexPath]
        
        guard !(row.body.isEmpty) else { return }
               let vc = FullImageViewVC(index: 0, dataSource: [row.body])
               vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true, completion: nil )
        //let body = row.body
        //let sepArray = body.components(separatedBy: "&")
        //let _ = sepArray[0]
        //let _ = sepArray[1]
        //let id = sepArray[2]
        
//        let userId = friendId
//        let vc = DetailListingOfferVC.controllerInstance(with: row.listingId, with1: userId)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
}
    @objc func viewTapped(tapGesture:UITapGestureRecognizer) {
        
        let indexPath = tapGesture.view!.tag
        let row = msg_lists[indexPath]
        //let body = row.body
        //let sepArray = body.components(separatedBy: "&")
        //let _ = sepArray[0]
        //let _ = sepArray[1]
        //let id = sepArray[2]
        
        let userId = friendId
        let vc = DetailListingOfferVC.controllerInstance(with: row.listingId, with1: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension ConversationVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = msg_lists[(indexPath as IndexPath).row]
        if row.stanzaType == "" {
            let height = messageHeight(for: row.body)
            print("height for cell : \(height)")
            return CGSize(width: self.view.frame.width, height: height + 40)
        } else {
            return CGSize(width: self.view.frame.width, height: 320)
        }
    }
    
    fileprivate func messageHeight(for text: String) -> CGFloat{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "HelveticaNeue", size: 17)!
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth:CGFloat = 240
        let maxsize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxsize)
        return neededSize.height
    }
}
//extension ConversationVC: UICollectionViewDelegate{
// func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let row = msg_lists[(indexPath as IndexPath).row]
//        let body = row.body
////        let sepArray = body.components(separatedBy: "&")
////        let _ = sepArray[0]
////        let _ = sepArray[1]
////        let id = sepArray[2]
////        let userId = friendId
////        let vc = DetailListingOfferVC.controllerInstance(with: id, with1: userId)
////        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
extension ConversationVC: MSInputViewDelegate {
    func didPressSendButton(with text: String) {
        updateUserInterface(msgText : text, stanzaType: "", type : "", title: "",marketUrl : "")
        messageInputView.sendButton.isHidden = true
        messageInputView.cameraButton.isHidden = false
    }
    func didPressCameraButton() {
        self.checkCameraStatus()
    }
    func didPressAddButton() {
        self.imageFromGallery()
    }
}
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
class NetworkManager: NSObject {
    
    var reachability: Reachability!
    
    // Create a singleton instance
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    
    
    override init() {
        super.init()
        
        // Initialise reachability
        reachability = Reachability()!
        
        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
}
extension ConversationVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("print1")
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("print2")
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
            print(textView.text); //the textView parameter is the textView where text was changed
        if textView.text.length == 0
        {
            messageInputView.sendButton.isHidden = true
            messageInputView.cameraButton.isHidden = false
        }
        else
        {
            messageInputView.sendButton.isHidden = false
            messageInputView.cameraButton.isHidden = true
        }
            
        }
}

//Not Using for ref
/*
 func sendMessage(with text: String, to jid: String, userId: String, fromId: String, uImage: String, fImage: String, uName: String, fName: String, uColor: String, fColor: String){
 
 //self.connect(with: AuthService.instance.userJID!)
 
 if AuthStatus.instance.isLoggedIn, !AuthStatus.instance.isGuest {
 var senderJID = XMPPJID(string: "\(jid.replacingOccurrences(of: "", with: " "))")
 if jid.contains("@myscrap.com") {
 senderJID = XMPPJID(string: "\(jid.replacingOccurrences(of: "", with: " "))")
 } else {
 senderJID = XMPPJID(string: "\(jid.replacingOccurrences(of: "", with: " "))@\(XMPPLoginManager.default.domain)")
 }
 
 let fromJID = XMPPJID(string: AuthService.instance.userJID)
 let elemId = xmppStream?.generateUUID()
 print("JID : \(jid.replacingOccurrences(of: "", with: " "))")
 print(senderJID)
 
 //let msg = XMPPMessage(type: "chat", to: senderJID, from:fromJID, elementID: elemId)
 let msg = XMPPMessage(type: "chat", to: senderJID, elementID: elemId)
 
 
 let data = DDXMLElement.element(withName: "data") as! DDXMLElement
 
 let myscrapReply = DDXMLNode.attribute(withName: XMPPAttributes.xmlns, stringValue: XMPPAttributes.myscrapReply) as! DDXMLNode
 
 let fidat = DDXMLNode.attribute(withName: XMPPAttributes.toId, stringValue: userId) as! DDXMLNode
 let uidat = DDXMLNode.attribute(withName: XMPPAttributes.fromId, stringValue: fromId) as! DDXMLNode
 
 let uImageat = DDXMLNode.attribute(withName: XMPPAttributes.uImage, stringValue: uImage) as! DDXMLNode
 let fImageat = DDXMLNode.attribute(withName: XMPPAttributes.fImage, stringValue: fImage) as! DDXMLNode
 
 
 let uNameat = DDXMLNode.attribute(withName: XMPPAttributes.uName, stringValue: uName) as! DDXMLNode
 let fNameat = DDXMLNode.attribute(withName: XMPPAttributes.fName, stringValue: fName) as! DDXMLNode
 
 let uColorat = DDXMLNode.attribute(withName: XMPPAttributes.uColor, stringValue: uColor) as! DDXMLNode
 let fColorat = DDXMLNode.attribute(withName: XMPPAttributes.fColor, stringValue: fColor) as! DDXMLNode
 
 data.addAttribute(myscrapReply)
 data.addAttribute(fidat)
 data.addAttribute(uidat)
 data.addAttribute(uImageat)
 data.addAttribute(fImageat)
 data.addAttribute(uNameat)
 data.addAttribute(fNameat)
 data.addAttribute(uColorat)
 data.addAttribute(fColorat)
 msg?.addChild(data)
 msg?.addBody(text)
 xmppStream?.send(msg)
 let lists = uiRealm.objects(UserPrivChat.self).last
 try! uiRealm.write {
 lists?.offlineFlag = false
 lists?.syncFlag = true
 lists?.msgStatus = "sent"
 //                    lastValue.stanza = (message.prettyXMLString())
 uiRealm.add(lists!, update: true)
 print("Sync Flag from offline message: \(lists?.syncFlag), Stanza while sending : \(lists?.stanza)")
 self.readDetails()
 }
 }
 }*/

/*@objc func statusManager(_ notification: Notification) {
 print("I'm in sparta")
 XMPPService.instance.disconnect()
 print("I'm out of sparta1 ")
 }*/

/*func sendOfflineMessage() {
 let retrieve = uiRealm.objects(UserPrivChat.self).filter("syncFlag == false AND offlineFlag == true AND messageType == 'sent'")
 print("Get Offline messages while sending : \(retrieve)")
 print("Count of the Db offline : \(retrieve.count)")
 for lists in retrieve {
 //            DispatchQueue.main.async {
 self.sendOfflineMessages(with: lists.body, to: lists.toJID, userId: lists.toUserId, fromId: lists.fromUserId, uImage: lists.toImageUrl, fImage: lists.fromImageUrl, uName: lists.toUserName, fName: lists.fromUserName, uColor: lists.toColorCode, fColor: lists.fromColorCode)
 try! uiRealm.write {
 lists.offlineFlag = false
 lists.syncFlag = true
 //                    lastValue.stanza = (message.prettyXMLString())
 uiRealm.add(lists, update: true)
 print("Sync Flag from offline message: \(lists.syncFlag), Stanza while sending : \(lists.stanza), body : \(lists.body)")
 self.readDetails()
 }
 //            }
 print("Sent offline message after connected to internet!! : \(lists)")
 }
 }
 
 func sendOfflineMessages(with text: String, to jid: String, userId: String, fromId: String, uImage: String, fImage: String, uName: String, fName: String, uColor: String, fColor: String){
 
 //self.connect(with: AuthService.instance.userJID!)
 
 if AuthStatus.instance.isLoggedIn, !AuthStatus.instance.isGuest {
 var senderJID = XMPPJID(string: "\(jid)")
 if jid.contains("@myscrap.com") {
 senderJID = XMPPJID(string: "\(jid)")
 } else {
 senderJID = XMPPJID(string: "\(jid)@\(XMPPLoginManager.default.domain)")
 }
 
 let fromJID = XMPPJID(string: AuthService.instance.userJID)
 let elemId = xmppStream?.generateUUID()
 print("JID : \(jid)")
 print(senderJID)
 
 //let msg = XMPPMessage(type: "chat", to: senderJID, from:fromJID, elementID: elemId)
 let msg = XMPPMessage(type: "chat", to: senderJID, elementID: elemId)
 
 
 let data = DDXMLElement.element(withName: "data") as! DDXMLElement
 
 let myscrapReply = DDXMLNode.attribute(withName: XMPPAttributes.xmlns, stringValue: XMPPAttributes.myscrapReply) as! DDXMLNode
 
 let fidat = DDXMLNode.attribute(withName: XMPPAttributes.toId, stringValue: userId) as! DDXMLNode
 let uidat = DDXMLNode.attribute(withName: XMPPAttributes.fromId, stringValue: fromId) as! DDXMLNode
 
 let uImageat = DDXMLNode.attribute(withName: XMPPAttributes.uImage, stringValue: uImage) as! DDXMLNode
 let fImageat = DDXMLNode.attribute(withName: XMPPAttributes.fImage, stringValue: fImage) as! DDXMLNode
 
 
 let uNameat = DDXMLNode.attribute(withName: XMPPAttributes.uName, stringValue: uName) as! DDXMLNode
 let fNameat = DDXMLNode.attribute(withName: XMPPAttributes.fName, stringValue: fName) as! DDXMLNode
 
 let uColorat = DDXMLNode.attribute(withName: XMPPAttributes.uColor, stringValue: uColor) as! DDXMLNode
 let fColorat = DDXMLNode.attribute(withName: XMPPAttributes.fColor, stringValue: fColor) as! DDXMLNode
 
 data.addAttribute(myscrapReply)
 data.addAttribute(fidat)
 data.addAttribute(uidat)
 data.addAttribute(uImageat)
 data.addAttribute(fImageat)
 data.addAttribute(uNameat)
 data.addAttribute(fNameat)
 data.addAttribute(uColorat)
 data.addAttribute(fColorat)
 msg?.addChild(data)
 msg?.addBody(text)
 xmppStream?.send(msg)
 
 }
 }*/

/*extension ConversationVC : XMPPStreamDelegate {
 
 
 /*func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
 let msg = message
 if msg != nil {
 //XMPPService.instance.handleReceivedMessage(message: msg!)
 collectionView.reloadData()
 scrollToBottom()
 print("Message received from stream : \(String(describing: msg))")
 } else {
 print("Private message received is nil")
 }
 }*/
 func handleReceivedMessage(message: XMPPMessage){
 
 guard let body = message.body(),
 let data = message.elements(forName: "data").first,
 let msgId = message.elementID(),
 let rjid = message.from().user,
 let userId = data.attributeStringValue(forName: XMPPAttributes.fromId),
 let rcolorCode = data.attributeStringValue(forName: XMPPAttributes.fColor),
 let name = data.attributeStringValue(forName: XMPPAttributes.fName),
 let profilePic = data.attributeStringValue(forName: XMPPAttributes.fImage)
 else { return }
 
 /*let chat = UserPrivChat.create()
 //            msg_Details.fromJID = AuthService.instance.userJID
 chat.conversationId = AuthService.instance.userId + userId
 chat.fromJID = rjid
 chat.toJID = AuthService.instance.userJID!
 chat.body = body
 let timeStamp = String(Date().toMillis())
 chat.timeStamp = timeStamp
 chat.fromUserId = userId
 chat.toUserId = AuthService.instance.userId
 chat.fromUserName = name
 chat.toUserName = AuthService.instance.fullName
 chat.fromImageUrl = profilePic
 chat.toImageUrl = AuthService.instance.profilePic
 chat.fromColorCode = rcolorCode
 chat.toColorCode = AuthService.instance.colorCode
 chat.signalId = timeStamp
 chat.stanza = message.prettyXMLString()
 chat.messageType = "receive"
 chat.offlineFlag = false
 chat.syncFlag = false
 */
 try! uiRealm.write {
 //            uiRealm.add(chat)
 let converId = AuthService.instance.userId + userId
 msg_lists = uiRealm.objects(UserPrivChat.self).filter("conversationId == '\(converId)'").sorted(byKeyPath: "timeStamp", ascending: true)
 collectionView.reloadData()
 scrollToBottom()
 print("RECEIVED Msg description lists : \(msg_lists)")
 }
 }
 /*func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error!) {
 print("Xmpp disconnected in converastion module")
 if let err = error {
 print(err.localizedDescription)
 } else {
 print("Unknown error disconnection")
 }
 //NotificationCenter.default.addObserver(self,selector: #selector(statusManager),name: .flagsChanged,object: nil)
 //        AuthStatus.instance.isXmpploggedIn = false
 }*/
 
 //    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
 //        self.sendOfflineMessage()
 //    }
 }*/

/*
 func loadMessages(_ completion: (Bool) -> ()){
 let delegate = UIApplication.shared.delegate as! AppDelegate
 let moc = delegate.persistentContainer.viewContext
 guard let id = member.jid else { return }
 let request : NSFetchRequest<Message> = Message.fetchRequest()
 request.predicate = NSPredicate(format: "member.jid = %@", id)
 //        request.sortDescriptors = Message.defaultDescriptors
 request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
 
 do {
 let messages = try moc.fetch(request)
 var model = [MessageModel]()
 for message in messages {
 if let text = message.text {
 model.append(MessageModel(text: text, isSender: message.isSender))
 }
 }
 dataSource = model
 collectionView?.reloadData()
 completion(true)
 
 
 } catch {
 print(error.localizedDescription)
 }
 }*/

/*
 extension ConversationVC {
 func setupMsgObservers(){
 NotificationCenter.default.addObserver(forName:.xmppSendMessage, object: nil, queue: nil) { [weak self] (notif)  in
 DispatchQueue.main.async {
 self?.handleMessage(notif)
 }
 }
 NotificationCenter.default.addObserver(forName: .xmppReceivedMessage, object: nil, queue: nil) { [weak self] (notif) in
 DispatchQueue.main.async {
 self?.handleMessage(notif)
 }
 }
 }
 
 
 
 func removeMsgObservers(){
 //        NotificationCenter.default.removeObserver(self, name: Notification.Name.xmppSendMessage, object: nil)
 //        NotificationCenter.default.removeObserver(self, name: Notification.Name.xmppReceivedMessage, object: nil)
 NotificationCenter.default.removeObserver(self)
 }
 
 
 func handleMessage(_ notif: Notification){
 guard let message = notif.object as? MessageViewModel , let jid = member.jid, message.jid == jid else { return }
 let model = MessageModel(text: message.text, isSender: message.isSender)
 let ip = IndexPath(item: self.dataSource.count, section: 0)
 self.dataSource.insert(model, at: ip.item)
 self.collectionView?.insertItems(at: [ip])
 self.scrollToBottom()
 checkJidandSettoSeen()
 }
 
 
 
 
 
 func handleSendedMessage(notif: Notification){
 guard let message = notif.object as? XMPPMessage, let to = message.to().user, let sendingJId = member.jid , to == sendingJId, let body = message.body() else {
 return
 }
 let model = MessageModel(text: body, isSender: true)
 let ip = IndexPath(item: self.dataSource.count, section: 0)
 self.dataSource.insert(model, at: ip.item)
 self.collectionView?.insertItems(at: [ip])
 self.scrollToBottom()
 checkJidandSettoSeen()
 
 }
 
 private func checkJidandSettoSeen(){
 updateMessagestoSeen(jid: friendId)
 }
 
 
 func updateMessagestoSeen(jid: String){
 DispatchQueue.main.async {
 let app = UIApplication.shared.delegate as! AppDelegate
 app.persistentContainer.performBackgroundTask({ (moc) in
 moc.perform {
 let messageReq : NSFetchRequest<Message> = Message.fetchRequest()
 messageReq.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
 messageReq.predicate = NSPredicate(format: "member.jid = %@", jid)
 do {
 let messages = try moc.fetch(messageReq)
 
 for message in messages{
 message.status = "1"
 }
 
 do {
 try moc.save()
 }
 } catch {
 print(error.localizedDescription)
 }
 }
 })
 }
 }
 }
 
 
 
 extension ConversationVC{
 func fetchFromRemote(load: Int){
 //        if let friendId = member.jid {
 //            XMPPService.instance.getArchiveMessages(with: friendId)
 //        }
 
 if isLoading { return }
 
 isLoading = true
 
 if let userJid = AuthService.instance.userJID , let friendJid = member.jid{
 let domain = XMPPLoginManager.default.domain
 let userid = userJid + "@" + domain
 let friendId = friendJid + "@" + domain
 let service = APIService()
 service.endPoint = Endpoints.CONVERSATION_URL
 service.params = "userId=\(userid)&friendId=\(friendId)&apiKey=\(API_KEY)&pageLoad=\(load)"
 
 let app = UIApplication.shared.delegate as! AppDelegate
 app.persistentContainer.performBackgroundTask { (moc) in
 service.getDataWith(completion: { (result) in
 switch result{
 case .Success(let dict):
 if let chatRoomData = dict["chatRoomData"] as? [[String: AnyObject]]{
 for data in chatRoomData{
 if let msg = data["msgId"] as? [String: AnyObject], let msgId = msg["0"] as? String, let isSender = data["isSender"] as? Bool, let message = data["lastMessage"] as? String, let createdat = data["created_at"] as? String, let doubleDate = Double(createdat){
 
 print(doubleDate)
 let date = Date(milliseconds: Int(doubleDate))
 
 moc.perform({
 self.msgOperation.updateChatHistoryMessages(msgId: msgId, body: message, member: self.member, isSender: isSender, date: date, moc: moc)
 })
 
 do {
 try moc.save()
 } catch{
 print(error.localizedDescription)
 }
 
 }
 }
 }
 DispatchQueue.main.async {
 self.pageLoad += 5
 self.isLoading = false
 self.collectionView.reloadData()
 }
 case .Error(let error):
 print(error)
 }
 })
 }
 }
 }
 }
 */
