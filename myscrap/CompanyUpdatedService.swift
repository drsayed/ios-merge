//
//  CompanyUpdatedService.swift
//  myscrap
//
//  Created by MyScrap on 6/20/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class CompanyUpdatedService {
    
    lazy var service : APIService = {
        return APIService()
    }()
    
    weak var delegate : CompanyUpdatedServiceDelegate?
    
    func getCompanyDetails(companyId: String) {
        let service = APIService()
        service.endPoint = Endpoints.COMPANY_DETAILS //COMPANY_DATA_FETCH_V2
        print("URL :\(service.endPoint)")
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleCompanyListing(dict: dict)
            case .Error(let error):
                print("Company Detail listing error \(error)")
                //self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    typealias feedCompletionHandler = (_ success: Bool, _ error: String?, _ data: [FeedV2Item]?) -> ()
    func getEmployeeFeeds(companyId: String,pageLoad:String, completion: @escaping (APIResult<[FeedV2Item]>) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.COMPANY_EMPLOYEE_FEEDS
        print("URL : \(service.endPoint)")
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)&pageLoad=\(pageLoad)"
        service.getDataWith { (result) in
            switch result {
            case .Success(let dict):
                let data = self.handleFeed(json: dict)
                 completion(APIResult.Success(data))
            case .Error(let error):
                completion(APIResult.Error(error))
            }
        }
    }
    
    func handleFeed(json: [String:AnyObject]) -> [FeedV2Item] {
        var data = [FeedV2Item]()
        if let error = json["error"] as? Bool{
            if !error{
                
                if let feedsData = json["feedsData"] as? [[String:AnyObject]]{
                    
                    for feeds in feedsData{
                        let feed = FeedV2Item(FeedDict: feeds)
                        data.append(feed)
                    }
                }
                return data
            }
        }
        return data
    }
    
    typealias completionHandler = ((CompanyItems?) -> () )
    func adminViewGet(companyId: String, _ completion: @escaping completionHandler)  {
        let service = APIService()
        service.endPoint = Endpoints.COMPANY_GET_ADMIN_VIEW
        print("URL :\(service.endPoint)")
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let companyData = dict["companyData"] as? [String:AnyObject] {
                    let viewItems = CompanyItems(companyDict: companyData)
                    completion(viewItems)
                }
            case .Error(let error):
                print("Company Detail listing error \(error)")
                //self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    typealias handler = ((Bool?) -> () )
    func deleteCompanyPhotos(companyId: String, urlStr : String, _ completion: @escaping handler)  {
        let service = APIService()
        service.endPoint = Endpoints.DELETE_COMPANY_PHOTOS
        print("URL :\(service.endPoint)")
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)&url=\(urlStr)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool {
                    if !error {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
            case .Error(let error):
                completion(false)
            }
        }
    }
    //MARk:- SAVE/UPDATE company details
    func updateCompanyAPI(companyId: String, name: String, about: String, commodity: String, industry: String,affiliation: String, address: String, phone: String, code: String, email: String, website: String, dayOpen: String, dayClose: String, openTime: String, closeTime: String, employeeId : String,companyPhotos: [Media]? , commodityPhotos: [Media]?,  completion: @escaping (Bool) -> ()){
           
    //        let addr = getIFAddresses()
            var ip = ""
            if !AuthService.instance.getIFAddresses().isEmpty{
                ip = AuthService.instance.getIFAddresses().description
            }
            
            
            //let path = Endpoints.COMPANY_UPDATE_ADMIN_VIEW
        let path = "SaveOrUpdateCompanyAdminData"
            let parameters = [
                CompanyPostKeys.userId : AuthService.instance.userId,
                CompanyPostKeys.apiKey : API_KEY,
                CompanyPostKeys.company_id   : companyId,
                CompanyPostKeys.company_name : name,
                CompanyPostKeys.company_about: about,
                CompanyPostKeys.company_commodity: commodity,
                CompanyPostKeys.company_industry: industry,
                CompanyPostKeys.company_affiliation: affiliation,
                CompanyPostKeys.company_address: address,
                CompanyPostKeys.company_phone : phone,
                CompanyPostKeys.company_code: code,
                CompanyPostKeys.company_email: email,
                CompanyPostKeys.company_website: website,
                CompanyPostKeys.company_dayOpen: dayOpen,
                CompanyPostKeys.company_dayClose : dayClose,
                CompanyPostKeys.company_openTime: openTime,
                CompanyPostKeys.company_closeTime: closeTime,
                CompanyPostKeys.company_addEmployeeID : employeeId,
                
                ] as [String : Any]
            
            print("Parameters while add listing : ", CompanyPostKeys.userId, ":", AuthService.instance.userId,
                PostKeys.apiKey, ":", API_KEY,
                CompanyPostKeys.company_id ,   ":", companyId,
                CompanyPostKeys.company_name, ":", name,
                CompanyPostKeys.company_about, ":", about,
                CompanyPostKeys.company_commodity, ":", commodity,
                CompanyPostKeys.company_industry, ":", industry,
                CompanyPostKeys.company_affiliation, ":", affiliation,
                CompanyPostKeys.company_address, ":", address,
                CompanyPostKeys.company_phone, ":", phone,
                CompanyPostKeys.company_code, ":", code,
                CompanyPostKeys.company_email, ":", email,
                CompanyPostKeys.company_website, ":", website,
                CompanyPostKeys.company_dayOpen, ":", dayOpen,
                CompanyPostKeys.company_dayClose, ":",  dayClose,
                CompanyPostKeys.company_openTime, ":", openTime,
                CompanyPostKeys.company_closeTime, ":", closeTime,
                CompanyPostKeys.company_addEmployeeID, ":", employeeId)
        service.getMultipartDataAdminView(with: path, params: parameters as? [String : String], company: companyPhotos, commodity: commodityPhotos) { (result) in
                switch result{
                case .Success(_):
                    DispatchQueue.main.async {
                        completion(true)
                    }
                case .Error(_):
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    
    //MARK:- View Listing JSON
    func handleCompanyListing(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            let status = dict["status"] as? String
            if !error{
                if let companyData = dict["companyData"] as? [String:AnyObject] {
                    
                    var companyItems = [CompanyItems]()
                    let viewItems = CompanyItems(companyDict: companyData)
                    companyItems.append(viewItems)
                    print("Handle Json for Company Detail lists : \(companyItems)")
                    
                    delegate?.didReceiveCompanyValues(data: companyItems)
                }
                
            } else {
                print("Market listing error \(error)")
                self.delegate?.DidReceivedError(error: status!)
            }
        }
    }
    
    //MARK:- Report About Company API
    typealias successHandler = ((Bool?) -> () )
    func reportAboutCompanyAndAdmin(view : UIView,
                                    companyId : String,
                                    reportType : String,
                                    reportDesc: String, completion:@escaping successHandler) {
                    
            let spinner = MBProgressHUD.showAdded(to: view, animated: true)
            spinner.mode = MBProgressHUDMode.indeterminate
            spinner.label.text = "Requesting..."
            let service = APIService()

            let endPoint = Endpoints.REPORT_ABOUT_COMPANY
            
            service.endPoint = endPoint
            if companyId != "" {
                
                service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)&des=\(reportDesc)&type=\(reportType)"
                service.getDataWith { [weak self] (result) in

                    switch result{
                    case .Success(let dict):
                        if let error = dict["error"] as? Bool{
                            
                            DispatchQueue.main.async {
                                MBProgressHUD.hide(for: (view), animated: true)
                            }

                            if !error {
                                DispatchQueue.main.async {
                                    completion(true)
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                completion(false)
                                }
                            }
                        }
                    case .Error(let error):
                        DispatchQueue.main.async {
                            completion(false)
                            MBProgressHUD.hide(for: (view), animated: true)
                        }
                    }
                }
            }
            else {
                completion(false)
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                }
            }
    }
    
    
    //MARK:- Moderator Delete Company Report API
    func deleteCompanyReport(view : UIView,
                                    companyId : String,
                                    reportType : String,
                                        completion:@escaping (Bool?) -> ()) {
                    
            let spinner = MBProgressHUD.showAdded(to: view, animated: true)
            spinner.mode = MBProgressHUDMode.indeterminate
            spinner.label.text = "Requesting..."
            let service = APIService()

            let endPoint = Endpoints.DELETE_COMPANY_REPORT
            
            service.endPoint = endPoint
            if companyId != "" {
                
                service.params = "reportedBy=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)&type=\(reportType)"
                service.getDataWith { [weak self] (result) in

                    switch result{
                    case .Success(let dict):
                        if let error = dict["error"] as? Bool{
                            
                            DispatchQueue.main.async {
                                MBProgressHUD.hide(for: (view), animated: true)
                            }

                            if !error {
                                DispatchQueue.main.async {
                                    completion(true)
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    completion(false)
                                }
                            }
                        }
                    case .Error(let error):
                        DispatchQueue.main.async {
                            completion(false)
                            MBProgressHUD.hide(for: (view), animated: true)
                        }
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                }
            }
    }
    
    //MARK:- Moderator ACCEPT|REJECT new company and company's admin request
    func respondAdminRequest(view:UIView,companyId:String, userID:String, type: String,success: @escaping (String) -> (), failure: @escaping (String) -> ()){
        
        let spinner = MBProgressHUD.showAdded(to: view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Requesting..."
        
        let service = APIService()
        service.endPoint = Endpoints.ACCEPT_OR_REJECT_ADMIN_REQUEST
        service.params = "friendId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)&type=\(type)&userId=\(userID)"
        service.getDataWith {(result) in
            print(result)
            switch result {
            case .Success(let dict):
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: (view), animated: true)
                    success(dict["status"] as? String ?? "")
                }
                
            case .Error(let err):
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: (view), animated: true)
                    failure(err)
                }
            }
        }
    }
}

protocol CompanyUpdatedServiceDelegate: class {
    
    func didReceiveCompanyValues(data: [CompanyItems])
    func DidReceivedError(error: String)
}
