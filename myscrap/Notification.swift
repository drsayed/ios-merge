//
//  Notification.swift
//  myscrap
//
//  Created by MS1 on 10/16/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
protocol NotificationDelegate:class {
    func DidReceiveData(data : [NotificationItem])
    func DidReceiveError(error: String)
}
class Notifications{
    
    weak var delegate: NotificationDelegate?
    
    func getNotifications(){
        let service = APIService()
        service.endPoint = Endpoints.NOTIFICATION_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=0"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleNotificationDict(dict: dict)
            case .Error(let error):
                if let delegate = self?.delegate{
                    delegate.DidReceiveError(error: error)
                }
            }
        }
    }
    
    
    func acknowledgeMarket(listId: String, postedUserId: String, status: Int, completion : @escaping (String?) -> Void){
        let service = APIClient()
        let params = ["userId": postedUserId,
                      "apiKey": API_KEY,
                      "listId": listId,
                      "status" : "\(status)"]
        service.getDataWith(with: Endpoints.NOTIFICATION_ACKNOWLADGE_URL, params: params) { (result: Result<NotificationMarketResponse, APIError>) in
            switch result{
            case .success(let response):
                
                print(response.changedChatStatus)
                DispatchQueue.main.async {
                    if let string = response.changedChatStatus {
                        completion(string)
                    } else {
                        completion(nil)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }

    }
    
    
    
    
    typealias completionHandler = ( APIResult<[AnyObject]> ) -> Void
    
    func fetchNotificationsWith(_ completion: @escaping completionHandler ) -> URLSessionTask? {
        let service = APIService()
        service.endPoint = Endpoints.NOTIFICATION_V2_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=0"
        print(service.endPoint)
        print(service.params)
        
        let task = service.getTaskAndDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let strongSelf = self{
                    completion(strongSelf.getResult(dict: dict))
                }
            case .Error(let error):
                completion(.Error(error))
            }
        }
        return task
    }
    
    
    private func getResult(dict:[String: AnyObject]) -> APIResult<[AnyObject]>{
        if let error = dict["error"] as? Bool{
            if !error{
                  var data = [AnyObject]()
                
                if let notifications = dict["employeeReq"] as? [[String:AnyObject]]{
                  
                    for var notification in notifications{
                        // manually inserting type because not receiving in API
                        notification["type"] = "empReq" as AnyObject
                        let obj = RequestNotificationItem(notificationDict: notification)
                        data.append(obj)
                    }
                }
                
                if let notifications = dict["cardRequestNotification"] as? [[String:AnyObject]]{
                                   for notification in notifications{
                                       let obj = RequestNotificationItem(notificationDict: notification)
                                       data.append(obj)
                                   }

                               }
                if let notifications = dict["mobileReqNotification"] as? [[String:AnyObject]]{
                                                  for notification in notifications{
                                                      let obj = RequestNotificationItem(notificationDict: notification)
                                                      data.append(obj)
                                                  }
                                              }
                
                if let notifications = dict["followRequest"] as? [[String:AnyObject]]{
                    for notification in notifications{
                        let obj = RequestNotificationItem(notificationDict: notification)
                        data.append(obj)
                    }
                }
                
                if let notifications = dict["notificationData"] as? [[String:AnyObject]]{
                  
                    for notification in notifications{
                        let obj = NotificationItem(notificationDict: notification)
                        data.append(obj)
                    }
                }
                
                  return .Success(data)
            }
        }
        return .Error("Error Occured")
    }
    
    func clearNotification(){
        let service = APIService()
        service.endPoint = Endpoints.CLEAR_NOTIFICATION_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=0"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleNotificationDict(dict: dict)
            case .Error(let error):
                if let delegate = self?.delegate{
                    delegate.DidReceiveError(error: error)
                }
            }
        }
    }
    
    
    
    private func handleNotificationDict(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                if let notifications = dict["notificationData"] as? [[String:AnyObject]]{
                    var data = [NotificationItem]()
                    for notification in notifications{
                        let obj = NotificationItem(notificationDict: notification)
                        data.append(obj)
                    }
                    if let delegate = self.delegate{
                        delegate.DidReceiveData(data: data)
                    }
                }
            } else{
                delegate?.DidReceiveData(data: [NotificationItem]())
            }
        } else {
            delegate?.DidReceiveData(data: [NotificationItem]())
        }
    }
    
    
//    private func handleNotificationDict(dict: [String:AnyObject]){
//        if let error = dict["error"] as? Bool{
//            if !error{
//                if let notifications = dict["notificationData"] as? [[String:AnyObject]]{
//                    var data = [NotificationItem]()
//                    for notification in notifications{
//                        let obj = NotificationItem(notificationDict: notification)
//                        data.append(obj)
//                    }
//                    if let delegate = self.delegate{
//                        delegate.DidReceiveData(data: data)
//                    }
//                }
//            } else{
//                delegate?.DidReceiveData(data: [NotificationItem]())
//            }
//        } else {
//            delegate?.DidReceiveData(data: [NotificationItem]())
//        }
//    }
}


enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
}


struct NotificationMarketResponse : Decodable{
    var changedChatStatus : String?
}

