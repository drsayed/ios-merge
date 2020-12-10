 //
//  RecentChatCell.swift
//  myscrap
//
//  Created by MS1 on 9/19/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

 
 
 /*
class RecentChatCell: UITableViewCell {
    
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var readImgView: CircularImageView!
    
    
    var message : Message?{
        didSet{
            
            guard let msg = message else { return }
            nameLabel.text = msg.member?.name
            if msg.messageType == "2" {
                if msg.isSender{
                    msgLbl.text = "You sent an image"
                } else {
                    msgLbl.text = "\(msg.member?.name ?? "") sent an image"
                }
            } else {
                msgLbl.text = msg.text
            }
            
            
            profileView.updateViews(name: (msg.member?.name)!, url: msg.member?.profilePic ?? "", colorCode: msg.member?.colorCode ?? "")
            setReadImagView(isSender: msg.isSender, status: msg.status ?? "3", imageURL: msg.member?.profilePic ?? "", colorCode: msg.member?.colorCode ?? "")
            if let date = msg.date {
                updateDateLbl(date: date)
            }
            
            
        }
    }
    
    // MARK:- UPDATE READIMAGE VIEW
    private func setReadImagView(isSender:Bool, status: String, imageURL: String, colorCode: String){
        let sendImage = #imageLiteral(resourceName: "msg_sent").withRenderingMode(.alwaysTemplate)
        let deliveredImage = #imageLiteral(resourceName: "msg_delivered").withRenderingMode(.alwaysTemplate)
        if !isSender{
            readImgView.backgroundColor = nil
            readImgView.image = nil
        } else {
            if status == "2" {
                readImgView.backgroundColor = UIColor.clear
                readImgView.image = deliveredImage
            } else if status == "3"{
                readImgView.backgroundColor = UIColor(hexString: colorCode)
                if let url = URL(string: imageURL){
                    readImgView.sd_setImage(with: url, completed: nil)
                } else {
                    readImgView.image = nil
                }
            } else {
                readImgView.backgroundColor = UIColor.clear
                readImgView.image = sendImage
            }
        }
    }
    
    
    //MARK:- UPDATING DATE LABEL
    private func updateDateLbl(date: Date){
        let dateformatter = DateFormatter()
        if Calendar.current.isDateInToday(date as Date){
            dateformatter.dateFormat = "h:mm"
        } else {
            dateformatter.dateFormat = "MMM dd"
        }
        timeLbl.text = dateformatter.string(from: date as Date)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.textColor = UIColor.darkGray
        nameLabel.font = Fonts.NAME_FONT
        msgLbl.textColor = UIColor.darkGray
        msgLbl.font = Fonts.descriptionFont
        timeLbl.font = UIFont(name: "HelveticaNeue", size: 11)
        timeLbl.textColor = UIColor.darkGray
        readImgView.tintColor = Colors.GREEN_PRIMARY
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}    */
