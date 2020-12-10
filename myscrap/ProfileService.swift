//
//  ProfileService.swift
//  myscrap
//
//  Created by MS1 on 11/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
protocol ProfileServiceDelegate : class {
    
    func DidReceiveError(error: String)
    func DidReceiveProfileData(item: ProfileData)
    func DidReceiveFeedItems(items: [FeedV2Item],pictureItems: [PictureURL])
    
}

class ProfileService{
    
    weak var delegate: ProfileServiceDelegate?
    
    var imageList: [String]?
    var pictureUrls = [PictureURL]()
    
    lazy var client : APIClient = {
        let client = APIClient()
        return client
    }()
    


    func getUserProfile(pageLoad: String){
        if AuthService.instance.userId == nil || AuthService.instance.colorCode == nil || AuthService.instance.firstname == nil || AuthService.instance.lastName == nil || AuthService.instance.fullName == nil || AuthService.instance.profilePic == nil || AuthService.instance.email == nil || AuthService.instance.password == nil || AuthService.instance.initial == nil {
            let vc = SignInViewController()
            vc.getFBUserData()
        }
        else {
            let service = APIService()
            service.endPoint = Endpoints.MY_PROFILE_FEEDS_URL //USER_PROFILE_FEEDS_URL_V2
            //        AuthService.instance.userId = "1"
            //        AuthService.instance.colorCode = ""
            //        AuthService.instance.firstname = ""
            //        AuthService.instance.lastName = ""
            //        AuthService.instance.profilePic = ""
            //        AuthService.instance.email = ""
            //        AuthService.instance.password = ""
            service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=\(pageLoad)&companyId="
            service.getDataWith { [weak self] (result) in
                switch result{
                case .Success(let dict):
                    self?.handleResult(dict: dict)
                case .Error(let error):
                    self?.delegate?.DidReceiveError(error: error)
                }
            }
        }
        
    }
    
    func getFriendProfile(friendId:String, notId: String){
        
        let service = APIService()
        service.endPoint =  Endpoints.FRIEND_PROFILE_FEEDS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=\(friendId)&userView=\(notId)"
        print("PARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleResult(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    
    func getFrndProfile(friendId: String) {
        let service = APIService()
        service.endPoint =  Endpoints.GET_FRIEND_PHOTOS
        service.params = "userId=\(friendId)&apiKey=\(API_KEY)&friendId=\(AuthService.instance.userId)"
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleResult(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    
    func getMainPage(friendId: String) {
        let service = APIService()
        service.endPoint =  Endpoints.GET_MAINPAGE_FRIEND_PROFILE
        service.params = "userId=\(friendId)&apiKey=\(API_KEY)&friendId=\(AuthService.instance.userId)"
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleResult(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    
    func getAboutPage(friendId: String) {
        let service = APIService()
        service.endPoint =  Endpoints.GET_ABOUTPAGE_FRIEND_PROFILE
        service.params = "userId=\(friendId)&apiKey=\(API_KEY)&friendId=\(AuthService.instance.userId)"
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleResult(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    
    func getFeedsPage(friendId: String) {
        let service = APIService()
        service.endPoint =  Endpoints.GET_USERFEEDS_FRIEND_PROFILE_V2
        service.params = "userId=\(friendId)&apiKey=\(API_KEY)&friendId=\(AuthService.instance.userId)"
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleResult(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        }
    }
    
    func getUserImagesPage(friendId: String) {
        let service = APIService()
        service.endPoint =  Endpoints.GET_IMAGES_FRIEND_PROFILE
        service.params = "userId=\(friendId)&apiKey=\(API_KEY)&friendId=\(AuthService.instance.userId)"
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
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
                var items = [FeedV2Item]()
                var pictureItems = [PictureURL]()
                
                if let userProfileData = dict["userProfileData"] as? [[String:AnyObject]] {
                    if let profile = userProfileData.last{
                        let item = ProfileData(userDict: profile)
                        let proPer = item.profilePercentage
                        print("ProfileService : \(proPer)")
                        if let cName = item.company as? String, let cID = item.companyId as? String {
                       AuthService.instance.companyId = cID
                         AuthService.instance.company = cName

                            }
                        //UserDefaults.standard.set(proPer, forKey: "proPer")
                        delegate?.DidReceiveProfileData(item: item)
                    }
                    if let feedsData = userProfileData.last?["feedsData"] as? [[String:AnyObject]]{
                        for obj in feedsData{
                            let feed = FeedV2Item(FeedDict: obj)
                            items.append(feed)
                        }
                        print("Feeds data count : \(items.last?.postuserId)")
                    }
                }
                if let pictureURL = dict["pictureUrl"] as? [[String:AnyObject]]{
                    //var listImg = gridItems.listingImg
                    pictureUrls.removeAll()
                    for obj in pictureURL{
 
                        let pic = PictureURL(pictureDict: obj)
                        pictureItems.append(pic)
                        pictureUrls.append(pic)
                        print(pictureItems)
                    }
                    
                }
                if let data = dict["data"] as? [String:AnyObject] {
                    //Put the values into Profile data
                    let item = ProfileData(userDict: data)
                    delegate?.DidReceiveProfileData(item: item)
                    
                    //Put the images array into imagesList array
                    let images = data["photos"] as? [String]
                    imageList = images
                    print("Imagee List data \(String(describing: imageList))")
                    
                    
                    
                    if let feedsData = data["feedsData"] as? [[String:AnyObject]]{
                        for obj in feedsData{
                            let feed = FeedV2Item(FeedDict: obj)
                            items.append(feed)
                        }
                    }
                }
                delegate?.DidReceiveFeedItems(items: items, pictureItems: pictureItems)
            } else {
                delegate?.DidReceiveError(error: "Received Error in JSON Result...!")
            }
        }
    }
    
    /*typealias viewListingResponse = (Result<PhotoGridLists,APIError>) -> Void
    
    func viewListing(with frndId: String, completion: @escaping viewListingResponse) {
        
        let params = [PostKeys.userId: AuthService.instance.userId,
                      PostKeys.apiKey : API_KEY,
                      "friendId": frndId
        ]
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nFriend ID : \(frndId), \nParams : \(params)")
        client.getDataWith(with: Endpoints.GET_FRIEND_PHOTOS, params: params) { (result: Result<PhotoGridLists,APIError>) in
            DispatchQueue.main.async {
                print("View Profile lists",result)
                completion(result)
            }
        }
    }*/
}
