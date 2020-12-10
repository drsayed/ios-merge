//
//  DiscoverItems.swift
//  myscrap
//
//  Created by MyScrap on 5/14/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class DiscoverItems {
    private var _image: String!
    private var _id: String!
    private var _name: String!
    private var _latitude: Double!
    private var _longitude: Double!
    private var _addressOne: String!
    private var _addressTwo: String!
    private var _state: String!
    private var _country: String!
    private var _userLocation: String!
    private var _companyType: String!
    private var _category: String!
    private var _newJoined: String!
    
    var image: String{
        if _image == nil { _image  = "" }; return _image
    }
    var id: String{
        if _id == nil { _id  = "" }; return _id
    }
    var name: String{
        if _name == nil { _name  = "" }; return _name
    }
    var latitude: Double {
        if _latitude == nil { _latitude = 0 } ; return _latitude
    }
    var longitude: Double{
        if _longitude == nil { _longitude = 0 } ; return _longitude
    }
    var addressOne: String{
        if _addressOne == nil { _addressOne  = "" }; return _addressOne
    }
    var addressTwo: String{
        if _addressTwo == nil { _addressTwo  = "" }; return _addressTwo
    }
    var state: String{
        if _state == nil { _state  = "" }; return _state
    }
    var country: String{
        if _country == nil { _country  = "" }; return _country
    }
    var userLocation: String{
        if _userLocation == nil { _userLocation  = "" }; return _userLocation
    }
    var companyType: String{
        if _companyType == nil { _companyType  = "" }; return _companyType
    }
    var category: String{
        if _category == nil { _category  = "" }; return _category
    }
    var newJoined: String{
        if _newJoined == nil { _newJoined  = "" }; return _newJoined
    }
    
    
    
    init(Dict:Dictionary<String,AnyObject>) {
        
        var trimmedLattitude = ""
        var trimmedLongitude = ""
        
        if let lattitude = Dict["latitude"] as? String{
            trimmedLattitude = lattitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let longitude = Dict["longitude"] as? String{
            trimmedLongitude = longitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if trimmedLongitude.count > 1 && trimmedLattitude.count > 1{
            self._latitude = Double(trimmedLattitude)!
            self._longitude = Double(trimmedLongitude)!
            
            if let image = Dict["image"] as? String{
                _image = image
            }
            if let id = Dict["id"] as? String{
                _id = id
            }
            if let name = Dict["name"] as? String{
                _name = name
            }
            if let addressOne = Dict["addressOne"] as? String{
                _addressOne = addressOne
            }
            if let addressTwo = Dict["addressTwo"] as? String{
                _addressTwo = addressTwo
            }
            if let state = Dict["state"] as? String{
                _state = state
            }
            if let country = Dict["country"] as? String{
                _country = country
            }
            if let userLocation = Dict["userLocation"] as? String{
                _userLocation = userLocation
            }
            if let companyType = Dict["companyType"] as? String{
                _companyType = companyType
            }
            if let category = Dict["category"] as? String{
                _category = category
            }
            if let newJoined = Dict["newJoined"] as? String{
                _newJoined = newJoined
            }
        }
        
        
        
        
    }
}
