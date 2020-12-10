//
//  LFeedsItem.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

final class LFeedsItem : Equatable{
    static func == (lhs: LFeedsItem, rhs: LFeedsItem) -> Bool {
        return lhs.postId == rhs.postId
    }
    
    
    private var _feedType: String!
    
    private var _postedUserId:String!
    private var _userCompany:String!
    private var _companyImage:String!
    private var _companyName:String!
    private var _companyId:String!
    private var _postId:String!
    private var _postedUserName:String!
    private var _postedUserDesignation:String!
    private var _timeStamp:Int!
    var likeStatus:Bool = false
    private var _albumid:String!
    private var _postType:String!
    private var _newsLocation:String!
    private var _status:String!
    private var _profilePic:String!
    private var _commentCount: Int!
    var likeCount: Int = 0
    private var _pictureURL: [PictureURL]!
    var userLike: [String] = [""]
    private var _userComment : [String]!
    private var _postedImage: String!
    private var _postBy:String!
    private var _colorCode:String!
    var isPostFavourited:Bool = false
    private var _points:String!
    private var _rank:String!
    private var _heading:String!
    private var _subHeading:String!
    private var _publisherUrl:String!
    var isReported:Bool = false
    var tagList : [TagItem]?
    private var _reportId:String!
    var reportedUserId:String = ""
    private var _newJoined:Bool!
    private var _moderator:String!
    private var _joinedTime:Int!
    private var _eventId:String!
    private var _eventPostedId:String!
    private var _eventName:String!
    private var _eventPicture: String!
    var isInterested = false
    private var _eventDetail: String!
    private var _startDate: String!
    private var _endDate: String!
    private var _startTime: String!
    private var _endTime: String!
    
    var postedUserId : String{ if _postedUserId == nil{ _postedUserId = ""};
        return _postedUserId
    }
    var userCompany : String{ if _userCompany == nil{ _userCompany = ""};
        return _userCompany
    }
    var companyImage : String{ if _companyImage == nil{ _companyImage = ""};
        return _companyImage
    }
    var companyName : String{ if _companyName == nil{ _companyName = ""};
        return _companyName
    }
    var companyId : String{ if _companyId == nil{ _companyId = ""};
        return _companyId
    }
    var postId : String{ if _postId == nil{ _postId = ""};
        return _postId
    }
    var postedUserName : String{ if _postedUserName == nil{ _postedUserName = ""};
        return _postedUserName
    }
    var postedUserDesignation : String{ if _postedUserDesignation == nil{ _postedUserDesignation = ""};
        return _postedUserDesignation
    }
    var postedFriendName: String?
    var timeStamp : String{ if _timeStamp == nil{ _timeStamp = 0 };
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_timeStamp))
        if calendar.isDateInToday(date as Date){
            let date = timeSince(from: date)
            print("if Date : \(date)")
            return "\(date)"
        } else {
            let datemonthformatter = DateFormatter()
            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let dateString = datemonthformatter.string(from: date as Date)
            let timeString = timeFormatter.string(from: date as Date)
            print("Date : \(dateString) \(timeString)")
            return "\(dateString) at \(timeString)"
        }
    }
    var albumId : String{ if _albumid == nil{ _albumid = ""};
        return _albumid
    }
    var newsLocation : String{ if _newsLocation == nil{ _newsLocation = ""};
        return _newsLocation
    }
    var status : String{ if _status == nil{ _status = ""};
        return _status.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var profilePic: String{ if _profilePic == nil ||  _profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || _profilePic == "https://myscrap.com/style/images/icons/profile.png" { _profilePic = ""}
        return _profilePic }
    var commentCount : Int { if _commentCount == nil { _commentCount = 0};
        return _commentCount
    }
    /*var userLike : [String] {
        if _userLike == nil {
            _userLike = [""]
        }
        return _userLike
    }*/
    var userComment : [String] {
        if _userComment == nil {
            _userComment = [""]
        }
        return _userComment
    }
    var pictureURL : [PictureURL] { if _pictureURL == nil { _pictureURL = [PictureURL]() };
        return _pictureURL
    }
    var postedImage : String { if _postedImage == nil { _postedImage = "" };
        return _postedImage
    }
    var postBy : String{ if _postBy == nil{ _postBy = ""};
        return _postBy
    }
    var colorCode : String{ if _colorCode == nil{ _colorCode = ""};
        return _colorCode
    }
    var points : String{ if _points == nil{ _points = ""};
        return _points
    }
    var rank : String { if _rank == nil { _rank = "9999"}; return _rank }
    var heading : String{ if _heading == nil{ _heading = ""};
        return _heading
    }
    var subHeading : String{ if _subHeading == nil{ _subHeading = ""};
        return _subHeading
    }
    var publisherUrl : String{ if _publisherUrl == nil{ _publisherUrl = ""};
        return _publisherUrl
    }
    
    //    var tagList : String{ if _tagList == nil{ _tagList = ""};
    //        return _tagList
    //    }
    var reportId : String{ if _reportId == nil{ _reportId = "" };
        return _reportId
    }
    var newJoined : Bool{ if _newJoined == nil{ _newJoined = false};
        return _newJoined
    }
    var moderator:String{ if _moderator == nil { _moderator = "0" }; return _moderator }
    var joinedTime : String{ if _joinedTime == nil{ _joinedTime = 0 };
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_joinedTime))
        if calendar.isDateInToday(date as Date){
            let date = timeSince(from: date)
            return "\(date)"
        } else {
            let datemonthformatter = DateFormatter()
            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm"
            let dateString = datemonthformatter.string(from: date as Date)
            let timeString = timeFormatter.string(from: date as Date)
            return "\(dateString) at \(timeString)"
        }
    }
    var eventId:String{
        if _eventId == nil{
            _eventId = ""
        }
        return _eventId
    }
    var eventPostedId:String{ if _eventPostedId == nil { _eventPostedId = "" }; return _eventPostedId}
    var eventName:String{
        if _eventName == nil{
            _eventName = ""
        }
        return _eventName
    }
    var eventPicture: String{
        if _eventPicture == nil {
            _eventPicture = ""
        }
        return _eventPicture
    }
    
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        var result = ""
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
            result = "\(components.hour!) hrs ago"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1 hr ago"
            } else {
                result = "1 hr ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) mins ago"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1 min ago"
            } else {
                result = "1 min ago"
            }
        } else if components.second! >= 3 {
            
            result = "Just now"
        }
        
        return result
    }
    
    // MARK DESCRIPTION
    var textStatus: NSMutableAttributedString{
        let st = status + "\n"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: st, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedString.Key.font: Fonts.descriptionFont, NSAttributedString.Key.paragraphStyle: style])
        
        if let tags = tagList {
            for tag in tags{
                if let name = tag.taggedName , let id = tag.taggedId {
                    if status.contains(name){
                        let ranges = st.subStringranges(of: name)
                        for range in ranges{
                            let rnge: NSRange = st.nsRange(from: range)
                            
                            attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.USERTAG), value: id, range: rnge)
                            attributedString.addAttribute(.foregroundColor, value: UIColor.GREEN_PRIMARY, range: rnge)
                            attributedString.addAttribute(.font, value: Fonts.userTagFont, range: rnge)
                            
                        }
                    }
                }
            }
        }
        
        if let linkRanges = st.extractedWeblinks(){
            for rng in linkRanges{
                if let rn = st.range(from: rng) {
                    let value = st[rn]
                    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rng)
                    attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.GREEN_PRIMARY, range: rng)
                    attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.URL), value: value, range: rng)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.GREEN_PRIMARY, range: rng)
                    attributedString.addAttribute(.font, value: Fonts.descriptionFont, range: rng)
                }
            }
        }
        return attributedString
    }
    
    var textImgStatus: NSMutableAttributedString{
        let st = status + "\n"
        
        //let style = NSMutableParagraphStyle()
        //style.lineSpacing = 5
        
        let attributedString = NSMutableAttributedString(string: st, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedString.Key.font: Fonts.landDescFont])
        
        if let tags = tagList {
            for tag in tags{
                if let name = tag.taggedName , let id = tag.taggedId {
                    if status.contains(name){
                        let ranges = st.subStringranges(of: name)
                        for range in ranges{
                            let rnge: NSRange = st.nsRange(from: range)
                            
                            attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.USERTAG), value: id, range: rnge)
                            attributedString.addAttribute(.foregroundColor, value: UIColor.GREEN_PRIMARY, range: rnge)
                            attributedString.addAttribute(.font, value: Fonts.userTagFont, range: rnge)
                            
                        }
                    }
                }
            }
        }
        
        if let linkRanges = st.extractedWeblinks(){
            for rng in linkRanges{
                if let rn = st.range(from: rng) {
                    let value = st[rn]
                    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rng)
                    attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.GREEN_PRIMARY, range: rng)
                    attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.URL), value: value, range: rng)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.GREEN_PRIMARY, range: rng)
                    attributedString.addAttribute(.font, value: Fonts.descriptionFont, range: rng)
                }
            }
        }
        return attributedString
    }
    
    var eventDetail:String{ if _eventDetail == nil { _eventDetail = "" }; return _eventDetail}
    var startDate:String{ if _startDate == nil { _startDate = "" }; return _startDate}
    var endDate:String{ if _endDate == nil { _endDate = "" }; return _endDate}
    var startTime:String{ if _startTime == nil { _startTime = "" }; return _startTime}
    var endTime:String{ if _endTime == nil { _endTime = "" }; return _endTime}
    
    enum LandCellType: String{
        case landFeedTextCell
        case landFeedImageCell
        case landFeedImageTextCell
        
    }
    
    var cellType: LandCellType{
        var ct = LandCellType.landFeedTextCell
        if !pictureURL.isEmpty && status != "" {
            ct = .landFeedImageTextCell
        } else if !pictureURL.isEmpty{
            ct = .landFeedImageCell
        } else {
            ct = .landFeedTextCell
        }
        return ct
    }
    
    init (FeedDict:[String:AnyObject]){
        if let feedType = FeedDict["feedType"] as? String {
            self._feedType = feedType
        }
        if let postedUserId = FeedDict["postedUserId"] as? String{
            self._postedUserId = postedUserId
        }
        if let userCompany = FeedDict["userCompany"] as? String{
            self._userCompany = userCompany
        }
        if let companyImage = FeedDict["companyImage"] as? String{
            self._companyImage = companyImage
        }
        if let companyName = FeedDict["companyName"] as? String{
            self._companyName = companyName
        }
        if let companyId = FeedDict["companyId"] as? String{
            self._companyId = companyId
        }
        if let postId = FeedDict["postId"] as? String{
            self._postId = postId
        }
        if let postedUserName = FeedDict["postedUserName"] as? String{
            self._postedUserName = postedUserName
        }
        if let postedUserDesignation = FeedDict["postedUserDesignation"] as? String{
            self._postedUserDesignation = postedUserDesignation
        }
        if let timeStamp = FeedDict["timeStamp"] as? Int{
            self._timeStamp = timeStamp
        }
        if let likeStatus = FeedDict["likeStatus"] as? Bool{
            self.likeStatus = likeStatus
        }
        if let albumid = FeedDict["albumid"] as? String{
            self._albumid = albumid
        }
        if let postType = FeedDict["postType"] as? String{
            self._postType = postType
        }
        if let newsLocation = FeedDict["newsLocation"] as? String{
            self._newsLocation = newsLocation
        }
        if let status = FeedDict["status"] as? String{
            self._status = status
        }
        if let profilePic = FeedDict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let commentCount = FeedDict["commentCount"] as? Int{
            self._commentCount = commentCount
        }
        if let likeCount = FeedDict["likeCount"] as? Int{
            self.likeCount = likeCount
        }
        if let like = FeedDict["userLike"] as? [String] {
            //self._userLike = like
            self.userLike = like
        }
        if let comment = FeedDict["userComment"] as? [String] {
            self._userComment = comment
        }
        if let pictures = FeedDict["pictureUrl"] as? [[String:AnyObject]]{
            var data = [PictureURL]()
            for obj in pictures{
                let picture = PictureURL(pictureDict: obj)
                data.append(picture)
            }
            self._pictureURL = data
        }
        if let pictures = FeedDict["pictureUrl"] as? [[String:AnyObject]]{
            let obj = pictures.first
            if let images = obj?["images"] as? String {
                self._postedImage = images
            }
        }
        if let postBy = FeedDict["postBy"] as? String{
            self._postBy = postBy
        }
        if let colorCode = FeedDict["colorCode"] as? String{
            self._colorCode = colorCode
        }
        if let isPostFavourited = FeedDict["isPostFavourited"] as? Bool{
            self.isPostFavourited = isPostFavourited
        }
        if let points = FeedDict["points"] as? String{
            self._points = points
        }
        if let rank = FeedDict["rank"] as? String{
            self._rank = rank
        }
        if let heading = FeedDict["heading"] as? String{
            self._heading = heading
        }
        if let subHeading = FeedDict["subHeading"] as? String{
            self._subHeading = subHeading
        }
        if let publisherUrl = FeedDict["publisherUrl"] as? String{
            self._publisherUrl = publisherUrl
        }
        if let isReported = FeedDict["isReported"] as? Bool{
            self.isReported = isReported
        }
        if let tagLists = FeedDict["tagList"] as? [[String:AnyObject]]{
            var tags = [TagItem]()
            for obj in tagLists{
                let tag = TagItem(Dict: obj)
                tags.append(tag)
            }
            self.tagList = tags
        }
        if let reportId = FeedDict["reportId"] as? String{
            self._reportId = reportId
        }
        if let reportedUserId = FeedDict["reportedUserId"] as? String{
            self.reportedUserId = reportedUserId
        }
        if let newJoined = FeedDict["newJoined"] as? Bool{
            self._newJoined = newJoined
        }
        if let moderator = FeedDict["moderator"] as? String{
            self._moderator = moderator
        }
        if let joinedTime = FeedDict["joinedTime"] as? Int{
            self._joinedTime = joinedTime
        }
        if let eventId = FeedDict["eventId"] as? String{
            self._eventId = eventId
        }
        if let eventPostedId = FeedDict["eventPostedId"] as? String{
            self._eventPostedId = eventPostedId
        }
        if let eventName = FeedDict["eventName"] as? String{
            self._eventName = eventName
        }
        if let eventPicture = FeedDict["eventPicture"] as? String{
            self._eventPicture = eventPicture
        }
        if let isInterested = FeedDict["isInterested"] as? Bool{
            self.isInterested = isInterested
        }
        if let eventDetail = FeedDict["eventDetail"] as? String{
            self._eventDetail = eventDetail
        }
        if let startDate = FeedDict["startDate"] as? String{
            self._startDate = startDate
        }
        if let endDate = FeedDict["endDate"] as? String{
            self._endDate = endDate
        }
        if let startTime = FeedDict["startTime"] as? String{
            self._startTime = startTime
        }
        if let endTime = FeedDict["endTime"] as? String{
            self._endTime = endTime
        }
    }
}
