//
//  AddListingBottomView.swift
//  myscrap
//
//  Created by MyScrap on 7/22/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class AddListingBottomView: BaseView{
    
    typealias Handler = () -> Void
    
    var didTapContact: Handler?
    var didTapEmail: Handler?
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.seperatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc let contactSellerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(" Chat", for: .normal)
        btn.titleLabel?.font = Fonts.DESIG_FONT
        //btn.setImage(UIImage(named: "ic_phone"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "chat_white"), for: .normal)
//        let origImage = UIImage(named: "ic_phone")
//        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = UIColor.WHITE_ALPHA
        btn.backgroundColor = UIColor.MyScrapGreen
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 10 , left: 10, bottom: 10, right: 10)
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        btn.layer.borderColor = UIColor.seperatorColor.cgColor
        btn.layer.borderWidth = 1.0
        return btn
    }()
    
    @objc private let emailButoon: UIButton = {
        let btn = UIButton()
        btn.setTitle(" Email Now", for: .normal)
        btn.setImage(#imageLiteral(resourceName: "email_white"), for: .normal)
        btn.titleLabel?.font = Fonts.DESIG_FONT
        btn.backgroundColor = UIColor.MyScrapGreen
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.layer.borderColor = UIColor.seperatorColor.cgColor
        btn.layer.borderWidth = 1.0
        return btn
    }()
    
    
    override func setupViews() {
        addSubview(borderView)
        borderView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: nil)
        borderView.setSize(size: CGSize(width: 0, height: 1))
        
        let stackView = UIStackView(arrangedSubviews: [contactSellerButton, emailButoon])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        
        addSubview(stackView)
        stackView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: borderView.bottomAnchor, bottom: bottomAnchor , padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        contactSellerButton.addTarget(self, action: #selector(contactPressed), for: .touchUpInside)
        emailButoon.addTarget(self, action: #selector(emailPressed), for: .touchUpInside)
    }
    
    @objc
    private func contactPressed(){
        didTapContact?()
    }
    
    @objc
    private func emailPressed(){
        didTapEmail?()
    }
    
}


class BaseView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews(){
        backgroundColor = UIColor.white
    }
    
    
}
