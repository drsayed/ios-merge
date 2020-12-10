//
//  UserPrivChat.swift
//  myscrap
//
//  Created by MyScrap on 4/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
import RealmSwift
class UserPrivChat : Object {
   // @objc dynamic var key_id = 1
    @objc dynamic var messageID = ""
    @objc dynamic var conversationId = ""
    @objc dynamic var fromJID = ""
    @objc dynamic var toJID = ""
    @objc dynamic var body = ""
    @objc dynamic var timeStamp = ""
    @objc dynamic var time = ""
    @objc dynamic var fromUserId = ""
    @objc dynamic var toUserId = ""
    @objc dynamic var fromUserName = ""
    @objc dynamic var toUserName = ""
    @objc dynamic var fromImageUrl = ""
    @objc dynamic var toImageUrl = ""
    @objc dynamic var fromColorCode = ""
    @objc dynamic var toColorCode = ""
    @objc dynamic var stanza = ""
    @objc dynamic var signalId = ""
    @objc dynamic var messageType = ""
    @objc dynamic var offlineFlag = false   //offline message
    @objc dynamic var syncFlag = false      //sent
    @objc dynamic var readCount = 0         //Message unread
    @objc dynamic var msgStatus = "offline"        //offline/sent/received
    
    //Market POST
    @objc dynamic var stanzaType = ""       //type must be ""
    @objc dynamic var type = ""           //Buy/Sell
    @objc dynamic var title = ""
    @objc dynamic var rate = ""
    @objc dynamic var listingId = ""
    @objc dynamic var marketUrl = ""
   
    
    
    /*override static func primaryKey() -> String? {
        return "key_id"
    }
    
    static func create() -> UserPrivChat {
        let chat = UserPrivChat()
        chat.key_id = lastId()
        return chat
    }
    
    static func lastId() -> Int {
        if let auto_id = uiRealm.objects(UserPrivChat.self).last {
            return auto_id.key_id + 1
        } else {
            return 1
        }
    }*/
}
