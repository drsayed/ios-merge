//
//  MarketService.swift
//  myscrap
//
//  Created by MyScrap on 6/27/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class MarketService{
 
    lazy var client : APIClient = {
        let client = APIClient()
        return client
    }()
    
    lazy var service : APIService = {
        return APIService()
    }()
    
    weak var delegate : MarketServiceDelegate?
    
    
    func postMarket(port: String, isri: String, description: String, quantity: String, duration: String,type: Int, packing: String, pricing: String, rate: String, shipment: String, anonym: Int, chat: String, code: String, phone: String, email: String, media: [Media]? , completion: @escaping (Bool) -> ()){
       
//        let addr = getIFAddresses()
        var ip = ""
        if !AuthService.instance.getIFAddresses().isEmpty{
            ip = AuthService.instance.getIFAddresses().description
        }
        
        
        let path = Endpoints.INSERT_MARKET_URL
        let parameters = [
            PostKeys.userId : AuthService.instance.userId,
            PostKeys.apiKey : API_KEY,
            PostKeys.market_port   : port,
            PostKeys.market_commodity:isri,
            PostKeys.market_description:description,
            PostKeys.market_quantity:quantity,
            PostKeys.market_unit:"MT",
            PostKeys.market_duration:duration,
            PostKeys.market_editid:"0",
            PostKeys.market_type : "\(type)",
            PostKeys.market_packing: packing,
            PostKeys.market_pricing: pricing,
            PostKeys.market_rate: rate,
            PostKeys.market_shipmentTerm: shipment,
            PostKeys.device_name : "iOS",
            PostKeys.ipAddress: ip,
            PostKeys.anony_user: "\(anonym)",
            PostKeys.market_payment : "",
            "contactMeChat" : chat,
            "contactMeEmail" : email,
            "contactMePhoneCode" : code,
            "contactMePhoneNo" : phone
            ]
        
        print("Parameters while add listing : ", PostKeys.userId, ":", AuthService.instance.userId,
            PostKeys.apiKey, ":", API_KEY,
            PostKeys.market_port,   ":", port,
            PostKeys.market_commodity, ":", isri,
            PostKeys.market_description, ":", description,
            PostKeys.market_quantity, ":", quantity,
            PostKeys.market_unit, ": MT",
            PostKeys.market_duration, ":", duration,
            PostKeys.market_editid, ":0",
            PostKeys.market_type, ":", type,
            PostKeys.market_packing, ":", packing,
            PostKeys.market_pricing, ":", pricing,
            PostKeys.market_rate, ":", rate,
            PostKeys.market_shipmentTerm, ":", shipment,
            PostKeys.device_name, ": iOS",
            PostKeys.ipAddress, ":", ip,
            PostKeys.market_payment, ": ")
        service.getMultipartData(with: path, params: parameters, media: media!) { (result) in
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
    
    func editMarket(editId: String,port: String, isri: String, description: String, quantity: String, duration: String,type: Int, packing: String, pricing: String, rate: String, shipment: String, anonym: Int, chat: String, code: String, phone: String, email: String, delImg: String, media: [Media]?, completion: @escaping (Bool) -> ()){
        
        //        let addr = getIFAddresses()
        var ip = ""
        if !AuthService.instance.getIFAddresses().isEmpty{
            ip = AuthService.instance.getIFAddresses().description
        }
        
        
        let path = Endpoints.INSERT_MARKET_URL
        let parameters = [
            PostKeys.userId : AuthService.instance.userId,
            PostKeys.apiKey : API_KEY,
            PostKeys.market_port   : port,
            PostKeys.market_commodity:isri,
            PostKeys.market_description:description,
            PostKeys.market_quantity:quantity,
            PostKeys.market_unit:"MT",
            PostKeys.market_duration:duration,
            PostKeys.market_editid: editId,
            PostKeys.market_type : "\(type)",
            PostKeys.market_packing: packing,
            PostKeys.market_pricing: pricing,
            PostKeys.market_rate: rate,
            PostKeys.market_shipmentTerm: shipment,
            PostKeys.device_name : "iOS",
            PostKeys.ipAddress: ip,
            PostKeys.anony_user: "\(anonym)",
            PostKeys.market_payment : "",
            "contactMeChat" : chat,
            "contactMeEmail" : email,
            "contactMePhoneCode" : code,
            "contactMePhoneNo" : phone,
            PostKeys.deleted_Imgs : delImg
        ]
        print("EDIT ID ****** \(editId)")
        print("Parameters while add listing : ", PostKeys.userId, ":", AuthService.instance.userId,
              PostKeys.apiKey, ":", API_KEY,
              PostKeys.market_port,   ":", port,
              PostKeys.market_commodity, ":", isri,
              PostKeys.market_description, ":", description,
              PostKeys.market_quantity, ":", quantity,
              PostKeys.market_unit, ": MT",
              PostKeys.market_duration, ":", duration,
              PostKeys.market_editid, ":", editId,
              PostKeys.market_type, ":", type,
              PostKeys.market_packing, ":", packing,
              PostKeys.market_pricing, ":", pricing,
              PostKeys.market_rate, ":", rate,
              PostKeys.market_shipmentTerm, ":", shipment,
              PostKeys.device_name, ": iOS",
              PostKeys.ipAddress, ":", ip,
              PostKeys.market_payment, ": ",
              "contactMeChat :", chat,
            "contactMeEmail :", email,
            "contactMePhoneCode :", code,
            "contactMePhoneNo :", phone,
            PostKeys.deleted_Imgs, ":", delImg)
        service.getMultipartData(with: path, params: parameters, media: media) { (result) in
            print("Edit Result found: \(result)")
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
    
    typealias viewListingResponse = (Result<DetailListing,APIError>) -> Void
    
    func viewListing(with listingId: String, completion: @escaping viewListingResponse) {
        let params = [PostKeys.userId: AuthService.instance.userId,
                      PostKeys.apiKey : API_KEY,
                      PostKeys.market_listingId: listingId
        ]
        print("URL : \(Endpoints.UPDATE_VIEW_LISTING_URL)")
        client.getDataWith(with: Endpoints.UPDATE_VIEW_LISTING_URL, params: params) { (result: Result<DetailListing,APIError>) in
            DispatchQueue.main.async {
                print("View listing",result)
                completion(result)
            }
        }
    }
    
    
    
    
    typealias dataResponse = Result<ListingResponse, APIError>
    
    
    func getMarketItems(with type: MarketType, country: String? = nil,  completion: @escaping (Result<ListingResponse, APIError>) -> Void ){
        
        var params = [PostKeys.userId : AuthService.instance.userId,
         PostKeys.apiKey : API_KEY,
         "type": "\(type.rawValue)"]
        if let code = country{
            params["country"] = code
        }
        print(params)
        
        client.getDataWith(with: Endpoints.MARKET_LISTING_URL, params: params as! [String : String]) { (result : Result<ListingResponse, APIError>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    //With searchtext
    func getMarketItemsWithSearchText(with type: MarketType, searchText: String, productId: String, country: String? = nil,  completion: @escaping (Result<ListingResponse, APIError>) -> Void ){
        
        var params = [PostKeys.userId : AuthService.instance.userId,
                      PostKeys.apiKey : API_KEY,
                      "searchText" : searchText,
                      "productId" : productId,
                      "type": "\(type.rawValue)"]
        if let code = country{
            params["country"] = code
        }
        print(params)
        
        client.getDataWith(with: Endpoints.MARKET_LISTING_URL, params: params as! [String : String]) { (result : Result<ListingResponse, APIError>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func sendChatRequest(listId: String , completion: @escaping (Int?) -> ()  ){
        
        let params = [PostKeys.userId : AuthService.instance.userId,
                      PostKeys.apiKey : API_KEY,
                      "listId": listId]
        client.getDataWith(with: Endpoints.MARKET_REQUEST_CHAT_URL, params: params as! [String : String]) { (result: Result<ChatRequestResponse, APIError>) in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    if let status = data.changed_status, let intStatus = Int(status){
                        completion(intStatus)
                    } else {
                        completion(nil)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    //Get My market list
    typealias listResponse = Result<MyListResponse, APIError>
    
//    func getMylists(with user_id: String,  completion: @escaping (Result<MyListResponse, APIError>) -> Void ){
//
//        let params = [PostKeys.userId : AuthService.instance.userId,
//                      PostKeys.apiKey : API_KEY]
//
//        client.getMarketDataWith(with: Endpoints.MY_MARKET_LISTINGS, params: params) { (result : Result<MyListResponse, APIError>) in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//    }
    
    func getmarketLists() {
        let service = APIService()
        service.endPoint = Endpoints.MY_MARKET_LISTINGS
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleJson(dict: dict)
            case .Error(let error):
                print("Market listing error \(error)")
                //self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    //MARK:- GET MARKET JSON
    private func handleJson(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            let status = dict["status"] as? String
            if !error{
                if let myListingData = dict["data"] as? [[String:AnyObject]]{
                    
                    var myListings = [MyListingItems]()
                    for obj in myListingData{
                        let myItems = MyListingItems(Dict: obj)
                        myListings.append(myItems)
                        print("Handle Json : \(obj)")
                    }
                    delegate?.DidReceivedData(data: myListings)
                }
                
            } else {
                print("Market listing error \(error)")
                self.delegate?.DidReceivedError(error: status!)
            }
        }
    }
    
    func detailMarketLists(listingId: String) {
        let service = APIService()
        service.endPoint = Endpoints.VIEW_LISTINGS
        print("URL :\(service.endPoint)")
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&listingId=\(listingId)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleViewListing(dict: dict)
            case .Error(let error):
                print("View Detail listing error \(error)")
                //self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    //MARK:- View Listing JSON
    func handleViewListing(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            let status = dict["status"] as? String
            if !error{
                if let viewListingData = dict["data"] as? [String:AnyObject] {
                    
                    var viewListings = [ViewListingItems]()
                    let viewItems = ViewListingItems(Dict: viewListingData)
                    viewListings.append(viewItems)
                    print("Handle Json : \(viewListings)")
    
                    delegate?.didReceiveViewListings(data: viewListings)
                }
                
            } else {
                print("Market listing error \(error)")
                self.delegate?.DidReceivedError(error: status!)
            }
        }
    }
    
}

protocol MarketServiceDelegate: class {
    func DidReceivedData(data: [MyListingItems])
    func didReceiveViewListings(data: [ViewListingItems])
    func DidReceivedError(error: String)
}

struct MyListResponse: Decodable {
    let data: [MylistData]?
}

struct ListingResponse: Decodable{
    let listingCountryCount: [CountryListing]?
    let productFilter: [ProductListing]?
    let data: [MarketData]?
}


struct ChatRequestResponse : Decodable {
    var changed_status: String?
}



