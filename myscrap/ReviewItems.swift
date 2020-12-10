//
//  ReviewItems.swift
//  myscrap
//
//  Created by MyScrap on 6/23/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class ReviewItems {
    var userReview = [UserReview]()
    private var _totalReview: String!
    private var _totalRatingCount: String!
    private var _AvgRating: String!
    var ratingValues = [RatingValues]()
    
    var totalReview:String{
        if _totalReview == nil { _totalReview = "" } ; return _totalReview
    }
    var totalRatingCount:String{
        if _totalRatingCount == nil { _totalRatingCount = "" } ; return _totalRatingCount
    }
    var AvgRating:String{
        if _AvgRating == nil { _AvgRating = "" } ; return _AvgRating
    }
    
    
    init(dict: [String: AnyObject]){
        if let userObj = dict["userReview"] as? [[String: AnyObject]]{
            for val in userObj {
                let userItems = UserReview(dict: val)
                userReview.append(userItems)
            }
        }
        if let totalReview = dict["totalReview"] as? String{
            self._totalReview = totalReview
        }
        if let totalRatingCount = dict["totalRatingCount"] as? String{
            self._totalRatingCount = totalRatingCount
        }
        if let AvgRating = dict["AvgRating"] as? String{
            self._AvgRating = AvgRating
        }
        if let ratingObj = dict["rattingValues"] as? [[String: AnyObject]]{
            for val in ratingObj {
                let ratingItems = RatingValues(dict: val)
                ratingValues.append(ratingItems)
            }
        }
    }
}
class UserReview {
    private var _id: String!
    private var _userId: String!
    private var _colorcode: String!
    private var _first_name: String!
    private var _last_name: String!
    private var _name: String!
    private var _initials: String!
    private var _profilePic: String!
    private var _reviewText: String!
    private var _ratting: Double!
    private var _date: String!
    private var _reviewCount : String!
    
    var id:String{
        if _id == nil { _id = "" } ; return _id
    }
    var userId:String{
        if _userId == nil { _userId = "" } ; return _userId
    }
    var colorcode:String{
        if _colorcode == nil { _colorcode = "" } ; return _colorcode
    }
    var first_name:String{
        if _first_name == nil { _first_name = "" } ; return _first_name
    }
    var last_name:String{
        if _last_name == nil { _last_name = "" } ; return _last_name
    }
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var initials:String{
        if _initials == nil { _initials = "" } ; return _initials
    }
    var profilePic:String{
        if _profilePic == nil { _profilePic = "" } ; return _profilePic
    }
    var reviewText:String{
        if _reviewText == nil { _reviewText = "" } ; return _reviewText
    }
    var ratting:Double{
        if _ratting == nil { _ratting = 0.0 } ; return _ratting
    }
    var date:String{
        if _date == nil { _date = "" } ; return _date
    }
    var reviewCount:String{
        if _reviewCount == nil { _reviewCount = ""}; return _reviewCount
    }
    
    
    init(dict: [String: AnyObject]){
        if let id = dict["id"] as? String{
            self._id = id
        }
        if let userId = dict["userId"] as? String{
            self._userId = userId
        }
        if let colorcode = dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let first_name = dict["first_name"] as? String{
            self._first_name = first_name
        }
        if let last_name = dict["last_name"] as? String{
            self._last_name = last_name
        }
        if let name = dict["name"] as? String{
            self._name = name
        }
        if let initials = dict["initials"] as? String{
            self._initials = initials
        }
        if let profilePic = dict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let reviewText = dict["reviewText"] as? String{
            self._reviewText = reviewText
        }
        if let ratting = dict["ratting"] as? String{
            self._ratting = Double(ratting)
        }
        if let date = dict["date"] as? String{
            self._date = date
        }
        if let reviewCount = dict["reviewCount"] as? String {
            self._reviewCount = reviewCount
        }
        
    }
}
