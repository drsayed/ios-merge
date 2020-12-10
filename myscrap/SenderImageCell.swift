//
//  SenderImageCell.swift
//  myscrap
//
//  Created by MS1 on 11/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class SenderImageCell: BaseCell {
    
    @IBOutlet weak var imageView: ChatImageView!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var readImageView : CircularImageView!
    
    var lastSeen = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        readImageView.tintColor = UIColor.GREEN_PRIMARY
        imageView.addGestureRecognizer(tap)
    }
    
     weak var tapDelegate : ChatTappedDelegate?
    
    func configCell(item:Message, isLastSeen: Bool){
        lastSeen = isLastSeen
        
        let imageURL = "https://myscrap.com/newchat/new/chatimage/\(item.imageURL ?? " ")"
        if let url = URL(string: imageURL){
            readImageView.sd_setImage(with: url, completed: nil)
        } else {
            imageView.image = nil
        }
        if let status = item.status{
            setReadImage(date: item.date, status: status, imageURL: item.member?.profilePic ?? "")
        } else {
            setReadImage(date: item.date, status: "", imageURL: item.member?.profilePic ?? "")
        }
    }
    
    func setReadImage(date: Date? ,status: String, imageURL: String){
        let sent = #imageLiteral(resourceName: "msg_sent").withRenderingMode(.alwaysTemplate)
        let delivered = #imageLiteral(resourceName: "msg_delivered").withRenderingMode(.alwaysTemplate)
        if status == "2"{
            timeLbl.text = "Delivered"
            readImageView.backgroundColor = UIColor.clear
            readImageView.image = delivered
        } else if status == "3"{
            timeLbl.text = "Seen"
            if self.lastSeen{
            
                readImageView.backgroundColor = UIColor.GREEN_PRIMARY
                if let url = URL(string: imageURL){
                    readImageView.sd_setImage(with: url, completed: nil)
                } else {
                    readImageView.image = nil
                }

            } else {
                readImageView.backgroundColor = UIColor.clear
                readImageView.image = nil
            }
        } else {
            timeLbl.text = "Sent"
            readImageView.backgroundColor = UIColor.clear
            readImageView.image = sent
        }
    }

    
    func setMsgStatus(status: String) {
//        let offline = #imageLiteral(resourceName: "time01").withRenderingMode(.alwaysTemplate)
//        let sent = #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysTemplate)
//        let received = #imageLiteral(resourceName: "double_tick_chat").withRenderingMode(.alwaysTemplate)
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
    
    
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer){
        tapDelegate?.DidTappedImage(cell: self)
    }
}
