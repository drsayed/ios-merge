//
//  LandingService.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

protocol LandingDelegate:class {
    func didReceivedFailure(error: String)
    func didReceiveData(mainDSource : [LandingItems],onlineUsers: [LOnlineItems], feeds: [LFeedsItem], market: [LMarketItems], menu : [LMenuItems])
}

class LandingService {
    weak var delegate: LandingDelegate?
    
    private var _feedType: String!
    
    var activeFriendsData = [LOnlineItems]()
    var dataFeeds = [LFeedsItem]()
    var data = [LMarketItems]()
    var dataMenuShortcut = [LMenuItems]()
    
    //Not Using
    func getLandingData(){
        let service = APIService()
        service.endPoint = LandingEndPoints.LANDING_PAGE_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        print("Landing PARAAAAAMS : \(service.params)")
        print("#################  End points",service.endPoint)
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                _ = self.handleLand(json: dict)
            case .Error(let error):
                self.delegate?.didReceivedFailure(error: error)
            }
        }
    }
    
    func handleLand(json: [String:AnyObject]) {
        var landingItems = [LandingItems]()
        if let error = json["error"] as? Bool{
            if !error{
                if let landingData = json["feedsData"] as? [[String:AnyObject]]{
                    
                    for landing in landingData{
                        let items = LandingItems(LandingDict: landing)
                        landingItems.append(items)
                        /*if let feedType = landing["feedType"] as? String {
                            //print("from api Feed Type :\(feedType)")
                            self._feedType = feedType           //All the feed value will added into _feedType
                            if feedType == "userOnline" {
                                
                                if let onlineUserData = landing["activeFriendsData"] as? [[String: AnyObject]]{
                                    for users in onlineUserData {
                                        let onlineItems = LOnlineItems(dict: users)
                                        activeFriendsData.append(onlineItems)
                                    }
                                }
                            } else if feedType == "feeds" {
                                if let feedsData = landing["dataFeeds"] as? [[String:AnyObject]] {
                                    for feeds in feedsData {
                                        let feedsItem = LFeedsItem(FeedDict: feeds)
                                        dataFeeds.append(feedsItem)
                                    }
                                    print("Data feeds : \(dataFeeds)")
                                    
                                }
                            } else if feedType == "market" {
                                if let marketData = landing["data"] as? [[String: AnyObject]] {
                                    for market in marketData {
                                        let marketItems = LMarketItems(dict: market)
                                        data.append(marketItems)
                                    }
                                }
                            } else if feedType == "shortcut" {
                                if let menuData = landing["dataMenuShortcut"] as? [[String: AnyObject]] {
                                    for menus in menuData {
                                        let menuItems = LMenuItems(dict: menus)
                                        dataMenuShortcut.append(menuItems)
                                    }
                                }
                            }
                        }*/
                    }
                }
                self.delegate?.didReceiveData(mainDSource: landingItems, onlineUsers: activeFriendsData, feeds: dataFeeds, market: data, menu : dataMenuShortcut)
            }
        }
    }
    
    func postLike(postId:String, frinedId: String){
        let api = APIService()
        api.endPoint = Endpoints.INSERT_LIKE_URL
        api.params = "userId=\(AuthService.instance.userId)&postId=\(postId)&friendId=\(frinedId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success")
            case .Error(let error):
                print("Error :- \(error)")
            }
        }
    }
    
    //Using
    typealias completionHandler = (_ success: Bool, _ error: String?, _ data: [LandingItems]?) -> ()
    func getLandingData(completion: @escaping (APIResult<[LandingItems]>) -> ()){
        let service = APIService()
        service.endPoint = LandingEndPoints.LANDING_PAGE_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        print("Landing PARAAAAAMS : \(service.params)")
        print("#################  End points",service.endPoint)
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let data = self.handleCompletionLand(json: dict)
            completion(APIResult.Success(data))
            case .Error(let error):
        
                completion(APIResult.Error(error))
            }
        }
    }
    
    func handleCompletionLand(json: [String:AnyObject]) -> [LandingItems] {
        var data = [LandingItems]()
        if let error = json["error"] as? Bool{
            if !error{
                if let landingData = json["feedsData"] as? [[String:AnyObject]]{
                    
                    for landing in landingData{
                        let finalData = LandingItems(LandingDict: landing)
                        data.append(finalData)
                        
                    }
                    //self.delegate?.didReceiveData(data: data)
                }
                return data
            }
        }
        return data
    }
}

