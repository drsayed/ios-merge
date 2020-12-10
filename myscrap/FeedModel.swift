//
//  FeedModel.swift
//  myscrap
//
//  Created by MS1 on 10/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
protocol FeedDelegate:class {
    func didReceivedFailure(error: String)
    func didReceiveData(data: [FeedItem])
}

final class FeedModel{
    
    typealias completionHandler = (_ success: Bool, _ error: String?, _ data: [FeedItem]?) -> ()
    
    weak var delegate:FeedDelegate?
    
    func getFeeds(pageLoad:String, completion: @escaping (APIResult<[FeedItem]>) -> ()){
        let service = APIService()
//        service.endPoint = Endpoints.USERFEEDS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=0&companyId=0&pageLoad=\(pageLoad)"
        print("PARAAAAAMS : \(service.params)")
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            service.params.append("&version=\(version)")
        }
        print(service.endPoint)
        print(service.params)
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let data = self.handleFeed(json: dict)
                completion(APIResult.Success(data))
            case .Error(let error):
                completion(APIResult.Error(error))
            }
        }
    }
    
    static func getFeeds(pageLoad: String, _ completion: @escaping completionHandler){
        let service = APIService()
//        service.endPoint = Endpoints.USERFEEDS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=0&companyId=0&pageLoad=\(pageLoad)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                guard let error = dict["error"] as? Bool, !error , let feedsData = dict["feedsData"] as? [[String: AnyObject]] else {
                    completion(false, "Error in internal Json", nil)
                    return
                }
                var data = [FeedItem]()
                for feeds in feedsData{
                    let feed = FeedItem(FeedDict: feeds)
                    data.append(feed)
                }
                completion(true, nil, data)
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    func getReportedPosts(completion: @escaping ([FeedItem]) -> ()){
        let service = APIService()
        service.endPoint = Endpoints.REPORTED_POST_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith {[weak self] (result) in
            print(result)
            switch result{
            case .Success(let dict):
                let data = self?.handleFeed(json: dict)
                completion(data!)
            case .Error(let err):
                if let delegate = self?.delegate{
                    delegate.didReceivedFailure(error: err)
                }
            }
        }
    }
    func getFavouritePosts(){
        let service = APIService()
        service.endPoint = Endpoints.FAVOURITE_POST_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith {(result) in
            switch result{
            case .Success(let dict):
                self.handleFeed(json: dict)
            case .Error(let err):
                if let delegate = self.delegate{
                    delegate.didReceivedFailure(error: err)
                }
            }
        }
    }
    
    typealias fvCompletionHandler = (APIResult<[FeedItem]>) -> Void
    
    func fetchFavouritePosts(_ completion : @escaping fvCompletionHandler){
        let service = APIService()
        service.endPoint = Endpoints.FAVOURITE_POST_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith {(result) in
            switch result{
            case .Success(let json):
                if let error = json["error"] as? Bool{
                    if !error{
                        var data = [FeedItem]()
                        if let feedsData = json["feedsData"] as? [[String:AnyObject]]{
                            for feeds in feedsData{
                                let feed = FeedItem(FeedDict: feeds)
                                data.append(feed)
                            }
                        }
                        completion(.Success(data))
                    } else {
                        completion(.Error("No json"))
                    }
                } else {
                    completion(.Error("No json"))
                }
            case .Error(let err):
                if let delegate = self.delegate{
                    delegate.didReceivedFailure(error: err)
                }
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
    
    func postFavourite(postId: String, friendId: String){
        let api = APIService()
        api.endPoint = Endpoints.INSERT_FAVOURITE_POST_URL
        api.params = "userId=\(AuthService.instance.userId)&postId=\(postId)&friendId=\(friendId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Successfully handled inserting / removing favourite posts")
            case .Error(let error):
                print("Error handled inserting / removing favourite posts." , error)
            }
        }
    }
    
    func deletePost(postId: String, albumId: String){
        let api = APIService()
        api.endPoint = Endpoints.DELETE_POST_URL
        api.params = "postId=\(postId)&albumId=\(albumId)&userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success( _):
                print("Deleted Post Succesfully")
            case .Error(let error):
                print("Error in deleting Post" , error )
            }
        }
        
    }
    
    func reportPost(postId:String, friendId:String){
        let api = APIService()
        api.endPoint = Endpoints.REPORT_POST_URL
        api.params =  "userId=\(AuthService.instance.userId)&postId=\(postId)&friendId=\(friendId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success")
            case .Error(_):
                print("Error Reporting Content")
            }
        }
    }
    
    func unReportPost(postId:String, friendId:String, reportId: String){
        let api = APIService()
        api.endPoint = Endpoints.REPORT_POST_URL
        api.params =  "userId=\(AuthService.instance.userId)&postId=\(postId)&friendId=\(friendId)&apiKey=\(API_KEY)&companyId=&reportId=\(reportId)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success")
            case .Error(_):
                print("Error Reporting Content")
            }
        }
    }
    
    
    func handleFeed(json: [String:AnyObject]) -> [FeedItem] {
        var data = [FeedItem]()
        if let error = json["error"] as? Bool{
            if !error{
                if let feedsData = json["feedsData"] as? [[String:AnyObject]]{
                    for feeds in feedsData{
                        let feed = FeedItem(FeedDict: feeds)
                        data.append(feed)
                        print("Feed Model count : \(data.count)")
                    }
                }
                return data
            }
        }
        return data
    }
    
    
}
