//
//  OnlinePresence.swift
//  myscrap
//
//  Created by MyScrap on 3/4/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class OnlinePresence {
    private var _userId : String!
    private var _first_name : String!
    private var _last_name : String!
    private var _rank : String!
    private var _colorcode : String!
    private var _profilePic : String!
    
    var userId:String{
        get {
            if _userId == nil{ _userId = "" } ; return _userId
        }
        set {
            _userId = userId;
        }
        
    }
    var first_name:String{
        get {
            if _first_name == nil{ _first_name = "" } ; return _first_name
        }
        set {
            _first_name = first_name;
        }
        
    }
    var last_name:String{
        get {
            if _last_name == nil{ _last_name = "" } ; return _last_name
        }
        set {
            _last_name = last_name;
        }
        
    }
    var rank:String{
        get {
            if _rank == nil{ _rank = "" } ; return _rank
        }
        set {
            _rank = rank;
        }
    }
    var colorcode:String{
        get {
            if _colorcode == nil{ _colorcode = "" } ; return _colorcode
        }
        set {
            _colorcode = colorcode;
        }
    }
    var profilePic:String{
        get {
            if _profilePic == nil{ _profilePic = "" } ; return _profilePic
        }
        set {
            _profilePic = profilePic;
        }
    }
    
    init(dict : [String:AnyObject]) {
        if let userId = dict["userId"] as? String{
            self._userId = userId
        }
        if let first_name = dict["first_name"] as? String{
            self._first_name = first_name
        }
        if let last_name = dict["last_name"] as? String{
            self._last_name = last_name
        }
        if let rank = dict["rank"] as? String{
            self._rank = rank
        }
        if let colorcode = dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let profilePic = dict["profilePic"] as? String{
            self._profilePic = profilePic
        }
    }
}
