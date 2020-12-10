//
//  ViewListingItems.swift
//  myscrap
//
//  Created by MyScrap on 2/21/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class ViewListingItems {
    private var _listingId : String!
    private var _userId : String!
    private var _listingTitle : String!
    private var _listingType : String!
    private var _description : String!
    private var _listingProductName : String!
    private var _listingIsriCodeID : String!
    private var _listingIsriCode : String!
    private var _totalView : String!
    private var _paymentTerms : String!
    private var _shipmentTerm : String!
    private var _quantity : String!
    private var _portID : String!
    private var _portName : String!
    private var _isFav : Bool!
    private var _priceTerms : String!
    private var _commodity : String!
    private var _packaging : String!
    private var _countryID : String!
    private var _countryName : String!
    private var _flagCode : String!
    private var _duration : String!
    private var _timeDuration : String!
    private var _rate : String!
    private var _anonymous : String!
    var user_data = [PostedUserData]()
    
    
    var listingId:String{
        get {
            if _listingId == nil{ _listingId = "" } ; return _listingId
        }
        set {
            _listingId = listingId;
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
    var listingTitle:String{
        get {
            if _listingTitle == nil{ _listingTitle = "" } ; return _listingTitle
        }
        set {
            _listingTitle = newValue;
        }
        
    }
    var listingType:String{
        get {
            if _listingType == nil{ _listingType = "" } ; return _listingType
        }
        set {
            _listingType = newValue;
        }
        
    }
    var paymentTerms:String{
        get {
            if _paymentTerms == nil{ _paymentTerms = "" } ; return _paymentTerms
            if _paymentTerms == "<null>"{ _paymentTerms = "" } ; return _paymentTerms
        }
        set {
            _paymentTerms = newValue;
        }
        
    }
    var shipmentTerm:String{
        get {
            if _shipmentTerm == nil{ _shipmentTerm = "" } ; return _shipmentTerm
        }
        set {
            _shipmentTerm = newValue;
        }
        
    }
    var portID:String{
        get {
            if _portID == nil{ _portID = "" } ; return _portID
        }
        set {
            _portID = newValue;
        }
        
    }
    var isFav: Bool{
        if _isFav == nil { _isFav = false } ; return _isFav
    }
    var portName:String{
        get {
            if _portName == nil{ _portName = "" } ; return _portName
        }
        set {
            _portName = newValue;
        }
        
    }
    var priceTerms:String{
        get {
            if _priceTerms == nil{ _priceTerms = "" } ; return _priceTerms
        }
        set {
            _priceTerms = newValue;
        }
        
    }
    var commodity:String{
        get {
            if _commodity == nil{ _commodity = "" } ; return _commodity
        }
        set {
            _commodity = newValue;
        }
        
    }
    var anonymous:String{
        get {
            if _anonymous == nil{ _anonymous = "" } ; return _anonymous
        }
        set {
            _anonymous = newValue;
        }
        
    }
    var rate:String{
        get {
            if _rate == nil{ _rate = "" } ; return _rate
        }
        set {
            _rate = newValue;
        }
        
    }
    var duration:String{
        get {
            if _duration == nil{ _duration = "" } ; return _duration
        }
        set {
            _duration = newValue;
        }
        
    }
    var timeDuration:String{
        get {
            if _timeDuration == nil{ _timeDuration = "" } ; return _timeDuration
        }
        set {
            _timeDuration = newValue;
        }
        
    }
    var listingProductName:String{
        get {
            if _listingProductName == nil{ _listingProductName = "" } ; return _listingProductName
        }
        set {
            _listingProductName = newValue;
        }
        
    }
    var listingIsriCodeID:String{
        get {
            if _listingIsriCodeID == nil{ _listingIsriCodeID = "" } ; return _listingIsriCodeID
        }
        set {
            _listingIsriCodeID = newValue;
        }
        
    }
    var listingIsriCode:String{
        get {
            if _listingIsriCode == nil{ _listingIsriCode = "" } ; return _listingIsriCode
        }
        set {
            _listingIsriCode = newValue;
        }
        
    }
    var totalView:String{
        get {
            if _totalView == nil{ _totalView = "" } ; return _totalView
        }
        set {
            _totalView = newValue;
        }
        
    }
    var packaging:String{
        get {
            if _packaging == nil{ _packaging = "" } ; return _packaging
        }
        set {
            _packaging = newValue;
        }
        
    }
    var countryName:String{
        get {
            if _countryName == nil{ _countryName = "" } ; return _countryName
        }
        set {
            _countryName = newValue;
        }
        
    }
    var flagCode:String{
        get {
            if _flagCode == nil{ _flagCode = "" } ; return _flagCode
        }
        set {
            _flagCode = newValue;
        }
        
    }
    var countryID:String{
        get {
            if _countryID == nil{ _countryID = "" } ; return _countryID
        }
        set {
            _countryID = newValue;
        }
        
    }
    var quantity:String{
        get {
            if _quantity == nil{ _quantity = "" } ; return _quantity
        }
        set {
            _quantity = newValue;
        }
        
    }
    var description:String{
        get {
            if _description == nil{ _description = "" } ; return _description
        }
        set {
            _description = newValue;
        }
        
    }
    
    var _listingImg : [String]!
    
    var listingImg: [String]?{
        get {
            if _listingImg == [] {_listingImg = [""] } ; return _listingImg
        }
        set {
            _listingImg = newValue
        }
    }
    var expiry: String{
        if let dt = Int(duration){
            let date = Date(timeIntervalSince1970: Double(dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM YYYY"
            return formatter.string(from: date)
        }
        return ""
    }
    var title: String{
        if listingType == "0" {
            return "SALES : \(listingIsriCode.firstCapitalized), \(listingProductName.capitalized)"
        } else {
            return "BUY : \(listingIsriCode.firstCapitalized), \(listingProductName.capitalized)"
        }
    }
    
    
    init(Dict:Dictionary<String,AnyObject>) {
        if let listingId = Dict["listingId"] as? String{
            self._listingId = listingId
        }
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        if let listingTitle = Dict["listingTitle"] as? String{
            self._listingTitle = listingTitle
        }
        if let listingType = Dict["listingType"] as? String{
            self._listingType = listingType
        }
        if let description = Dict["description"] as? String{
            self._description = description
        }
        if let listingProductName = Dict["listingProductName"] as? String{
            self._listingProductName = listingProductName
        }
        if let listingIsriCodeID = Dict["listingIsriCodeID"] as? String{
            self._listingIsriCodeID = listingIsriCodeID
        }
        if let listingIsriCode = Dict["listingIsriCode"] as? String{
            self._listingIsriCode = listingIsriCode
        }
        if let totalView = Dict["totalView"] as? String{
            self._totalView = totalView
        }
        if let paymentTerms = Dict["paymentTerms"] as? String{
            self._paymentTerms = paymentTerms
        }
        if let shipmentTerm = Dict["shipmentTerm"] as? String {
            self._shipmentTerm = shipmentTerm
        }
        if let quantity = Dict["quantity"] as? String{
            self._quantity = quantity
        }
        if let portID = Dict["portID"] as? String{
            self._portID = portID
        }
        if let isFav = Dict["isFav"] as? Bool {
            self._isFav = isFav
        }
        if let portName = Dict["portName"] as? String{
            self._portName = portName
        }
        if let priceTerms = Dict["priceTerms"] as? String{
            self._priceTerms = priceTerms
        }
        if let commodity = Dict["commodity"] as? String{
            self._commodity = commodity
        }
        if let packaging = Dict["packaging"] as? String{
            self._packaging = packaging
        }
        if let countryID = Dict["countryID"] as? String{
            self._countryID = countryID
        }
        if let countryName = Dict["countryName"] as? String{
            self._countryName = countryName
        }
        if let flagCode = Dict["flagCode"] as? String{
            self._flagCode = flagCode
        }
        if let duration = Dict["duration"] as? String{
            self._duration = duration
        }
        if let timeDuration = Dict["timeDuration"] as? String{
            self._timeDuration = timeDuration
        }
        if let rate = Dict["rate"] as? String{
            self._rate = rate
        }
        if let anonymous = Dict["anonymous"] as? String{
            self._anonymous = anonymous
        }
        if let userObj = Dict["user_data"] as? [String: AnyObject]{
            let userItems = PostedUserData(dict: userObj)
            user_data.append(userItems)
        }
        if let listingImg = Dict["listingImg"] as? [String]{
            self._listingImg = listingImg
        }
    }
}
class PostedUserData{
    
    private var _user_id : String!
    private var _email : String!
    private var _profile_img : String!
    private var _jid : String!
    private var _name : String!
    private var _first_name : String!
    private var _last_name : String!
    private var _colorcode : String!
    private var _company : String!
    private var _designation : String!
    private var _contactMeChat : String!
    private var _contactMeEmail : String!
    private var _contactMePhoneCode : String!
    private var _contactMePhoneNo : String!
    private var _countryShortName : String!
    
    var user_id:String{
        get {
            if _user_id == nil{ _user_id = "" } ; return _user_id
        }
        set {
            _user_id = user_id;
        }
        
    }
    var email:String{
        get {
            if _email == nil{ _email = "" } ; return _email
        }
        set {
            _email = email;
        }
        
    }
    var profile_img:String{
        get {
            if _profile_img == nil{ _profile_img = "" } ; return _profile_img
        }
        set {
            _profile_img = profile_img;
        }
        
    }
    var jid:String{
        get {
            if _jid == nil{ _jid = "" } ; return _jid
        }
        set {
            _jid = jid;
        }
        
    }
    var name:String{
        get {
            if _name == nil{_name = "" } ; return _name
        }
        set {
            _name = name;
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
    var colorcode:String{
        get {
            if _colorcode == nil{ _colorcode = "" } ; return _colorcode
        }
        set {
            _colorcode = colorcode;
        }
    }
    var company:String{
        get {
            if _company == nil{ _company = "" } ; return _company
        }
        set {
            _company = company;
        }
    }
    var designation:String{
        get {
            if _designation == nil{ _designation = "" } ; return _designation
        }
        set {
            _designation = designation;
        }
    }
    var contactMeChat:String{
        get {
            if _contactMeChat == nil{ _contactMeChat = "" } ; return _contactMeChat
        }
        set {
            _contactMeChat = contactMeChat;
        }
    }
    var contactMeEmail:String{
        get {
            if _contactMeEmail == nil{ _contactMeEmail = "" } ; return _contactMeEmail
        }
        set {
            _contactMeEmail = contactMeEmail;
        }
    }
    var contactMePhoneCode:String{
        get {
            if _contactMePhoneCode == nil{ _contactMePhoneCode = "" } ; return _contactMePhoneCode
        }
        set {
            _contactMePhoneCode = contactMePhoneCode;
        }
    }
    var contactMePhoneNo:String{
        get {
            if _contactMePhoneNo == nil{ _contactMePhoneNo = "" } ; return _contactMePhoneNo
        }
        set {
            _contactMePhoneNo = contactMePhoneNo;
        }
    }
    var countryShortName:String{
        get {
            if _countryShortName == nil{ _countryShortName = "" } ; return _countryShortName
        }
        set {
            _countryShortName = countryShortName;
        }
    }
    
    init(dict: [String: AnyObject]){
        if let user_id = dict["user_id"] as? String{
            self._user_id = user_id
        }
        if let email = dict["email"] as? String{
            self._email = email
        }
        if let profile_img = dict["profile_img"] as? String{
            self._profile_img = profile_img
        }
        if let jid = dict["jid"] as? String{
            self._jid = jid
        }
        if let name = dict["name"] as? String{
            self._name = name
        }
        if let first_name = dict["first_name"] as? String{
            self._first_name = first_name
        }
        if let last_name = dict["last_name"] as? String{
            self._last_name = last_name
        }
        if let colorcode = dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let company = dict["company"] as? String{
            self._company = company
        }
        if let designation = dict["designation"] as? String{
            self._designation = designation
        }
        if let contactMeChat = dict["contactMeChat"] as? String{
            self._contactMeChat = contactMeChat
        }
        if let contactMeEmail = dict["contactMeEmail"] as? String{
            self._contactMeEmail = contactMeEmail
        }
        if let contactMePhoneCode = dict["contactMePhoneCode"] as? String{
            self._contactMePhoneCode = contactMePhoneCode
        }
        if let contactMePhoneNo = dict["contactMePhoneNo"] as? String{
            self._contactMePhoneNo = contactMePhoneNo
        }
        if let countryShortName = dict["countryShortName"] as? String{
            self._countryShortName = countryShortName
        }
    }
}

