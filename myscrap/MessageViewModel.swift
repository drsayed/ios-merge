//
//  MessageViewModel.swift
//  myscrap
//
//  Created by MyScrap on 4/22/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


class MessageViewModel {
    
    enum Status: Int{
        case send = 0
        case seen = 1
    }
    
    let msgId: String
    
    let text: String
    
    let name: String
    
    let colorCode: String
    
    let date : Date
    
    let isSender: Bool
    
    let profilePic : String
    
    let jid: String
    
    let userId: String
    
    let status : Status
    
    init(text: String, name: String, colorCode:String, date: Date, isSender: Bool, profilePic: String, jid: String, msgId: String, userId: String, status: Int) {
        self.text = text
        self.name = name
        self.colorCode = colorCode
        self.date = date
        self.isSender = isSender
        self.profilePic = profilePic
        self.jid = jid
        self.msgId = msgId
        self.userId = userId
        self.status = Status(rawValue: status) ?? .send
    }
    
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
    
}



extension MessageViewModel: Equatable {
    static func == (lhs: MessageViewModel, rhs: MessageViewModel) -> Bool {
        return (lhs.jid == rhs.jid) || (lhs.userId == rhs.userId)
    }
}
