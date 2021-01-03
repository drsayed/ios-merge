//
//  RequestNotificationItem.swift
//  myscrap
//
//  Created by MS1 on 10/16/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation


class RequestNotificationItem{
    

    
    private var _userid:String!
    private var _senderName: String!
    private var _photos: String!
    private var _time: String!
    private var _message: String!
    private var _shortName: String!
    private var _colorCode: String!
    private var _friendId: String!
    private var _type: String!
    private var _status: String!
    private var _companyID: String!

    enum NotificationStatus: String {
        case seen
        case UnSeen
    }
    enum RequestType{
        case Card
        case Mobile
        case Follow
        case EmployeeRequest
    }
    
    
    
    var photos: String{ if _photos == nil ||  _photos == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || _photos == "https://myscrap.com/style/images/icons/profile.png" { _photos = ""}
        return _photos }
    
    var type: RequestType{
        if _type == "card"{
            //Redirects to Feed Post
            return .Card
        }
        else if _type == "follow"{
            //Redirects to Feed Post
            return .Follow
        }
        
        else if _type == "empReq" {
            return .EmployeeRequest
        }
        
            //Simpley redirects to Feeds
            //when 
            return .Mobile
        }
    
    
    
    var message:String{ if _message == nil { _message = ""}; return _message }
    var senderName:String{ if _senderName == nil { _senderName = ""}; return _senderName}
    var time:String{ if _time == nil { _time = "" }; return _time}
    var colorCode:String { if _colorCode == nil { _colorCode = "#000000"}; return _colorCode }
    var userid:String { if _userid == nil { _userid = ""}; return _userid }
    var shortName:String { if _shortName == nil { _shortName = ""}; return _shortName }
    var friendId:String { if _friendId == nil { _friendId = ""}; return _friendId }
    var companyID:String { if _companyID == nil { _companyID = ""}; return _companyID }
    var status: NotificationStatus{
        get {
            if _status == NotificationStatus.seen.rawValue {
                return .seen
            }
            return .UnSeen
        }
        set {
            _status = newValue.rawValue
        }
    }


    
    
    init (notificationDict:[String:AnyObject]){
        if let friendId = notificationDict["friendId"] as? String
        {
            self._friendId = friendId
            
        }
        if let postUserId = notificationDict["userId"] as? String
        {
            self._userid = postUserId
            
        }
        if let senderName = notificationDict["senderName"] as? String
        {
            self._senderName = senderName
            
        }
        if let colorCode = notificationDict["colorCode"] as? String{
            self._colorCode = colorCode
            
        }
        if let message = notificationDict["message"] as? String{
                   self._message = message
                   
               }
        if let photos = notificationDict["photos"] as? String{
                          self._photos = photos
                          
                      }
        if let shortName = notificationDict["shortName"] as? String{
                                 self._shortName = shortName
                                 
                             }
        if let time = notificationDict["time"] as? String{
                                       self._time = time
                                       
                                   }
        if let type = notificationDict["type"] as? String{
            self._type = type
            
        }
        if let status = notificationDict["status"] as? String{
                   self._status = status
                   
               }
        if let compId = notificationDict["companyId"] as? String{
                   self._companyID = compId
                   
               }

    }
    
}
