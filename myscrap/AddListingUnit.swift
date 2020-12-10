//
//  AddListingUnit.swift
//  myscrap
//
//  Created by MyScrap on 7/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum AddListingUnit: Int, Printable{
    case mt = 0
    
    static var count: Int{
        return 1
    }
    
    
    var description: String{
        return "MT"
    }
}
