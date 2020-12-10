//
//  Feeds.swift
//  myscrap
//
//  Created by MS1 on 5/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

final class Feeds{
    private var _postedUserId:String!
    private var _postId:String!
    private var _postedUserName:String!
    private var _postedUserDesignation:String!
    private var _timeStamp:Int!
     var likeStatus:Bool!
    private var _albumid:String!
    private var _postType:String!
    private var _status:String!
    private var _profilePic:String!
    private var _commentCount:Int!
     var likeCount:Int!
    private var _pictureUrl:[Dictionary<String,AnyObject>]!

    private var _pictureURL : [PictureURL]!

    private var _postBy:String!
    private var _userCompany:String!
    private var _colorCode:String!
    var ispostFavourited:Bool!
    var score:String!
    var rank:String!
    var expanded:Bool!
    var isNew: Bool!
    var isReported: Bool = false

    private var _newsLocation: String!
    private var _publisherURL: String!
    private var _subHeading: String!
    private var _heading: String!
    private var _companyImage: String!


    
    
    
    var pictureArray:[PictureURL]{
        if _pictureURL == nil{
            _pictureURL = [PictureURL]()
        }
        return _pictureURL
    }
    var newsLocation: String{
        if _newsLocation == nil{
            _newsLocation = ""
        }
        return _newsLocation
    }
    var publishURL: String{
        if _publisherURL == nil{
            _publisherURL = ""
        }
        return _publisherURL
    }
    var subHeading: String{
        if _subHeading == nil{
            _subHeading = ""
        }
        return _subHeading
    }
    var heading:String{
        if _heading == nil{
            _heading = ""
        }
        return _heading
    }
    var companyImage:String{
        if _companyImage == nil{
            _companyImage = ""
        }
        return _companyImage
    }
    

    
    private var _postedFriendName:String!
    
    
    var postedFriendName:String{
        if _postedFriendName == nil{
            
            _postedFriendName = ""
        }
        
        return _postedFriendName
    }
    
    
    var userCompany:String{
        
        if _userCompany == nil{
            
            
            _userCompany = ""
        }
        return _userCompany
    }
    
     var colorCode:String{
        
        if _colorCode == nil{
        _colorCode = "#118d24"
            
        }
        return _colorCode
    }
    
    var postedUserId:String{
        
        if _postedUserId == nil {
            
            _postedUserId = ""
            
        }
        return _postedUserId
    }
    
    var postId:String{
        
        if _postId == nil{
            
            _postId = ""
        }
            return _postId
    }
    
    var postedUserName:String{
        
        if _postedUserName == nil{
            
            _postedUserName = ""
            
        }
        return _postedUserName
    }
    var postedUserDesignation:String{
        
        if _postedUserDesignation == nil {
            
            
            _postedUserDesignation = ""
        }
        
        return _postedUserDesignation
    }
    
    var timestamp:String{
        
        if _timeStamp == nil {
            
            _timeStamp = 0
            
        }
        
    
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_timeStamp))
        
        
        if calendar.isDateInToday(date as Date){
            
            let date = timeSince(from: date)
            
            return date
        } else {
            
            let datemonthformatter = DateFormatter()
            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let dateString = datemonthformatter.string(from: date as Date)
            let timeString = timeFormatter.string(from: date as Date)
            
            return "\(dateString) at \(timeString)"
            
        }
        
        
    
    }

    var timeStamp1: Int{
        if _timeStamp == nil{
            _timeStamp = 0
        }
        return _timeStamp
    }
    

    
//    var likeStatus:Bool{
//        
//        if _likeStatus == nil{
//            
//            _likeStatus = false
//            
//        }
//        
//        return _likeStatus
//    }

    var albumId:String{
        
        if _albumid == nil{
            
            _albumid = ""
            
        }
        return _albumid
    }
    
    var postType:String{
        if _postType == nil{
            
            _postType = ""
        }
        
        return _postType
    }
    
    var staus:String{
        
        if _status == nil{
            
            _status = ""
        }
        return _status.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var profilePic:String{
        
        if _profilePic == nil || _profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || _profilePic == "https://myscrap.com/style/images/icons/profile.png" {
            
            _profilePic = ""
        }
        
        return _profilePic
    }
    
    var commentCount:Int{
        
        if _commentCount == nil{
            
            _commentCount = 0
        }
        return _commentCount
    }

    
    
//    var likeCount:Int{
//        if _likeCount == nil{
//            
//            _likeCount = 0
//            
//        }
//        
//        return _likeCount
//    }
    

    var pictureURL : [Dictionary<String,AnyObject>]{
        
        if _pictureUrl == nil{
            
            _pictureUrl = [Dictionary<String,AnyObject>]()
        }
        return _pictureUrl
    }
    
    var postBy:String{
        
        if _postBy == nil{
            
            _postBy = ""
            
        }
           return _postBy
    }
    
    private var _reportId: String!
    private var _reportBy:String!
    
    var reportId: String{
        if _reportId == nil{
            _reportId = ""
        }
        return _reportId
    }
    var reportedUserId: String = ""
    
    var reportBy:String{
        if _reportBy == nil{
            _reportBy = ""
        }
        return _reportBy
    }
    
    init(feedDict:Dictionary<String,AnyObject>) {
        
        if let reportId = feedDict["reportId"] as? String{
            self._reportId = reportId
        }
        
        if let reportBy = feedDict["reportBy"] as? String{
            self._reportBy = reportBy
        }

        if let postedFriendName = feedDict["postedFriendName"] as? String{
            
            self._postedFriendName = postedFriendName
            
        }
        
        if let postuserid = feedDict["postedUserId"] as? String{
            
            self._postedUserId = postuserid
            
        }
        
        if let colorc = feedDict["colorCode"] as? String{
            
            self._colorCode = colorc
            
        }

        if let postid = feedDict["postId"] as? String{
            
            self._postId = postid
        }
        if let postedusername = feedDict["postedUserName"] as? String{
            
            
            self._postedUserName = postedusername
        }
        
        if let postedUserDesignation = feedDict["postedUserDesignation"] as? String{
            
            
            self._postedUserDesignation = postedUserDesignation
        }
        if let timeStamp = feedDict["timeStamp"] as? Int{
            
            self._timeStamp = timeStamp
            
            
        }
        if let likeStatus = feedDict["likeStatus"] as? Bool{
            
            self.likeStatus = likeStatus
        }
        if let albumId = feedDict["albumid"] as? String{
            
            self._albumid = albumId
        }
        if let posttype = feedDict["postType"] as? String{
            
            self._postType = posttype
            
        }
        if let status = feedDict["status"] as? String{
            self._status = status
        }
        if let profilepic = feedDict["profilePic"] as? String{
            
            self._profilePic = profilepic
            
        }
        if let commentCount = feedDict["commentCount"] as? Int{
            self._commentCount = commentCount
        }

        
        if let likecount = feedDict["likeCount"] as? Int{
            
            self.likeCount = likecount
            
        }
        if let postby = feedDict["postBy"] as? String{
            
            self._postBy = postby
            
        }
        if let pictureurl = feedDict["pictureUrl"] as? [Dictionary<String,AnyObject>]{
            
            self._pictureUrl = pictureurl
            
        }
        if let userCompany = feedDict["userCompany"] as? String{
            
            self._userCompany = userCompany
            
        }
        if let points = feedDict["points"] as? String{
            
            self.score = points
            
        }
        if let rank = feedDict["rank"] as? String{
            
            self.rank = rank
        }

        
        if let postfavor = feedDict["isPostFavourited"] as? Bool{
            
            self.ispostFavourited = postfavor
        }
        

        if let newJoined = feedDict["newJoined"] as? Bool{
            
            self.isNew = newJoined
        }

        if let publisherUrl = feedDict["publisherUrl"] as? String{
            
            self._publisherURL = publisherUrl
        }
        if let subHeading = feedDict["subHeading"] as? String{
            
            self._subHeading = subHeading
        }
        if let heading = feedDict["heading"] as? String{
            
            self._heading = heading
        }
        if let companyImage = feedDict["companyImage"] as? String{
            
            self._companyImage = companyImage
        }
        
        if let newsLocation = feedDict["newsLocation"] as? String{
            
            self._newsLocation = newsLocation
        }
        if let pictures = feedDict["pictureUrl"] as? [[String:AnyObject]]{
            var pict  = [PictureURL]()
            for obj in pictures{
                let pic = PictureURL(pictureDict: obj)
                pict.append(pic)
            }
            self._pictureURL = pict
        }
        if let isReported = feedDict["isReported"] as? Bool{
            self.isReported = isReported
        }
        if let reportedUserId = feedDict["reportedUserId"] as? String{
            self.reportedUserId = reportedUserId
        }
        self.expanded = false

    }
    
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
//        
//        if components.year! >= 2 {
//            result = "\(components.year!) years ago"
//        } else if components.year! >= 1 {
//            if numericDates {
//                result = "1 year ago"
//            } else {
//                result = "Last year"
//            }
//        } else if components.month! >= 2 {
//            result = "\(components.month!) months ago"
//        } else if components.month! >= 1 {
//            if numericDates {
//                result = "1 month ago"
//            } else {
//                result = "Last month"
//            }
//        } else if components.weekOfYear! >= 2 {
//            result = "\(components.weekOfYear!) weeks ago"
//        } else if components.weekOfYear! >= 1 {
//            if numericDates {
//                result = "1 week ago"
//            } else {
//                result = "Last week"
//            }
//        } else if components.day! >= 2 {
//            result = "\(components.day!) days ago"
//        }
//        else
        
            if components.day! >= 1 {
            if numericDates {
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
                let dateString = dayTimePeriodFormatter.string(from: from as Date)
                
                result = "Updated: \(dateString)"
            } else {
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
                let dateString = dayTimePeriodFormatter.string(from: from as Date)
                
                result = "Updated: \(dateString)"
                
                }
        } else if components.hour! >= 2 {
            result = "\(components.hour!) hrs"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1 hr"
            } else {
                result = "1 hr"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) mins"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1 min"
            } else {
                result = "1 min"
            }
        } else if components.second! >= 3 {
    
            result = "Just now"
        }
        
        return result
    }
    
    
    

//    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
//        let calendar = Calendar.current
//        let now = NSDate()
//        let earliest = now.earlierDate(from as Date)
//        let latest = earliest == now as Date ? from : now
//        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
//        
//        var result = ""
//        
//        if components.year! >= 2 {
//            result = "\(components.year!) years ago"
//        } else if components.year! >= 1 {
//            if numericDates {
//                result = "1 year ago"
//            } else {
//                result = "Last year"
//            }
//        } else if components.month! >= 2 {
//            result = "\(components.month!) months ago"
//        } else if components.month! >= 1 {
//            if numericDates {
//                result = "1 month ago"
//            } else {
//                result = "Last month"
//            }
//        } else if components.weekOfYear! >= 2 {
//            result = "\(components.weekOfYear!) weeks ago"
//        } else if components.weekOfYear! >= 1 {
//            if numericDates {
//                result = "1 week ago"
//            } else {
//                result = "Last week"
//            }
//        } else if components.day! >= 2 {
//            result = "\(components.day!) days ago"
//        } else if components.day! >= 1 {
//            if numericDates {
//                result = "1 day ago"
//            } else {
//                result = "Yesterday"
//            }
//        } else if components.hour! >= 2 {
//            result = "\(components.hour!) hours ago"
//        } else if components.hour! >= 1 {
//            if numericDates {
//                result = "1 hour ago"
//            } else {
//                result = "An hour ago"
//            }
//        } else if components.minute! >= 2 {
//            result = "\(components.minute!) minutes ago"
//        } else if components.minute! >= 1 {
//            if numericDates {
//                result = "1 minute ago"
//            } else {
//                result = "A minute ago"
//            }
//        } else if components.second! >= 3 {
//            result = "\(components.second!) seconds ago"
//        } else {
//            result = "Just now"
//        }
//        
//        return result
//    }
    
}















