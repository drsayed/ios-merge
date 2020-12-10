//
//  MyListingItems.swift
//  myscrap
//
//  Created by MyScrap on 1/23/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class MyListingItems {
    private var _listing_id : String!
    private var _user_id : String!
    private var _anonymous : String!
    private var _rate : String!
    private var _duration : String!
    private var _product : String!
    private var _isri_code : String!
    private var _total_view : String!
    private var _port_name : String!
    private var _country_name : String!
    private var _flagcode : String!
    private var _countryID : String!
    private var _quantity : String!
    private var _description : String!
    private var _type : String!
    private var _imageUrl : String!
    private var _listingImage : [String]?
  
    var listing_id:String{
        get {
            if _listing_id == nil{ _listing_id = "" } ; return _listing_id
        }
        set {
            _listing_id = listing_id;
        }
        
    }
    var user_id:String{
        get {
            if _user_id == nil{ _user_id = "" } ; return _user_id
        }
        set {
            _user_id = newValue;
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
    var product:String{
        get {
            if _product == nil{ _product = "" } ; return _product
        }
        set {
            _product = newValue;
        }
        
    }
    var isri_code:String{
        get {
            if _isri_code == nil{ _isri_code = "" } ; return _isri_code
        }
        set {
            _isri_code = newValue;
        }
        
    }
    var total_view:String{
        get {
            if _total_view == nil{ _total_view = "" } ; return _total_view
        }
        set {
            _total_view = newValue;
        }
        
    }
    var port_name:String{
        get {
            if _port_name == nil{ _port_name = "" } ; return _port_name
        }
        set {
            _port_name = newValue;
        }
        
    }
    var country_name:String{
        get {
            if _country_name == nil{ _country_name = "" } ; return _country_name
        }
        set {
            _country_name = newValue;
        }
        
    }
    var flagcode:String{
        get {
            if _flagcode == nil{ _flagcode = "" } ; return _flagcode
        }
        set {
            _flagcode = newValue;
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
    var imageUrl:String{
        get {
            if _imageUrl == nil{ _imageUrl = "" } ; return _imageUrl
        }
        set {
            _imageUrl = newValue;
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
    /*var listingImage:String{
        get {
            if _listingImage == nil{ _listingImage = [""] } ; return _listingImage
        }
        set {
            _listingImage = newValue;
        }
        
    }*/
    
    init(Dict:Dictionary<String,AnyObject>) {
        if let listing_id = Dict["listing_id"] as? String{
            self._listing_id = listing_id
        }
        if let user_id = Dict["user_id"] as? String{
            self._user_id = user_id
        }
        if let anonymous = Dict["anonymous"] as? String{
            self._anonymous = anonymous
        }
        if let rate = Dict["rate"] as? String{
            self._rate = rate
        }
        if let duration = Dict["duration"] as? String{
            self._duration = duration
        }
        if let product = Dict["product"] as? String{
            self._product = product
        }
        if let isri_code = Dict["isri_code"] as? String{
            self._isri_code = isri_code
        }
        if let total_view = Dict["total_view"] as? String{
            self._total_view = total_view
        }
        if let port_name = Dict["port_name"] as? String{
            self._port_name = port_name
        }
        if let country_name = Dict["country_name"] as? String{
            self._country_name = country_name
        }
        if let flagcode = Dict["flagcode"] as? String{
            self._flagcode = flagcode
        }
        if let countryID = Dict["countryID"] as? String{
            self._countryID = countryID
        }
        if let quantity = Dict["quantity"] as? String{
            self._quantity = quantity
        }
        if let description = Dict["description"] as? String{
            self._description = description
        }
        if let imageUrl = Dict["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        if let type = Dict["type"] as? String {
            self._type = type
        }
    }
}
