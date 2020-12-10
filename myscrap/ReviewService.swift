//
//  ReviewService.swift
//  myscrap
//
//  Created by MyScrap on 6/23/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class ReviewService {
    weak var delegate : ReviewServiceDelegate?
    
    func submitReview(companyId: String, userId: String, reviewText: String, rating: String,  completion: @escaping (Bool) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.POST_REVIEW
        print("URL :\(service.endPoint)")
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)&reviewText=\(reviewText)&rating=\(rating)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleReviewPost(dict: dict)
                DispatchQueue.main.async {
                    completion(true)
                }
            case .Error(let error):
                print("Review cannot be posted :  \(error)")
                //self?.delegate?.DidReceivedError(error: error)
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func reviewFetch(companyId: String) {
        let service = APIService()
        service.endPoint = Endpoints.FETCH_REVIEW
        print("URL :\(service.endPoint)")
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleFetchReview(dict: dict)
            case .Error(let error):
                print("Review cannot be fetched :  \(error)")
                //self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    //MARK:- View Listing JSON
    func handleReviewPost(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            let status = dict["status"] as? String
            if !error{
                delegate?.didReceiveReviewValues(status: status!)
                
            } else {
                print("Review Posting error \(error)")
                self.delegate?.didReceivedError(error: status!)
            }
        }
    }
    
    func handleFetchReview(dict: [String: AnyObject]) {
        if let error = dict["error"] as? Bool{
            let status = dict["status"] as? String
            if !error{
                if let reviewData = dict["data"] as? [String:AnyObject] {
                    var reviewItems = [ReviewItems]()
                    let viewItems = ReviewItems(dict: reviewData)
                    reviewItems.append(viewItems)
                    print("Handle Json for Company review lists : \(reviewItems)")
                    
                    delegate?.didFetchReview(data: reviewItems)
                }
            } else {
                print("Review Posting error \(error)")
                self.delegate?.didReceivedError(error: status!)
            }
        }
    }
}
protocol ReviewServiceDelegate: class {
    func didFetchReview(data: [ReviewItems])
    func didReceiveReviewValues(status: String)
    func didReceivedError(error: String)
}
