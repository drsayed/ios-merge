//
//  FeedLoadDB.swift
//  myscrap
//
//  Created by MyScrap on 7/29/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
import RealmSwift

class FeedLoadDB : Object {
    @objc dynamic var key_id = 1
    @objc dynamic var feedKey = "feed"
    @objc dynamic var feedString = ""
    
    
    static func create() -> FeedLoadDB {
        let feedData = FeedLoadDB()
        //feedData.key_id = lastId()
        return feedData
    }
    
}
