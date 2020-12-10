//
//  Companies.swift
//  myscrap
//
//  Created by MS1 on 7/8/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation


final class Companies{
    
    private var _name:String!
    private var _category:String!
    private var _country:String!
    private var _imageURL:String!
    private var _id:String!
    private var _lattitude:String!
    private var _longitude:String!
    private var _state:String!
    
    
    var state:String{
        
        if _state == nil{
            
            _state = ""
        }
        
        return _state
    }
    
    
  
    var id:String{
        if _id == nil{
            
            _id = "'"
        }
        
        return _id
    }
    

    var lattitude:Double{
        
        return Double(_lattitude)!
        
    }
    var longitude:Double{
        
        return Double(_longitude)!
        
    }
    
    
    
    
    var name:String{
        
        if _name == nil{
            
            _name = " "
        }
        return _name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var category:String{
        
        if _category == nil || _category == ""{
            _category = "Recycler"
        }
        
        return _category
    }
    
    var Country:String{
        if _country == nil{
            
            _country = " "
        }
        
        return _country.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var imageURL:String{
        
        if _imageURL == nil {
            
            _imageURL = ""
        }
        
        return _imageURL
    }
    
    
    init(locationdict:Dictionary<String,AnyObject>) {
        
        
        if let image = locationdict["image"] as? String{
            
            self._imageURL = image
        }
        
        if let name = locationdict["name"] as? String{
            
            self._name = name
        }
        if let id = locationdict["id"] as? String{
            
            self._id = id
        }
        if let compnayType = locationdict["companyType"] as? String{
            self._category = compnayType
        }
        if let countr = locationdict["country"] as? String{
            
            self._country = countr
        }
        
        if let latitude = locationdict["latitude"] as? String{
            
            self._lattitude = latitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let longitude = locationdict["longitude"] as? String{
            
            self._longitude = longitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let state = locationdict["state"] as? String{
            
            self._state = state
        }
        

        
    }

}
















