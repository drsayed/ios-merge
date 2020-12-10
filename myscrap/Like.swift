//
//  Like.swift
//  myscrap
//
//  Created by MS1 on 5/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit

final class Like{
    private var _userId:String!
    
    private var _name:String!
    
    private var _designation:String!
    
    private var _friendCount:Int!
    var FriendStatus:Int = 0
    
    private var _isFriend:Bool!
    
    private var _postId:String!
    
    private var _likeTimeStamp:String!
    
    private var _likeProfilePic:String!
    
    private var _firstName:String!
    private var _lastName:String!
    
    
    private var _likeStatus:Bool!
    
    private var _commentCount:Int!
    
    private var _commentId:String!
    
    private var _comment:String!
    
    private var _country:String!
    
    var contactImg:UIImage!
    
    private var _isMod:String!
    private var _friendId:String!
    
    private var _userCompany:String!
    
    private var _colorCode:String!
    
    private var _rank:String!
    private var _score :String!
    private var _admin:String!
    
    private var _isNew: Bool!
    
    
    var isNew:Bool{
        
        if _isNew == nil{
            
            _isNew = false
        }
        
        return _isNew
    }
    
    var admin:String{
        
        if _admin == nil{
            
            _admin = ""
        }
        return _admin
    }
    

    var firstName:String{
        
        if _firstName == nil{
            _firstName = ""
        }
        
        return _firstName
    }
    
    var lastName:String{
        
        if _lastName == nil{
            _lastName = ""
        }
        
        return _lastName
    }
//
//    var FriendStatus:Int{
//        
//        if _friendStatus == nil{ _friendStatus = 0}
//        return _friendStatus
//    }
    
    
    
    
    var rank:String{
        if _rank == nil{ _rank = ""}
        return _rank
    }
    
    var score:String{
        
        if _score == nil {_score = ""}
        return _score
    }
    
    var colorCode:String{
        
        if _colorCode == nil {
            
            _colorCode = "#118d24"
        }
        
        return _colorCode
    }
    
    var usercompany:String{
        
        if _userCompany == nil{
            
            _userCompany = ""
        }
        return _userCompany
    }
    
    var friendId:String{
        
        if _friendId == nil{
            
            _friendId = ""
        }
        
        return _friendId
    }
    
    var country:String{
        
        
        if _country == nil{
            
            _country = ""
            
        }
        return _country
    }
    
    
    
    var likeStatus:Bool{
        
        if _likeStatus == nil{
            
            _likeStatus = false
        }
        
        return _likeStatus
    }
    
    var commentCount:Int{
        
        if _commentCount == nil{
            
            _commentCount = 0
        }
        
        return _commentCount
    }
    
    var commentId:String{
        
        if _commentId == nil{
            
            _commentId = ""
            
        }
     return _commentId
    }
    
    var comment:String{
        
        if _comment == nil{
            _comment = ""
            
        }
        return _comment
    }
    
    
    
    
    
    var userId:String{
        if _userId == nil {
            
            _userId = "'"
        }
        return _userId
    }
    var name:String{
        if _name == nil {
            
            _name = ""
        }
        return _name
    }
    var designation:String{
        if _designation == nil {
            
            _designation = "'"
        }
        return _designation
    }
    var friendCount:Int{
        if _friendCount == nil {
            
            _friendCount = 0
        }
        return _friendCount
    }
  
    var isFriend:Bool{
        if _isFriend == nil {
            
            _isFriend = false
        }
        return _isFriend
    }
    var postId:String{
        if _postId == nil {
            
            _postId = "'"
        }
        return _postId
    }
    var likeTimeStamp:String{
        if _likeTimeStamp == nil {
            
            _likeTimeStamp = "'"
        }
        return _likeTimeStamp
    }
    var likeProfilePic:String{
        if _likeProfilePic == nil || _likeProfilePic == "https://myscrap.com/style/images/icons/profile.png" || _likeProfilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png"{
            
            _likeProfilePic = "'"
        }
        return _likeProfilePic
    }
    
    var isMod:Bool {
        if _isMod == "1" { return true }
        else { return false }
    }

    
    init(likeDict: Dictionary<String,AnyObject>) {
        
        if let moderator = likeDict["moderator"] as? String{
            self._isMod = moderator
        }
        
        
        if let colorCode = likeDict["colorCode"] as? String{
            
            self._colorCode = colorCode
        }
        
        if let userId = likeDict["userId"] as? String{
            
            self._userId = userId
            
        }
        if let name = likeDict["name"] as? String{
            
            self._name = name
            
        }
        if let designation = likeDict["designation"] as? String{
            
            self._designation = designation
            
        }
        if let friendCount = likeDict["friendCount"] as? Int{
            
            self._friendCount = friendCount
            
        }
        if let friendStatus = likeDict["friendStatus"] as? Int{
            
            self.FriendStatus = friendStatus
            
        }
        if let isFriend = likeDict["isFriend"] as? Bool{
            
            self._isFriend = isFriend
            
        }
        if let postId = likeDict["postId"] as? String{
            
            self._postId = postId
            
        }
        if let likeTimeStamp = likeDict["likeTimeStamp"] as? Int{
            
            self._likeTimeStamp = "\(likeTimeStamp)"
            
        }
        if let likeProfilePic = likeDict["likeProfilePic"] as? String{
            
            self._likeProfilePic = likeProfilePic
            
        }
    }
    
    
    
    init(companyLikeDict: Dictionary<String,AnyObject>){
        
        if let moderator = companyLikeDict["moderator"] as? String{
            self._isMod = moderator
        }
        
        if let colorCode = companyLikeDict["colorCode"] as? String{
            
            self._colorCode = colorCode
        }
        
        if let userId = companyLikeDict["userId"] as? String{
            
            self._userId = userId
            
        }
        if let name = companyLikeDict["name"] as? String{
            
            self._name = name
            
        }
        if let designation = companyLikeDict["designation"] as? String{
            
            self._designation = designation
            
        }
        if let friendCount = companyLikeDict["friendCount"] as? Int{
            
            self._friendCount = friendCount
            
        }
        if let friendStatus = companyLikeDict["friendStatus"] as? Int{
            
            self.FriendStatus = friendStatus
            
        }
        if let isFriend = companyLikeDict["isFriend"] as? Bool{
            
            self._isFriend = isFriend
            
        }
        if let postId = companyLikeDict["postId"] as? String{
            
            self._postId = postId
            
        }
        if let likeTimeStamp = companyLikeDict["likeTimeStamp"] as? Int{
            
            self._likeTimeStamp = "\(likeTimeStamp)"
            
        }
        if let likeProfilePic = companyLikeDict["likeProfilePic"] as? String{
            
            self._likeProfilePic = likeProfilePic
            
        }

    }
    
    init(employeeDict: Dictionary<String,AnyObject>){
        
        
        if let moderator = employeeDict["moderator"] as? String{
            self._isMod = moderator
        }
        
        if let colorCode = employeeDict["colorCode"] as? String{
            
            self._colorCode = colorCode
        }
        
        if let userId = employeeDict["userId"] as? String{
            
            self._userId = userId
            
        }
        if let name = employeeDict["name"] as? String{
            
            self._name = name
            
        }
        if let designation = employeeDict["designation"] as? String{
            
            self._designation = designation
            
        }
        if let friendCount = employeeDict["friendCount"] as? Int{
            
            self._friendCount = friendCount
            
        }
        if let friendStatus = employeeDict["friendStatus"] as? Int{
            
            self.FriendStatus = friendStatus
            
        }
        if let isFriend = employeeDict["isFriend"] as? Bool{
            
            self._isFriend = isFriend
            
        }
        if let postId = employeeDict["postId"] as? String{
            
            self._postId = postId
            
        }
        if let likeTimeStamp = employeeDict["likeTimeStamp"] as? Int{
            
            self._likeTimeStamp = "\(likeTimeStamp)"
            
        }
        if let likeProfilePic = employeeDict["profilePic"] as? String{
            
            self._likeProfilePic = likeProfilePic
            
        }
        
        
        if let admin = employeeDict["admin"] as? String{
            
            self._admin = admin
        }
        
    }

    
    init(commentDict: Dictionary<String,AnyObject>) {
        
        if let moderator = commentDict["moderator"] as? String{
            self._isMod = moderator
        }
        
        if let likeStatus = commentDict["likeStatus"] as? Bool{
            
            self._likeStatus = likeStatus
            
        }
        
        if let colorCode = commentDict["colorCode"] as? String{
            
            self._colorCode = colorCode
        }
        
        if let friendStatus = commentDict["friendStatus"] as? Int{
            
            
            self.FriendStatus = friendStatus
        }
        if let commentCount = commentDict["commentCount"] as? Int{
            
            
            self._commentCount = commentCount
        }
        if let commentId = commentDict["commentId"] as? String{
            
            
            self._commentId = commentId
        }
        if let userId = commentDict["userId"] as? String{

            self._userId = userId
        }
        if let name = commentDict["name"] as? String{
            
            
            self._name = name
        }
        if let designation = commentDict["designation"] as? String{
            
            
            self._designation = designation
        }
        if let postId = commentDict["postId"] as? String{
            
            
            self._postId = postId
        }
        if let comment = commentDict["comment"] as? String{
            
            
            self._comment = comment
        }
        if let profilePic = commentDict["profilePic"] as? String{
            
            
            self._likeProfilePic = profilePic
        }
        
        if let timeStamp = commentDict["timeStamp"] as? Int{
            
            let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp))
    
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "d MMM" //Specify your format that you want
            let strDate = dateFormatter.string(from: date as Date)
            
            
            self._likeTimeStamp = strDate
            
        }

    }
    
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.year! >= 2 {
            result = "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                result = "1 year ago"
            } else {
                result = "Last year"
            }
        } else if components.month! >= 2 {
            result = "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                result = "1 month ago"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            result = "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                result = "1 week ago"
            } else {
                result = "Last week"
            }
        } else if components.day! >= 2 {
            result = "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                result = "1 day ago"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1 hour ago"
            } else {
                result = "An hour ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1 minute ago"
            } else {
                result = "A minute ago"
            }
        } else if components.second! >= 3 {
            result = "\(components.second!) seconds ago"
        } else {
            result = "Just now"
        }
        
        return result
    }

  
    
    init(MemberDict:Dictionary<String,AnyObject>) {
        
        print(MemberDict)
        
        if let name = MemberDict["name"] as? String{
            
            self._name = name
            
        }
        
        if let newJoined = MemberDict["newJoined"] as? Bool{
            
            self._isNew = newJoined
            
        }
        
        if let firstname = MemberDict["firstName"] as? String{
            
            self._firstName = firstname
            
        }
        if let lastName = MemberDict["lastName"] as? String{
            
            self._lastName = lastName
            
        }
        
        
        if let userCompany = MemberDict["userCompany"] as? String{
            
            self._userCompany = userCompany
            
        }
        
        if let designation = MemberDict["designation"] as? String{
            
            
            self._designation = designation
        }
        
        if let country = MemberDict["country"] as? String{
            
            self._country = country
            
        }
        
        if let profilePic = MemberDict["profilePic"] as? String{
            
            self._likeProfilePic = profilePic
        }
        
        if let userId = MemberDict["userid"] as? String{
            
            self._friendId = userId
            
        }
        
        if let points = MemberDict["points"] as? String{
            
            self._score = points
        }
        if let rank = MemberDict["rank"] as? String{
            
            self._rank = rank
            
        }
        if let colorCode = MemberDict["colorCode"] as? String{
            
            self._colorCode = colorCode
            
        }
        if let FriendStatus = MemberDict["FriendStatus"] as? Int{
            
            self.FriendStatus = FriendStatus
            
        }
        
        self.contactImg = #imageLiteral(resourceName: "star")
        
    }
    init(FavouriteDict:Dictionary<String,AnyObject>) {
        
        if let moderator = FavouriteDict["moderator"] as? String{
            self._isMod = moderator
        }
        
        if let name = FavouriteDict["name"] as? String{
            
            self._name = name
            
        }
        
        if let designation = FavouriteDict["designation"] as? String{
            
            
            self._designation = designation
        }
        
        if let country = FavouriteDict["country"] as? String{
            
            self._country = country
            
        }
        
        if let profilePic = FavouriteDict["profilePic"] as? String{
            
            self._likeProfilePic = profilePic
        }
        if let userId = FavouriteDict["userid"] as? String{
            
            self._friendId = userId
            
        }
        if let userCompany = FavouriteDict["userCompany"] as? String{
            
            self._userCompany = userCompany
            
        }

        if let points = FavouriteDict["points"] as? String{
            
            self._score = points
        }
        if let rank = FavouriteDict["rank"] as? String{
            
            self._rank = rank
            
        }
        if let colorCode = FavouriteDict["colorCode"] as? String{
            
            self._colorCode = colorCode
            
        }
        
        self.contactImg = #imageLiteral(resourceName: "starg")
        
    }

}
