//
//  UIColor-Ext.swift
//  TypeView
//
//  Created by MS1 on 2/4/18.
//  Copyright © 2018 xerox101. All rights reserved.
//

import UIKit



extension UIColor {
    
    // MARK: - Initialization
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}


extension UIColor{
    
     static let MyScrapGreen = UIColor(red: 35/255, green: 107/255, blue: 41/255, alpha: 1.0)
    
    static let WHITE_ALPHA = UIColor.white.withAlphaComponent(0.95)
    static let GREEN_PRIMARY = UIColor(red: 35/255, green: 107/255, blue: 41/255, alpha: 1.0)
    static let BLACK_ALPHA = UIColor.black.withAlphaComponent(0.8)
    static let MOD_COLOR = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
    static let seperatorColor : UIColor = UIColor.init(hexString: "#C2C2C2")
        
        //UIColor(white: 0.5, alpha: 0.5)
    static let NEW_COLOR = UIColor(red: 200/255, green: 53/255, blue: 53/255, alpha: 1.0)
    static let IMAGE_BG_COLOR = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
    
    static let LMEgreenColor : UIColor  = UIColor(red: 0/255, green: 133/255, blue: 63/255, alpha: 1.0)
    static let LMEredColor : UIColor = UIColor(red: 210/255, green: 46/255, blue: 25/255, alpha: 1.0)
    static let LMEBgRed : UIColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    static let LMEBgGreen : UIColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)
    
    
    
    static let ONLINE_COLOR = UIColor.init(hexString: "#FF42B72A")
    static let GREEN_ALPHA = UIColor(red: 33/255, green: 108/255, blue: 41/255, alpha: 0.1)
    static let SHADOW_GRAY: CGFloat = 120.0 / 255.0
    
    static let BACKGROUND_GRAY = UIColor.init(hexString: "#DFDEE4")
    
    static let TIME_COLOR = UIColor.gray
    
    static let cvColor = UIColor.rgbColor(red: 216, green: 223, blue: 227)
    
}

extension UIColor{
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}


extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}


extension UIColor {

    class var MSPaleGrayColor : UIColor {
        return UIColor(red: 222/255.0, green: 222/255.0, blue: 227/255.0, alpha: 1)
    }
}
