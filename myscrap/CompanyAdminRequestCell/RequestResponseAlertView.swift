//
//  RequestResponseAlertView.swift
//  myscrap
//
//  Created by Mehtab Ahmed on 26/12/20.
//  Copyright © 2020 MyScrap. All rights reserved.

import UIKit

class RequestResponseAlertView: UIView {
    
    var contentView : UIView!
    var titleLabel : UILabel!
    
    var confirmButton : UIButton!
    var cancelButton : UIButton!
    
    var closeAction : (() -> (Void))?
    var confirmAction : (() -> (Void))?
    
    var customWindow : UIWindow!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Actions
    @objc func closeButtonAction() {
        
        if(closeAction != nil){
            self.closeAction!()
            doCloseAnimation()
        }
        else {
            doCloseAnimation()
        }
    }
    
    @objc func confirmButtonAction() {
        
        if(confirmAction != nil){
            self.confirmAction!()
        }
        doCloseAnimation()
    }
    
    func doCloseAnimation(){
        
        UIView.animate(withDuration: 0.25, animations: {  [weak self] in
            if(self != nil){
                self!.alpha = 0
            }
        }, completion: {[weak self] finished in
            if(self != nil){
                //                    self!.removeFromSuperview()
                self!.customWindow.removeFromSuperview()
            }
            
        })
    }
    
    //MARK:- setUpViews
    func setUpViews() {
        
        //contentView
        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 10
        self.addSubview(contentView)
        
        //titleLabel
        self.titleLabel = UILabel()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.text = ""
        self.contentView.addSubview(self.titleLabel)
        
        
        //CONFIRM Button
        self.confirmButton = UIButton()
        self.confirmButton.translatesAutoresizingMaskIntoConstraints = false
        self.confirmButton.setTitle("CONFIRM", for: .normal)
        self.confirmButton.setTitleColor(UIColor.white, for: .normal)
        self.confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.confirmButton.layer.cornerRadius = 5.0
        self.confirmButton.layer.borderColor = UIColor.GREEN_PRIMARY.cgColor
        self.confirmButton.layer.backgroundColor = UIColor.GREEN_PRIMARY.cgColor
        self.confirmButton.layer.borderWidth = 1
        self.confirmButton.layer.masksToBounds = true
        self.contentView.addSubview(self.confirmButton)
        
        //CANCEL Button
        self.cancelButton = UIButton()
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.setTitle("CANCEL", for: .normal)
        self.cancelButton.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.cancelButton.layer.cornerRadius = 5.0
        self.cancelButton.layer.borderColor = UIColor.GREEN_PRIMARY.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.layer.masksToBounds = true
        self.contentView.addSubview(cancelButton)
        
        self.setUpConstraints()
    }
    
    //MARK: setUpConstraints
    func setUpConstraints () {
        
        //contentView
        self.contentView.centerXAnchor.constraint(equalTo: contentView.superview!.centerXAnchor).isActive = true
        self.contentView.centerYAnchor.constraint(equalTo: contentView.superview!.centerYAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50).isActive = true
        
        //titleLabel
        self.titleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.superview!.leadingAnchor,constant:15).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.titleLabel.superview!.trailingAnchor,constant:-10).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.titleLabel.superview!.topAnchor,constant:20).isActive = true
        
        //CANCEL Button
        self.cancelButton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 25).isActive = true
        self.cancelButton.bottomAnchor.constraint(equalTo: self.titleLabel.superview!.bottomAnchor, constant: -20).isActive = true
        self.cancelButton.trailingAnchor.constraint(equalTo: self.titleLabel.superview!.trailingAnchor,constant: -15).isActive = true
        self.cancelButton.leadingAnchor.constraint(equalTo: self.confirmButton.trailingAnchor,constant: -15).isActive = true
        self.cancelButton.widthAnchor.constraint(equalTo: self.confirmButton.widthAnchor).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Confirm Button
        self.confirmButton.topAnchor.constraint(equalTo:self.cancelButton.topAnchor).isActive = true
        self.confirmButton.trailingAnchor.constraint(equalTo: self.cancelButton.leadingAnchor,constant: -15).isActive = true
        self.confirmButton.leadingAnchor.constraint(equalTo: self.titleLabel.superview!.leadingAnchor,constant: 15).isActive = true
        self.confirmButton.bottomAnchor.constraint(equalTo: self.confirmButton.superview!.bottomAnchor,constant: -20).isActive = true
        self.confirmButton.widthAnchor.constraint(equalTo: self.cancelButton.widthAnchor).isActive = true
        self.confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    public func attributeTitle(firstTitle: String,secondTitle: String) -> NSMutableAttributedString {
        
        let firstText = NSAttributedString(string: firstTitle, attributes: [
                                            NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        let secondText = NSAttributedString(string: secondTitle, attributes: [
                                                NSAttributedString.Key.foregroundColor : UIColor(red: 255/255.0, green: 2/255.0, blue: 68/255.0, alpha: 1)])
        
        let mutableString = NSMutableAttributedString()
        mutableString.append(firstText)
        mutableString.append(secondText)
        return mutableString
    }
    
    //MARK: Display Alert
    func displayAlert(withSuperView : UIViewController,title: String, buttonAction : (() -> Void)?) {
        
        self.customWindow = UIWindow(frame: UIScreen.main.bounds)
        self.customWindow.rootViewController = withSuperView
        self.titleLabel.text = title
        confirmAction = buttonAction
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        withSuperView.view.addSubview(self)
        
        self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: self.superview!.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor).isActive = true
        
        self.cancelButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        
        self.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }, completion: { finished in
            
        })
    }
}
