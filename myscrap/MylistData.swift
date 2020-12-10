//
//  MylistData.swift
//  myscrap
//
//  Created by MyScrap on 1/21/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class MylistData: Decodable{
    
    var listing_id: String?
    var user_id: String?
    var anonymous: String?
    var rate: String?
    var duration: String?
    var product: String?
    var isri_code: String?
    var total_view: String?
    var port_name: String?
    var country_name: String?
    var flagcode: String?
    var countryID: String?
    var quantity: String?
    var description: String?
    //var listingImage: [String]?
    var imageUrl: String?
}
