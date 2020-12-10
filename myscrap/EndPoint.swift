//
//  EndPoint.swift
//  myscrap
//
//  Created by MyScrap on 5/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

protocol QueryITem {
    var query : String? { get }
}

enum RequestType : String{
    case post = "POST"
    case get = "GET"
}


protocol EndPoint : class{
    var subPath : String { get }
    var requestType: RequestType { get }
    var params: [String: String]? { get  set}
    var media : [Media]? { get }
}

extension EndPoint {
    
    var media : [Media]?{
        return nil
    }
    
    var baseURL : String {        
        return "192.168.1.125"
    }
    
    var path: String {
        return "/myscrap-2006/index.php/ios/" +  subPath
    }
    
    var urlComponent: URLComponents{
        var components = URLComponents()
        components.host = baseURL
        components.scheme = URLComponents.http
        components.path = path
        return components
    }
    
    var request: URLRequest{
        var req = URLRequest(url: urlComponent.url!)
        req.httpMethod = requestType.rawValue
        var headers = req.allHTTPHeaderFields ?? [:]
        req.allHTTPHeaderFields = headers
        let boundary = generateBoundary()
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        req.allHTTPHeaderFields = headers
        switch requestType {
        case .post:
            if let parameters = params{
                let dataBody = createDataBody(withParameters: parameters, media: media, boundary: boundary)
                req.httpBody = dataBody
            }
        case .get:
            break
        }
        return req
    }
    
    
    
    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}



extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}









extension URLComponents{
    static let http = "http"
    static let https = "https"
}
