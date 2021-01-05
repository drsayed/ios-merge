 //
//  UserLiveOperations.swift
//  myscrap

import Foundation
import CoreData

class UserLiveOperations {
    

    typealias onlineStatus = (_ onlineStat: [String : AnyObject]) -> ()
    
    func userGoLive(id: String,topic: String, completion: @escaping  onlineStatus){
   //     topic,link,time,status = 1,liveid="",friendId="",type="single"
    
      let service = APIService()
        service.endPoint = Endpoints.USER_LIVE_INSERT_URL
        service.params = "userId=\(id)&apiKey=\(API_KEY)&link=&topic=\(topic)&status=\(1)&type=single&time=\((Int(Date().timeIntervalSince1970)))"
        print(service.endPoint)
        print(service.params)
        service.getDataWith { /* [weak self] */ (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        completion(dict["message"] as! [String : AnyObject])
                    }
                }
            case .Error(_):
                print("Error")
            }
        }
    }
    func userEndLive(id: String, completion: @escaping  onlineStatus){
   //     topic,link,time,status = 1,liveid="",friendId="",type="single"
    
      let service = APIService()
        service.endPoint = Endpoints.USER_LIVE_INSERT_URL
        service.params = "userId=\(id)&apiKey=\(API_KEY)&link=&status=\(0)&type=single&time=\((Int(Date().timeIntervalSince1970)))"
        print(service.endPoint)
        print(service.params)
        service.getDataWith { /* [weak self] */ (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        completion(dict)
                    }
                }
            case .Error(_):
                print("Error")
            }
        }
    }
    func allUsersLiveStatus(id: String, completion: @escaping  onlineStatus){
   //     topic,link,time,status = 1,liveid="",friendId="",type="single"
    
      let service = APIService()
        service.endPoint = Endpoints.USER_LIVE_Status_URL
        service.params = "userId=\(id)&apiKey=\(API_KEY)"
        print(service.endPoint)
        print(service.params)
        service.getDataWith { /* [weak self] */ (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        completion(dict)
                    }
                }
            case .Error(_):
                print("Error")
            }
        }
    }
}
 
