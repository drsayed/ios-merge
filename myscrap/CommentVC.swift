//
//  CommentVC.swift
//  myscrap
//
//  Created by MS1 on 8/2/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CommentVC: BaseVC , FriendControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var active: UIActivityIndicatorView!
    @IBOutlet weak var sendBtn: CircularButton!
    
    
    var commenet = [Like]()
    var commenet2 = [Like]()
    
    var postId = ""
    var postedUserId = ""
    
    var comment = ""
    
    @IBOutlet weak var bottomConStraint: NSLayoutConstraint!
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        
        textView.keyboardType = .default
        textView.delegate = self
        
        active.startAnimating()
        
        self.tableView.addSubview(refreshControl)
        
        self.tableView.keyboardDismissMode = .interactive
        
        
        getDetails()
        
    }
    
    
    func toggleSendBtn(){
        
        
        
        if !validate(textView: textView){
            
            sendBtn.isUserInteractionEnabled = false
            sendBtn.tintColor = UIColor.lightGray
        } else {
            sendBtn.isUserInteractionEnabled = true
            sendBtn.tintColor = UIColor.GREEN_PRIMARY
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        IQKeyboardManager.sharedManager().enable = false
        self.keyboardObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        IQKeyboardManager.sharedManager().enable = true
        self.removeKeyboardObserver()
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl){
        
        
        self.getDetails()
    }
    
    func getDetails(){
        let userid = UserDefaults.standard.value(forKey: "userid") as! String
        
        
        let url = URL(string: Endpoints.DETAILS_POST_URL)!
        let postString = "userId=\(userid)&apiKey=\(API_KEY)&postId=\(postId)"
        
        
        print(url)
        print(postString)
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "content-Type")
        
        
        request.httpBody = postString.data(using: String.Encoding.ascii, allowLossyConversion: false)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else{
                return
            }
            guard let data = data else {
                
                return
            }
            
            
            do {
                
                if let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,AnyObject>{
                    
                    print(dict)
                    
                    
                    if let error = dict["error"] as? Bool{
                        
                        
                        if !error{
                            

   
                                if let commentData = dict["commentData"] as? [Dictionary<String,AnyObject>]{
                                    
                                    
                                    self.commenet2.removeAll()
                                    
                                    for obj in commentData{
                                        
                                        let comment = Like(commentDict: obj)
                                        self.commenet2.append(comment)
                                    }
                                }
                                
                                
                                
                            }
                            
                            
                            DispatchQueue.main.async {
                                
                                
                                if self.active.isAnimating{
                                    
                                    self.active.stopAnimating()
                                }
                                
                                if self.refreshControl.isRefreshing{
                                    
                                    self.refreshControl.endRefreshing()
                                }
                                
                                
                                self.commenet = self.commenet2
        
                                
                                self.tableView.reloadData()
                            
                                
                                if !self.commenet.isEmpty {
                                    
                                     let indexPath = IndexPath(row: self.commenet.count - 1, section: 0)
                                    
                                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                                    
                                    
                                }
                                
                            }
                            
                            
                        } else {
                            
                            // MARK :- HANDLE IF ERROR
                            
                            print("something wrong happend please try again later")
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                
            }
                
                catch let error {
                
                print(error.localizedDescription)
            }
            
            
        }
        task.resume()
        
        
        
        
        
    }
    
    func insertComment(){
        let API_URL = Endpoints.COMMENT_INSERT_URL
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        
        
        let userId = UserDefaults.standard.value(forKey: "userid") as! String
        
        
        let url = URL(string: API_URL)!
        print(url)
        let postString = "userId=\(userId)&postId=\(postId)&postedUserId=\(postedUserId)&comment=\(comment)&timeStamp=\(timestamp)&apiKey=\(API_KEY)"
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "content-Type")
        
        
        request.httpBody = postString.data(using: String.Encoding.ascii, allowLossyConversion: false)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                
                return
            }
            guard let data = data  else {
                
                return
            }
            
            do {
                
                if let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,AnyObject>{
                    
                    print(dict)
                    
                    
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
                            
                        } else {
                            
                            print("api error or error status true")
                        }
                        
                    }
                    
                    
                    
                }
                
                
            } catch let error{
                
                print(error.localizedDescription)
            }
            
            
        }
        
        task.resume()
        
    }

    
    @IBAction func commentBtnPRessed(_ sender: Any) {
        
        
        if UserDefaults.standard.bool(forKey: "isGuest"){
            
            self.showGuestAlert()
            
        } else {
            
            comment = textView.text
            textView.text = ""
            insertComment()
            
        }
        
        
    }
    
}

extension CommentVC: UITableViewDataSource,UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
    return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commenet.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentCell
        
        let com = commenet[indexPath.row]
        
        cell.configCell(comment: com)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let com = commenet[indexPath.row]
        performFriendView(friendId: com.userId)
    }
    
}



class CommentCell: UITableViewCell{
    
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var nameLabel: NameLabel!
    @IBOutlet weak var timeLabel: TimeLable!
    @IBOutlet weak var statusLbl: StatusLabel!
    @IBOutlet weak var editBtn : UIButton!
    
    
    
    
    override func awakeFromNib() {
        
        self.selectionStyle = .none
        
        editBtn.isHidden = true
        
        let img = #imageLiteral(resourceName: "ellipsis2").withRenderingMode(.alwaysTemplate)
        editBtn.setImage(img, for: .normal)
        editBtn.tintColor = UIColor.BLACK_ALPHA
        
    }
    
    func configCell(comment : Like){
        
        profileView.updateViews(name: comment.name, url: comment.likeProfilePic, colorCode: comment.colorCode)
        
        nameLabel.text = comment.name
        
        timeLabel.text = comment.likeTimeStamp
            
        statusLbl.text = comment.comment
        
    }
    
}


class StatusLabel: UILabel{
    
    override func awakeFromNib() {
        
        self.font = Fonts.descriptionFont
        self.textColor = UIColor.BLACK_ALPHA
    }
    
}




// MARK :- KEYBOARD HANDLING

extension CommentVC{
    
    
    
    
    func keyboardObserver(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func removeKeyboardObserver(){
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = value.cgRectValue.height
        
        
        
        
        
        self.bottomConStraint.constant = keyboardHeight
        
        
        UIView.animate(withDuration: 0.1) {
            
            
            
            self.view.layoutIfNeeded()
            
            
            
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                
                let indexPath = IndexPath(row: self.commenet.count - 1, section: 0)
                
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                
            }
        }
        
        
    }
   @objc func keyboardWillHide(_ notification: Notification){
        
        
        self.bottomConStraint.constant = 0
        
        
        UIView.animate(withDuration: 0.1) {
            
            self.view.layoutIfNeeded()
        }
        
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

    
    static func storyBoardInstance() -> CommentVC? {
        let storyBoard = UIStoryboard(name: StoryBoard.COMMENT, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: CommentVC.id) as? CommentVC
    }
    
    
}

extension CommentVC: UITextViewDelegate{
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.toggleSendBtn()
    }
}








