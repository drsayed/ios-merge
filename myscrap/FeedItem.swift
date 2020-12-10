//
//  FeedItem.swift
//  myscrap
//
//  Created by MS1 on 10/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit

final class FeedItem: Equatable{
    
    //Listing
    var listingFeed: ListingFeed?
    
    // Events
    
    private var _eventPicture: String!
    var isInterested = false
    private var _eventId:String!
   var eventDate:String?
    private var _eventName:String!
    
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
    
    
    var eventId:String{
        if _eventId == nil{
            _eventId = ""
        }
        return _eventId
    }
    
    
    
    enum CellType: String{
        
        case feedNewUserCell
        case feedTextCell
        case feedImageCell
        case feedImageTextCell
        case userFeedTextCell
        case userFeedImageCell
        case userFeedImageTextCell
        case newsTextCell
        case newsImageCell
        case eventCell
        case feedListingCell
    }
    
    enum PostType{
        
        case friendProfilePost
        case userProfilePost
        case friendUserPost
        case eventPost
        case none
    }
    
    var postType: PostType{
        if _postType == "friendProfilePost"{
            return .friendProfilePost
        } else if _postType == "userProfilePost"{
            return .userProfilePost
        } else if _postType == "friendUserPost"{
            return .friendUserPost
        }else if _postType == "eventPost"{
            return .eventPost
        }else {
            return .none
        }
    }
    
    var cellType: CellType{
        var ct = CellType.feedTextCell
        if _postType == "newsPost"{
            if pictureURL.count == 0 {
                ct = .newsTextCell
            } else {
                ct = .newsImageCell
            }
        } else if _postType == "eventPost" {
            ct = .eventCell
        } else if _postType == "newUserJoined"{
            ct = .feedNewUserCell
        } else if _postType == "marketPost"{
            ct = .feedListingCell
        }
        else {
            if !pictureURL.isEmpty && status != "" {
                ct = .feedImageTextCell
            } else if !pictureURL.isEmpty{
                ct = .feedImageCell
            } else {
                ct = .feedTextCell
            }
        }
        
        return ct
    }
    
    var userCellType: CellType{
        var uct = CellType.userFeedTextCell
        if _postType == "newsPost"{
            if pictureURL.count == 0 {
                uct = .newsTextCell
            } else {
                uct = .newsImageCell
            }
        } else if _postType == "eventPost" {
            uct = .eventCell
        } else if _postType == "newUserJoined"{
            uct = .feedNewUserCell
        } else if _postType == "marketPost"{
            uct = .feedListingCell
        }
        else {
            if !pictureURL.isEmpty && status != "" {
                uct = .userFeedImageTextCell
            } else if !pictureURL.isEmpty{
                uct = .userFeedImageCell
            } else {
                uct = .userFeedTextCell
            }
        }
        
        return uct
    }
    

    var tagList : [TagItem]?
    
    
    
    var isCellExpanded: Bool = false
    
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
    private var _memProfilePic: String!
    private var _commentCount: Int!
    var likeCount: Int = 0
    private var _pictureURL: [PictureURL]!
    private var _postBy:String!
    private var _colorCode:String!
    var isPostFavourited:Bool = false
    private var _points:String!
    private var _rank:String!
    private var _heading:String!
    private var _subHeading:String!
    private var _publisherUrl:String!
    var isReported:Bool = false
    //private var _tagList:String!
    private var _reportId:String!
    var reportedUserId:String = ""
    private var _newJoined:Bool!
    private var _moderator:String!
    private var _reportBy:String!
    private var _isVideo: Bool!
    private var _videoUrl: String!
    private var _videoThumbnail: String!
    private var _videoType: String!
    
    //Members data from msProfileDetails API
    private var _postNewId: String!              //Already used name postId
    private var _companynews: String!
    private var _tagcontent: String!
    private var _check_tgged: String!
    private var _readmoreval: String!
    private var _comments: Int!
    private var _cmtname: String!
    private var _content_css: String!
    private var _newuser: String!
    private var _usrlkd: String!
    private var _likes: Int!
    private var _iLiked: String!
    private var _likename: String!
    private var _postimage: String!
    private var _postimage_ck: String!
    private var _colorUser: String!
    private var _user_id: String!
    private var _userRank: String!
    private var _usrCompany: String!
    private var _lsitingId: String!
    private var _lsiting_quantity: String!
    private var _listOffer: String!
    private var _listingProduct: String!
    private var _isri_code: String!
    private var _litingPostedTime: String!
    private var _usrstatus: String!
    private var _usrShortname: String!
    private var _username: String!
    private var _desi: String!
    private var _post_time: String!
    private var _content: String!
    private var _color_code: String!
    private var _check_favpost: String!
    private var _action_to_perform: String!
    private var _userimage: String!
    private var _profileLetter: String!
    
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
    
    var postedFriendName: String?
    
    var postedUserDesignation : String{ if _postedUserDesignation == nil{ _postedUserDesignation = ""};
        return _postedUserDesignation
    }
    var timeStamp : String{ if _timeStamp == nil{ _timeStamp = 0 };
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_timeStamp))
        if calendar.isDateInToday(date as Date){
            let date = timeSince(from: date)
            return "\(date)"
        } else {
            let datemonthformatter = DateFormatter()
            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"     hh->12hrs HH->24hrs
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let dateString = datemonthformatter.string(from: date as Date)
            let timeString = timeFormatter.string(from: date as Date)
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
    var memProfilePic: String{ if _memProfilePic == nil ||  _memProfilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || _memProfilePic == "https://myscrap.com/style/images/icons/profile.png" { _memProfilePic = ""}
        return _memProfilePic }
    var commentCount : Int { if _commentCount == nil { _commentCount = 0};
        return _commentCount
    }
    var pictureURL : [PictureURL] { if _pictureURL == nil { _pictureURL = [PictureURL]() };
        return _pictureURL
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
    var heading : String{ if _heading == nil{ _heading = ""};
        return _heading
    }
    var subHeading : String{ if _subHeading == nil{ _subHeading = ""};
        return _subHeading
    }
    var publisherUrl : String{ if _publisherUrl == nil{ _publisherUrl = ""};
        return _publisherUrl
    }
    var reportId : String{ if _reportId == nil{ _reportId = "" };
        return _reportId
    }
    var newJoined : Bool{ if _newJoined == nil{ _newJoined = false};
        return _newJoined
    }
    var moderator:String{ if _moderator == nil { _moderator = "0" }; return _moderator }
    var reportBy:String{ if _reportBy == nil { _reportBy = "" }; return _reportBy}
    var rank : String { if _rank == nil { _rank = "9999"}; return _rank }

    
    // MARK DESCRIPTION
    var description: NSMutableAttributedString{
        var st = status + "\n"
        
        var shouldTrim : Bool = false
        
        if !isCellExpanded && st.count > 300 {
            shouldTrim = true
            st = st.truncate(length: 100).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let attributedString = NSMutableAttributedString(string: st, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedString.Key.font: Fonts.descriptionFont])
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
        if shouldTrim {
            let mutableString = NSMutableAttributedString(string: "...Continue Reading", attributes:[ .foregroundColor: UIColor.gray, .font : Fonts.descriptionFont])
            attributedString.append(mutableString)
            let myRange = NSRange(location: st.count , length: 19)
            attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.CONTINUE_READING), value: "abc", range: myRange)
            
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
   
    
  
    
    var newsDescription: NSAttributedString{
        if isCellExpanded{
            return NSAttributedString(string: "\(newsLocation) : \(status)", attributes: [.font: Fonts.descriptionFont , .foregroundColor : UIColor.BLACK_ALPHA])
        } else {
            if status.count > 300 {
                let st = status.truncate(length: 100).trimmingCharacters(in: .whitespacesAndNewlines)
                let rtStatus = NSMutableAttributedString(string: "\(newsLocation) : \(st)", attributes: [.font : Fonts.descriptionFont , .foregroundColor: UIColor.BLACK_ALPHA])
                let readMore = NSMutableAttributedString(string: "... Continue Reading", attributes: [.foregroundColor: UIColor.gray, .font : Fonts.descriptionFont])
                rtStatus.append(readMore)
                return rtStatus
            } else {
                isCellExpanded = true
                return NSAttributedString(string: "\(newsLocation) : \(status)", attributes: [.font: Fonts.descriptionFont , .foregroundColor : UIColor.BLACK_ALPHA])
            }
        }
    }
    
    //Assigning the values from msProfileDetails API
    var postuserId : String{ if _postNewId == nil{ _postNewId = ""};
        return _postNewId
    }
    var companynews : String{ if _companynews == nil{ _companynews = ""};
        return _companynews
    }
    var tagcontent : String{ if _tagcontent == nil{ _tagcontent = ""};
        return _tagcontent
    }
    var check_tgged : String{ if _check_tgged == nil{ _check_tgged = ""};
        return _check_tgged
    }
    var readmoreval : String{ if _readmoreval == nil{ _readmoreval = ""};
        return _readmoreval
    }
    var comments : Int{ if _comments == nil{ _comments = 0};
        return _comments
    }
    var cmtname : String{ if _cmtname == nil{ _cmtname = ""};
        return _cmtname
    }
    var content_css : String{ if _content_css == nil{ _content_css = ""};
        return _content_css
    }
    var newuser : String{ if _newuser == nil{ _newuser = ""};
        return _newuser
    }
    var liked : String{ if _usrlkd == nil{ _usrlkd = ""};
        return _usrlkd
    }
    var likes : Int{ if _likes == nil{ _likes = 0};
        return _likes
    }
    var iLiked : String{ if _iLiked == nil{ _iLiked = ""};
        return _iLiked
    }
    var likename : String{ if _likename == nil{ _likename = ""};
        return _likename
    }
    var postimage : String{ if _postimage == nil{ _postimage = ""};
        return _postimage
    }
    var postimage_ck : String{ if _postimage_ck == nil{ _postimage_ck = ""};
        return _postimage_ck
    }
    var colorUser : String{ if _colorUser == nil{ _colorUser = ""};
        return _colorUser
    }
    var user_id : String{ if _user_id == nil{ _user_id = ""};
        return _user_id
    }
    var userRank : String{ if _userRank == nil{ _userRank = ""};
        return _userRank
    }
    var usrCompany : String{ if _usrCompany == nil{ _usrCompany = ""};
        return _usrCompany
    }
    var lsitingId : String{ if _lsitingId == nil{ _lsitingId = ""};
        return _lsitingId
    }
    var lsiting_quantity : String{ if _lsiting_quantity == nil{ _lsiting_quantity = ""};
        return _lsiting_quantity
    }
    var listOffer : String{ if _listOffer == nil{ _listOffer = ""};
        return _listOffer
    }
    var listingProduct : String{ if _listingProduct == nil{ _listingProduct = ""};
        return _listingProduct
    }
    var isri_code : String{ if _isri_code == nil{ _isri_code = ""};
        return _isri_code
    }
    var litingPostedTime : String{ if _litingPostedTime == nil{ _litingPostedTime = ""};
        return _litingPostedTime
    }
    var usrStatus : String{ if _usrstatus == nil{ _usrstatus = ""};
        return _usrstatus
    }
    var usrShortName : String{ if _usrShortname == nil{ _usrShortname = ""};
        return _usrShortname
    }
    var username : String{ if _username == nil{ _username = ""};
        return _username
    }
    var desi : String{ if _desi == nil{ _desi = ""};
        return _desi
    }
    var post_time : String{ if _post_time == nil{ _post_time = ""};
        return _post_time
    }
    var content : String{ if _content == nil{ _content = ""};
        return _content
    }
    var color_code : String{ if _color_code == nil{ _color_code = ""};
        return _color_code
    }
    var check_favpost : String{ if _check_favpost == nil{ _check_favpost = ""};
        return _check_favpost
    }
    var action_to_perform : String{ if _action_to_perform == nil{ _action_to_perform = ""};
        return _action_to_perform
    }
    var userimage : String{ if _userimage == nil{ _userimage = ""};
        return _userimage
    }
    var profileLetter : String{ if _profileLetter == nil{ _profileLetter = ""};
        return _profileLetter
    }
    
    
    // Initializing Dictionary
    init (FeedDict:[String:AnyObject]){
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
        if let companyId = FeedDict["companyId"] as? String{
            self._companyId = companyId
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
        if let commentCount = FeedDict["commentCount"] as? Int{
            self._commentCount = commentCount
        }
        if let likeCount = FeedDict["likeCount"] as? Int{
            self.likeCount = likeCount
        }
        if let pictures = FeedDict["pictureUrl"] as? [[String:AnyObject]]{
            var data = [PictureURL]()
            for obj in pictures{
               let picture = PictureURL(pictureDict: obj)
                data.append(picture)
            }
            self._pictureURL = data
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
        if let reportId = FeedDict["reportId"] as? String{
            self._reportId = reportId
        }
        if let reportedUserId = FeedDict["reportedUserId"] as? String{
            self.reportedUserId = reportedUserId
        }
        if let newJoined = FeedDict["newJoined"] as? Bool{
            self._newJoined = newJoined
        }
        if let reportBy = FeedDict["reportBy"] as? String{
            self._reportBy = reportBy
        }
        if let profilePic = FeedDict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let tagLists = FeedDict["tagList"] as? [[String:AnyObject]]{
            var tags = [TagItem]()
            for obj in tagLists{
                let tag = TagItem(Dict: obj)
                tags.append(tag)
            }
            self.tagList = tags
        }
        
        if let eventId = FeedDict["eventId"] as? String{
            self._eventId = eventId
        }
        if let eventName = FeedDict["eventName"] as? String{
            self._eventName = eventName
        }
        if let eventPicture = FeedDict["eventPicture"] as? String{
            self._eventPicture = eventPicture
        }
        if let eventDate = FeedDict["startDate"] as? String{
            self.eventDate = eventDate
        }
        if let isInterested = FeedDict["isInterested"] as? Bool{
            self.isInterested = isInterested
        }
        if let moderator = FeedDict["moderator"] as? String{
            self._moderator = moderator
        }
        if let postfname = FeedDict["postedFriendName"] as? String{
            self.postedFriendName = postfname
        }
        if let listingObject = FeedDict["listingFeed"] as? [String: AnyObject]{
            self.listingFeed = ListingFeed(dict: listingObject)
        }
        
        //Assign the values from msProfileDetails
        if let postuserId = FeedDict["postId"] as? String {
            self._postNewId = postuserId
        }
        if let companynews = FeedDict["companynews"] as? String {
            self._companynews = companynews
        }
        if let tagcontent = FeedDict["tagcontent"] as? String {
            self._tagcontent = tagcontent
        }
        if let check_tgged = FeedDict["check_tgged"] as? String {
            self._check_tgged = check_tgged
        }
        if let readmoreval = FeedDict["readmoreval"] as? String {
            self._readmoreval = readmoreval
        }
        if let comments = FeedDict["comments"] as? Int {
            self._comments = comments
        }
        if let cmtname = FeedDict["cmtname"] as? String {
            self._cmtname = cmtname
        }
        if let content_css = FeedDict["content_css"] as? String {
            self._content_css = content_css
        }
        if let newuser = FeedDict["newuser"] as? String {
            self._newuser = newuser
        }
        if let liked = FeedDict["liked"] as? String {
            self._usrlkd = liked
        }
        if let likes = FeedDict["likes"] as? Int {
            self._likes = likes
        }
        if let iLiked = FeedDict["iLiked"] as? String {
            self._iLiked = iLiked
        }
        if let likename = FeedDict["likename"] as? String {
            self._likename = likename
        }
        if let postimage = FeedDict["postimage"] as? String {
            self._postimage = postimage
        }
        if let postimage_ck = FeedDict["postimage_ck"] as? String {
            self._postimage_ck = postimage_ck
        }
        if let colorUser = FeedDict["colorUser"] as? String {
            self._colorUser = colorUser
        }
        if let user_id = FeedDict["user_id"] as? String {
            self._user_id = user_id
        }
        if let rank = FeedDict["rank"] as? String {
            self._userRank = rank
        }
        if let company = FeedDict["company"] as? String {
            self._usrCompany = company
        }
        if let lsitingId = FeedDict["lsitingId"] as? String {
            self._lsitingId = lsitingId
        }
        if let lsiting_quantity = FeedDict["lsiting_quantity"] as? String {
            self._lsiting_quantity = lsiting_quantity
        }
        if let listOffer = FeedDict["listOffer"] as? String {
            self._listOffer = listOffer
        }
        if let listingProduct = FeedDict["listingProduct"] as? String {
            self._listingProduct = listingProduct
        }
        if let isri_code = FeedDict["isri_code"] as? String {
            self._isri_code = isri_code
        }
        if let litingPostedTime = FeedDict["litingPostedTime"] as? String {
            self._litingPostedTime = litingPostedTime
        }
        if let status = FeedDict["status"] as? String {
            self._status = status
        }
        if let usrShortName = FeedDict["name"] as? String {
            self._usrShortname = usrShortName
        }
        if let username = FeedDict["username"] as? String {
            self._username = username
        }
        if let desi = FeedDict["desi"] as? String {
            self._desi = desi
        }
        if let post_time = FeedDict["post_time"] as? String {
            self._post_time = post_time
        }
        if let content = FeedDict["content"] as? String {
            self._content = content
        }
        if let color_code = FeedDict["color_code"] as? String {
            self._color_code = color_code
        }
        if let check_favpost = FeedDict["check_favpost"] as? String {
            self._check_favpost = check_favpost
        }
        if let action_to_perform = FeedDict["action_to_perform"] as? String {
            self._action_to_perform = action_to_perform
        }
        if let userimage = FeedDict["userimage"] as? String {
            self._userimage = userimage
        }
        if let profileLetter = FeedDict["profileLetter"] as? String {
            self._profileLetter = profileLetter
        }
        
        

        
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
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.postId == rhs.postId
    }
    
}


extension NSMutableAttributedString{
    
    func setTagLink(string: NSMutableAttributedString, name: String, linkId: String) -> NSAttributedString {
        let range: NSRange = self.mutableString.range(of: name, options: .caseInsensitive)
        if range.location != NSNotFound{
            string.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.green], range: range)
        }
        
        return string
    }
}



class ListingFeed{
    
    var listingId: String
    var listingTitle: String
    private var type: String
    var quantity: String
    private var status: String
    private var _viewcount: String
    var listingImg: String?
    var colorCode: String
    var profilePic: String?
    var postedUserName: String
    
    var attributedStatus: NSAttributedString{
        return NSAttributedString(string: status, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedString.Key.font: Fonts.descriptionFont])
    }
    
    var offerString: NSAttributedString{
        let _type = type == "0" ? "Sell Offer" : "Buy Offer"
  
        
        let quantityString = NSAttributedString(string: " - \(quantity) MT", attributes: [NSAttributedString.Key.font: Fonts.descriptionFont, NSAttributedString.Key.foregroundColor : UIColor.BLACK_ALPHA])
        
        
        let typeString = NSAttributedString(string: _type.uppercased(), attributes: [NSAttributedString.Key.font: Fonts.NAME_FONT, NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY])
        let attr = NSMutableAttributedString()
        attr.append(typeString)
        attr.append(quantityString)
        return attr
    }
    
    var viewCount: String{
        if let count = Int(_viewcount) {
            if count == 0{
                return "No Views"
            } else if count == 1{
                return "1 view"
            }
        }
        return "\(_viewcount) views."
    }
    
    
    init(dict: [String: AnyObject]){
        /*if dict["listingId"] == nil {
           self.listingId = dict["listingId"] as? String
        }
        else {
            self.listingId = dict["listingId"] as! String
        }*/
        self.listingId = dict["listingId"] as? String ?? "1001"
        self.listingTitle = dict["listingTitle"] as? String ?? "null"
        self.type = dict["type"] as? String ?? "null"
        self.quantity = dict["quantity"] as? String ?? "null"
        self.status = dict["status"] as? String ?? "null"
        self._viewcount = dict["viewcount"] as? String ?? "null"
        self.listingImg = dict["listingImg"] as? String
        self.colorCode = dict["colorCode"] as? String ?? "null"
        self.profilePic = dict["profilePic"] as? String
        self.postedUserName = dict["postedUserName"] as? String ?? "null"
    }
}


