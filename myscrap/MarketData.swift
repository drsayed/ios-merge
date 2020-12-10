//
//  MarketData.swift
//  myscrap
//
//  Created by MyScrap on 7/1/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class MarketData: Decodable{
    
    var listingID: String?
    var imageUrl: String?
    var listingCode : String!
    var isriCode: String?
    var countryFlagCode : String!
    var place : String!
    var description : String!
    var expiry : Int!
    var views : String?
    var listingType: String?
    private var chat_status : String?
    var quantity: String?
    var isFav : Bool?
    var userSeen: Bool?
    var postStatusExpire: Bool?
    var isriProduct: String?
    var user_data: UserData?
    

    
    var title: String?{
        if let isri = isriCode, let product = isriProduct{
            if listingType == "0"{
                return "SALES: \(isri), \(product)"
            } else {
                return "BUY: \(isri), \(product)"
            }
        }
        return nil
    }
    
    var viewTitle: String{
        if let v = views{
            switch v {
            case "0": return "No Views."
            case "1": return "1 View."
            default: return "\(v) Views."
            }
        }
        return "No Views."
    }
    
    
    var chatStatus: MarketChatStatus{
        get {
            if let status = chat_status,let intValue = Int(status), let value = MarketChatStatus(rawValue: intValue){
                return value
            }
            return MarketChatStatus.contact
        } set {
            chat_status = "\(newValue.rawValue)"
        }
    }
}

struct UserData: Decodable{
    
    var fullName : String?{
        if let fname = firstName, let lname = lastName{
            return fname + " " + lname
        }
        return nil
    }

    var userId: String?
    var jid: String?
    var firstName: String?
    var lastName: String?
    var colorCode: String?
    var profilePic: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case jid = "jid"
        case firstName = "first_name"
        case lastName = "last_name"
        case colorCode = "colorcode"
        case profilePic = "profile_img"
        case email = "email"
    }

}
