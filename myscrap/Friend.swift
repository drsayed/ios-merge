//
//  Friend.swift
//  myscrap
//
//  Created by MyScrap on 5/19/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


struct APIResponse<T: Decodable>: Decodable{
    let error: Bool
    let status: String
    let data : [T]?

    enum CodingKeys: String, CodingKey {
        case error, status
        case data = "addContactsData"
    }
}


//struct Friend{
//
//    var userid: String?
//    var firstName: String?
//    var lastName: String?
//    var country: String?
//    var profilePic: String?
//    var colorCode: String?
//    var
//}
