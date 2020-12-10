//
//  Meida.swift
//  Network-Test
//
//  Created by MyScrap on 6/23/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "1.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
/*struct Video {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage videoUrl: URL, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "1.jpg"
        
        do {
            guard let data = try Data(contentsOf: videoUrl, options: .mappedIfSafe) else { return nil }
            self.data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
        } catch {
            //self.data = nil
            self.data = nil
            return
            print("Nil data")
        }
    }
}*/

