//
//  MarketItem.swift
//  myscrap
//
//  Created by MyScrap on 6/5/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class CountryListing: Decodable{
    
    var country : String?
    var count: String?
    var flagCode: String?
    var countryId: String
    
    
    private enum CodingKeys: String, CodingKey{
        case country = "country_name", count = "total_listing" , countryId = "country_id", flagCode = "flagcode"
    }
    
    
    init(country: String, count: String, flagCode: String, countryId: String) {
        self.country = country
        self.count = count
        self.flagCode = flagCode
        self.countryId = countryId
    }
}
class ProductListing: Decodable{
    var total_product : String?
    var product : String?
    var isri_code : String?
    var productId : String?
    
    init(total_product: String, product: String, isri_code: String, productId: String) {
        self.total_product = total_product
        self.product = product
        self.isri_code = isri_code
        self.productId = productId
    }
}


