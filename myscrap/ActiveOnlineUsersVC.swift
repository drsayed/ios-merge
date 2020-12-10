//
//  ActiveOnlineUsersVC.swift
//  myscrap
//
//  Created by MyScrap on 5/22/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class ActiveOnlineUsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FriendControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var activeDataSource = [ActiveUsers]()
    let service = ChatService()
    
    let spinner: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        tableView.isHidden = true
        // Do any additional setup after loading the view.
        setupSpinner()
        setupTableView()
        getActiveUsers()
    }
    
    @objc func runTimedCode() {
        getActiveUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.title = "Active Users"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // needed to clear the text in the back navigation:
        self.navigationItem.title = " "
        timer.invalidate()
    }
    
    func getActiveUsers() {
        service.delegate = self
        service.activeUsers()
    }
    
    func setupSpinner() {
        self.view.addSubview(spinner)
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActiveUsersCell.nib, forCellReuseIdentifier: "ActiveUsersCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ActiveUsersCell = tableView.dequeueReusableCell(withIdentifier: "ActiveUsersCell", for: indexPath) as! ActiveUsersCell
        let row = activeDataSource[indexPath.row]
        cell.initialLbl.text = row.name?.initials()
        cell.profileView.backgroundColor = UIColor(hexString: row.colorCode!)
        if row.profilePic != "" {
            cell.profileImage.isHidden = false
            cell.profileImage.sd_setImage(with: URL(string: row.profilePic!), completed: nil)
        } else {
            cell.profileImage.isHidden = true
        }
        if row.online == true {
            cell.onlineView.isHidden = false
        } else {
            cell.onlineView.isHidden = true
        }
        cell.nameLbl.text = row.name
        cell.designationLbl.text = row.designation
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let row = activeDataSource[indexPath.row]
        let friendId = row.userid
        let name = row.name ?? ""
        let colorcode = row.colorCode ?? ""
        let profileImg = row.profilePic ?? ""
        let jId = row.jId
        
        performConversationVC(friendId: friendId!, profileName: name, colorCode: colorcode, profileImage: profileImg, jid: jId!, listingId: "", listingTitle: "", listingType: "", listingImg: "")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    static func storyBoardInstance() -> ActiveOnlineUsersVC? {
        return UIStoryboard.chat.instantiateViewController(withIdentifier: ActiveOnlineUsersVC.id) as? ActiveOnlineUsersVC
    }

}
extension ActiveOnlineUsersVC : ChatServiceDelegate {
    func DidReceivedData(data: [ActiveUsers]) {
        DispatchQueue.main.async {
            if self.spinner.isAnimating == true {
                self.spinner.stopAnimating()
                self.tableView.isHidden = false
            }
            self.activeDataSource = data
            self.tableView.reloadData()
            
            
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error in online users fetch: \(error)")
    }
}
