//
//  JSONUtils.swift
//  myscrap
//
//  Created by myscrap on 14/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class JSONUtils {
    
    public static func GetStringFromObject(object: [String:Any], key: String) -> String
    {
        var value = "";
        if let str = object[key] as? String
        {
            value = str;
        }
        return value;
    }
    
    public static func GetIntFromObject(object: [String:Any], key: String) -> Int
    {
        var value = 0;
        if let val = object[key] as? Int
        {
            value = val;
        }
        return value;
    }

    
    public static func GetBoolFromObject(object: [String:Any], key: String) -> Bool
    {
        var value = false;
        if let val = object[key] as? Bool
        {
            value = val;
        }
        return value;
    }
    
    // MARK:- Check is Valid Email
    public static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
