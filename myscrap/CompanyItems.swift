//
//  CompanyItems.swift
//  myscrap
//
//  Created by MyScrap on 6/20/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class CompanyItems {
    private var _companyType: String!
    private var _businessType:String!
    private  var _commodity:String!
    private var _adminAffiliation:String!
    private var _affiliation: [String]!
    
    private var _totalReview: String!
    private var _totalRatingCount: String!
    private var _AvgRating: String!
    private var _verified: Bool!
    private var _years: String!
    private var _employeeCount: Int!
    private var _officeOpen: Bool!
    private var _isEmployeeView: Bool!
    private var _isAdminView: Bool!
    private var _isAdminAvailable: Bool!
    private var _openTimingDay: String!
    private var _openTiming: String!
    private var _commodityAdminImage: String!
    private var _commodityImageCount: Int!
    private var _officeTimings : [String]!
    private var _officeOpenDay:String!
    private var _officeCloseDay:String!
    private var _adminOfficeOpen:String!
    private var _adminOfficeClose:String!
    private var _place: String!
    private var _lat: Double!
    private var _long: Double!
    private var _address: String!
    private var _code: String!
    private var _phone: String!
    private var _email: String!
    private var _website: String!
    private var _membershipType: String!
    private var _membershipYears: String!
    private var _membershipYearsCount: String!
    private var _compnayId: String!
    private var _compnayName: String!
    private var _compnayAbout: String!
    private var _companyImages: [String]!
     private var _commodityImages: [String]!
    
    //Company Interest Tab
    private var _businessTypeInterest: String!
    private var _commodityInterest: String!
    private var _affiliationInterest: String!
    
    //var companyImages = [Company_Images]()
    var employees = [Employees]()
    var interest = [Interest]()
    var reviews = [Reviews]()
    var ratingValues = [RatingValues]()
    
    var adminReport : String!
    var ownCompanyRequest : String!
    var companyOwnerId : String!
    
    var reportedBy : String!
    var reportedType : String!
    var reportedUserId : String!

    var reportedReason : String!

    var reportedStatusOfCompany : String!

    var companyProfilePic : String!

    var companyType:String{
        if _companyType == nil { _companyType = "" } ; return _companyType
    }
    var businessType:String{
        if _businessType == nil { _businessType = ""}; return _businessType
    }
    var businessTypeArray: [String] {
        var array = [String]()
        let string = businessType.replacingOccurrences(of: " ", with: "")
        if string != ""{
            array = string.components(separatedBy: ",")
        }
        return array
    }
    var commodity:String {
        if _commodity == nil { _commodity = ""}; return _commodity
    }
    var commodityArray: [String] {
        var array = [String]()
        let string = commodity.replacingOccurrences(of: " ", with: "")
        if string != ""{
            array = string.components(separatedBy: ",")
        }
        return array
    }
    var adminAffiliation:String{
        if _adminAffiliation == nil { _adminAffiliation = ""}; return _adminAffiliation
    }
    var affiliationArray: [String] {
           var array = [String]()
           let string = adminAffiliation.replacingOccurrences(of: " ", with: "")
           if string != ""{
               array = string.components(separatedBy: ",")
           }
           return array
       }
    var affiliation:[String]{
        if _affiliation == nil { _affiliation = [""] } ; return _affiliation
    }
    var totalReview:String{
        if _totalReview == nil { _totalReview = "" } ; return _totalReview
    }
    var totalRatingCount:String{
        if _totalRatingCount == nil { _totalRatingCount = "" } ; return _totalRatingCount
    }
    var AvgRating:String{
        if _AvgRating == nil { _AvgRating = "" } ; return _AvgRating
    }
    var verified:Bool{
        if _verified == nil { _verified = false } ; return _verified
    }
    var years:String{
        if _years == nil { _years = "" } ; return _years
    }
    var employeeCount:Int{
        if _employeeCount == nil { _employeeCount = 0 } ; return _employeeCount
    }
    var officeOpen:Bool{
        if _officeOpen == nil { _officeOpen = false } ; return _officeOpen
    }
    var isEmployeeView:Bool{
        if _isEmployeeView == nil { _isEmployeeView = false } ; return _isEmployeeView
    }
    var isAdminView:Bool{
        if _isAdminView == nil { _isAdminView = false } ; return _isAdminView
    }
    var isAdminAvailable:Bool{
        if _isAdminAvailable == nil { _isAdminAvailable = false } ; return _isAdminAvailable
    }
    var openTimingDay:String {
        if _openTimingDay == nil { _openTimingDay = "" } ; return _openTimingDay
    }
    var openTiming:String {
        if _openTiming == nil { _openTiming = "" } ; return _openTiming
    }
    var commodityAdminImage:String {
        if _commodityAdminImage == nil { _commodityAdminImage = "" } ; return _commodityAdminImage
    }
    var commodityImageCount:Int{
        if _commodityImageCount == nil { _commodityImageCount = 0 } ; return _commodityImageCount
    }
    var officeTimings:[String]{
        if _officeTimings == nil { _officeTimings = [""] } ; return _officeTimings
    }
    var officeOpenDay:String {
        if _officeOpenDay == nil { _officeOpenDay = "" } ; return _officeOpenDay
    }
    var officeCloseDay:String {
        if _officeCloseDay == nil { _officeCloseDay = "" } ; return _officeCloseDay
    }
    var adminOfficeOpen:String {
        if _adminOfficeOpen == nil { _adminOfficeOpen = "" } ; return _adminOfficeOpen
    }
    var adminOfficeClose:String {
        if _adminOfficeClose == nil { _adminOfficeClose = "" } ; return _adminOfficeClose
    }
    
    var place:String{
        if _place == nil { _place = "" } ; return _place
    }
    var lat:Double{
        if _lat == nil { _lat = 0.0 } ; return _lat
    }
    var long:Double{
        if _long == nil { _long = 0.0 } ; return _long
    }
    var address:String{
        if _address == nil { _address = "" } ; return _address
    }
    var code:String {
        if _code == nil { _code = ""}; return _code
    }
    var phone:String{
        if _phone == nil { _phone = "" } ; return _phone
    }
    var email:String{
        if _email == nil { _email = "" } ; return _email
    }
    var website:String{
        if _website == nil { _website = "" } ; return _website
    }
    var membershipType:String{
        if _membershipType == nil { _membershipType = "" } ; return _membershipType
    }
    var membershipYears:String{
        if _membershipYears == nil { _membershipYears = "" } ; return _membershipYears
    }
    var membershipYearsCount:String{
        if _membershipYearsCount == nil { _membershipYearsCount = "" } ; return _membershipYearsCount
    }
    var compnayId:String{
        if _compnayId == nil { _compnayId = "" } ; return _compnayId
    }
    var compnayAbout:String{
        if _compnayAbout == nil { _compnayAbout = "" } ; return _compnayAbout
    }
    var compnayName:String{
        if _compnayName == nil { _compnayName = "" } ; return _compnayName
    }
    var companyImages:[String]{
        if _companyImages == nil { _companyImages = [""] } ; return _companyImages
    }
    var commodityImages:[String]{
        if _commodityImages == nil { _commodityImages = [""] } ; return _commodityImages
    }
    
    //Company Interest Tab
    var businessTypeInterest:[String]{
        var busType: [String]!
        if _businessTypeInterest == nil || _businessTypeInterest == ""{ busType = [String]() } else {
            let trim = _businessTypeInterest.replacingOccurrences(of: " ", with: "")
            busType = trim.components(separatedBy: "/")
        }
        return busType
    }
    var commodityInterest:[String]{
        var com: [String]!
        if _commodityInterest == nil || _commodityInterest == ""{ com = [String]() } else {
            let trim = _commodityInterest.replacingOccurrences(of: " ", with: "")
            com = trim.components(separatedBy: "/")
        }
        return com
    }
    var affiliationInterest:[String]{
        var aff: [String]!
        if _affiliationInterest == nil || _affiliationInterest == ""{ aff = [String]() } else {
            let trim = _affiliationInterest.replacingOccurrences(of: " ", with: "")
            aff = trim.components(separatedBy: "/")
        }
        return aff
    }
    
    var mediaAllImagesArray : [PictureURL]?
    var mediaCompanyImagesArray : [PictureURL]?
    var mediaCommodityImagesArray : [PictureURL]?
    var mediaEmployeesImagesArray : [PictureURL]?

    init(companyDict:Dictionary<String,AnyObject>) {
        if let companyType = companyDict["companyType"] as? String{
            self._companyType = companyType
        }
        if let businessType = companyDict["businessType"] as? String {
            self._businessType = businessType
        }
        if let commodity = companyDict["commodity"] as? String {
            self._commodity = commodity
        }
        if let adminAffiliation = companyDict["affiliation"] as? String {
            self._adminAffiliation = adminAffiliation
        }
        if let affiliation = companyDict["affiliation"] as? [String]{
            self._affiliation = affiliation
        }
        if let totalReview = companyDict["totalReview"] as? String{
            self._totalReview = totalReview
        }
        if let totalRatingCount = companyDict["totalRatingCount"] as? String{
            self._totalRatingCount = totalRatingCount
        }
        if let AvgRating = companyDict["AvgRating"] as? String{
            self._AvgRating = AvgRating
        }
        if let verified = companyDict["verified"] as? Bool{
            self._verified = verified
        }
        if let years = companyDict["years"] as? String{
            self._years = years
        }
        if let employeeCount = companyDict["employeeCount"] as? Int{
            self._employeeCount = employeeCount
        }
        if let officeOpen = companyDict["officeOpen"] as? Bool{
            self._officeOpen = officeOpen
        }
        if let isEmployeeView = companyDict["isEmployeeView"] as? Bool{
            self._isEmployeeView = isEmployeeView
        }
        if let isAdminView = companyDict["isAdminView"] as? Bool{
            self._isAdminView = isAdminView
        }
        if let isAdminAvailable = companyDict["isAdminAvailable"] as? Bool{
            self._isAdminAvailable = isAdminAvailable
        }
        if let openTimingDay = companyDict["openTimingDay"] as? String{
                   self._openTimingDay = openTimingDay
        }
        if let openTiming = companyDict["openTiming"] as? String{
                   self._openTiming = openTiming
        }
        if let commodityAdminImage = companyDict["commodityAdminImage"] as? String{
                   self._commodityAdminImage = commodityAdminImage
        }
        if let commodityImageCount = companyDict["commodityImageCount"] as? Int{
            self._commodityImageCount = commodityImageCount
        }
        if let officeTimings = companyDict["officeTimings"] as? [String]{
            self._officeTimings = officeTimings
        }
        if let officeOpenDay = companyDict["officeOpenDay"] as? String{
                   self._officeOpenDay = officeOpenDay
        }
        if let officeCloseDay = companyDict["officeCloseDay"] as? String{
                   self._officeCloseDay = officeCloseDay
        }
        if let adminOfficeOpen = companyDict["officeOpen"] as? String {
            self._adminOfficeOpen = adminOfficeOpen
        }
        if let adminOfficeClose = companyDict["officeClose"] as? String {
            self._adminOfficeClose = adminOfficeClose
        }
        if let place = companyDict["place"] as? String{
            self._place = place
        }
        if let lat = companyDict["lat"] as? String{
            self._lat = Double(lat)
        }
        if let long = companyDict["long"] as? String{
            self._long = Double(long)
        }
        if let address = companyDict["address"] as? String{
            self._address = address
        }
        if let code = companyDict["code"] as? String {
            self._code = code
        }
        if let phone = companyDict["phone"] as? String{
            self._phone = phone
        }
        if let email = companyDict["email"] as? String{
            self._email = email
        }
        if let website = companyDict["website"] as? String{
            self._website = website
        }
        if let membershipType = companyDict["membershipType"] as? String{
            self._membershipType = membershipType
        }
        if let membershipYears = companyDict["membershipYears"] as? String{
            self._membershipYears = membershipYears
        }
        if let membershipYearsCount = companyDict["membershipYearsCount"] as? String{
            self._membershipYearsCount = membershipYearsCount
        }
        if let compnayAbout = companyDict["compnayAbout"] as? String{
            self._compnayAbout = compnayAbout
        }
        if let compnayId = companyDict["compnayId"] as? String{
            self._compnayId = compnayId
        }
        if let compnayName = companyDict["compnayName"] as? String{
            self._compnayName = compnayName
        }
        if let companyImages = companyDict["companyImages"] as? [String]{
            self._companyImages = companyImages
        }
        if let commodityImages = companyDict["commodityImages"] as? [String]{
            self._commodityImages = commodityImages
        }
        
        //Company Interest Tab
        if let businessTypeInterest = companyDict["businessTypeInterest"] as? String{
            self._businessTypeInterest = businessTypeInterest
        }
        if let commodityInterest = companyDict["commodityInterest"] as? String{
            self._commodityInterest = commodityInterest
        }
        if let affiliationInterest = companyDict["affiliationInterest"] as? String{
            self._affiliationInterest = affiliationInterest
        }
        
        if let employObj = companyDict["employees"] as? [[String: AnyObject]]{
            for val in employObj {
                let employItems = Employees(dict: val)
                employees.append(employItems)
            }
        }
        if let interObj = companyDict["interest"] as? [String: AnyObject]{
            let interItems = Interest(dict: interObj)
            interest.append(interItems)
        }
        if let reviewsObj = companyDict["reviews"] as? [String: AnyObject]{
            let reviewsItems = Reviews(dict: reviewsObj)
            reviews.append(reviewsItems)
        }
        if let ratingObj = companyDict["rattingValues"] as? [[String: AnyObject]]{
            for val in ratingObj {
                let ratingItems = RatingValues(dict: val)
                ratingValues.append(ratingItems)
            }
        }
        if let companyAllImages = companyDict["all_photos"] as? [String] {
            var data = [PictureURL]()
            for item in companyAllImages {
                let employeesPic = PictureURL(urlString: item)
                data.append(employeesPic)
            }
            self.mediaAllImagesArray = data
        }
        
        if let companyImages = companyDict["companyImages"] as? [String] {
            var data = [PictureURL]()
            for item in companyImages {
                let employeesPic = PictureURL(urlString: item)
                data.append(employeesPic)
            }
            self.mediaCompanyImagesArray = data
        }
        
        if let commodityImages = companyDict["commodityAdminImage"] as? [String] {
            var data = [PictureURL]()
            for item in commodityImages {
                let employeesPic = PictureURL(urlString: item)
                data.append(employeesPic)
            }
            self.mediaCommodityImagesArray = data
        }
        
        if let companyEmployeImages = companyDict["employee_images"] as? [String] {
            
            var data = [PictureURL]()
            for item in companyEmployeImages {
                let employeesPic = PictureURL(urlString: item)
                data.append(employeesPic)
            }
            self.mediaEmployeesImagesArray = data
        }

        let adminReport = JSONUtils.GetStringFromObject(object: companyDict, key: "adminReport")
        self.adminReport = adminReport
        
        let ownCompanyRequest = JSONUtils.GetStringFromObject(object: companyDict, key: "ownReq")
        self.ownCompanyRequest = ownCompanyRequest
        
        let companyOwnerId = JSONUtils.GetStringFromObject(object: companyDict, key: "ownerId")
        self.companyOwnerId = companyOwnerId

        let reportedByStr = JSONUtils.GetStringFromObject(object: companyDict, key: "reportedby")
        self.reportedBy = reportedByStr
        
        let reportedTypeStr = JSONUtils.GetStringFromObject(object: companyDict, key: "reportedtype")
        self.reportedType = reportedTypeStr

        let reportedUserIdStr = JSONUtils.GetStringFromObject(object: companyDict, key: "reportedUserId")
        self.reportedUserId = reportedUserIdStr

        self.companyProfilePic = JSONUtils.GetStringFromObject(object: companyDict, key: "companyProfilePic")

        self.reportedReason = JSONUtils.GetStringFromObject(object: companyDict, key: "reportReason")

        self.reportedStatusOfCompany = JSONUtils.GetStringFromObject(object: companyDict, key: "reportedStatus")

    }
}
class Company_Images {
    
}
class Employees {
    private var _userId: String!
    private var _colorcode: String!
    private var _first_name: String!
    private var _last_name: String!
    private var _name: String!
    private var _initials: String!
    private var _profilePic: String!
    private var _designation: String!
    private var _companyName: String!
    private var _country: String!
    private var _rank: String!
    private var _isAdmin: Bool!
    private var _isAdminView: Bool!
    private var _isEmployeeView: Bool!
    
    var reportOfCompanyAdmin : String = ""

    var userId:String{
        if _userId == nil { _userId = "" } ; return _userId
    }
    var colorcode:String{
        if _colorcode == nil { _colorcode = "" } ; return _colorcode
    }
    var first_name:String{
        if _first_name == nil { _first_name = "" } ; return _first_name
    }
    var last_name:String{
        if _last_name == nil { _last_name = "" } ; return _last_name
    }
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var initials:String{
        if _initials == nil { _initials = "" } ; return _initials
    }
    var profilePic:String{
        if _profilePic == nil { _profilePic = "" } ; return _profilePic
    }
    var designation:String{
        if _designation == nil { _designation = "" } ; return _designation
    }
    var companyName:String{
        if _companyName == nil { _companyName = "" } ; return _companyName
    }
    var country:String{
        if _country == nil { _country = "" } ; return _country
    }
    var rank:String{
        if _rank == nil { _rank = "" } ; return _rank
    }
    
    var isAdmin:Bool {
        if _isAdmin == nil { _isAdmin = false}; return _isAdmin
    }
    var isAdminView:Bool {
        if _isAdminView == nil { _isAdminView = false}; return _isAdminView
    }
    var isEmployeeView:Bool {
        if _isEmployeeView == nil { _isEmployeeView = false}; return _isEmployeeView
    }
    
    init(dict: [String: AnyObject]){
        if let userId = dict["userId"] as? String{
            self._userId = userId
        }
        if let colorcode = dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let first_name = dict["first_name"] as? String{
            self._first_name = first_name
        }
        if let last_name = dict["last_name"] as? String{
            self._last_name = last_name
        }
        if let name = dict["name"] as? String{
            self._name = name
        }
        if let initials = dict["initials"] as? String{
            self._initials = initials
        }
        if let profilePic = dict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let designation = dict["designation"] as? String{
            self._designation = designation
        }
        if let companyName = dict["companyName"] as? String{
            self._companyName = companyName
        }
        if let country = dict["country"] as? String{
            self._country = country
        }
        if let rank = dict["rank"] as? String{
            self._rank = rank
        }
        if let isAdmin = dict["isAdmin"] as? Bool {
            self._isAdmin = isAdmin
        }
        if let isAdminView = dict["isAdminView"] as? Bool {
            self._isAdminView = isAdminView
        }
        if let isEmployeeView = dict["isEmployeeView"] as? Bool {
            self._isEmployeeView = isEmployeeView
        }
        reportOfCompanyAdmin = JSONUtils.GetStringFromObject(object: dict, key: "adminreport")
    }
}
class Interest {
    private var _commodity: [String]!
    private var _industry: [String]!
    private var _affiliation: [String]!
    
    
    var commodity:[String]{
        if _commodity == nil { _commodity = [""] } ; return _commodity
    }
    var industry:[String]{
        if _industry == nil { _industry = [""] } ; return _industry
    }
    var affiliation:[String]{
        if _affiliation == nil { _affiliation = [""] } ; return _affiliation
    }
    
    init(dict: [String:AnyObject]) {
        if let commodity = dict["commodity"] as? [String]{
            self._commodity = commodity
        }
        if let industry = dict["industry"] as? [String]{
            self._industry = industry
        }
        if let affiliation = dict["affiliation"] as? [String]{
            self._affiliation = affiliation
        }
    }
}
class Reviews {
    private var _first_name: String!
    private var _last_name: String!
    private var _name: String!
    private var _initials: String!
    private var _profilePic: String!
    private var _reviewText: String!
    private var _ratting: String!
    private var _date: String!
    
    
    var first_name:String{
        if _first_name == nil { _first_name = "" } ; return _first_name
    }
    var last_name:String{
        if _last_name == nil { _last_name = "" } ; return _last_name
    }
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var initials:String{
        if _initials == nil { _initials = "" } ; return _initials
    }
    var profilePic:String{
        if _profilePic == nil { _profilePic = "" } ; return _profilePic
    }
    var reviewText:String{
        if _reviewText == nil { _reviewText = "" } ; return _reviewText
    }
    var ratting:String{
        if _ratting == nil { _ratting = "" } ; return _ratting
    }
    var date:String{
        if _date == nil { _date = "" } ; return _date
    }
    
    
    init(dict: [String: AnyObject]){
        if let first_name = dict["first_name"] as? String{
            self._first_name = first_name
        }
        if let last_name = dict["last_name"] as? String{
            self._last_name = last_name
        }
        if let name = dict["name"] as? String{
            self._name = name
        }
        if let initials = dict["initials"] as? String{
            self._initials = initials
        }
        if let profilePic = dict["profilePic"] as? String{
            self._profilePic = profilePic
        }
        if let reviewText = dict["reviewText"] as? String{
            self._reviewText = reviewText
        }
        if let ratting = dict["ratting"] as? String{
            self._ratting = ratting
        }
        if let date = dict["date"] as? String{
            self._date = date
        }
    }
}
class RatingValues {
    private var _rattingLable: String!
    private var _rattingValue: String!
    private var _ratingPercentage: String!
    
    
    var rattingLable:String{
        if _rattingLable == nil { _rattingLable = "" } ; return _rattingLable
    }
    var rattingValue:String{
        if _rattingValue == nil { _rattingValue = "" } ; return _rattingValue
    }
    var ratingPercentage:String{
        if _ratingPercentage == nil { _ratingPercentage = "" } ; return _ratingPercentage
    }
    
    init(dict: [String: AnyObject]){
        if let rattingLable = dict["rattingLable"] as? String{
            self._rattingLable = rattingLable
        }
        if let rattingValue = dict["rattingValue"] as? String{
            self._rattingValue = rattingValue
        }
        if let ratingPercentage = dict["ratingPercentage"] as? String{
            self._ratingPercentage = ratingPercentage
        }
    }
}
