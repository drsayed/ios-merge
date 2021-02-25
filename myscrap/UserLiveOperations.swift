 //
//  UserLiveOperations.swift
//  myscrap

import Foundation
import CoreData

class UserLiveOperations {
    
  
    typealias onlineStatus = (_ onlineStat: [String : AnyObject]) -> ()
    
    func userGoLive(id: String,topic: String, completion: @escaping  onlineStatus){
   //     topic,link,time,status = 1,liveid="",friendId="",type="single"
    
//
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 30
//        configuration.timeoutIntervalForResource = 30
//        let session = URLSession(configuration: configuration)
//
//        let url = URL(string: Endpoints.USER_LIVE_INSERT_URL)!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let parameters = "userId=\(id)&apiKey=\(API_KEY)&link=&topic=\(topic)&status=\(1)&type=single&time=\((Int(Date().timeIntervalSince1970)))"
//        var postData  = parameters.data(using: .utf8)
//        var postLength:NSString = String( postData!.count ) as NSString
//        request.httpBody = postData
//        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//            if error != nil || data == nil {
//                print("Client error!")
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
//                print("Oops!! there is server error!")
//                return
//            }
//
//            guard let mime = response.mimeType, mime == "application/json" else {
//                print("response is not json")
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print("The Response is : ",json)
//            } catch {
//                print("JSON error: \(error.localizedDescription)")
//            }
//
//        })
//
//        task.resume()

        
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
    func UpdateUserStatus(id: String,Status:String = "single", completion: @escaping  onlineStatus){
   //     topic,link,time,status = 1,liveid="",friendId="",type="single"
    
      let service = APIService()
        service.endPoint = Endpoints.USER_LIVE_INSERT_URL
        service.params = "userId=\(id)&apiKey=\(API_KEY)&link=&topic=&status=\(1)&type=\(Status)&time=\((Int(Date().timeIntervalSince1970)))"
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
    func userViewLive(id: String,liveid: String, completion: @escaping  onlineStatus){
   //     topic,link,time,status = 1,liveid="",friendId="",type="single"
      let service = APIService()
        service.endPoint = Endpoints.USER_LIVE_VIEWS_URL
        service.params = "userId=\(id)&apiKey=\(API_KEY)&link=&device=\(MOBILE_DEVICE)&liveId=\(liveid)&status=\(0)&type=single&time=\((Int(Date().timeIntervalSince1970)))"
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
    func userEndViewLive(id: String,liveid: String, completion: @escaping  onlineStatus){
   //     topic,link,time,status = 1,liveid="",friendId="",type="single"
      let service = APIService()
        service.endPoint = Endpoints.USER_LIVE_VIEWS_URL
        service.params = "userId=\(id)&apiKey=\(API_KEY)&link=&device=\(MOBILE_DEVICE)&liveId=\(liveid)&status=\(1)&type=single&time=\((Int(Date().timeIntervalSince1970)))"
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
    func allUsersLiveStatus(id: String,LiveId: String, completion: @escaping  onlineStatus){
   //     topic,link,time,status = 1,liveid="",friendId="",type="single"
    
      let service = APIService()
        service.endPoint = Endpoints.USER_LIVE_Status_URL
        service.params = "userId=\(id)&apiKey=\(API_KEY)&liveId=\(LiveId)"
        print(service.endPoint)
        print(service.params)
        service.getDataWith { /* [weak self] */ (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        completion(dict)
                    }
                    else
                    {
                        completion(dict)
                    }
                }
            case .Error(_):
                print("Error")
            }
        }
    }
    func simplePostRequestWithParamsAndErrorHandling(){
        
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            let session = URLSession(configuration: configuration)
            
            let url = URL(string: "https://httpbin.org/post")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let parameters = ["username": "foo", "password": "123456"]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                if error != nil || data == nil {
                    print("Client error!")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Oops!! there is server error!")
                    return
                }
                
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("response is not json")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print("The Response is : ",json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
            })
            
            task.resume()
        }
}
 
