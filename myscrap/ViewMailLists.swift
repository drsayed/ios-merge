//
//  ViewMailLists.swift
//  myscrap
//
//  Created by MyScrap on 2/7/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class ViewMailLists {
    var _opened : Bool!
    private var _id : String!
    private var _listing_id : String!
    private var _from_user_id : String!
    private var _to_user_id : String!
    private var _mail_subject : String!
    private var _message_plain_text : String!
    private var _createDate : String!
    private var _messageType : String!
    
    var id:String{
        get {
            if _id == nil{ _id = "" } ; return _id
        }
        set {
            _id = id;
        }
        
    }
    var listing_id:String{
        get {
            if _listing_id == nil{ _listing_id = "" } ; return _listing_id
        }
        set {
            _listing_id = listing_id;
        }
        
    }
    var from_user_id:String{
        get {
            if _from_user_id == nil{ _from_user_id = "" } ; return _from_user_id
        }
        set {
            _from_user_id = from_user_id;
        }
        
    }
    var to_user_id:String{
        get {
            if _to_user_id == nil{ _to_user_id = "" } ; return _to_user_id
        }
        set {
            _to_user_id = to_user_id;
        }
        
    }
    var mail_subject:String{
        get {
            if _mail_subject == nil{ _mail_subject = "" } ; return _mail_subject
        }
        set {
            _mail_subject = mail_subject;
        }
        
    }
    var message_plain_text:String{
        get {
            if _message_plain_text == nil{ _message_plain_text = "" } ; return _message_plain_text
        }
        set {
            _message_plain_text = message_plain_text;
        }
        
    }
    var createDate:String{
        get {
            if _createDate == nil{ _createDate = "" } ; return _createDate
        }
        set {
            _createDate = createDate;
        }
        
    }
    var messageType:String{
        get {
            if _messageType == nil{ _messageType = "" } ; return _messageType
        }
        set {
            _messageType = messageType;
        }
        
    }
    
    init(Dict:Dictionary<String,AnyObject>) {
        self._opened = false
        if let id = Dict["id"] as? String{
            self._id = id
        }
        if let listing_id = Dict["listing_id"] as? String{
            self._listing_id = listing_id
        }
        if let from_user_id = Dict["from_user_id"] as? String{
            self._from_user_id = from_user_id
        }
        if let to_user_id = Dict["to_user_id"] as? String{
            self._to_user_id = to_user_id
        }
        if let mail_subject = Dict["mail_subject"] as? String{
            self._mail_subject = mail_subject
        }
        if let message_plain_text = Dict["message_plain_text"] as? String{
            self._message_plain_text = message_plain_text
        }
        if let createDate = Dict["createDate"] as? String{
            self._createDate = createDate
        }
        if let messageType = Dict["messageType"] as? String{
            self._messageType = messageType
        }
    }
}
