//
//  LandingItems.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

class LandingItems {
    private var _feedType: String!
    var activeFriendsData = [LOnlineItems]()
    var dataFeeds = [LFeedsItem]()
    var data = [LMarketItems]()
    var dataMenuShortcut = [LMenuItems]()
    
    enum LandCellType: String{
        case userOnline
        case feeds
        case market
        case none
    }
    var cellType: LandCellType{
        var ct = LandCellType.userOnline
        if _feedType == "userOnline"{
            ct = .userOnline
        } else if _feedType == "feeds" {
            ct = .feeds
        } else if _feedType == "market" {
            ct = .market
        } else {
            ct = .none
        }
        return ct
    }
    
    init (LandingDict:[String:AnyObject]){
        if let feedType = LandingDict["feedType"] as? String {
            //print("from api Feed Type :\(feedType)")
            self._feedType = feedType           //All the feed value will added into _feedType
            if feedType == "userOnline" {
                
                if let onlineUserData = LandingDict["activeFriendsData"] as? [[String: AnyObject]]{
                    for users in onlineUserData {
                        let onlineItems = LOnlineItems(dict: users)
                        activeFriendsData.append(onlineItems)
                    }
                }
            } else if feedType == "feeds" {
                if let feedsData = LandingDict["dataFeeds"] as? [[String:AnyObject]] {
                    for feeds in feedsData {
                        let feedsItem = LFeedsItem(FeedDict: feeds)
                        dataFeeds.append(feedsItem)
                    }
                    print("Data feeds : \(dataFeeds)")
                    
                }
            } else if feedType == "market" {
                if let marketData = LandingDict["data"] as? [[String: AnyObject]] {
                    for market in marketData {
                        let marketItems = LMarketItems(dict: market)
                        data.append(marketItems)
                    }
                }
            } else if feedType == "shortcut" {
                if let menuData = LandingDict["dataMenuShortcut"] as? [[String: AnyObject]] {
                    for menu in menuData {
                        let menuItems = LMenuItems(dict: menu)
                        dataMenuShortcut.append(menuItems)
                    }
                }
            }
        }
    }
}
class LOnlineItems {
    var colorCode: String?
    var designation: String?
    var friendcount: String?
    var jId: String?
    var lastActive: String?
    var moderator: String?
    var name : String?
    var newJoined: Bool = false
    var online : Bool = false
    var profilePic: String?
    var userCompany: String?
    var userid : String?
    
    
    
    init(dict: [String: AnyObject]) {
        
        if let colorCode = dict["colorCode"] as? String{
            self.colorCode = colorCode
        }
        if let designation = dict["designation"] as? String{
            self.designation = designation
        }
        if let friendcount = dict["friendcount"] as? String{
            self.friendcount = friendcount
        }
        if let jId = dict["jId"] as? String{
            self.jId = jId
        }
        if let lastactive = dict["lastActive"] as? String{
            self.lastActive = lastactive
        }
        if let moderator = dict["moderator"] as? String{
            self.moderator = moderator
        }
        if let name = dict["name"] as? String{
            self.name = name
        }
        if let newJoined = dict["newJoined"] as? Bool{
            self.newJoined = newJoined
        }
        if let online = dict["online"] as? Bool{
            self.online = online
        }
        if let profilePic = dict["profilePic"] as? String{
            self.profilePic =  profilePic
        }
        if let userCompany = dict["userCompany"] as? String{
            self.userCompany =  userCompany
        }
        
        if let userid = dict["userid"] as? String{
            self.userid = userid
        }
    }
}
class LMarketItems {
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
class LMenuItems {
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
