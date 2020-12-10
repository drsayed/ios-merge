//
//  EditListingItem.swift
//  myscrap
//
//  Created by MyScrap on 11/12/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class EditListingItem {
    var listing_type: String?
    var commodity: String?
    var payment: String?
    var pricing: String?
    var quantity: String?
    var packing: String?
    var origin: String?
    var port: String?
    var expiry: String?
    var description: String?
    
    lazy var client : APIClient = {
        let client = APIClient()
        return client
    }()
    
    init(dict: [String:AnyObject]) {
        if let listing_type = dict["listingType"] as? String{
            self.listing_type = listing_type
        }
        if let commodity = dict["commodity"] as? String{
            self.commodity = commodity
        }
        if let payment = dict["paymentTerms"] as? String{
            self.payment = payment
        }
        if let pricing = dict["priceTerms"] as? String {
            self.pricing = pricing
        }
        if let quantity = dict["quantity"] as? String{
            self.quantity = quantity
        }
        if let packing = dict["packaging"] as? String{
            self.packing = packing
        }
        if let origin = dict["countryName"] as? String{
            self.origin = origin
        }
        if let port = dict["portName"] as? String{
            self.port = port
        }
        if let expiry = dict["duration"] as? String{
            self.expiry = expiry
        }
        if let description = dict["description"] as? String{
            self.description = description
        }
    }
    
    //typealias completionHandler = ((EditListingItem?) -> () )
    typealias viewListingResponse = (Result<DetailListing,APIError>) -> Void
    
    func getEditListing(with listingId: String, completion: @escaping viewListingResponse) {
        let params = [PostKeys.userId: AuthService.instance.userId,
                      PostKeys.apiKey : API_KEY,
                      PostKeys.market_listingId: listingId
        ]
        
        client.getDataWith(with: Endpoints.UPDATE_VIEW_LISTING_URL, params: params , completion: { (result: Result<DetailListing,APIError>) in
            DispatchQueue.main.async {
                completion(result)
            }
        })
        
//        let service = APIService()
//        service.endPoint = Endpoints.UPDATE_VIEW_LISTING_URL
//        service.params = "userId=\(user_id)&apiKey=\(API_KEY)&listingId=\(listingId)"
//        service.getDataWith { (result) in
//            print(result)
//            switch result{
//            case .Success(let dict):
//                if let data = dict["data"] as? [String:AnyObject]{
//                    let listing = EditListingItem(dict: data)
//                    completion(listing)
//                }
//            case .Error(_):
//                completion(nil)
//            }
//        }
    }

}

