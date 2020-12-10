//
//  MenuHeaderView.swift
//  myscrap
//
//  Created by MS1 on 12/12/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

protocol MenuHeaderViewDeleagate: class {
    func DidTapOnNotificationIcon()
    func DidTapForProfile()
    func DidTapMessageICon()
}

class MenuHeaderView: UIView{
    
    weak var delegate: MenuHeaderViewDeleagate?
    
    var notificationCount: Int?{
        didSet{
            notificationBtn.badgeText = notificationCount
        }
    }
    
    var messageCount: Int?{
        didSet{
            messageBtn.badgeText = messageCount
        }
    }
    
    var profileCount: Int? {
        didSet{
            profileImageView.badgeText = profileCount
        }
    }
    
    private let profileImageView: ProfileImageView = {
        let iv = ProfileImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let imageInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
    
    private lazy var notificationBtn: BadgeView = {
        let btn = BadgeView()
        btn.image = #imageLiteral(resourceName: "ic_notifications_48pt")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var messageBtn: BadgeView = {
        let btn = BadgeView()
        btn.image = #imageLiteral(resourceName: "ic_email_48pt")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
   
    
    private let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Guest User"
        lbl.font = Fonts.NAME_FONT
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(MenuHeaderView.nameLblTapped(_:)))
        tap.numberOfTapsRequired = 1
        lbl.addGestureRecognizer(tap)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var initialLbl : UILabel = {
        let lbl = UILabel()
        //lbl.adjustsFontSizeToFitWidth = true
        //lbl.numberOfLines = 2
        //lbl.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        lbl.text = "G U"
        lbl.textColor = UIColor.white
        print("Text colotr \(lbl.textColor)")
        lbl.font = UIFont(name: "HelveticaNeue", size: 20)
        lbl.textAlignment = .center
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    init(frame: CGRect, name: String, profilePic: String,colorCode:String, initial: String) {
        //profileImageView.sendSubview(toBack: profileImageView)
        nameLbl.text = name
        
        
        if profilePic == "" {
            
            profileImageView.updateViews(name: name, profilePic: "initial", colorCode: colorCode)
            initialLbl.text = initial
            print("shit: \(initialLbl.text!)")
            print("Empty Frame Profile :\(profilePic)")
            super.init(frame: frame)
            setupViews()
            setupTapRecogonizers()
        } else {
            profileImageView.updateViews(name: name, profilePic: AuthService.instance.profilePic, colorCode: colorCode)
            print("Else Frame Profile :\(profilePic)")
            initialLbl.text = ""
            print("shit: \(initialLbl.text!)")
            super.init(frame: frame)
            setupViews()
            setupTapRecogonizers()
        }
        
    }
    
    private func setupViews(){
        backgroundColor = UIColor.rgbColor(red: 241, green: 242, blue: 244)
        
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
                profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
                profileImageView.widthAnchor.constraint(equalToConstant: 80),
                profileImageView.heightAnchor.constraint(equalToConstant: 80)
            ])
        
        addSubview(notificationBtn)
        NSLayoutConstraint.activate([
            notificationBtn.widthAnchor.constraint(equalToConstant: 44),
            notificationBtn.heightAnchor.constraint(equalToConstant: 44),
            notificationBtn.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -20)
            ])
        
        addSubview(messageBtn)
        NSLayoutConstraint.activate([
            messageBtn.widthAnchor.constraint(equalToConstant: 44),
            messageBtn.heightAnchor.constraint(equalToConstant: 44),
            messageBtn.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20)
            ])
        
        NSLayoutConstraint.activate([
            messageBtn.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            notificationBtn.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
            ])
        
        addSubview(nameLbl)
        nameLbl.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        nameLbl.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        
        addSubview(initialLbl)
        initialLbl.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        initialLbl.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        initialLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        initialLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        //initialLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

    }
    
    private func setupTapRecogonizers(){
        
        let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(MenuHeaderView.profileImageTapped(_:)))
        profileImageTap.numberOfTapsRequired = 1
        profileImageView.addGestureRecognizer(profileImageTap)
        
        let notificationTap = UITapGestureRecognizer(target: self, action: #selector(MenuHeaderView.notificationTapped(_:)))
        notificationTap.numberOfTapsRequired = 1
        notificationBtn.addGestureRecognizer(notificationTap)
        
        let msgTap = UITapGestureRecognizer(target: self, action: #selector(MenuHeaderView.msgIconTapped(_:)))
        msgTap.numberOfTapsRequired = 1
        messageBtn.addGestureRecognizer(msgTap)
        
    }
    
    @objc fileprivate func notificationTapped(_ sender: UIButton){
        delegate?.DidTapOnNotificationIcon()
    }
    @objc fileprivate func msgIconTapped(_ sender: UIButton){
        delegate?.DidTapMessageICon()
    }
    @objc fileprivate func profileImageTapped(_ sender: UITapGestureRecognizer){
        delegate?.DidTapForProfile()
    }
    @objc fileprivate func nameLblTapped(_ sender: UITapGestureRecognizer){
        delegate?.DidTapForProfile()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ProfileImageView: UIView{
    
    
    var badgeText: Int?{
        didSet{
            updateBadgelbl(badgeText)
        }
    }
    
    private func updateBadgelbl(_ string: Int?){
        
        print(string)
        
        if let text = string , text != 0{
            badgeLabel.isHidden = false
            badgeLabel.text = "\(text)"
        } else {
            badgeLabel.isHidden = true
        }
    }
    
    
    private lazy var badgeLabel: BadgeSwift = {
        let lbl = BadgeSwift()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    
    private let profileIV: CircularImageView! = {
        let iv = CircularImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func updateViews(name: String, profilePic:String,colorCode:String){
        self.profileIV.backgroundColor = UIColor(hexString: colorCode)
        //initialLbl.text = name.initials()
        print("Initial Text \(name), \(profilePic), \(colorCode)")
        profileIV.sd_setImage(with: URL(string: AuthService.instance.profilePic), completed: nil)
        //self.profilePic.sd_setImage(with: URL(string: profilePic), completed: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        backgroundColor = UIColor.clear
        //addSubview(initialLbl)
        addSubview(profileIV)
        addSubview(badgeLabel)
        
//        initialLbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        initialLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        initialLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        initialLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        profileIV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileIV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileIV.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        profileIV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        badgeLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        badgeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileIV.layer.cornerRadius = layer.frame.height / 2
        profileIV.clipsToBounds = true
    }
}



final class BadgeView: UIView{
    
    var imageSpacing: CGFloat = 7.5
    
    var badgeText: Int?{
        didSet{
            updateBadgelbl(badgeText)
        }
    }
    
    private func updateBadgelbl(_ string: Int?){
        if let text = string , text != 0{
            badgeLabel.isHidden = false
            badgeLabel.text = "\(text)"
        } else {
            badgeLabel.isHidden = true
        }
    }
    
    
    var image: UIImage? {
        didSet{
            badgeImageView.image = image
        }
    }
    
    
    private lazy var circleView: UIView = {
        let iv = UIView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.white
        return iv
    }()
    
    private lazy var badgeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    
    private lazy var badgeLabel: BadgeSwift = {
        let lbl = BadgeSwift()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 10)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        
        addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: topAnchor),
            circleView.leftAnchor.constraint(equalTo: leftAnchor),
            circleView.rightAnchor.constraint(equalTo: rightAnchor),
            circleView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        addSubview(badgeImageView)
        
        NSLayoutConstraint.activate([
            badgeImageView.topAnchor.constraint(equalTo: topAnchor, constant: imageSpacing),
            badgeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -imageSpacing),
            badgeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: imageSpacing),
            badgeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imageSpacing)
        ])
    
        addSubview(badgeLabel)
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: topAnchor),
            badgeLabel.rightAnchor.constraint(equalTo: rightAnchor)
            ])
        

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = circleView.frame.height /  2
        circleView.clipsToBounds = true
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    

