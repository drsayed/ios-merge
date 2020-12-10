//
//  LiveSender.swift
//  myscrap
//
//  Created by MyScrap on 12/30/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol LiveChatTappedDelegate: class{
    func DidTappedView(cell: BaseCell)
    func DidTappedImage(cell: SenderImageCell)
}



class LiveSender: BaseCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderView: SenderView!
    //@IBOutlet weak var statusLbl: UILabel!
    //@IBOutlet weak var readImageView: CircularImageView!
    @IBOutlet weak var circlePoints: UIView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var readImageView: CircularImageView!
    
    weak var tapDelegate : LiveChatTappedDelegate?
    
    var lastSeen = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.textColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.numberOfTapsRequired = 1
        senderView.addGestureRecognizer(tap)
        statusLbl.text = ""
        readImageView.tintColor = UIColor.GREEN_PRIMARY
        readImageView.backgroundColor = UIColor.clear
        circlePoints.clipsToBounds = true
        circlePoints.layer.masksToBounds = true
        circlePoints.layer.cornerRadius = 11
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer){
        if let delegate = self.tapDelegate{
            delegate.DidTappedView(cell: self)
        }
    }
    
    func configSender(message: Message, isLastSeen: Bool){
        lastSeen = isLastSeen
        messageLabel.text = message.text
        if let status = message.status{
            setReadImage(status: status, imageURL: message.member?.profilePic ?? "")
        } else {
            setReadImage(status: "", imageURL: message.member?.profilePic ?? "")
        }
    }
    
    
    
    //MARK:- SETTING READIMAGEVIEW AND STATUSLABEL
    private func setReadImage(status: String, imageURL: String){
        let sent = #imageLiteral(resourceName: "msg_sent").withRenderingMode(.alwaysTemplate)
        let delivered = #imageLiteral(resourceName: "msg_delivered").withRenderingMode(.alwaysTemplate)
        if status == "2"{
            statusLbl.text = "Delivered"
            readImageView.backgroundColor = UIColor.clear
            readImageView.image = delivered
        } else if status == "3"{
            statusLbl.text = "Seen"
            if self.lastSeen{
                readImageView.backgroundColor = UIColor.GREEN_PRIMARY
                if let url = URL(string: imageURL) {
                    readImageView.sd_setImage(with: url, completed: nil)
                } else {
                    readImageView.image = nil
                }
            } else {
                readImageView.backgroundColor = UIColor.clear
                readImageView.image = nil
            }
        } else {
            statusLbl.text = "Sent"
            readImageView.backgroundColor = UIColor.clear
            readImageView.image = sent
        }
    }
    
}



class LiveMessageLabel: UILabel{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.font = Fonts.descriptionFont
        self.numberOfLines = 0
        // self.textColor = BLACK_ALPHA
    }
}

