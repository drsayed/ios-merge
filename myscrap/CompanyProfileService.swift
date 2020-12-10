//
//  CompanyProfileService.swift
//  myscrap
//
//  Created by MS1 on 11/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation


protocol CompanyProfileDelegate:class {
    func DidReceiveData(data:String)
    func DidReceiveError(error: String)
}

class CompanyProfileService{
    
    weak var delegate: CompanyProfileDelegate?
    
    func getCompany(companyId:String, completion:@escaping (Bool,String?, CompanyProfileItem?, [PictureURL]?  ) -> ()){
        let service = APIService()
        service.endPoint = Endpoints.COMPANYFEEDS_URL
        service.params = "userId=\(AuthService.instance.userId)&companyId=\(companyId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let json):
                if let error = json["error"] as? Bool{
                    if !error{
                        
                        //Company Details
                        var companyData : CompanyProfileItem?
                        if let data = json["companyData"] as? [String: AnyObject]{
                            let item = CompanyProfileItem(companyDict: data)
                            companyData = item
                        }
                        
                        //Picture Array
                        var pictureURL : [PictureURL]?
                        
                        if let pictures = json["pictureUrl"] as? [[String: AnyObject]]{
                            var pictureData = [PictureURL]()
                            for picture in pictures {
                                let pic = PictureURL(pictureDict: picture)
                                pictureData.append(pic)
                            }
                            pictureURL = pictureData
                        }
                        
                        print(pictureURL?.count ?? "No picture Data" )
                        
                        completion(true, nil , companyData, pictureURL)
                        
                    } else {
                        completion(false, "JSON Error", nil, nil)
                    }
                }
            case .Error(let error):
                completion(false, error, nil, nil)
            }
        }
    }
    
    private func handleJSON(dict: [String:AnyObject]){
        
    }
    
}

