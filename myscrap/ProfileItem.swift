//
//  ProfileItem.swift
//  myscrap
//
//  Created by MS1 on 1/27/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class EditProfileItem{
  
    var firstName: String?
    var email: String?
    var lastName: String?
    var designation: String?
    var company: String?
    var userBio: String?
    var profilePic: String?
    var userInterest: String?
    var userRoles: String?
    var code: String?
    var phoneNumber:String?
    var website:String?
    var companyId:String?
    var userLocation: String?
    var colorCode: String?
    var city: String?
    var userHereFor: String?
    var officePhoneCode: String?
    var officePhoneNumber: String?
    var cardFront: String?
      var cardBack: String?
      var cardShow: String?
      var showPhone: String?
    
    
    var userCommoditiesArray: [String] {
        var array = [String]()
        if let userIntersts = userInterest{
            let string = userIntersts.replacingOccurrences(of: " ", with: "")
            if string != ""{
                   array = string.components(separatedBy: ",")
            }
        }
        return array
    }
    
    var userRolesArray: [String] {
        var array = [String]()
        if let userIntersts = userRoles{
            let string = userIntersts.replacingOccurrences(of: " ", with: "")
            if string != ""{
                array = string.components(separatedBy: ",")
            }
        }
        return array
    }
    
    
    init(dict: [String:AnyObject]) {
        if let firstName = dict["firstName"] as? String{
            self.firstName = firstName
        }
        if let email = dict["email"] as? String{
            self.email = email
        }
        if let lastName = dict["lastName"] as? String{
            self.lastName = lastName
        }
        if let designation = dict["designation"] as? String{
            self.designation = designation
        }
        if let company = dict["company"] as? String{
            self.company = company
        }
        if let userBio = dict["userBio"] as? String{
            self.userBio = userBio
        }
        if let profilePic = dict["profilePic"] as? String{
            self.profilePic = profilePic
        }
        if let userInterest = dict["userInterest"] as? String{
            self.userInterest = userInterest
        }
        if let userInterestRoles = dict["userInterestRoles"] as? String{
            self.userRoles = userInterestRoles
        }
        if let code = dict["code"] as? String{
            self.code = code
        }
        if let code = dict["code"] as? String{
            self.code = code
        }
        if let officePhoneCode = dict["officePhoneCode"] as? String {
            self.officePhoneCode = officePhoneCode
        }
        if let phoneNo = dict["phoneNo"] as? String{
            self.phoneNumber = phoneNo
        }
        if let officePhoneNumber = dict["officePhoneNumber"] as? String {
            self.officePhoneNumber = officePhoneNumber
        }
        if let website = dict["website"] as? String{
            self.website = website
        }
        if let companyId = dict["companyId"] as? String{
            self.companyId = companyId
        }
        if let userLocation = dict["userLocation"] as? String{
            self.userLocation = userLocation
        }
        if let colorCode = dict["colorCode"] as? String{
            self.colorCode = colorCode
        }
        if let city = dict["city"] as? String {
            self.city = city
        }
        if let userHereFor = dict["userHereFor"] as? String {
            self.userHereFor = userHereFor
        }
        if let cardFront = dict["cardFront"] as? String {
                  self.cardFront = cardFront
              }
        if let cardBack = dict["cardBack"] as? String {
                  self.cardBack = cardBack
              }
        if let showPhone = dict["showPhone"] as? String {
                  self.showPhone = showPhone
              }
        if let cardShow = dict["cardShow"] as? String {
                  self.cardShow = cardShow
              }
    }

    typealias completionHandler = ((EditProfileItem?) -> () )
    
    static func getEditProfile(_ completion: @escaping completionHandler) {
        let service = APIService()
        service.endPoint = Endpoints.EDIT_PROFILE_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let editProfileData = dict["EditProfileData"] as? [String:AnyObject]{
                    let profile = EditProfileItem(dict: editProfileData)
                    completion(profile)
                }
            case .Error(_):
                completion(nil)
            }
        }
    }
    
    static func updateProfile(email: String, website: String,country: String, city: String,position:String,lastName:String, firstName:String, phone:String, code:String, officeCode: String, officePhoneNo: String, userInterest:String, userRoles:String,company:String,companyId:String, bio: String,showPhone: String,cardShow: String, cardFront: String,cardBack: String,userHereFor: String, completion: @escaping (Bool,String?) -> Void  ) {
        let service = APIService()
        service.endPoint = Endpoints.EDIT_PROFILE_URL
        
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&dob=&city=\(city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&website=\(website.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&userLocation=\(country.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&designation=\(position)&email=\(email)&gender=&lastName=\(lastName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&firstName=\(firstName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&phoneNo=\(phone)&code=\(code)&officePhoneCode=\(officeCode)&userHereFor=\(userHereFor.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlPathAllowed)!)&cardFront=\(cardFront)&cardBack=\(cardBack)&cardShow=\(cardShow)&phoneShow=\(showPhone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&officePhoneNumber=\(officePhoneNo)&userInterest=\(userInterest)&userRoles=\(userRoles)&company=\(company)&companyId=\(companyId)&userBio=\(bio)"

   
        
        service.getDataWith(completion: { (result) in
            switch result{
            case .Success(let dict):
                DispatchQueue.main.async {
                    let status = dict["status"] as? String
                    if let error = dict["error"] as? Bool {
                        if !error {
                            if let editProfileData = dict["EditProfileData"] as? [String:AnyObject]{
                                let profile = EditProfileItem(dict: editProfileData)
                                if let nm = profile.firstName, let lastnm = profile.lastName {
                                    AuthService.instance.firstname = nm
                                    AuthService.instance.lastName = lastnm

                                }
                                if let cName = profile.company, let cID = profile.companyId {
                                                                  AuthService.instance.companyId = cID
                                                                  AuthService.instance.company = cName

                                                              }
                                if let profilePic = profile.profilePic{
                                    AuthService.instance.profilePic = profilePic
                                }
                            }
                            completion(true, status!)
                        } else {
                            completion(false, status!)
                        }
                    }

                }

            case .Error(_):
                DispatchQueue.main.async {
                    completion(false, "Failed to update the profile")
                }
            }
        })
    }
    static func updateProfileAfterVerify(Param: String, completion: @escaping (Bool,String?) -> Void  ) {
           let service = APIService()
           service.endPoint = Endpoints.EDIT_PROFILE_URL
           
           service.params = Param

           service.getDataWith(completion: { (result) in
               switch result{
               case .Success(let dict):
                   DispatchQueue.main.async {
                       let status = dict["status"] as? String
                       if let error = dict["error"] as? Bool {
                           if !error {
                               if let editProfileData = dict["EditProfileData"] as? [String:AnyObject]{
                                   let profile = EditProfileItem(dict: editProfileData)
                                   if let nm = profile.firstName, let lastnm = profile.lastName {
                                       AuthService.instance.firstname = nm
                                       AuthService.instance.lastName = lastnm

                                   }
                                   if let cName = profile.company, let cID = profile.companyId {
                                                                     AuthService.instance.companyId = cID
                                                                     AuthService.instance.company = cName

                                                                 }
                                   if let profilePic = profile.profilePic{
                                       AuthService.instance.profilePic = profilePic
                                   }
                               }
                               completion(true, status!)
                           } else {
                               completion(false, status!)
                           }
                       }

                   }

               case .Error(_):
                   DispatchQueue.main.async {
                       completion(false, "Failed to update the profile")
                   }
               }
           })
       }
    
}


