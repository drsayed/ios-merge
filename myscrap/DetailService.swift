//
//  DetailService.swift
//  myscrap
//
//  Created by MS1 on 11/21/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
protocol DetailDelegate: class{
    func DidReceiveError(error: String)
    func DidReceiveDetails(feed: FeedV2Item?, members: [MemberItem], comment: [CommentItem])
    func DidReceiveCMDetails(feed: FeedV2Item?, comment: [CommentCMItem])
    func DidReceivePOWDetails(feed: FeedV2Item?, comment: [CommentPOWItem])
}
class DetailService {
    
    weak var delegate: DetailDelegate?
    
    func getDetails(postId:String){
        let service = APIService()
        service.endPoint = Endpoints.DETAILS_POST_URL_V2
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&postId=\(postId)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleDict(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    /*Company of the Month*/
    func getCMDetails(cmId: String){
        let service = APIService()
        service.endPoint = Endpoints.FETCH_DETAIL_CM_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&cmId=\(cmId)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleCMDict(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    /*Person of the week*/
    func getPOWDetails(powId: String){
        let service = APIService()
        service.endPoint = Endpoints.FETCH_DETAIL_POW_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&powId=\(powId)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handlePOWDict(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    private func handleDict(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                //var feedItem : FeedItem?
                var feedV2Item : FeedV2Item?
                var members = [MemberItem]()
                var comments = [CommentItem]()
                if let feedsData = dict["feedsData"] as? [[String: AnyObject]]{
                    if let feed = feedsData.last {
                        let objfeed = FeedV2Item(FeedDict: feed)
                        feedV2Item = objfeed
                    }
                    if let likeData = dict["likeData"] as? [[String: AnyObject]]{
                        for obj in likeData{
                            let mem = MemberItem(Dict: obj)
                            members.append(mem)
                        }
                    }
                    if let commentData = dict["commentData"] as? [[String:AnyObject]]{
                        for obj in commentData{
                            let comment = CommentItem(Dict: obj)
                            comments.append(comment)
                        }
                    }
                    
                }
                delegate?.DidReceiveDetails(feed: feedV2Item, members: members, comment: comments)
            } else {
                delegate?.DidReceiveError(error: "Error processed After Api Call")
            }
        }
    }
    private func handleCMDict(dict: [String:AnyObject]) {
        if let error = dict["error"] as? Bool{
            if !error{
                //var feedItem : FeedItem?
                var feedV2Item : FeedV2Item?
                var cmComment = [CommentCMItem]()
                if let feedsData = dict["feedsData"] as? [String: AnyObject]{
                    let objfeed = FeedV2Item(FeedDict: feedsData)
                    feedV2Item = objfeed
                }
                if let commentData = dict["commentData"] as? [[String:AnyObject]]{
                    for obj in commentData{
                        let comment = CommentCMItem(Dict: obj)
                        cmComment.append(comment)
                    }
                }
                delegate?.DidReceiveCMDetails(feed: feedV2Item, comment: cmComment)
            } else {
                delegate?.DidReceiveError(error: "Error processed After Api Call")
            }
        }
    }
    private func handlePOWDict(dict: [String:AnyObject]) {
        if let error = dict["error"] as? Bool{
            if !error{
                //var feedItem : FeedItem?
                var feedV2Item : FeedV2Item?
                var cmComment = [CommentPOWItem]()
                if let feedsData = dict["feedsData"] as? [String: AnyObject]{
                    let objfeed = FeedV2Item(FeedDict: feedsData)
                    feedV2Item = objfeed
                }
                if let commentData = dict["commentData"] as? [[String:AnyObject]]{
                    for obj in commentData{
                        let comment = CommentPOWItem(Dict: obj)
                        cmComment.append(comment)
                    }
                }
                delegate?.DidReceivePOWDetails(feed: feedV2Item, comment: cmComment)
            } else {
                delegate?.DidReceiveError(error: "Error processed After Api Call")
            }
        }
    }
    //Feed  image /text/ image+text
    func insertComment(postId:String,postedUserId: String, comment: String ){
        let service = APIService()
        service.endPoint = Endpoints.COMMENT_INSERT_URL
        let timestamp = Int(NSDate().timeIntervalSince1970)
        service.params = "userId=\(AuthService.instance.userId)&postId=\(postId)&friendId=\(postedUserId)&comment=\(comment)&timeStamp=\(timestamp)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleDict(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    /*Company Of the Month*/ //not using
    func insertCMComment(cmId:String, commentText: String ){
        let service = APIService()
        service.endPoint = Endpoints.INSERT_COM_MONTH_COMMENT
        //let timestamp = Int(NSDate().timeIntervalSince1970)
        service.params = "userId=\(AuthService.instance.userId)&cmId=\(cmId)&commentText=\(commentText)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleDict(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    /*Person Of Week*/ //not using
    func insertCMComment(powId:String, commentText: String ){
        let service = APIService()
        service.endPoint = Endpoints.INSERT_POW_COMMENT_URL
        //let timestamp = Int(NSDate().timeIntervalSince1970)
        service.params = "userId=\(AuthService.instance.userId)&cmId=\(powId)&commentText=\(commentText)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleDict(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    
    typealias commentCompletion = ([CommentItem]?) -> Void
    
    func insertDetailComment(postId:String,postedUserId: String, comment: String , editId: String? = nil, completion : @escaping commentCompletion){
        let service = APIService()
        service.endPoint = Endpoints.COMMENT_INSERT_URL
        let timestamp = Int(NSDate().timeIntervalSince1970)
        service.params = "userId=\(AuthService.instance.userId)&postId=\(postId)&friendId=\(postedUserId)&comment=\(comment)&timeStamp=\(timestamp)&apiKey=\(API_KEY)"
        if let editid = editId{
            service.params.append("&editId=\(editid)")
        }
//        print(service.endPoint)
//        print(service.params)
        service.getDataWith {(result) in
            switch result{
            case .Success(let dict):
                if let commentData = dict["commentData"] as? [[String:AnyObject]]{
                    var cmts = [CommentItem]()
                    for obj in commentData{
                        let comment = CommentItem(Dict: obj)
                        cmts.append(comment)
                    }
                    completion(cmts)
                } else {
                    completion(nil)
                }
            case .Error(let _):
                print("Error Occured")
                completion(nil)
            }
        }
    }
    //INSERT/EDIT comment of Company of the Month
    typealias commentCMCompletion = ([CommentCMItem]?) -> Void
    func insertEditCMComment(cmId:String, commentText: String , editCommentId: String? = nil, completion : @escaping commentCMCompletion){
        let service = APIService()
        service.endPoint = Endpoints.INSERT_COM_MONTH_COMMENT
        let timestamp = Int(NSDate().timeIntervalSince1970)
        service.params = "userId=\(AuthService.instance.userId)&cmId=\(cmId)&commentText=\(commentText)&apiKey=\(API_KEY)"
        if let editCommentId = editCommentId{
            service.params.append("&editCommentId=\(editCommentId)")
        }
        //        print(service.endPoint)
        //        print(service.params)
        service.getDataWith {(result) in
            switch result{
            case .Success(let dict):
                if let commentData = dict["commentData"] as? [[String:AnyObject]]{
                    var cmts = [CommentCMItem]()
                    for obj in commentData{
                        let comment = CommentCMItem(Dict: obj)
                        cmts.append(comment)
                    }
                    completion(cmts)
                } else {
                    completion(nil)
                }
            case .Error(let _):
                print("Error Occured")
                completion(nil)
            }
        }
    }
    
    //INSERT/EDIT comment of Person of Week
    typealias commentPOWCompletion = ([CommentPOWItem]?) -> Void
    func insertEditPOWComment(powId:String, commentText: String , editCommentId: String? = nil, completion : @escaping commentPOWCompletion){
        let service = APIService()
        service.endPoint = Endpoints.INSERT_POW_COMMENT_URL
        let timestamp = Int(NSDate().timeIntervalSince1970)
        service.params = "userId=\(AuthService.instance.userId)&powId=\(powId)&commentText=\(commentText)&apiKey=\(API_KEY)"
        if let editCommentId = editCommentId{
            service.params.append("&editCommentId=\(editCommentId)")
        }
        print(service.endPoint)
        print(service.params)
        service.getDataWith {(result) in
            switch result{
            case .Success(let dict):
                if let commentData = dict["commentData"] as? [[String:AnyObject]]{
                    var cmts = [CommentPOWItem]()
                    for obj in commentData{
                        let comment = CommentPOWItem(Dict: obj)
                        cmts.append(comment)
                    }
                    completion(cmts)
                } else {
                    completion(nil)
                }
            case .Error(let _):
                print("Error Occured")
                completion(nil)
            }
        }
    }
    
    func insertPost(friendId:String,editPostId:String,content: String ,feedImage:String,eventId:String?, tagging: [[String:String]]?, completionHandler: @escaping (Bool) -> ()){
        var ipAdress = ""
        if AuthService.instance.getIFAddresses().count >= 1 {
            ipAdress = AuthService.instance.getIFAddresses().description
        }
      
        let service = APIService()
        service.endPoint = Endpoints.USER_PROFILE_INSERT_URL
        service.params = "userId=\(AuthService.instance.userId)&friendId=\(friendId)&editPostId=\(editPostId)&apiKey=\(API_KEY)&content=\(content)&timeStamp=\(Int(Date().timeIntervalSince1970))&feedImage=\(feedImage)&device=\(MOBILE_DEVICE)&ipAddress=\(ipAdress)".replacingOccurrences(of: "+", with: "%2B")
        
        
        
        if let tag = tagging {
            let dict = ["tagging": tag]
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) , let string = String(data: jsonData, encoding: .ascii){
                service.params += "&tagged=\(string)"
            }
        }
        if let id = eventId{  service.params += "&eventPost=1&eventId=\(id)"}
        
        print(service.params)
        
        service.getDataWith {(result) in
            switch result{
            case .Success(_):
                completionHandler(true)
            case .Error(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    func insertPost_V2(friendId:String,editPostId:String,content: String ,videoFeed: String ,feedImage: Dictionary<String, AnyObject>,eventId:String?, tagging: [[String:String]]?, completionHandler: @escaping (Bool) -> ()){
        var ipAdress = ""
        if AuthService.instance.getIFAddresses().count >= 1 {
            ipAdress = AuthService.instance.getIFAddresses().description
        }
         var imageCount = 0
        var decoded = "null"
        if videoFeed != ""
        {
            imageCount = 0
        }
        else
        {
            imageCount = feedImage["multiImage"]?.count as! Int
            let jsonData = try! JSONSerialization.data(withJSONObject: feedImage, options: [])
            decoded = String(data: jsonData, encoding: .utf8)!
        }
      
     
        let service = APIService()
        service.endPoint = Endpoints.USER_PROFILE_INSERT_URL_V2
        if imageCount == 0 && videoFeed == ""{
            service.params = "userId=\(AuthService.instance.userId)&friendId=\(friendId)&editPostId=\(editPostId)&apiKey=\(API_KEY)&content=\(content)&timeStamp=\(Int(Date().timeIntervalSince1970))&multiImage=\(decoded)&feedImage=&imageCount=\(imageCount as Int)&device=\(MOBILE_DEVICE)&ipAddress=\(ipAdress)".replacingOccurrences(of: "+", with: "%2B")
        }
        else
        {
            service.params = "userId=\(AuthService.instance.userId)&friendId=\(friendId)&editPostId=\(editPostId)&apiKey=\(API_KEY)&content=\(content)&timeStamp=\(Int(Date().timeIntervalSince1970))&multiImage=\(decoded)&feedImage=Array&imageCount=\(imageCount as Int)&device=\(MOBILE_DEVICE)&ipAddress=\(ipAdress)".replacingOccurrences(of: "+", with: "%2B")
        }
        
       
        
         service.params =  service.params + videoFeed
        
        if let tag = tagging {
            let dict = ["tagging": tag]
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) , let string = String(data: jsonData, encoding: .ascii){
                service.params += "&tagged=\(string)"
            }
        }
        if let id = eventId{
            service.params += "&eventPost=1&eventId=\(id)"
            
        }
        
        print(service.params)
        

        
        
        service.getDataWith {(result) in
            switch result{
            case .Success(_):
                completionHandler(true)
            case .Error(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
   
}



extension Dictionary{
    
    
    

    func convertIntoString() -> String?{
        do {
            
        }
        
        return nil
    }
    
}
