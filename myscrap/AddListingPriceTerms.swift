//
//  AddListingTerms.swift
//  myscrap
//
//  Created by MyScrap on 7/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum AddListingPriceTerms: Int, Printable{
    case fixed = 0, unknown = 1, spot = 2, quote = 3, bid = 4,other = 5
    
    
    static var count : Int{
        return AddListingPriceTerms.other.rawValue + 1
    }
    
    var description: String{
        switch self {
        case .fixed :return "Fixed"
        case .unknown: return "Unknown"
        case .spot: return "Spot"
        case .quote: return "Message to quote"
        case .bid: return "Highest bid"
        case .other : return "Other"
        }
    }
}
