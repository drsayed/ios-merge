//
//  XMPPGroup.swift
//  myscrap
//
//  Created by MyScrap on 1/6/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
import XMPPFramework
import UserNotifications

enum XMPPGroupError : Error {
    case wrongUserJID
}

class XMPPGroup: NSObject{
    
    var xmppStream: XMPPStream
    
    let hostName: String
    let userJID: XMPPJID
    let hostPort: UInt16
    let password: String
    
    init(hostName: String, userJIDString: String, hostPort: UInt16 = 5222, password: String) throws {
        guard let userJID = XMPPJID(string: userJIDString) else {
            throw XMPPGroupError.wrongUserJID
        }
        
        self.hostName = hostName
        self.userJID = userJID
        self.hostPort = hostPort
        self.password = password
        
        // Stream Configuration
        self.xmppStream = XMPPStream()
        self.xmppStream.hostName = hostName
        self.xmppStream.hostPort = hostPort
        self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
        self.xmppStream.myJID = userJID
        
        super.init()
        
        self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    func connect() {
        if !self.xmppStream.isDisconnected() {
            return
        }
        
        try! self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
    }
}


extension XMPPGroup: XMPPStreamDelegate{
    
    func xmppStreamWillConnect(_ sender: XMPPStream!) {
        print("will Connect : \(sender)")
    }
    
    func xmppStreamDidConnect(_ stream: XMPPStream!) {
        print("Stream: Connected")
        try! stream.authenticate(withPassword: self.password)
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        self.xmppStream.send(XMPPPresence())
        print("Stream: Authenticated")
    }
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error!) {
        print("Xmpp disconnected")
        if let err = error {
            print(err.localizedDescription)
        } else {
            print("Unknown error disconnection")
        }
        //        AuthStatus.instance.isXmpploggedIn = false
    }
}


