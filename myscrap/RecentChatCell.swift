
//  Copyright © 2018 MyScrap. All rights reserved.

import UIKit

class RecentChatCell: BaseTVC {

    var viewModel: MessageViewModel? {
        didSet{
            guard let message = viewModel else { return }
            config(message)
        }
    }
    
    
    var memberViewModel: MemberViewModel? {
        didSet{
            guard let message = memberViewModel else { return }
            setMessage(viewModel: message)
        }
    }
    
    var memberItem: MemberItem? {
        didSet{
            guard let message = memberItem else { return }
            setMember(viewModel: message)
        }
    }
    
    
    private func setMessage(viewModel: MemberViewModel){
        profileView.updateViews(name: viewModel.name, url: viewModel.profilePic, colorCode: viewModel.colorCode)
        nameLabel.text = viewModel.name
        msgLbl.text = viewModel.designation
        timeLbl.text = ""
    }
    
    private func setMember(viewModel: MemberItem){
        profileView.updateViews(name: viewModel.name, url: viewModel.profilePic, colorCode: viewModel.colorCode)
        nameLabel.text = viewModel.name
        msgLbl.text = viewModel.designation
        timeLbl.text = ""
        badgeLbl.isHidden = true 
    }
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var readImgView: CircularImageView!
    @IBOutlet weak var badgeLbl: BadgeSwift!
    
    
    private func config(_ message: MessageViewModel){
        profileView.updateViews(name: message.name, url: message.profilePic, colorCode: message.colorCode)
        nameLabel.text = message.name
        msgLbl.text = message.text
        
        print("message status" , message.status.rawValue)
        
        if !message.isSender && message.status == .send {
            msgLbl.font = UIFont.boldSystemFont(ofSize: 17)
            nameLabel.font =  UIFont.boldSystemFont(ofSize: 17)
        } else {
            msgLbl.font = UIFont.systemFont(ofSize: 17)
            nameLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        timeLbl.text = message.dateString
    }

    //MARK:- SETTING READIMAGEVIEW AND STATUSLABEL
    func setRead(status: Bool){
        let notDelivered = #imageLiteral(resourceName: "time01").withRenderingMode(.alwaysTemplate)
        let delivered = #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysTemplate)
        // status = 0 message sent if status = 1 message not sent still offlint
        if status == true {
            
//            readImgView.tintColor = UIColor(hexString: "#7a7a7a")
            readImgView.image = notDelivered  // time
        } else {
            readImgView.tintColor = UIColor(hexString: "#7a7a7a")
            readImgView.image = delivered
        }
    }
    func setMsgStatus(status: String) {
        let offline = #imageLiteral(resourceName: "time01").withRenderingMode(.alwaysTemplate)
        let sent = #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysTemplate)
        let received = #imageLiteral(resourceName: "double_tick_chat").withRenderingMode(.alwaysTemplate)
        // status = 0 message sent if status = 1 message not sent still offlint
        if status == "offline" {
            
            readImgView.tintColor = UIColor(hexString: "#7a7a7a")
            readImgView.image = offline  // time
        } else if status == "sent" {
            readImgView.tintColor = UIColor(hexString: "#7a7a7a")
            readImgView.image = sent
        } else {
            readImgView.tintColor = UIColor.MyScrapGreen
            readImgView.image = received
        }
    }
    
}

