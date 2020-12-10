//
//  MarketSenderCell.swift
//  myscrap
//
//  Created by MyScrap on 8/17/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MarketSenderCell: BaseCell {
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var marketImageView: UIImageView!
    @IBOutlet weak var marketTypeLbl: UILabel!
    @IBOutlet weak var marketTitleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var readImageView: CircularImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        senderView.layer.cornerRadius = 5
        senderView.layer.masksToBounds = true
        
        innerView.layer.cornerRadius = 2
        innerView.clipsToBounds = true
        
        timeLbl.text = ""
        readImageView.tintColor = UIColor.GREEN_PRIMARY
        readImageView.backgroundColor = UIColor.clear
    }
    
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
    
}
