//
//  VisitorItem.swift
//  myscrap
//
//  Created by MS1 on 11/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
class VisitorItem: MemberItem{
    private var _isNewViewer: Bool!
    private var _viewerDate: String!
    var viewerDate: String{
        if _viewerDate == nil { _viewerDate = ""} ; return _viewerDate
    }
    
    var isNewViewer: Bool{
        if _isNewViewer == nil { _isNewViewer = false } ; return _isNewViewer
    }
    
    override init(Dict: Dictionary<String, AnyObject>) {
        super.init(Dict: Dict)
        if let viewDate = Dict["viewDate"] as? Int{
            let date = Date(timeIntervalSince1970: TimeInterval(viewDate))
            self._viewerDate = date.timestampString?.replacingOccurrences(of: "seconds", with: "s").replacingOccurrences(of: "second", with: "s").replacingOccurrences(of: "minutes", with: "m").replacingOccurrences(of: "minute", with: "m").replacingOccurrences(of: "hours", with: "h").replacingOccurrences(of: "hour", with: "h").replacingOccurrences(of: "days", with: "d").replacingOccurrences(of: "day", with: "d")
            /*if (date.timestampString?.contains("seconds"))!{
                self._viewerDate = date.timestampString?.replacingOccurrences(of: "seconds", with: "s")
            } else if (date.timestampString?.contains("second"))! {
                self._viewerDate = date.timestampString?.replacingOccurrences(of: "second", with: "s")
            } else if (date.timestampString?.contains("minutes"))! {
                self._viewerDate = date.timestampString?.replacingOccurrences(of: "minutes", with: "m")
            } else if (date.timestampString?.contains("minute"))! {
                self._viewerDate = date.timestampString?.replacingOccurrences(of: "minute", with: "m")
            } else if (date.timestampString?.contains("hours"))! {
                self._viewerDate = date.timestampString?.replacingOccurrences(of: "hours", with: "h")
            } else if (date.timestampString?.contains("hour"))! {
                self._viewerDate = date.timestampString?.replacingOccurrences(of: "hour", with: "h")
            } else if (date.timestampString?.contains("days"))! {
                self._viewerDate = date.timestampString?.replacingOccurrences(of: "days", with: "d")
            } else if (date.timestampString?.contains("day"))! {
                self._viewerDate = date.timestampString?.replacingOccurrences(of: "day", with: "d")
            }*/
            print("Visitors time stamp : \(date.timestampString)")
            
        }
        if let isNew = Dict["isNew"] as? Bool{
            self._isNewViewer = isNew
        }
    }
}

protocol VisitorDelegate: class {
    func DidReceiveData(data: [VisitorItem])
    func DidReceiveError(error: String)
}

class VisitorService {
    
    weak var delegate: VisitorDelegate?
    
    /*
    //MARK:- VISITORS API
    func getVisitors(){
        let api = APIService()
        api.endPoint = Endpoints.VISITORS_URL
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        
        print(api.endPoint)
        print(api.params)
        
        
        
        api.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleVisitors(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    } */

    //MARK:- VISITORS API
    func getVisitors(pageLoad : String, completion: @escaping (APIResult<[VisitorItem]>) -> ()){
        let api = APIService()
        api.endPoint = Endpoints.VISITORS_URL
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=\(pageLoad)"

        print(api.endPoint)
        print(api.params)
        
        api.getDataWith { (result) in
            switch result{
            case .Success(let dict):
               let data = self.handleVisitors(dict: dict)
               completion(APIResult.Success(data))
            case .Error(let error):
//                self?.delegate?.DidReceiveError(error: error)
                completion(APIResult.Error(error))
            }
        }
    }
    
    //MARK:- VISITORS
    private func handleVisitors(dict: [String:AnyObject]) -> [VisitorItem] {
        var data = [VisitorItem]()

        if let error = dict["error"] as? Bool{
            if !error{
                if let AddContactsData = dict["viewersData"] as? [[String:AnyObject]]{
                    for obj in AddContactsData{
                        let item = VisitorItem(Dict:obj)
                        data.append(item)
                    }
                }
                return data
            } else {
                self.delegate?.DidReceiveError(error: "Error in api")
            }
        }
        return data
    }
    /*
    //MARK:- VISITORS
    private func handleVisitors(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                var data = [VisitorItem]()
                if let AddContactsData = dict["viewersData"] as? [[String:AnyObject]]{
                    for obj in AddContactsData{
                        let item = VisitorItem(Dict:obj)
                        data.append(item)
                    }
                }
                delegate?.DidReceiveData(data: data)
            } else {
                self.delegate?.DidReceiveError(error: "Error in api")
            }
        }
    } */
    
    typealias successCompletion = (Bool) -> ()
    
   func updateVisitors(_ success : @escaping successCompletion){
        let service = APIService()
        service.endPoint = Endpoints.UPDATE_VIEWERS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"

    print(service.endPoint)
    print(service.params)

        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error{
                        success(true)
                    }
                    success(true)
                } else {
                    success(false)
                }
            case .Error(_):
                success(false)
            }
        }
    }
    
}
