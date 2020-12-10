//
//  CompanyProfileItem.swift
//  myscrap
//
//  Created by MS1 on 11/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

class CompanyProfileItem{
    
    private var _longittude: String?
    private var _lattitude: String?
    
    var companyId:String?
    var ownerUserId:String?
    
    var companyAddress:String?
    
    var companyPhoneNumber:String?
    var companyCountry: String?
    var companyWebsite:String?
    var companyAffiliations: String?
    var companyType: String?
    var companyBio: String?
    var companyInterests: String?
    var companyRoles: String?
    var companyName: String?
    var companyImage: String?
    var isFollowing: Bool = false
    var isJoined: Bool = false
    var isEmployee : Bool = false
    var isFavourite: Bool = false
    var workingHoursTitle: String?
    var workingHours: String?
    var joinRequest: Int?
    var joinedStatus: Int?
    var viewerCount: Int?
    var points: Int?
    var rank: Int?
    var isPartner: Int?
    var partnerCompany: String?
    
    
    
    
    
    var companyLike: Int = 0
    
    var companyEmployees: Int = 0
    

    
    
    var companyLattitude:Double?{
        if let stringLat = _lattitude, let cmpnylat = Double(stringLat){
            return cmpnylat
        }
        return nil
    }
    
    var companyLongitude: Double? {
        if let stringLong = _longittude, let cmpnylong = Double(stringLong){
            return cmpnylong
        }
        return nil
    }
    
    
    var interest:[String]{
        var int = [String]()
        if let intrst = companyInterests{
            let trim = intrst.replacingOccurrences(of: " ", with: "")
            int = trim.components(separatedBy: ",")
        }
        return int
    }
    
    var roles:[String]{
        var int = [String]()
        if let intrst = companyRoles{
            let trim = intrst.replacingOccurrences(of: " ", with: "")
            int = trim.components(separatedBy: ",")
        }
        return int
    }
    
    var affiliation:[String]{
        var int = [String]()
        if let intrst = companyAffiliations{
            let trim = intrst.replacingOccurrences(of: " ", with: "")
            int = trim.components(separatedBy: ",")
        }
        return int
    }
    
    
    
    init() { }
    
    init(companyDict: Dictionary<String,AnyObject>){
        
        if let comapnyId = companyDict["companyId"] as? String{
            self.companyId = comapnyId
        }
        
        if let ownerUserId = companyDict["ownerUserId"] as? String{
            self.ownerUserId = ownerUserId
        }
        
        if let companyLongitude = companyDict["companyLongitude"] as? String{
            self._longittude = companyLongitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let companyName = companyDict["companyName"] as? String{
            self.companyName = companyName
        }
        if let companyType = companyDict["companyType"] as? String{
            self.companyType = companyType
        }
        if let companyPhoneNumber = companyDict["companyPhoneNumber"] as? String{
            self.companyPhoneNumber = companyPhoneNumber
        }
        if let companyWebsite = companyDict["companyWebsite"] as? String{
            self.companyWebsite = companyWebsite
        }
        if let companyBio = companyDict["companyBio"] as? String{
            self.companyBio = companyBio
        }
        if let companyInterests = companyDict["companyInterests"] as? String{
            self.companyInterests = companyInterests
        }
        if let companyLike = companyDict["companyLike"] as? Int{
            self.companyLike = companyLike
        }
        
        if let companyEmployees = companyDict["companyEmployees"] as? Int{
            self.companyEmployees = companyEmployees
        }
        if let comapnyId = companyDict["companyId"] as? String{
            self.companyId = comapnyId
        }
        
        if let companyImage = companyDict["companyImage"] as? String{
            self.companyImage = companyImage
        }
        if let isEmployee = companyDict["isEmployee"] as? Bool{
            self.isEmployee = isEmployee
        }
        if let country = companyDict["companyCountry"] as? String{
            self.companyCountry = country
        }
        if let lattitude = companyDict["companyLatitude"] as? String{
            self._lattitude = lattitude.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let isFollowing = companyDict["isFollowing"] as? Bool{
            self.isFollowing = isFollowing
        }
        if let address = companyDict["companyAddress"] as? String{
            self.companyAddress = address
        }
        
        if let affiliation = companyDict["companyAffiliations"] as? String{
            self.companyAffiliations = affiliation
        }
        if let userInterestRoles = companyDict["userInterestRoles"] as? String{
            self.companyRoles = userInterestRoles
        }
        if let isfavourite = companyDict["isFavourite"] as? Bool{
            self.isFavourite = isfavourite
        }
        if let workingHoursTitle = companyDict["workingHoursTitle"] as? String{
            self.workingHoursTitle = workingHoursTitle
        }
        if let workingHours = companyDict["workingHours"] as? String{
            self.workingHours = workingHours
        }
        if let joinRequest = companyDict["joinRequest"] as? Int{
            self.joinRequest = joinRequest
        }
        if let joinedStatus = companyDict["joinedStatus"] as? Int{
            self.joinedStatus = joinedStatus
        }
        if let viewerCount = companyDict["viewerCount"] as? Int{
            self.viewerCount = viewerCount
        }
        if let points = companyDict["points"] as? Int{
            self.points = points
        }
        if let rank = companyDict["rank"] as? Int{
            self.rank = rank
        }
        if let isPartner = companyDict["isPartner"] as? Int{
            self.isPartner = isPartner
        }
        if let partnerCompany = companyDict["partnerCompany"] as? String{
            self.partnerCompany = partnerCompany
        }
        
    }
    
    func insertCompanyFavourite(){
        guard let id = companyId else { return }
        
        let service = APIService()
        service.endPoint =  Endpoints.INSERT_FAVOURITE_COMPANY_URL
        service.params = "userId=\(AuthService.instance.userId)&companyId=\(id)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("successfully inserted/removed company From Favourite")
            case .Error(_):
                print("Error")
            }
        }
    }
    
}



