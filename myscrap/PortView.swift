//
//  PortView.swift
//  myscrap
//
//  Created by MyScrap on 7/19/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class PortView: UIView, Modal {
    
    
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
    
    
    private func setupViews(){
        addSubview(backgroundView)
        
        backgroundView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor)
        
        
        addSubview(dialogView)
        dialogView.setSize(size: CGSize(width: backgroundView.frame.width * 0.8, height: backgroundView.frame.height * 0.8))
        dialogView.setVerticalCenter(to: backgroundView)
        dialogView.setHorizontalCenter(to: backgroundView.centerXAnchor)
        
        
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 80, height: 80))
        btn.backgroundColor = UIColor.blue
        dialogView.addSubview(btn)
        
        btn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
    }
    
    @objc
    private func cancelTapped(){
        dismiss(animated: true)
    }
    
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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
