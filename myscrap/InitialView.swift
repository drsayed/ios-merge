//
//  InitialView.swift
//  myscrap
//
//  Created by MS1 on 10/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class InitialView: UIView {
    
    let initialLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "M A"
        return lbl
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.blue
        return iv
    }()
    
    internal func setupViews(){
        self.layer.cornerRadius = self.frame.width / 2
        
        self.addSubview(initialLbl)
        initialLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        initialLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
}

class NearFriendView: InitialView {
    
    let onlineView: UIView = {
        let ov = UIView()
        ov.translatesAutoresizingMaskIntoConstraints = false
        ov.widthAnchor.constraint(equalToConstant: 20).isActive = true
        ov.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ov.backgroundColor = UIColor.ONLINE_COLOR
        return ov
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setupViews() {
        super.setupViews()
        self.addSubview(onlineView)
        onlineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        onlineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true

    }
}



