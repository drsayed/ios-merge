//
//  MemberType.swift
//  myscrap
//
//  Created by MyScrap on 11/27/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum MemberType: Int, NewCount {
    
    case about = 0
    case wall = 1
    case photos = 2
    
    var stringRepresentation: String{
        switch self {
        case .about:
            return "ABOUT"
        case .wall:
            return "WALL"
        case .photos:
            return "PHOTOS"
        }
    }
}


protocol NewCount {
    static var caseCount: Int { get }
}

extension NewCount where Self: RawRepresentable, Self.RawValue == Int {
    internal static var caseCount: Int {
        var count = 0
        while let _ = Self(rawValue: count) {
            count += 1
        }
        return count
    }
}
