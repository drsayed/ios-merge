//
//  EmailInboxCell.swift
//  myscrap
//
//  Created by MyScrap on 1/29/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class EmailInboxCell: UITableViewCell {

    weak var delegate: EmailDelegate?
    
//    var emailList: EmailInboxLists?{
//        didSet{
//            if let item = emailList, let value = item.mailData{
//                configCell(with: value)
//            }
//        }
//    }
    
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var msgPreviewLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//
//    private func configCell(with item : MailData){
//        userLbl.text = "Anonymous User "
//        dateLbl.textColor = .darkGray
//        dateLbl.text = item.dateSent
//        subjectLbl.textColor = .lightGray
//        subjectLbl.text = item.subject
//        msgPreviewLbl.textColor = .lightGray
//        msgPreviewLbl.text = item.message
//        
//    }
}
