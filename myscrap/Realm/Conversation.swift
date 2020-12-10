//
//  Conversation.swift
//  myscrap
//
//  Created by MyScrap on 4/16/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import RealmSwift

class Conversation : Object {
    @objc dynamic var msgId = 1
    @objc dynamic var fromID = ""
    @objc dynamic var toID = ""
    @objc dynamic var fromJID = ""
    @objc dynamic var toJID = ""
    @objc dynamic var fromImage = ""
    @objc dynamic var toImage = ""
    @objc dynamic var fromName = ""
    @objc dynamic var toName = ""
    @objc dynamic var fromColor = ""
    @objc dynamic var toColor = ""
    @objc dynamic var message = ""
    @objc dynamic var sync = false
    
    override static func primaryKey() -> String? {
        return "msgId"
    }
    
    static func create() -> Conversation {
        let user = Conversation()
        user.msgId = lastId()
        return user
    }
    
    static func lastId() -> Int {
        if let auto_id = uiRealm.objects(Conversation.self).last {
            return auto_id.msgId + 1
        } else {
            return 1
        }
    }
}
