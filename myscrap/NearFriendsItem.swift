//
//  NearFriendsItem.swift
//  myscrap
//
//  Created by MS1 on 10/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
final class NearFriendsItem{
    private var _userid:String!
    private var _name:String!
    private var _friendcount:String!
    private var _profilePic:String!
    private var _colorCode:String!
    private var _online:Bool!
    private var _rank:String!
    private var _new:Bool!
    
    var new:Bool{
        if _new == nil{ _new = false } ; return _new
    }
    
    
    var rank:Int{ if _rank == nil { _rank = "1000" } ; return Int(_rank)! }
    var online:Bool{ if _online == nil{ _online =  false }; return _online }
    var colorCode:String{ if _colorCode == nil{ _colorCode = "#ffffff" }; return _colorCode }
    var userid:String{ if _userid == nil{ _userid = "" };return _userid }
    var name:String{ if _name == nil{ _name = "" }; return _name }
    var friendCount:String{ if _friendcount == nil{ _friendcount = "0" }; return _friendcount }
    var profilePic:String{
        if _profilePic == nil || _profilePic == "https://myscrap.com/style/images/icons/profile.png" || _profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" { _profilePic = "" }
        return _profilePic
    }
    
    
    init(nearDict:Dictionary<String,AnyObject>){
        if let userid = nearDict["userid"] as? String{
            self._userid = userid
        }
        if let name = nearDict["name"] as? String{
            self._name = name
        }
        if let friendCount = nearDict["friendCount"] as? String{
            self._friendcount = friendCount
        }
        if let profilePic = nearDict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let colorcode = nearDict["colorCode"] as? String{
            self._colorCode = colorcode
        }
        if let online = nearDict["online"] as? Bool{
            self._online = online
        }
        if let rank = nearDict["rank"] as? String{
            self._rank = rank
        }
        if let newJoined = nearDict["newJoined"] as? Bool{
            self._new = newJoined
        }
    }
}
