
//
//  BumpedCell.swift
//  myscrap
//
//  Created by MS1 on 12/11/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

protocol BumpDelegate: class {
    func didTapChatBtn(cell: BumpedCell)
    func didTapCloseBtn(cell: BumpedCell)
}

class BumpedCell: BaseCVCell{
    
    weak var delegate : BumpDelegate?
    
    private var isInitiallyLoaded = false
    
    var bumpedItem: BumpedItem?{
        didSet{
            guard  let item = bumpedItem else { return }
            
//            imageView.setImageWithIndicator(imageURL: item.profilePic)
            
            imageView.sd_setImage(with: URL(string: item.profilePic), placeholderImage: #imageLiteral(resourceName: "bumpedProfile"), options: .refreshCached, completed: nil)
            
            nameLbl.text = item.name
            titleLbl.text = "Last Bumped"
            titleLbl.isHidden = item.bumpNew
            profileTypeView.isHidden = !item.bumpNew
            
            timeLbl.text = item.bumpedTime
            designationLbl.text = item.designation
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = UIColor.gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "bumpedProfile")
        return iv
    }()
    
    var profileTypeView: ProfileTypeView = {
        let view = ProfileTypeView()
        view.type = .new
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "HelveticaNeue-Bold", size: 14)!
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "bumpedClose"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(BumpedCell.closeBtnClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    let timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 10)!
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Lady Rona Smith"
        lbl.font = Fonts.NAME_FONT
        lbl.textColor = UIColor.white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    
    
    
//    let nView: newView = {
//        let view = newView()
//        return view
//    }()
   
    let designationLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Trader"
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 12)!
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var chatBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Say Hi", for: .normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.GREEN_PRIMARY
        btn.setImage(#imageLiteral(resourceName: "ic_say_hi"), for: .normal)
        btn.tintColor = UIColor.white
        btn.addTarget(self, action: #selector(BumpedCell.chatBtnClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        addSubview(imageView)
        addSubview(chatBtn)
//        addSubview(titleLbl)
//        addSubview(timeLbl)
        addSubview(nameLbl)
        addSubview(designationLbl)
        addSubview(closeButton)
        
        //Image View Constraints
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: chatBtn.topAnchor).isActive = true
        
        // ChatBtn Constraints
        chatBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chatBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        chatBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        chatBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        profileTypeView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileTypeView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLbl, profileTypeView, timeLbl])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 3
//        stackView.distribution = .
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        
        // titleLabel constraints
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
//        titleLbl.bottomAnchor.constraint(equalTo: timeLbl.topAnchor, constant: -3).isActive = true
        stackView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: 8).isActive = true
        
        closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        //nameLbl Constraints
        nameLbl.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        nameLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        nameLbl.bottomAnchor.constraint(equalTo: designationLbl.topAnchor, constant: -3).isActive = true
        designationLbl.bottomAnchor.constraint(equalTo: chatBtn.topAnchor, constant: -3).isActive = true
        
        //CloseButton Constraints
        
        designationLbl.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        
        nameLbl.textDropShadow()
        designationLbl.textDropShadow()
        
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }
    
    var shadowLayer : CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil{
            shadowLayer = CAShapeLayer()
        }
    }
    
    
    @objc private func closeBtnClicked(_ sender: UIButton){
        delegate?.didTapCloseBtn(cell: self)
    }
    
    @objc private func chatBtnClicked(_ sender: UIButton){
        delegate?.didTapChatBtn(cell: self)
    }
}


