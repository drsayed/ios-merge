//
//  LikeService.swift
//  myscrap
//
//  Created by MS1 on 2/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


struct LikeService {
    
    
    typealias completionHandler = (_ success: Bool, _ error: String? , _ data: [MemberItem]? ) -> ()
    
    
    static func getCompanyLikes(id: String, completion: @escaping completionHandler){
        let service = APIService()
        service.endPoint = Endpoints.COMPANY_LIKE_DETAILS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(id)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                guard let error = dict["error"] as? Bool , !error , let likeData = dict["LikeData"] as? [[String:AnyObject]] else {
                    completion(false, "Json Internal Error", nil)
                    return
                }
                var dataSource = [MemberItem]()
                for like in likeData{
                    let item = MemberItem(Dict: like)
                    dataSource.append(item)
                }
                completion(true, nil, dataSource)
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    static func getEmployees(id: String, completion: @escaping completionHandler){
        let service = APIService()
        service.endPoint = Endpoints.EMPLOYEE_DETAILS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(id)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                var dataSource = [MemberItem]()
                /*guard let error = dict["error"] as? Bool , !error , let employeedata = dict["employeeData"] as? [String:AnyObject],   let admin = employeedata["Admin"] as? [String: AnyObject] else {
                    completion(false, "Json Internal Error", nil)
                    return
                }
                
                let item = MemberItem(Dict: admin)
                item.isAdmin = true
                dataSource.append(item)*/
                
                guard let error = dict["error"] as? Bool , !error , let employeedata = dict["employeeData"] as? [String:AnyObject] else {
                    completion(false, "Json Internal Error", nil)
                    return
                }
                
                if let employees = employeedata["Employees"] as? [[String:AnyObject]]{
                    for employee in employees{
                        let item = MemberItem(Dict: employee)
                        dataSource.append(item)
                    }
                }
                completion(true, nil, dataSource)
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    static func getLikes(id: String, completion: @escaping completionHandler){
        let service = APIService()
        service.endPoint = Endpoints.LIKE_COUNT_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&postId=\(id)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                guard let error = dict["error"] as? Bool , !error , let likeData = dict["LikeData"] as? [[String:AnyObject]] else {
                    completion(false, "Json Internal Error", nil)
                    return
                }
                var dataSource = [MemberItem]()
                for like in likeData{
                    let item = MemberItem(Dict: like)
                    dataSource.append(item)
                }
                completion(true, nil, dataSource)
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    //MARK:- GetUserFollowers
    static func getUserFollowers(id: String, isFollowers: Bool, completion: @escaping completionHandler){
        let service = APIService()
        service.endPoint = Endpoints.GET_USER_FOLLOWERS
        
        let type = isFollowers ? "1" : "0"
        service.params = "userId=\(id)&apiKey=\(API_KEY)&type=\(type)" //&postId=\(id)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                guard let error = dict["error"] as? Bool , !error , let followersData = dict["followers"] as? [[String:AnyObject]], let followingData = dict["following"] as? [[String:AnyObject]] else {
                    completion(false, "Json Internal Error", nil)
                    return
                }
                
                var dataSource = [MemberItem]()
                if isFollowers {
                    for like in followersData{
                        let item = MemberItem(Dict: like)
                        dataSource.append(item)
                    }
                }
                else {
                    for like in followingData{
                        let item = MemberItem(Dict: like)
                        dataSource.append(item)
                    }
                }
                completion(true, nil, dataSource)
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    static func getViewLists(postId: String, completion: @escaping completionHandler){
        let service = APIService()
        service.endPoint = Endpoints.VIDEO_VIEW_LISTS
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&postId=\(postId)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                guard let error = dict["error"] as? Bool , !error , let viewData = dict["viewData"] as? [[String:AnyObject]] else {
                    completion(false, "Json Internal Error", nil)
                    return
                }
                var dataSource = [MemberItem]()
                for like in viewData {
                    let item = MemberItem(Dict: like)
                    dataSource.append(item)
                }
                completion(true, nil, dataSource)
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    static func getCMLikes(cmId: String, completion: @escaping completionHandler){
        let service = APIService()
        service.endPoint = Endpoints.GET_LIKE_MEMBERS_CM
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&cmId=\(cmId)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                guard let error = dict["error"] as? Bool , !error , let likeData = dict["LikeData"] as? [[String:AnyObject]] else {
                    completion(false, "Json Internal Error", nil)
                    return
                }
                var dataSource = [MemberItem]()
                for like in likeData{
                    let item = MemberItem(Dict: like)
                    dataSource.append(item)
                }
                completion(true, nil, dataSource)
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    static func getPOWLikes(powId: String, completion: @escaping completionHandler){
        let service = APIService()
        service.endPoint = Endpoints.GET_LIKE_MEMBERS_POW
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&powId=\(powId)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                guard let error = dict["error"] as? Bool , !error , let likeData = dict["LikeData"] as? [[String:AnyObject]] else {
                    completion(false, "Json Internal Error", nil)
                    return
                }
                var dataSource = [MemberItem]()
                for like in likeData{
                    let item = MemberItem(Dict: like)
                    dataSource.append(item)
                }
                completion(true, nil, dataSource)
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
}
