//
//  RoasterItems.swift
//  myscrap
//
//  Created by MyScrap on 4/21/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

/*First time while login the app this api get called
 Get data from API and stores into Realm DB */

import Foundation

class RoasterItems {
    private var _conversationId : String!
    private var _fromJID : String!
    private var _toJID : String!
    private var _body : String!
    private var _stanza : String!
    private var _userId : String!
    private var _fromId : String!
    private var _uImage : String!
    private var _fImage : String!
    private var _uName : String!
    private var _fName : String!
    private var _uColor : String!
    private var _fColor : String!
    private var _messageID : String!
    private var _type : String!
    private var _messageTime : String!
    private var _messageTimeMM : String!
    
    //Sent and Receive time handling
    private var _sentReceiveTimeStamp : String!
    
    //Market data
    private var _stanzaType : String!
    private var _marketUrl : String!
    
    
    var conversationId:String{
        get {
            if _conversationId == nil{ _conversationId = "" } ; return _conversationId
        }
        set {
            _conversationId = newValue;
        }
        
    }
    var fromJID:String{
        get {
            if _fromJID == nil{ _fromJID = "" } ; return _fromJID
        }
        set {
            _fromJID = newValue;
        }
        
    }
    var toJID:String{
        get {
            if _toJID == nil{ _toJID = "" } ; return _toJID
        }
        set {
            _toJID = newValue;
        }
        
    }
    var body:String{
        get {
            if _body == nil{ _body = "" } ; return _body
        }
        set {
            _body = newValue;
        }
        
    }
    var stanza:String{
        get {
            if _stanza == nil{ _stanza = "" } ; return _stanza
        }
        set {
            _stanza = newValue;
        }
        
    }
    var userId:String{
        get {
            if _userId == nil{ _userId = "" } ; return _userId
        }
        set {
            _userId = newValue;
        }
        
    }
    var fromId:String{
        get {
            if _fromId == nil{ _fromId = "" } ; return _fromId
        }
        set {
            _fromId = newValue;
        }
        
    }
    var uImage:String{
        get {
            if _uImage == nil{ _uImage = "" } ; return _uImage
        }
        set {
            _uImage = newValue;
        }
        
    }
    var fImage:String{
        get {
            if _fImage == nil{ _fImage = "" } ; return _fImage
        }
        set {
            _fImage = newValue;
        }
        
    }
    var uName:String{
        get {
            if _uName == nil{ _uName = "" } ; return _uName
        }
        set {
            _uName = newValue;
        }
        
    }
    var fName:String{
        get {
            if _fName == nil{ _fName = "" } ; return _fName
        }
        set {
            _fName = newValue;
        }
        
    }
    var uColor:String{
        get {
            if _uColor == nil{ _uColor = "" } ; return _uColor
        }
        set {
            _uColor = newValue;
        }
        
    }
    var fColor:String{
        get {
            if _fColor == nil{ _fColor = "" } ; return _fColor
        }
        set {
            _fColor = newValue;
        }
        
    }
    var messageID:String{
        get {
            if _messageID == nil{ _messageID = "" } ; return _messageID
        }
        set {
            _messageID = newValue;
        }
        
    }
    var type:String{
        get {
            if _type == nil{ _type = "" } ; return _type
        }
        set {
            _type = newValue;
        }
        
    }
    var messageTime:String{
        get {
            if _messageTime == nil{ _messageTime = "" } ; return _messageTime
        }
        set {
            _messageTime = newValue;
        }
    }
    var messageTimeMM:String{
        get {
            if _messageTimeMM == nil{ _messageTimeMM = "" } ; return _messageTimeMM
        }
        set {
            _messageTimeMM = newValue;
        }
    }
    
    //Market data
    var stanzaType:String{
        get {
            if _stanzaType == nil{ _stanzaType = "" } ; return _stanzaType
        }
        set {
            _stanzaType = newValue;
        }
    }
    var marketUrl:String{
        get {
            if _marketUrl == nil{ _marketUrl = "" } ; return _marketUrl
        }
        set {
            _marketUrl = newValue;
        }
    }
    var sentReceiveTimeStamp: String {
        get {
            if _sentReceiveTimeStamp == nil { _sentReceiveTimeStamp = "" }; return _sentReceiveTimeStamp
        }
        set {
            _sentReceiveTimeStamp = newValue
        }
    }
    /*var listingImage:String{
     get {
     if _listingImage == nil{ _listingImage = [""] } ; return _listingImage
     }
     set {
     _listingImage = newValue;
     }
     
     }*/
    
    init(Dict:Dictionary<String,AnyObject>) {
        if let conversationId = Dict["conversationId"] as? String{
            self._conversationId = conversationId
        }
        if let fromJID = Dict["fromJID"] as? String{
            self._fromJID = fromJID
        }
        if let toJID = Dict["toJID"] as? String{
            self._toJID = toJID
        }
        if let body = Dict["body"] as? String{
            self._body = body
        }
        if let stanza = Dict["stanza"] as? String{
            self._stanza = stanza
        }
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        if let fromId = Dict["fromId"] as? String{
            self._fromId = fromId
        }
        if let uImage = Dict["uImage"] as? String{
            self._uImage = uImage
        }
        if let fImage = Dict["fImage"] as? String{
            self._fImage = fImage
        }
        if let uName = Dict["uName"] as? String{
            self.uName = uName
        }
        if let fName = Dict["fName"] as? String{
            self._fName = fName
        }
        if let uColor = Dict["uColor"] as? String{
            self._uColor = uColor
        }
        if let fColor = Dict["fColor"] as? String{
            self._fColor = fColor
        }
        if let messageID = Dict["messageID"] as? String{
            self._messageID = messageID
        }
        if let type = Dict["type"] as? String{
            self._type = type
        }
        if let messageTime = Dict["messageTime"] as? String {
            self._messageTime = messageTime
        }
        if let messageTimeMM = Dict["messageTimeMM"] as? String {
            self._messageTimeMM = messageTimeMM
        }
        if let stanzaType = Dict["stanzaType"] as? String {
            self._stanzaType = stanzaType
        }
        if let marketUrl = Dict["marketUrl"] as? String {
            self._marketUrl = marketUrl
        }
        
        //Sending and receiving message time handling
        if let sentReceiveTimeStamp = Dict["sentReceiveTimeStamp"] as? String {
            self._sentReceiveTimeStamp = sentReceiveTimeStamp
        }
    }
}
