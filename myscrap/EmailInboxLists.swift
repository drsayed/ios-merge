//
//  EmailInboxLists.swift
//  myscrap
//
//  Created by MyScrap on 1/29/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

final class EmailInboxLists : Equatable{
    
    
    
    private var _listingId : String!
    private var _product : String!
    private var _isri_code : String!
    private var _quantity : String!
    private var _unit : String!
    var _opened : Bool!
    var mailData = [MailData]()
    
    var listingId:String{
        get {
            if _listingId == nil{ _listingId = "" } ; return _listingId
        }
        set {
            _listingId = listingId;
        }
        
    }
    var product:String{
        get {
            if _product == nil{ _product = "" } ; return _product
        }
        set {
            _product = product;
        }
        
    }
    var isri_code:String{
        get {
            if _isri_code == nil{ _isri_code = "" } ; return _isri_code
        }
        set {
            _isri_code = isri_code;
        }
        
    }
    var quantity:String{
        get {
            if _quantity == nil{ _quantity = "" } ; return _quantity
        }
        set {
            _quantity = quantity;
        }
        
    }
    var unit:String{
        get {
            if _unit == nil{ _unit = "" } ; return _unit
        }
        set {
            _unit = unit;
        }
        
    }
    
    static func == (lhs: EmailInboxLists, rhs: EmailInboxLists) -> Bool {
        return lhs.listingId == rhs.listingId
    }
    
    weak var eDelegate : EmailServiceDelegate?
    //var data = [MailData]()

    init(Dict:Dictionary<String,AnyObject>) {
        
        if let listingId = Dict["listingId"] as? String{
            self._listingId = listingId
        }
        if let product = Dict["product"] as? String{
            self._product = product
        }
        if let isri_code = Dict["isri_code"] as? String{
            self._isri_code = isri_code
        }
        if let quantity = Dict["quantity"] as? String{
            self._quantity = quantity
        }
        if let unit = Dict["unit"] as? String{
            self._unit = unit
        }
        self._opened = false
        
        if let mailObj = Dict["mailDatas"] as? [[String: AnyObject]]{
            for data in mailObj {
                let emailItems = MailData(dict: data)
                mailData.append(emailItems)
            }
        }
    }
}
class MailData{
    
    private var _userId : String!
    private var _subject : String!
    private var _message : String!
    private var _dateSent : String!
    

    var userId:String{
        get {
            if _userId == nil{ _userId = "" } ; return _userId
        }
        set {
            _userId = userId;
        }
        
    }
    var subject:String{
        get {
            if _subject == nil{ _subject = "" } ; return _subject
        }
        set {
            _subject = subject;
        }
        
    }
    var message:String{
        get {
            if _message == nil{ _message = "" } ; return _message
        }
        set {
            _message = message;
        }
        
    }
    var dateSent:String{
        get {
            if _dateSent == nil{ _dateSent = "" } ; return _dateSent
        }
        set {
            _dateSent = dateSent;
        }
        
    }

    init(dict: [String: AnyObject]){
        if let userId = dict["userId"] as? String{
            self._userId = userId
        }
        if let subject = dict["subject"] as? String{
            self._subject = subject
        }
        if let message = dict["message"] as? String{
            self._message = message
        }
        if let dateSent = dict["dateSent"] as? String{
            self._dateSent = dateSent
        }
    }
}
