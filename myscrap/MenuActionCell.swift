//
//  MenuActionCell.swift
//  myscrap
//
//  Created by MyScrap on 3/30/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import RealmSwift

class MenuActionCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var desigLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var notifLbl: UILabel!
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var editBtn: CircularButton!
    
    
    
    @IBOutlet weak var msgBadge: UILabel!
    @IBOutlet weak var notifBadge: UILabel!
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var notifBtn: UIButton!
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var cView: UIView!
    @IBOutlet weak var innerView: UIView!
    
    var readMsg_count : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(msgCount(notif:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        //readCount()
        homeBtn.tintColor = .white
        homeBtn.layer.cornerRadius = 20
        homeBtn.clipsToBounds = true
        homeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        homeBtn.setTitle(String.fontAwesomeIcon(name: .home), for: .normal)
        
        msgBtn.tintColor = .white
        msgBtn.layer.cornerRadius = 20
        msgBtn.clipsToBounds = true
        msgBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        msgBtn.setTitle(String.fontAwesomeIcon(name: .envelope), for: .normal)
        
        notifBtn.tintColor = .white
        notifBtn.layer.cornerRadius = 20
        notifBtn.clipsToBounds = true
        notifBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        notifBtn.setTitle(String.fontAwesomeIcon(name: .bell), for: .normal)
        
        accountBtn.tintColor = .white
        accountBtn.layer.cornerRadius = 20
        accountBtn.clipsToBounds = true
        accountBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        accountBtn.setTitle(String.fontAwesomeIcon(name: .user), for: .normal)
        
        
//        closeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
//        closeBtn.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        
        msgBadge.layer.cornerRadius = 4
        msgBadge.layer.masksToBounds = true
        msgBadge.isHidden = true
        
        notifBadge.layer.cornerRadius = 4
        notifBadge.layer.masksToBounds = true
        notifBadge.isHidden = true
        
        //let closeImage = UIImage(named: "closeButton");
        //let tintCloseImage = closeImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        //closeBtn.setImage(tintCloseImage, for: .normal)
        //closeBtn.tintColor = UIColor(hexString: "#42000000")
        //closeBtn.tintColor = UIColor.white
        //closeBtn.backgroundColor = UIColor(hexString: "#42000000")
        
        let origImage = UIImage(named: "editphoto");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        editBtn.setImage(tintedImage, for: .normal)
        editBtn.tintColor = UIColor.MyScrapGreen
        //editBtn.layer.borderColor = UIColor.darkGray.cgColor
        //editBtn.layer.borderWidth = 0.3
        
//        settingBtn.tintColor = UIColor(hexString: "#3f3f3f")
        
        setupBadgeCountObservers()
        
        /*nameLbl.layer.shadowColor = UIColor.black.cgColor
        nameLbl.layer.shadowRadius = 3.0
        nameLbl.layer.shadowOpacity = 1.0
        nameLbl.layer.shadowOffset = CGSize(width: 4, height: 4)
        nameLbl.layer.masksToBounds = false
        
        desigLbl.layer.shadowColor = UIColor.black.cgColor
        desigLbl.layer.shadowRadius = 3.0
        desigLbl.layer.shadowOpacity = 1.0
        desigLbl.layer.shadowOffset = CGSize(width: 4, height: 4)
        desigLbl.layer.masksToBounds = false
        
        scoreLbl.layer.shadowColor = UIColor.black.cgColor
        scoreLbl.layer.shadowRadius = 3.0
        scoreLbl.layer.shadowOpacity = 1.0
        scoreLbl.layer.shadowOffset = CGSize(width: 4, height: 4)
        scoreLbl.layer.masksToBounds = false*/
    }
    
    private func setupBadgeCountObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(notificationChanged(_:)), name: .notificationCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationChanged(_:)), name: .messageCountChanged, object: nil)
    }
    
    func readCount() {
        //This function calls when tapping menu
        readMsg_count = try! Realm().objects(UserPrivChat.self).filter("readCount == 0").count
        if readMsg_count == 0 {
            msgBadge.isHidden = true
        } else {
            msgBadge.isHidden = false
            msgBadge.text = String(readMsg_count)
        }
    }
    
    @objc func msgCount(notif: Notification){
        readMsg_count = try! Realm().objects(UserPrivChat.self).filter("readCount == 0").count
        if readMsg_count == 0 {
            msgBadge.isHidden = true
        } else {
            msgBadge.isHidden = false
            msgBadge.text = String(readMsg_count)
        }
    }
    @objc func msgCountUpdate(){
        readMsg_count = try! Realm().objects(UserPrivChat.self).filter("readCount == 0").count
        if readMsg_count == 0 {
            msgBadge.isHidden = true
        } else {
            msgBadge.isHidden = false
            msgBadge.text = String(readMsg_count)
        }
    }
    @objc private func notificationChanged(_ notification: Notification){
        
        let notifCount = NotificationService.instance.notificationCount!
        
        if notifCount == 0 {
            notifBadge.isHidden = true
        } else {
            notifBadge.isHidden = false
            notifBadge.text =  "\(notifCount)"
        }
        /*let msgCount = NotificationService.instance.messageCount!
        if msgCount == 0 {
            msgBadge.isHidden = true
        } else {
            msgBadge.isHidden = false
            msgBadge.text = "\(msgCount)"
        }*/
        
        print("Notification Count : \(String(describing: NotificationService.instance.messageCount))")
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .notificationCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageCountChanged, object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuActionCell {
        let id = "MenuActionCell"
        tableView.register(UINib(nibName: "MenuActionCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuActionCell
        return cell
    }

    @IBAction func closeBtnTapped(_ sender: UIButton) {
        
    }
}
