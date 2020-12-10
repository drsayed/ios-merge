//
//  FeedTagListsDB.swift
//  myscrap
//
//  Created by MyScrap on 2/12/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
import RealmSwift

class FeedTagListsDB : Object {
    @objc dynamic var key_id = 1
    @objc dynamic var feedKey = "feedTagLists"
    @objc dynamic var feedString = ""
    
    
    static func create() -> FeedTagListsDB {
        let feedTagData = FeedTagListsDB()
        //feedData.key_id = lastId()
        return feedTagData
    }
}
