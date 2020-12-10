//
//  NotificationCell.swift
//  myscrap
//
//  Created by MS1 on 5/31/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    

    @IBOutlet weak var notificationLbl:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var notificationImg: CircularImageView!
    @IBOutlet weak var seperatorView: SeperatorView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        timeLabel.font = UIFont(name: "HelveticaNeue", size:13)
        
        notificationImg.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(item: NotificationItem){
        

        
        setAttributeString(with: item)
        
        
        
        timeLabel.text = "\(item.notificationTime)"
        
        timeLabel.textColor = UIColor.gray
        
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
        
        if item.notificationMessage.contains("comment"){
            
            notificationImg.image = #imageLiteral(resourceName: "ic_notification_comment")
        } else if item.notificationMessage.contains("like"){
            
            notificationImg.image = #imageLiteral(resourceName: "ic_notification_like")
        } else {
            
            notificationImg.image = nil
        }
        
        switch item.active {
        case .seen:
            self.backgroundColor = UIColor.BACKGROUND_GRAY
            seperatorView.backgroundColor = UIColor.clear
        default:
            self.backgroundColor = UIColor.white
            seperatorView.backgroundColor = UIColor.clear
        }
        
    }
    
    func setAttributeString(with item: NotificationItem){
        
        if item.postType == .listing {
            
            if item.chatRequestStatus == .accepted {
                
                let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "You Accepted chat Request for", attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
                attributedString.append(NSAttributedString(string: " \(item.name) ", attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size:17)!, NSAttributedString.Key.foregroundColor:UIColor.BLACK_ALPHA]))
                attributedString.append(NSAttributedString(string: "on Listing Id \(item.listingId ?? "") ", attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
                notificationLbl.attributedText = attributedString
                
            } else if item.chatRequestStatus == .rejected {
                let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "You Rejected chat Request for", attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
                attributedString.append(NSAttributedString(string: " \(item.name) ", attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size:17)!, NSAttributedString.Key.foregroundColor:UIColor.BLACK_ALPHA]))
                attributedString.append(NSAttributedString(string: "on Listing Id \(item.listingId ?? "") ", attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
                notificationLbl.attributedText = attributedString
            } else {
                
                print(item.chatRequestStatus.stringReprsentation)
                notificationLbl.attributedText = NSAttributedString(string: "")
            }
            
            
        } else {
            let attrString = NSMutableAttributedString(string: "\(item.name) ", attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size:17)!, NSAttributedString.Key.foregroundColor:UIColor.BLACK_ALPHA])
            
            attrString.append(NSAttributedString(string: item.notificationMessage, attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
            
            notificationLbl.attributedText = attrString
        }
        
        
        
    }
}
