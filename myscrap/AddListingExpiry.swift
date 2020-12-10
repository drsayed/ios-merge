//
//  AddListingExpiry.swift
//  myscrap
//
//  Created by MyScrap on 7/22/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum AddListingExpiry: Int ,Printable {
    case one = 1
    case two = 2
    case three = 3
    
    static var count: Int {
        return 3
    }
    
    var description: String{
        switch  self {
        case .one: return "30 Days"
        case .two: return "90 Days"
        case .three : return "365 Days"
        }
    }
    
}
