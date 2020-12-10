//
//  RoasterHistory.swift
//  myscrap
//
//  Created by MyScrap on 4/21/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

/*First time while login the app this api get called
 Get data from API and stores into Realm DB */

import Foundation
import RealmSwift


protocol RoasterServiceDelegate: class {
    func DidReceivedData(data: [RoasterItems])
    func DidReceivedError(error: String)
}

class RoasterHistory{
    
    lazy var client : APIClient = {
        let client = APIClient()
        return client
    }()
    
    lazy var service : APIService = {
        return APIService()
    }()
    
    weak var delegate : RoasterServiceDelegate?
    
    
   
    
    func getRoasterHistory() {
        let service = APIService()
        service.endPoint = Endpoints.GET_ROASTER
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                
                if let error = dict["error"] as? Bool{
                    let status = dict["status"] as? String
                    if !error{
                        if let myListingData = dict["data"] as? [[String:AnyObject]]{
                            
                            //let writeQueue = DispatchQueue(label: "background", qos: .background, attributes: [.concurrent])
                            //writeQueue.async {
                                //let startTime = CFAbsoluteTimeGetCurrent()
                                //autoreleasepool {
                                    //var realmBatches = [UserPrivChat]()
                                    //let realm = try! Realm()
                                    
                                    //print(realm.configuration.fileURL!)
                                    
                                    var myListings = [RoasterItems]()
                                    
                                    for obj in myListingData{
                                        let myItems = RoasterItems(Dict: obj)
                                        myListings.append(myItems)
                                    }
                                    self?.delegate?.DidReceivedData(data: myListings)
                                                           //let roastChat = UserPrivChat.create()
                                                           
                                                   
                                    //}
                                    
                                ///}
                                
                            //}
                            
                            /*var myListings = [RoasterItems]()
                for obj in myListingData{
                            let myItems = RoasterItems(Dict: obj)
                            myListings.append(myItems)
                            //print("Handle Json : \(obj)")
                            
                            
                            // Storing Roaster history into DB
                            let writeQueue = DispatchQueue(label: "background", qos: .background, attributes: [.concurrent])
                            writeQueue.async {
                                let startTime = CFAbsoluteTimeGetCurrent()
                                autoreleasepool {
                                        let roastChat = UserPrivChat.create()
                                    var taskId =  roastChat.key_id
                                        //Market Message fetch
                                        //Converting String to JSON
                                        var type = ""
                                        var title = ""
                                        var rate = ""
                                        var listingId = ""
                                                
                                        if myItems.stanzaType == "marketAdv" {
                                            let jsonString = myItems.body
                                            let jsondata = jsonString.data(using: .utf8)!
                                            do {
                                                if let jsonArray = try JSONSerialization.jsonObject(with: jsondata, options : .allowFragments) as? [String:String] {
                                                    //print("Converted json string",jsonArray) // use the json here
                                                    if let recType = jsonArray["type"] {
                                                        if recType == "0" || recType == "SELL" {
                                                            type = "SELL"
                                                        } else if recType == "1" || recType == "BUY"{
                                                            type = "BUY"
                                                        }
                                                    }
                                                    if let recTitle = jsonArray["title"]{
                                                        title = recTitle
                                                    }
                                                    if let recRate = jsonArray["rate"]{
                                                        rate = recRate
                                                    }
                                                    if let recListingID = jsonArray["listingId"] {
                                                        listingId = recListingID
                                                    }
                                                } /*else {
                        print("bad json")
                        }*/
                                            } catch let error as NSError {
                                                print(error)
                                            }
                                        }
                                        //let roastChat = UserPrivChat.create()
                                        var userJID = ""
                                        if AuthService.instance.userJID!.contains("@myscrap.com") {
                                            userJID = AuthService.instance.userJID!
                                        } else {
                                            userJID = AuthService.instance.userJID! + "@myscrap.com"
                                        }
                                        //print("FromJID :\(myItems.fromJID) , ToJID : \(myItems.toJID)")
                                        if myItems.fromJID == userJID  || myItems.toJID == userJID {
                                            if myItems.fromId == AuthService.instance.userId {
                                                //Message sent by me
                                                roastChat.conversationId = myItems.fromId + myItems.userId
                                                roastChat.fromJID = myItems.fromJID
                                                roastChat.toJID = myItems.toJID
                                                roastChat.body = myItems.body
                                                roastChat.stanza = myItems.stanza
                                                roastChat.fromUserId = myItems.fromId
                                                roastChat.toUserId = myItems.userId
                                                roastChat.fromImageUrl = myItems.fImage
                                                roastChat.toImageUrl = myItems.uImage
                                                roastChat.fromUserName = myItems.fName
                                                roastChat.toUserName = myItems.uName
                                                roastChat.fromColorCode = myItems.fColor
                                                roastChat.toColorCode = myItems.uColor
                                                roastChat.messageType = myItems.type
                                                // Updated with previous commented line to get the actual sender and receiver time
                                                if myItems.sentReceiveTimeStamp != "" {
                                                    roastChat.timeStamp = myItems.sentReceiveTimeStamp
                                                    let intTimeStamp = Int64(myItems.sentReceiveTimeStamp)
                                                    if intTimeStamp != nil {
                                                        // get the current date and time
                                                        let currentDateTime = Date(milliseconds: intTimeStamp!)
                                                        // initialize the date formatter and set the style
                                                        let formatter = DateFormatter()
                                                        //formatter.timeZone = TimeZone(abbreviation: "GMT")
                                                        //formatter.dateFormat = "dd-MMM, HH:mm"        //24 hrs
                                                        formatter.dateFormat = "dd-MMM, h:mm a"     //12 hrs
                                                        roastChat.time = formatter.string(from: currentDateTime)
                                                    } else {
                                                        print("Timestamp can't convert to INT64 because it's not in correct format")
                                                    }
                                                } else {
                                                    roastChat.timeStamp = myItems.messageTimeMM
                                                    roastChat.time = myItems.messageTime
                                                }
                                                roastChat.readCount = 1
                                                roastChat.stanzaType = myItems.stanzaType
                                                roastChat.marketUrl = myItems.marketUrl
                                                roastChat.type = type
                                                roastChat.title = title
                                                roastChat.rate = ""
                                                roastChat.listingId = listingId
                                                roastChat.msgStatus = "received"
                                                let tempTask = taskId// get task from Realm based on taskId
                                                uiRealm.beginWrite()
                                                let objectsToDelete = uiRealm.objects(UserPrivChat.self).filter("key_id IN %@", tempTask)
                                                uiRealm.delete(objectsToDelete)
                                                try! uiRealm.write {
                                                    //Roaster history added to UserPrivChat table in realm
                                                    uiRealm.add(roastChat)
                                                    //print("Roasted chat history : \(roastChat)")
                                                }
                                                do {
                                                    try uiRealm.commitWrite()
                                                } catch {
                                                    print("Catch error exeption in roaster")
                                                }
                                                
                                            } else if myItems.userId == AuthService.instance.userId {
                                                //Message received to me
                                                roastChat.conversationId = myItems.userId + myItems.fromId
                                                roastChat.fromJID = myItems.fromJID
                                                roastChat.toJID = myItems.toJID
                                                roastChat.body = myItems.body
                                                roastChat.stanza = myItems.stanza
                                                roastChat.fromUserId = myItems.fromId
                                                roastChat.toUserId = myItems.userId
                                                roastChat.fromImageUrl = myItems.fImage
                                                roastChat.toImageUrl = myItems.uImage
                                                roastChat.fromUserName = myItems.fName
                                                roastChat.toUserName = myItems.uName
                                                roastChat.fromColorCode = myItems.fColor
                                                roastChat.toColorCode = myItems.uColor
                                                roastChat.messageType = myItems.type
                                                // Updated with previous commented line to get the actual sender and receiver time
                                                if myItems.sentReceiveTimeStamp != "" {
                                                    roastChat.timeStamp = myItems.sentReceiveTimeStamp
                                                    let intTimeStamp = Int64(myItems.sentReceiveTimeStamp)
                                                    if intTimeStamp != nil {
                                                        // get the current date and time
                                                        let currentDateTime = Date(milliseconds: intTimeStamp!)
                                                        // initialize the date formatter and set the style
                                                        let formatter = DateFormatter()
                                                        //formatter.timeZone = TimeZone(abbreviation: "GMT")
                                                        //formatter.dateFormat = "dd-MMM, HH:mm"        //24 hrs
                                                        formatter.dateFormat = "dd-MMM, h:mm a"     //12 hrs
                                                        roastChat.time = formatter.string(from: currentDateTime)
                                                    } else {
                                                        print("Timestamp can't convert to INT64 because it's not in correct format")
                                                    }
                                                } else {
                                                    roastChat.timeStamp = myItems.messageTimeMM
                                                    roastChat.time = myItems.messageTime
                                                }
                                                roastChat.readCount = 1
                                                roastChat.stanzaType = myItems.stanzaType
                                                roastChat.marketUrl = myItems.marketUrl
                                                roastChat.type = type
                                                roastChat.title = title
                                                roastChat.rate = ""
                                                roastChat.listingId = listingId
                                                let tempTask = taskId// get task from Realm based on taskId
                                                uiRealm.beginWrite()
                                                let objectsToDelete = uiRealm.objects(UserPrivChat.self).filter("key_id IN %@", tempTask)
                                                uiRealm.delete(objectsToDelete)
                                                try! uiRealm.write {
                                                    //Roaster history added to UserPrivChat table in realm
                                                    uiRealm.add(roastChat)
                                                    //print("Roasted chat history : \(roastChat)")
                                                }
                                                do {
                                                    try uiRealm.commitWrite()
                                                } catch {
                                                    print("Catch error exeption in roaster")
                                                }
                                            } else if myItems.toJID == "livechatdiscussion@conference.myscrap.com" {
                                                // Chance for livechat as ToJID
                                                print("This will not handle in DB because TOJID is live chat")
                                                //For storing Livechat to DB
                                            } else if myItems.stanza.contains("/Spark ") {
                                                print("Message from spark user")
                                            } /*else {
                        print("Some weird thing happened in db")
                        }*/
                                            } else {
                                                print("This will not handle in DB because user JID is not me")
                                            }
                                }
                                print("Background Thread Time \(CFAbsoluteTimeGetCurrent() - startTime)")
                            }
                            //DispatchQueue.main.async {
                            
                            //}
                        }*/
//     here                       delegate?.DidReceivedData(data: myListings)
                        }
                        
                    } else {
                        print("Fetch Roaster history error : \(error)")
                        self?.delegate?.DidReceivedError(error: status!)
                    }
                }
                //self?.handleJson(dict: dict)
            case .Error(let error):
                print("Fetch Roaster history error : \(error)")
                //self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    //MARK:- GET MARKET JSON
    private func handleJson(dict: [String:AnyObject]){
        
    }
}
extension Realm {
    func writeAsync<T : ThreadConfined>(obj: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
        let wrappedObj = ThreadSafeReference(to: obj)
        let config = self.configuration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: config)
                    let obj = realm.resolve(wrappedObj)
                    
                    try realm.write {
                        block(realm, obj)
                    }
                }
                catch {
                    errorHandler(error)
                }
            }
        }
    }
}
