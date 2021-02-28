//
//  ProfileView.swift
//  myscrap
//
//  Created by MS1 on 7/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ProfileView: CircleView {
    
    let label = UILabel()
    let image = UIImageView()
    let newView = UIView()
    
    
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.green
        
        setupViews()
    }
    
    func setupViews(){
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.text = ""
        label.font = Fonts.INIITIAL_FONT
        label.textColor = UIColor.WHITE_ALPHA
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        
        
        image.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        self.addSubview(image)
        
    }
    
    func updateViews(name: String, url: String, colorCode: String){
        
        
        if name.contains(" "){
            self.label.text = name.initials().replacingOccurrences(of: " ", with: "")
        } else {
            self.label.text = name.firstLetter()
        }
        var downloadURL = ""
        
        if (url == "https://myscrap.com/style/images/icons/profile.png" || url == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || url == "https://myscrap.com/style/images/icons/no_image.png") {
            downloadURL = ""
        } else {
            downloadURL = url
        }
        
        if let url = URL(string: downloadURL) {
            image.sd_setImage(with: url, completed: nil)
        } else {
            image.image = nil
        }
    
        self.backgroundColor = UIColor.init(hexString: colorCode)
        self.backgroundColor = UIColor.MyScrapGreen
    }

}
class NewMembsProfileView: CircleView {
    
    let label = UILabel()
    let image = UIImageView()
    let newView = UIView()
    
    
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.green
        
        setupViews()
    }
    
    func setupViews(){
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.text = ""
        label.font = Fonts.MEMB_INITIAL_FONT
        label.textColor = UIColor.WHITE_ALPHA
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        
        
        image.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        self.addSubview(image)
        
    }
    
    func updateViews(name: String, url: String, colorCode: String){
        
        
        if name.contains(" "){
            self.label.text = name.initials().replacingOccurrences(of: " ", with: "")
        } else {
            self.label.text = name.firstLetter()
        }
        var downloadURL = ""
        
        if (url == "https://myscrap.com/style/images/icons/profile.png" || url == "https://myscrap.com/style/images/icons/no-profile-pic-female.png") {
            downloadURL = ""
        } else {
            downloadURL = url
        }
        
        if let url = URL(string: downloadURL) {
            image.sd_setImage(with: url, completed: nil)
        } else {
            image.image = nil
        }
        
        self.backgroundColor = UIColor.init(hexString: colorCode)
        
    }
    
}
class MarketProfileView: CircleView {
    
    let label = UILabel()
    let image = UIImageView()
    let newView = UIView()
    
    
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.green
        
        setupViews()
    }
    
    func setupViews(){
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.text = ""
        label.font = Fonts.MARKET_FONT
        label.textColor = UIColor.WHITE_ALPHA
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        
        
        image.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.focusOnFaces = true
        self.addSubview(image)
        
    }
    
    func updateViews(name: String, url: String, colorCode: String){
        
        
        if name.contains(" "){
            self.label.text = name.initials()
        } else {
            self.label.text = name.firstLetter()
        }
        var downloadURL = ""
        
        if (url == "https://myscrap.com/style/images/icons/profile.png" || url == "https://myscrap.com/style/images/icons/no-profile-pic-female.png") {
            downloadURL = ""
        } else {
            downloadURL = url
        }
        
        if let url = URL(string: downloadURL) {
            image.sd_setImage(with: url, completed: nil)
        } else {
            image.image = nil
        }
        
        self.backgroundColor = UIColor.init(hexString: colorCode)
        
    }
    
}
class LandProfileView: CircleView {
    
    let label = UILabel()
    let image = UIImageView()
    let newView = UIView()
    
    
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.white
        
        setupViews()
    }
    
    func setupViews(){
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.text = ""
        label.font = Fonts.LAND_USERINITIALS_FONT
        label.textColor = UIColor.WHITE_ALPHA
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        
        
        image.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.focusOnFaces = true
        self.addSubview(image)
        
    }
    
    func updateViews(name: String, url: String, colorCode: String){
        
        
        if name.contains(" "){
            self.label.text = name.initials()
        } else {
            self.label.text = name.firstLetter()
        }
        var downloadURL = ""
        
        if (url == "https://myscrap.com/style/images/icons/profile.png" || url == "https://myscrap.com/style/images/icons/no-profile-pic-female.png") {
            downloadURL = ""
        } else {
            downloadURL = url
        }
        
        if let url = URL(string: downloadURL) {
            image.sd_setImage(with: url, completed: nil)
        } else {
            image.image = nil
        }
        
        self.backgroundColor = UIColor.init(hexString: colorCode)
        
    }
    
}

class LoginButton: UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitle("", for: .normal)
        self.setTitleColor(UIColor.WHITE_ALPHA, for: .normal)
        self.setTitleColor(UIColor.WHITE_ALPHA, for: .highlighted)
        super.awakeFromNib()
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.GREEN_PRIMARY
        self.titleLabel?.font = Fonts.LOGIN_BTN_FONT
        
    }
}

