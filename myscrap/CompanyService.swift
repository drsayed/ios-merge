//
//  CompanyService.swift
//  myscrap
//
//  Created by MS1 on 10/21/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
protocol CompanyDelegate: class {
    func didReceiveData(data: [CompanyItem])
    func didReceiveError(error: String)
}
protocol CompanyDelegateFetch: class {
    var companyTableView: UITableView { get }
//    var companyDataSource: [CompanyItem] { get set }
}
class CompanyService{
    
    weak var delegate: CompanyDelegate?
    weak var companydel: CompanyDelegateFetch?
    
    
    func getCompanies(){
        let service = APIService()
        service.endPoint = Endpoints.COMPANY_LIST
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleJSON(dict: dict)
            case .Error(let error):
                self?.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    func getFavourites(){
        let service = APIService()
        service.endPoint =  Endpoints.FavouriteCompany
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleJSON(dict: dict)
            case .Error(let error):
                self?.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    private func handleJSON(dict: [String:AnyObject]) -> [CompanyItem] {
        var data = [CompanyItem]()
        var country = [CountryItem]()
        if let error = dict["error"] as? Bool{
            if !error{
                if let companyData = dict["locationData"] as? [[String:AnyObject]]{
                    for comp in companyData{
                        let value = CompanyItem(companyDict: comp)
                        data.append(value)
                    }
                }
                return data
            } else {
                self.delegate?.didReceiveError(error: "error while company fetch")
            }
        }
        return data
    }
    
    private func handleCountryJSON(dict: [String:AnyObject]) -> [CountryItem] {
        var country = [CountryItem]()
        
        if let error = dict["error"] as? Bool{
            if !error{
                if let countryData = dict["countryData"] as? [[String:AnyObject]]{
                    for countData in countryData {
                        let value = CountryItem(countryDict: countData)
                        country.append(value)
                    }
                }
                return country
            }
        }
        return country
    }
    
    
    
    
//    typealias companyCompletion = (([CompanyItem]?, _ error:String?) -> Void )
    typealias completionHandler = (_ success: Bool, _ error: String?, _ data: [CompanyItem]?) -> ()
    typealias signUPcompletionHandler = (_ success: Bool, _ error: String?, _ data: [SignUPCompanyItem]?) -> ()
    typealias countryCompletion = (_ success: Bool, _ error: String?, _ data: [CountryItem]?) -> ()
    
    func getAllCompanies(pageLoad: String, searchText: String, countryFilter: String, completion: @escaping (APIResult<[CompanyItem]>) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.COMPANY_LIST
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=\(pageLoad)&searchText=\(searchText)&countryFilter=\(countryFilter)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let data = self.handleJSON(dict: dict)
                completion(APIResult.Success(data))
            case .Error(let error):
                completion(APIResult.Error(error))
            }
        }
    }
    
    func getSignUPCompanyLists(pageLoad: String, searchText: String, completion: @escaping (APIResult<[SignUPCompanyItem]>) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.SIGNUP_COMPANY_LIST
        service.params = "apiKey=\(API_KEY)&pageLoad=\(pageLoad)&searchText=\(searchText)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let data = self.handleSignUPJSON(dict: dict)
                completion(APIResult.Success(data))
            case .Error(let error):
                completion(APIResult.Error(error))
            }
        }
    }
    
    private func handleSignUPJSON(dict: [String:AnyObject]) -> [SignUPCompanyItem] {
        var data = [SignUPCompanyItem]()
        if let error = dict["error"] as? Bool{
            if !error{
                DispatchQueue.main.async {
                    do {
                        let companyLoad = CompanySignupLoad()
                        let data1 =  try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                        print(convertedString ?? "defaultvalue")
                        companyLoad.companyString = convertedString!
                        print("Feeds JSON String : \(companyLoad.companyString)")
                        try! uiRealm.write {
                            uiRealm.add(companyLoad)
                        }
                    } catch let myJSONError {
                        print(myJSONError)
                    }
                }

                if let companyData = dict["locationData"] as? [[String:AnyObject]]{
                    for comp in companyData{
                        let value = SignUPCompanyItem(companyDict: comp)
                        data.append(value)
                    }
                }
                return data
            } else {
                self.delegate?.didReceiveError(error: "error while company fetch")
            }
        }
        return data
    }
    
    func getAllCountry(pageLoad: String, searchText: String, countryFilter: String, completion: @escaping (APIResult<[CountryItem]>) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.COMPANY_LIST
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=\(pageLoad)&searchText=\(searchText)&countryFilter=\(countryFilter)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let data = self.handleCountryJSON(dict: dict)
                completion(APIResult.Success(data))
            case .Error(let error):
                completion(APIResult.Error(error))
            }
        }
    }
    
}


