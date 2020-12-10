//
//  NearFriendsModel.swift
//  myscrap
//
//  Created by MS1 on 10/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
protocol NearFriendsDelegate: class {
    func didFailedNearFriends(error: String)
    func didReceivedNearFriends(data: [NearFriendsItem])
}
final class NearFriendsModel{
    
    weak var delgate:NearFriendsDelegate?
    
    func getNearFriends(){
        let api = APIService()
        api.endPoint = Endpoints.MS_NEAR_FRIENDS_URL
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let json):
                self.handleJson(json: json)
            case .Error(let error):
                if let delegate = self.delgate{
                    delegate.didFailedNearFriends(error: error)
                }
            }
        }
    }
    private func handleJson(json : [String:AnyObject]){
        if let error = json["error"] as? Bool{
            if !error{
                var data = [NearFriendsItem]()
                if let nearFriendsData = json["nearFriendsData"] as? [[String:AnyObject]]{
                    for friends in nearFriendsData{
                        let friend = NearFriendsItem(nearDict: friends)
                        data.append(friend)
                    }
                    if let delegate = self.delgate{
                        delegate.didReceivedNearFriends(data: data)
                    }
                }
            } else{
                if let delegate = self.delgate{
                    delegate.didFailedNearFriends(error: "Failed")
                }
            }
        }
    }
}
