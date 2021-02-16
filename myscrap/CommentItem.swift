//
//  CommentItem.swift
//  myscrap
//
//  Created by MS1 on 11/23/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

class CommentItem: MemberItem{
    
    private var _comment: String!
    private var _commentId: String!
    private var _timeStamp: Int!
    var isCellExpanded: Bool = false
    var comment: String = ""
    var commentTextAttrib: NSMutableAttributedString{
        
        var st = _comment
        
        
        var shouldTrim : Bool = false
        
        if !isCellExpanded && st!.count > 400 {
            shouldTrim = true
            st = st!.truncate(length: 398).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        
        let attributedString = NSMutableAttributedString(string: st!, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedString.Key.font: Fonts.commentFont, NSAttributedString.Key.paragraphStyle: style])
        
        if shouldTrim {
            let mutableString = NSMutableAttributedString(string: "\n\n\n Read More...", attributes:[ .foregroundColor: UIColor.MyScrapGreen, .font : Fonts.commentFont])
            attributedString.append(mutableString)
            let myRange = NSRange(location: st!.count , length: 13)
            attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.CONTINUE_READING), value: "abc", range: myRange)
        }
        
        if let linkRanges = st!.extractedWeblinks(){
            for rng in linkRanges{
                if let rn = st!.range(from: rng) {
                    let value = st![rn]
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
    
    var commentId:String{
        if _commentId == nil{
            _commentId = ""
        }
        return _commentId
    }
    
    var postId: String?
    var isDislike: String?
    var isLike: String?
    var userDisliked: String?
    var userLike: String?
   
    
    
    var timeStamp : String{ if _timeStamp == nil{ _timeStamp = 0 };
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_timeStamp))
        if calendar.isDateInToday(date as Date){
            let dateTime = timeSince(from: date)
            print("if Date : \(dateTime)")
            return "\(dateTime)"
        } /*else if let diff = Calendar.current.dateComponents([.hour], from: date as Date, to: Date()).hour, diff > 24 {
            //do something
            return "\(diff) hrs ago"
        }*/ else {
            let datemonthformatter = DateFormatter()
            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm"
            let dateString = datemonthformatter.string(from: date as Date)
            let timeString = timeFormatter.string(from: date as Date)
            print("Date in comment : \(dateString) \(timeString)")
            //return "\(dateString) at \(timeString) •"
            return "\(dateString) •"
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
    
    override init(Dict: Dictionary<String, AnyObject>) {
        super.init(Dict: Dict)
        if let commentId = Dict["commentId"] as? String{
            self._commentId = commentId
        }
        if let comment = Dict["comment"] as? String{
            self._comment = comment
        }
        if let timeStamp = Dict["timeStamp"] as? Int {
            print("time stamp in : \(timeStamp)")
            self._timeStamp = timeStamp
        }
        if let postId = Dict["postId"] as? String{
            self.postId = postId
        }
        else
        {
            if let postId = Dict["postId"] as? Int{
                self.postId = "\(postId)"
            }
        }
        if let isDislike = Dict["isDislike"] as? Int{
            self.isDislike = "\(isDislike)"
        }
        if let isLike = Dict["isLike"] as? Int{
            self.isLike = "\(isLike)"
        }
        if let userDisliked = Dict["userDisliked"] as? Int{
            self.userDisliked = "\(userDisliked)"
        }
        if let userLike = Dict["userLike"] as? Int{
            self.userLike = "\(userLike)"
        }
    
    }
}
class CommentCMItem {
    
    var isCellExpanded: Bool = false
    
    private var _commentId: String!
    private var _userId: String!
    private var _colorcode: String!
    private var _commentText: String?
    private var _first_name: String!
    private var _last_name: String!
    private var _name: String!
    private var _initials: String!
    private var _profilePic: String!
    private var _designation: String!
    private var _rank: String!
    private var _date: Int!
    
    var postId: String?
    var isDislike: String?
    var isLike: String?
    var userDisliked: String?
    var userLike: String?
    
    var commentId:String{
        if _commentId == nil{
            _commentId = ""
        }
        return _commentId
    }
    var userId:String{
        if _userId == nil{
            _userId = ""
        }
        return _userId
    }
    var colorcode:String{
        if _colorcode == nil{
            _colorcode = ""
        }
        return _colorcode
    }
    var commentText: String = ""
    var commentTextAttrib: NSMutableAttributedString{
        
        var st = _commentText
        
        var shouldTrim : Bool = false
        
        if !isCellExpanded && st!.count > 400 {
            shouldTrim = true
            st = st!.truncate(length: 398).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let attributedString = NSMutableAttributedString(string: st!, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedString.Key.font: Fonts.commentFont])
        
        if shouldTrim {
            let mutableString = NSMutableAttributedString(string: "\n\n\n Read More...", attributes:[ .foregroundColor: UIColor.MyScrapGreen, .font : Fonts.commentFont])
            attributedString.append(mutableString)
            let myRange = NSRange(location: st!.count , length: 13)
            attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.CONTINUE_READING), value: "abc", range: myRange)
        }
        
        if let linkRanges = st!.extractedWeblinks(){
            for rng in linkRanges{
                if let rn = st!.range(from: rng) {
                    let value = st![rn]
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
    var first_name:String{
        if _first_name == nil{
            _first_name = ""
        }
        return _first_name
    }
    var last_name:String{
        if _last_name == nil{
            _last_name = ""
        }
        return _last_name
    }
    var name:String{
        if _name == nil{
            _name = ""
        }
        return _name
    }
    var initials:String{
        if _initials == nil{
            _initials = ""
        }
        return _initials
    }
    var profilePic:String{
        if _profilePic == nil{
            _profilePic = ""
        }
        return _profilePic
    }
    var designation:String{
        if _designation == nil{
            _designation = ""
        }
        return _designation
    }
    var rank:String{
        if _rank == nil{
            _rank = ""
        }
        return _rank
    }
    var timeStamp : String{ if _date == nil{ _date = 0 };
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_date))
        if calendar.isDateInToday(date as Date){
            let date = timeSince(from: date)
            print("if Date : \(date)")
            return "\(date)"
        } else {
            let datemonthformatter = DateFormatter()
            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm"
            let dateString = datemonthformatter.string(from: date as Date)
            let timeString = timeFormatter.string(from: date as Date)
            print("Date : \(dateString) \(timeString)")
            return "\(dateString) at \(timeString)"
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
    
    init(Dict: Dictionary<String, AnyObject>) {
        if let commentId = Dict["commentId"] as? String{
            self._commentId = commentId
        }
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        if let colorcode = Dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let commentText = Dict["commentText"] as? String{
            self._commentText = commentText
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
        if let date = Dict["date"] as? Int{
            self._date = date
        }
        if let postId = Dict["postId"] as? String{
            self.postId = postId
        }
        else
        {
            if let postId = Dict["postId"] as? Int{
                self.postId = "\(postId)"
            }
        }
        if let isDislike = Dict["isDislike"] as? Int{
            self.isDislike = "\(isDislike)"
        }
        if let isLike = Dict["isLike"] as? Int{
            self.isLike = "\(isLike)"
        }
        if let userDisliked = Dict["userDisliked"] as? Int{
            self.userDisliked = "\(userDisliked)"
        }
        if let userLike = Dict["userLike"] as? Int{
            self.userLike = "\(userLike)"
        }
    }
}
class CommentPOWItem {
    
    var isCellExpanded: Bool = false
    
    private var _commentId: String!
    private var _userId: String!
    private var _colorcode: String!
    private var _commentText: String?
    private var _first_name: String!
    private var _last_name: String!
    private var _name: String!
    private var _initials: String!
    private var _profilePic: String!
    private var _designation: String!
    private var _rank: String!
    private var _date: Int!
    var postId: String?
    var isDislike: String?
    var isLike: String?
    var userDisliked: String?
    var userLike: String?
    
    var commentId:String{
        if _commentId == nil{
            _commentId = ""
        }
        return _commentId
    }
    var userId:String{
        if _userId == nil{
            _userId = ""
        }
        return _userId
    }
    var colorcode:String{
        if _colorcode == nil{
            _colorcode = ""
        }
        return _colorcode
    }
    var commentText: String = ""
    var commentTextAttrib: NSMutableAttributedString{
        
        var st = _commentText
        
        var shouldTrim : Bool = false
        
        if !isCellExpanded && st!.count > 400 {
            shouldTrim = true
            st = st!.truncate(length: 398).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let attributedString = NSMutableAttributedString(string: st!, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedString.Key.font: Fonts.commentFont])
        
        if shouldTrim {
            let mutableString = NSMutableAttributedString(string: "\n\n\n Read More...", attributes:[ .foregroundColor: UIColor.MyScrapGreen, .font : Fonts.commentFont])
            attributedString.append(mutableString)
            let myRange = NSRange(location: st!.count , length: 13)
            attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.CONTINUE_READING), value: "abc", range: myRange)
        }
        
        if let linkRanges = st!.extractedWeblinks(){
            for rng in linkRanges{
                if let rn = st!.range(from: rng) {
                    let value = st![rn]
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
    var first_name:String{
        if _first_name == nil{
            _first_name = ""
        }
        return _first_name
    }
    var last_name:String{
        if _last_name == nil{
            _last_name = ""
        }
        return _last_name
    }
    var name:String{
        if _name == nil{
            _name = ""
        }
        return _name
    }
    var initials:String{
        if _initials == nil{
            _initials = ""
        }
        return _initials
    }
    var profilePic:String{
        if _profilePic == nil{
            _profilePic = ""
        }
        return _profilePic
    }
    var designation:String{
        if _designation == nil{
            _designation = ""
        }
        return _designation
    }
    var rank:String{
        if _rank == nil{
            _rank = ""
        }
        return _rank
    }
    var timeStamp : String{ if _date == nil{ _date = 0 };
        let calendar = NSCalendar.current
        let date = NSDate(timeIntervalSince1970: Double(_date))
        if calendar.isDateInToday(date as Date){
            let date = timeSince(from: date)
            print("if Date : \(date)")
            return "\(date)"
        } else {
            let datemonthformatter = DateFormatter()
            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm"
            let dateString = datemonthformatter.string(from: date as Date)
            let timeString = timeFormatter.string(from: date as Date)
            print("Date : \(dateString) \(timeString)")
            return "\(dateString) at \(timeString)"
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
    
    init(Dict: Dictionary<String, AnyObject>) {
        if let commentId = Dict["commentId"] as? String{
            self._commentId = commentId
        }
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        if let colorcode = Dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let commentText = Dict["commentText"] as? String{
            self._commentText = commentText
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
        if let date = Dict["date"] as? Int{
            self._date = date
        }
        if let postId = Dict["postId"] as? String{
            self.postId = postId
        }
        else
        {
            if let postId = Dict["postId"] as? Int{
                self.postId = "\(postId)"
            }
        }
        if let isDislike = Dict["isDislike"] as? Int{
            self.isDislike = "\(isDislike)"
        }
        if let isLike = Dict["isLike"] as? Int{
            self.isLike = "\(isLike)"
        }
        if let userDisliked = Dict["userDisliked"] as? Int{
            self.userDisliked = "\(userDisliked)"
        }
        if let userLike = Dict["userLike"] as? Int{
            self.userLike = "\(userLike)"
        }
    }
}


