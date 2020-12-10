//
//  LandingServiceV2.swift
//  myscrap
//
//  Created by MyScrap on 2/1/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

protocol LandingDelegateV2:class {
    func didReceivedFailure(error: String)
    func didReceiveData(mainDSource : [LandingItemsV2])
}

class LandingServiceV2 {
    weak var delegate: LandingDelegateV2?
    
    private var _feedType: String!
    
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
    
    //Not using
    typealias completionHandler = (_ error: Bool, _ status: String?, _ bgColor1: String?, _ bgColor2: String?, _ bgImage: String?, _ data: APIResult<[LandingItemsV2]>) -> ()
    //func getLandingData(completion: @escaping (APIResult<[LandingItemsV2]>) -> ()){
    func getLandingData(completion: @escaping completionHandler){
        let service = APIService()
        service.endPoint = LandingEndPoints.LANDING_PAGE_URL_V2
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        print("Landing PARAAAAAMS : \(service.params)")
        print("#################  End points",service.endPoint)
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                //completion(APIResult.Success(data))
                if let error = dict["error"] as? Bool {
                    let status = dict["status"] as? String
                    if !error {
                        
                        let bgColorTop = dict["bgColorInit"] as? String
                        let bgColorBottom = dict["bgColorSecond"] as? String
                        let bgGradientImg = dict["bgImageUrl"] as? String
                        let data = self.handleCompletionLand(json: dict)
                        completion(error, status, bgColorTop, bgColorBottom, bgGradientImg, APIResult.Success(data))
                    } else {
                        completion(error, status, "", "", "", APIResult.Error(status!))
                    }
                }
                
            case .Error(let error):
                completion(true, "Fail", "", "", "", APIResult.Error(error))
                //completion(APIResult.Error(error), <#String?#>, <#String?#>, <#String?#>, <#String?#>)
            }
        }
    }
    
    func handleCompletionLand(json: [String:AnyObject]) -> [LandingItemsV2] {
        var data = [LandingItemsV2]()
        if let error = json["error"] as? Bool{
            if !error{
                if let landingData = json["feedsData"] as? [[String:AnyObject]]{
                    
                    for landing in landingData{
                        let finalData = LandingItemsV2(LandingDict: landing)
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
