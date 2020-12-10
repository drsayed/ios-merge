//
//  SingleNewsVC.swift
//  myscrap
//
//  Created by MS1 on 8/28/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//
/*
import UIKit
import SafariServices
import IQKeyboardManagerSwift

class SingleNewsVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate , FriendControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    fileprivate var comment: String = ""
    
    
    
    lazy var refreshcontrol: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        return rc
    }()
    

    
    var newsId = ""
    var news = [News]()
    var commenet = [Like]()
    fileprivate var commenet2 = [Like]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        tableView.addSubview(refreshcontrol)
        refreshcontrol.beginRefreshing()
        getApi()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardObserver()
        IQKeyboardManager.sharedManager().enable = false
        self.tableView.estimatedRowHeight = 100
        tableView.keyboardDismissMode = .interactive
        textView.delegate = self
        if !validate(textView: textView){
            
            sendBtn.isUserInteractionEnabled = false
            sendBtn.tintColor = UIColor.lightGray
        } else {
            sendBtn.isUserInteractionEnabled = true
            sendBtn.tintColor = UIColor.GREEN_PRIMARY
            
        }
    }
    @objc func handleRefresh(_ sender: UIRefreshControl){
        getApi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
        IQKeyboardManager.sharedManager().enable = true
    }
    func getApi(){
        let api = APIService()
        api.endPoint = Endpoints.SINGLE_NEWS_URL
        let userId = UserDefaults.standard.value(forKey: "userid") as! String
        api.params = "userId=\(userId)&apiKey=\(API_KEY)&newsId=\(newsId)"
        print(api.params)
        api.getDataWith { (result) in
            
            switch result{
            case .Error(let errorMsg):
                print(errorMsg)
                DispatchQueue.main.async {
                    if self.refreshcontrol.isRefreshing{
                        self.refreshcontrol.endRefreshing()
                    }
                }
            case .Success(let dict):
                self.dealData(dict: dict)
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        
        if !validate(textView: textView){
            
            sendBtn.isUserInteractionEnabled = false
            sendBtn.tintColor = UIColor.lightGray
        } else {
            sendBtn.isUserInteractionEnabled = true
            sendBtn.tintColor = UIColor.GREEN_PRIMARY
            
        }
    }
    func dealData(dict: [String: AnyObject]){
        
        if let singleNewsData = dict["singleNewsData"] as? [[String:AnyObject]]{
            var newss = [News]()
            for obj in singleNewsData{
                let singleNews = News(newsDict: obj)
                newss.append(singleNews)
            }
            
            DispatchQueue.main.async {
                if self.refreshcontrol.isRefreshing{
                    self.refreshcontrol.endRefreshing()
                }
                self.news = [newss.last!]
                self.commenet = (newss.last?.commentDict)!
                self.tableView.reloadData()
            }
        }
        
    }
    fileprivate func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        
        return true
    }
    private func keyboardObserver(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UITextInputCurrentInputModeDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
         }
    
    @objc func toFriendView(_ sender: UIGestureRecognizer){
        let obj = commenet[(sender.view?.tag)!]
        performFriendView(friendId: obj.userId)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = value.cgRectValue.height
        self.bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification){
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    private func removeKeyboardObserver(){
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? SingleNewsCell else {return UITableViewCell()}
            if let new = news.last{
                cell.delegate = self
                cell.configCell(news: new)
            }
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentsCell
            cell.selectionStyle = .none
            let comm = commenet[indexPath.row]
            cell.configCell(comment: comm)
            cell.delegate = self
            cell.profileImage.isUserInteractionEnabled = true
            cell.profileImage.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
            tap.numberOfTapsRequired = 1
            cell.profileImage.addGestureRecognizer(tap)
            return cell

        default:
            return UITableViewCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch commenet.count {
        case 0:
            return 1
        default:
            return 2
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return news.count
        case 1:
            return commenet.count
        default:
            return 0
        }
    }
    @IBAction func commentBtnPRessed(_ sender: Any) {
        self.view.endEditing(true)
        comment = textView.text
        textView.text = ""
        sendBtn.isUserInteractionEnabled = false
        sendBtn.tintColor = UIColor.lightGray
        if UserDefaults.standard.bool(forKey: "isGuest"){
            self.showGuestAlert()
        } else {
            insertComment()
        }
    }
    
    
    
    // MARK:- Insert Comment Api
    fileprivate func insertComment(){
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let userId = UserDefaults.standard.value(forKey: "userid") as! String
        if let feed = news.last{
            let api = APIService()
            api.endPoint = Endpoints.COMMENT_INSERT_URL
            api.params = "userId=\(userId)&postId=\(feed.postId ?? "")&friendId=\(feed.postedUserId ?? "")&comment=\(comment)&timeStamp=\(timestamp)&apiKey=\(API_KEY)"
            api.getDataWith(completion: { (result) in
                switch result{
                case .Success(let dict):
                    self.dealInsertComment(dict: dict)
                case .Error(let error):
                    print(error)
                }
            })
        }
    }
    fileprivate func dealInsertComment(dict: [String:AnyObject]){
    if let error = dict["error"] as? Bool{
        if !error{
            if let commentData = dict["commentData"] as? [Dictionary<String,AnyObject>]{
                self.commenet2 = [Like]()
                for obj in commentData{
                    let comment = Like(commentDict: obj)
                    self.commenet2.append(comment)
                }
                DispatchQueue.main.async {
                    self.commenet = self.commenet2
                    self.tableView.reloadData()
                    }
                }
            }
        }
    }
}


extension SingleNewsVC: SingleNewsDelegate{
    func likeButtonPressed(cell: SingleNewsCell) {
       let indexpath = tableView.indexPathForRow(at: cell.center)
        let n = news.last!
        
        if let status = news.last?.likeStatus {
           
            switch status {
            case true:
                n.likeStatus = false
                n.likeCount = n.likeCount - 1

            
            case false:
                n.likeStatus = true
                n.likeCount = n.likeCount + 1
                
            }
            tableView.reloadRows(at: [indexpath!], with: .automatic)
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 80
        } else {
            return UITableViewAutomaticDimension
        }
    }
    func companyPressed(cell: SingleNewsCell) {
        let n = news.last!
        let svc = SFSafariViewController(url: URL(string: n.publisherUrl!)!)
        svc.preferredBarTintColor = UIColor.GREEN_PRIMARY
        
        self.present(svc, animated: true, completion: nil)
        
    }
    func likeCountPressed(cell: SingleNewsCell) {
        if let new = news.last , let id = new.postId{
            let vc = LikesController()
            vc.title = "Likes"
            vc.id = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
        
//        if let vc = LikeVC.storyBoardInstance(){
//            vc.feedLike = false
//            vc.like  = (news.last?.likeData)!
//            vc.isNewsLike = true
//            self.navigationController?.pushViewController(vc, animated: true)
//
}

extension SingleNewsVC: CommentDelegate{
    func editCommentPressed(cell:CommentsCell){
        self.view.endEditing(true)
        let indexPath = self.tableView.indexPathForRow(at: cell.center)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
            let cmnt = self.commenet[(indexPath?.row)!]
            self.deleteComment(cmnt: cmnt)
            switch self.commenet.count{
            case 1:
                self.commenet.remove(at: (indexPath?.section)! - 1)
                let indexSet = IndexSet(arrayLiteral: (indexPath?.section)!)
                self.tableView.deleteSections(indexSet, with: .fade)
            default:
                self.commenet.remove(at: (indexPath?.row)!)
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    fileprivate func deleteComment(cmnt: Like){
        let api = APIService()
        api.endPoint = Endpoints.COMMENT_DELETE_URL
        let userId = UserDefaults.standard.value(forKey: "userid") as! String
        api.params = "userId=\(userId)&postId=\(cmnt.postId)&commentId=\(cmnt.commentId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success")
            case .Error(let err):
                print(err)
            }
        }
    }
    
    static func storyBoardInstance() -> SingleNewsVC?{
        let st = UIStoryboard(name: "Main", bundle: nil)
        return st.instantiateViewController(withIdentifier: "SingleNewsVC") as? SingleNewsVC
    }
    
}
*/
