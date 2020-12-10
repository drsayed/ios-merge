//
//  AddListingService.swift
//  myscrap
//
//  Created by MyScrap on 7/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum AddListingService:Int, Printable{
    case insurance = 0, shipping
    
    static var count : Int{
        return AddListingService.shipping.rawValue + 1
    }
    
    var description: String{
        switch self {
        case .insurance: return "Insurance"
        case .shipping : return "Shipping"
        }
    }
}
