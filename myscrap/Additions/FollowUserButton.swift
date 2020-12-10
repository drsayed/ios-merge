//
//  FollowUserButton.swift
//  myscrap
//
//  Created by myscrap on 28/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class FollowUserButton: UIButton {

    var isFollowUser: Bool = false {
        didSet{
            UIView.animate(withDuration: 0.3) {
                self.configureView()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        configureView()
    }
    
    private func configureView(){
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
        
        if isFollowUser {
            self.setTitle("Following", for: .normal)
            self.setImage(UIImage(named: ""), for: .normal)
            self.backgroundColor = UIColor.GREEN_PRIMARY
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.borderWidth = 0
//            self.isEnabled = false
            self.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            self.setTitle("Follow", for: .normal)
//            self.setImage(UIImage(named: "icFollow"), for: .normal)
            self.backgroundColor = UIColor.clear
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1.0
//            self.isEnabled = true
//            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
//            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
            self.setTitleColor(UIColor.BLACK_ALPHA, for: .normal) 
        }
    }
}
