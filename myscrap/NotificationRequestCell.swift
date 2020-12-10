//
//  NotificationRequestCell.swift
//  myscrap
//
//  Created by MyScrap on 7/7/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit


final class NotificationRequestCell: NotificationCell{
    
    var completion: ((Int, NotificationCell) -> ())?
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        acceptBtn.layer.cornerRadius = 5.0
        acceptBtn.clipsToBounds = true
        
        rejectBtn.layer.cornerRadius = 5.0
        rejectBtn.clipsToBounds = true
        rejectBtn.backgroundColor = UIColor.clear
        rejectBtn.setTitleColor(UIColor.MyScrapGreen, for: .normal)
        rejectBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
          rejectBtn.layer.borderWidth = 1
    }
    func configRequestCell(item: RequestNotificationItem){
        

        
        setAttributeStringLable(with: item)
        
        
        
        timeLabel.text = "\(item.time)"
        
        timeLabel.textColor = UIColor.gray
        
        profileView.updateViews(name: item.senderName, url: item.photos, colorCode: item.colorCode)
        
        if item.message.contains("comment"){
            
            notificationImg.image = #imageLiteral(resourceName: "ic_notification_comment")
        } else if item.message.contains("like"){
            
            notificationImg.image = #imageLiteral(resourceName: "ic_notification_like")
        } else {
            
            notificationImg.image = nil
        }
        
//        switch item.status {
//        case .seen:
//            self.backgroundColor = UIColor.BACKGROUND_GRAY
//            seperatorView.backgroundColor = UIColor.clear
//        default:
//            self.backgroundColor = UIColor.white
//            seperatorView.backgroundColor = UIColor.lightGray
//        }
        
    }
    
//    override func setAttributeString(with item: RequestNotificationItem) {
//
//        let str = NSMutableAttributedString(attributedString: NSAttributedString(string: item.message + "from ",attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
//        str.append(NSMutableAttributedString(string: item.senderName, attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size:17)!, NSAttributedString.Key.foregroundColor:UIColor.BLACK_ALPHA]))
//        notificationLbl.attributedText = str
//
//    }
     func setAttributeStringLable(with item: RequestNotificationItem) {
       
        
        let str = NSMutableAttributedString(attributedString: NSAttributedString(string: item.senderName, attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size:17)!, NSAttributedString.Key.foregroundColor:UIColor.BLACK_ALPHA]))
        
            str.append(NSMutableAttributedString(string:" " +  item.message,attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
                notificationLbl.attributedText = str
        
//           let str = NSMutableAttributedString(attributedString: NSAttributedString(string: item.message + "from ",attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
//           str.append(NSMutableAttributedString(string: item.senderName, attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size:17)!, NSAttributedString.Key.foregroundColor:UIColor.BLACK_ALPHA]))
        
           notificationLbl.attributedText = str
           
       }
    
    
    // 2 for accept and 4 for reject (setted as tag for button)
    @IBAction func actionBtnClicked(_ sender: UIButton) {
        completion?(sender.tag, self)
    }
    
}
