//
//  ReportAlertView.swift
//  myscrap
//
//  Created by Apple on 01/11/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class ReportAlertView : UIView {
    
    var contentView : UIView!
    var closeButton : UIButton!

    var titleLabel : UILabel!
    var okButton : UIButton!

    var closeAction : (() -> (Void))?
    var confirmAction : (() -> (Void))?

    var descriptionTextView : UITextView!
    var descriptionTextViewHeightConstraint : NSLayoutConstraint!
    
    let placeholderStr : String = "Please describe as much detail as possible"
    
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
//                doCloseAnimation()
        }
        else {
//                doCloseAnimation()
        }

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
//        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.text = "Are you sure you want to report?"
        self.contentView.addSubview(self.titleLabel)
        
        
        //descriptionTextView
        self.descriptionTextView = UITextView()
        self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionTextView.delegate = self
        self.descriptionTextView.font = UIFont.systemFont(ofSize: 14)
        self.descriptionTextView.layer.cornerRadius = 3
        self.descriptionTextView.layer.masksToBounds = true
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor

        self.descriptionTextView.text = self.placeholderStr
        self.descriptionTextView.textColor = UIColor.lightGray
        self.descriptionTextView.backgroundColor = UIColor.white
//        self.descriptionTextView.attributedText = self.attributeTitle(firstTitle: " Please describe as much detail as possible", secondTitle: "")
        
        self.contentView.addSubview(self.descriptionTextView)
        
        
        
        //yes
        self.okButton = UIButton()
        self.okButton.translatesAutoresizingMaskIntoConstraints = false
        self.okButton.setTitle("Yes", for: .normal)
        self.okButton.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        self.okButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.okButton.layer.cornerRadius = 3.0
        self.okButton.layer.borderColor = UIColor.GREEN_PRIMARY.cgColor
        self.okButton.layer.borderWidth = 1
        self.okButton.layer.masksToBounds = true
        self.contentView.addSubview(self.okButton)

        //No
        self.closeButton = UIButton()
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.setTitle("No", for: .normal)
        self.closeButton.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        self.closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.closeButton.layer.cornerRadius = 3.0
        self.closeButton.layer.borderColor = UIColor.GREEN_PRIMARY.cgColor
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.masksToBounds = true
        self.contentView.addSubview(closeButton)

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
        self.titleLabel.trailingAnchor.constraint(equalTo: self.titleLabel.superview!.trailingAnchor,constant:-15).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.titleLabel.superview!.topAnchor,constant:20).isActive = true

//        //descriptionTextField
//        self.descriptionTextField.leadingAnchor.constraint(equalTo: self.descriptionTextField.superview!.leadingAnchor,constant:15).isActive = true
//        self.descriptionTextField.trailingAnchor.constraint(equalTo: self.descriptionTextField.superview!.trailingAnchor,constant:-15).isActive = true
//        self.descriptionTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant:10).isActive = true
//        self.descriptionTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
  
        //descriptionTextView
        self.descriptionTextView.leadingAnchor.constraint(equalTo: self.descriptionTextView.superview!.leadingAnchor,constant:15).isActive = true
        self.descriptionTextView.trailingAnchor.constraint(equalTo: self.descriptionTextView.superview!.trailingAnchor,constant:-15).isActive = true
        self.descriptionTextView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant:10).isActive = true
        
        self.descriptionTextViewHeightConstraint = self.descriptionTextView.heightAnchor.constraint(equalToConstant: 33)
        self.descriptionTextViewHeightConstraint.isActive = true

        //closeButton
        self.closeButton.topAnchor.constraint(equalTo: self.okButton.topAnchor,constant:0).isActive = true
        self.closeButton.trailingAnchor.constraint(equalTo: self.okButton.leadingAnchor,constant:-15).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        //okButton
        self.okButton.topAnchor.constraint(equalTo: self.descriptionTextView.bottomAnchor,constant:15).isActive = true
        self.okButton.trailingAnchor.constraint(equalTo: self.okButton.superview!.trailingAnchor,constant:-15).isActive = true
        self.okButton.bottomAnchor.constraint(equalTo: self.okButton.superview!.bottomAnchor,constant: -20).isActive = true
       
        self.okButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.okButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

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

        self.closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.okButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)

        self.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }, completion: { finished in
            
        })

    //contentView.layer.add(popUpAnimation(), forKey: "popup")

    }

    func updateTextViewSize() {
        let fixedWidth = descriptionTextView.frame.size.width
        let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newHeight = max(33, newSize.height)
        if newHeight != descriptionTextViewHeightConstraint.constant {
            
            if newHeight > 100 {

                newHeight = 100
            }
            descriptionTextViewHeightConstraint.constant = newHeight
            descriptionTextView.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
}

extension ReportAlertView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 0 {
            self.updateTextViewSize()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeholderStr && textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = self.placeholderStr
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
}
