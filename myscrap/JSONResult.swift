//
//  ClientService.swift
//  myscrap
//
//  Created by MyScrap on 6/30/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

struct JSONResult<T: Decodable> : Decodable{
    var error : Bool
    var status : String
    var data: T?
}

struct ListJSONResult<T: Decodable> : Decodable{
    var error : Bool
    var message : String
    var data: T?
}

