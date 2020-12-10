//
//  MarketType.swift
//  myscrap
//
//  Created by MyScrap on 7/1/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum MarketType: Int, CaseCountable {
    case sell = 0
    case buy = 1
    
    var stringRepresentation: String{
        switch self {
        case .sell:
            return "Sell"
        case .buy:
            return "Buy"
        }
    }
}


protocol CaseCountable {
    static var caseCount: Int { get }
}

extension CaseCountable where Self: RawRepresentable, Self.RawValue == Int {
    internal static var caseCount: Int {
        var count = 0
        while let _ = Self(rawValue: count) {
            count += 1
        }
        return count
    }
}
