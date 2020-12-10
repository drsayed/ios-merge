//
//  XMPPAttributes.swift
//  myscrap
//
//  Created by MyScrap on 5/6/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

struct XMPPAttributes{
    
    static let xmlns = "xmlns"
//    static let myscrapReply = "myscrap:reply"
    static let myscrapReply = "my-custom-data-ns"
    
    static let toId = "userId"
    static let fromId = "fromId"
    
    static let uImage = "uImage"
    static let fImage = "fImage"
    
    static let uName = "uName"
    static let fName = "fName"
    
    static let uColor = "uColor"
    static let fColor = "fColor"
    
    static let uRank = "uRank"
    static let userId = "userId"
    
    //Sending message time handling in stanza
    static let sentReceiveTimeStamp = "sentReceiveTimeStamp"
    
    //marketMessage
    static let stanzaType = "stanzaType"
    static let marketUrl = "marketUrl"
    
    
}
