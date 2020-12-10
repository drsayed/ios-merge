//
//  CountryCode.swift
//  myscrap
//
//  Created by MyScrap on 10/11/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


struct Ccode: Decodable{
    
    
    let InternetCode : String
    //    let port_name : String
    let CountryCode:String
    
    //let flagcode: String
    
    let Capital :String
    
    let CountryName: String
    
    
   
    
    
    static func getcountryCode() -> [Ccode]? {
        if let url = Bundle.main.url(forResource: "countrycode", withExtension: "json"){
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode([Ccode].self, from: data)
                return jsonData
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
