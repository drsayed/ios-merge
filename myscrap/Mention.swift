//
//  SZExampleMention.swift
//  SZMentionsExample
//
//  Created by Steven Zweier on 1/12/16.
//  Copyright © 2016 Steven Zweier. All rights reserved.
//

import UIKit

class Mention: CreateMention {
    var mentionId: String = ""
    var mentionName: String = ""
    var designation : String = ""
    var mentionRange: NSRange = NSMakeRange(0, 0)
    var colorCode: String = ""
    private var _profilePic: String!
    var profilePic:String{
        if _profilePic == nil { _profilePic = ""} ; return _profilePic
    }
    var country = ""
    
    
    init(Dict: [String:AnyObject]) {
        if let name = Dict["name"] as? String{
            self.mentionName = name
        }
        if let profilePic = Dict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let country = Dict["country"] as? String{
            self.country = country
        }
        
        if let userId = Dict["userid"] as? String{
            self.mentionId = userId
        }
        if let userId = Dict["userId"] as? String{
            self.mentionId = userId
        }
        if let designation = Dict["designation"] as? String{
            self.designation = designation
        }
        if let designation = Dict["designation"] as? String{
            self.designation = designation
        }
        if let colorCode = Dict["colorCode"] as? String{
            self.colorCode = colorCode
        }
    }
    
    
    static func getMentions(completion: @escaping (([Mention]?) -> ()) ){
        let service = APIService()
        service.endPoint = Endpoints.TAG_USER_CONTACTS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=0"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        
                            do {
                                let feedTagLoad = FeedTagListsDB()
                                let data1 =  try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                                //print(convertedString ?? "defaultvalue")
                                feedTagLoad.feedString = convertedString!
                                //print("Feeds JSON String : \(feedTagLoad.feedString)")
                                DispatchQueue.main.async {
                                    try! uiRealm.write {
                                        uiRealm.add(feedTagLoad)
                                    }
                                }
                            } catch let myJSONError {
                                print(myJSONError)
                            }
                        
                        
                        if let AddContactsData = dict["addContactsData"] as? [[String:AnyObject]]{
                            var data = [Mention]()
                            for obj in AddContactsData{
                                let item = Mention(Dict:obj)
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
    static func getMentionsV2(pageLoad:Int , searchText: String, completion: @escaping (([Mention]?) -> ()) ){
        let service = APIService()
        service.endPoint = Endpoints.TAG_USER_LIST_V2
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=\(pageLoad)&searchText=\(searchText)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        if let AddContactsData = dict["addContactsData"] as? [[String:AnyObject]]{
                            var data = [Mention]()
                            for obj in AddContactsData{
                                let item = Mention(Dict:obj)
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
}

