//
//  ConversationVC.swift
//  myscrap
//
//  Created by MS1 on 9/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import CoreData
import Photos
import IQKeyboardManagerSwift
import XMPPFramework

class MessageModel {
    
    var text: String
    var isSender: Bool
    
    init(text: String, isSender: Bool) {
        self.text = text
        self.isSender = isSender
    }
}



class ConvVC: BaseVC {
    
    @IBOutlet weak var selectPhotoBtn: UIButton!
    // navigation Bar view
    
    var jid: String?
    
    var dataSource = [MessageModel]()
    
    lazy var profileView : CircleView = {
        let pv = CircleView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = UIColor(hexString: member.cCode)
        return pv
    }()
    
    
    lazy var initialLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        lbl.text = member.name?.initials() ?? "G U"
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()
    lazy var profileImageView: CircularImageView = {
        let pv = CircularImageView()
        pv.contentMode = .scaleAspectFill
        if let url = URL(string: member.profileImage) {
            pv.sd_setImage(with: url, completed: nil)
        }
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
    
    let onlineLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.text = ""
        lbl.font = UIFont(name: "HelveticaNeue", size: 15)!
        return lbl
    }()
    
    var timer = Timer()
    
    
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    
    var memberId = ""
    var member: Member!
    enum MsgType{
        case text
        case image
    }
    
    fileprivate var msgType : MsgType = .text
    fileprivate var image: UIImage?
    
    
    
    var selectedIndexPaths = [IndexPath]()
    var blockOperations = [BlockOperation]()
    fileprivate var seenIndexPath : IndexPath?
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        setupNavView()
        textView.delegate = self
        
    }
    
    func loadArchiveMessages(){
        
        let storage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
        
        guard let id = jid, let moc = storage?.mainThreadManagedObjectContext else { return }
        
        let friendId = "\(id)@\(XMPPLoginManager.default.domain)"
        
        let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "XMPPMessageArchiving_Message_CoreDataObject")
        
        request.predicate = NSPredicate(format: "bareJidStr = %@", friendId)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let result = try moc.fetch(request)
            
            if let items = result as? [XMPPMessageArchiving_Message_CoreDataObject] {
                for item in items {
                    if let msg = item.body {
                        let isSender = item.isOutgoing
                        let mdl = MessageModel(text: msg, isSender: isSender)
                        dataSource.append(mdl)
                    }
                    collectionView.reloadData()
                }
            }
            
            
        } catch {
            print(error)
        }
        
    }
    
    
    func loadMessages(){
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let moc = delegate.persistentContainer.viewContext
        
        guard let id = member.jid else { return }
        let request : NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "member.jid = %@", id)
        request.sortDescriptors = Message.defaultDescriptors
        
        
        do {
            
            let messages = try moc.fetch(request)
           
            var model = [MessageModel]()
            
            for message in messages {
                if let text = message.text {
                    model.append(MessageModel(text: text, isSender: message.isSender))
                }
            }
            
            dataSource = model
            collectionView.reloadData()

            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        keyboardObserver()
        setupObservers()
        updateAlltoSeen()
        checkOnline()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(checkOnline), userInfo: nil, repeats: true)
        
        let img = #imageLiteral(resourceName: "ic_photo_library").withRenderingMode(.alwaysTemplate)
        selectPhotoBtn.setImage(img, for: .normal)
        selectPhotoBtn.tintColor = UIColor.GREEN_PRIMARY
        
        loadMessages()
        
        guard let id = jid , let nickname = member.name else {
            return
        }
        
        XMPPService.instance.addUser(with: id, nickname: nickname)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
        removeKeyboardObserver()
        updateAlltoSeen()
        timer.invalidate()
        companyView.isHidden = true
        removeMsgObservers()
    }
    
    
    // setup views
    private func setupViews(){
        textView.delegate = self
        toggleSendButton(growingtxt: textView)
    }
    
    private func setupNavView(){
        
        let titleView = UIView()
        titleView.backgroundColor = UIColor.clear
        titleView.autoresizingMask = .flexibleWidth
        titleView.frame = CGRect(x: 0, y: 0, width: 400, height: 42)
        
        titleView.addSubview(profileView)
        profileView.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
        
        titleView.addSubview(initialLbl)
        initialLbl.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
        
        titleView.addSubview(profileImageView)
        profileImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
        
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(onlineLbl)
        titleView.addSubview(stackView)
        stackView.frame = CGRect(x: titleView.frame.height + 5, y: 0, width: titleView.frame.width - titleView.frame.height - 5 , height: titleView.frame.height)
        
        self.navigationItem.titleView = titleView
    
        nameLbl.text = member.name
        companyLabel.textColor = UIColor.BLACK_ALPHA
        companyLabel.font = UIFont(name: "HelveticaNeue", size: 14)!
    }
    
    var postImage : UIImage?
    
    
    @IBAction func image(_ sender: UIButton) {
        
        /*let reachability = Reachability()!
        
        if reachability.connection != .none{
            showToast(message: "Check Your Internet Connection")
        } else {*/
            let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize(width: 100 , height: 60))
    
            let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: false, allowVolumeButtonCapture: true) { [weak self] (image, asset) in
                if let img = image{
                    let imageData: Data = img.jpegData(compressionQuality: 0.6)!
                    let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
                    self?.sendImage(base64: imageString)
                }
                self?.dismiss(animated: true, completion: nil)
            }
                present(cameraViewController, animated: true, completion: nil)
//        }
    }
    
    fileprivate func updateAlltoSeen(){
        
    }
    
  

    
    //MARK:- checking online
    @objc fileprivate func checkOnline(){
        let api = APIService()
        api.endPoint = Endpoints.USER_ONLINE_STATUS_URL
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&chatRoomId=\(member.id ?? "")&timeZone=\(TimeZone.current.identifier)"
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
                    var online = false
                    var timestamp = ""
                    var userCompany = ""
                    var companyId = ""
                    var userCountry = ""
                    
                    
                    if let desig = json["userDesignation"] as? String{
                        userDesignation = desig
                    }
                    if let onlineStatus = json["online"] as? Bool{
                        online = onlineStatus
                    }
                    if let timeStp = json["timeStamp"] as? String{
                        timestamp = timeStp
                    }
                    if let company = json["userCompany"] as? String{
                        userCompany = company
                    }
                    if let comId = json["companyId"] as? String{
                        companyId = comId
                    }
                    if let cntry = json["userCountry"] as? String{
                        userCountry = cntry
                    }
                    
                    self.updateUSerDesignation(online: online, time: timestamp, userDesignation: userDesignation, company: userCompany, country: userCountry)
                }
            }
        }
    }
    
    fileprivate func updateUSerDesignation(online:Bool, time:String, userDesignation: String, company:String, country:String){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                if online{
                    self.onlineLbl.text = "Online"
                } else {
                    self.onlineLbl.text = time
                }
                var titleText = ""
                titleText += userDesignation
                if company != ""{
                    titleText += " • \(company)"
                }
                if country != "" {
                    titleText += " • \(country)"
                }
                self.companyView.isHidden = false
                self.companyLabel.text = titleText
            }
        }
    }
}

// MARK:- COLLECTIONVIEW ACTIONS
extension ConvVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    // collectionview scrolls to bottom
    func scrollToBottom(anim:Bool){
        let item = self.collectionView.numberOfItems(inSection: 0)
        if item != 0 {
            let indexPath = IndexPath(item: item - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: anim)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = dataSource[indexPath.item]
        
        switch  message.isSender {
        case true:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderCell
            cell.messageLbl.text = message.text
            return cell
        case false:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.messageLabel.text = message.text
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let msg = dataSource[indexPath.item]
        let height = messageHeight(for: msg.text)
        return CGSize(width: self.view.frame.width, height: height + 22)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

extension ConvVC: ChatTappedDelegate {
    
    func DidTappedImage(cell: SenderImageCell) {
//        if let indexPath = collectionView.indexPathForItem(at: cell.center){
//            if let imgURL = fetchedResultsController.object(at: indexPath).imageURL {
//                tappedOnImage(imgURL)
//            }
//        }
    }

    func DidTappedView(cell: BaseCell) {
//        if let indexPath = collectionView.indexPathForItem(at: cell.center){
//            tappedOnCell(indexPath: indexPath)
//        }
    }
    
    private func tappedOnCell(indexPath: IndexPath){
//        if selectedIndexPaths.contains(indexPath){
//            selectedIndexPaths = selectedIndexPaths.filter{ $0 != indexPath }
//        } else {
//            selectedIndexPaths.append(indexPath)
//        }
//        UIView.animate(withDuration: 0.3) {
//            self.collectionView.reloadItems(at: [indexPath])
//            //self.collectionView.reloadData()
//        }
    }

    private func tappedOnImage(_ imageURL : String){
//        let pictureURL = PictureURL(urlString: "https://myscrap.com/newchat/new/chatimage/\(imageURL)")
//        let vc = AlbumVC(index: 0, dataSource: [pictureURL])
//        self.present(vc, animated: true)
    }
}






extension ConvVC: UITextViewDelegate{
    
    
    //MARK:-  Send Button Pressed
    @IBAction func sendButtonPressed(_ sender: UIButton){
        
        guard let text = textView.text , text != "" , let jid = member.jid , let userID = member.id , let uName = member.name else { return }
        textView.text = ""
        toggleSendButton(growingtxt: textView)
        //XMPPService.instance.sendMessage(with: text, to: jid, userId: userID, fromId: AuthService.instance.userId, uImage: member.profileImage, fImage: AuthService.instance.profilePic, uName: uName , fName: AuthService.instance.fullName, uColor: member.cCode, fColor: AuthService.instance.colorCode)
    }
    
    
    fileprivate func sendImage(base64: String){
        
    }
    
    // MARK:- Handle Send Button
    fileprivate func toggleSendButton(growingtxt: UITextView){
        
        switch validate(textView: textView) {
        case false:
            self.sendButton.isUserInteractionEnabled = false
            self.sendButton.tintColor = UIColor.gray
        case true:
            self.sendButton.isUserInteractionEnabled = true
            self.sendButton.tintColor = UIColor.GREEN_PRIMARY
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        toggleSendButton(growingtxt: textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    fileprivate   func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        return true
    }
    
  
}

//MARK:- SOCKET OBSERVERS
extension ConvVC{
 

    
    fileprivate func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont(name: "HelveticaNeue", size: fontSize)!
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font:font,
                                                                      NSAttributedString.Key.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        return textHeight
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

extension ConvVC{
    //Animate stackview
    func animate(condition:Bool){
        UIView.animate(withDuration: 0.3) {
            self.companyView.isHidden = condition
        }
    }
}

extension ConvVC{
    static func storyBoardInstance() -> ConvVC? {
        let storyBoard = UIStoryboard(name: StoryBoard.CHAT, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "ConvVC") as? ConvVC
    }
    
}

extension ConvVC{
    
    func handleSendedMessage(notif: Notification){
        guard let message = notif.object as? MessageViewModel else { return }
        let model = MessageModel(text: message.text , isSender: message.isSender)
        let ip = IndexPath(item: self.dataSource.count, section: 0)
        self.dataSource.insert(model, at: ip.item)
        self.collectionView.insertItems(at: [ip])
        self.scrollToBottom()
    }
    
    func handledReceivedMessage(notif: Notification){
        guard let message = notif.object as? MessageViewModel else { return }
        let model = MessageModel(text: message.text , isSender: message.isSender)
        let ip = IndexPath(item: self.dataSource.count, section: 0)
        self.dataSource.insert(model, at: ip.item)
        self.collectionView.insertItems(at: [ip])
        self.scrollToBottom()
    }
    
    
    private func scrollToBottom(){
        if !dataSource.isEmpty{
            let ip = IndexPath(item: dataSource.count - 1, section: 0)
            self.collectionView.scrollToItem(at: ip, at: .bottom, animated: true)
        }
    }
    
    func setupObservers(){
        NotificationCenter.default.addObserver(forName:.xmppSendMessage, object: nil, queue: nil) { [weak self] (notif)  in
            self?.handleSendedMessage(notif: notif)
        }
        NotificationCenter.default.addObserver(forName: .xmppReceivedMessage, object: nil, queue: nil) { [weak self] (notif) in
            self?.handledReceivedMessage(notif: notif)
        }
    }
    
    func removeMsgObservers(){
        NotificationCenter.default.removeObserver(Notification.Name.xmppSendMessage)
        NotificationCenter.default.removeObserver(Notification.Name.xmppReceivedMessage)
    }
    
    
}



