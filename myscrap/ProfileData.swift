//
//  ProfileData.swift
//  myscrap
//
//  Created by MS1 on 5/22/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation


final class ProfileData{
    
    private var _firstName: String!
    private var _lastName: String!
    private var _userId: String!
    private var _user_id: String!
    private var _userName: String!
    private var _name: String!
    private var _email: String!
    private var _memEmail: String!
    private var _designation: String!
    private var _memDesignation: String!
    private var _company: String!
    private var _memCompany:String!
    private var _phone: String!
    private var _personalPhone: String!
    private var _offPhone: String!
    private var _interest: String!
    private var _phonereq: String!
    private var _cardreq: String!
    private var _memInterest: [String]!
    private var _memRoles: [String]!
    private var _userBio: String!
    private var _city: String!
    private var _country: String!
    private var _profilePic: String!
    private var _memProfile: String!
    private var _score: String!
    private var _rank: String!
    private var _cardBack: String!
    private var _cardFront: String!
    private var _cardShow: String!
    private var _showPhone: String!
    private var _likes:Int!
    private var _lastSeen:String!
    private var _last_seen_timestamp: Int!
    private var _colorCode: String!
    private var _website: String!
    private var _location: String!
    private var friendStatus: Int!
    private var _isFav:Int!
    private var _isLike:Int!
    private var _companyId: String!
    private var _joinedTime: Int!
    private var _joinedDate: String!
    private var _profilePercentage: Int!
    var newJoined: Bool = false
    private var _moderator: String!
    private var _roles: String!
    private var _companyType:String!
    private var _userType:String!
    //Added for Edit Profile
    private var _userHereFor: String!
    private var _offPhoneCode: String!
    
    private var _companyName:String!
    private var _isLevel:Bool!
    private var _level:String!
    
    var jid: String?
    
    var followStatusType : Int!
    
    var moderator: Bool{
        if _moderator == "1" { return true }
        return false
    }
    var companyName:String{
        if _companyName == nil{ _companyName = "" }
        return _companyName
    }
    var memCompany:String{
        if _memCompany == nil { _memCompany = "" }
        return _memCompany
    }
    var phonereq:String{
        if _phonereq == nil{ _phonereq = "" }
        return _phonereq
    }
    var cardreq:String{
        if _cardreq == nil{ _cardreq = "" }
        return _cardreq
    }
    var userId:String{
        if _userId == nil{ _userId = "" }
        return _userId
    }
    var memUserId: String {
        if _user_id == nil{ _user_id = "" }
        return _user_id
    }
    
    var email:String?{
        if _email == nil{ _email = "" }
        return _email
    }
    var memEmail:String?{
        if _memEmail == nil { _memEmail = "" }
        return _memEmail
    }
    var profilePic:String{
        if _profilePic == nil{ _profilePic = "" }
        return _profilePic
    }
    var memProfilePic:String{
        if _memProfile == nil{ _memProfile = "" }
        return _memProfile
    }
    var name:String{
        if _name == nil{ _name = "" }
        return _name
    }
    var memName:String{
        if _userName == nil {
            _userName = ""
        }
        return _userName
    }
    var userType:String{
        if _userType == nil {
            _userType = ""
        }
        return _userType
    }
    var designation:String{
        if _designation == nil{ _designation = "" }
        return _designation
    }
    var memDesignation:String {
        if _memDesignation == nil { _memDesignation = "" }
        return _memDesignation
    }
    var lastSeen: String{
        if _lastSeen == nil { _lastSeen = "" }
        return _lastSeen
    }
    var last_seen_timestamp: Int {
        if _last_seen_timestamp == nil { _last_seen_timestamp == 0 }
        return _last_seen_timestamp
    }
    var isFavourite: Bool{
        get {
            return friendStatus == 3 ? true : false
        }
        set {
            if newValue == true {
                friendStatus = 3
            } else {
                friendStatus = 1
            }
        }
    }
    var isFav:Bool{
        get {
            return _isFav == 1 ? true : false
        }
        set {
            if newValue == true {
                _isFav = 1
            } else {
                _isFav = 0
            }
        }
    }
    var isLike:Bool{
        get {
            return _isLike == 1 ? true : false
        }
        set {
            if newValue == true {
                _isLike = 1
            } else {
                _isLike = 0
            }
        }
    }
    var likes: Int = 0
    
    var interest:[String]{
        var int: [String]!
        if _interest == nil || _interest == ""{ int = [String]() } else {
            let trim = _interest.replacingOccurrences(of: " ", with: "")
            int = trim.components(separatedBy: "/")
        }
        return int
    }
    var inter:[String]{
        var int: [String]!
        if _interest == nil || _interest == ""{ int = [String]() } else {
            let trim = _interest.replacingOccurrences(of: " ", with: "")
            int = trim.components(separatedBy: ",")
        }
        return int
    }
    var memInterest:[String]{
        if _memInterest == nil || _memInterest == [""] { _memInterest = [""] }
        return _memInterest
    }
    var memRoles:[String]{
        if _memRoles == nil || _memRoles == [""] { _memRoles = [""] }
        return _memRoles
    }
    var roles:[String]{
        var int: [String]!
        if _roles == nil || _roles == ""{
            int = [String]()
        } else {
            let trim = _roles.replacingOccurrences(of: " ", with: "")
            int = trim.components(separatedBy: ",")
        }
        return int
    }
    
    

    var companyId:String{
        if _companyId == nil{
            _companyId = ""
        }
        return _companyId
    }
    
    var phone:String{
        if _phone == nil{
            _phone = ""
        }
        return _phone
    }
    var userHereFor:String{
        if _userHereFor == ""{
            _userHereFor = ""
        }
        return _userHereFor
    }
    var personalPhone: String {
        if _personalPhone == nil { _personalPhone = "" }
        return _personalPhone
    }
    var offPhone: String{
        if _offPhone == nil{
            _offPhone = ""
        }
        return _offPhone
        
    }
    var offPhoneCode: String{
        if _offPhone == nil{
            _offPhone = ""
        }
        return _offPhone
        
    }
    var cardFront:String{
           if _cardFront == nil{
               _cardFront = ""
           }
           return _cardFront
       }
    var cardBack:String{
           if _cardBack == nil{
               _cardBack = ""
           }
           return _cardBack
       }
    var cardShow:String{
           if _cardShow == nil{
               _cardShow = ""
           }
           return _cardShow
       }
    var showPhone:String{
           if _showPhone == nil{
               _showPhone = ""
           }
           return _showPhone
       }
    var website:String{
        if _website == nil{
            _website = ""
        }
        return _website
    }
    
    var colorCode:String{
        if _colorCode == nil{ _colorCode = "#118d24" }
        return _colorCode
    }
    
    var city:String{ if _city == nil { _city = "" }
        return _city
    }
    
    var location:String{ if _location == nil { _location = "" }
        return _location
    }
    var country: String{
        if _country == nil { _country = "" }
        return _country
    }
    var score:String{
        if _score == nil{ _score = "" }
        return _score
    }
    var userBio:String{
        if _userBio == nil{ _userBio = "" }
        return _userBio
    }
    
    var profilePercentage: Int{
        if _profilePercentage == nil {
            _profilePercentage = 100
        }
        return _profilePercentage
    }
    var joinedDate: Date{
        return Date(timeIntervalSince1970: TimeInterval(_joinedTime))
    }
    var joinedDateNew: String{
        if _joinedDate == nil {
            _joinedDate = ""
        }
        return _joinedDate
    }
    var companyType:String{
        if _companyType == nil{ _companyType = "" }
        return _companyType
    }
    var rank:String{
        if _rank == nil{ _rank = "10000" }
        return _rank
    }
    
    var isLevel: Bool {
        if _isLevel == nil { _isLevel = false }
        return _isLevel
    }
    
    var level: String {
        if _level == nil { _level = "" };
        return _level
    }
    
    var company:String{
        if _company == nil{ _company = "" }
        return _company
    }
    var followersCount:Int!
    var followingCount:Int!
    var currentTotalPoints: Int!
    var pointsNeed:String!
    var nextLevel:String!
    var levelNextTotalPoint:String!
    var followStatus : Bool!

    init (userDict:Dictionary<String,AnyObject>){
        if let name = userDict["firstName"] as? String {
            self._firstName = name
        }
        if let name = userDict["lastName"] as? String {
            self._lastName = name
        }
        
        if let userid = userDict["user_id"] as? String{
            self._user_id = userid
        }
        if let userid = userDict["userid"] as? String{
            self._userId = userid
        }
        if let name = userDict["name"] as? String{
            self._name = name
        }
        if let memName = userDict["username"] as? String{
            self._userName = memName
        }
        if let Email = userDict["Email"] as? String{
            self._email = Email
        }
        if let cardBack = userDict["cardBack"] as? String{
                   self._cardBack = cardBack
               }
        if let cardFront = userDict["cardFront"] as? String{
                   self._cardFront = cardFront
               }
        if let cardShow = userDict["cardShow"] as? String{
                   self._cardShow = cardShow
               }
        if let showPhone = userDict["showPhone"] as? String{
                   self._showPhone = showPhone
               }
        if let memEmail = userDict["email"] as? String{
            self._memEmail = memEmail
        }
        if let email = userDict["email"] as? String{
            self._email = email
        }
        if let designation = userDict["postedUserDesignation"] as? String{
            self._designation = designation
        }
        if let memDesignation = userDict["designation"] as? String{
            self._memDesignation = memDesignation
        }
        if let phonereq = userDict["phonereq"] as? String{
            self._phonereq = phonereq
        }
        if let cardreq = userDict["cardreq"] as? String{
            self._cardreq = cardreq
        }
        if let designation = userDict["designation"] as? String {
            self._designation = designation
        }
        if let company = userDict["company"] as? String{
            self._memCompany = company
        }
        if let company = userDict["company"] as? String{
            self._company = company
        }
        if let userCompany = userDict["userCompany"] as? String{
            self._company = userCompany
        }
        if let phoneNo = userDict["phoneNo"] as? String{
            self._phone = phoneNo
        }
        //added for Edit profile
        if let officePhoneCode = userDict["officePhoneCode"] as? String {
            self._offPhoneCode = officePhoneCode
        }
        if let code = userDict["code"] as? String {
            self._offPhoneCode = code
        }
        if let userHereFor = userDict["userHereFor"] as? String {
            self._userHereFor = userHereFor
        }
        if let officePhoneNumber = userDict["officePhoneNumber"] as? String {
            self._offPhone = officePhoneNumber
        }
        if let personalPhone = userDict["person_number"] as? String {
            self._personalPhone = personalPhone
        }
        if let offPhone = userDict["office_number"] as? String{
            self._offPhone = offPhone
        }
        if let interest = userDict["userInterest"] as? String{
            print("Interests!!! : \(interest)")
            self._interest = interest
        }
        if let userBio = userDict["userBio"] as? String{
            self._userBio = userBio
        }
        if let city = userDict["city"] as? String{
            self._city = city
        }
        if let country = userDict["country"] as? String{
            self._country = country
        }
        if let profielPic = userDict["profilePic"] as? String{
            self._profilePic = profielPic
        }
        if let profilePic = userDict["pro_img"] as? String{
            self._memProfile = profilePic
        }
        if let userType = userDict["usertype"] as? String{
            self._userType = userType
        }
        if let score = userDict["points"] as? String{
            self._score = score
        }
        if let rank = userDict["rank"] as? String{
            AuthService.instance.userRank = rank
            self._rank = rank
        }
        if let likes = userDict["userProfilelikesCount"] as? Int{
            print("Profile likes in Profile data \(likes)")
            self.likes = likes
        }
        if let lastSeen = userDict["last_seen"] as? String{
            self._lastSeen = lastSeen
        }
        if let last_seen_timestamp = userDict["last_seen_timestamp"] as? Int
        {
            self._last_seen_timestamp = last_seen_timestamp
        }
        if let colorcode = userDict["colorCode"] as? String{
            self._colorCode = colorcode
        }
        if let website = userDict["website"] as? String{
            self._website = website
        }
        if let location = userDict["userLocation"] as? String{
            self._location = location
        }
        if let friendstatus = userDict["friendstatus"] as? Int{
            self.friendStatus = friendstatus
        }
        if let isFav = userDict["myFav"] as? Int {
            self._isFav = isFav
        }
        if let isLike = userDict["myLike"] as? Int {
            self._isLike = isLike
        }
        if let companyTag = userDict["companyTag"] as? [Dictionary<String,AnyObject>]{
            if let companyId = companyTag.last?["companyId"] as? String{
                self._companyId = companyId
            }
        }
        if let companyId = userDict["companyId"] as? String{
            self._companyId = companyId
        }
        if let userInterestRoles = userDict["userInterestRoles"] as? String{
            self._roles = userInterestRoles
        }
        if let memInterest = userDict["userIntrest"] as? [String]{
            self._memInterest = memInterest
        }
        if let memRoles = userDict["userRoles"] as? [String]{
            self._memRoles = memRoles
        }
        if let joinedTime = userDict["joinedTime"] as? Int{
            self._joinedTime = joinedTime
        }
        if let joinedDate = userDict["joining_date"] as? String{
            self._joinedDate = joinedDate
            
        }
        if let profilePercent = userDict["profilePercentage"] as? Int{
            print("Profile data percentage: \(profilePercent)")
            self._profilePercentage = profilePercent
        }
        if let newJoined = userDict["newJoined"] as? Bool{
            AuthService.instance.isNewJoined = newJoined
            self.newJoined = newJoined
        }
        
        if let moderator = userDict["moderator"] as? String{
            self._moderator = moderator
        }
        
        if let isLevel = userDict["isLevel"] as? Bool {
            self._isLevel = isLevel
        }
        
        if let level = userDict["level"] as? String {
            self._level = level
        }
        /*if let jid = userDict["userJid"] as? String{
            self.jid = jid          // need to change the userJid as shroya35 alone in api
        }*/
        if let newjid = userDict["userNewJid"] as? String {
            self.jid = newjid
        }
     
        self.followersCount = JSONUtils.GetIntFromObject(object: userDict, key: "followercount") //JSONUtils.GetStringFromObject(object: userDict, key: "followercount")
        self.followingCount = JSONUtils.GetIntFromObject(object: userDict, key: "followingcount")
        self.currentTotalPoints = JSONUtils.GetIntFromObject(object: userDict, key: "totalPoints") //JSONUtils.GetStringFromObject(object: userDict, key: "totalPoints")
        self.levelNextTotalPoint = JSONUtils.GetStringFromObject(object: userDict, key: "levelNextPoint")
        self.pointsNeed = JSONUtils.GetStringFromObject(object: userDict, key: "pointsNeed")
        self.nextLevel = JSONUtils.GetStringFromObject(object: userDict, key: "levelNext")

        self.followStatus = JSONUtils.GetBoolFromObject(object: userDict, key: "followStatus")

        followStatusType = JSONUtils.GetIntFromObject(object: userDict, key: "followStatus")

    }
    
}


