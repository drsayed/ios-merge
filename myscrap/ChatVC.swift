//
//  ChatVC.swift
//  myscrap
//
//  Created by MS1 on 9/16/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import XMPPFramework
import RealmSwift

var activeUserTimer: Timer!

class ChatVC: BaseRevealVC, FriendControllerDelegate { //BaseVC -> BaseRevealVC
    
    

    lazy var mytableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.register(RecentChatCell.Nib, forCellReuseIdentifier: RecentChatCell.identifier)
        return tv
    }()
    
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var floaty = Floaty()
    
    var viewModel: LastMessageViewModel?
    
    
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(getChatHistory), for: .valueChanged)
//        tableview.refreshControl = rc
        return rc
    }()
    
    lazy var syncView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: mytableView.center.x, y: mytableView.center.y, width: 60, height: 60), type: .ballPulseSync, color: .MyScrapGreen, padding: 0)
        return view
    }()
    
    
    //Realm DB implemented
    var msg_lists : Results<UserPrivChat>!
    var readMsg_count : Int!
    var filter = [UserPrivChat]()
    var activeDataSource = [ActiveUsers]()
    let service = ChatService()
    var isTapNotifMsg = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        activeView.delegate = self
        
        setupFloaty()
        setupSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        //Background thread refresh check
        checkAfterWriteBackgroundThreadUpdated()
        
        setupViews()
        print(alreadyAppeared)
        
        if !alreadyAppeared{
            alreadyAppeared = true
        } else{
            loadChatMessages()
        }
        
        print(alreadyAppeared)
        
        addObservers()
        title = "Chat"
        
        if isTapNotifMsg {
            let cancelBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelPressed))
            self.navigationItem.leftBarButtonItem = cancelBtn
        } else {
            //Skipping Left bar button Close chat page
            //Using the menu icon instead
        }
        
        //sendOnline()
        //gooffline()
        
        //getActiveUsers()
        loadChatMessages()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handledMessage(notif:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handledReceivedMessage(notif:)), name: NSNotification.Name(rawValue: "allchat"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deliveryReceipt(notif:)), name: NSNotification.Name(rawValue: "msgID"), object: nil)
        self.view.bringSubviewToFront(floaty)
    }
    func FormateConversion(dateString: String) -> String
    {
        var dateStringFinal: String = ""
        if dateString != ""  && dateString != " "  {
            let array = dateString.components(separatedBy: ",")
            if array.count > 0 {
                var stringFinal: String = array[0]
                if stringFinal.contains("-") {
                    let arrayFinal = stringFinal.components(separatedBy: "-")
                    dateStringFinal =  "\(arrayFinal[1]) \(arrayFinal[0])"
                }
                else
                {
                    dateStringFinal =  array[0]
                }
               
            }
            else
            {
                dateStringFinal  = dateString
            }
            return dateStringFinal
//            var dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM dd, h:mm a"
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//            let s = dateFormatter.date(from: dateStr1)
//            var dateFormatter2 = DateFormatter()
//            dateFormatter2.dateFormat = "MMM dd"
//            dateFormatter2.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//
//            var dateString1 = dateFormatter2.string(from: s!)
//            return dateString1
        }
        return dateStringFinal
    }
    func checkAfterWriteBackgroundThreadUpdated() {
        
        DispatchQueue.init(label: "background").async {
            
            let realmOnBackgroundThread = try! Realm()
            let getChatBgThread = realmOnBackgroundThread.objects(UserPrivChat.self)
            
            var isToContinue = true
            while isToContinue {
                realmOnBackgroundThread.refresh()
                if getChatBgThread.count > 0 {
                    isToContinue = false
                    print("Found")
                }
            }
        }
    }
    
    func gooffline() {
        let xmppJid = XMPPJID(string: (XMPPService.instance.xmppStream?.myJID?.user!)! + "@myscrap.com/iOS")
        let priority = XMLElement(name: "priority", stringValue: "24")
        let element = DDXMLElement.element(withName: "presence") as! DDXMLElement
        let from = DDXMLNode.attribute(withName: "from", stringValue: "\((XMPPService.instance.xmppStream?.myJID?.user)!)@myscrap.com/iOS") as! DDXMLNode
        let type = DDXMLNode.attribute(withName: "type", stringValue: "unavailable") as! DDXMLNode
        element.addAttribute(from)
        element.addAttribute(type)
        let pre = XMPPPresence(from: element)
        //        let p = XMPPPresence(type: "unavailable")
        pre?.addChild(priority)
        XMPPService.instance.xmppStream?.send(pre)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    //Realm
    func loadChatMessages() {
        
        msg_lists = try! Realm().objects(UserPrivChat.self).sorted(byKeyPath: "timeStamp", ascending: false).distinct(by: ["conversationId"])
        
        print("Load all messages :\(String(describing: msg_lists))")
        if msg_lists.count != 0  {
            mytableView.reloadData()
        } else {
            if self.syncView.isAnimating {
                self.syncView.stopAnimating()
            }
        }
        
    }
    
    private func getActiveUsers(){
        service.activeUsers()
    }
    
    @objc func handledMessage(notif: Notification){
        loadChatMessages()
    }
    
    @objc func handledReceivedMessage(notif: Notification){
        loadChatMessages()
    }
    
    @objc func deliveryReceipt(notif: Notification) {
        loadChatMessages()
    }
    

    private func setupFloaty(){
        floaty.respondsToKeyboard = false
        floaty.paddingX = 30
        floaty.buttonImage = #imageLiteral(resourceName: "baseline_add_white_48pt_1x")
        floaty.hasShadow = true
        floaty.buttonColor = UIColor.MyScrapGreen
        
        let friendItem = FloatyItem()
        friendItem.buttonColor = UIColor.MyScrapGreen
        friendItem.title = "Friends"
        friendItem.icon = #imageLiteral(resourceName: "baseline_people_white_24pt_1x")
        friendItem.handler = { item in
            let vc = UINavigationController(rootViewController: MemberSearchController())
            self.present(vc, animated: true, completion: nil)
        }
        floaty.addItem(item: friendItem)
        
        let searchItem = FloatyItem()
        searchItem.buttonColor = UIColor.MyScrapGreen
        searchItem.title = "Search"
        searchItem.icon = #imageLiteral(resourceName: "baseline_search_white_24pt_1x")
        searchItem.handler = { item in
            self.searchButtonClicked()
        }
        floaty.addItem(item: searchItem)
        
        self.view.addSubview(floaty)
        self.view.bringSubviewToFront(floaty)
    }
   
    private func setupSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.isActive = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.subviews[0].subviews.flatMap { $0 as? UITextField }.first?.tintColor = UIColor.GREEN_PRIMARY
        self.extendedLayoutIncludesOpaqueBars = true
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    @objc
    private func searchButtonClicked(){
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    @objc
    func getChatHistory(){
        self.loadChatMessages()
        if self.refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    let activeView: ActiveUsersView = {
        let view = ActiveUsersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let seeAll : UIButton = {
        let btn = UIButton()
        btn.setTitle("See All > ", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self, action: #selector(seeAllBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    let seperatorView : UIView = {
        let vi = UIView()
        vi.height = 1
        vi.backgroundColor = UIColor.lightGray
        return vi
    }()
    
    private func setupViews(){
        let baseView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(baseView)
        
       
        let stackView = UIStackView(arrangedSubviews: [mytableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white

        baseView.addSubview(stackView)
//        activeView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        seeAll.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        seeAll.anchor(leading: nil, trailing: baseView.safeTrailing, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
//        seperatorView.translatesAutoresizingMaskIntoConstraints = false
//        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        seperatorView.anchor(leading: baseView.safeLeading, trailing: baseView.safeTrailing, top: seeAll.bottomAnchor, bottom: nil)
        
        stackView.anchor(leading: baseView.safeLeading, trailing: baseView.safeTrailing, top: baseView.safeTop, bottom: baseView.safeBottom, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        //baseView.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        mytableView.addSubview(refreshControl)
        
        //syncView = NVActivityIndicatorView(frame: CGRect(x: mytableView.center.x, y: mytableView.center.y, width: 60, height: 60), type: .ballPulseSync, color: .MyScrapGreen, padding: 0)
        mytableView.addSubview(syncView)
        
    }
    
    @objc
    private func seeAllBtnPressed(){
        if let vc = ActiveOnlineUsersVC.storyBoardInstance(){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    private func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }
    func addObservers(){
        /*NotificationCenter.default.addObserver(forName: Notification.Name.xmppSendMessage, object: nil, queue: nil) {(notif) in
            if let object = notif.object as? MessageViewModel{
//                self.handleMessage(message: object)
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.xmppReceivedMessage, object: nil, queue: nil) {(notif) in
            if let object = notif.object as? MessageViewModel{
//                self.handleMessage(message: object)
            }
        }*/
        
        NotificationCenter.default.addObserver(forName: Notification.Name.navigate, object: nil, queue: nil) { (notif) in
            if let obj = notif.object as? FriendModel {
                self.navigate(friendModel: obj)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .chatHistoryCompleted, object: nil, queue: nil) {  (notif) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                self.loadChatMessages()
            }
        }
        
    }
    
    var alreadyAppeared = false
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
        if activeUserTimer.isValid {
            activeUserTimer.invalidate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        refreshControl.beginRefreshing()
    }
    
}


extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filter.count
        } else if let lists = msg_lists {
            print("Number of section : \(msg_lists.count)")
            return lists.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 120
        }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        

        let baseView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100 ))
        baseView.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [activeView,seeAll,seperatorView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.frame = CGRect(x: 0, y: 0, width: view.width, height: 100)
        baseView.addSubview(stackView)
        activeView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        seeAll.heightAnchor.constraint(equalToConstant: 30).isActive = true
        seeAll.anchor(leading: nil, trailing: stackView.safeTrailing, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.anchor(leading: stackView.safeLeading, trailing: stackView.safeTrailing, top: seeAll.bottomAnchor, bottom: nil)
        
        stackView.anchor(leading: baseView.safeLeading, trailing: baseView.safeTrailing, top: baseView.safeTop, bottom: baseView.safeBottom, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
   //     stackView.anchor(leading: mytableView.leadingAnchor, trailing: mytableView.trailingAnchor , top: 0, bottom:0, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        


            return baseView
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentChatCell.identifier, for: indexPath) as? RecentChatCell else { return UITableViewCell()}
        var searchResults = UserPrivChat()
        if isFiltering() {
            searchResults = filter[indexPath.item]
        } else {
            searchResults = msg_lists[(indexPath as IndexPath).item]
//            readMsg_count = try! Realm().objects(UserPrivChat.self).filter("conversationId == '\(searchResults.conversationId)'").distinct(by: ["readCount"]).count
            readMsg_count = try! Realm().objects(UserPrivChat.self).filter("conversationId == '\(searchResults.conversationId)' AND readCount == 0").count
        }
        
        if searchResults.messageType == "receive" && searchResults.stanzaType == "" {
            cell.nameLabel.text = searchResults.fromUserName
            cell.msgLbl.text = searchResults.body
            cell.profileView.updateViews(name: searchResults.fromUserName.initials().replacingOccurrences(of: "", with: " "), url: searchResults.fromImageUrl, colorCode: searchResults.fromColorCode)
            cell.readImgView.image = UIImage(named: "")
            cell.timeLbl.text = self.FormateConversion(dateString: searchResults.time)
            print("Time from : \(cell.timeLbl.text!)")
        } else if searchResults.messageType == "sent" && searchResults.stanzaType == "" {
            cell.nameLabel.text = searchResults.toUserName
            cell.msgLbl.text = searchResults.body
            cell.profileView.updateViews(name: searchResults.toUserName.initials().replacingOccurrences(of: "", with: " "), url: searchResults.toImageUrl, colorCode: searchResults.toColorCode)
            let status = searchResults.offlineFlag
            //cell.setRead(status: status)
            cell.setMsgStatus(status: searchResults.msgStatus)
            cell.timeLbl.text = self.FormateConversion(dateString: searchResults.time) // searchResults.time
            
            print("Time to : \(cell.timeLbl.text!)")
        }
        else if searchResults.messageType == "receive" && ( searchResults.stanzaType == "imageAttach" || searchResults.stanzaType == "imageAttachment" ){
            cell.nameLabel.text = searchResults.fromUserName
            cell.msgLbl.text = "Image" // searchResults.body
            cell.profileView.updateViews(name: searchResults.fromUserName.initials().replacingOccurrences(of: "", with: " "), url: searchResults.fromImageUrl, colorCode: searchResults.fromColorCode)
            cell.readImgView.image = UIImage(named: "")
            cell.timeLbl.text = self.FormateConversion(dateString: searchResults.time) // searchResults.time
            print("Time from : \(cell.timeLbl.text!)")
        } else if searchResults.messageType == "sent" && (searchResults.stanzaType == "imageAttach" || searchResults.stanzaType == "imageAttachment" ){
            cell.nameLabel.text = searchResults.toUserName
          //  cell.msgLbl.text = searchResults.body
            cell.msgLbl.text = "Image"
            cell.profileView.updateViews(name: searchResults.toUserName.initials().replacingOccurrences(of: "", with: " "), url: searchResults.toImageUrl, colorCode: searchResults.toColorCode)
            let status = searchResults.offlineFlag
            //cell.setRead(status: status)
            cell.setMsgStatus(status: searchResults.msgStatus)
            cell.timeLbl.text = self.FormateConversion(dateString: searchResults.time) // searchResults.time
            
            print("Time to : \(cell.timeLbl.text!)")
        }
        else if searchResults.messageType == "receive" && searchResults.stanzaType == "marketAdv" {
            cell.nameLabel.text = searchResults.fromUserName
            cell.msgLbl.text = "Interested in your Market Ad"
            cell.profileView.updateViews(name: searchResults.fromUserName.initials().replacingOccurrences(of: "", with: " "), url: searchResults.fromImageUrl, colorCode: searchResults.fromColorCode)
            cell.readImgView.image = UIImage(named: "")
            cell.timeLbl.text = self.FormateConversion(dateString: searchResults.time) //searchResults.time
            print("Time from market receive: \(cell.timeLbl.text!)")
        } else if searchResults.messageType == "sent" && searchResults.stanzaType == "marketAdv" {
            cell.nameLabel.text = searchResults.toUserName
            cell.msgLbl.text = "Interested in your Market Ad"
            cell.profileView.updateViews(name: searchResults.toUserName.initials().replacingOccurrences(of: "", with: " "), url: searchResults.toImageUrl, colorCode: searchResults.toColorCode)
            let status = searchResults.offlineFlag
            //cell.setRead(status: status)
            cell.setMsgStatus(status: searchResults.msgStatus)
            cell.timeLbl.text = self.FormateConversion(dateString: searchResults.time) //searchResults.time
        }
        else
        {
            cell.nameLabel.text = searchResults.fromUserName
            cell.msgLbl.text = searchResults.body
            cell.profileView.updateViews(name: searchResults.fromUserName.initials().replacingOccurrences(of: "", with: " "), url: searchResults.fromImageUrl, colorCode: searchResults.fromColorCode)
            cell.readImgView.image = UIImage(named: "")
            cell.timeLbl.text = self.FormateConversion(dateString: searchResults.time) //searchResults.time
        }
        //Badge count
        print("Read count : \(searchResults.readCount), from db :\(readMsg_count)")
        if readMsg_count != 0 {
            cell.badgeLbl.isHidden = false
            cell.badgeLbl.text = String(readMsg_count)
        } else {
            cell.badgeLbl.isHidden = true
        }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            let row = filter[indexPath.item]
            guard let vc = ConversationVC.storyBoardInstance() else { return }
            
            if row.fromUserId == AuthService.instance.userId {
                vc.friendId = row.toUserId
                vc.profileName = row.toUserName
                vc.colorCode = row.toColorCode
                vc.profileImage = row.toImageUrl
                vc.jid = row.toJID
            } else {
                vc.friendId = row.fromUserId
                vc.profileName = row.fromUserName
                vc.colorCode = row.fromColorCode
                vc.profileImage = row.fromImageUrl
                vc.jid = row.fromJID
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let row = msg_lists[(indexPath as IndexPath).item]
            guard let vc = ConversationVC.storyBoardInstance() else { return }
            
            if row.fromUserId == AuthService.instance.userId {
                vc.friendId = row.toUserId
                vc.profileName = row.toUserName
                vc.colorCode = row.toColorCode
                vc.profileImage = row.toImageUrl
                vc.jid = row.toJID
            } else {
                vc.friendId = row.fromUserId
                vc.profileName = row.fromUserName
                vc.colorCode = row.fromColorCode
                vc.profileImage = row.fromImageUrl
                vc.jid = row.fromJID
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension ChatVC{
    /*static func storyBoardInstance() -> ChatVC?{
        return ChatVC()
    }*/
    static func storyBoardInstance() -> ChatVC? {
        let sb = UIStoryboard.chat
        return sb.instantiateViewController(withIdentifier: ChatVC.id) as? ChatVC
    }
}


private extension Date {
    func toString(dateformat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension ChatVC: LastMessagViewModelRepresentable {
    func deleteMessage(at indexPath: IndexPath) {
        if viewModel?.messages.count == 0 {
            mytableView.reloadData()
        } else {
            mytableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func insertMessage(at indexPath: IndexPath) {
        mytableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
}

struct FriendModel{
    let id : String
    let profileName: String
    let colorCode: String
    let profileImg: String
    let jid: String
}


extension ChatVC: FriendNaviDelegate {
    func navigate(friendModel: FriendModel ){
        performConversationVC(friendId: friendModel.id , profileName: friendModel.profileName, colorCode: friendModel.colorCode, profileImage: friendModel.profileImg , jid: friendModel.jid, listingId: "", listingTitle: "", listingType: "", listingImg: "")
    }
    
    func convc(id: String, name: String, color: String, image: String, jid: String) {
        if AuthStatus.instance.isGuest{
            self.showGuestAlert()
        } else {
            guard let vc = ConversationVC.storyBoardInstance() else { return }
            
            vc.friendId = id
            vc.profileName = name
            vc.colorCode = color
            vc.profileImage = image
            vc.jid = jid
            
            //Market POST Link Send as Chat Message
            vc.listingId = ""
            vc.listingTitle = ""
            vc.listingType = ""
            vc.listingImg = ""
            
            
            
            self.navigationController?.pushViewController(vc, animated: true)
            /*if member.isMemberExists(with: jid, context: context) {
             vc.member = member.getMember(with: jid, moc: context)
             
             self.navigationController?.pushViewController(vc, animated: true)
             } else {
             guard let name = profileName, let colorCode = colorCode, let profilepic = profileImage else { return }
             if let member = member.createNewMember(userid: friendId, jid: jid, profilePic: profilepic, colorCode: colorCode, name: name, context: context) {
             vc.member = member
             self.navigationController?.pushViewController(vc, animated: true)
             }
             }*/
        }
    }
    func performFriendView(friendId: String){
        switch friendId {
        case nil:
            return
        case "":
            return
        case AuthService.instance.userId:
            if let vc = ProfileVC.storyBoardInstance() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            if let vc = FriendVC.storyBoardInstance() {
                vc.friendId = friendId
                UserDefaults.standard.set(friendId, forKey: "friendId")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension ChatVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        msg_lists = try! Realm().objects(UserPrivChat.self).sorted(byKeyPath: "timeStamp", ascending: false).distinct(by: ["conversationId"])
        //filteredCandies = try! Realm().objects(UserPrivChat.self).sorted(byKeyPath: "timeStamp", ascending: false).distinct(by: ["conversationId"])
        filter = msg_lists.filter { (db) -> Bool in
            if db.fromUserId != AuthService.instance.userId {
                return db.fromUserName.lowercased().contains(searchText.lowercased())
            } else if db.toUserId != AuthService.instance.userId {
                return db.toUserName.lowercased().contains(searchText.lowercased())
            } else {
                return false
            }
        }
        print("Search Text value : \(filter)")
        mytableView.reloadData()
    }
}

extension UIView{
    func makeRounded(){
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.clipsToBounds = true
    }
}
protocol FriendNaviDelegate {
    func performFriendView(friendId: String)
    func convc(id: String, name: String, color: String, image: String, jid: String)
}


class ActiveUsersView: UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    
    var memObj = MessageOperation()
    
    var activeDataSource = [ActiveUsers]()
    let service = ChatService()
    
    fileprivate var shouldReloadCollectionView = false
    
    var delegate : FriendNaviDelegate?
    
    

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = " Active Users"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        return lbl
    }()
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        cv.flashScrollIndicators()
        return cv
    }()
    
    let spinner: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    func reloadCollectionView(){
        DispatchQueue.main.async {
            self.reloadData()
            self.isHidden = self.activeDataSource.isEmpty
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        getActiveUsers()
        //service.delegate = self
        setupViews()
        
        setupCollectionView()
        setupSpinner()
        //reloadCollectionView()
        activeUserTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode() {
        getActiveUsers()
    }
    
    func setupSpinner() {
        self.addSubview(spinner)
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
    }
    
    func reloadData(){
        collectionView.reloadData()
    }
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ActiveCollectionViewCell.self, forCellWithReuseIdentifier: "ActiveCollectionViewCell")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews(){
        addSubview(titleLabel)
        
        titleLabel.anchor(leading: safeLeading, trailing: safeTrailing, top: safeTop, bottom: nil, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        
        addSubview(collectionView)
        collectionView.anchor(leading: safeLeading, trailing: safeTrailing, top: titleLabel.bottomAnchor, bottom: nil, padding: UIEdgeInsets(top: 3, left: 12, bottom: 0, right: 0))
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
    }
    
    private func closeStack() {
        titleLabel.anchor(leading: safeLeading, trailing: nil, top: safeTop, bottom: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        collectionView.anchor(leading: safeLeading, trailing: safeTrailing, top: titleLabel.bottomAnchor, bottom: safeBottom)
    }
    
    private func openStack() {
        titleLabel.anchor(leading: safeLeading, trailing: nil, top: safeTop, bottom: nil, padding: UIEdgeInsets(top: 3, left: 8, bottom: 0, right: 0))
        collectionView.anchor(leading: safeLeading, trailing: safeTrailing, top: titleLabel.bottomAnchor, bottom: safeBottom)
    }
    
    private func getActiveUsers(){
        service.activeUsers()
        service.delegate = self
    }
    
    //CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Active online users :\(activeDataSource.count)")
        if activeDataSource.count == 0 {
            closeStack()
            return 0
        } else {
            if activeDataSource.count <= 25 {
                openStack()
                return activeDataSource.count
            } else {
                openStack()
                return 25
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActiveUsersCell", for: indexPath) as! ActiveUsersCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActiveCollectionViewCell", for: indexPath) as! ActiveCollectionViewCell
        
        let row = activeDataSource[indexPath.item]
        print("Profileview : \(cell.initials)")
        cell.profileView.updateViews(name: row.name!, url: row.profilePic!, colorCode: row.colorCode!)
        cell.initials.text = row.name?.initials().replacingOccurrences(of: "", with: " ")
        let lastSeen = row.lastActive
        if row.online == true && lastSeen == "" {
            cell.lastSeen.isHidden = true
            cell.onlineViews.isHidden = false
        } else {
            cell.lastSeen.isHidden = false
            cell.onlineViews.isHidden = true
            cell.lastSeen.setTitle(lastSeen, for: .normal)
        }
       
            
        if row.profilePic == "" || row.profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" ||  row.profilePic == "https://myscrap.com/style/images/icons/no_image.png" ||  row.profilePic == "https://myscrap.com/style/images/icons/profile.png" {
            cell.profileImageView.isHidden = true
        } else {
            cell.profileImageView.isHidden = false
            cell.profileImageView.sd_setImage(with: URL(string: row.profilePic!), completed: nil)
        }
        
//        cell.profileTypeView.isHidden = true
        //profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank)
//        cell.onlineView.isHidden = !row.online
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Directly navigating to Conversation page
        let row = activeDataSource[indexPath.row]
        let friendId = row.userid
        let name = row.name ?? ""
        let colorcode = row.colorCode ?? ""
        let profileImg = row.profilePic ?? ""
        let jId = row.jId
        if friendId != nil && jId != nil {
            delegate?.convc(id: friendId!, name: name, color: colorcode, image: profileImg, jid: jId!)
        } else {
            //If not navigating to profile page
            delegate?.performFriendView(friendId: activeDataSource[indexPath.row].userid!)
        }
        
        
        //delegate?.performFriendView(friendId: activeDataSource[indexPath.row].userid!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 70)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }*/
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }*/
}
extension ActiveUsersView: ChatServiceDelegate {
    func DidReceivedData(data: [ActiveUsers]) {
        DispatchQueue.main.async {
            self.activeDataSource = data
            self.collectionView.reloadData()
            if self.spinner.isAnimating == true {
                self.spinner.stopAnimating()
            }
            
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error in online users fetch: \(error)")
    }
}
class ActiveCollectionViewCell: UICollectionViewCell{
    let profileView : ProfileView = {
        let view = ProfileView()
        view.backgroundColor = .white
        view.x = 8
        view.y = 0
        view.height = 60
        view.width = 60
        return view
    }()
    let initials : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue", size: 17)
        lbl.height = 20
        lbl.width = 20
        lbl.textColor = .white
        return lbl
    }()
    let onlineViews : CircleView = {
        let online = CircleView()
        online.height = 15
        online.width = 15
        return online
    }()
    let lastSeen : UIButton = {
        let btn = UIButton()
        btn.height = 20
        btn.width = 20
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = false
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 10)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("-", for: .normal)
        return btn
    }()
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.x = 8
        iv.y = 0
        iv.height = 60
        iv.width = 60
        iv.layer.cornerRadius = 30
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    /*
    var member : ActiveUsers? {
        didSet {
            guard let item = member else { return }
            
            profileImageView.setImageWithIndicator(imageURL: item.profilePic!)
        }
    }*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(profileView)
        addSubview(lastSeen)
    
        profileView.addSubview(initials)
        
        addSubview(onlineViews)
        onlineViews.backgroundColor = UIColor(hexString: "#42B72A")
        
        onlineViews.translatesAutoresizingMaskIntoConstraints = false
        onlineViews.anchor(leading: nil, trailing: profileView.trailingAnchor, top: nil, bottom: profileView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 3), size: CGSize(width: 15, height: 15))
        
        lastSeen.translatesAutoresizingMaskIntoConstraints = false
        lastSeen.backgroundColor = UIColor(hexString: "#42B72A")
        lastSeen.anchor(leading: nil, trailing: profileView.trailingAnchor, top: nil, bottom: profileView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 25, height: 15))
        
        initials.translatesAutoresizingMaskIntoConstraints = false
        initials.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
        initials.centerYAnchor.constraint(equalTo: profileView.centerYAnchor).isActive = true
        
        
        
        profileView.anchor(leading: self.leadingAnchor, trailing: nil, top: self.topAnchor, bottom: nil, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0), size: CGSize(width: 60, height: 60))
        profileView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.anchor(leading: profileView.leadingAnchor, trailing: profileView.trailingAnchor, top: profileView.topAnchor, bottom: profileView.bottomAnchor)
        
        
        
        
//        onlineViews.translatesAutoresizingMaskIntoConstraints = false
//        onlineViews.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
//        onlineViews.centerYAnchor.constraint(equalTo: profileView.centerYAnchor).isActive = true
//        onlineViews.anchor(leading: nil, trailing: profileView.trailingAnchor, top: nil, bottom: profileView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 10, height: 10))
        print("Online view : \(onlineViews)")
        
        
    }
}

extension String{
    var  userJID : String {
        return components(separatedBy: "@")[0]
    }
}





