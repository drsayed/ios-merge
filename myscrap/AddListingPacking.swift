//
//  Packing.swift
//  myscrap
//
//  Created by MyScrap on 7/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
protocol Printable{
    var description: String { get }
}


enum AddListingPacking: Int , Printable {
    
    case bags = 0, bale = 1, jumbo = 2, loose = 3, pallets = 4, other = 5
    
    static var count: Int{
        return AddListingPacking.other.rawValue + 1
    }
    
    var description: String{
        switch self {
        case .bags: return "Bags"
        case .bale : return "Bale"
        case .jumbo : return "Jumbo Bags"
        case .loose : return "Loose"
        case .pallets : return "Pallets"
        case .other : return "Other"
        }
    }

}
