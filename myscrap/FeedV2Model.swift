//
//  FeedV2Model.swift
//  myscrap
//
//  Created by MyScrap on 3/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
import RealmSwift
/* API Version 2.0 */
protocol FeedV2Delegate:class {
    func didReceivedFailure(error: String)
    func didReceiveData(data: [FeedV2Item])
}

final class FeedV2Model {
    typealias completionHandler = (_ success: Bool, _ error: String?, _ data: [FeedV2Item]?) -> ()
    
    weak var delegate:FeedV2Delegate?
    
    //Get feeds V2.0
    func getAllFeeds(pageLoad:String, completion: @escaping (APIResult<[FeedV2Item]>) -> ()){
        let service = APIService()
        //"https://test.myscrap.com/feeds/msFeedPageV10" //
        service.endPoint =  V2EndPoints.FEEDS_V5_URL
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
    
    func handleFeed(json: [String:AnyObject]) -> [FeedV2Item] {
        var data = [FeedV2Item]()
        if let error = json["error"] as? Bool{
            if !error{
                DispatchQueue.main.async {
                    do {
                        let feedLoad = FeedLoadDB()
                        let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                        print(convertedString ?? "defaultvalue")
                        feedLoad.feedString = convertedString!
                        print("Feeds JSON String : \(feedLoad.feedString)")
                        try! uiRealm.write {
                            uiRealm.add(feedLoad)
                        }
                    } catch let myJSONError {
                        print(myJSONError)
                    }
                }
                
                if let feedsData = json["feedsData"] as? [[String:AnyObject]]{
                    
                    for feeds in feedsData{
                        let feed = FeedV2Item(FeedDict: feeds)
                        data.append(feed)
                    }
                }
                return data
            }
        }
        return data
    }
    
    /*
    func getReportedPosts(completion: @escaping ([FeedV2Item]) -> ()){
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
    } */
    
    func getReportedPosts(completion: @escaping ([FeedV2Item], [CompanyItems],[AdminRequestModel]) -> ()){
        let service = APIService()
        service.endPoint = Endpoints.REPORTED_POST_URL_V2//REPORTED_POST_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith {[weak self] (result) in
            print(result)
            switch result{
            case .Success(let dict):
            
                var feedsData = [FeedV2Item]()
                var companyData = [CompanyItems]()
                var requests = [AdminRequestModel]()

                if let data = dict["feedsData"] as? [[String:AnyObject]] {
                    let feedsItem = self?.handleFeed(json: dict)
                    feedsData = feedsItem!
                }
                if let companyDict = dict["companyData"] as? [[String:AnyObject]] {
                    
                    for companyItems in companyDict{
                        
                        if var companyDetailsDict = companyItems["detail"] as? [String : AnyObject] {

                            // manually adding report type and reason in details object because from API receiving out of the detail object
                            companyDetailsDict["reportType"] = companyItems["reportType"]
                            companyDetailsDict["reportReason"] = companyItems["reportReason"]
                            let companyItems = CompanyItems(companyDict: companyDetailsDict)
                            companyData.append(companyItems)
                        }
                    }
                }
                if let requestsDict = dict["employeeReq"] as? [[String:AnyObject]] {
                    
                    for reqItem in requestsDict {
                        let request = AdminRequestModel(Dict: reqItem)
                        requests.append(request)
                    }
                }
                completion(feedsData,companyData,requests)
                
            case .Error(let err):
                if let delegate = self?.delegate{
                    delegate.didReceivedFailure(error: err)
                }
            }
        }
    }
    func hitView(postId:String) {
        let api = APIService()
        api.endPoint = Endpoints.INSERT_VIDEO_VIEWS
        api.params = "userId=\(AuthService.instance.userId)&postId=\(postId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success")
            case .Error(let error):
                print("Error :- \(error)")
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
    /*Hitting like/dislike for Company of the Month feeds*/
    func postCMLike(cmId:String, likeText: String){
        let api = APIService()
        api.endPoint = Endpoints.INSERT_COM_MONTH_LIKE_URL
        api.params = "userId=\(AuthService.instance.userId)&cmId=\(cmId)&likeText=\(likeText)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                print("Success")
            case .Error(let error):
                print("Error :- \(error)")
            }
        }
    }
    /*Hitting like/dislike for Person of week feeds*/
    func postPOWLike(powId:String, likeText: String){
        let api = APIService()
        api.endPoint = Endpoints.INSERT_POW_LIKE_URL
        api.params = "userId=\(AuthService.instance.userId)&powId=\(powId)&likeText=\(likeText)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let dict):
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
    
    func postCMFavourite(cmId: String){
        let api = APIService()
        api.endPoint = Endpoints.INSERT_COM_MONTH_FAV
        api.params = "userId=\(AuthService.instance.userId)&cmId=\(cmId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Successfully handled inserting / removing favourite posts")
            case .Error(let error):
                print("Error handled inserting / removing favourite posts." , error)
            }
        }
    }
    
    func postPOWFavourite(powId: String){
        let api = APIService()
        api.endPoint = Endpoints.INSERT_POW_FAV_URL
        api.params = "userId=\(AuthService.instance.userId)&powId=\(powId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Successfully handled inserting / removing favourite person of week")
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
                NotificationCenter.default.post(name: Notification.Name("DeletedUserOwnVideo"), object: nil)

                //NotificationCenter.default.post(name: Notification.Name("DeletedUserOwnVideo"), object: nil)

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
}
