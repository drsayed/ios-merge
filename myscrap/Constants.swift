//
//  Constants.swift
//  myscrap
//
//  Created by MS1 on 5/16/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit


struct MSTextViewAttributes{
    static let USERTAG = "com.myscrap.usertag"
    static let CONTINUE_READING = "com.myscrap.continueReading"
    static let SHOW_LESS = "com.myscrap.showLess"
    static let URL = "com.myscrap.url"
}



var API_KEY:String {
    if AuthStatus.instance.isGuest {
      //  return "12f05b68f332c0fa9cb0e01b47f740e3"
         return "9b0b2617-0f4a-40ac-a9ac-c9abf02e7159"
        
    }
    if let key = AuthStatus.instance.apiKey {
        return key
    }
    return _API_KEY!
}



let _API_KEY = UIDevice.current.identifierForVendor?.uuidString.lowercased()
//let API_KEY = "12f05b68f332c0fa9cb0e01b47f740e3"

let MOBILE_DEVICE = UIDevice.current.modelName
let BRAND_NAME = UIDevice.current.model


let FULL_COMMODITY_ARRAY = ["Non-Ferrous Metals","Ferrous Metals","Stainless Steel","Tyres","Paper","Textiles","Plastic","E-Scrap","Red Metals","Aluminum","Zinc","Magnesium","Lead","Nickel/Stainless/Hi Temp","Mixed Metals","Electric Furnace Casting and Foundry","Specially Processed Grades","Cast Iron Grades","Special Boring Grades","Steel From Scrap Tiles","Railroad Ferrous Scrap","Stainless Alloy","Special Alloy","Copper","Finance","Insurance","Shipping","Equipments","Others"]


let ROLES_ARRAY = ["Trader","Agent","Recycler","Exporter","Stocker","Equipment","Service","Consumer","Consultant","Press","Importer","Supplier","Other"]

let COMPANY_ROLES_ARRAY = ["Trader","Indentor","Recycler","Exporter","Stocker","Equipment","Service","Consumer","Consultant","Importer","Press","Supplier","Other"]

//Company Business Type / Commodity / Affiliations
let COMPANY_BUSINESS_TYPE_ARRAY = [ "Processor", "Broker", "Consumer" ,"Trader", "Institution", "Equipment", "Media", "Others"]
let COMPANY_COMMODITY_ARRAY = ["Non-Ferrous", "Ferrous", "Glass", "Paper", "Plastic", "Electronics", "Rubber", "Textile", "Others"]
let COMPANY_AFFILIATION_ARRAY = ["ISRI", "BIR", "CMRA", "BMR", "Others"]


let USER_TAG = "com.myscrap.userTag"


