//
//  EmailInboxVC.swift
//  myscrap
//
//  Created by MyScrap on 1/29/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class EmailInboxVC: BaseRevealVC {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [EmailInboxLists]()
    var mailDataSource = [MailData]()
    let service = EmailService()
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var refreshControll : UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        service.eDelegate = self
        service.getEmailLists()
        
        setupTableView()
        
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Email"
        tableView.reloadData()
        //fetchItems()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControll)
        tableView.refreshControl = refreshControll
        tableView.tableFooterView = UIView()
    }
    
    @objc
    func handleRefresh(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        fetchItems()
    }
    
    func fetchItems(){
        service.getEmailLists()
    }

}
extension EmailInboxVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource[section]._opened == true {
            return dataSource[section].mailData.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! EmailInboxSectionCell
            cell.sectionTitle.text = dataSource[indexPath.section].product + " - (" + dataSource[indexPath.section].quantity + " " + dataSource[indexPath.section].unit + ")"
            let origImage = #imageLiteral(resourceName: "ic_filter_list")
            let tintedImage = origImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.openImageView.image = tintedImage
            cell.openImageView.tintColor = UIColor.white
            
            return cell
        } else {
            let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor.black]
            let attributedString2 = NSMutableAttributedString(string: "Inbox", attributes:attrs2)
            let attrs3 = [NSAttributedString.Key.foregroundColor : UIColor.MyScrapGreen]
            let attributedString3 = NSMutableAttributedString(string: " (\(dataSource[indexPath.section].mailData.count))", attributes:attrs3)
            attributedString2.append(attributedString3)
            
            self.titleLbl.attributedText = attributedString2
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailInboxCell", for: indexPath) as! EmailInboxCell
            let emailLists = dataSource[indexPath.section].mailData[indexPath.row - 1]
            cell.userLbl.text = "Anonymous"
            cell.dateLbl.text = emailLists.dateSent
            cell.subjectLbl.textColor = .lightGray
            cell.subjectLbl.text = emailLists.subject
            cell.msgPreviewLbl.textColor = .lightGray
            cell.msgPreviewLbl.text = emailLists.message
            cell.msgPreviewLbl.text = emailLists.message
            
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if dataSource[indexPath.section]._opened == true {
                dataSource[indexPath.section]._opened = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .none)
            } else {
                dataSource[indexPath.section]._opened = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .none)
            }
        } else {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewMailVC") as! ViewMailVC
            controller.listing_id = dataSource[indexPath.section].listingId
            controller.user_id = dataSource[indexPath.section].mailData[indexPath.row - 1].userId
            let initial = dataSource[indexPath.section].product.initials()
            controller.initial = initial
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 88
        }
        
    }
    
    
}
extension EmailInboxVC : EmailServiceDelegate {
    func DidReceiveViewMail(data: [ViewMailLists]) {
        print("Will not happen view detail mail")
    }
    
    
    func DidReceiveMailData(data: [MailData]) {
        DispatchQueue.main.async {
            print("Data in Did receive email : \(data.count)")
            self.mailDataSource = data
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
            }
            self.tableView.reloadData()
            
            
        }
    }
    func DidSentMail(data: String) {
        print("This will not work here")
    }
    
    func DidReceivedData(array : [EmailInboxLists]) {
        DispatchQueue.main.async {
            print("Data in Did receive : \(array.count)")
            self.dataSource = array
            self.tableView.reloadData()
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func DidReceivedError(error: String) {
        showMessage(with: error)
    }
}

extension EmailInboxVC : EmailDelegate {
    var mailDS: [EmailInboxLists] {
        get {
            return dataSource
        }
        set {
            dataSource = newValue
        }
    }
}

protocol EmailDelegate : class {
    
    var service : EmailService { get }
    var mailDS: [EmailInboxLists] { get set }
}
