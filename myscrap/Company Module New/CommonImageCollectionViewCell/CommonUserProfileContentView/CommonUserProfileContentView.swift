//
//  CommonUserProfileContentView.swift
//  myscrap
//
//  Created by Apple on 20/11/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class CommonUserProfileContentView: UIView {

    var contentBackgroundView : UIView!
    var profileImageView : UIImageView!
    
    var userNameLabel : UILabel!
    var designationLabel : UILabel!
    var postedDateLabel : UILabel!

    var rightArrowButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Set Up Views
    func setUpViews() {
        
        //contentBackgroundView
        self.contentBackgroundView = UIView()
        self.contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.contentBackgroundView.backgroundColor = UIColor.white
        self.addSubview(self.contentBackgroundView)
        
        //profileImageView
        self.profileImageView = UIImageView()
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.layer.cornerRadius = 30
        self.profileImageView.layer.masksToBounds = true
        self.contentBackgroundView.addSubview(self.profileImageView)
        
        //userNameLabel
        self.userNameLabel = UILabel()
        self.userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userNameLabel.text = " "
        self.userNameLabel.textColor = UIColor.black
        self.contentBackgroundView.addSubview(self.userNameLabel)

        //designationLabel
        self.designationLabel = UILabel()
        self.designationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.designationLabel.text = " "
        self.designationLabel.textColor = UIColor.BLACK_ALPHA
        self.designationLabel.font = UIFont(name: "HelveticaNeue", size: 13)
        self.contentBackgroundView.addSubview(self.designationLabel)

        //postedDateLabel
        self.postedDateLabel = UILabel()
        self.postedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.postedDateLabel.text = " "
        self.postedDateLabel.textColor = UIColor.gray
        self.postedDateLabel.font = UIFont(name: "HelveticaNeue", size: 10)
        self.contentBackgroundView.addSubview(self.postedDateLabel)

        self.setUpConstraints()
    }
    
    //MARK:- setUpConstraints
    func setUpConstraints() {
        
        //contentBackgroundView
        self.contentBackgroundView.leadingAnchor.constraint(equalTo: self.contentBackgroundView.superview!.leadingAnchor, constant: 0).isActive = true
        self.contentBackgroundView.trailingAnchor.constraint(equalTo: self.contentBackgroundView.superview!.trailingAnchor, constant: 0).isActive = true
        self.contentBackgroundView.topAnchor.constraint(equalTo: self.contentBackgroundView.superview!.topAnchor, constant: 0).isActive = true
        self.contentBackgroundView.bottomAnchor.constraint(equalTo: self.contentBackgroundView.superview!.bottomAnchor, constant: 0).isActive = true

        //profileImageView
        self.profileImageView.leadingAnchor.constraint(equalTo: self.profileImageView.superview!.leadingAnchor, constant: 10).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: self.profileImageView.superview!.topAnchor, constant: 10).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: self.profileImageView.superview!.topAnchor, constant: -10).isActive = true

        self.profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //userNameLabel
        self.userNameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 10).isActive = true
        self.userNameLabel.topAnchor.constraint(equalTo: self.profileImageView.topAnchor, constant: 0).isActive = true
//        self.userNameLabel.trailingAnchor.constraint(equalTo: self.userNameLabel.superview!.trailingAnchor, constant: 50).isActive = true
//        
//        //designationLabel
        self.designationLabel.leadingAnchor.constraint(equalTo: self.userNameLabel.leadingAnchor, constant: 0).isActive = true
        self.designationLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 5).isActive = true
//        self.designationLabel.trailingAnchor.constraint(equalTo: self.userNameLabel.trailingAnchor, constant: 0).isActive = true
//
//        //postedDateLabel
        self.postedDateLabel.leadingAnchor.constraint(equalTo: self.userNameLabel.leadingAnchor, constant: 0).isActive = true
        self.postedDateLabel.topAnchor.constraint(equalTo: self.designationLabel.bottomAnchor, constant: 5).isActive = true
//        self.postedDateLabel.trailingAnchor.constraint(equalTo: self.userNameLabel.trailingAnchor, constant: 0).isActive = true

    }
}
