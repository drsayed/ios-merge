
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
import XMPPFramework
import UserNotifications
import RealmSwift
import Reachability


//enum Presence: String{
//    case unavailable
//}

struct StoreGroup {
    var message : [String]
    var name : [String]
    var color : [String]
    var rank : [String]
}

protocol GrpMsgDelegate: class {
    func putMessages(message: [String], fromId: [String], uName: [String], uColor: [String], uRank: [String])
    //func putMessages(msgId : String, message: String, fromId: String, uName: String, uColor: String, uRank: String)
}

private let kSendMessageTimeoutInterval: TimeInterval = 30

class XMPPService: NSObject{
    
    var container: NSPersistentContainer
    
    private let queue = DispatchQueue(label: "com.myscrp.cwwise", attributes: DispatchQueue.Attributes.concurrent)
    
    
    static let instance = XMPPService()
    
    let defaults = UserDefaults.standard
    
    //Connect attempt AVOID RECONNECT METHOD
    //var connectEst : Bool!
    
    var connectEst : Bool {
        get {
            return defaults.bool(forKey: UserDefaults.XMPPConnEst)
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.XMPPConnEst)
        }
    }
    
    var xmppStream: XMPPStream?
    var xmppReconnect: XMPPReconnect?
    //    var streamManagement: XMPPStreamManagement
    var xmppStreamManagement : XMPPStreamManagement
    var xmppMessageDeliveryRecipts : XMPPMessageDeliveryReceipts
    
    
    var xmppRoster: XMPPRoster?
    var xmppRosterStorage: XMPPRosterCoreDataStorage
    
    var ping : XMPPPing
    var xmppAutoPing: XMPPAutoPing
    
    weak var delegate : GrpMsgDelegate?
    
    
    let options: XMPPLoginManager
    
    var messageCarbons : XMPPMessageCarbons
    
    let memberOperation = MemberOperation()
    let messageOperation = MessageOperation()
    
    var isConnected: Bool{
        guard let stream = xmppStream else { return false}
        return stream.isConnected()
    }
    
    var arrayBody = [""]
    var arrayFrom = [""]
    var arrayuName = [""]
    var arrayuColor = [""]
    var arrayuRank = [""]
    
    var grpMsgDict: Dictionary = [String : [String]]()
    
    var mainArray: [[String]] = [[String]]()
    
    var globalArray = [StoreGroup]()
    var getOfflineMessages : Results<UserPrivChat>!
    var sendMessageConnected : Results<UserPrivChat>!
    var getMessageID : Results<UserPrivChat>!
    
    override init(){
        self.options = XMPPLoginManager.default
        
        xmppStream = XMPPStream()
        xmppStream?.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
        xmppReconnect = XMPPReconnect()
        
        //ping
        ping = XMPPPing()
        xmppAutoPing = XMPPAutoPing()
        
        //Roster (Contacts with Logged in user)
        self.xmppRosterStorage = XMPPRosterCoreDataStorage.sharedInstance()
        self.xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        
        //
        let memoryStorage = XMPPStreamManagementMemoryStorage()
        xmppStreamManagement = XMPPStreamManagement(storage: memoryStorage)
        
        // delivery Receipts
        xmppMessageDeliveryRecipts = XMPPMessageDeliveryReceipts(dispatchQueue: DispatchQueue.main)
        messageCarbons = XMPPMessageCarbons()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        container = app.persistentContainer
        
        super.init()
        
        xmppStream?.enableBackgroundingOnSocket = true
        
        messageCarbons.autoEnableMessageCarbons = true
        messageCarbons.addDelegate(self, delegateQueue: queue)
        messageCarbons.activate(xmppStream)
        
        xmppReconnect?.reconnectDelay = 0.3
        xmppReconnect?.reconnectTimerInterval = DEFAULT_XMPP_RECONNECT_TIMER_INTERVAL
        xmppReconnect?.activate(xmppStream)
        xmppReconnect?.addDelegate(self, delegateQueue: queue)
        
        xmppRoster?.autoFetchRoster = true
        self.xmppRoster?.addDelegate(self, delegateQueue: queue)
        self.xmppRoster?.activate(xmppStream)
        
        
        
        //ping
        ping.respondsToQueries = true
        ping.activate(xmppStream)
        
        xmppAutoPing.pingInterval =  15  //2 * 60      previous 10 secs
        xmppAutoPing.pingTimeout = 10000.0   //1000.0
        xmppAutoPing.activate(xmppStream)
        xmppAutoPing.respondsToQueries = true
        
        
        //
        xmppStreamManagement.autoResume = true
        xmppStreamManagement.ackResponseDelay = 0.2
        xmppStreamManagement.automaticallyRequestAcks(afterStanzaCount: 5, orTimeout: 2.0)
        xmppStreamManagement.automaticallySendAcks(afterStanzaCount: 5, orTimeout: 2.0)
        
        xmppStreamManagement.activate(xmppStream)
        xmppStreamManagement.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        
        
        setupNotificationObserver()
        
        
        
        //setupNetworkReachable
        //xmppStream?.addDelegate(self, delegateQueue: queue)
    
        
    }
    
    func setupNotificationObserver(){
        NotificationCenter.default.addObserver(forName: .xmppReceivedMessage, object: nil, queue: nil) { [weak self] (notif) in
            self?.messageReceived(notif)
            
        }
    }
    
    private func messageReceived(_ notif: Notification){
        guard let message = notif.object as? MessageViewModel else { return }
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = message.name
        content.body = message.text
        content.userInfo = [
            
            "data" : [
                UnNotificationKeys.notificationType : UnNotificationType.chat.rawValue,
                UnNotificationKeys.jid : message.jid,
                UnNotificationKeys.fname : message.name,
                UnNotificationKeys.colorCode : message.colorCode,
                UnNotificationKeys.profilePic : message.profilePic,
                UnNotificationKeys.userId : message.userId
            ]
        ]
        content.sound = UNNotificationSound.default
        print("messageId == \(message.msgId)")
        let req = UNNotificationRequest(identifier: message.msgId, content: content, trigger: nil)
        
        
        center.add(req) { (err) in
            if let error = err {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    func removeNotificationObserver(){
        NotificationCenter.default.removeObserver(self, name: .xmppReceivedMessage, object: nil)
    }
    
    
    
    deinit {
        xmppStream?.removeDelegate(self)
        xmppRoster?.removeDelegate(self)
        xmppReconnect?.removeDelegate(self)
        xmppStreamManagement.removeDelegate(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    var isConnecting : Bool{
        guard let stream = xmppStream else { return false}
        return stream.isConnecting()
    }
    
    var isAuthenticated: Bool{
        guard let stream = xmppStream else { return false}
        return stream.isAuthenticated()
    }
    
    
    func connect(with jid: String){
        
        //Connection attempt
        connectEst = true
        
        let resource = options.resource
        let domain = options.domain
        xmppStream?.hostName = options.host
        xmppStream?.hostPort = options.port
        print("Connect jid : \(jid)")
        
        if jid.contains("@") {
            xmppStream?.myJID = XMPPJID(string: jid, resource: resource)
        } else {
            xmppStream?.myJID = XMPPJID(user: jid, domain: domain, resource: resource)
        }
        print("JID :",xmppStream?.myJID as Any)
        //print("Nickname :", xmppStream?.myJID.user as Any)
        print("Stored JID:", AuthService.instance.userJID as Any)
        
        
        
        try! xmppStream?.connect(withTimeout: XMPPStreamTimeoutNone)
        xmppStream?.addDelegate(self, delegateQueue: queue)
        
        /*do {
            try xmppStream?.connect(withTimeout: XMPPStreamTimeoutNone)
            xmppStream?.addDelegate(self, delegateQueue: queue)
        } catch {
            print("Error in connecting xmpp **** wTH")
        }*/
        
        self.xmppMessageDeliveryRecipts = XMPPMessageDeliveryReceipts(dispatchQueue: DispatchQueue.main)
        self.xmppMessageDeliveryRecipts.autoSendMessageDeliveryReceipts = true
        self.xmppMessageDeliveryRecipts.autoSendMessageDeliveryRequests = true
        self.xmppMessageDeliveryRecipts.activate(xmppStream)
        
    }
    
    func offline(){
        if isConnected == true {
            if isAuthenticated == true {
                let xmppJid = XMPPJID(string: "livechatdiscussion@conference.myscrap.com/" + (XMPPService.instance.xmppStream?.myJID?.user)!)
                
                let p = XMPPPresence(type: "unavailable", to: xmppJid)
                
                xmppStream?.send(p)
                print("Offline presence : \(String(describing: p))")
            } else {
                print("User is not authenticated")
            }
            
        } else {
            print("Need to connect with Xmpp server in offline")
        }
    }
    
    func offlinePrivateChat() {
        /*let xmppJid = XMPPJID(string: XMPPService.instance.xmppStream?.myJID?.user!)
        let p = XMPPPresence(type: "unavailable", to: xmppJid)
        
        xmppStream?.send(p)*/
        /*let xmppJid = XMPPJID(string: (XMPPService.instance.xmppStream?.myJID?.user!)! + "@myscrap.com/iOS")
        let priority = XMLElement(name: "priority", stringValue: "24")
        let element = DDXMLElement.element(withName: "presence") as! DDXMLElement
        let from = DDXMLNode.attribute(withName: "from", stringValue: "\((XMPPService.instance.xmppStream?.myJID?.user)!)@myscrap.com/iOS") as! DDXMLNode
        let type = DDXMLNode.attribute(withName: "type", stringValue: "unavailable") as! DDXMLNode
        element.addAttribute(from)
        element.addAttribute(type)
        let pre = XMPPPresence(from: element)
        //        let p = XMPPPresence(type: "unavailable")
        pre?.addChild(priority)
        xmppStream?.send(pre)*/
    }
    
    private func enableStreamManagement(){
        //
        //        xmppStream?.register(streamManagement)
        //        streamManagement.activate(xmppStream)
        //        streamManagement.autoResume = true
        //        streamManagement.enable(withResumption: true, maxTimeout: 0)
        //        streamManagement.requestAck()
        //        streamManagement.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        let xmppSMMS = XMPPStreamManagementMemoryStorage()
        xmppStreamManagement = XMPPStreamManagement(storage: xmppSMMS, dispatchQueue: DispatchQueue.main)
        xmppStreamManagement.addDelegate(self, delegateQueue: DispatchQueue.main)
        xmppStreamManagement.activate(xmppStream)
        xmppStreamManagement.autoResume = true
        xmppStreamManagement.ackResponseDelay = 0.2
        xmppStreamManagement.requestAck()
        xmppStreamManagement.automaticallyRequestAcks(afterStanzaCount: 1, orTimeout: 10)
        xmppStreamManagement.automaticallySendAcks(afterStanzaCount: 1, orTimeout: 10)
        xmppStreamManagement.enable(withResumption: true, maxTimeout: 0)
        xmppStreamManagement.sendAck()
        xmppStream?.register(xmppStreamManagement)
        
    }
    
    func authenticate(){
        if AuthStatus.instance.isLoggedIn {
            let password = AuthService.instance.password
            do {
                try xmppStream?.authenticate(withPassword: password)
            } catch let err {
                print("Authentication failed, Error to connect xmpp")
                print(err.localizedDescription)
            }
        }
    }
    
    func sendOnline(){
        
        if isConnected && isAuthenticated {
//            let xmppJid = XMPPJID(string: (XMPPService.instance.xmppStream?.myJID!.user)! + "@myscrap.com/iOS")
//            let priority = XMLElement(name: "priority", stringValue: "24")
//            let presence = XMPPPresence(type: "available", to: xmppJid)
//            presence?.addChild(priority)
//            self.xmppStream!.send(presence)
            let presence = XMPPPresence()
            xmppStream?.send(presence)
        }
    }
    
    func disconnect(){
        /*let xmppJid = XMPPJID(string: (XMPPService.instance.xmppStream?.myJID?.user!)! + "@myscrap.com/iOS")
        let priority = XMLElement(name: "priority", stringValue: "24")
        let element = DDXMLElement.element(withName: "presence") as! DDXMLElement
        let from = DDXMLNode.attribute(withName: "from", stringValue: "\((XMPPService.instance.xmppStream?.myJID?.user)!)@myscrap.com/iOS") as! DDXMLNode
        let type = DDXMLNode.attribute(withName: "type", stringValue: "unavailable") as! DDXMLNode
        element.addAttribute(from)
        element.addAttribute(type)
        let pre = XMPPPresence(from: element)
        let p = XMPPPresence(type: "unavailable")
        pre?.addChild(priority)
        xmppStream?.send(pre)*/
        let p = XMPPPresence(type: "unavailable")
        xmppStream?.send(p)
        xmppStream?.removeDelegate(self)
        xmppStream?.disconnectAfterSending()
        //xmppStream = nil
        print("I'm out of sparta")
    }
    
    func sendGrpMsg(text : String, uColor: String, uName: String, userId: String, uimage: String, urank: String) {
        let xmppRoomMemoryStorage = XMPPRoomMemoryStorage()
        let xmppJid = XMPPJID(string: "livechatdiscussion@conference.myscrap.com")
        
        let xmppRoom = XMPPRoom(roomStorage: xmppRoomMemoryStorage!, jid: xmppJid!, dispatchQueue: DispatchQueue.main)
        xmppRoom!.activate(xmppStream!)
        xmppRoom!.addDelegate(self, delegateQueue: DispatchQueue.main)
        xmppRoom!.fetchConfigurationForm()
        xmppRoom!.configureRoom(usingOptions: nil)
        xmppRoom!.sendMessage(withBody: text, uColor: uColor, uName: uName, userId: userId, uimage: "", urank: urank)
        print("Message : \(text), Fromid : \(userId), XmppRoom :\(String(describing: xmppRoom))")
        
    }
}


extension XMPPService: XMPPStreamDelegate{

    func xmppStreamWillConnect(_ sender: XMPPStream!) {
        print("will Connect : \(String(describing: sender.myJID))")
        print("Connecting  RESOURCE : \(sender.myJID.resource!)")
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        
        print("Stream connected: \(String(describing: sender.myJID))")
        print("Connected RESOURCE : \(sender.myJID.resource!)")
        if AuthStatus.instance.isLoggedIn{
            authenticate()
        }
        print("Password : \(AuthService.instance.password), \(String(describing: AuthService.instance.userJID))")
        //try! sender.authenticate(withPassword: AuthService.instance.password)
        
        /*if sender.isAuthenticating() == false {
            try! sender.authenticate(withPassword: AuthService.instance.password)
        } else {
            print("Already authenticated")
        }*/
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        print("Stream Authenticated: \(String(describing: sender.myJID))")
//        let xmppJid = XMPPJID(string: (XMPPService.instance.xmppStream?.myJID!.user)! + "@myscrap.com/iOS")
        //offlinePrivateChat()
        
//        let presence = XMPPPresence()
        sender.send(XMPPPresence())
        /*let defaultJID = XMPPJID(string: (XMPPService.instance.xmppStream?.myJID?.user!)! + "@myscrap.com/iOS")
        if sender.myJID != defaultJID {
            disconnect()
            
        } else {
            sender.send(XMPPPresence())
        }*/
        
        
        /*if presence?.type() == "unavailable" {
            print("No need to show as online")
        } else {let priority = XMLElement(name: "priority", stringValue: "24")
            let element = DDXMLElement.element(withName: "presence") as! DDXMLElement
            let from = DDXMLNode.attribute(withName: "from", stringValue: "\((XMPPService.instance.xmppStream?.myJID?.user)!)@myscrap.com/iOS") as! DDXMLNode
            let type = DDXMLNode.attribute(withName: "type", stringValue: "available") as! DDXMLNode
            element.addAttribute(from)
            element.addAttribute(type)
            let pre = XMPPPresence(from: element)
            //        let p = XMPPPresence(type: "unavailable")
            pre?.addChild(priority)
            xmppStream?.send(pre)
//            presence?.addChild(priority)
//            xmppStream?.send(presence)
        }*/
        
        DispatchQueue.main.async {
            self.sendOfflineMessage()
        }
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendOffline"), object: nil)
        //addMembers()
        enableStreamManagement()
        xmppStreamManagement.autoResume = true
        xmppStreamManagement.enable(withResumption: true, maxTimeout: 60)
        messageCarbons.enable()
    }
    
    func xmppStream(_ sender: XMPPStream!, socketDidConnect socket: GCDAsyncSocket!) {
        print("Socket also called in xmpp")
        sender.enableBackgroundingOnSocket = true
        sender.keepAliveInterval = 1000
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend presence: XMPPPresence!) {
        print("send Presence : \(String(describing: presence))")
        /*if presence.type() == "unavailable" {
            let priority = XMLElement(name: "priority", stringValue: "24")
            let element = DDXMLElement.element(withName: "presence") as! DDXMLElement
            let from = DDXMLNode.attribute(withName: "from", stringValue: "\((XMPPService.instance.xmppStream?.myJID?.user)!)@myscrap.com/iOS") as! DDXMLNode
            let type = DDXMLNode.attribute(withName: "type", stringValue: "available") as! DDXMLNode
            element.addAttribute(from)
            element.addAttribute(type)
            let pre = XMPPPresence(from: element)
            pre?.addChild(priority)
            xmppStream?.send(pre)
        } else {
            print("Still unavailable")
        }*/
    }

    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        if isAuthenticated == true {
            print("Receive Presence : \(presence!)")
            let presenceType = presence.type()
            let username = sender.myJID.user
            let presenceFromUser = presence.from().user
            
            if presenceFromUser != username  {
                if presenceType == "available" {
                    print("available")
                }
                else if presenceType == "subscribe" {
                    //let xmppJID = XMPPJID(string: (XMPPService.instance.xmppStream?.myJID?.user!)! + "@myscrap.com/iOS")
                    self.xmppRoster?.subscribePresence(toUser: presence.from())
                }
                else {
                    print("presence type"); print(presenceType)
                }
            }
        } else {
            print("Failed to receive presence, because not authenticated")
        }
        
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        print("Stream did not authenticated : \(String(describing: error))")
        dump(error)
        connectEst = false
        print("XMPP not connected username/Password changed")
//        DispatchQueue.main.async {
//            AuthStatus.instance.isLoggedIn = false
//        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
        print("Xmpp Received Error", error.description)
    }
//
    func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error!) {
        print("Xmpp disconnected")
        connectEst = false
        if let err = error {
            print(err.localizedDescription)
        } else {
            print("Unknown error disconnection")
        }
//        AuthStatus.instance.isXmpploggedIn = false
    }
    
    func addUser(with jid: String, nickname: String){
        let newJid = XMPPJID(string: "\(jid)@\(XMPPLoginManager.default.domain)/iOS")
        xmppRoster?.addUser(newJid, withNickname: nickname)
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!) {
        if isAuthenticated == true {
            let msg = message
            if msg != nil {
                self.handleSendedMessage(message: msg!)
                print("Message sent in delegate stream")
                print("Message sent id : \(String(describing: msg!.elementID()))")
                if msg!.elementID() != nil {
                    UserDefaults.standard.set("\(msg!.elementID()!)", forKey: "messageID")
                }
                
                print("Message is delivered to client : \(String(describing: msg!.receiptResponseID()))")
            }
            else {
                print("Private message sent is nil")
            }
        } else {
            print("Not autheticated, failed to send message")
        }
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend message: XMPPMessage!, error: Error!) {
        print("failed to send message")
        if message.type() == "chat" {
            let update = uiRealm.objects(UserPrivChat.self).last
            
            //Update the last inserted message as failed
            try! uiRealm.write {
                update?.syncFlag = false
                uiRealm.add(update!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)           //conv-xmpp for offline load
            }
        } else {
            print("This error is for group chat")
        }
    }
    
    func handleSendedMessage(message: XMPPMessage){
        print("Message stanza : \(message)")
        guard let msgId = message.elementID(),
            let body = message.body(),
            let sjid = message.to().user,
            let data = message.elements(forName: "data").first,
            let colorCode = data.attributeStringValue(forName: XMPPAttributes.uColor),
            let name = data.attributeStringValue(forName: XMPPAttributes.uName),
            let profilePic = data.attributeStringValue(forName: XMPPAttributes.uImage),
            let userId = data.attributeStringValue(forName: XMPPAttributes.toId)
            else { return }
        
        let jid = sjid.userJID
        
        print("Message Id on Did Send Message ", message.elementID())
        DispatchQueue.main.async {
            //Offline message DB update
            self.sendMessageConnected = uiRealm.objects(UserPrivChat.self).filter("syncFlag == false AND offlineFlag == true AND msgStatus == 'offline'")
            for lists in self.sendMessageConnected {
                try! uiRealm.write {
                    lists.offlineFlag = false
                    lists.syncFlag = true
                    lists.msgStatus = "sent"
                    lists.messageID = msgId
                    //uiRealm.add(lists, update: true)
                    uiRealm.add(lists)
                    print("Sync Flag from offline message: \(lists.syncFlag), Stanza while sending : \(lists.stanza), body : \(lists.body)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)           //conv-xmpp for offline load
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadchat"), object: nil)       //chat-xmpp for offline load
                }
            }
            //Online messages DB update
            let update = uiRealm.objects(UserPrivChat.self)
            //print("Last insert key_id : \(update.last?.key_id)")
            if let lastValue = update.last {
                try! uiRealm.write {
                    lastValue.messageID = msgId
                    lastValue.syncFlag = true
                    lastValue.offlineFlag = false
                    lastValue.msgStatus = "sent"
                    uiRealm.add(lastValue)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)           //conv-xmpp for offline load
                }
            }
            /*print("Last insert key_id : \(update.last?.key_id)")
            if let lastValue = update.last {
                //Update the last inserted message
                try! uiRealm.write {
                    lastValue.messageID = msgId
                    lastValue.msgStatus = "sent"
                    lastValue.syncFlag = true
                    lastValue.offlineFlag = false
                    uiRealm.add(lastValue)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)           //conv-xmpp for offline load
                }
            }*/
        }
    }
    
    //Send online message
    func sendMessage(with text: String, to jid: String, userId: String, fromId: String, uImage: String, fImage: String, uName: String, fName: String, uColor: String, fColor: String, stanzaType: String, marketUrl: String, sentReceiveTimeStamp: String){
      
        if AuthStatus.instance.isLoggedIn, !AuthStatus.instance.isGuest {
            var senderJID = XMPPJID(string: "\(jid)")
            if jid.contains("@myscrap.com") {
                senderJID = XMPPJID(string: "\(jid)")
            } else {
                if jid != AuthService.instance.userJID {
                    senderJID = XMPPJID(string: "\(jid)@\(XMPPLoginManager.default.domain)")
                } else {
                    senderJID = XMPPJID(string: "\(jid)@\(XMPPLoginManager.default.domain)")
                }
                
            }
            
            let fromJID = XMPPJID(string: AuthService.instance.userJID)
            let elemId = xmppStream?.generateUUID()
            print("JID : \(jid)")
            print(senderJID)
            
            //let msg = XMPPMessage(type: "chat", to: senderJID, from:fromJID, elementID: elemId)
            let msg = XMPPMessage(type: "chat", to: senderJID, elementID: elemId)
            
            
            let data = DDXMLElement.element(withName: "data") as! DDXMLElement
            
            let myscrapReply = DDXMLNode.attribute(withName: XMPPAttributes.xmlns, stringValue: XMPPAttributes.myscrapReply) as! DDXMLNode
            
            let fidat = DDXMLNode.attribute(withName: XMPPAttributes.toId, stringValue: userId) as! DDXMLNode
            let uidat = DDXMLNode.attribute(withName: XMPPAttributes.fromId, stringValue: fromId) as! DDXMLNode
            
            let uImageat = DDXMLNode.attribute(withName: XMPPAttributes.uImage, stringValue: uImage) as! DDXMLNode
            let fImageat = DDXMLNode.attribute(withName: XMPPAttributes.fImage, stringValue: fImage) as! DDXMLNode
            
            
            let uNameat = DDXMLNode.attribute(withName: XMPPAttributes.uName, stringValue: uName) as! DDXMLNode
            let fNameat = DDXMLNode.attribute(withName: XMPPAttributes.fName, stringValue: fName) as! DDXMLNode
            
            let uColorat = DDXMLNode.attribute(withName: XMPPAttributes.uColor, stringValue: uColor) as! DDXMLNode
            let fColorat = DDXMLNode.attribute(withName: XMPPAttributes.fColor, stringValue: fColor) as! DDXMLNode
            
            //Sending time handling in stanza
            let sentTime = DDXMLNode.attribute(withName: XMPPAttributes.sentReceiveTimeStamp, stringValue: sentReceiveTimeStamp) as! DDXMLNode
            
            //marketMsg
            let stanzaType = DDXMLNode.attribute(withName: XMPPAttributes.stanzaType, stringValue: stanzaType) as! DDXMLNode
            let marketUrl = DDXMLNode.attribute(withName: XMPPAttributes.marketUrl, stringValue: marketUrl) as! DDXMLNode
            
            data.addAttribute(myscrapReply)
            data.addAttribute(fidat)
            data.addAttribute(uidat)
            data.addAttribute(uImageat)
            data.addAttribute(fImageat)
            data.addAttribute(uNameat)
            data.addAttribute(fNameat)
            data.addAttribute(uColorat)
            data.addAttribute(fColorat)
            data.addAttribute(sentTime)
            data.addAttribute(stanzaType)
            data.addAttribute(marketUrl)
            msg?.addChild(data)
            msg?.addBody(text)
            msg?.addReceiptRequest()
            msg?.hasReceiptRequest()
            msg?.hasReceiptResponse()
            msg?.generateReceiptResponse()
            xmppStream?.send(msg)
        }
    
    }
    //send offline message
    func sendOfflineMessage() {
        getOfflineMessages = uiRealm.objects(UserPrivChat.self).filter("syncFlag == false AND offlineFlag == true AND msgStatus == 'offline'")
        print("Get Offline messages while sending : \(getOfflineMessages)")
        print("Count of the Db offline : \(getOfflineMessages.count)")
        for lists in getOfflineMessages {
//            DispatchQueue.main.async {
            self.sendOfflineMessages(with: lists.body, to: lists.toJID, userId: lists.toUserId, fromId: lists.fromUserId, uImage: lists.toImageUrl, fImage: lists.fromImageUrl, uName: lists.toUserName, fName: lists.fromUserName, uColor: lists.toColorCode, fColor: lists.fromColorCode, stanzaType: lists.stanzaType, marketUrl: lists.marketUrl, sentReceiveTimeStamp: lists.timeStamp)
                try! uiRealm.write {
                    lists.offlineFlag = false
                    lists.syncFlag = true
                    lists.msgStatus = "sent"
                    //uiRealm.add(lists, update: true)
                    uiRealm.add(lists)
                    print("Sync Flag from offline message: \(lists.syncFlag), Stanza while sending : \(lists.stanza), body : \(lists.body)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)           //conv-xmpp/chat-xmpp for offline load
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadchat"), object: nil)       //chat-xmpp for offline load
                }
//            }
            print("Sent offline message after connected to internet!! : \(lists)")
        }
    }
    
    func sendOfflineMessages(with text: String, to jid: String, userId: String, fromId: String, uImage: String, fImage: String, uName: String, fName: String, uColor: String, fColor: String, stanzaType: String, marketUrl: String, sentReceiveTimeStamp: String){
        
        //self.connect(with: AuthService.instance.userJID!)
        
        if AuthStatus.instance.isLoggedIn, !AuthStatus.instance.isGuest {
            var senderJID = XMPPJID(string: "\(jid)")
            if jid.contains("@myscrap.com") {
                senderJID = XMPPJID(string: "\(jid)")
            } else {
                senderJID = XMPPJID(string: "\(jid)@\(XMPPLoginManager.default.domain)")
            }
            
            let fromJID = XMPPJID(string: AuthService.instance.userJID)
            let elemId = xmppStream?.generateUUID()
            print("JID : \(jid)")
            print(senderJID)
            
            //let msg = XMPPMessage(type: "chat", to: senderJID, from:fromJID, elementID: elemId)
            let msg = XMPPMessage(type: "chat", to: senderJID, elementID: elemId)
            
            
            let data = DDXMLElement.element(withName: "data") as! DDXMLElement
            
            let myscrapReply = DDXMLNode.attribute(withName: XMPPAttributes.xmlns, stringValue: XMPPAttributes.myscrapReply) as! DDXMLNode
            
            let fidat = DDXMLNode.attribute(withName: XMPPAttributes.toId, stringValue: userId) as! DDXMLNode
            let uidat = DDXMLNode.attribute(withName: XMPPAttributes.fromId, stringValue: fromId) as! DDXMLNode
            
            let uImageat = DDXMLNode.attribute(withName: XMPPAttributes.uImage, stringValue: uImage) as! DDXMLNode
            let fImageat = DDXMLNode.attribute(withName: XMPPAttributes.fImage, stringValue: fImage) as! DDXMLNode
            
            
            let uNameat = DDXMLNode.attribute(withName: XMPPAttributes.uName, stringValue: uName) as! DDXMLNode
            let fNameat = DDXMLNode.attribute(withName: XMPPAttributes.fName, stringValue: fName) as! DDXMLNode
            
            let uColorat = DDXMLNode.attribute(withName: XMPPAttributes.uColor, stringValue: uColor) as! DDXMLNode
            let fColorat = DDXMLNode.attribute(withName: XMPPAttributes.fColor, stringValue: fColor) as! DDXMLNode
            
            //Sending time handling in stanza
            let sentTime = DDXMLNode.attribute(withName: XMPPAttributes.sentReceiveTimeStamp, stringValue: sentReceiveTimeStamp) as! DDXMLNode
            
            //marketMsg
            let stanzaType = DDXMLNode.attribute(withName: XMPPAttributes.stanzaType, stringValue: stanzaType) as! DDXMLNode
            let marketUrl = DDXMLNode.attribute(withName: XMPPAttributes.marketUrl, stringValue: marketUrl) as! DDXMLNode
            
            data.addAttribute(myscrapReply)
            data.addAttribute(fidat)
            data.addAttribute(uidat)
            data.addAttribute(uImageat)
            data.addAttribute(fImageat)
            data.addAttribute(uNameat)
            data.addAttribute(fNameat)
            data.addAttribute(uColorat)
            data.addAttribute(fColorat)
            data.addAttribute(sentTime)
            data.addAttribute(stanzaType)
            data.addAttribute(marketUrl)
            msg?.addChild(data)
            msg?.addBody(text)
            xmppStream?.send(msg)
            
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        if isAuthenticated == true {
            let msg = message
            if msg != nil {
                if message.type() == "chat" {
                    self.handleReceivedMessage(message: msg!)
                } else {
                    print("Message from group chat")
                }
                
                print("Message From: \(message.from().user)")
                print("Message Body: \(message.body())")
                print("Message is delivered to client -: \(message.receiptResponseID())")
                //Get Delivery receipt id
                if msg!.receiptResponseID() != nil {
                    DispatchQueue.main.async {
                        self.getMessageID = uiRealm.objects(UserPrivChat.self).filter("syncFlag == true AND offlineFlag == false AND messageID == '\(msg!.receiptResponseID()!)'")
                        for lists in self.getMessageID {
                            try! uiRealm.write {
                                lists.msgStatus = "received"
                                //uiRealm.add(lists, update: true)
                                uiRealm.add(lists)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "msgID"), object: nil)
                            }
                        }
                    }
                }
                print("Message received from XMPPService : \(String(describing: msg))")
            } else {
                print("Private message received is nil")
            }
        } else {
            print("Not authenticated, failed to receive messsage")
        }
        
    }
    
    func handleReceivedMessage(message: XMPPMessage){
        //if any of the content is nil then this will not trigger push
        guard let body = message.body(),
            let data = message.elements(forName: "data").first,
            let msgId = message.elementID(),
            let rjid = message.from().user,
            let userId = data.attributeStringValue(forName: XMPPAttributes.fromId),
            let rcolorCode = data.attributeStringValue(forName: XMPPAttributes.fColor),
            let name = data.attributeStringValue(forName: XMPPAttributes.fName),
            let profilePic = data.attributeStringValue(forName: XMPPAttributes.fImage),
            let receiveTime = data.attributeStringValue(forName: XMPPAttributes.sentReceiveTimeStamp),
            let stanzaType = data.attributeStringValue(forName: XMPPAttributes.stanzaType),
            let marketUrl = data.attributeStringValue(forName: XMPPAttributes.marketUrl)
            else {
            return
            
        }
        
        //Handle Delivery Receipt
        if message.hasReceiptResponse() {
            print("Message read ")
        }
        
        var msgTitle = ""
        
        if stanzaType == "marketAdv" {
            msgTitle = "Interested in your Market Ad"
        } else {
            msgTitle = body
        }
        
        //Handling Notifications
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = name
        content.body = msgTitle
        content.userInfo = [
            
            "data" : [
                UnNotificationKeys.notificationType : UnNotificationType.chat.rawValue,
                UnNotificationKeys.jid : rjid,
                UnNotificationKeys.fname : name,
                UnNotificationKeys.colorCode : rcolorCode,
                UnNotificationKeys.profilePic : profilePic,
                UnNotificationKeys.userId : userId
            ]
        ]
        content.sound = UNNotificationSound.default
        print("messageId == \(msgId)")
        let req = UNNotificationRequest(identifier: msgId, content: content, trigger: nil)
        
        
        center.add(req) { (err) in
            if let error = err {
                print(error.localizedDescription)
            }
        }
        
       DispatchQueue.main.async {
        
        //Market Message fetch
        //Converting String to JSON
        
        var type = ""
        var title = ""
        var rate = ""
        var listingId = ""
        
        let jsonString = body
        let jsondata = jsonString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: jsondata, options : .allowFragments) as? [String:String]
            {
                print("Converted json string",jsonArray) // use the json here
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
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
            let chat = UserPrivChat()
            //            msg_Details.fromJID = AuthService.instance.userJID
            chat.conversationId = AuthService.instance.userId + userId
            chat.messageID = msgId
            chat.fromJID = rjid
            chat.toJID = AuthService.instance.userJID!
            chat.body = body
            //let timeStamp = String(Date().toMillis())
            let timeStamp = receiveTime
            chat.timeStamp = timeStamp
            let doubleTimeStamp = Int64(receiveTime)
            // get the current date and time
            let currentDateTime = Date(milliseconds: doubleTimeStamp!)
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            //formatter.timeZone = TimeZone(abbreviation: "GMT")
            //formatter.dateFormat = "dd-MMM, HH:mm"
            //formatter.dateFormat = "dd-MMM, h:mm a"     //12 hrs
        formatter.dateFormat = "MMM dd, h:mm a" 
            chat.time = formatter.string(from: currentDateTime)
            chat.fromUserId = userId
            chat.toUserId = AuthService.instance.userId
            chat.fromUserName = name
            chat.toUserName = AuthService.instance.fullName
            chat.fromImageUrl = profilePic
            chat.toImageUrl = AuthService.instance.profilePic
            chat.fromColorCode = rcolorCode
            chat.toColorCode = AuthService.instance.colorCode
            chat.signalId = timeStamp
            chat.stanza = message.prettyXMLString()
            chat.messageType = "receive"
            chat.offlineFlag = false
            chat.syncFlag = false
            chat.readCount = 0
            //Assigning Market values
            chat.stanzaType = stanzaType
            chat.marketUrl = marketUrl
            chat.type = type
            chat.title = title
            chat.rate = rate
            chat.listingId = listingId
            
            try! uiRealm.write {
                uiRealm.add(chat)
                
                print("RECEIVED Msg description lists : \(chat)")
                //print("1 row inserted by receive !! : \(chat.key_id)")
                //ConversationVC.instance.collecReload()
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "allchat"), object: nil)    //chat-xmpp for receive
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadchat"), object: nil)       //chat-xmpp for receive
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)       //conv-xmpp for receive
            }
        
        }
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend presence: XMPPPresence!, error: Error!) {
        if let err = error{
            print("Failed to send presence: ",err.localizedDescription)
        }
        sendOnline()
    }
    
    func xmppStream(_ sender: XMPPStream, didSend iq: XMPPIQ) {
        print("%@", iq, "Did send")

    }

    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool {

        print("")

        print("Receiving iq in xmppstream called ",iq)

        print("IQ ID",iq.elementID())


        
                let chats = iq.elements(forName: "chat")
        print("chats : \(chats)")
                for chat in chats{
        
                    print("Received iqs")
                    if let body = chat.attribute(forName: "chat") as? String{
                        print(body)
                    }
                }
        return false
    }
    
    //Trying voip bg socket
    /*
    func xmppStream(_ sender: XMPPStream!, socketDidConnect socket: GCDAsyncSocket!) {
        socket.perform {
            //sender.enableBackgroundingOnSocket = true
            //sender.keepAliveInterval = 1000
            socket.enableBackgroundingOnSocket()
        }
        
    }*/
}


extension XMPPService {
    func managedObjectContext_roster() -> NSManagedObjectContext {
        return self.xmppRosterStorage.mainThreadManagedObjectContext
    }
}

extension XMPPService: XMPPStreamManagementDelegate {
    func xmppStreamManagement(_ sender: XMPPStreamManagement!, wasEnabled enabled: DDXMLElement!) {
        print("Stream management enabled")
    }
    
    func xmppStreamManagement(_ sender: XMPPStreamManagement!, wasNotEnabled failed: DDXMLElement!) {
        print("stream managemnent failed", failed.description)
    }
    
    func xmppStreamManagement(_ sender: XMPPStreamManagement!, didReceiveAckForStanzaIds stanzaIds: [Any]!) {
        print("Received Stanza Ids")
        print(stanzaIds)
        print("Received Ack")
        if let messageIds = stanzaIds as? [String] {
            for id in messageIds {
                print("Message is delivered to xmpp server: \(id)")
                // TODO: Custom code goes here to change the message status
            }
        }
    }
    func xmppStreamManagementDidRequestAck(_ sender: XMPPStreamManagement!) {
        print("Requested Ack")
    }
    
    
}

extension XMPPService: XMPPMessageCarbonsDelegate{
    func xmppMessageCarbons(_ xmppMessageCarbons: XMPPMessageCarbons!, willReceive message: XMPPMessage!, outgoing isOutgoing: Bool) {
        print("will receive carbon message")
    }
    
    func xmppMessageCarbons(_ xmppMessageCarbons: XMPPMessageCarbons!, didReceive message: XMPPMessage!, outgoing isOutgoing: Bool) {
        guard let msg = message else { return }
        if isOutgoing{
            handleSendedMessage(message: msg)
        } else {
            handleReceivedMessage(message: msg)
            //handleReceiveMsgGroup(message: msg)
        }
    }
    
    
    func getArchiveMessages(with jid: String){
        
        if let uuid = xmppStream?.generateUUID(){
            let iQ = DDXMLElement.element(withName: "iq") as! DDXMLElement
            iQ.addAttribute(withName: "type", stringValue: "get")
            //            iQ.addAttribute(withName: "id", stringValue: uuid)
            //let query = DDXMLElement.element(withName: "query") as! DDXMLElement
            //query.addAttribute(withName: "xmlns", stringValue: "http://jabber.org/protocol/disco#info")
            let retrieve = DDXMLElement(name: "retrieve", xmlns: "urn:xmpp:archive")
            retrieve?.addAttribute(withName: "with", stringValue: "\(jid)@\(XMPPLoginManager.default.domain)/iOS")
            let set = DDXMLElement.element(withName: "set") as! DDXMLElement
            set.addAttribute(withName: "xmlns", stringValue: "http://jabber.org/protocol/rsm")
            let max = DDXMLElement.element(withName: "max") as! DDXMLElement
            max.stringValue = "10"
            max.addAttribute(withName:"xmlns", stringValue: "http://jabber.org/protocol/rsm")
            //iQ.addChild(query)
            iQ.addChild(retrieve!)
            retrieve?.addChild(set)
            set.addChild(max as DDXMLNode)
            xmppStream?.send(iQ)
            
            print("\n hello")
            print(iQ)
            print("\n iqsss")
        }
    }
}


extension UIViewController{
    func sendOnline(){
        XMPPService.instance.sendOnline()
    }
}
extension XMPPService: XMPPRosterDelegate{
    func xmppRoster(_ sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        sender.acceptPresenceSubscriptionRequest(from: presence.from(), andAddToRoster: true)
    }
}

