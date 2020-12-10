//
//  ViewMailCell.swift
//  myscrap
//
//  Created by MyScrap on 1/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class ViewMailCell: UICollectionViewCell, UITextViewDelegate {
    @IBOutlet weak var bodyMessageTV: UITextView!
    @IBOutlet weak var sendMsgTV: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var sendMsgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bodySpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendMsgSpacingConstraint: NSLayoutConstraint!
    // this will be our "call back" action
    var btnTapAction : (()->())?
    
    override func awakeFromNib() {
        //sendMsgHeightConstraint.constant = 0
        //sendBtnHeightConstraint.constant = 0
        bodyMessageTV.isEditable = false
        setupTextView()
        setupButton()
    }
    
    func setupButton(){
        sendBtn.backgroundColor = .clear
        sendBtn.layer.cornerRadius = 5
        sendBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        sendBtn.layer.borderWidth = 1
    }
    
    func setupTextView() {
        sendMsgTV.delegate = self
        sendMsgTV.clipsToBounds = true
        sendMsgTV.layer.cornerRadius = 5
        let color = UIColor.lightGray
        sendMsgTV.layer.borderColor = color.cgColor
        sendMsgTV.layer.borderWidth = 0.5
        sendMsgTV.text = "Write the message..."
        sendMsgTV.textColor = .lightGray
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write the message.."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        // use our "call back" action to tell the controller the button was tapped
        btnTapAction?()
    }
}
