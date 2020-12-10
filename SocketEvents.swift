//
//  SocketEvents.swift
//  myscrap
//
//  Created by MS1 on 11/5/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
struct SocketEvents{
    //SOCKET EVENTS
    static let START_TYPING = "startTyping"
    static let STOP_TYPING = "stopTyping"
    static let USER_ONLINE = "userOnline"
    static let ADD_USER = "add-user-ms"
    static let SEND_TEXT_MESSAGE = "chat-message"
    static let SEND_IMAGE_MESSAGE = "uploadFileStart"
    static let MY_MESSAGE = "my-message-ms"
    static let FRIEND_MESSAGE = "friend-message-ms"
    static let MESSAGE_DELIVERED = "messageDelivered"
    static let MESSAGE_SEEN = "messageSeen"

}


struct SocketParams{
    static let username = "username"
    static let uploadFile = "uploadFileStart"
}

