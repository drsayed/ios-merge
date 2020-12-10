//
//  EditProfile.swift
//  myscrap
//
//  Created by MS1 on 7/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

final class EditProfile{
    
    
    var firstName:String!
    var email:String!
    var lastName:String!
    var designation:String!
    var company:String!
    var userBio:String!
    
    private var _profilePic:String!
    
    
    private var _userInterest:String!
    private var _userInterestRoles:String!
    
    
    
    
    var code :String!
    var phoneNo: String!
    var website: String!
    var userLocation:String!
    var colorCode: String!
    private var _companyId : String!
    var companyName: String!
    var ownerId:String!
    var companyType:String!
    
    
    var companyId:String{
        
        if _companyId == nil{
            _companyId = ""
        }
        
        return _companyId
    }
    
    var userInterest:String{
        
        if _userInterest == nil{
            _userInterest = "0"
        }
        return _userInterest
    }
    
    var userInterestRoles:String{
        
        if _userInterestRoles == nil {
            
            _userInterestRoles = "0"
        }
        
        return _userInterestRoles
    }
    
    
    
    var fullCommodity: [String]!
    
    var profilePic:String{
        
        if _profilePic == nil || _profilePic == "https://myscrap.com/style/images/icons/profile.png" || _profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png"{
            
            _profilePic = ""
        }
        
        return _profilePic
    }
    
    
    
    init(editDict: Dictionary<String,AnyObject>){
        
        if let editprofileData = editDict["EditProfileData"] as? Dictionary<String,AnyObject>{
            
            
            if let firstName = editprofileData["firstName"] as? String{
                
                self.firstName = firstName
            }
            if let email = editprofileData["lastName"] as? String{
                
                self.email = email
            }
            if let lastName = editprofileData["lastName"] as? String{
                
                self.lastName = lastName
            }
            if let designation = editprofileData["designation"] as? String{
                
                self.designation = designation
            }
            if let company = editprofileData["company"] as? String{
                
                self.company = company
            }
            if let userBio = editprofileData["userBio"] as? String{
                
                self.userBio = userBio
            }
            if let profilePic = editprofileData["profilePic"] as? String{
                
                self._profilePic = profilePic
            }
            if let userInterest = editprofileData["userInterest"] as? String{
                
                self._userInterest = userInterest
            }
            if let userinterstroles = editprofileData["userInterestRoles"] as? String{
                
                self._userInterestRoles = userinterstroles
            }
            if let code = editprofileData["code"] as? String{
                self.code = code
            }
            if let phoneNo = editprofileData["phoneNo"] as? String{
                
                self.phoneNo = phoneNo
            }
            if let webSote = editprofileData["website"] as? String{
                
                self.website = webSote
            }
            if let userLocation = editprofileData["userLocation"] as? String{
                
                self.userLocation = userLocation
            }
            if let colorCode = editprofileData["colorCode"] as? String{
                
                self.colorCode = colorCode
            }
            
            
    
            
        }
        
        
        if let EditCompanyProfileData = editDict["EditCompanyProfileData"] as? Dictionary<String,AnyObject>{
            
            if let companyName = EditCompanyProfileData["companyName"] as? String{
                
                self.companyName = companyName
            }
            
            print(self.companyName)
            
            
            if let email = EditCompanyProfileData["email"] as? String{
                
                self.email = email
            }
            if let owerId = EditCompanyProfileData["owerId"] as? String{
                
                self.ownerId = owerId
            }
            if let companyType = EditCompanyProfileData["companyType"] as? String{
                
                self.companyType = companyType
            }
            if let companyBio = EditCompanyProfileData["companyBio"] as? String{
                
                self.userBio = companyBio
            }
            
            if let userInterestRoles = EditCompanyProfileData["userInterestRoles"] as? String{
                
                self._userInterestRoles = userInterestRoles
            }
            if let companyProfilePic = EditCompanyProfileData["companyProfilePic"] as? String{
                
                self._profilePic = companyProfilePic
            }
            if let companyProfilePic = EditCompanyProfileData["companyProfilePic"] as? String{
                
                self._profilePic = companyProfilePic
            }
            if let companyInterest = EditCompanyProfileData["companyInterest"] as? String{
                
                self._userInterest = companyInterest
            }
            if let code = EditCompanyProfileData["code"] as? String{
                self.code = code
            }
            if let phoneNo = EditCompanyProfileData["phoneNo"] as? String{
                
                self.phoneNo = phoneNo
            }
            if let webSote = EditCompanyProfileData["website"] as? String{
                
                self.website = webSote
            }
            if let userLocation = EditCompanyProfileData["companyLocation"] as? String{
                
                self.userLocation = userLocation
            }
            
            
        }
        
        if let companyTag = editDict["companyTag"] as? Dictionary<String,AnyObject>{
            
            if let companyId = companyTag["companyId"] as? String{
                
                self._companyId = companyId
            }
            if let company = companyTag["company"] as? String{
                
                self.company = company
            }
        }
        
        self.fullCommodity =         ["Non-Ferrous metals","Ferrous metals","Stainless Steel","Tyres","Paper","Textiles","Plastic","E-scrap","Red Metals","Aluminum","Zinc","Magnesium","Lead","Nickel/Stainless/Hi Temp","Mixed Metals","Other","Electric Furnace Casting and Foundry Grades","Specially Processed Grades","Cast Iron Grades","Special Boring Grades","Steel From Scrap Tiles","Railroad Ferrous Scrap","Stainless Alloy","Special Alloy","Copper","Construction","Processor","Troll","Laboratory","Supply of IT","Shredder"]
        
    }
    
    
    
    
    
}
