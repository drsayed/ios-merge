//
//  MenuButton.swift
//  myscrap
//
//  Created by MS1 on 10/9/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit

class MenuButton: UIButton{
    
    var notify: Bool = false {
        didSet{
            notificationView.isHidden = !notify
        }
    }
    
    private let notificationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        
        setImage(#imageLiteral(resourceName: "menu_icon"), for: .normal)
        setTitle("", for: .normal)
        
        addSubview(notificationView)
        notificationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant : -5).isActive = true
        notificationView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        notificationView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        notificationView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    @objc func notificationCountChanged(_ notification: Notification){
        if let mBtn = notification.object as? MenuButton{
            if AuthStatus.instance.isGuest{
                mBtn.notify = false
            } else if NotificationService.instance.totalCount == 0 {
                mBtn.notify = false
            } else {
                mBtn.notify = true
            }
        }
    }
}




