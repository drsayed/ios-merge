//
//  ChatService.swift
//  myscrap
//
//  Created by MyScrap on 4/25/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class ChatService {
    lazy var client : APIClient = {
        let client = APIClient()
        return client
    }()
    
    lazy var service : APIService = {
        return APIService()
    }()
    
    weak var delegate : ChatServiceDelegate?
    
    func activeUsers(){
        let service = APIService()
        service.endPoint = Endpoints.ACTIVE_FRIENDS_URL
        print("User JID in chat service: \(AuthService.instance.userJID!)")
        service.params = "userjid=\(AuthService.instance.userJID!)&apiKey=\(API_KEY)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        service.getDataWith { (result) in
            print("Result : \(result)")
            switch result{
            case .Success(let dict):
                if let datas = dict["activeFriendsData"] as? [[String: AnyObject]]{
                    var users = [ActiveUsers]()
                    for data in datas{
                        let active = ActiveUsers(dict: data)
                        users.append(active)
                    }
                    self.delegate?.DidReceivedData(data: users)
                } 
            case .Error(let error):
                print(error)
                print("Chat online users fetch error")
                self.delegate?.DidReceivedError(error: error)
            }
        }
    }
}
protocol ChatServiceDelegate: class {
    func DidReceivedData(data: [ActiveUsers])
    func DidReceivedError(error: String)
}

