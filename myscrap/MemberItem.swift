//
//  MemberItem.swift
//  myscrap
//
//  Created by MS1 on 10/16/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit



class MemberItem : Equatable{
   
    

    private var _name : String!
    private var _isNew : Bool!
    private var _firstName : String!
    private var _lastName : String!
    private var _userCompany : String!
    private var _designation : String!
    private var _country : String!
    private var _userLocation : String!
    private var _Email : String!
    private var _dateOfBirth : String!
    private var _gender : String!
    private var _address1 : String!
    private var _address2 : String!
    private var _phoneNo : String!
    private var _city : String!
    private var _lastLogin : String!
    private var _lastLogout : String!
    private var _jId : String!
    private var _profilePic : String!
    private var _userId : String!
    private var _score : String!
    private var _rank : String!
    private var _colorCode : String!
    private var _isMod : String!
    private var _joinedTime: Int!
    private var _isOnline: Bool!
    private var _isFriend:Bool!
    private var _friendcount : String!
    
    //Company of the Month Like Members Details
    
    private var _colorcode : String!
    private var _first_name : String!
    private var _last_name : String!
    
    private var _initials : String!
    
    private var _newJoined : Bool!
    private var _likeTimeStamp : String!
    
    private var _moderator : Int!
    private var _points : String!
    private var _isLevel: Bool!
    private var _level: String!
    
    var isAdmin: Bool = false
    
    var followStatusType : Int!

    
    var joinedDate:Date{
        return Date(timeIntervalSince1970: TimeInterval(_joinedTime))
    }
    
    var isFavourite: Bool{
        get {
            return FriendStatus == 3 ? true : false
        }
        set {
            if newValue == true {
                FriendStatus = 3
            } else {
                FriendStatus = 1
            }
        }
    }
    
    
    
    var FriendStatus : Int!
    var contactImg:UIImage!
//    self.contactImg = #imageLiteral(resourceName: "star")
    var profilePic:String{
        if _profilePic == nil || _profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || _profilePic == "https://myscrap.com/style/images/icons/profile.png" {
            _profilePic = ""
        }
        return _profilePic
    }
    
    var name:String{ if _name == nil{ _name = "" } ; return _name }
    var lowercasedName: String{
        return name.lowercased()
    }
    
    var userId:String{ if _userId == nil{ _userId = "" } ; return _userId }
    var isNew:Bool{ if _isNew == nil{ _isNew = false } ; return _isNew }
    var isMod:Bool {
        if _isMod == "1" || _moderator == 1 {
            return true
        } else {
            return false
        }
    }
    var firstName:String{ if _firstName == nil{ _firstName = "" } ; return _firstName }
    var lastName:String{ if _lastName == nil{ _lastName = "" } ; return _lastName }
    var userCompany:String{ if _userCompany == nil{ _userCompany = "" } ; return _userCompany }
    var designation:String{ if _designation == nil{ _designation = "" } ; return _designation }
    var country:String{ if _country == nil{ _country = "" } ; return _country }
    var userLocation:String{ if _userLocation == nil{ _userLocation = "" } ; return _userLocation }
    var Email:String{ if _Email == nil{ _Email = "" } ; return _Email }
    var dateOfBirth:String{ if _dateOfBirth == nil{ _dateOfBirth = "" } ; return _dateOfBirth }
    var gender:String{ if _gender == nil{ _gender = "" } ; return _gender }
    var address1:String{ if _address1 == nil{ _address1 = "" } ; return _address1 }
    var address2:String{ if _address2 == nil{ _address2 = "" } ; return _address2 }
    var phoneNo:String{ if _phoneNo == nil{ _phoneNo = "" } ; return _phoneNo }
    var city:String{ if _city == nil{ _city = "" } ; return _city }
    var lastLogin:String{ if _lastLogin == nil{ _lastLogin = "" } ; return _lastLogin }
    var lastLogout:String{ if _lastLogout == nil{ _lastLogout = "" } ; return _lastLogout }
    var jId:String{ if _jId == nil{ _jId = "" } ; return _jId }
    
    var score:String{ if _score == nil{ _score = "0" } ; return _score.trimmingCharacters(in: .whitespacesAndNewlines) }
    var rank:String{ if _rank == nil{ _rank = "" } ; return _rank }
    var colorCode:String{ if _colorCode == nil{ _colorCode = "" } ; return _colorCode }
    var isOnline: Bool{
        if _isOnline == nil { _isOnline = false } ; return _isOnline
    }
    var isFriend: Bool{
        if _isFriend == nil { _isFriend = false } ; return _isFriend
    }
    var friendcount:String{ if _friendcount == nil{ _friendcount = "" } ; return _friendcount }
    var isLevel: Bool {
        if _isLevel == nil { _isLevel = false}; return _isLevel
    }
    var level: String {
        if _level == nil { _level = "" }; return _level
     }
    
    static func == (lhs: MemberItem, rhs: MemberItem) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    //Company Of the month Liked Members
    
    var colorcode:String{ if _colorcode == nil{ _colorcode = "" } ; return _colorcode }
    var first_name:String{ if _first_name == nil{ _first_name = "" } ; return _first_name }
    var last_name:String{ if _last_name == nil{ _last_name = "" } ; return _last_name }
    
    var initials:String{ if _initials == nil{ _initials = "" } ; return _initials }
    
    var newJoined:Bool{ if _newJoined == false{ _newJoined = false } ; return _newJoined }
    var likeTimeStamp:String{ if _likeTimeStamp == nil{ _likeTimeStamp = "" } ; return _likeTimeStamp }
    
    var moderator:Int{ if _moderator == nil{ _moderator = 0 } ; return _moderator }
    var points:String{ if _points == nil{ _points = "" } ; return _points }
   
    init(Dict:Dictionary<String,AnyObject>) {
        if let name = Dict["name"] as? String{
            self._name = name
        }
        if let newJoined = Dict["newJoined"] as? Bool{
            self._isNew = newJoined
        }
        if let firstname = Dict["firstName"] as? String{
            self._firstName = firstname
        }
        if let lastName = Dict["lastName"] as? String{
            self._lastName = lastName
        }
        if let userCompany = Dict["userCompany"] as? String{
            self._userCompany = userCompany
        }
        
        if let designation = Dict["designation"] as? String{
            self._designation = designation
        }
        
        if let country = Dict["country"] as? String{
            self._country = country
        }
        if let userLocation = Dict["userLocation"] as? String{
            self._userLocation = userLocation
        }
        if let Email = Dict["Email"] as? String{
            self._Email = Email
        }
        if let dateOfBirth = Dict["dateOfBirth"] as? String{
            self._dateOfBirth = dateOfBirth
        }
        if let gender = Dict["gender"] as? String{
            self._gender = gender
        }
        if let address1 = Dict["address1"] as? String{
            self._address1 = address1
        }
        if let address2 = Dict["address2"] as? String{
            self._address2 = address2
        }
        if let phoneNo = Dict["phoneNo"] as? String{
            self._phoneNo = phoneNo
        }
        if let city = Dict["city"] as? String{
            self._city = city
        }
        if let lastLogin = Dict["lastLogin"] as? String{
            self._lastLogin = lastLogin
        }
        if let lastLogout = Dict["lastLogout"] as? String{
            self._lastLogout = lastLogout
        }
        if let jId = Dict["jId"] as? String{
            self._jId = jId
        }
        if let profilePic = Dict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        
        if let likepic = Dict["likeProfilePic"] as? String{
            self._profilePic = likepic
        }
        
        if let userId = Dict["userid"] as? String{
            self._userId = userId
        }
        
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        
        if let points = Dict["points"] as? String{
            self._score = points
        }
        if let rank = Dict["rank"] as? String{
            self._rank = rank
        }
        if let colorCode = Dict["colorCode"] as? String{
            self._colorCode = colorCode
        }
        if let FriendStatus = Dict["FriendStatus"] as? Int{
            self.FriendStatus = FriendStatus
        }
        if let joinedTime = Dict["joinedTime"] as? Int{
            self._joinedTime = joinedTime
        }
        if let moderator = Dict["moderator"] as? String{
            self._isMod = moderator
        }
        
        if let online = Dict["online"] as? Bool{
            self._isOnline = online
        }
        if let isFriend = Dict["isFriend"] as? Bool{
            self._isFriend = isFriend
        }
        if let friendcount = Dict["friendcount"] as? String{
            self._friendcount = friendcount
        }
        
        //Company of the Month Liked Members fetch
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        if let colorcode = Dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let first_name = Dict["first_name"] as? String{
            self._first_name = first_name
        }
        if let last_name = Dict["last_name"] as? String{
            self._last_name = last_name
        }
        if let name = Dict["name"] as? String{
            self._name = name
        }
        if let initials = Dict["initials"] as? String{
            self._initials = initials
        }
        
        if let profilePic = Dict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let designation = Dict["designation"] as? String{
            self._designation = designation
        }
        if let rank = Dict["rank"] as? String{
            self._rank = rank
        }
        if let newJoined = Dict["newJoined"] as? Bool{
            self._newJoined = newJoined
        }
        if let userCompany = Dict["userCompany"] as? String{
            self._userCompany = userCompany
        }
        if let moderator = Dict["moderator"] as? Int{
            self._moderator = moderator
        }
        if let points = Dict["points"] as? String{
            self._points = points
        }
        if let isLevel = Dict["isLevel"] as? Bool {
            self._isLevel = isLevel
        }
        if let level = Dict["level"] as? String {
            self._level = level
        }
        
        followStatusType = JSONUtils.GetIntFromObject(object: Dict, key: "followStatusNew")

    }
}
class LikedMemberItemCM {
    private var _userId : String!
    private var _colorcode : String!
    private var _first_name : String!
    private var _last_name : String!
    private var _name : String!
    private var _initials : String!
    private var _profilePic : String!
    private var _designation : String!
    private var _rank : String!
    private var _newJoined : Bool!
    private var _likeTimeStamp : String!
    private var _userCompany : String!
    private var _moderator : Int!
    private var _points : String!
    
    var userId:String{ if _userId == nil{ _userId = "" } ; return _userId }
    var colorcode:String{ if _colorcode == nil{ _colorcode = "" } ; return _colorcode }
    var first_name:String{ if _first_name == nil{ _first_name = "" } ; return _first_name }
    var last_name:String{ if _last_name == nil{ _last_name = "" } ; return _last_name }
    var name:String{ if _name == nil{ _name = "" } ; return _name }
    var initials:String{ if _initials == nil{ _initials = "" } ; return _initials }
    var profilePic:String{ if _profilePic == nil{ _profilePic = "" } ; return _profilePic }
    var designation:String{ if _designation == nil{ _designation = "" } ; return _designation }
    var rank:String{ if _rank == nil{ _rank = "" } ; return _rank }
    var newJoined:Bool{ if _newJoined == false{ _newJoined = false } ; return _newJoined }
    var likeTimeStamp:String{ if _likeTimeStamp == nil{ _likeTimeStamp = "" } ; return _likeTimeStamp }
    var userCompany:String{ if _userCompany == nil{ _userCompany = "" } ; return _userCompany }
    var moderator:Int{ if _moderator == nil{ _moderator = 0 } ; return _moderator }
    var points:String{ if _points == nil{ _points = "" } ; return _points }
    
    init(Dict:Dictionary<String,AnyObject>) {
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        if let colorcode = Dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let first_name = Dict["first_name"] as? String{
            self._first_name = first_name
        }
        if let last_name = Dict["last_name"] as? String{
            self._last_name = last_name
        }
        if let name = Dict["name"] as? String{
            self._name = name
        }
        if let initials = Dict["initials"] as? String{
            self._initials = initials
        }
        
        if let profilePic = Dict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let designation = Dict["designation"] as? String{
            self._designation = designation
        }
        if let rank = Dict["rank"] as? String{
            self._rank = rank
        }
        if let newJoined = Dict["newJoined"] as? Bool{
            self._newJoined = newJoined
        }
        if let userCompany = Dict["userCompany"] as? String{
            self._userCompany = userCompany
        }
        if let moderator = Dict["moderator"] as? Int{
            self._moderator = moderator
        }
        if let points = Dict["points"] as? String{
            self._points = points
        }
    }
}

class VideoViewItems {
    private var _userId : String!
    private var _postId : String!
    private var _colorCode : String!
    //private var _first_name : String!
    //private var _last_name : String!
    private var _name : String!
    private var _initials : String!
    private var _likeProfilePic : String!
    private var _designation : String!
    private var _rank : String!
    private var _newJoined : Bool!
    private var _likeTimeStamp : String!
    private var _userCompany : String!
    private var _moderator : Int!
    private var _points : String!
    private var _country : String!
    
    
    var userId:String{ if _userId == nil{ _userId = "" } ; return _userId }
    var postId:String{ if _postId == nil{ _postId = "" } ; return _postId }
    var colorcode:String{ if _colorCode == nil{ _colorCode = "" } ; return _colorCode }
    //var first_name:String{ if _first_name == nil{ _first_name = "" } ; return _first_name }
    //var last_name:String{ if _last_name == nil{ _last_name = "" } ; return _last_name }
    var name:String{ if _name == nil{ _name = "" } ; return _name }
    var initials:String{ if _initials == nil{ _initials = "" } ; return _initials }
    var likeProfilePic:String{ if _likeProfilePic == nil{ _likeProfilePic = "" } ; return _likeProfilePic }
    var designation:String{ if _designation == nil{ _designation = "" } ; return _designation }
    var rank:String{ if _rank == nil{ _rank = "" } ; return _rank }
    var newJoined:Bool{ if _newJoined == false{ _newJoined = false } ; return _newJoined }
    var likeTimeStamp:String{ if _likeTimeStamp == nil{ _likeTimeStamp = "" } ; return _likeTimeStamp }
    var userCompany:String{ if _userCompany == nil{ _userCompany = "" } ; return _userCompany }
    var moderator:Int{ if _moderator == nil{ _moderator = 0 } ; return _moderator }
    var points:String{ if _points == nil{ _points = "" } ; return _points }
    var country:String{ if _country == nil{ _country = "" } ; return _country }
    
    init(Dict:Dictionary<String,AnyObject>) {
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        if let postId = Dict["postId"] as? String{
            self._postId = postId
        }
        if let colorCode = Dict["colorCode"] as? String{
            self._colorCode = colorCode
        }
        /*if let first_name = Dict["first_name"] as? String{
            self._first_name = first_name
        }
        if let last_name = Dict["last_name"] as? String{
            self._last_name = last_name
        }*/
        if let name = Dict["name"] as? String{
            self._name = name
        }
        if let initials = Dict["initials"] as? String{
            self._initials = initials
        }
        
        if let likeProfilePic = Dict["likeProfilePic"] as? String{
            self._likeProfilePic = likeProfilePic
        }
        if let designation = Dict["designation"] as? String{
            self._designation = designation
        }
        if let rank = Dict["rank"] as? String{
            self._rank = rank
        }
        if let newJoined = Dict["newJoined"] as? Bool{
            self._newJoined = newJoined
        }
        if let userCompany = Dict["userCompany"] as? String{
            self._userCompany = userCompany
        }
        if let moderator = Dict["moderator"] as? Int{
            self._moderator = moderator
        }
        if let points = Dict["points"] as? String{
            self._points = points
        }
        if let country = Dict["country"] as? String{
            self._country = country
        }
    }
}



