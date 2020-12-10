//
//  APIError.swift
//  myscrap
//
//  Created by MyScrap on 5/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum APIError: Error{
    
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case jsonResponseFailure
    case noData
    
    
    var localizedDescription: String{
        switch self {
        case .requestFailed: return "Request Failed"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response unsuccessfull"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonResponseFailure: return "JSON Response Failure"
        case .noData : return "No Data"
        }
    }
    
}
