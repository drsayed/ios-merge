//
//  ChatStatus.swift
//  myscrap
//
//  Created by MyScrap on 7/1/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum MarketChatStatus: Int{
    case contact = 0
    case requested = 1
    case accepted = 2
    case mine = 3
    case rejected = 4
    
    var stringReprsentation: String{
        switch self {
        case .mine:
            return "Chat Now"
        case .contact:
            return "Request"
        case .requested:
            return "Requested"
        case .accepted:
            return "Chat Now"
        case .rejected:
            return "Rejucted"
        }
    }
}
