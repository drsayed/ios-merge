//
//  ChatCell.swift
//  myscrap
//
//  Created by MS1 on 9/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var readImgView: CircularImageView!
    
    /*var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            
            messageLabel.text = message?.text
            
            if let date = message?.date {
                
                let dateFormatter = DateFormatter ()
                dateFormatter.dateFormat = "h:mm a"
                
                let elapsedTimeInSeconds = NSDate().timeIntervalSince(date as Date)
                
                let secondInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > 7 * secondInDays {
                    dateFormatter.dateFormat = "dd/MM/yy"
                    
                } else if elapsedTimeInSeconds > secondInDays {
                    dateFormatter.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
    } */
    
    var message : Message?{
        didSet{
            nameLabel.text = message?.member?.name
            msgLbl.text = message?.text
            profileView.updateViews(name: (message?.member?.name)!, url: (message?.member?.profilePic)!, colorCode: (message?.member?.cCode)!
            )
            
        }
    }
}
