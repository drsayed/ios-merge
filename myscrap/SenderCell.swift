//
//  SenderCell.swift
//  myscrap
//
//  Created by MS1 on 9/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

protocol ChatTappedDelegate: class{
    func DidTappedView(cell: BaseCell)
    func DidTappedImage(cell: SenderImageCell)
}



class SenderCell: BaseCell {
    
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var senderView: SenderView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var readImageView: CircularImageView!
    
    weak var tapDelegate : ChatTappedDelegate?
    
    var lastSeen = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLbl.textColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.numberOfTapsRequired = 1
        senderView.addGestureRecognizer(tap)
        statusLbl.text = ""
        readImageView.tintColor = UIColor.GREEN_PRIMARY
        readImageView.backgroundColor = UIColor.clear
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer){
        if let delegate = self.tapDelegate{
            delegate.DidTappedView(cell: self)
        }
    }
    
    func configSender(message: Message, isLastSeen: Bool){
        lastSeen = isLastSeen
        messageLbl.text = message.text
        if let status = message.status{
            setReadImage(status: status, imageURL: message.member?.profilePic ?? "")
        } else {
            setReadImage(status: "", imageURL: message.member?.profilePic ?? "")
        }
    }
    
    //MARK:- SETTING READIMAGEVIEW AND STATUSLABEL
    func setRead(status: Bool){
        let notDelivered = #imageLiteral(resourceName: "time01").withRenderingMode(.alwaysTemplate)
        let delivered = #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysTemplate)
        let clientReceived = #imageLiteral(resourceName: "double_tick_chat").withRenderingMode(.alwaysTemplate)
        // status = 0 message sent if status = 1 message not sent still offlint
        if status == true {
            
            readImageView.tintColor = UIColor(hexString: "#7a7a7a")
            readImageView.image = notDelivered  // time
        } else {
            readImageView.tintColor = UIColor.MyScrapGreen
            readImageView.image = delivered
        }
    }
    
    //Using * in ConversationVC
    func setMsgStatus(status: String) {
        let offline = #imageLiteral(resourceName: "time01").withRenderingMode(.alwaysTemplate)
        let sent = #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysTemplate)
        let received = #imageLiteral(resourceName: "double_tick_chat").withRenderingMode(.alwaysTemplate)
        // status = 0 message sent if status = 1 message not sent still offlint
        if status == "offline" {
            
            readImageView.tintColor = UIColor(hexString: "#7a7a7a")
            readImageView.image = offline  // time
        } else if status == "sent" {
            readImageView.tintColor = UIColor(hexString: "#7a7a7a")
            readImageView.image = sent
        } else {
            readImageView.tintColor = UIColor.MyScrapGreen
            readImageView.image = received
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
                readImageView.backgroundColor = UIColor(hexString: "#7a7a7a")
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



class MessageLabel: UILabel{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.font = Fonts.descriptionFont
        self.numberOfLines = 0
       // self.textColor = BLACK_ALPHA
    }
}
