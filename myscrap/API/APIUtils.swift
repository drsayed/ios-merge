//
//  APIUtils.swift
//  myscrap
//
//  Created by myscrap on 13/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//


import UIKit

class APIUtils {
    
    public static func GetAuthorizationHeader() -> [String:String]
    {
        
        if let token = UserDefaults.standard.string(forKey: "kUserToken") {
            print(token)
            if token != "" {
                
                
                let header = ["Authorization": "Bearer " + token,
                              "Accept" : "application/json"];
                return header;
            }
        }
        return ["" : ""]
    }

}
