//
//  ReceiverCell.swift
//  myscrap
//
//  Created by MS1 on 9/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ReceiverCell: BaseCell {
    

    
    weak var tapDelegate: ChatTappedDelegate?
    var lastSeen = false

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var receiverView: ReceiverView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var readImageView: CircularImageView!
    
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(receiverTapped(_:)))
        tap.numberOfTapsRequired = 1
        receiverView.addGestureRecognizer(tap)
        statusLbl.text = ""
        readImageView.backgroundColor = UIColor.clear
    }
    @objc private func receiverTapped(_ sender: UITapGestureRecognizer){
        if let delegate = tapDelegate{
            delegate.DidTappedView(cell: self)
        }
    }
    func configReceiver(message: Message,isLastSeen:Bool){
        lastSeen = isLastSeen
        messageLabel.text = message.text
        if let date = message.date{
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "hh:mm a"
            } /*else if calendar.isDateInWeekend(date){
                dateFormatter.dateFormat = "E hh:mm a"
            } */
            else {
                dateFormatter.dateFormat = "MMM dd hh:mm a"
            }
            statusLbl.text = dateFormatter.string(from: date)
            
            if let status = message.status{
               self.setReadImageView(status: status, imageURL: message.member?.profilePic ?? "")
            } else {
               self.setReadImageView(status: "1", imageURL: message.member?.profilePic ?? "")
            }
        }
    }
    
    private func setReadImageView(status: String , imageURL: String){
        if status == "3"{
            if lastSeen{
                readImageView.backgroundColor = UIColor.GREEN_PRIMARY
                readImageView.setImageWithIndicator(imageURL: imageURL)
            } else {
                readImageView.backgroundColor = UIColor.clear
                readImageView.image = nil
            }
        }
    }
}
