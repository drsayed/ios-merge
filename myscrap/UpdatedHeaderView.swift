//
//  UpdatedHeaderView.swift
//  myscrap
//
//  Created by MyScrap on 3/27/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

protocol UpdatedHeaderViewDelegate: class {
    func DidTapOnNotificationIcon()
    func DidTapForProfile()
    func DidTapMessageICon()
}

class UpdatedHeaderView: UIView{
    
    /*weak var delegate: UpdatedHeaderViewDelegate?
    
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
    
    let imageInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
    
    var horizStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 10
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var vertStackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var vieew: UIView = {
        let view = UIView()
        return view
    }()
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UpdatedHeaderView.nameLblTapped(_:)))
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
        setupViews()
        setupTapRecogonizers()
    }
    
    private func setupViews(){
        backgroundColor = UIColor.rgbColor(red: 241, green: 242, blue: 244)
        
        addSubview(notificationBtn)
        NSLayoutConstraint.activate([
            notificationBtn.widthAnchor.constraint(equalToConstant: 44),
            notificationBtn.heightAnchor.constraint(equalToConstant: 44)
            //notificationBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20)
            ])
        
        addSubview(messageBtn)
        NSLayoutConstraint.activate([
            messageBtn.widthAnchor.constraint(equalToConstant: 44),
            messageBtn.heightAnchor.constraint(equalToConstant: 44)
            //messageBtn.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 40)
            ])
        
        
        
        
        
        
        
    }
    
    private func setupTapRecogonizers(){
        
        let notificationTap = UITapGestureRecognizer(target: self, action: #selector(UpdatedHeaderView.notificationTapped(_:)))
        notificationTap.numberOfTapsRequired = 1
        notificationBtn.addGestureRecognizer(notificationTap)
        
        let msgTap = UITapGestureRecognizer(target: self, action: #selector(UpdatedHeaderView.msgIconTapped(_:)))
        msgTap.numberOfTapsRequired = 1
        messageBtn.addGestureRecognizer(msgTap)
        
    }
    
    @objc fileprivate func notificationTapped(_ sender: UIButton){
        delegate?.DidTapOnNotificationIcon()
    }
    @objc fileprivate func msgIconTapped(_ sender: UIButton){
        delegate?.DidTapMessageICon()
    }
    
    @objc fileprivate func nameLblTapped(_ sender: UITapGestureRecognizer){
        delegate?.DidTapForProfile()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
}




