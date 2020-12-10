//
//  FeedV2Item.swift
//  myscrap
//
//  Created by MyScrap on 3/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
final class FeedV2Item: Equatable{
    
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
    //#4 Api called
    var isCellExpanded: Bool = false
    
    //For KEY Value feedType = "feeds"
    //Initialization
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
   var likedByText: String = ""
    private var _albumid:String!
    private var _postType:String!
    private var _newsLocation:String!
    private var _status:String!
    private var _profilePic:String!
    private var _commentCount: Int!
    var likeCount: Int = 0
    var viewsCount: Int = 0
//    "videoUrl" : [
//           {
//             "postId" : "22689",
//             "videoThumbnail" : "https:\/\/myscrap.com\/uploads\/thumbnail\/3671595652702250720.jpg",
//             "videoType" : "portrait",
//             "video" : "https:\/\/myscrap.com\/uploads\/video\/7141595652702250720original.mp4",
//             "download" : "https:\/\/myscrap.com\/uploads\/video\/watermark_video\/output3671595652702250720.mp4",
//             "videoId" : "1174"
//           }
//         ]
    private var _pictureURL: [PictureURL]!
    private var _videoURL: [VideoURL]!
    
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
    private var _reportBy:String!
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
    private var _isVideo: Bool!
    private var _videoUrl: String!
    private var _downloadVideoUrl: String!
    private var _videoThumbnail: String!
    private var _videoType: String!
    private var _isLevel:Bool!
    private var _level:String!
    private var _feedType: String!                          // feeds/ads/market/companyMonth/personWeek
    
    
    //MARK:- COVID-19 Poll Initialization
       private var _isPollClosed:Bool!
       private var _totalCount:Int!
    
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
//    private var _pictureUrl: Array<String>!

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
    
    enum CellType: String{
        case covidPoll
        case feedTextCell
        case feedImageCell
        case feedImageTextCell
        case feedVideoCell
        case feedVideoTextCell
        case feedPortrVideoCell
        case feedLandsVideoCell
        case feedPortrVideoTextCell
        case feedLandsVideoTextCell
        case ads
        case market
        case userFeedTextCell
        case userFeedImageCell
        case userFeedImageTextCell
        case newUser
        case news
        case companyMonth
        case personWeek
        case vote
        case personWeekScroll
    }
    //#8 after size at indexpath
    var cellType: CellType{
        var ct = CellType.feedTextCell
        if _feedType == "feeds"{
            if !pictureURL.isEmpty && status != "" {
                ct = .feedImageTextCell
            }else if !pictureURL.isEmpty{
                ct = .feedImageCell
            } else {
                ct = .feedTextCell
            }
        } else if _feedType == "ads" {
            ct = .ads
        } else if _feedType == "market"{
            ct = .market
        } else if _feedType == "newuser" {
            ct = .newUser
        } else if _feedType == "news" {
            ct = .news
        } else if _feedType == "companyMonth" {
            ct = .companyMonth
        } else if _feedType == "personWeek" {
            ct = .personWeek
        } else if _feedType == "vote" {
            ct = .vote
        } else if _feedType == "personWeekScroll" {
            ct = .personWeekScroll
        } /*else if _feedType == "videoFeed" {
            if status != "" {
                ct = .feedVideoTextCell
            } else {
                ct = .feedVideoCell
            }
        } */
        else if _feedType == "videoFeed" {
            if videoURL.count > 0 {
                let vido =  videoURL[0] as VideoURL
                if vido.videoType == "landscape" && status != "" {
                    ct = .feedPortrVideoTextCell
                } else if vido.videoType == "landscape" && status == "" {
                    ct = .feedPortrVideoCell
                }
                else if  vido.videoType == "portrait" &&  status != ""  {
                    ct = .feedLandsVideoTextCell
                } else if vido.videoType == "portrait" &&  status == "" {
                    ct = .feedLandsVideoCell
                }
            }
            else
            {
                
                if videoType == "landscape" && status != "" {
                    ct = .feedPortrVideoTextCell
                } else if videoType == "landscape" && status == "" {
                    ct = .feedPortrVideoCell
                }
                else if  videoType == "portrait" &&  status != ""  {
                    ct = .feedLandsVideoTextCell
                } else if videoType == "portrait" &&  status == "" {
                    ct = .feedLandsVideoCell
                }
            }
           
        }
        else if _feedType == "covidPoll" {
            //Checking whether poll is closed or not
            if !_isPollClosed {
                 ct = .covidPoll
            }
        }
        else {
            print("No cell type assigned")
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
    
    //User Profile cell
    var userCellType: CellType{
            var uct = CellType.userFeedTextCell
        
           if _feedType == "feeds"{
        if !pictureURL.isEmpty && status != "" {
            uct = .userFeedImageTextCell
        } else if !pictureURL.isEmpty{
            uct = .userFeedImageCell
        } else {
            uct = .userFeedTextCell
        }
        }
        else if _feedType == "videoFeed" {
            if videoURL.count > 0 {
            let vido =  videoURL[0] as VideoURL
            if vido.videoType == "landscape" && status != "" {
                uct = .feedPortrVideoTextCell
            } else if vido.videoType == "landscape" && status == "" {
                uct = .feedPortrVideoCell
            }
            else if  vido.videoType == "portrait" &&  status != ""  {
                uct = .feedLandsVideoTextCell
            } else if vido.videoType == "portrait" &&  status == "" {
                uct = .feedLandsVideoCell
            }
            }
            else
            {
                if videoType == "landscape" && status != "" {
                    uct = .feedPortrVideoTextCell
                } else if videoType == "landscape" && status == "" {
                    uct = .feedPortrVideoCell
                }
                else if  videoType == "portrait" &&  status != ""  {
                    uct = .feedLandsVideoTextCell
                } else if videoType == "portrait" &&  status == "" {
                    uct = .feedLandsVideoCell
                }
            }
        }
        return uct
    }
    
    /* Ads */
    //For KEY Value feedType = "ads"
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
    
    /* Covid Poll*/
    //For KEY Value feedType = "covidPoll"
    var covidData = [CovidPollFeed]()
    
    /* Market */
    //For KEY Value feedType = "market"
    var data = [MarketFeed]()
    
    /* Vote */
    //For KEY Value feedType = "vote"
    var voteData = [VoteFeed]()
    
    /* Person Week Scroll */
    //For KEY Value feedType = "personWeekScroll"
    var powScrollData = [POWScrollFeed]()
    
    /* New User */
    //For KEY Value feedType = "newuser"
    var datauser = [NewUserFeed]()
    
    /* News */
    //For KEY Value feedType = "news"
    var dataNews = [NewsFeed]()
    
    //Covid Poll Preventing nil values
    var isPollClosed : Bool{ if _isPollClosed == nil{ _isPollClosed = false};
           return _isPollClosed
       }
    var totalCount : Int{ if _totalCount == nil{ _totalCount = 0};
           return _totalCount
       }
    
    //Checking the nil value
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
        
        let currentYear = calendar.component(.year, from: Date()) // Current
        let postedYear = calendar.component(.year, from: date as Date) // Posted

        if calendar.isDateInToday(date as Date){
            let date = timeSince(from: date)
            print("if Date : \(date)")
            return "\(date)"
        } else {
            let datemonthformatter = DateFormatter()
//            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"
            if currentYear == postedYear {
                datemonthformatter.dateFormat =  "dd MMM" //"dd MMM"   //"MMM dd YYYY hh:mm a"
            }
            else {
                datemonthformatter.dateFormat =  "dd MMM YYYY" //"dd MMM"   //"MMM dd YYYY hh:mm a"
            }
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
    var pictureURL : [PictureURL] { if _pictureURL == nil { _pictureURL = [PictureURL]() };
        return _pictureURL
    }
    var videoURL : [VideoURL] { if _videoURL == nil { _videoURL = [VideoURL]() };
          return _videoURL
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
    var isLevel : Bool{ if _isLevel == nil{ _isLevel = false};
        return _isLevel
    }
    var level:String{ if _level == nil { _level = ""}; return _level}
    var moderator:String{ if _moderator == nil { _moderator = "0" }; return _moderator }
    var reportBy:String{ if _reportBy == nil { _reportBy = "" }; return _reportBy}
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
    var eventDetail:String{ if _eventDetail == nil { _eventDetail = "" }; return _eventDetail}
    var startDate:String{ if _startDate == nil { _startDate = "" }; return _startDate}
    var endDate:String{ if _endDate == nil { _endDate = "" }; return _endDate}
    var startTime:String{ if _startTime == nil { _startTime = "" }; return _startTime}
    var endTime:String{ if _endTime == nil { _endTime = "" }; return _endTime}
    var isVideo:Bool{ if _isVideo == nil { _isVideo = false }; return _isVideo}
    var videoUrl:String{ if _videoUrl == nil { _videoUrl = "" }; return _videoUrl}
    var downloadVideoUrl:String{ if _downloadVideoUrl == nil { _downloadVideoUrl = "" }; return _downloadVideoUrl}
    var videoThumbnail:String{ if _videoThumbnail == nil { _videoThumbnail = "" }; return _videoThumbnail}
    var videoType:String{ if _videoType == nil { _videoType = "" }; return _videoType}
    
    /* Ads */
    //For KEY Value feedType = "ads"
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
    var adsType : String{ if _adsType == nil{ _adsType == ""};
        return _adsType
    }
    var ccodeAdv : String{ if _ccodeAdv == nil{ _ccodeAdv == ""};
        return _ccodeAdv
    }
    var adsPictureUrl: [String]?{
        get {
            if _adsPictureUrl == [] {_adsPictureUrl = [""] } ; return _adsPictureUrl
        }
        set {
            _adsPictureUrl = newValue
        }
    }
    
    
    // MARK DESCRIPTION
    var descriptionStatus: NSMutableAttributedString{
        var st = status + "\n"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        
        var shouldTrim : Bool = false
        
        if !isCellExpanded && st.count > 300 {
            shouldTrim = true
            st = st.truncate(length: 100).trimmingCharacters(in: .whitespacesAndNewlines)
        }
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
    
    // MARK DESCRIPTION
    var cmDescriptionStatus: NSMutableAttributedString{
        //let desc = "-weekly shipments of few hundred tons ,\nMixed electric motors scrap\nOrigin Europe\n-searching for reliable motor scrap processor to collaborate on long term\n \nWe have also many other non ferrous scrap grades\n \nAny interest please contact us\n \n \nFranck\nwhatsapp +85260669186\nwechat +8613923192733\npowerstepmetalhk@gmail.com\nwww.powerstep.hk".trimmingCharacters(in: .whitespacesAndNewlines)
        
        var st = cmdescription
        print("Html string : \(st)")
        var shouldTrim : Bool = false
        
        if !isCellExpanded && st.count > 400 {
            shouldTrim = true
            st = st.truncate(length: 398).trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            shouldTrim = false
        }
        
        let attributedString = NSMutableAttributedString(string: st, attributes: [.foregroundColor: UIColor.darkGray,NSAttributedString.Key.font: Fonts.cmDescriptionFont])
        //let htmlAttrib = st.convertHtml()
        //attributedString.append(htmlAttrib)
        if let tags = tagList {
            for tag in tags{
                if let name = tag.taggedName , let id = tag.taggedId {
                    if st.contains(name){
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
            //let mutableString = NSMutableAttributedString(string: "<strong><span style=\"color:\(UIColor.MyScrapGreen.toHex()!);font-family: HelveticaNeue; font-size: 16\"></span><br /> Read More...</strong>", attributes:[ .foregroundColor: UIColor.MyScrapGreen, .font : Fonts.termsHedingFont])
            let mutableString = NSMutableAttributedString(string: "\n\n Read More...", attributes:[ .foregroundColor: UIColor.MyScrapGreen, .font : Fonts.termsHedingFont])
            attributedString.append(mutableString)
            let myRange = NSRange(location: st.count , length: 13)
            attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.CONTINUE_READING), value: "abc", range: myRange)
        } else {
            let mutableString = NSMutableAttributedString(string: "\n\n Show Less...", attributes:[ .foregroundColor: UIColor.MyScrapGreen, .font : Fonts.termsHedingFont])
            attributedString.append(mutableString)
            let myRange = NSRange(location: st.count , length: 13)
            attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.SHOW_LESS), value: "cba", range: myRange)
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
    
    var newsDescriptionStatus: NSAttributedString{
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
    
    
    static func == (lhs: FeedV2Item, rhs: FeedV2Item) -> Bool {
        return lhs.postId == rhs.postId
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
    
    //Assigning the values from msProfileDetails API ******User Profile
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
//    var pictureUrl : Array<String>{ if _pictureUrl == nil{ _pictureUrl  = [] };
//         return _pictureUrl
//     }
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
    
    /* Company of the Month */
    private var _cmId:String!
    private var _cmcompanyWebsiteUrl:String!
    var _cmdescription:String!
    private var _cmbannerTitle:String!
    private var _cmcompanyId:String!
    private var _cmcompanyName:String!
    private var _cmtimestamp:Int!
    var cmlikeStatus:Bool = false
    private var _cmcompanyImage:String!
    private var _cmlogoImage:String!
    var cmcommentCount: Int = 0
    var cmlikeCount: Int = 0
    var cmisPostFavourited:Bool = false
    
    
    /* Company of the Month*/
    //For KEY value feedType = "companyMonth"
    var cmId : String{ if _cmId == nil{ _cmId = ""};
        return _cmId
    }
    var cmcompanyWebsiteUrl : String{ if _cmcompanyWebsiteUrl == nil{ _cmcompanyWebsiteUrl = ""};
        return _cmcompanyWebsiteUrl
    }
    var cmdescription : String{ if _cmdescription == nil{ _cmdescription = ""};
        return _cmdescription
    }
    var cmbannerTitle : String{ if _cmbannerTitle == nil{ _cmbannerTitle = ""};
        return _cmbannerTitle
    }
    var cmcompanyId : String{ if _cmcompanyId == nil{ _cmcompanyId = ""};
        return _cmcompanyId
    }
    var cmcompanyName : String{ if _cmcompanyName == nil{ _cmcompanyName = ""};
        return _cmcompanyName
    }
    var cmtimestamp : String{ if _cmtimestamp == nil{ _cmtimestamp = 0 };
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_cmtimestamp))
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
    var cmcompanyImage : String{ if _cmcompanyImage == nil{ _cmcompanyImage = ""};
        return _cmcompanyImage
    }
    var cmlogoImage : String{ if _cmlogoImage == nil{ _cmlogoImage = ""};
        return _cmlogoImage
    }
    
    /* Person of the week*/
    //For KEY value feedType = "personWeek"
    /* Company of the Month */
    
    private var _powId:String!
    private var _pwbannerImage:String!
    private var _pwtimestamp:Int!
    private var _pwbannerTitle:String!
    var _pwdescription:String!
    var pwlikeStatus:Bool = false
    var pwcommentCount: Int = 0
    var pwlikeCount: Int = 0
    private var _pwuserId:String!
    var pwisPostFavourited:Bool = false
    
    /* Person of the Week*/
    //For KEY value feedType = "personWeek"
    var powId : String{ if _powId == nil{ _powId = ""};
        return _powId
    }
    var pwbannerImage : String{ if _pwbannerImage == nil{ _pwbannerImage = ""};
        return _pwbannerImage
    }
    var pwtimestamp : String{ if _pwtimestamp == nil{ _pwtimestamp = 0 };
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_cmtimestamp))
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
    var pwbannerTitle : String{ if _pwbannerTitle == nil{ _pwbannerTitle = ""};
        return _pwbannerTitle
    }
    var pwdescription : String{ if _pwdescription == nil{ _pwdescription = ""};
        return _pwdescription
    }
    // MARK DESCRIPTION
    var pwDescriptionStatus: NSMutableAttributedString{
        //let desc = "-weekly shipments of few hundred tons ,\nMixed electric motors scrap\nOrigin Europe\n-searching for reliable motor scrap processor to collaborate on long term\n \nWe have also many other non ferrous scrap grades\n \nAny interest please contact us\n \n \nFranck\nwhatsapp +85260669186\nwechat +8613923192733\npowerstepmetalhk@gmail.com\nwww.powerstep.hk".trimmingCharacters(in: .whitespacesAndNewlines)
        
        var st = pwdescription
        print("Html string : \(st)")
        var shouldTrim : Bool = false
        
        if !isCellExpanded && st.count > 400 {
            shouldTrim = true
            st = st.truncate(length: 398).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let attributedString = NSMutableAttributedString(string: st, attributes: [.foregroundColor: UIColor.darkGray,NSAttributedString.Key.font: Fonts.cmDescriptionFont])
        //let htmlAttrib = st.convertHtml()
        //attributedString.append(htmlAttrib)
        if let tags = tagList {
            for tag in tags{
                if let name = tag.taggedName , let id = tag.taggedId {
                    if st.contains(name){
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
        /*if shouldTrim {
            let mutableString = NSMutableAttributedString(string: "\n\n Read More...", attributes:[ .foregroundColor: UIColor.MyScrapGreen, .font : Fonts.termsHedingFont])
            attributedString.append(mutableString)
            let myRange = NSRange(location: st.count , length: 13)
            attributedString.addAttribute(NSAttributedStringKey(rawValue: MSTextViewAttributes.CONTINUE_READING), value: "abc", range: myRange)
        } else {
            let mutableString = NSMutableAttributedString(string: "\n\n Show Less...", attributes:[ .foregroundColor: UIColor.MyScrapGreen, .font : Fonts.termsHedingFont])
            attributedString.append(mutableString)
            let myRange = NSRange(location: st.count , length: 13)
            attributedString.addAttribute(NSAttributedStringKey(rawValue: MSTextViewAttributes.SHOW_LESS), value: "cba", range: myRange)
        }*/
        
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
    var pwuserId : String{ if _pwuserId == nil{ _pwuserId = ""};
        return _pwuserId
    }
    
    
    //#5 after Api calleed
    init (FeedDict:[String:AnyObject]){
        if let feedType = FeedDict["feedType"] as? String {
            //print("from api Feed Type :\(feedType)")
            self._feedType = feedType           //All the feed value will added into _feedType
            if feedType == "covidPoll" {
                //COVID Poll Values Fetch
                if let isPollClosed = FeedDict["isPollClosed"] as? Bool{
                    self._isPollClosed = isPollClosed
                }
                if let totalCount = FeedDict["totalCount"] as? Int{
                    self._totalCount = totalCount
                }
                //Checking poll is closed or not
                if !isPollClosed {
                    if let pollData = FeedDict["data"] as? [[String: AnyObject]] {
                        for poll in pollData {
                            let pollItems = CovidPollFeed(dict: poll)
                            covidData.append(pollItems)
                        }
                    }
                }
            }
            if feedType == "market" {
                /* Market */
                //For KEY Value feedType = "market"
                if let marketData = FeedDict["data"] as? [[String: AnyObject]]{
                    for market in marketData {
                        let marketItems = MarketFeed(dict: market)
                        data.append(marketItems)
                    }
                }
            }
            if feedType == "personWeekScroll" {
                /* Market */
                //For KEY Value feedType = "market"
                if let powScrollFetchData = FeedDict["data"] as? [[String: AnyObject]]{
                    for powScroll in powScrollFetchData {
                        let scrollItems = POWScrollFeed(dict: powScroll)
                        powScrollData.append(scrollItems)
                    }
                }
            }
            if feedType == "vote" {
                /* Market */
                //For KEY Value feedType = "market"
                if let voteFetchData = FeedDict["data"] as? [[String: AnyObject]]{
                    for vote in voteFetchData {
                        let voteItems = VoteFeed(dict: vote)
                        voteData.append(voteItems)
                    }
                }
            }
            if feedType == "newuser" {
                /* New user */
                //For KEY Value feedType = "newuser"
                if let newuserData = FeedDict["data"] as? [[String: AnyObject]]{
                    for newuser in newuserData {
                        let newdata = NewUserFeed(dict: newuser)
                        datauser.append(newdata)
                    }
                }
            }
            if feedType == "news" {
                /* News */
                //For KEY Value feedType = "news"
                if let newsData = FeedDict["data"] as? [[String: AnyObject]]{
                    for news in newsData {
                        let newsdata = NewsFeed(dict: news)
                        dataNews.append(newsdata)
                    }
                }
            }
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
        if let viewsCount = FeedDict["viewsCount"] as? Int{
            self.viewsCount = viewsCount
        }
        if let pictures = FeedDict["pictureUrl"] as? [[String:AnyObject]]{
            var data = [PictureURL]()
            for obj in pictures{
                let picture = PictureURL(pictureDict: obj)
                data.append(picture)
            }
            self._pictureURL = data
        }
        if let videos = FeedDict["videoUrl"] as? [[String:AnyObject]]{
            var data = [VideoURL]()
            for obj in videos{ //HAJA changed
                let video = VideoURL(videoDict: obj)
                data.append(video)
            }
//            if videos.count > 0 {
//                let dict = videos[0]
//                let video = VideoURL(videoDict: dict)
//                data.append(video)
//            }
            self._videoURL = data
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
        if let reportBy = FeedDict["reportBy"] as? String{
            self._reportBy = reportBy
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
        if let isVideo = FeedDict["isVideo"] as? Bool{
            self._isVideo = isVideo
        }
        if let videoUrl = FeedDict["videoUrl"] as? String{
            self._videoUrl = videoUrl
        }
        if let downloadVideoUrl = FeedDict["downloadVideoUrl"] as? String{
            self._downloadVideoUrl = downloadVideoUrl
        }
        if let videoThumbnail = FeedDict["videoThumbnail"] as? String{
            self._videoThumbnail = videoThumbnail
        }
        if let videoType = FeedDict["videoType"] as? String{
            self._videoType = videoType
        }
        if let likedByText = FeedDict["likedByText"] as? String{
            self.likedByText = likedByText
        }
        if let isLevel = FeedDict["isLevel"] as? Bool {
            self._isLevel = isLevel
        }
        if let level = FeedDict["level"] as? String{
            self._level = level
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
//        if let pictureUrl = FeedDict["pictureUrl"] as? Array<String> {
//                   self._pictureUrl = pictureUrl
//               }
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
        
        /* Ads */
        //For KEY Value feedType = "ads"
        if let title = FeedDict["title"] as? String{
            self._title = title
        }
        if let redirectURL = FeedDict["redirectURL"] as? String{
            self._redirectURL = redirectURL
        }
        if let visitMoreLink = FeedDict["visitMoreLink"] as? String{
            self._visitMoreLink = visitMoreLink
        }
        if let description = FeedDict["description"] as? String{
            self._description = description
        }
        if let adImage = FeedDict["adImage"] as? String{
            self._adImage = adImage
        }
        if let sponserBy = FeedDict["sponserBy"] as? String{
            self._sponserBy = sponserBy
        }
        if let sponserLogo = FeedDict["sponserLogo"] as? String{
            self._sponserLogo = sponserLogo
        }
        if let sponserShortName = FeedDict["sponserShortName"] as? String{
            self._sponserShortName = sponserShortName
        }
        if let bannerCountry = FeedDict["bannerCountry"] as? String{
            self._bannerCountry = bannerCountry
        }
        if let bannerTitle = FeedDict["bannerTitle"] as? String{
            self._bannerTitle = bannerTitle
        }
        if let adsType = FeedDict["adsType"] as? String{
            self._adsType = adsType
        }
        if let ccodeAdv = FeedDict["colorCode"] as? String {
            self._ccodeAdv = ccodeAdv
        }
        if let adsPictureUrl = FeedDict["adsPictureUrl"] as? [String]{
            self._adsPictureUrl = adsPictureUrl
        }
        
        /* Company of month*/
        if let cmId = FeedDict["cmId"] as? String{
            self._cmId = cmId
        }
        if let cmcompanyWebsiteUrl = FeedDict["companyWebsiteUrl"] as? String{
            self._cmcompanyWebsiteUrl = cmcompanyWebsiteUrl
        }
        if let cmdescription = FeedDict["description"] as? String{
            //let htmlAttrib = cmdescription.convertHtml()
            self._cmdescription = cmdescription
        }
        if let cmbannerTitle = FeedDict["bannerTitle"] as? String{
            self._cmbannerTitle = cmbannerTitle
        }
        if let cmcompanyId = FeedDict["companyId"] as? String{
            self._cmcompanyId = cmcompanyId
        }
        if let cmcompanyName = FeedDict["companyName"] as? String{
            self._cmcompanyName = cmcompanyName
        }
        if let cmtimestamp = FeedDict["timestamp"] as? Int{
            self._cmtimestamp = cmtimestamp
        }
        if let cmlikeStatus = FeedDict["likeStatus"] as? Bool{
            self.cmlikeStatus = cmlikeStatus
        }
        if let cmcompanyImage = FeedDict["companyImage"] as? String{
            self._cmcompanyImage = cmcompanyImage
        }
        if let cmlogoImage = FeedDict["logoImage"] as? String{
            self._cmlogoImage = cmlogoImage
        }
        if let cmcommentCount = FeedDict["commentCount"] as? Int{
            self.cmcommentCount = cmcommentCount
        }
        if let cmlikeCount = FeedDict["likeCount"] as? Int{
            self.cmlikeCount = cmlikeCount
        }
        if let cmisPostFavourited = FeedDict["isPostFavourited"] as? Bool{
            self.cmisPostFavourited = cmisPostFavourited
        }
        
        /*Person of the Week*/
        if let powId = FeedDict["powId"] as? String{
            self._powId = powId
        }
        if let pwbannerImage = FeedDict["bannerImage"] as? String{
            self._pwbannerImage = pwbannerImage
        }
        if let pwtimestamp = FeedDict["timestamp"] as? Int{
            self._pwtimestamp = pwtimestamp
        }
        if let pwbannerTitle = FeedDict["bannerTitle"] as? String{
            self._pwbannerTitle = pwbannerTitle
        }
        if let pwdescription = FeedDict["description"] as? String{
            //let htmlAttrib = pwdescription.convertHtml()
            self._pwdescription = pwdescription
        }
        if let pwlikeStatus = FeedDict["likeStatus"] as? Bool{
            self.pwlikeStatus = pwlikeStatus
        }
        if let pwcommentCount = FeedDict["commentCount"] as? Int{
            self.pwcommentCount = pwcommentCount
        }
        if let pwlikeCount = FeedDict["likeCount"] as? Int{
            self.pwlikeCount = pwlikeCount
        }
        if let pwuserId = FeedDict["userId"] as? String{
            self._pwuserId = pwuserId
        }
        if let pwisPostFavourited = FeedDict["isPostFavourited"] as? Bool{
            self.pwisPostFavourited = pwisPostFavourited
        }
    }
}
class CovidPollFeed {
    var _isVoted:Bool!
    var _option: String!
    var _votingCount: String!
    var _percentage: Int!
    
    var isVoted : Bool {if _isVoted == nil{_isVoted = false };
        return _isVoted
    }
    var option : String{ if _option == nil{ _option = ""};
        return _option
    }
    var votingCount : String{ if _votingCount == nil{ _votingCount = ""};
        return _votingCount
    }
    var percentage : Int{ if _percentage == nil{ _percentage = 0};
        return _percentage
    }
    
    init(dict: [String: AnyObject]){
        if let isVoted = dict["isVoted"] as? Bool {
            self._isVoted = isVoted
        }
        if let option = dict["option"] as? String{
            self._option = option
        }
        if let votingCount = dict["votingCount"] as? String{
            self._votingCount = votingCount
        }
        if let percentage = dict["percentage"] as? Int{
            self._percentage = percentage
        }
    }
}
class VoteFeed {
    var _voterId: String!
    var user_data = [PostedUserData]()
    var voterId : String{ if _voterId == nil{ _voterId = ""};
        return _voterId
    }
    
    init(dict: [String: AnyObject]){
        if let voterId = dict["voterId"] as? String{
            self._voterId = voterId
        }
        if let userObj = dict["user_data"] as? [String: AnyObject]{
            let userItems = PostedUserData(dict: userObj)
            user_data.append(userItems)
        }
    }
}
class POWScrollFeed {
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
class MarketFeed{
    
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
class NewUserFeed {
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
class NewsFeed{
    
    private var _id: String!
    private var _title: String!
    private var _description: String!
    private var _newsBanner: String!
    private var _newsBy: String!
    
    var id : String{ if _id == nil{ _id = ""};
        return _id
    }
    var title : String{ if _title == nil{ _title = ""};
        return _title
    }
    var description : String{ if _description == nil{ _description = ""};
        return _description
    }
    var newsBanner : String{ if _newsBanner == nil{ _newsBanner = ""};
        return _newsBanner
    }
    var newsBy : String{ if _newsBy == nil{ _newsBy = ""};
        return _newsBy
    }
    
    init(dict: [String: AnyObject]){
        if let id = dict["id"] as? String{
            self._id = id
        }
        if let title = dict["title"] as? String{
            self._title = title
        }
        if let description = dict["description"] as? String{
            self._description = description
        }
        if let newsBanner = dict["newsBanner"] as? String{
            self._newsBanner = newsBanner
        }
        if let newsBy = dict["newsBy"] as? String{
            self._newsBy = newsBy
        }
    }
}
class CompanyMonthFeed{
    
}
extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
