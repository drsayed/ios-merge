//
//  AdminRequestModel.swift
//  myscrap
//
//  Created by Mehtab Ahmed on 26/12/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation


class AdminRequestModel {
    
    var type: String?
    var companyPhoto: String?
    var userId: String?
    var photos: String?
    var companyId: String?
    var senderName: String?
    var colorCode: String?
    var companyName: String?
    var totalReview: String?
    var totalRatingCount: String?
    var avgRating: String?
    var message: String?
    var shortName: String?
    var time: String?
    var companyAffiliation: [String]?
    
    init() {

    }
    
    init(Dict:[String:AnyObject]) {
        if let type = Dict["type"] as? String {
            self.type = type
        }
        if let comPhoto = Dict["companyPhoto"] as? String {
            self.companyPhoto = comPhoto
        }
        if let id = Dict["userId"] as? String {
            self.userId = id
        }
        if let userPhoto = Dict["photos"] as? String {
            self.photos = userPhoto
        }
        if let comID = Dict["companyId"] as? String {
            self.companyId = comID
        }
        if let senderName = Dict["senderName"] as? String {
            self.senderName = senderName
        }
        if let color = Dict["colorCode"] as? String {
            self.colorCode = color
        }
        if let comName = Dict["companyName"] as? String {
            self.companyName = comName
        }
        if let totalReviews = Dict["totalReview"] as? String {
            self.totalReview = totalReviews
        }
        if let ratingCount = Dict["totalRatingCount"] as? String {
            self.totalRatingCount = ratingCount
        }
        if let avgRating = Dict["AvgRating"] as? String {
            self.avgRating = avgRating
        }
        if let msg = Dict["message"] as? String {
            self.message = msg
        }
        if let shortName = Dict["shortName"] as? String {
            self.shortName = shortName
        }
        if let time = Dict["time"] as? String {
            self.time = time
        }
        
        if let affiliations = Dict["companyAffiliation"] as? [String] {
            self.companyAffiliation = affiliations
        }
    }
}
