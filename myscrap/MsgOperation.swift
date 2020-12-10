 //
//  MsgOperation.swift
//  myscrap
//
//  Created by MyScrap on 5/16/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
import CoreData

class MessageOperation{
    
    
    var isLoading = false
    
    func activeUsers(_ completion : @escaping ([ActiveUsers]? , String? ) -> () ){
        let service = APIService()
        service.endPoint = Endpoints.ACTIVE_FRIENDS_URL
        print("User JID in Msg operation: \(AuthService.instance.userJID!)")
        service.params = "userjid=\(AuthService.instance.userJID!)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let datas = dict["activeUserData"] as? [[String: AnyObject]]{
                    var members = [ActiveUsers]()
                    for data in datas{
                        let member = ActiveUsers(dict: data)
                        members.append(member)
                    }
                    completion(members, nil)
                } else {
                    completion(nil, "No Data")
                }
            case .Error(let error):
                print(error)
            }
        }
    }
    
    func updateChatHistoryMessages(msgId: String, body: String, member: Member,isSender: Bool, date: Date, moc: NSManagedObjectContext){
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "msgId =%@", msgId)
        do {
            
            if let message = try moc.fetch(fetchRequest).first{
                if let msgDate = message.date, msgDate > date {
                    message.date = msgDate
                }
            } else {
                let newmsg = Message(context: moc)
                newmsg.date = date
                newmsg.text = body
                newmsg.msgId = msgId
                newmsg.isSender = isSender
                print(member.name)
                
                newmsg.member = member
            }
            
            do {
                try moc.save()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func loadChatList(with container: NSPersistentContainer){
        if isLoading{ return }
        isLoading = true
        let service = APIService()
        service.endPoint = Endpoints.CHATROOMS_URL
        guard let jid = AuthService.instance.userJID else { return }
        service.params = "apiKey=\(API_KEY)&jId=\(jid)@\(XMPPLoginManager.default.domain)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                container.performBackgroundTask({ (contexts) in
                    contexts.perform({
                        self.handleBackgroundMessage(with: contexts, dict: dict)
                        do {
                            try contexts.save()
                            NotificationCenter.default.post(name: Notification.Name.chatHistoryCompleted, object: nil)
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                })
            case .Error(let error):
                self.isLoading = false
                print(error)
            }
        }
    }
    
   
    
    private func handleBackgroundMessage(with moc: NSManagedObjectContext,dict: [String: AnyObject] ){
            isLoading   = false
            if let chatRoomData = dict["chatRoomData"] as? [[String:AnyObject]]{
                for data in chatRoomData{
                    self.performChatData(with: data, backgroundContext: moc)
                    if let lastMessages = data["data"] as? [[String: AnyObject]]{
                        for message in lastMessages{
                            self.performChatData(with: message, backgroundContext: moc)
                        }
                    }
                }
            }
        
       
    }
    
    private func performChatData(with data: [String: AnyObject], backgroundContext: NSManagedObjectContext ){
        if let chatRoomId = data["chat_room_id"] as? String,
            let profilePic = data["profilePic"] as? String,
            let name = data["name"] as? String,
            let body = data["lastMessage"] as? String,
            let colorCode = data["colorCode"] as? String,
            let zero = data["msgId"] as? [String: AnyObject],
            let msgId = zero["0"] as? String,
            let userId = data["userId"] as? String,
            let isSender = data["isSender"] as? Bool,
            let createdat = data["created_at"] as? String,
            let integerDate = Int(createdat) {
            var idate = integerDate
            if createdat.count > 10 {
                idate = integerDate / 1000
            }
            let doubleDate = Double(idate)
            let date = Date(timeIntervalSince1970: doubleDate)
            
            let truncindex = chatRoomId.index(chatRoomId.endIndex, offsetBy: -34)
            let jid = String(chatRoomId[..<truncindex])

            
            var member : Member?
            let message = MessageOperation()
            let mem = MemberOperation()
            if message.isMessageExists(msgId: msgId, context: backgroundContext){
//                message.updateMessage(msgId: msgId, text: body, date: date, cont: backgroundContext)
//                print("Message Exists with id :- \(msgId)")
            } else {
                if mem.isMemberExists(with: jid, context: backgroundContext){
                    member = mem.getMember(with: jid, moc: backgroundContext)
                } else {
                    member = mem.createNewMember(userid: userId, jid: jid, profilePic: profilePic, colorCode: colorCode, name: name, context: backgroundContext)
                }
                if let membs = member{
                    message.insertMessage(text: body, member: membs, context: backgroundContext, msgId: msgId, isSender: isSender, date: date)
                }
            }
        }
    }
    
    
    
    
    
    func loadData(completion: @escaping ([Message]) -> () ){
        
        DispatchQueue.main.async {
            let app = UIApplication.shared.delegate as! AppDelegate
            let moc = app.persistentContainer.viewContext
            if let members = self.fetchFriends(with: moc) {
                var msgs = [Message]()
                for member in members{
                    let request: NSFetchRequest<Message> = Message.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    request.predicate = NSPredicate(format: "member.jid = %@", member.jid!)
//                    request.resultType = NSFetchRequestResultType.dictionaryResultType
                    request.fetchLimit = 1
                    do {
                        let fetchedMessages = try(moc.fetch(request))
                        if let message = fetchedMessages.first{
                            msgs.append(message)
                        }
    
                    } catch let err{
                        print(err)
                    }
                }
                completion(msgs.sorted(by: { $0.date!.compare($1.date!) == .orderedDescending }))
            }
        }
    }
    
    
    private func fetchFriends(with moc: NSManagedObjectContext) -> [Member]? {
            let request: NSFetchRequest<Member> = Member.fetchRequest()
            do {
                let results = try moc.fetch(request)
                return results
            } catch let err {
                print(err)
            }
        return nil
    }
    
    
    func insertMessage(text:String, member: Member  , context: NSManagedObjectContext,msgId:String, isSender:Bool, date: Date){
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        
        message.member = member
        message.text = text
        message.date = date
        message.isSender = isSender
        message.msgId = msgId
        message.status = "0"
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
    
    func updtMessage(msgId:String, member:Member, text: String, isSender: Bool, date: Date, moc: NSManagedObjectContext){
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "msgId = %@", msgId)
        do {
            if let _ = try moc.fetch(fetchRequest).first{
                
            } else {
                insertMessage(text: text, member: member, context: moc, msgId: msgId, isSender: isSender, date: date)
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
    }
    
    func updateMessage(msgId: String,text: String, date: Date,cont: NSManagedObjectContext){
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "msgId = %@", msgId)
        fetchRequest.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try cont.fetch(fetchRequest)
            if let message = results.first as? Message{
                message.text = text
                message.date = date
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
    
    typealias result = (_ online: Bool, _ time: String, _ designation: String, _ company: String, _ country: String, _ compnayId: String) -> ()
    typealias onlineStatus = (_ onlineStat: [String : AnyObject]) -> ()
    
    func checkOnline(id: String, completion: @escaping  onlineStatus){
        let service = APIService()
        service.endPoint = Endpoints.USER_ONLINE_STATUS_URL
        service.params = "friendsUserId=\(id)&apiKey=\(API_KEY)"
        print(service.endPoint)
        print(service.params)
        service.getDataWith { /* [weak self] */ (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        
                        var userOnline = ""
                        if let online = dict["onlineStatusInMili"] as? Int{
                            
                            userOnline = "\(online)"
                        }
//                            if online == 1 {
//                                userOnline = "Online"
//                            } else {
//                                //last seen
//                                let date = Date(milliseconds: online)
//                                let dateFormatter = DateFormatter()
//                                let calendar = Calendar.current
//
//                                if calendar.isDateInToday(date){
//                                    dateFormatter.dateFormat = "hh:mm a"
//                                    userOnline = "last seen today at " + dateFormatter.string(from: date)
//                                } else if calendar.isDateInYesterday(date){
//                                    dateFormatter.dateFormat = "hh:mm a"
//                                    userOnline = "last seen yesterday at " + dateFormatter.string(from: date)
//                                } else if (calendar.locale?.calendar.isDateInWeekend(date))! {
//                                    dateFormatter.dateFormat = "hh:mm a"
//                                    let day = date.dayOfWeek(date: date)
//                                    userOnline = "last seen " + day! + " at " + dateFormatter.string(from: date)
//                                }
//                                else {
//                                    dateFormatter.dateFormat = "dd/MM/yyyy"
//                                    let time = date.splitDateTime()
//                                    userOnline = "last seen " + dateFormatter.string(from: date) + " at " + time!
//                                }
//                            }
//                        }
                        completion(dict)
                    }
                }
            case .Error(_):
                print("Error")
            }
        }
    }
    
    func updateNewMessage(msgId:String,text:String, member: Member  , moc: NSManagedObjectContext, isSender:Bool ,type: String,status: String, date: Date) -> Message? {
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "msgId = %@", msgId)
        fetchRequest.fetchLimit = 1
        
        do {
            if let message = try moc.fetch(fetchRequest).first{
                return message
            } else {
               let msg = Message(context: moc)
                msg.member = member
                msg.text = text
                msg.date = date
                msg.isSender = isSender
                msg.msgId = msgId
                msg.status = status
                msg.messageType = type
                member.lastMessage = msg
                
                do {
                    try moc.save()
                    return msg
                }
            }
            
            
        } catch{
            print("Error Happened")
            return nil
        }
    }
}
 extension Date {
    func dayOfWeek(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
        //return dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)]
    }
    
    func splitDateTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
 }
