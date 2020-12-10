//
//  ISRI.swift
//  myscrap
//
//  Created by MyScrap on 6/24/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

struct ISRI: Decodable{
    
    var name: String{
        return "\(isri_code.capitalized) - \(product.capitalized)"
    }
    
    
    let id: String
    private let product: String
    private let isri_code: String
    let description: String
    
    
    static func loadJson() -> [ISRI]? {
        if let url = Bundle.main.url(forResource: "ms_isri_code", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([ISRI].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
}
