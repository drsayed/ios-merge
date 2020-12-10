//
//  BumpedItem.swift
//  myscrap
//
//  Created by MS1 on 12/11/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
class BumpedItem: MemberItem{
    
    private var _title: String!
    private var _bumpedTime:String!
    
    var title: String{
        if _title == nil { _title = "" } ; return _title
    }
    var bumpedTime:String{
        if _bumpedTime == nil { _bumpedTime = ""} ; return _bumpedTime
    }
    
    var bumpNew: Bool = false
    
    var jid: String?
    
    override init(Dict: Dictionary<String, AnyObject>) {
        super.init(Dict: Dict)
        if let title = Dict["title"] as? String{
            self._title = title
        }
        if let Jid = Dict["jId"] as? String{
            self.jid = Jid
        }
        
        if let timeStamp = Dict["timeStamp"] as? String{
            self._bumpedTime = timeStamp
        }
        
        if let isNew = Dict["isNew"] as? Bool{
//            self.isNew = isNew
            self.bumpNew = isNew
        }
    }
    
    static func getBumbs( completion: @escaping ((_ success:Bool,_ error:String?,[BumpedItem]?) -> ())) {
     
        let service = APIService()
        service.endPoint = Endpoints.BUMPED_POSTS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let json):
                if let error = json["error"] as? Bool{ 
                    var items = [BumpedItem]()
                    if !error{
                        if let bumpData = json["bumpPostsData"] as? [[String:AnyObject]]{
                            for obj in bumpData{
                                let item = BumpedItem(Dict: obj)
                                items.append(item)
                            }
                        }
                        completion(true, nil, items)
                    } else {
                        let status = json["status"] as! String
                        completion(false, status, nil)
                    }
                } else {
                    completion(false, "Json Error", nil)
                }
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    static func removeBumps( friendId:String, completion:  (_ success: Bool) -> ()){
        let service = APIService()
        service.endPoint = Endpoints.DELETE_BUMPED_POSTS_URL
        service.params = "userId=\(AuthService.instance.userId)&friendId=\(friendId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Successfully removed Bump")
            case .Error(_):
                print("Error in Removing Bump")
            }
        }
    }
    
    static func updateBumps(){
        let service = APIService()
        service.endPoint = Endpoints.UPDATE_BUMP_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                print(dict)
                print("Successfully updated Bump")
            case .Error(_):
                print("Error in updating Bump")
            }
        }
    }
    
}
