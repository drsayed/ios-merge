//
//  NotificationListingCell.swift
//  myscrap
//
//  Created by MyScrap on 7/7/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit


final class NotificationListingCell: NotificationCell{
    
    var completion: ((Int, NotificationCell) -> ())?
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        acceptBtn.layer.cornerRadius = 3.0
        acceptBtn.clipsToBounds = true
        
        rejectBtn.layer.cornerRadius = 3.0
        rejectBtn.clipsToBounds = true
    }

    
    override func setAttributeString(with item: NotificationItem) {
    
        let str = NSMutableAttributedString(attributedString: NSAttributedString(string: item.notificationMessage + "from ",attributes: [NSAttributedString.Key.font: UIFont(name:"HelveticaNeue", size:14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
        str.append(NSMutableAttributedString(string: item.name, attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size:17)!, NSAttributedString.Key.foregroundColor:UIColor.BLACK_ALPHA]))
        notificationLbl.attributedText = str
        
    }
    
    
    // 2 for accept and 4 for reject (setted as tag for button)
    @IBAction func actionBtnClicked(_ sender: UIButton) {
        completion?(sender.tag, self)
    }
    
}
