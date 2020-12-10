//
//  AboutMyscrapVC.swift
//  myscrap
//
//  Created by MS1 on 7/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI
import UserNotifications

class AboutMyscrapVC: BaseRevealVC {
    
    @IBOutlet weak var tableView: UITableView!
    var isNotificationOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            let authStatus = settings.authorizationStatus
            if(authStatus != .authorized)
            {
                self.isNotificationOn = false
            } else {
                self.isNotificationOn = true
            }
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}


extension AboutMyscrapVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AboutMyScrapCell
            switch indexPath.row {
            case 0:
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    cell.titleHeader.text = "Version \(version)"
                }
            case 2:
                cell.titleHeader.text = "Tips"
            case 3:
                cell.titleHeader.text = "General Information"
            case 4:
                cell.titleHeader.text = "Privacy & Policy"
            case 5:
                cell.titleHeader.text = "Terms & Conditions"
            case 6:
                cell.titleHeader.text = "Contact Us"
                cell.sepView.isHidden = true
            case 7:
                cell.titleHeader.text = "  sales@myscrap.com"
                cell.titleHeader.textColor = UIColor.MyScrapGreen
                cell.sepView.isHidden = true
            case 8:
                cell.titleHeader.textColor = UIColor.MyScrapGreen
                cell.titleHeader.text = "  support@myscrap.com"
            default:
                //cell.titleHeader.text = "Will not trigger"
                print("Row 2 will be notification")
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notifCell", for: indexPath) as! AboutNotificationCell
            cell.notificationSwitch.isOn = isNotificationEnabled()
            cell.notifBtnAction = {
                let alertController = UIAlertController(title: nil, message: "Do you want to change notifications settings?", preferredStyle: .alert)
                
                let action1 = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction) in
                    if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
                        
                    }
                }
                
                let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                    tableView.reloadData()
                }
                
                alertController.addAction(action1)
                alertController.addAction(action2)
                self.present(alertController, animated: true, completion: nil)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("do nothing")
        case 2:
            performSegue(withIdentifier: Segues.Tips, sender: self)
        case 3:
            performSegue(withIdentifier: Segues.GeneralInformation, sender: self)
            print("privacy")
        case 4:
            performSegue(withIdentifier: Segues.PrivacyPolicy, sender: self)
        case 5:
            performSegue(withIdentifier: Segues.TermsAndCondition, sender: self)
        case 6:
            print("Nothing happen")
        case 7:
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["sales@myscrap.com"])
                present(mail, animated: true, completion: nil)
            }
            else {
                showToast(message: "Can't connect through email, please sign in to Mail")
            }
        case 8:
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["support@myscrap.com"])
                present(mail, animated: true, completion: nil)
            }
            else {
                showToast(message: "Can't connect through email, please sign in to Mail")
            }
        default:
            print("will not trigger")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func isNotificationEnabled() -> Bool{
        if isNotificationOn {
            return true
        } else {
            return false
        }

    }
}


class AboutMyScrapCell: UITableViewCell{
    @IBOutlet weak var titleHeader: AboutLabel!
    @IBOutlet weak var sepView: SeperatorView!
    let seperatorView : UIView = {
        let sepView = UIView()
        sepView.translatesAutoresizingMaskIntoConstraints = false
        //sepView.backgroundColor = UIColor.lightGray
        sepView.backgroundColor = UIColor(hexString: "#D3D3D3")
        return sepView
    }()
    
    override func awakeFromNib() {
        //setupView()
    }
    
    func setupView() {
        addSubview(seperatorView)
        
        seperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        seperatorView.height = 1
    }
}
class AboutNotificationCell: UITableViewCell {
    @IBOutlet weak var notificationSwitch: UISwitch!
    var notifBtnAction: (() -> Void)?
    
    override func awakeFromNib() {
        //setupView()
    }
    
    @IBAction func notifSwitchTapped(_ sender: UISwitch) {
        notifBtnAction?()
    }
    
}
