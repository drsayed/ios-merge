//
//  Message-Ext.swift
//  myscrap
//
//  Created by MS1 on 11/9/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications


extension Message{
    
    static var defaultDescriptors : [NSSortDescriptor]{
        return [NSSortDescriptor(key: "date", ascending: true)]
    }
    
    
    func loadData(completion: @escaping ([Message]) -> () ){
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        if let members = fetchFriends() {
            var msgs = [Message]()
            for member in members{
                let request: NSFetchRequest<Message> = Message.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                request.predicate = NSPredicate(format: "member.id = %@", member.id!)
                request.fetchLimit = 1
                do {
                    let fetchedMessages = try(context.fetch(request))
                    
                    print(fetchedMessages.count)
                    
                    if !fetchedMessages.isEmpty{
                        msgs.append(fetchedMessages[0])
                    }
                } catch let err{
                    print(err)
                }
            }
            completion(msgs.sorted(by: { $0.date!.compare($1.date!) == .orderedDescending }))
        }
    }
    
    
    private func fetchFriends() -> [Member]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext{
            let request: NSFetchRequest<Member> = Member.fetchRequest()
            do {
                return try context.fetch(request)
            } catch let err {
                print(err)
            }
        }
        return nil
    }
    
    
    func insertMessage(text:String, member: Member  , context: NSManagedObjectContext,msgId:String, isSender:Bool, date: Date){
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        
        print("modaa insert")
        print(message.text ?? "hello" )
        
        message.member = member
        message.text = text
        message.date = date
        message.isSender = isSender
        message.msgId = msgId
        message.status = "1"
//        message.imageURL = imageURL
        message.messageType = "1"
        do {
            try context.save()
        } catch let err{
            print(err.localizedDescription)
        }
    }
    
    
    
    
    
    func insertNewMessage(text:String, member: Member  , context: NSManagedObjectContext,msgId:String, isSender:Bool ,type: String, imageURL:String, status: String, date: Date){
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        
        
        message.member = member
        message.text = text
        message.date = date
        message.isSender = isSender
        message.msgId = msgId
        message.status = status
        message.imageURL = imageURL
        message.messageType = type
        do {
            try context.save()
            /*
            DispatchQueue.main.async {
                let content = UNMutableNotificationContent()
                let center = UNUserNotificationCenter.current()
                content.title = "\(member.name ?? "") send a new Message."
                content.body = "\(text)"
                content.sound = .default()
                let identifier = msgId
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            } */
        } catch let err{
            print(err.localizedDescription)
        }
    }
    
    func updateMessage(msgId: String,text: String, status: String, imageURL: String,cont: NSManagedObjectContext){
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "msgId = %@", msgId)
        fetchRequest.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try cont.fetch(fetchRequest)
            if let message = results.first as? Message{
                if message.status != "3"{
                    message.status = status
                }
                message.text = text
                message.imageURL = imageURL
                do {
                    try cont.save()
                } catch let err{
                    print("\(err.localizedDescription)")
                }
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
    }
    
    func isMessageExists(msgId: String, context: NSManagedObjectContext) -> Bool{
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "msgId = %@", msgId)
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    
 
    /*
    // MARK:- HANDLE FRIEND MESSAGE
    func handleFriendMessage(dict: [String: AnyObject], moc: NSManagedObjectContext){
        let memberObject = Member()
        print("Friend Message Received", dict)
        guard let colorcode = dict["color"] as? String,
            let fromid = dict["fromid"] as? String ,
            let msgId = dict["msgId"] as? String ,
            let chatProfile = dict["chatProfile"] as? String,
            let userName = dict["userName"] as? String,
            let chatName = dict["chatName"] as? String,
            let userid = dict["userid"] as? String,
            let time = dict["time"] as? String,
            let type = dict["type"] as? String,
            let userDP = dict["userDP"] as? String,
            let timeStamp = dict["msgTime"] as? String else { return }
        var message = ""
        var imageURL = ""
        if let msg = dict["message"] as? String{
            message = msg
        }
        if let img = dict["image"] as? String{
            imageURL = img
        }
        if let integerDate = Int(timeStamp){
            var date = integerDate
            if timeStamp.count > 10{
                date = integerDate/1000
            }
            var member: Member?
            
            if memberObject.isMemberExists(with: fromid, context: moc){
                member = memberObject.getMember(id: fromid, moc: moc)
            } else {
                member = memberObject.createNewMember(userid: "", jid: fromid, profilePic: chatProfile, colorCode: colorcode, name: chatName, context: moc)
            }
            if let mem = member{
                insertNewMessage(text: message, member: mem, context: moc, msgId: msgId, isSender: false, type: type, imageURL: imageURL, status: "1", date: Date(timeIntervalSince1970: TimeInterval(date)))
            }
        }
    }
 
 
 */
    
//    // MARK:- HANDLE MY MESSAGE
//    func handleMyMessage(dict : [String: AnyObject], moc: NSManagedObjectContext){
//        let memberObject = Member()
//        print("Handling My Message" ,dict)
//        guard let colorcode = dict["color"] as? String,
//            let fromid = dict["fromid"] as? String ,
//            let msgId = dict["msgId"] as? String,
//            let chatProfile = dict["chatProfile"] as? String,
//            let userName = dict["userName"] as? String,
//            let chatName = dict["chatName"] as? String,
//            let userid = dict["userid"] as? String,
//            let time = dict["time"] as? String,
//            let type = dict["type"] as? String,
//            let userDP = dict["userDP"] as? String,
//            let timeStamp = dict["msgTime"] as? String else { return }
//        var message = ""
//        var imageURL = ""
//        if let msg = dict["message"] as? String{
//            message = msg
//        }
//        if let img = dict["image"] as? String{
//            imageURL = img
//        }
//
//        if let integerDate = Int(timeStamp){
//            var date = integerDate
//            if timeStamp.count > 10{
//                date = integerDate/1000
//            }
//            var member : Member?
//            if memberObject.isMemberExists(with: userid, context: moc) {
//                member = memberObject.getMember(id: userid, moc: moc)
//            } else {
//                member = memberObject.createNewMember(userid: " ", jid: userid, profilePic: userDP, colorCode: colorcode, name: userName, context: moc)
//            }
//            if let mem = member{
//                insertNewMessage(text: message, member: mem, context: moc, msgId: "\(msgId)", isSender: true, type: type , imageURL: imageURL, status: "1", date: Date(timeIntervalSince1970: TimeInterval(date)))
//            }
//        }
//    }
    
    typealias completionHandler = (Bool) -> ()
    
    /*
    
    func getUndeliveredMessages(moc: NSManagedObjectContext , completion: @escaping completionHandler){
        let memberObject = Member()
        let api = APIService()
        api.endPoint = Endpoints.MS_CONNECTED_URL
        api.params = "from=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        api.getDataWith { result in
            switch result{
            case .Success(let dict):
                DispatchQueue.main.async {
                    
                    let center = UNUserNotificationCenter.current()
                    if let connectData = dict["connectData"] as? [[String:AnyObject]]{
                        for data in connectData{
                            var text  = ""
                            var imageURL = ""
                            var type = ""
                            var title = ""
                            
                            
                            if let userId = data["userid"] as? String,
                                let fromId = data["fromid"] as? String,
                                let messageId = data["messageId"] as? String,
                                let timeStamp  = data["timeStamp"] as? String,
                                let userName = data["userName"] as? String,
                                let userDp = data["userDP"] as? String,
                                let colorCode = data["colorCode"] as? String,
                                let messageType = data["messageType"] as? String{
                                
                                if let message = data["message"] as? String{
                                    text = message
                                }
                                
                                if let messageChat = data["messageChat"] as? String{
                                    imageURL = messageChat
                                }
                                
                                let integerDate = Int(timeStamp)!
                                var date = integerDate
                                if timeStamp.count > 10{
                                    date = integerDate/1000
                                }
                                
                                type = messageType
                                print("message Type is " ,type)
                                
                                let msg = Message()
                                if  !msg.isMessageExists(msgId: messageId, context: moc){
                                    let content = UNMutableNotificationContent()
                                    content.title = userName
                                    if type == "1"{
                                        content.body = text
                                    } else {
                                        content.body = "image"
                                    }
                                    
                                    content.sound = UNNotificationSound.default()
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                    let request = UNNotificationRequest(identifier: messageId, content: content, trigger: trigger)
                                    center.add(request, withCompletionHandler: { (error) in
                                        guard error == nil else { return }
                                        var member : Member?
                                        let memberObject = Member()
                                        if memberObject.isMemberExists(with: fromId, context: moc){
                                            member = memberObject.getMember(id: fromId, moc: moc)
                                        } else {
                                            member = memberObject.createNewMember(userid: "", jid: fromId, profilePic: userDp, colorCode: colorCode, name: userName, context: moc)
                                        }
                                        if let mem = member{
                                            self.insertNewMessage(text: text, member: mem, context: moc, msgId: messageId, isSender: false, type: type, imageURL: imageURL, status: "2", date: Date(timeIntervalSince1970: TimeInterval(date)))
                                        }
                                    })
                                }
                            } else {
                                completion(false)
                            }
                            
                            completion(false)
                        }
                        
                    }
                    
                    
                    
                }
            case .Error(let error):
                print(error)
                completion(false)
            }
        }
    }
                    
    */
            
            
            
            /*
             
             if let error = dict["error"] as? Bool{
             if !error{
             if let connectData = dict["connectData"] as? [[String:AnyObject]]{
             DispatchQueue.main.async {
             for data in connectData{
             
             var text  = ""
             var imageURL = ""
             var type = ""
             
             let center = UNUserNotificationCenter.current()
             if let userId = data["userid"] as? String,
             let fromId = dict["fromid"] as? String,
             let messageId = data["messageId"] as? String,
             let timeStamp  = dict["timeStamp"] as? String,
             let userName = data["userName"] as? String,
             let userDp = data["userDP"] as? String,
             let colorCode = data["colorCode"] as? String,
             let messageType = data["messageType"] as? String{
             
             type = messageType
             if let message = data["message"] as? String{
             text = message
             }
             if let imgurl = data["messageChat"] as? String{
             imageURL = imgurl
             }
             if fromId != AuthService.instance.userId {
     
     
     
             if !self.isMessageExists(msgId: messageId, context: moc){
             if let mem = member {
             let content = UNMutableNotificationContent()
             content.title =  userName
             if messageType == "1" {
             content.body = text
             } else {
             content.body = "Image"
             }
             content.sound = .default()
             
             let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
             let request = UNNotificationRequest(identifier: messageId, content: content, trigger: trigger)
             center.add(request, withCompletionHandler: { (error) in
             guard let _ = error else {
     
     
             print("process Coredata for messageID \(messageId)")
             return
             }
             completion(false)
             })
             }
             }
             }
             }
             }
             }
             }
             
             }
             else {
             completion(true)
             }
             }
             completion(true)
             }
             completion(false)  */
            

    
    private func processUndeliveredMessages(dict: [String:AnyObject]){
        
    }
    
    
    /*
    func getLastMessages(moc: NSManagedObjectContext){
        let api = APIService()
        api.endPoint = Endpoints.MESSAGECHATROOM_URL
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                self.handleDataInBackground(dict: dict, moc: moc, dictName: "chatRoomData")
            case .Error(let error):
                print(error)
            }
        }
    }  */
    
    
    /*
    
    private func handleDataInBackground(dict: [String:AnyObject], moc: NSManagedObjectContext, dictName: String){
        let memberObject = Member()
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = moc
        backgroundContext.perform {
            if let error = dict["error"] as? Bool{
                if !error{
                    if let chatRoomData = dict[dictName] as? [[String:AnyObject]]{
                        for obj in chatRoomData{
                            guard let memberId = obj["chat_room_id"] as? String else { return }
                            guard let profilePic = obj["profilePic"] as? String else { return }
                            guard let name = obj["name"] as? String else { return }
                            guard let colorCode = obj["colorCode"] as? String else { return }
                            
                            var member:Member?
                            if memberObject.isMemberExists(with: memberId, context: backgroundContext){
                                member = memberObject.getMember(id: memberId, moc: backgroundContext)
                            } else {
                                member = memberObject.createNewMember(userid: " ", jid: memberId, profilePic: profilePic, colorCode: colorCode, name: name, context: backgroundContext)
                            }
                            if let chats = obj["data"] as? [[String:AnyObject]]{
                                for chat in chats{
                                    
                                    var text  = ""
                                    var imageURL = ""
                                    var type = ""
                                    guard let msgId = chat["id"] as? String else { return }
                                    print("MessageId Crash", msgId )
                                    guard let fromId = chat["msg_from_id"] as? String else { return }
                                    // guard let toId = chat["msg_to_id"] as? String else { return }
                                    if let txt = chat["message"] as? String  { text = txt }
                                    if let imgURL = chat["messageChat"] as? String { imageURL = imgURL}
                                    guard let status = chat["status"] as? String else { return }
                                    guard let timeStamp = chat["sent"] as? String else { return }
                                    guard let msgType = chat["messageType"] as? String else { return }
                                    type = String(msgType)
                                    print("Message Type",type)
                                    print("image URL" , imageURL)
                                    if let mem = member{
                                        var isSender = false
                                        if fromId == AuthService.instance.userId{
                                            isSender = true
                                        }
                                        if self.isMessageExists(msgId: msgId, context: backgroundContext){
                                            self.updateMessage(msgId: msgId, text: text, status: status, imageURL: imageURL, cont: backgroundContext)
                                        } else {
                                            if let integerDate = Int(timeStamp){
                                                var date = integerDate
                                                if timeStamp.count > 10{
                                                    date = integerDate/1000
                                                }
                                                self.insertNewMessage(text: text, member: mem, context: backgroundContext, msgId: msgId, isSender: isSender, type: type, imageURL: imageURL, status: status, date: Date(timeIntervalSince1970: TimeInterval(date)))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            moc.performAndWait {
                try? context.save()
            }
        }
    } 
    
    */
    func setReceivedMessagestoSeen(moc: NSManagedObjectContext, memberId: String) -> [Message]? {
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "member.id = %@", memberId)
        fetchRequest.predicate = NSPredicate(format: "NOT (status CONTAINS %@)", "3")
        fetchRequest.predicate = NSPredicate(format: "isSender = %@", NSNumber(value: false))
        var results : [NSManagedObject] = []
        do {
            results = try moc.fetch(fetchRequest)
            return results as? [Message]
        }
        catch {
            print("Error executing fetch Request: \(error)")
        }
        return nil
    }
}








