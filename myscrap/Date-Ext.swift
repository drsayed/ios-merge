//
//  Date-Ext.swift
//  myscrap
//
//  Created by MS1 on 11/11/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        
        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }
        
        let formatString = NSLocalizedString("%@ ago", comment: "")
        return String(format: formatString, timeString)
    }
    
}
