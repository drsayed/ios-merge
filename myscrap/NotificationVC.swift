//
//  NotificationVC.swift
//  myscrap
//
//  Created by MS1 on 5/31/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController{
    
    fileprivate var dataSource = [AnyObject]() {
        didSet {
            refreshTableView()
        }
    }
    
    private var notificationTask : URLSessionTask?
    
    fileprivate var dataService = Notifications()
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var active: UIActivityIndicatorView!
    
    fileprivate var isInitiallyLoaded = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        self.tableView.addSubview(refreshControl)
        tableView.register(EmptyCell.nib, forCellReuseIdentifier: EmptyCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.dataSource.count == 0 {
            active.startAnimating()
        }
        NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

        getNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     //   notificationTask?.cancel()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        refreshControl.beginRefreshing()
        active.stopAnimating()
        self.getNotifications()
    }
    
    private func refreshTableView(){
        self.isInitiallyLoaded = true
        if active.isAnimating{
            active.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
    }
    
    private func getNotifications(){
        DispatchQueue.global(qos:.userInteractive).async {
            
            self.dataService.fetchNotificationsWith({ [weak self] (result) in
                DispatchQueue.main.async {
                    switch result{
                    case .Success(let data):
                        NotificationService.instance.notificationCount = 0
                        self?.dataSource = data
                    case .Error(_):
                        if self?.dataSource == nil || self?.dataSource.count == 0 {
                            self?.dataSource = [AnyObject]()
                        }
                       
                    }
                }
            })
        }
//        notificationTask = dataService.fetchNotificationsWith({ [weak self] (result) in
//            DispatchQueue.main.async {
//                switch result{
//                case .Success(let data):
//                    NotificationService.instance.notificationCount = 0
//                    self?.dataSource = data
//                case .Error(_):
//                    if self?.dataSource == nil || self?.dataSource.count == 0 {
//                        self?.dataSource = [AnyObject]()
//                    }
//
//                }
//            }
//        })
    }
    
    
    @IBAction func closeBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearNotificationTapped(_ sender: UIBarButtonItem){
        self.dataSource = [AnyObject]()
        dataService.clearNotification()
    }
    
}

extension NotificationVC : UITableViewDataSource{
    
    //MARK:- Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    //MARK:- Cell for Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let item = dataSource[indexPath.item] as? RequestNotificationItem
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationRequestCell", for: indexPath) as! NotificationRequestCell
            cell.configRequestCell(item: item)
            //  cell.setAttributeStringLable(with: item)
            cell.completion = { value, cell in
                if let ip = tableView.indexPathForRow(at: cell.center){
                  /*  if value == 100
                    {
                        // accepted
                        let  obj = self.dataSource[ip.row] as? RequestNotificationItem
                        if obj?.type == .card
                        {
                            self.sendRequestAction(friendId: obj!.friendId, Type: "0", isAccepted: true)
                        }
                        else
                        {
                            self.sendRequestAction(friendId: obj!.friendId, Type: "1", isAccepted: true)
                        }
                        
                    }
                    else{
                        let  obj = self.dataSource[ip.row] as? RequestNotificationItem
                        if obj?.type == .card
                        {
                            self.sendRequestAction(friendId: obj!.friendId, Type: "0", isAccepted: false)
                        }
                        else
                        {
                            self.sendRequestAction(friendId: obj!.friendId, Type: "1", isAccepted: false)
                        }
                        // rejected
                    }
                    
                    //    self.callMarketListingservice(value: value, indexPath: ip)
                     */
                    let  dataObj = self.dataSource[ip.row] as? RequestNotificationItem
                    
                    if dataObj != nil {
                        self.sendRequestAction(obj: dataObj!, tagValue: value)
                    }
                }
            }
            if item.status == .seen {
                cell.backgroundColor = UIColor.white
            }
            else
            {
                cell.backgroundColor =  UIColor.BACKGROUND_GRAY //UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00) // UIColor.gray
            }
          
//            if item.active == .seen {
//                cell.backgroundColor =
//            }
            return cell
            
        }
        else{
            let item = dataSource[indexPath.row] as! NotificationItem
            
            if item.postType == .listing && item.chatRequestStatus == .requested {
                let cell = tableView.dequeueReusableCell(withIdentifier: "listing", for: indexPath) as! NotificationListingCell
                cell.configCell(item: item)
                cell.completion = { value, cell in
                    if let ip = tableView.indexPathForRow(at: cell.center){
                        self.callMarketListingservice(value: value, indexPath: ip)
                    }
                }
            //    || UserDefaults.standard.bool(forKey: "\(item.listingId)Seen") || UserDefaults.standard.bool(forKey: "\(item.postId)Seen") || UserDefaults.standard.bool(forKey: "\(item.userid)Seen")
                if item.active == .seen || UserDefaults.standard.bool(forKey: "\(item.notId)Seen" )  {
                    cell.backgroundColor = UIColor.white
                }
                else
                {
                    cell.backgroundColor =  UIColor.BACKGROUND_GRAY //UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00)  //UIColor.gray
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationCell
                cell.configCell(item: item)
                   // || UserDefaults.standard.bool(forKey: "\(item.listingId)Seen") || UserDefaults.standard.bool(forKey: "\(item.postId)Seen") || UserDefaults.standard.bool(forKey: "\(item.userid)Seen" ) 
                if item.active == .seen || UserDefaults.standard.bool(forKey: "\(item.notId)Seen" ) {
                    cell.backgroundColor = UIColor.white
                }
                else
                {
                    cell.backgroundColor =  UIColor.BACKGROUND_GRAY // UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00) //UIColor.lightGray
                }
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data = dataSource[indexPath.row] as! NotificationItem
        if let data = dataSource[indexPath.item] as? NotificationItem
        {
            data.active = .seen
            UserDefaults.standard.set(true, forKey: "\(data.notId)Seen")
            tableView.reloadData()
            switch data.postType {
            case .Post:
                self.gotoPostVC(item: data)
            case .video:
                self.gotoPostVC(item: data)
            case .number:
                self.gotoFriendView(item: data)
            case .card:
                self.gotoFriendCardView(item: data)
            case .numberaccept:
                self.gotoFriendView(item: data)
            case .numberreject:
                self.gotoFriendView(item: data)
            case .cardaccept:
                self.gotoFriendCardView(item: data)
            case .cardreject:
                self.gotoFriendCardView(item: data)
            case .User:
                if data.notificationMessage.contains("business card")
                {
                    self.gotoFriendCardView(item: data)
                }
                else{
                    self.gotoFriendView(item: data)
                }
            case .user:
                if data.notificationMessage.contains("business card")
                {
                    self.gotoFriendCardView(item: data)
                }
                else{
                    self.gotoFriendView(item: data)
                }
            case .marketmpost:
                self.gotoListingVC(item: data)
            case .listing:
                self.gotoListingVC(item: data)
            case .live:
                self.gotoJoinLiveVC(item: data)
            case .other:
                self.gotoFeedsVC(item: data)
            }
        }
        
    }
    
    func callMarketListingservice(value: Int, indexPath: IndexPath){
        
        let item = dataSource[indexPath.row]  as! NotificationItem
        
        if let window = UIApplication.shared.keyWindow {
            let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            window.addSubview(overlay)
            
            let av = UIActivityIndicatorView(style: .whiteLarge)
            av.center = overlay.center
            av.startAnimating()
            overlay.addSubview(av)
            dataService.acknowledgeMarket(listId: item.listingId ?? "" ,postedUserId: item.userid, status: value) { (returnValue) in
                av.stopAnimating()
                overlay.removeFromSuperview()
                print("REturn Value", returnValue)
                
                if let stringvalue = returnValue, let intValue = Int(stringvalue), let reqStatus = MarketChatStatus(rawValue: intValue){
                    item.chatRequestStatus = reqStatus
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isInitiallyLoaded && dataSource.isEmpty{
            return self.view.frame.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.identifier) as! EmptyCell
        cell.emptyImg.image = #imageLiteral(resourceName: "ic_notification_empty")
        cell.emptyLabel.text = "No Notifications"
        return cell
    }
    
    static func storyBoardInstance() -> NotificationVC?{
        return UIStoryboard.MAIN.instantiateViewController(withIdentifier: NotificationVC.id) as? NotificationVC
    }
}

extension NotificationVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource[indexPath.item] is RequestNotificationItem
        {
            return 85 + 40
        }
        else
        {
            let item = dataSource[indexPath.item] as! NotificationItem
            if item.postType == .listing && item.chatRequestStatus == .requested {
                return 85 + 40
            } else {
                return 85
            }
        }
        
    }
}

//MARK:- Custom Actions
extension NotificationVC{
    fileprivate func gotoPostVC(item: NotificationItem){
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = item.postId
        vc.notificationId = item.notId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func gotoFriendCardView(item:NotificationItem){
        if let vc = FriendVC.storyBoardInstance(){
            vc.friendId = item.userid
            vc.notificationId = item.notId
            vc.isfromCardNoti = "1"
            UserDefaults.standard.set(item.userid, forKey: "friendId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    fileprivate func gotoFriendView(item:NotificationItem){
        if let vc = FriendVC.storyBoardInstance(){
            vc.friendId = item.userid
            vc.notificationId = item.notId
            vc.isfromCardNoti = ""
            UserDefaults.standard.set(item.userid, forKey: "friendId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func gotoListingVC(item: NotificationItem){
        if item.listingId != nil {
            let vc = DetailListingOfferVC.controllerInstance(with:  item.listingId, with1: item.userid)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if let vc = MarketVC.storyBoardInstance(){
                self.navigationController?.pushViewController(vc, animated: true)

            }
         //   pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)

         //   let vc = DetailListingOfferVC.controllerInstance(with:  item.listingId, with1: item.userid)
      //      self.navigationController?.pushViewController((storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id), animated: true)
        }
     
    }
    fileprivate func gotoJoinLiveVC(item: NotificationItem){
        if let vc = JoinUserLiveVC.storyBoardInstance() {

            vc.friendId = item.userid
            vc.liveID = item.liveId
            vc.liveUserNameValue  = item.name
            vc.liveUserImageValue  = item.profilePic
            vc.liveUserProfileColor  = item.colorCode
            vc.liveUsertopicValue  = ""
            vc.isFromNotificationClick  = false
            vc.liveType  =  "single"
            self.navigationController?.pushViewController(vc, animated: true)

            }
    }
    fileprivate func gotoFeedsVC(item: NotificationItem) {
        if let vc = FeedsVC.storyBoardInstance() {
            vc.isScrollToAD = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NotificationVC
{
    /*
    func sendRequestAction(friendId: String, Type: String, isAccepted:Bool) {
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Requesting..."
        let service = APIService()
        if isAccepted
        {
            service.endPoint =  Endpoints.Send_Accept_Request
            
        }
        else
        {
            service.endPoint =  Endpoints.Send_Reject_Request
            
        }
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=\(friendId)&type=\(Type)"
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: (self?.view)!, animated: true)
                            self?.getNotifications()
                        }
                        
                        //     delegate?.DidReceiveStories(item: items)
                    } else {
                        DispatchQueue.main.async {
                            self?.showToast(message: dict["status"] as? String ?? "Error in sending request")
                        }
                        //  delegate?.DidReceiveError(error: "Received Error in JSON Result...!")
                    }
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    self?.showToast(message: error)
                }
            }
        }
    }*/
    
    func sendRequestAction(obj : RequestNotificationItem, tagValue: Int) { //friendId: String, Type: String, isAccepted:Bool) {
        obj.status = .seen
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Requesting..."
        let service = APIService()
        
        var endPoint = ""
        let friendId = obj.friendId
        var apiType = ""
        var body =  "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=\(friendId)&type=\(apiType)"

        if obj.type == .Card {
            apiType = "0" // card
        }
        else if obj.type == .Mobile {
             apiType = "1" //
        }
        
        if tagValue == 100 { // Accept
            if obj.type == .Follow {
                endPoint = Endpoints.ACCEPT_FOLLOW_REQUEST
            }
            else if obj.type == .EmployeeRequest { // Accept
                apiType = "1"
                endPoint = Endpoints.ADD_OR_DECLINE_EMPLOYEE_REQUEST
                body =  "userId=\(obj.userid)&apiKey=\(API_KEY)&companyId=\(obj.companyID)&type=\(apiType)"
            }
            else {
                endPoint = Endpoints.Send_Accept_Request
            }
        }
        else { // Decline
            if obj.type == .Follow {
                endPoint = Endpoints.REJECT_FOLLOW_REQUEST
            }
            else if obj.type == .EmployeeRequest { // Decline
                apiType = "0"
                endPoint = Endpoints.ADD_OR_DECLINE_EMPLOYEE_REQUEST
                body =  "userId=\(obj.userid)&apiKey=\(API_KEY)&companyId=\(obj.companyID)&type=\(apiType)"
            }
            else {
                endPoint = Endpoints.Send_Reject_Request
            }
        }
        service.endPoint = endPoint
        service.params = body
        print("URL : \(endPoint), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            
            switch result{
            case .Success(let dict):
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: (self?.view)!, animated: true)
                    if let error = dict["error"] as? Bool {
                        if !error{
                            self?.getNotifications()
                        } else {
                            self?.showToast(message: dict["status"] as? String ?? "Error in sending request")
                        }
                    }
                }
                
            case .Error(let error):
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: (self?.view)!, animated: true)
                    self?.showToast(message: error)
                }
            }
        }
    }
}




