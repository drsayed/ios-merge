//
//  AddMoreFooterView.swift
//  myscrap
//
//  Created by Apple on 12/11/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

protocol CloseCellButtonDelegate : class {
    
    func didCloseButtonTapped(_ cell: CompanyAndCommoditiesPhotosCell)
}

class CompanyAndCommoditiesPhotosCell: UICollectionViewCell {
        
    var contentBackgroundView : UIView!
    var contentImageView : UIImageView!
    var closeButton : UIButton!
    
//    var addMoreContentView : UIView!
//    var addMoreImageView : UIImageView!
//    var addMoreLabel : UILabel!
    
    weak var cellDelegate : CloseCellButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        //contentBackgroundView
        self.contentBackgroundView = UIView()
        self.contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.contentBackgroundView.backgroundColor = UIColor.white//lightGray
        self.contentBackgroundView.layer.borderWidth = 0.5
        self.contentBackgroundView.layer.borderColor = UIColor.darkGray.cgColor
        self.contentBackgroundView.layer.cornerRadius = 10
        self.contentBackgroundView.layer.masksToBounds = true
        self.addSubview(self.contentBackgroundView)

        //addMoreImageView
        self.contentImageView = UIImageView()
        self.contentImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.contentImageView.contentMode = .scaleAspectFit
        self.contentBackgroundView.addSubview(self.contentImageView)

        //closeButton
        self.closeButton = UIButton()
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.setImage(UIImage(named:"close_btn_15x15"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.contentBackgroundView.addSubview(self.closeButton)
        
//        //addMoreImageView
//        self.addMoreImageView = UIImageView()
//        self.addMoreImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.addMoreImageView.image = UIImage(named: "")
//        self.contentBackgroundView.addSubview(self.addMoreImageView)
//
//
//        //addMoreLabel
//        self.addMoreLabel = UILabel()
//        self.addMoreLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.addMoreLabel.text = "Add more"
//        self.addMoreLabel.textColor = UIColor.black
//        self.addMoreLabel.font = UIFont.systemFont(ofSize: 15)
//        self.contentBackgroundView.addSubview(self.addMoreLabel)
        
        self.setUpConstraints()
    }
    
    @objc func closeButtonAction() {
        
        cellDelegate?.didCloseButtonTapped(self)
    }
    func setUpConstraints() {
        
        //contentBackgroundView
        self.contentBackgroundView.leadingAnchor.constraint(equalTo: self.contentBackgroundView.superview!.leadingAnchor, constant: 0).isActive = true
        self.contentBackgroundView.trailingAnchor.constraint(equalTo: self.contentBackgroundView.superview!.trailingAnchor, constant: 0).isActive = true
        self.contentBackgroundView.topAnchor.constraint(equalTo: self.contentBackgroundView.superview!.topAnchor, constant: 0).isActive = true
        self.contentBackgroundView.bottomAnchor.constraint(equalTo: self.contentBackgroundView.superview!.bottomAnchor, constant: 0).isActive = true

        
        //contentImageView
        self.contentImageView.leadingAnchor.constraint(equalTo: self.contentImageView.superview!.leadingAnchor, constant: 0).isActive = true
        self.contentImageView.trailingAnchor.constraint(equalTo: self.contentImageView.superview!.trailingAnchor, constant: 0).isActive = true
        self.contentImageView.topAnchor.constraint(equalTo: self.contentImageView.superview!.topAnchor, constant: 2).isActive = true
        self.contentImageView.bottomAnchor.constraint(equalTo: self.contentImageView.superview!.bottomAnchor, constant: 0).isActive = true
//        self.contentImageView.widthAnchor.constraint(lessThanOrEqualToConstant:150).isActive = true
        self.contentImageView.heightAnchor.constraint(lessThanOrEqualToConstant:70).isActive = true
        self.contentImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width / 3 - 20).isActive = true
        //closeButton
        self.closeButton.topAnchor.constraint(equalTo:self.closeButton.superview!.topAnchor, constant: 2).isActive = true
        self.closeButton.trailingAnchor.constraint(equalTo:self.closeButton.superview!.trailingAnchor, constant:-5).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
//        //addMoreImageView
//        self.addMoreImageView.centerXAnchor.constraint(equalTo: self.addMoreImageView.superview!.centerXAnchor,constant: 0).isActive = true
//        self.addMoreImageView.centerYAnchor.constraint(equalTo: self.addMoreImageView.superview!.centerYAnchor,constant: -10).isActive = true
//        self.addMoreImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        self.addMoreImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        //addMoreLabel
//        self.addMoreLabel.topAnchor.constraint(equalTo: self.addMoreImageView.bottomAnchor, constant: 6).isActive = true
//        self.addMoreLabel.centerXAnchor.constraint(equalTo: self.addMoreLabel.superview!.centerXAnchor,constant: 0).isActive = true
//        self.addMoreLabel.centerYAnchor.constraint(equalTo: self.addMoreLabel.superview!.centerYAnchor,constant: 0).isActive = true

    }
}
