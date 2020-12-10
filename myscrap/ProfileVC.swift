//
//  ProfileVC.swift
//  myscrap
//
//  Created by Mac on 6/23/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ProfileVC:UpdatedUserPrrofileVC,SWRevealViewControllerDelegate {

    var menuButton : MenuButton?
    
    func setupMenuButton(){
        menuButton = MenuButton()
        if let reveal = revealViewController() , let mBtn = menuButton {
            reveal.delegate = self
            mBtn.notify = NotificationService.instance.totalCount != 0
            mBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            mBtn.addTarget(reveal, action: #selector(reveal.revealToggle(_:)), for: .touchUpInside)
            let item = UIBarButtonItem(customView: mBtn)
            self.navigationItem.setLeftBarButtonItems([item], animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupMenuButton()
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        view.isUserInteractionEnabled = position == FrontViewPosition.left ? true : false
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        view.isUserInteractionEnabled = position == FrontViewPosition.left ? true : false
    }
    
}
extension ProfileVC: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> ProfileVC?{
        return UIStoryboard(name: StoryBoard.PROFILE, bundle: nil).instantiateViewController(withIdentifier: ProfileVC.id) as? ProfileVC
    }
}

