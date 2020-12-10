//
//  MarketChatAlertView.swift
//  myscrap
//
//  Created by MyScrap on 7/3/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class MarketChatAlertView: UIView, Modal{

    
    var handler: (() -> ())?
    
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    var dialogView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.0
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Send Request for Chat."
        lbl.font = UIFont(name: "HelveticaNeue", size: 24)
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.sizeToFit()
        return lbl
    }()

    let cancelBtn: UIButton = {
        let btn  = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cancel", for: .normal)
        btn.backgroundColor = UIColor.BACKGROUND_GRAY
        btn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        btn.layer.cornerRadius = 2.0
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(MarketChatAlertView.okButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let sendBtn: UIButton = {
        let btn  = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Send Request", for: .normal)
        btn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        btn.backgroundColor = UIColor.BACKGROUND_GRAY
        btn.layer.cornerRadius = 2.0
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(MarketChatAlertView.sendBtnTapped), for: .touchUpInside)
        return btn
    }()
    
   
    
    @objc
    private func sendBtnTapped(){
        handler?()
        dismiss(animated: true)
    }
    
    @objc private func okButtonTapped(){
        dismiss(animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(backgroundView)
        
        backgroundView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: nil, bottom: nil)
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(dialogView)
        dialogView.setHorizontantalCenter(to: self)
        dialogView.setVerticalCenter(to: self)
        
        dialogView.widthAnchor.constraint(equalToConstant:280).isActive = true
        
        
        let stakView = UIStackView(arrangedSubviews: [sendBtn, cancelBtn])
        stakView.translatesAutoresizingMaskIntoConstraints = false
        stakView.axis = .horizontal
        stakView.spacing = 8
        stakView.distribution = .fillEqually
        stakView.alignment = .fill
        
        dialogView.addSubview(titleLabel)
        dialogView.addSubview(stakView)
        
        titleLabel.anchor(leading: dialogView.leadingAnchor, trailing: dialogView.trailingAnchor, top: dialogView.topAnchor, bottom: stakView.topAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        stakView.anchor(leading: dialogView.leadingAnchor, trailing: dialogView.trailingAnchor, top: nil, bottom: dialogView.bottomAnchor,padding: UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8))
        
     
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(){
        self.init(frame: UIScreen.main.bounds)
    }
    convenience init(view: UIView){
        self.init(frame: view.frame)
    }
    
}



