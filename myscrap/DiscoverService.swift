//
//  DiscoverService.swift
//  myscrap
//
//  Created by MyScrap on 5/14/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
protocol DiscoverDelegate: class {
    func didReceiveData(data: [DiscoverItems])
    func didReceiveError(error: String)
}
class DiscoverService {
    
    weak var delegate: DiscoverDelegate?
    
    
    typealias completionHandler = (_ success: Bool, _ error: String?, _ data: [DiscoverItems]?) -> ()
    
    func getDiscoverCompany(searchText: String, completion: @escaping (APIResult<[DiscoverItems]>) -> ()){
        let service = APIService()
        service.endPoint = Endpoints.DISCOVER_URL
        service.params = "searchText=\(searchText)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                let data = self?.handleJSON(dict: dict)
                completion(APIResult.Success(data!))
            case .Error(let error):
                completion(APIResult.Error(error))
            }
        }
    }
    
    private func handleJSON(dict: [String:AnyObject]) -> [DiscoverItems] {
        var data = [DiscoverItems]()

        if let error = dict["error"] as? Bool{
            if !error{
                if let discoverData = dict["locationData"] as? [[String:AnyObject]]{
                    for disc in discoverData{
                        let value = DiscoverItems(Dict: disc)
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
}
