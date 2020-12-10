//
//  CompanyItem.swift
//  myscrap
//
//  Created by MS1 on 10/21/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
class CompanyItem: Equatable {
    static func == (lhs: CompanyItem, rhs: CompanyItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    private var _name: String!
    private var _id: String!
    private var _lattitude : Double!
    private var _longitude: Double!
    private var _addressOne: String!
    private var _addressTwo: String!
    private var _state: String!
    private var _country: String!
    private var _userLocation: String!
    private var _category: String!
    private var _isFavourite: Bool!
    private var _companyType:String!
    private var _newJoined:Bool!
    private var _image:String!
    
    var id: String{
        if _id == nil { _id  = "" }; return _id
    }
    var companyType:String{
        if _companyType == nil { _companyType = "" } ; return _companyType
    }
    var newJoined:Bool{
        if _newJoined == true { _newJoined = true } ; return _newJoined
    }
    var image:String{
        if _image == nil { _image = "" } ; return _image
    }
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var lattitude: Double {
        if _lattitude == nil { _lattitude = 0 } ; return _lattitude
    }
    var longitude: Double{
        if _longitude == nil { _longitude = 0 } ; return _longitude
    }
    var addressOne: String{
        if _addressOne == nil{ _addressOne = ""} ; return _addressOne
    }
    var addressTwo: String{
        if _addressTwo == nil { _addressTwo = "" }; return _addressTwo
    }
    var state: String{
        if _state == nil { _state = " " }; return _state
    }
    var country: String{
        if _country == nil { _country = "" }; return _country
    }
    var userLocation: String {
        if _userLocation == nil { _userLocation = ""}; return _userLocation
    }
    var category: String {
        if _category == nil || _category == "" { _category = "Recycler"}; return _category
    }
    var isFavourite: Bool {
        if _isFavourite == nil { _isFavourite = false } ; return _isFavourite
    }
    
    init(companyDict:Dictionary<String,AnyObject>) {
        
        var trimmedLattitude = ""
        var trimmedLongitude = ""
        
        if let lattitude = companyDict["latitude"] as? String{
            trimmedLattitude = lattitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let longitude = companyDict["longitude"] as? String{
            trimmedLongitude = longitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let longitude = companyDict["longitude"] as? String{
            trimmedLongitude = longitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        
        if trimmedLongitude.count > 1 && trimmedLattitude.count > 1{
            self._lattitude = Double(trimmedLattitude)!
            self._longitude = Double(trimmedLongitude)!
            
            if let companyType = companyDict["companyType"] as? String{
                self._companyType = companyType
            }
            if let newJoined = companyDict["newJoined"] as? Bool{
                self._newJoined = newJoined
            }
            if let image = companyDict["image"] as? String{
                self._image = image
            }
            if let id = companyDict["id"] as? String{
                self._id = id
            }
            if let name = companyDict["name"] as? String{
                self._name = name
            }
            if let addressOne = companyDict["addressOne"] as? String{
                self._addressOne = addressOne
            }
            if let addressTwo = companyDict["addressTwo"] as? String{
                self._addressTwo = addressTwo
            }
            if let state = companyDict["state"] as? String{
                self._state = state
            }
            if let country = companyDict["country"] as? String{
                self._country = country
            }
        }
        
    }
}
class SignUPCompanyItem: Equatable {
    static func == (lhs: SignUPCompanyItem, rhs: SignUPCompanyItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    private var _name: String!
    private var _id: String!
    private var _country: String!
    private var _companyType:String!
    private var _image:String!
    
    var id: String{
        if _id == nil { _id  = "" }; return _id
    }
    var companyType:String{
        if _companyType == nil { _companyType = "" } ; return _companyType
    }
    var image:String{
        if _image == nil { _image = "" } ; return _image
    }
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var country: String{
        if _country == nil { _country = "" }; return _country
    }
    
    init(companyDict:Dictionary<String,AnyObject>) {
        if let companyType = companyDict["companyType"] as? String{
            self._companyType = companyType
        }
        if let image = companyDict["image"] as? String{
            self._image = image
        }
        if let id = companyDict["id"] as? String{
            self._id = id
        }
        if let name = companyDict["name"] as? String{
            self._name = name
        }
        if let country = companyDict["country"] as? String{
            self._country = country
        }
        
    }
}

class CountryItem {
    
    //Country Filter
    private var _countryName : String!
    private var _country_id : String!
    private var _totalCompany : String!
    
    var countryName: String{
        if _countryName == nil { _countryName  = "" }; return _countryName
    }
    
    var country_id: String{
        if _country_id == nil { _country_id  = "" }; return _country_id
    }
    
    var totalCompany: String{
        if _totalCompany == nil { _totalCompany  = "" }; return _totalCompany
    }
    
    init(countryDict:Dictionary<String,AnyObject>) {
        
        
        if let countryName = countryDict["countryName"] as? String{
            _countryName = countryName
        }
        
        if let country_id = countryDict["country_id"] as? String{
            _country_id = country_id
        }
        
        if let totalCompany = countryDict["totalCompany"] as? String{
            _totalCompany = totalCompany
        }
        
        
    }
    
}
