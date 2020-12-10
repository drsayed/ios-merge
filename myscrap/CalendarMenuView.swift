//
//  CalendarMenuView.swift
//  myscrap
//
//  Created by MS1 on 1/21/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol CalendarMenuViewDelegate: class{
    func didTappedSaySomething()
    func didTappedImageBtn()
}

class CalendarMenuView: UICollectionReusableView {
    
    weak var delegate: CalendarMenuViewDelegate?
    
    lazy var menuBar: TopMenuBar = { [unowned self] in
        let mb = TopMenuBar(frame: .zero)
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.titleArray = ["ABOUT", "DISCUSSION"]
        return mb
    }()
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.sd_setImage(with: URL(string: AuthService.instance.profilePic), completed: nil)
        return iv
    }()
    
    private let writeSomethingBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Say something...", for: .normal)
        btn.titleLabel?.font = Fonts.DESIG_FONT
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(CalendarMenuView.writePostPressed), for: .touchUpInside)
        return btn
    }()
    
    private let addImageBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ic_photo_library-1").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.lightGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(CalendarMenuView.imageBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    let writePostView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    
    @objc private func imageBtnPressed(){
        delegate?.didTappedImageBtn()
    }
    
    @objc private func writePostPressed(){
        delegate?.didTappedSaySomething()
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
        addSubview(menuBar)
        menuBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(writePostView)
        
        writePostView.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: 8).isActive = true
        writePostView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        writePostView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        writePostView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        writePostView.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.leftAnchor.constraint(equalTo: writePostView.leftAnchor, constant: 8).isActive = true
        imageView.centerYAnchor.constraint(equalTo: writePostView.centerYAnchor).isActive = true
        
        writePostView.addSubview(writeSomethingBtn)
        
        writeSomethingBtn.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        writeSomethingBtn.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        writePostView.addSubview(addImageBtn)
        writeSomethingBtn.rightAnchor.constraint(equalTo: addImageBtn.leftAnchor).isActive = true
        addImageBtn.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        addImageBtn.rightAnchor.constraint(equalTo: writePostView.rightAnchor, constant: -16).isActive = true
        
        
        
        
    }
}
