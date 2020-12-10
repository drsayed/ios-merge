//
//  AddListingPayment.swift
//  myscrap
//
//  Created by MyScrap on 7/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


import Foundation

enum AddListingShipment:Int, Printable{
    case fob = 0, cnf = 1, cif = 2
    
    static var count : Int{
        return AddListingShipment.cif.rawValue + 1
    }
    
    var description: String{
        switch self {
        case .fob: return "FOB"
        case .cnf : return "CNF"
        case .cif : return "CIF"
        }
    }
}
