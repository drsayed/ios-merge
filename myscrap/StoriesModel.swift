//
//  StoriesModel.swift
//  myscrap
//
//  Created by MyScrap on 2/20/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

protocol StoriesModelDelegate : class {
    func DidReceiveError(error: String)
    func DidReceiveStories(item: [StoriesList])
    
}

class StoriesModel {
    weak var delegate: StoriesModelDelegate?
    
    func getStories() {
        let service = APIService()
        service.endPoint =  Endpoints.RECENT_STORIES
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        print("URL : \(service.endPoint), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleResult(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    
    private func handleResult(dict: [String: AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                var items = [StoriesList]()
                if let storiesData = dict["data"] as? [[String:AnyObject]] {
                    for obj in storiesData{
                        let data = StoriesList(Dict: obj)
                        items.append(data)
                    }
                }
                delegate?.DidReceiveStories(item: items)
            } else {
                delegate?.DidReceiveError(error: "Received Error in JSON Result...!")
            }
        }
    }
}
