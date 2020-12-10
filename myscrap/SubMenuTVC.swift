//
//  SubMenuTVC.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import CoreData
import FacebookLogin
import FBSDKLoginKit
import XMPPFramework

class SubMenuTVC: UITableViewController {

    var selectedIndex: Int?
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        tableView.separatorColor = .clear
        setupObservers()
    }
    
    private func setupRevealViewController(){
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        self.revealViewController().rearViewRevealOverdraw = 0
        self.revealViewController().bounceBackOnOverdraw = false
        self.revealViewController().stableDragOnOverdraw = true
    }
    
    private func selectAndReload(with indexPath: IndexPath){
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SubMenuTVC.signedOut(_:)), name: .userSignedOut, object: nil)
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
        } else if section == 1{
            return 5
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = SubMenuTopCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.nameLbl.text = AuthService.instance.fullName
            cell.emailLbl.text = AuthService.instance.email
            
            let closeTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(closeBtnTap(tapGesture:)))
            closeTap.numberOfTapsRequired = 1
            cell.closeBtn.isUserInteractionEnabled = true
            cell.closeBtn.tag = indexPath.row
            cell.closeBtn.addGestureRecognizer(closeTap)
            
            return cell
        } else if indexPath.section == 1{
            if indexPath.item == 0 {
                let cell = SubMenuHeaderCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                //cell.backMenuLbl.text = "< BACK TO MAIN MENU"
                return cell
            } else if indexPath.item == 1 {
                let cell = SubMenuProfileCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 2 {
                let cell = SubMenuMessageCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 3{
                let cell = SubMenuAccountCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else if indexPath.item == 4{
                let cell = SubMenuNotificationCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.cellSelected = selectedIndex == indexPath.item
                return cell
            } else {
              return UITableViewCell()
            }
        } else {
            let cell = SubMenuSignoutCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 122
        } else if indexPath.section == 1 {
            if indexPath.item == 0 {
                return 50
            } else if indexPath.item == 4 {
                return 72
            } else {
                return 60
            }
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
        } else if indexPath.section == 1 {
            if indexPath.item == 0 {
                let vc = MenuTVC()
                revealViewController().pushFrontViewController(vc, animated: true)
                
            } else if indexPath.item == 1 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                }else {
                    self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: EditProfileController.id, checkisGuest: AuthStatus.instance.isGuest)
                }
            } else if indexPath.item == 2 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                }else {
                    if AuthStatus.instance.isGuest{
                        self.showGuestAlert()
                    } else {
                        let vc = UINavigationController(rootViewController: ChatVC())
                        present(vc, animated: true, completion: nil)
                    }
                    
                }
            } else if indexPath.item == 3 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                }else {
                    self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: ProfileVC.id, checkisGuest: AuthStatus.instance.isGuest)
                }
            } else if indexPath.item == 4 {
                if AuthStatus.instance.isGuest{
                    showGuestAlert()
                } else {
                    presentViewController(isGuest: AuthStatus.instance.isGuest, storyBoard: StoryBoard.MAIN, identifier: NotificationVC.id)
                }
            }
        } else {
            self.performLogOut()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else if section == 1 {
             return 10
        } else {
            return 10
        }
    }
    
    @objc func closeBtnTap(tapGesture:UITapGestureRecognizer) {
        print("close tapped")
        
        pushViewController(storyBoard: StoryBoard.MAIN, Identifier: FeedsVC.id)
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        guard !checkisGuest else {
            self.showGuestAlert(); return
        }
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let nav = UINavigationController(rootViewController: vc)
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    //MARK:- Present View Controller
    private func presentViewController(isGuest:Bool, storyBoard: String, identifier: String){
        guard !isGuest else { self.showGuestAlert(); return }
        let vc = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier : identifier)
        let nav = UINavigationController(rootViewController: vc)
        self.revealViewController().present(nav, animated: true, completion: nil)
    }
    
    private func setRootViewController(_ viewController: UIViewController){
        window?.rootViewController = viewController
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
                    if loggedOut{
                        let loginManager = FBSDKLoginManager()                              //Maha manually logout from fb
                        loginManager.logOut() // this is an instance function
                        NotificationCenter.default.post(name: .userSignedOut, object: nil)
                        //AuthService.instance.removeRegistrationDetails(profilePic: UserDefaults.PROFILE_PIC,loggedOut: true)
                        XMPPService.instance.disconnect()
                        XMPPService.instance.offline()
                        av.stopAnimating()
                        overlay.removeFromSuperview()
                    } else {
                        NotificationCenter.default.post(name: .userSignedOut, object: nil)
                        XMPPService.instance.disconnect()
                        XMPPService.instance.offline()
                        av.stopAnimating()
                        overlay.removeFromSuperview()
//                        let vc = SignInViewController()
//                        self.present(vc, animated: true, completion: nil)
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
        
        //        if let delegate = UIApplication.shared.delegate as? AppDelegate , let window = delegate.window , let signInController = SignInViewController.storyBoardInstance() {
        //                window.rootViewController = signInController
        //        }
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

}
