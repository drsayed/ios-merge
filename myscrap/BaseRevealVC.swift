//
//  BaseRevealVC.swift
//  myscrap
//
//  Created by MS1 on 11/5/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class BaseRevealVC : BaseVC , SWRevealViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupMenuButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCountChanged(_:)), name: .notificationCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCountChanged(_:)), name: .bumpCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCountChanged(_:)), name: .visitorsCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCountChanged(_:)), name: .messageCountChanged, object: nil)
        
    }
    
    let mBtn = MenuButton()
    
    func setupMenuButton(){
        if let reveal = revealViewController(){
            reveal.delegate = self
            mBtn.notify = NotificationService.instance.totalCount != 0
            mBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            mBtn.addTarget(reveal, action: #selector(reveal.revealToggle(_:)), for: .touchUpInside)
            let item = UIBarButtonItem(customView: mBtn)
            self.navigationItem.setLeftBarButtonItems([item], animated: true)
        }
        
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        view.isUserInteractionEnabled = position == FrontViewPosition.left ? true : false
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        view.isUserInteractionEnabled = position == FrontViewPosition.left ? true : false
    }
    
    @objc private func notificationCountChanged(_ notification: Notification){
        notifyButton()
    }
    
    private func notifyButton(){
        if AuthStatus.instance.isGuest{
            mBtn.notify = false
        } else if NotificationService.instance.totalCount == 0 {
            mBtn.notify = false
        } else {
            mBtn.notify = true
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .notificationCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .bumpCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .visitorsCountChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notifyButton()
    }
    
}
