//
//  NotificationItem.swift
//  myscrap
//
//  Created by MS1 on 10/16/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation


class NotificationItem{
    
    private var _postId:String!
    private var _userid:String!
    private var _name: String!
    private var _active: String!
    private var _profilePic: String!
    private var _notificationTime: String!
    private var _notificationMessage: String!
    private var _notId: String!
    private var _posttype: String!
    private var _count: String!
    private var _bumpedId: String!
    private var _colorCode: String!
    private var _companyId: String!
    private var _listingId: String!
    private var _liveId: String!
    
    private var _chatRequestStatus: String?
    
    
    
    
    enum NotificationStatus: String {
        case seen
        case UnSeen
    }
    enum PostType{
        case Post
        case listing
        case marketmpost
        case numberaccept
        case cardaccept
        case number
        case card
        case cardreject
        case numberreject
        case User
        case user
        case live
        case other
    }
    
    
    var chatRequestStatus: MarketChatStatus{
        
        get {
            if let status = _chatRequestStatus, let intStatus = Int(status), let reqStatus = MarketChatStatus(rawValue: intStatus){
                return reqStatus
            }
            return .contact
        } set {
            _chatRequestStatus = "\(newValue.rawValue)"
        }
        
    }
    
    
    var active: NotificationStatus{
        get {
            if _active == NotificationStatus.seen.rawValue {
                return .seen
            }
            return .UnSeen
        }
        set {
            _active = newValue.rawValue
        }
    }

    
    var profilePic: String{ if _profilePic == nil ||  _profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || _profilePic == "https://myscrap.com/style/images/icons/profile.png" { _profilePic = ""}
        return _profilePic }

    var postType: PostType{
        print(_posttype)
        if _posttype == "post"{
            //Redirects to Feed Post
            return .Post
        } else if _posttype == "listing"{
            //Redirects to Market post
            return .listing
        }
        else if _posttype == "number"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .number
        }
        else if _posttype == "card"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .card
        }
        else if _posttype == "numberaccept"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .numberaccept
        }
        else if _posttype == "cardaccept"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .cardaccept
        }
        else if _posttype == "cardreject"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .cardreject
        }
        else if _posttype == "numberreject"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .numberreject
        }
        else if _posttype == "profile"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .User
        }
        else if _posttype == "market/mpost"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .marketmpost
        }
        else if _posttype.contains("market") || _posttype.contains("mpost") {
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .marketmpost
        }
       else if _posttype == "company" {
            //Redirects to company
            //Not implemented yet
            return .other   //For time being redirecting to FEEDS
        } else if _posttype == "User" {
            //Redirects unknown waiting for backend dev
            //Not implemented yet
            return .User
        //    return .other   //For time being redirecting to FEEDS
        }
        else if _posttype == "user" {
           //Redirects unknown waiting for backend dev
           //Not implemented yet
           return .user
       //    return .other   //For time being redirecting to FEEDS
       }
        else if _posttype == "live"{
            //Redirect to Profile
            //Combined of profilelike, favmem, view
            return .live
        }else {
            //Simpley redirects to Feeds
            //when 
            return .other
        }
    }
    
    
    var notificationMessage:String{ if _notificationMessage == nil { _notificationMessage = ""}; return _notificationMessage }
    var name:String{ if _name == nil { _name = ""}; return _name}
    var notificationTime:String{ if _notificationTime == nil { _notificationTime = "" }; return _notificationTime}
    var colorCode:String { if _colorCode == nil { _colorCode = "#000000"}; return _colorCode }
    var notId:String { if _notId == nil { _notId = ""}; return _notId }
    var postId:String { if _postId == nil { _postId = ""}; return _postId }
    var liveId:String { if _liveId == nil { _liveId = ""}; return _liveId }

    var userid:String { if _userid == nil { _userid = ""}; return _userid }
    var listingId :String { if _listingId == nil { _listingId = ""}; return _listingId!}

    
    
    init (notificationDict:[String:AnyObject]){
        if let postId = notificationDict["postId"] as? String{ self._postId = postId }
        if let postUserId = notificationDict["postUserId"] as? String{ self._userid = postUserId }
        if let postUserName = notificationDict["postUserName"] as? String{ self._name = postUserName }
        if let active = notificationDict["active"] as? String{ self._active = active }
        if let profilePic = notificationDict["profilePic"] as? String{ self._profilePic = profilePic }
        if let NotificationTime = notificationDict["NotificationTime"] as? String{ self._notificationTime = NotificationTime }
        if let notificationMessage = notificationDict["notificationMessage"] as? String{ self._notificationMessage = notificationMessage }
        if let not_id = notificationDict["not_id"] as? String{ self._notId = not_id }
        if let colorCode = notificationDict["colorCode"] as? String{ self._colorCode = colorCode }
        if let posttype = notificationDict["posttype"] as? String{ self._posttype = posttype }
        if let chatReqStatus = notificationDict["chatReqestStatus"] as? String { self._chatRequestStatus = chatReqStatus }
        if let listid = notificationDict["listingid"] as? String { self._listingId = listid }
        if let liveId = notificationDict["liveId"] as? String { self._liveId = liveId }

    }
    
}
