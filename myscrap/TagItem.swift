//
//  TagItem.swift
//  myscrap
//
//  Created by MS1 on 12/5/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

class TagItem {
    var taggedId: String?
    var taggedName: String?
    
    
    init(Dict:[String:AnyObject]) {
        if let id = Dict["taggedId"] as? String{
            self.taggedId = id
        }
        if let name = Dict["taggedUserName"] as? String{
            self.taggedName = name
        }
     }
}
