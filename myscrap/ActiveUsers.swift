//
//  ActiveUsers.swift
//  myscrap
//
//  Created by MyScrap on 4/25/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
class ActiveUsers{
    
    var colorCode: String?
    var country: String?
    var designation: String?
    var friendcount: String?
    var jId: String?
    var lastActive: String?
    var moderator: String?
    var name : String?
    var newJoined: Bool = false
    var online : Bool = false
    var points: String?
    var profilePic: String?
    var rank: String?
    var userCompany: String?
    var userid : String?
    var isLevel: Bool?
    var level: String?
    var live: Bool?
    var liveId: String?
    var topic: String?
    var liveType: String?
    
    
    init(dict: [String: AnyObject]) {
        
        if let colorCode = dict["colorCode"] as? String{
            self.colorCode = colorCode
        }
        if let country = dict["country"] as? String{
            self.country = country
        }
        if let designation = dict["designation"] as? String{
            self.designation = designation
        }
        if let friendcount = dict["friendcount"] as? String{
            self.friendcount = friendcount
        }
        if let jId = dict["jId"] as? String{
            self.jId = jId
        }
        if let lastactive = dict["lastActive"] as? String{
            self.lastActive = lastactive
        }
        if let moderator = dict["moderator"] as? String{
            self.moderator = moderator
        }
        if let name = dict["name"] as? String{
            self.name = name
        }
        if let newJoined = dict["newJoined"] as? Bool{
            self.newJoined = newJoined
        }
        if let online = dict["online"] as? Bool{
            self.online = online
        }
        if let points = dict["points"] as? String{
            self.points = points
        }
        if let profilePic = dict["profilePic"] as? String{
            self.profilePic =  profilePic
        }
        if let rank = dict["rank"] as? String{
            self.rank =  rank
        }
        if let userCompany = dict["userCompany"] as? String{
            self.userCompany =  userCompany
        }
        
        if let userid = dict["userid"] as? String{
            self.userid = userid
        }
        
        if let isLevel = dict["isLevel"] as? Bool {
            self.isLevel = isLevel
        }
        
        if let level = dict["level"] as? String {
            self.level = level
        }
        if let live = dict["live"] as? Bool {
            self.live = live
        }
        if let liveId = dict["liveid"] as? String{
            self.liveId = liveId
        }
        if let topic = dict["topic"] as? String{
            self.topic = topic
        }
        if let liveType = dict["liveType"] as? String{
            self.liveType = liveType
        }
        
    }
}
