//
//  SocketService.swift
//  myscrap
//
//  Created by MS1 on 5/24/17.
//  Copyright © 2017 sayedmetal. All rights reserved.
//

import UIKit
import SocketIO
import CoreData
import UserNotifications

final class SocketService: NSObject {

    static let instance = SocketService()
    
    let manager = SocketManager(socketURL: URL(string: "https://myscrap.com:30109/")!, config: [.log(true), .compress])
  
    // Objects
    private let memberObject = Member()
    private let msg = Message()
    
    private let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    private enum MessageType{
        case image
        case text
    }
    
    override init() {
        super.init()
    }
    
    
    func establishConnection(){
        
        manager.defaultSocket.on(clientEvent: .connect) { (data, ack) in
            print("***/n Socket Connected /n****")
            // ADDING HANDLERS
            let dict = [SocketParams.username: AuthService.instance.userId]
            self.manager.defaultSocket.emit(SocketEvents.ADD_USER, dict)
            self.addHandlers()
        }
        
        manager.defaultSocket.on(clientEvent: .disconnect) { (data, ack) in
            self.manager.defaultSocket.removeAllHandlers()
        }
        
        manager.defaultSocket.on(clientEvent: .reconnect) { (data, ack) in
            print("***/n Socket Connected /n****")
            // ADDING HANDLERS
            let dict = [SocketParams.username: AuthService.instance.userId]
            self.manager.defaultSocket.emit(SocketEvents.ADD_USER, dict)
            self.addHandlers()
        }
        
        
        manager.defaultSocket.connect()
    }
    
    
    func reconnectConnection(){
        let dict = ["ping":"pong"]
        manager.defaultSocket.emit("pingpong", dict)
    }
    
    
    
    func closeConnection(){
        manager.defaultSocket.disconnect()
    }
    
    
    // ADD SOCKET HANDLERS
    private func addHandlers(){
        // MY MESSAGE
        manager.defaultSocket.on(SocketEvents.MY_MESSAGE) { [weak self] (data, ack) in
            if let dict = data[0] as? [String: AnyObject] {
                self?.msg.handleMyMessage(dict: dict, moc: (self?.moc)!)
                print("mymessage added")
            }
        }
        
        // FRIEND MESSAGE
        manager.defaultSocket.on(SocketEvents.FRIEND_MESSAGE) { [weak self](data, ack) in
            if let dict = data[0] as? [String: AnyObject]{
                self?.msg.handleFriendMessage(dict: dict, moc: (self?.moc)!)
                print("friendMessage added")
            }
        }
        
        manager.defaultSocket.on(SocketEvents.MESSAGE_DELIVERED) {[weak self] (data, ack) in
            if let dict = data[0] as? [String: AnyObject] {
                self?.handleDeliveredMessage(dict: dict)
                print("delivered message added")
            }
        }
        
        manager.defaultSocket.on(SocketEvents.MESSAGE_SEEN) { [weak self] (data, ack) in
            if let dict = data[0] as? [String: AnyObject]{
                self?.handleSeenMessage(dict: dict)
            }
        }
    }
    
  
    

    
    private func listenforOtherMessages(){
        manager.defaultSocket.on(SocketEvents.START_TYPING) { [weak self] (data, ack) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .startTyping, object: data[0] as! [String:AnyObject])
            }
        }
        manager.defaultSocket.on(SocketEvents.STOP_TYPING) { [weak self] (data, ack) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .stopTyping, object: data[0] as! [String:AnyObject])
            }
        }
        manager.defaultSocket.on(SocketEvents.USER_ONLINE) { [weak self] (data, ack) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .userOnline, object: data[0] as! [String: AnyObject])
            }
        }
        manager.defaultSocket.on(SocketEvents.MESSAGE_SEEN) { [weak self] (data, ack) in
            DispatchQueue.main.async {
                if let dict = data[0] as? [String:AnyObject] {
                    self?.handleSeenMessage(dict: dict)
                }
            }
        }
        self.manager.defaultSocket.on(SocketEvents.MESSAGE_DELIVERED, callback: { [weak self] (data, ack) in
            NotificationCenter.default.post(name: .messageDelivered, object: data[0] as! [String:AnyObject])
            if let dict = data[0] as? [String:AnyObject] {
                self?.handleDeliveredMessage(dict: dict)
            }
        })
    }
    private func handleDeliveredMessage(dict:[String:AnyObject]){
        print(dict)
        guard let userId = dict["userid"] as? String else { return }
        guard let fromId = dict["fromid"] as? String else { return }
        
        if userId == AuthService.instance.userId{
            DispatchQueue.main.async {
                if self.memberObject.isMemberExists(id: fromId, context: self.moc){
                    if let messages = self.fetchSentMessages(memberId: fromId){
                        for obj in messages{
                                obj.status = "2"
                        }
                        do {
                            try self.moc.save()
                        } catch let err {
                            print(err)
                        }
                    }
                }
                if fromId == AuthService.instance.currentUser {
                    self.emitSeen(fromId: AuthService.instance.userId, toId: fromId)
                }
            }
        } else {
            // handle their
        }
    }

    private func handleSeenMessage(dict: [String: AnyObject]){
        print(dict)
        guard let userId = dict["userid"] as? String else { return }
        guard let fromId = dict["fromid"] as? String else { return }
        
        if userId == AuthService.instance.userId{
            DispatchQueue.main.async {
                if self.memberObject.isMemberExists(id: fromId, context: self.moc){
                    if let messages = self.fetchSentMessages(memberId: fromId){
                        for obj in messages{
                                obj.status = "3"
                        }
                        do {
                            try self.moc.save()
                        } catch let err {
                            print(err)
                        }
                        
                    }
                }
            }
        } else {
            // handle their
        }
    }
    
    //MARK:- EMIT SEEN
    func emitSeen(fromId:String, toId: String){
        let dict = ["to": toId, "from": fromId]
        manager.defaultSocket.emit(SocketEvents.MESSAGE_SEEN, dict)
    }
    //MARK:- EMIT DELIVERED
    func emitDelivered(fromId:String, toId: String){
        let dict = ["to": toId, "from": fromId]
        manager.defaultSocket.emit(SocketEvents.MESSAGE_DELIVERED, dict)
    }
    
    
    
  
    
    // get messge by id
    func getMessage(id: String,moc: NSManagedObjectContext) -> Message{
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "msgId = %@", id)
        fetchRequest.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try moc.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.first as! Message
    }
    
    //MARK:- SOCKET OBSERVERS
    func emitStartTyping(fromId:String, toId:String){
        let dict = ["to":toId, "from": fromId]
        manager.defaultSocket.emit("startTyping", dict)
    }
    func emitStopTyping(fromId:String, toId:String){
        let dict = ["userid":toId, "fromid":fromId]
        manager.defaultSocket.emit("stopTyping", dict)
    }
}

// get chat from api
extension SocketService{
    func fetchUnseenMessages(memberId: String) -> Message?{
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "member.id = %@", memberId)
        fetchRequest.predicate = NSPredicate(format: "status != %a", "3")
        var results: [NSManagedObject] = []
        do {
            results = try moc.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.first as? Message
    }
    func fetchSentMessages(memberId: String) -> [Message]?{
        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "member.id = %@", memberId)
        fetchRequest.predicate = NSPredicate(format: "NOT (status CONTAINS %@)", "3")
        //fetchRequest.predicate = NSPredicate(format: "status != %a", "2")
        var results: [NSManagedObject] = []
        do {
            results = try moc.fetch(fetchRequest)
            return results as? [Message]
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return nil
    }
}
