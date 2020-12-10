//
//  Member.swift
//  myscrap
//
//  Created by MS1 on 10/16/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import CoreData

protocol MemberDelegate: class {
    func DidReceivedData(data: [MemberItem])
    func DidReceivedError(error: String)
}
protocol OnlineDelegate: class {
    func DidReceivedData(data: [ActiveUsers])
    func DidReceivedError(error: String)
}
class MemmberModel{
    
    weak var delegate: MemberDelegate?
    weak var online_delegate: OnlineDelegate?
    
    //Not using
    func getMember(pageLoad: String,searchText: String, orderBy: String){
        let service = APIService()
        service.endPoint = Endpoints.ADD_CONTACTS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=\(pageLoad)&searchText=\(searchText)&orderByText=\(orderBy)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleJson(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    //MARK:- send Follow Request
    func sendFollowRequest(friendId:String){
        
        let service = APIService()
        service.endPoint = Endpoints.SEND_FOLLOW_REQUEST
        service.params = "friendId=\(friendId)&userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        print("Params : \(service.params), URL : \(service.endPoint)")
        service.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success in sending follow request")
            case .Error(_):
                print("Error  in Following User")
            }
        }

    }
    
    //MARK:- send unFollow Request
    func sendUnFollowRequest(friendId:String){
        
        let service = APIService()
        service.endPoint = Endpoints.SEND_UNFOLLOW_REQUEST
        service.params = "friendId=\(friendId)&userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        print("Params : \(service.params), URL : \(service.endPoint)")
        service.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success in sending follow request")
            case .Error(_):
                print("Error  in Following User")
            }
        }

    }
    
    //MARK:- MEMBERS JSON
    typealias completionHandler = (_ success: Bool, _ error: String?, _ data: [MemberItem]?) -> ()
    
    func getMembers(pageLoad: String,searchText: String, orderBy: String, completion: @escaping (APIResult<[MemberItem]>) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.ADD_CONTACTS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=\(pageLoad)&searchText=\(searchText)&orderByText=\(orderBy)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let data = self.handleJSON(dict: dict)
                completion(APIResult.Success(data))
            case .Error(let error):
                completion(APIResult.Error(error))
            }
        }
    }
    
    private func handleJSON(dict: [String:AnyObject]) -> [MemberItem] {
        var data = [MemberItem]()
        if let error = dict["error"] as? Bool{
            if !error{
                if let AddContactsData = dict["addContactsData"] as? [[String:AnyObject]]{
                    for obj in AddContactsData{
                        let item = MemberItem(Dict:obj)
                        data.append(item)
                    }
                }
                return data
            } else {
                let status = dict["status"] as? String
                self.delegate?.DidReceivedError(error: status!)
            }
        }
        return data
    }
    
    func getEventInterested(eventId:String, completion: @escaping (([MemberItem]?) -> ()) ){
        let service = APIService()
        service.endPoint = Endpoints.EVENT_INTERESTED_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&eventId=\(eventId)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        if let AddContactsData = dict["eventListData"] as? [[String:AnyObject]]{
                            var data = [MemberItem]()
                            for obj in AddContactsData{
                                let item = MemberItem(Dict:obj)
                                data.append(item)
                            }
                            completion(data)
                        }
                    } else {
                        completion(nil)
                    }
                }
            case .Error(_):
                completion(nil)
            }
        }
    }
    
    func getEventGoing(eventId:String, completion: @escaping (([MemberItem]?) -> ()) ){
        let service = APIService()
        service.endPoint = Endpoints.EVENT_GOING_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&eventId=\(eventId)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                self.saveDatainBackground(dict: dict)
                if let error = dict["error"] as? Bool{
                    if !error{
                        if let AddContactsData = dict["eventListData"] as? [[String:AnyObject]]{
                            var data = [MemberItem]()
                            for obj in AddContactsData{
                                let item = MemberItem(Dict:obj)
                                data.append(item)
                            }
                            completion(data)
                        }
                    } else {
                        completion(nil)
                    }
                }
            case .Error(_):
                completion(nil)
            }
        }
    }
    
    func saveDatainBackground(dict: [String: AnyObject]){
        DispatchQueue.main.async {
            
            let operation = MemberOperation()
            let app = UIApplication.shared.delegate as! AppDelegate
            app.persistentContainer.performBackgroundTask({ (moc) in
                if let AddContactsData = dict["addContactsData"] as? [[String:AnyObject]]{
                    for contact in AddContactsData{
                        
                        let profilePic = contact["profilePic"] as? String
                        if let name = contact["name"] as? String,
                        let designation = contact["designation"] as? String,
                        let userId = contact["userid"] as? String,
                        let colorCode = contact["colorCode"] as? String ,
                        let jid = contact["jId"] as? String{
                            
                            if let _ = operation.getMembersWithoutDesignation(with: jid, moc: moc){
                                operation.updateMember(of: jid, designation: designation, with: moc)
                            } else {
                                // update Member
                                operation.updateMember(with: jid, userId: userId, profilePic: profilePic ?? "", colorCode: colorCode, name: name, designation: designation, moc: moc)
                            }
                        }
                    }
                }
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name.memberCorDataUpdated, object: nil)
                }
            })
        }
        
    }
    
    func getMembers( completion: @escaping (([MemberItem]?) -> ()) ){
        let service = APIService()
        service.endPoint = Endpoints.ADD_CONTACTS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=0"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        if let AddContactsData = dict["addContactsData"] as? [[String:AnyObject]]{
                            var data = [MemberItem]()
                            for obj in AddContactsData{
                                let item = MemberItem(Dict:obj)
                                data.append(item)
                            }
                            completion(data)
                        }
                    } else {
                        completion(nil)
                    }
                }
            case .Error(_):
                completion(nil)
            }
        }
    }
    
    
    func getFavourites(){
        let service = APIService()
        service.endPoint = Endpoints.FAVOURITES_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=0"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleFavouritesJson(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    func getModerators(){
        let service = APIService()
        service.endPoint = Endpoints.ModeratorsURL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=0"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleFavouritesJson(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    func postFavourite(friendId:String){
        let service = APIService()
        service.endPoint =  Endpoints.CONNECT_PEOPLE_URL
        service.params = "userId=\(AuthService.instance.userId)&friendId=\(friendId)&apiKey=\(API_KEY)"
        print("Params : \(service.params), URL : \(service.endPoint)")
        service.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success in handling favourite member")
            case .Error(_):
                print("Error in handling favourite member")
            }
        }
    }
    
    func clickLike(friendId:String, action:String){
        let service = APIService()
        service.endPoint =  Endpoints.POST_PROFILE_LIKE
        service.params = "friendId=\(friendId)&userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&action=\(action)"
        print("Params : \(service.params), URL : \(service.endPoint)")
        service.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success in handling Like")
            case .Error(_):
                print("Error in handling Like")
            }
        }
    }
    
    func clickFav(friendId:String, action:String){
        let service = APIService()
        service.endPoint =  Endpoints.POST_PROFILE_FAV
        service.params = "friendId=\(friendId)&userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&action=\(action)"
        print("Params : \(service.params), URL : \(service.endPoint)")
        service.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Success in handling favourite member")
            case .Error(_):
                print("Error in handling favourite member")
            }
        }
    }
    
    
    
   
    
    //MARK:- NEAR FRIENDS API
    func getNearFriends(completion: @escaping ([MemberItem]) -> ()){
        let api = APIService()
        api.endPoint = Endpoints.MS_NEAR_FRIENDS_URL
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&timeZone=\(TimeZone.current.identifier)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let json):
                let data = self.handleNearFriends(dict: json)
                completion(data)
            case .Error(_):
                completion([])
            }
        }
    }
    
    //MARK:- Online users API
    func getOnlineFriends(completion: @escaping ([ActiveUsers]) -> ()){
        let api = APIService()
        api.endPoint = Endpoints.ACTIVE_FRIENDS_URL
        print("User JID in member model: \(AuthService.instance.userJID!)")
        api.params = "userjid=\(AuthService.instance.userJID!)&apiKey=\(API_KEY)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        api.getDataWith { (result) in
            switch result{
            case .Success(let json):
                let data = self.handleOnlineFriends(dict: json)
                completion(data)
            case .Error(_):
                completion([])
            }
        }
    }
    
    
    
    //MARK:- MEMBERS JSON //Not using
    private func handleJson(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                if let AddContactsData = dict["addContactsData"] as? [[String:AnyObject]]{
                    var data = [MemberItem]()
                    for obj in AddContactsData{
                        let item = MemberItem(Dict:obj)
                        data.append(item)
                    }
                    delegate?.DidReceivedData(data: data)
                }
            } else {
                self.delegate?.DidReceivedError(error: "Error in api")
            }
        }
    }
    
    
    //MARK:- FAVOURITES JSON
    private func handleFavouritesJson(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                if let AddContactsData = dict["favouriteDetailsData"] as? [[String:AnyObject]]{
                    var data = [MemberItem]()
                    for obj in AddContactsData{
                        let item = MemberItem(Dict:obj)
                        data.append(item)
                    }
                    delegate?.DidReceivedData(data: data)
                }
            } else {
                self.delegate?.DidReceivedError(error: "Error in api")
            }
        }
    }
    
   
    

    
    //MARK:- NEAR FRIENDS
    private func handleNearFriends(dict: [String:AnyObject]) -> [MemberItem]{
        if let error = dict["error"] as? Bool{
            var data = [MemberItem]()
            if !error{
                if let AddContactsData = dict["nearFriendsData"] as? [[String:AnyObject]]{
                    for obj in AddContactsData{
                        let item = MemberItem(Dict:obj)
                        data.append(item)
                    }
                    return data
                }
            }
        }
        return []
    }
    
    //MARK:- Online Users
    private func handleOnlineFriends(dict: [String:AnyObject]) -> [ActiveUsers]{
        if let error = dict["error"] as? Bool{
            if !error{
                var users = [ActiveUsers]()
                if let datas = dict["activeFriendsData"] as? [[String: AnyObject]]{
                    for data in datas{
                        let active = ActiveUsers(dict: data)
                        users.append(active)
                    }
                    return users
                }
            }
        }
        return []
    }
}

