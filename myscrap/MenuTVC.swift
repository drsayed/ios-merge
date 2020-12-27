//
//  MenuTVC.swift
//  myscrap
//
//  Created by MyScrap on 3/30/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import CoreData
import FacebookLogin
import FBSDKLoginKit
import XMPPFramework
import SDWebImage
import RealmSwift
import Firebase

class MenuTVC: UITableViewController {
    
    fileprivate var dataSource : [MenuItem] = [MenuItem]()
    var selectedIndex: Int?
    var subCellSelectedIndex: Int?
    var isComingFromBump : Bool = false
    var singleActBlock: (() -> Int)? = nil
    var doubleActBlock: (() -> Int)? = nil
    var cellHidden = true
    var tapCount = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reveal = self.revealViewController() {
            let vc = BaseRevealVC()
            vc.mBtn.target(forAction: #selector(reveal.rightRevealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if !AuthStatus.instance.isGuest{
            //updateMessageCount()
        }
        
        //tableView.reloadData()
        NotificationService.instance.getNotificationCount()
        getUserProfile()
        setupBadgeCountObservers()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        self.navigationController?.navigationBar.backgroundColor = .MyScrapGreen
        
        if #available(iOS 13.0, *) {
            let tag = 38482458385
            var statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.MyScrapGreen
            view.addSubview(statusbarView)
            if let statusBar = UIApplication.shared.keyWindow?.viewWithTag(tag) {
                statusbarView = statusBar
            } else {
                let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBar.tag = tag
                UIApplication.shared.keyWindow?.addSubview(statusBar)
                statusbarView = statusBar
            }
           
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.MyScrapGreen
        }
        
        /*if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.MyScrapGreen
        }
         */
        
        
//        //for table view border
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.reloadData()
//        //for rounded corners
//
//        //let containerView:UIView = UIView(frame: CGRect(x: tableView.x, y: tableView.y, width: tableView.width, height: tableView.height))
//        //containerView.backgroundColor = .clear
//        tableView.roundCorners([.topRight,.bottomRight], radius: 25)
        
        /* Commented on 24MAR2020 for status bar color issue in ios 13*/
        //tableView.clipsToBounds = true
        //tableView.layer.cornerRadius = 25
        //tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        /* Above three lines*/
        
//        tableView.layer.masksToBounds = true
        //tableView.addSubview(containerView)
        //containerView.addSubview(tableView)
        
        
        /*if appDelegate.isLandMenuSelected {
            subCellSelectedIndex = nil
            selectedIndex = 1
            tableView.reloadData()
        } else if appDelegate.isFeedMenuSelected {
            subCellSelectedIndex = nil
            selectedIndex = 2
            tableView.reloadData()
        } else if appDelegate.isMarketMenuSelected {
            subCellSelectedIndex = nil
            selectedIndex = 4
            tableView.reloadData()
        } else if appDelegate.isPricesMenuSelected {
            subCellSelectedIndex = nil
            selectedIndex = 3
            tableView.reloadData()
        } else if appDelegate.isChatMenuSelected {
            subCellSelectedIndex = 1
            selectedIndex = nil
            tableView.reloadData()
        } else if appDelegate.isDiscoverMenuSelected {
            subCellSelectedIndex = nil
            selectedIndex = 8
            tableView.reloadData()
        } else if appDelegate.isCompanyMenuSelected {
            subCellSelectedIndex = nil
            selectedIndex = 6
            tableView.reloadData()
        } else if appDelegate.isMembersMenuSelected {
            subCellSelectedIndex = nil
            selectedIndex = 5
            tableView.reloadData()
        } else if isComingFromBump {
            //selectedIndex = 5
            //Bump is not showing in menu
        } else if appDelegate.isAppLaunching{
            subCellSelectedIndex = nil
            selectedIndex = 1
            //tableView.reloadData()
        } else {
            print("menu tapped")
        }*/
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupBadgeCountObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(signedOut(_:)), name: .userSignedOut, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(notificationChanged(_:)), name: .messageCountChanged, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        //self.clearsSelectionOnViewWillAppear = false
        tableView.separatorColor = .clear
       setupRevealViewController()
        
        if isComingFromBump {
            //selectedIndex = 5
            //Bump is not showing in menu
        } else {
            subCellSelectedIndex = nil
            selectedIndex = 1
            //tableView.reloadData()
        }
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "SubMenuProfileCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCell")
        tableView.register(UINib(nibName: "SubMenuMessageCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageCell")
        tableView.register(UINib(nibName: "SubMenuAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "AccountCell")
        tableView.register(UINib(nibName: "SubMenuNotificationCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationCell")
        tableView.register(UINib(nibName: "SubMenuSignoutCell", bundle: Bundle.main), forCellReuseIdentifier: "SignoutCell")
    }

    private func setupRevealViewController() {
        //self.revealViewController()?.setNeedsStatusBarAppearanceUpdate()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        self.revealViewController()?.revealToggle(animated: false)
        
        self.revealViewController()?.frontViewShadowOffset = CGSize(width: 0, height: 2)
        //self.revealViewController()?.frontViewShadowOpacity = 0.0
        //self.revealViewController()?.frontViewShadowRadius = 10
        self.revealViewController().rearViewRevealOverdraw = 0
        self.revealViewController().bounceBackOnOverdraw = false
        self.revealViewController().stableDragOnOverdraw = true
        self.revealViewController()?.clipsViewsToBounds = true
        
//        self.revealViewController()?.rearViewController.view.backgroundColor = .blue
//        self.view.backgroundColor = .red
        
//        self.view.roundCorners([.bottomRight, .topRight], radius: 25)
//        self.revealViewController()?.frontViewController.view.roundCorners([.bottomRight, .topRight], radius: 25)
//        self.revealViewController()?.rearViewController.view.roundCorners([.bottomRight, .topRight], radius: 25)
    }
    
    private func selectAndReload(with indexPath: IndexPath){
        if indexPath.section == 1 {
            subCellSelectedIndex = indexPath.row
            selectedIndex = nil
            tableView.reloadData()
        } else {
            selectedIndex = indexPath.row
            subCellSelectedIndex = nil
            tableView.reloadData()
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else if section == 1 {
            return 5
        } else {
            //return 14
            return 13
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = MenuActionCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
          
            let strokeTextAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)
            ] as [NSAttributedString.Key  : Any]
            
            //Customising name label
            cell.nameLbl.layer.shadowColor = UIColor.black.cgColor
            cell.nameLbl.layer.shadowRadius = 2.0
            cell.nameLbl.layer.shadowOpacity = 0.8
            cell.nameLbl.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.nameLbl.layer.masksToBounds = false
            
            cell.nameLbl.attributedText = NSMutableAttributedString(string: AuthService.instance.fullName, attributes: strokeTextAttributes)
            
            //Customising Designation Label
            cell.desigLbl.layer.shadowColor = UIColor.black.cgColor
            cell.desigLbl.layer.shadowRadius = 2.0
            cell.desigLbl.layer.shadowOpacity = 0.8
            cell.desigLbl.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.desigLbl.layer.masksToBounds = false
            
            if AuthService.instance.designation != "" && AuthService.instance.company != "" {
                cell.desigLbl.attributedText = NSMutableAttributedString(string: AuthService.instance.designation.firstLetterUppercased() + " • " + AuthService.instance.company.firstLetterUppercased(), attributes: strokeTextAttributes)
            } else if AuthService.instance.designation == "" && AuthService.instance.company == "" {
                cell.desigLbl.attributedText = NSMutableAttributedString(string: "-", attributes: strokeTextAttributes)
            } else if AuthService.instance.designation == "" {
                cell.desigLbl.attributedText = NSMutableAttributedString(string: AuthService.instance.company.firstLetterUppercased(), attributes: strokeTextAttributes)
            } else {
                cell.desigLbl.attributedText = NSMutableAttributedString(string: AuthService.instance.designation.firstLetterUppercased(), attributes: strokeTextAttributes)
            }
            
            /*if AuthService.instance.logUserRank.contains("NoRank")  || AuthService.instance.logUserRank.contains("") {
                cell.scoreLbl.attributedText = NSMutableAttributedString(string: "", attributes: strokeTextAttributes)
            } else {
                cell.scoreLbl.attributedText = NSMutableAttributedString(string: AuthService.instance.logUserRank + " Score", attributes: strokeTextAttributes)
            }*/
            //Appending score values
//            cell.scoreLbl.attributedText = NSMutableAttributedString(string: "Score " +  AuthService.instance.logScore, attributes: strokeTextAttributes)
            var followerStr = "Followers"
              
            if AuthService.instance.followersPoints == 1 {
              followerStr = "Follower"
            }

            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: "Score " +  AuthService.instance.logScore, attributes: strokeTextAttributes))

            attributedString.append(NSAttributedString(string: String(format: " • %d %@", AuthService.instance.followersPoints, followerStr), attributes: strokeTextAttributes))

            cell.scoreLbl.attributedText = attributedString
            
            //Customising Score Label
            cell.scoreLbl.layer.shadowColor = UIColor.black.cgColor
            cell.scoreLbl.layer.shadowRadius = 2.0
            cell.scoreLbl.layer.shadowOpacity = 0.8
            cell.scoreLbl.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.scoreLbl.layer.masksToBounds = false
            
            /*if AuthService.instance.userRank == nil {
                cell.scoreLbl.text = "No Score"
            } else {
                cell.scoreLbl.text = AuthService.instance.userRank + " Score"
            }*/
            
            //Download Profile picture HD image try 1
            var downloadURL = URL(string:"")
//            guard let hdPic = AuthService.instance.bigProfilePic else {
//                downloadURL = URL(string: AuthService.instance.profilePic)
//                return
//            }
            let hdPic = AuthService.instance.bigProfilePic
            print("HD : \(hdPic) , profile : \(AuthService.instance.profilePic)")
            if hdPic == nil && AuthService.instance.profilePic != "https://myscrap.com/style/images/icons/no-profile-pic-female.png"{
                downloadURL = URL(string: AuthService.instance.profilePic)
            } else if hdPic != nil && AuthService.instance.profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png"{
                downloadURL = URL(string: hdPic!)
            } else if hdPic == "" && AuthService.instance.profilePic != "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                downloadURL = URL(string: AuthService.instance.profilePic)
            } else {
                downloadURL = URL(string: hdPic!)
            }
            
            
            SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
                if status{
                    /*SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                        cell.profileIV.image = image
                    })*/
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        if let error = error {
                            print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
                            cell.profileIV.sd_setImage(with: URL(string: AuthService.instance.profilePic), completed: nil)
                        } else {
                            
                            if downloadURL == nil{
                                cell.profileIV.image = #imageLiteral(resourceName: "default-profile-pic-png-5")
                            } else {
                                SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                                cell.profileIV.image = image
                            }
                            
                        }
                        
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        if let error = error {
                            print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
                            cell.profileIV.sd_setImage(with: URL(string: AuthService.instance.profilePic), completed: nil)
                        } else {
                            
                            if downloadURL == nil{
                                cell.profileIV.image = #imageLiteral(resourceName: "default-profile-pic-png-5")
                            } else {
                                SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                                cell.profileIV.image = image
                            }
                            
                        }
                        
                    })
                }
            }
            var readMsg_count : Int!
            //This function calls when tapping menu
            readMsg_count = try! Realm().objects(UserPrivChat.self).filter("readCount == 0").count
            if readMsg_count == 0 {
                cell.msgBadge.isHidden = true
            } else {
                cell.msgBadge.isHidden = false
                cell.msgBadge.text = String(readMsg_count)
            }
//            cell.profileIV.clipsToBounds = true
            
//             SDWebImageManager.shared().loadImage(with: downloadURL, options: .refreshCached, progress: nil, completed: { (image, _, error, _, _, _) in
//
//             })
//            cell.profileIV.contentMode = .scaleAspectFill
//            cell.profileIV.clipsToBounds = true
//            cell.profileIV.layer.cornerRadius = 25
//            cell.profileIV.layer.maskedCorners = [.layerMinXMaxYCorner]
//            cell.cView.roundCorners([.topRight], radius: 25)
//            cell.innerView.roundCorners([.topRight], radius: 25)
            
            let profileTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ProfileBtnTap(tapGesture:)))
            profileTap.numberOfTapsRequired = 1
            cell.profileIV.isUserInteractionEnabled = true
            cell.profileIV.tag = indexPath.row
            cell.profileIV.addGestureRecognizer(profileTap)
            
            
            let editBtnTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(editProfileTap(tapGesture:)))
            editBtnTap.numberOfTapsRequired = 1
            cell.editBtn.isUserInteractionEnabled = true
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addGestureRecognizer(editBtnTap)
            
            let homeImage : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(homeTap(tapGesture:)))
            homeImage.numberOfTapsRequired = 1
            cell.homeBtn.isUserInteractionEnabled = true
            cell.homeBtn.tag = indexPath.row
            cell.homeBtn.addGestureRecognizer(homeImage)
            
            let homeTitle : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(homeTap(tapGesture:)))
            homeTitle.numberOfTapsRequired = 1
            cell.homeLbl.isUserInteractionEnabled = true
            cell.homeLbl.tag = indexPath.row
            cell.homeLbl.addGestureRecognizer(homeTitle)
            
            let msgImage : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(msgTap(tapGesture:)))
            msgImage.numberOfTapsRequired = 1
            cell.msgBtn.isUserInteractionEnabled = true
            cell.msgBtn.tag = indexPath.row
            cell.msgBtn.addGestureRecognizer(msgImage)
            
            let msgTitle : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(msgTap(tapGesture:)))
            msgTitle.numberOfTapsRequired = 1
            cell.msgLbl.isUserInteractionEnabled = true
            cell.msgLbl.tag = indexPath.row
            cell.msgLbl.addGestureRecognizer(msgTitle)
            
            let notifImage : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(notifTap(tapGesture:)))
            notifImage.numberOfTapsRequired = 1
            cell.notifBtn.isUserInteractionEnabled = true
            cell.notifBtn.tag = indexPath.row
            cell.notifBtn.addGestureRecognizer(notifImage)
            
            let notifTitle : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(notifTap(tapGesture:)))
            notifTitle.numberOfTapsRequired = 1
            cell.notifLbl.isUserInteractionEnabled = true
            cell.notifLbl.tag = indexPath.row
            cell.notifLbl.addGestureRecognizer(notifTitle)
            
            let accountImage : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(singleTap(tapGesture:)))
            cell.accountBtn.isUserInteractionEnabled = true
            cell.accountBtn.tag = indexPath.row
            cell.accountBtn.addGestureRecognizer(accountImage)
            
            let accountTitle : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(singleTap(tapGesture:)))
            cell.accountLbl.isUserInteractionEnabled = true
            cell.accountLbl.tag = indexPath.row
            cell.accountLbl.addGestureRecognizer(accountTitle)
            
            let closeTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(closeBtnTap(tapGesture:)))
            closeTap.numberOfTapsRequired = 1
            cell.closeBtn.isUserInteractionEnabled = true
            cell.closeBtn.tag = indexPath.row
            cell.closeBtn.addGestureRecognizer(closeTap)
            
            
            // Configure the cell...
            
            return cell
        } else if indexPath.section == 1 {
            if cellHidden == true {
                if indexPath.item == 0 {
                    let cell: SubMenuProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! SubMenuProfileCell
                    
                    cell.isHidden = true
                    cell.cellSelected = subCellSelectedIndex == indexPath.item
                    return cell
                } else if indexPath.item == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! SubMenuMessageCell
                    
                    cell.isHidden = true
                    cell.cellSelected = subCellSelectedIndex == indexPath.item
                    return cell
                } else if indexPath.item == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! SubMenuAccountCell
                    
                    cell.isHidden = true
                    cell.cellSelected = subCellSelectedIndex == indexPath.item
                    return cell
                } else if indexPath.item == 3{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! SubMenuNotificationCell
                    
                    cell.isHidden = true
                    cell.cellSelected = subCellSelectedIndex == indexPath.item
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SignoutCell", for: indexPath) as! SubMenuSignoutCell
                    cell.isHidden = true
                    //cell.cellSelected = selectedIndex == indexPath.item
                    return cell
                }
            } else {
                if indexPath.item == 0 {
                    let cell: SubMenuProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! SubMenuProfileCell
                    cell.isHidden = false
                    cell.cellSelected = subCellSelectedIndex == indexPath.item
                    return cell
                } else if indexPath.item == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! SubMenuMessageCell
                    cell.isHidden = false
                    cell.cellSelected = subCellSelectedIndex == indexPath.item
                    return cell
                } else if indexPath.item == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! SubMenuAccountCell
                    cell.isHidden = false
                    cell.cellSelected = subCellSelectedIndex == indexPath.item
                    return cell
                } else if indexPath.item == 3{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! SubMenuNotificationCell
                    cell.isHidden = false
                    cell.cellSelected = subCellSelectedIndex == indexPath.item
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SignoutCell", for: indexPath) as! SubMenuSignoutCell
                    cell.isHidden = false
                    //cell.cellSelected = selectedIndex == indexPath.item
                    return cell
                }
            }
        }
        else {
            if indexPath.item == 0 {
                let cell = MenuHeaderCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                return cell
            } /*else if indexPath.item == 1 {
                //let cell = MenuFeedCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                let cell = MenuLandCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } */else if indexPath.item == 1 {
                let cell = MenuFeedCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 2 {
                let cell = MenuPricesCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 3 {
                let cell = MenuMarketCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 4 {
                let cell = MenuMembersCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 5 {
                let cell = MenuCompaniesCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 6 {
                let cell = MenuVisitorsCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 7 {
                let cell = MenuDiscoverCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            }
            /*else if indexPath.item == 8{
                let cell = MenuBumpedCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            }*/ else if indexPath.item == 8 {
                let cell = MenuCalendarCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 9 {
                let cell = MenuNearbyCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 10 {
                let cell = MenuInviteFriendCellTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 11 {
                if !AuthStatus.instance.isGuest{
                    print("Moderator find : \(AuthStatus.instance.isModeraor)")
                    if AuthStatus.instance.isModeraor{
                        let cell = MenuModeratorCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                        cell.cellSelected = selectedIndex == indexPath.item
                        return cell
                    } else {
                        return UITableViewCell()
                    }
                } else {
                    return UITableViewCell()
                }
            } else if indexPath.item == 12 {
                let cell = MenuAboutCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 418  //217   278
            
        } else if indexPath.section == 1 {
            if cellHidden == true {
                if indexPath.item == 0 {
                    return 0
                } else if indexPath.item == 1 {
                    return 0
                } else if indexPath.item == 2 {
                    return 0
                } else if indexPath.item == 3 {
                    return 0
                } else {
                    return  0
                }
            } else {
                if indexPath.item == 0 {
                    return 60
                } else if indexPath.item == 1 {
                    return 60
                } else if indexPath.item == 2{
                    return 60
                } else if indexPath.item == 3{
                    return 60
                } else {
                    return 60
                }
            }
        }
        else {
            if indexPath.item == 11 {           //Removed Bumped from menu changed from indexPath.item == 12 to 11
                if !AuthStatus.instance.isGuest{
                    print("Moderator find : \(AuthStatus.instance.isModeraor)")
                    if !AuthStatus.instance.isModeraor{
                        return 0
                    } else {
                        return 50
                    }
                } else {
                    return 0
                }
            } else {
                return 50
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.appDelegate.isAppLaunching = false
        self.appDelegate.isLandMenuSelected = false
        self.appDelegate.isFeedMenuSelected = false
        self.appDelegate.isMarketMenuSelected = false
        self.appDelegate.isPricesMenuSelected = false
        self.appDelegate.isChatMenuSelected = false
        self.appDelegate.isDiscoverMenuSelected = false
        self.appDelegate.isCompanyMenuSelected = false
        self.appDelegate.isMembersMenuSelected = false
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            if indexPath.item == 0 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                }else {
                    
                    selectAndReload(with: indexPath)
                    self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: ProfileVC.id, checkisGuest: AuthStatus.instance.isGuest)
                    //self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: EditProfileController.id, checkisGuest: AuthStatus.instance.isGuest)
                }
            } else if indexPath.item == 1 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                }else {
                    selectAndReload(with: indexPath)
                    //let vc = UINavigationController(rootViewController: ChatVC())
                    //present(vc, animated: true, completion: nil)
                    NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                    self.pushViewController(storyBoard: StoryBoard.CHAT, Identifier: ChatVC.id, checkisGuest: AuthStatus.instance.isGuest)
                }
            } else if indexPath.item == 2 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                }else {
                    selectAndReload(with: indexPath)
                    self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: EditProfileController.id, checkisGuest: AuthStatus.instance.isGuest)
                }
            } else if indexPath.item == 3 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                } else {
                    selectAndReload(with: indexPath)
                    NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                    presentViewController(isGuest: AuthStatus.instance.isGuest, storyBoard: StoryBoard.MAIN, identifier: NotificationVC.id)
                }
            } else {
               self.performLogOut()
            }
        }
        else {
             /*if indexPath.item == 1 {
                selectAndReload(with: indexPath)
                //pushViewController(storyBoard: StoryBoard.MAIN, Identifier: FeedsVC.id)
                pushViewController(storyBoard: StoryBoard.LAND, Identifier: LandHomePageVC.id)
             } else */if indexPath.item == 1 {
                selectAndReload(with: indexPath)
                pushViewController(storyBoard: StoryBoard.MAIN, Identifier: FeedsVC.id)
             } else if indexPath.item == 2 {
                selectAndReload(with: indexPath)
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

              pushViewController(storyBoard: StoryBoard.MAIN, Identifier: PricesTabVC.id)
             //   pushViewController(storyBoard: StoryBoard.MAIN, Identifier: PricesUpdatedVCOld.id)
            } else if indexPath.item == 3 {
                selectAndReload(with: indexPath)
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)
            } else if indexPath.item == 4 {
                selectAndReload(with: indexPath)
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                pushViewController(storyBoard: StoryBoard.MAIN, Identifier: MembersVC.id)
            } else if indexPath.item == 5 {
                selectAndReload(with: indexPath)
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                pushViewController(storyBoard: StoryBoard.COMPANIES, Identifier: CompaniesVC.id)
                //pushViewController(storyBoard: StoryBoard.COMPANIES, Identifier: CompanyDetailedTVC.id)
            } else if indexPath.item == 6 {
                selectAndReload(with: indexPath)
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                pushViewController(storyBoard: StoryBoard.MAIN, Identifier: VisitorsVC.id, checkisGuest: AuthStatus.instance.isGuest)
            } else if indexPath.item == 7 {
                selectAndReload(with: indexPath)
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                pushViewController(storyBoard: StoryBoard.MAIN, Identifier: DiscoverVC.id)
            }
            /*else if indexPath.item == 8 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                } else {
                    selectAndReload(with: indexPath)
                    let vc = BumpedVC()
                    vc.title = MenuName.bump.rawValue
                    let nav = UINavigationController(rootViewController: vc)
                    revealViewController().pushFrontViewController(nav, animated: true)
                }
            }*/
             else if indexPath.item == 8 {
                selectAndReload(with: indexPath)
                let vc = CalendarVC()
                vc.title = MenuName.calendar.rawValue
                let nav = UINavigationController(rootViewController: vc)
                revealViewController().pushFrontViewController(nav, animated: true)
             } else if indexPath.item == 9 {
                selectAndReload(with: indexPath)
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                pushViewController(storyBoard: StoryBoard.MAIN, Identifier: PeopleVc.id,checkisGuest: AuthStatus.instance.isGuest)
             } else if indexPath.item == 10 {
                inviteFriends()
             } else if indexPath.item == 11 {
                //Moderator
                selectAndReload(with: indexPath)
                let vc = ReportedVC()
                vc.title = MenuName.report.rawValue
                let nav = UINavigationController(rootViewController: vc)
                
                revealViewController().pushFrontViewController(nav, animated: true)
             } else if indexPath.item == 12 {
                selectAndReload(with: indexPath)
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                pushViewController(storyBoard: StoryBoard.ABOUT, Identifier: AboutMyscrapVC.id)
             } else {
                print("nothing to tap in menu")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    @objc func editProfileTap(tapGesture:UITapGestureRecognizer) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        }else {
            self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: EditProfileController.id, checkisGuest: AuthStatus.instance.isGuest)
        }
    }
    @objc func ProfileBtnTap(tapGesture:UITapGestureRecognizer) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        }else {
            self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: ProfileVC.id, checkisGuest: AuthStatus.instance.isGuest)
        }
    }
    @objc func homeTap(tapGesture:UITapGestureRecognizer) {
        print("Home tapped")
       pushViewController(storyBoard: StoryBoard.MAIN, Identifier: FeedsVC.id)
        //pushViewController(storyBoard: StoryBoard.LAND, Identifier: LandHomePageVC.id)
        //pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)
        //performDetailVC(indexPath: tapGesture.view!.tag)
    }
    
    @objc func msgTap(tapGesture:UITapGestureRecognizer) {
        print("Message tapped")
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        }else {
            if AuthStatus.instance.isGuest{
                self.showGuestAlert()
            } else {
                //let vc = UINavigationController(rootViewController: ChatVC())
                //present(vc, animated: true, completion: nil)
                self.pushViewController(storyBoard: StoryBoard.CHAT, Identifier: ChatVC.id, checkisGuest: AuthStatus.instance.isGuest)
            }
            
        }
        //performDetailVC(indexPath: tapGesture.view!.tag)
    }
    
    @objc func notifTap(tapGesture:UITapGestureRecognizer) {
        print("Notication tapped")
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            presentViewController(isGuest: AuthStatus.instance.isGuest, storyBoard: StoryBoard.MAIN, identifier: NotificationVC.id)
        }
        //performDetailVC(indexPath: tapGesture.view!.tag)
    }
    
    @objc func accountTap(tapGesture:UITapGestureRecognizer) {
        print("Account tapped")
        let vc = SubMenuTVC()
        let rearViewController = MenuTVC()
        //let frontNavigationController = UINavigationController(rootViewController: vc)
        let mainRevealController = SWRevealViewController()
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = vc
        UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        //performDetailVC(indexPath: tapGesture.view!.tag)
        
    }
    
    @objc func singleTap(tapGesture:UITapGestureRecognizer) {
        if tapCount == 0 {
            cellHidden = false
            tapCount = 1
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            self.tableView.layoutIfNeeded()
            /*DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                //self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.height), animated: false)
            }*/
            
        } else {
            tapCount = 0
            cellHidden = true
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            self.tableView.layoutIfNeeded()
            /*DispatchQueue.main.async {
                //self.tableView.reloadData()
                
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.height), animated: false)
            }*/
        }
    }
    
    @objc func doubleTap(tapGesture:UITapGestureRecognizer) {
        cellHidden = true
        tableView.reloadData()
        //_ = doubleActBlock?()
        //tableView.reloadSections(IndexSet(integer: 1), with: .bottom)
    }
    
    @objc func closeBtnTap(tapGesture:UITapGestureRecognizer) {
        print("close tapped")
        //pushViewController(storyBoard: StoryBoard.LAND, Identifier: LandHomePageVC.id)
        pushViewController(storyBoard: StoryBoard.MAIN, Identifier: FeedsVC.id)
        //pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    //MARK:- Invite Friends
    fileprivate func inviteFriends(){
        let activityVC = UIActivityViewController(activityItems: ["MyScrap is an application which helps leveraging your business and linking your profile to active users.\n\nMyScrap empowers users to strengthen recycling business all over the world to outreach effectively that has direct benefits building comprehensive marketing strategy as per clients business need.\n\nMyscrap is accessible, reliable and easy to download in iOS & Android through internet connections without any hassle.\n\nPlay Store:  https://play.google.com/store/apps/details?id=com.myscrap .\n\nApp Store: https://itunes.apple.com/ae/app/myscrap/id1233167019?mt=8 .\n\nGet it now from https://myscrap.com/login"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        //        activityVC.popoverPresentationController?.sourceView?.tintColor = Colors.GREEN_PRIMARY
        
        self.present(activityVC, animated: true, completion: nil)
        
        //API Call for app link to increase the Score levels
        shareAppPoints()
        
    }
    
    func shareAppPoints() {
        let api = APIService()
        api.endPoint = Endpoints.APP_LINK_SHARE
        api.params = "userId=\(AuthService.instance.userId))&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let json):
                print("Success")
                if let error = json["error"] as? Bool {
                    if !error {
                        let status = json["status"] as? String
                        if  status == "Point added succesfully." {
                            print(" Share app \(status )")
                        }
                    }
                }
            case .Error(let error):
                print("Error :- \(error)")
            }
        }
    }
    
    fileprivate func performLogOut(){
        let alert = UIAlertController(title: "", message: "Are you sure to Log out?", preferredStyle: .alert)
        let logout = UIAlertAction(title: "Logout", style: .destructive) { (
            action) in
            //perform logout
            if let window = UIApplication.shared.keyWindow {
                
                
                let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
                overlay.alpha = 0.5
                overlay.backgroundColor = UIColor.black
                window.addSubview(overlay)
                
                
                let av = UIActivityIndicatorView(style: .whiteLarge)
                av.center = overlay.center
                av.startAnimating()
                overlay.addSubview(av)
                
                
                AuthService.instance.logoutUser({ (loggedOut) in
                    print("If Logout success ",loggedOut)
                    
                    if loggedOut{
                        DispatchQueue.main.async {
                            let loginManager = FBSDKLoginManager()                              //Maha manually logout from fb
                            loginManager.logOut() // this is an instance function
                            //AuthService.instance.removeRegistrationDetails(profilePic: UserDefaults.PROFILE_PIC,loggedOut: true)
                            XMPPService.instance.disconnect()
                            XMPPService.instance.offline()
                            XMPPService.instance.connectEst = false
                            //Making fcm token to "" while logging off
                            NotificationService.instance.apnToken = ""
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.fireBaseConfig = false
                            av.stopAnimating()
                            overlay.removeFromSuperview()
                            NotificationCenter.default.post(name: .userSignedOut, object: nil)
                        }
                    } else {
                        
                        /*XMPPService.instance.offline()
                        XMPPService.instance.disconnect()
                        NotificationService.instance.apnToken = ""
                        av.stopAnimating()
                        overlay.removeFromSuperview()
                        NotificationCenter.default.post(name: .userSignedOut, object: nil)*/
                        DispatchQueue.main.async {
                            av.stopAnimating()
                            let alertVC = UIAlertController(title: "OOPS",message: "Server error, Failed to Logout. Try again.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC,animated: true,completion: nil)
                            print("Should not get logged out from api")
                        }
                        
                    }
                })
            }
            
            // TODO:- ACTIVITY INDICATOR
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logout)
        alert.addAction(cancel)
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func signedOut(_ notification: Notification){
        AuthStatus.instance.isLoggedIn = false
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate , let window = delegate.window , let signInController = SignInViewController.storyBoardInstance() {
            window.rootViewController = signInController
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .notificationCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .bumpCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .visitorsCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userSignedOut, object: nil)
        NotificationCenter.default.removeObserver(self, name: .moderatorChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .profileCountChanged, object: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- Push View Controller
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        guard !checkisGuest else {
            self.showGuestAlert(); return
        }
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let nav = UINavigationController(rootViewController: vc)
        self.revealViewController()?.navigationController?.popViewController(animated: false)
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    //MARK:- Present View Controller
    private func presentViewController(isGuest:Bool, storyBoard: String, identifier: String){
        guard !isGuest else { self.showGuestAlert(); return }
        let vc = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier : identifier)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        self.revealViewController().present(nav, animated: true, completion: nil)
    }
    
    //API Call to update score in Menu
    func getUserProfile(){
        let service = APIService()
        service.endPoint = Endpoints.GET_USER_PROFILE
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        print("PARAMS : \(service.params)")
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                DispatchQueue.main.async {
                    if let error = dict["error"] as? Bool{
                        
                        print("Value of dict in own user data",dict)
                        if !error{
                            if let userData = dict["userData"] as? [String: AnyObject] {
                                if let points = userData["points"] as? String {
                                    
                                    if let uid = userData["userId"] as? String{
                                                   AuthService.instance.userId = uid
                                               }
                                               if let fname = userData["firstName"] as? String{
                                                   AuthService.instance.firstname = fname
                                               }
                                               if let lname = userData["lastName"] as? String{
                                                   AuthService.instance.lastName = lname
                                               }
                                               if let mobile = userData["mobile"] as? String {
                                                   AuthService.instance.mobile = mobile
                                               }
                                               if let email = userData["email"] as? String{
                                                   AuthService.instance.email = email
                                               }
                                               if let pwd = userData["password"] as? String{
                                                   AuthService.instance.password = pwd
                                               }
                                               if let pro = userData["profilePic"] as? String{
                                                   AuthService.instance.profilePic = pro
                                               }
                                               if let bigPro = userData["bigProfilePic"] as? String{
                                                   AuthService.instance.bigProfilePic = bigPro
                                               }
                                               if let color = userData["colorCode"] as? String{
                                                   AuthService.instance.colorCode = color
                                               }
                                               if let jId = userData["jId"] as? String{
                                                   AuthService.instance.userJID = jId
                                               }
                                               if let userRank = userData["userRank"] as? String{
                                                   AuthService.instance.userRank = userRank
                                               }
                                               if let company = userData["company"] as? String{
                                                   AuthService.instance.company = company
                                               }
                                               if let companyID = userData["companyId"] as? String{
                                                 AuthService.instance.companyId = companyID
                                               }
                                               if let designation = userData["designation"] as? String{
                                                   AuthService.instance.designation = designation
                                               }
                                               if let points = userData["points"] as? String {
                                                   AuthService.instance.logScore = points
                                               }
                                    if let countryId = userData["countryId"] as? String{
                                             AuthService.instance.companyCountryID = countryId
                                            }
                                    
                                    let followersCount = JSONUtils.GetIntFromObject(object: userData, key: "followercount")
                                    AuthService.instance.followersPoints = followersCount

                                }
                                // Remains values not fetched here (REFER POSTMAN for actual response)
                            }
                        }
                    }
                }
            case .Error(_):
                print("Error in getting notification Count")
            }
        }
    }

}
