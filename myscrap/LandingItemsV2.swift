//
//  LandingItemsV2.swift
//  myscrap
//
//  Created by MyScrap on 2/1/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

class LandingItemsV2 {
    private var _feedType: String!
    var dataAds = [LAdsItemV2]()
    var dataMenu = [LMenuItemsV2]()
    var dataFeeds = [LFeedsItemV2]()
    var dataMarket = [LMarketItemsV2]()
    var dataPerson = [LPowItemV2]()
    var dataPersonNew = [LNewUserItemV2]()
    
    enum LandCellTypeV2: String{
        case trendingAds
        case trendingMenu
        case trendingFeeds
        case trendingMarket
        case trendingPerson
        case trendingNewPerson
        case trendingNav
    }
    var cellType: LandCellTypeV2{
        var ct = LandCellTypeV2.trendingAds
        if _feedType == "trendingAds"{
            ct = .trendingAds
        } else if _feedType == "trendingMenu" {
            ct = .trendingMenu
        } else if _feedType == "trendingFeeds" {
            ct = .trendingFeeds
        } else if _feedType == "trendingMarket" {
            ct = .trendingMarket
        } else if _feedType == "trendingPerson" {
            ct = .trendingPerson
        } else if _feedType == "trendingNewPerson" {
            ct = .trendingNewPerson
        } else {
            ct = .trendingNav
        }
        return ct
    }
    
    init (LandingDict:[String:AnyObject]){
        if let feedType = LandingDict["feedType"] as? String {
            //print("from api Feed Type :\(feedType)")
            self._feedType = feedType           //All the feed value will added into _feedType
            if feedType == "trendingAds" {
                
                if let adsData = LandingDict["dataAds"] as? [[String: AnyObject]]{
                    for ad in adsData {
                        let adItems = LAdsItemV2(dict: ad)
                        dataAds.append(adItems)
                    }
                }
            } else if feedType == "trendingMenu" {
                if let menuData = LandingDict["dataMenu"] as? [[String:AnyObject]] {
                    for menu in menuData {
                        let menuItem = LMenuItemsV2(dict: menu)
                        dataMenu.append(menuItem)
                    }
                    
                }
            } else if feedType == "trendingFeeds" {
                if let feedsData = LandingDict["dataFeeds"] as? [[String: AnyObject]] {
                    for feeds in feedsData {
                        let feedsItem = LFeedsItemV2(FeedDict: feeds)
                        dataFeeds.append(feedsItem)
                    }
                }
            } else if feedType == "trendingMarket" {
                if let marketData = LandingDict["dataMarket"] as? [[String: AnyObject]] {
                    for market in marketData {
                        let marketItems = LMarketItemsV2(dict: market)
                        dataMarket.append(marketItems)
                    }
                }
            } else if feedType == "trendingPerson" {
                if let personData = LandingDict["dataPerson"] as? [[String : AnyObject]] {
                    for person in personData {
                        let personItem = LPowItemV2(dict: person)
                        dataPerson.append(personItem)
                    }
                }
            } else if feedType == "trendingNewPerson" {
                if let newData = LandingDict["dataPersonNew"] as? [[String : AnyObject]] {
                    for newMember in newData {
                        let newItem = LNewUserItemV2(dict: newMember)
                        dataPersonNew.append(newItem)
                    }
                }
            }
        }
    }
}
class LAdsItemV2 {
    private var _title:String!
    private var _redirectURL:String!
    private var _visitMoreLink:String!
    private var _description:String!
    private var _adImage:String!
    private var _sponserBy:String!
    private var _sponserLogo:String!
    private var _sponserShortName:String!
    private var _bannerCountry:String!
    private var _bannerTitle:String!
    private var _adsType:String!
    private var _ccodeAdv:String!
    var _adsPictureUrl : [String]!
    
    //Using for landing ads
    private var _AdsImage:String!
    private var _websiteAds:String!
    
    var title : String{ if _title == nil{ _title = ""};
        return _title
    }
    var redirectURL : String{ if _redirectURL == nil{ _redirectURL = ""};
        return _redirectURL
    }
    
    var visitMoreLink : String{ if _visitMoreLink == nil{ _visitMoreLink = ""};
        return _visitMoreLink
    }
    var description : String{ if _description == nil{ _description = ""};
        return _description
    }
    var adImage : String{ if _adImage == nil{ _adImage = ""};
        return _adImage
    }
    
    var sponserBy : String{ if _sponserBy == nil{ _sponserBy = ""};
        return _sponserBy
    }
    var sponserLogo : String{ if _sponserLogo == nil{ _sponserLogo = ""};
        return _sponserLogo
    }
    var sponserShortName : String{ if _sponserShortName == nil{ _sponserShortName = ""};
        return _sponserShortName
    }
    var bannerCountry : String{ if _bannerCountry == nil{ _bannerCountry = ""};
        return _bannerCountry
    }
    var bannerTitle : String{ if _bannerTitle == nil{ _bannerTitle = ""};
        return _bannerTitle
    }
    
    var adsPictureUrl: [String]?{
        get {
            if _adsPictureUrl == [] {_adsPictureUrl = [""] } ; return _adsPictureUrl
        }
        set {
            _adsPictureUrl = newValue
        }
    }
    
    var AdsImage : String{ if _AdsImage == nil{ _AdsImage = ""};
        return _AdsImage
    }
    var websiteAds : String{ if _websiteAds == nil{ _websiteAds = ""};
        return _websiteAds
    }
    
    init(dict: [String : AnyObject]) {
        /*Using for Landing Ads*/
        if let AdsImage = dict["AdsImage"] as? String{
            self._AdsImage = AdsImage
        }
        if let websiteAds = dict["websiteAds"] as? String{
            self._websiteAds = websiteAds
        }
        
        
        if let title = dict["title"] as? String{
            self._title = title
        }
        if let redirectURL = dict["redirectURL"] as? String{
            self._redirectURL = redirectURL
        }
        
        if let visitMoreLink = dict["visitMoreLink"] as? String{
            self._visitMoreLink = visitMoreLink
        }
        if let description = dict["description"] as? String{
            self._description = description
        }
        if let adImage = dict["adImage"] as? String{
            self._adImage = adImage
        }
        
        if let sponserBy = dict["sponserBy"] as? String{
            self._sponserBy = sponserBy
        }
        if let sponserLogo = dict["sponserLogo"] as? String{
            self._sponserLogo = sponserLogo
        }
        if let sponserShortName = dict["sponserShortName"] as? String{
            self._sponserShortName = sponserShortName
        }
        if let bannerCountry = dict["bannerCountry"] as? String{
            self._bannerCountry = bannerCountry
        }
        if let bannerTitle = dict["bannerTitle"] as? String{
            self._bannerTitle = bannerTitle
        }
        if let adsType = dict["adsType"] as? String{
            self._adsType = adsType
        }
        if let ccodeAdv = dict["colorCode"] as? String {
            self._ccodeAdv = ccodeAdv
        }
        if let adsPictureUrl = dict["adsPictureUrl"] as? [String]{
            self._adsPictureUrl = adsPictureUrl
        }
    }
}
class LMenuItemsV2 {
    var _itemName: String!
    
    var itemName : String{ if _itemName == nil{ _itemName = ""};
        return _itemName
    }
    
    init(dict: [String: AnyObject]){
        if let itemName = dict["itemName"] as? String{
            self._itemName = itemName
        }
    }
}
final class LFeedsItemV2 : Equatable{
    static func == (lhs: LFeedsItemV2, rhs: LFeedsItemV2) -> Bool {
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
class LMarketItemsV2 {
    var _listingId: String!
    var _listId: String!
    var _userId: String!
    var _listingTitle: String!
    var _listingType: String!
    //    var _imageTitle: String!
    var _description: String!
    var _listingProductName: String!
    var _listingIsriCode: String!
    var _totalView: String!
    var _paymentTerms: String!
    var _quantity: String!
    var _portName: String!
    var _priceTerms: String!
    //    var _commodity: String!
    var _packaging: String!
    var _countryName: String!
    var _flagCode: String!
    var _duration: String!
    var _listingImg: String!
    var user_data = [PostedUserData]()
    
    var listingId : String{ if _listingId == nil{ _listingId = ""};
        return _listingId
    }
    var listId : String{ if _listId == nil{ _listId = ""};
        return _listId
    }
    var userId : String{ if _userId == nil{ _userId = ""};
        return _userId
    }
    var listingTitle : String{ if _listingTitle == nil{ _listingTitle = ""};
        return _listingTitle
    }
    var listingType : String{ if _listingType == nil{ _listingType = ""};
        return _listingType
    }
    //    var imageTitle : String{ if _imageTitle == nil{ _imageTitle = ""};
    //        return _imageTitle
    //    }
    var description : String{ if _description == nil{ _description = ""};
        return _description
    }
    var listingProductName : String{ if _listingProductName == nil{ _listingProductName = ""};
        return _listingProductName
    }
    var listingIsriCode : String{ if _listingIsriCode == nil{ _listingIsriCode = ""};
        return _listingIsriCode
    }
    var totalView : String{ if _totalView == nil{ _totalView = ""};
        return _totalView
    }
    var paymentTerms : String{ if _paymentTerms == nil{ _paymentTerms = ""};
        return _paymentTerms
    }
    var quantity : String{ if _quantity == nil{ _quantity = ""};
        return _quantity
    }
    var portName : String{ if _portName == nil{ _portName = ""};
        return _portName
    }
    var priceTerms : String{ if _priceTerms == nil{ _priceTerms = ""};
        return _priceTerms
    }
    //    var commodity : String{ if _commodity == nil{ _commodity = ""};
    //        return _commodity
    //    }
    var packaging : String{ if _packaging == nil{ _packaging = ""};
        return _packaging
    }
    var countryName : String{ if _countryName == nil{ _countryName = ""};
        return _countryName
    }
    
    var flagCode : String{ if _flagCode == nil{ _flagCode = ""};
        return _flagCode
    }
    var duration : String{ if _duration == nil{ _duration = ""};
        return _duration
    }
    var listingImg : String{ if _listingImg == nil{ _listingImg = ""};
        return _listingImg
    }
    
    init(dict: [String: AnyObject]){
        if let listingId = dict["listingId"] as? String{
            self._listingId = listingId
        }
        if let listId = dict["listId"] as? String{
            self._listId = listId
        }
        if let userId = dict["userId"] as? String{
            self._userId = userId
        }
        if let listingTitle = dict["listingTitle"] as? String{
            self._listingTitle = listingTitle
        }
        if let listingType = dict["listingType"] as? String{
            self._listingType = listingType
        }
        //        if let imageTitle = dict["imageTitle"] as? String{
        //            self._imageTitle = imageTitle
        //        }
        if let description = dict["description"] as? String{
            self._description = description
        }
        if let listingProductName = dict["listingProductName"] as? String{
            self._listingProductName = listingProductName
        }
        if let listingIsriCode = dict["listingIsriCode"] as? String{
            self._listingIsriCode = listingIsriCode
        }
        if let totalView = dict["totalView"] as? String{
            self._totalView = totalView
        }
        if let paymentTerms = dict["paymentTerms"] as? String{
            self._paymentTerms = paymentTerms
        }
        if let quantity = dict["quantity"] as? String{
            self._quantity = quantity
        }
        if let portName = dict["portName"] as? String{
            self._portName = portName
        }
        if let priceTerms = dict["priceTerms"] as? String{
            self._priceTerms = priceTerms
        }
        //        if let commodity = dict["commodity"] as? String{
        //            self._commodity = commodity
        //        }
        if let packaging = dict["packaging"] as? String{
            self._packaging = packaging
        }
        if let countryName = dict["countryName"] as? String{
            self._countryName = countryName
        }
        
        if let flagCode = dict["flagCode"] as? String{
            self._flagCode = flagCode
        }
        if let duration = dict["duration"] as? String{
            self._duration = duration
        }
        if let listingImg = dict["listingImg"] as? [String]{
            self._listingImg = listingImg.first
        }
        if let userObj = dict["user_data"] as? [String: AnyObject]{
            let userItems = PostedUserData(dict: userObj)
            user_data.append(userItems)
        }
    }
}
class LPowItemV2 {
    var _powId: String!
    var _name: String!
    var _bannerImage: String!
    var _bannerTitle: String!
    var _userCompany: String!
    var _designation: String!
    var _country: String!
    
    var powId : String{ if _powId == nil{ _powId = ""};
        return _powId
    }
    var name : String{ if _name == nil{ _name = ""};
        return _name
    }
    var bannerImage : String{ if _bannerImage == nil{ _bannerImage = ""};
        return _bannerImage
    }
    var bannerTitle : String{ if _bannerTitle == nil{ _bannerTitle = ""};
        return _bannerTitle
    }
    var userCompany : String{ if _userCompany == nil{ _userCompany = ""};
        return _userCompany
    }
    var designation : String{ if _designation == nil{ _designation = ""};
        return _designation
    }
    var country : String{ if _country == nil{ _country = ""};
        return _country
    }
    
    init(dict: [String: AnyObject]){
        if let powId = dict["powId"] as? String{
            self._powId = powId
        }
        if let name = dict["name"] as? String{
            self._name = name
        }
        if let bannerImage = dict["bannerImage"] as? String{
            self._bannerImage = bannerImage
        }
        if let bannerTitle = dict["bannerTitle"] as? String{
            self._bannerTitle = bannerTitle
        }
        if let userCompany = dict["userCompany"] as? String{
            self._userCompany = userCompany
        }
        if let designation = dict["designation"] as? String{
            self._designation = designation
        }
        if let country = dict["country"] as? String{
            self._country = country
        }
        
    }
}
class LNewUserItemV2 {
    private var _userId: String!
    private var _username: String!
    private var _userimage: String!
    private var _profileLetter: String!
    private var _short_name: String!
    private var _company: String!
    private var _designation: String!
    private var _colorcode: String!
    private var _joining_date: String!
    
    var userId : String{ if _userId == nil{ _userId = ""};
        return _userId
    }
    var username : String{ if _username == nil{ _username = ""};
        return _username
    }
    var userimage : String{ if _userimage == nil{ _userimage = ""};
        return _userimage
    }
    var profileLetter : String{ if _profileLetter == nil{ _profileLetter = ""};
        return _profileLetter
    }
    var short_name : String{ if _short_name == nil{ _short_name = ""};
        return _short_name
    }
    var company : String{ if _company == nil{ _company = ""};
        return _company
    }
    var designation : String{ if _designation == nil{ _designation = ""};
        return _designation
    }
    var colorcode : String{ if _colorcode == nil{ _colorcode = ""};
        return _colorcode
    }
    var joining_date : String{ if _joining_date == nil{ _joining_date = ""};
        return _joining_date
    }
    
    init(dict: [String: AnyObject]){
        if let userId = dict["userId"] as? String{
            self._userId = userId
        }
        if let username = dict["username"] as? String{
            self._username = username
        }
        if let userimage = dict["userimage"] as? String{
            self._userimage = userimage
        }
        if let profileLetter = dict["profileLetter"] as? String{
            self._profileLetter = profileLetter
        }
        if let short_name = dict["short_name"] as? String{
            self._short_name = short_name
        }
        if let company = dict["company"] as? String{
            self._company = company
        }
        if let designation = dict["designation"] as? String{
            self._designation = designation
        }
        if let colorcode = dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let joining_date = dict["joining_date"] as? String{
            self._joining_date = joining_date
        }
    }
    
}
