//
//  APIservice.swift
//  CoreDataTutorialPart1Final
//
//  Created by James Rochabrun on 3/2/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class APIService: NSObject {
    
    lazy var params: String = {
        return "apiKey=\(API_KEY)"
    }()
    
    lazy var endPoint: String = {
        return "https://myscrap.com"
    }()
    
    lazy var baseURL: String = {
//        return "192.168.1.125"
        return "myscrap.com"
    }()
    /*Test server url*/
     lazy var testBaseURL: String = {
    //        return "192.168.1.125"
            return "test.myscrap.com"
        }()
    
    lazy var testPath: String = {
    //        return "/myscrap-2006/index.php/ios/" + subPath
            return "/api/" + subPath
        }()
    
    lazy var path: String = {
//        return "/myscrap-2006/index.php/ios/" + subPath
        return "/ios/" + subPath
    }()
    
    lazy var subPath: String = {
        return ""
    }()
    
    
    lazy var urlComponent: URLComponents = {
        var components = URLComponents()
        components.host = baseURL
//        components.scheme = URLComponents.http
        components.scheme = URLComponents.https
        components.path = path
        return components
    }()
    
    lazy var companyUrlComponent: URLComponents = {
            var components = URLComponents()
            //components.host = testBaseURL
        components.host = baseURL
    //        components.scheme = URLComponents.http
            components.scheme = URLComponents.https
            components.path = testPath
            return components
        }()
    
    @discardableResult
    func getMultipartData(with subpath: String, params: [String: String]?, media: [Media]? = nil , requestType: RequestType = .post, completion: @escaping  (APIResult<[String: AnyObject]>) -> Void) -> URLSessionTask? {
        subPath = subpath
        var req = URLRequest(url: urlComponent.url!)
        req.httpMethod = requestType.rawValue
        var headers = req.allHTTPHeaderFields ?? [:]
        req.allHTTPHeaderFields = headers
        let boundary = generateBoundary()
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        req.allHTTPHeaderFields = headers
        if requestType == .post, let parameters = params {
            let dataBody = createDataBody(withParameters: parameters, media: media, boundary: boundary)
            req.httpBody = dataBody
        }
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            dump(data)
            print("\n get multipart data : ", data,"\n",response,"\n",error)
            guard error == nil else{
                return completion(.Error("Error Processing API: \(error?.localizedDescription ?? " ")"))
            }
            guard let data = data else {
                return completion(.Error(error?.localizedDescription ?? "Empty Data to show"))
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                print("Add listing response :\(json)")
                completion(.Success(json))
            }
            catch let error {
                print("Error while add listing : \(error)")
                return completion(.Error(error.localizedDescription))
            }
        }
        task.resume()
        
        return task
        
    }
    
    private func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        
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
                dump(photo)
            }
            dump(media)
            print("Parameters : \(params), \(body)")
            dump(body)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
   //Company photos and commodity photos upload in Admin View
    @discardableResult
    func getMultipartDataAdminView(with subpath: String, params: [String: String]?, company: [Media]? = nil , commodity: [Media]? = nil , requestType: RequestType = .post, completion: @escaping  (APIResult<[String: AnyObject]>) -> Void) -> URLSessionTask? {
        subPath = subpath
        var req = URLRequest(url: companyUrlComponent.url!)
        req.httpMethod = requestType.rawValue
        var headers = req.allHTTPHeaderFields ?? [:]
        req.allHTTPHeaderFields = headers
        let boundary = generateBoundary()
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        req.allHTTPHeaderFields = headers
        if requestType == .post, let parameters = params {
            let dataBody = createDataBodyAdminView(withParameters: parameters, company: company, commodity: commodity, boundary: boundary)
            req.httpBody = dataBody
        }
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            dump(data)
            print("\n get multipart data : ", data,"\n",response,"\n",error)
            guard error == nil else{
                return completion(.Error("Error Processing API: \(error?.localizedDescription ?? " ")"))
            }
            guard let data = data else {
                return completion(.Error(error?.localizedDescription ?? "Empty Data to show"))
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                print("Add listing response :\(json)")
                completion(.Success(json))
            }
            catch let error {
                print("Error while add listing : \(error)")
                return completion(.Error(error.localizedDescription))
            }
        }
        task.resume()
        
        return task
        
    }
    
    private func createDataBodyAdminView(withParameters params: [String: String]?, company: [Media]?, commodity: [Media]?,boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = company {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
                dump(photo)
            }
            dump(media)
            print("Parameters : \(params), \(body)")
            dump(body)
        }
        
        if let media = commodity {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
                dump(photo)
            }
            dump(media)
            print("Parameters : \(params), \(body)")
            dump(body)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func getTaskAndDataWith(completion: @escaping (APIResult<[String: AnyObject]>) -> Void) -> URLSessionTask? {
        
        if AuthStatus.instance.isLoggedIn{
            
        }
        
        let urlString = endPoint
        let postString = params  //.replacingOccurrences(of: "+", with: "%2B")
//        printDebug("URL = \(urlString)")
//        printDebug(postString)
        guard let url = URL(string: urlString) else {
            completion(.Error("Invalid URL, we can't update your feed"))
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "content-Type")
        request.httpBody = postString.data(using: String.Encoding.ascii, allowLossyConversion: false)
        var task = URLSessionTask()
        DispatchQueue.global(qos:.userInteractive).async {
         task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
//                printDebug(url.absoluteString)
                completion(.Error("Error Processing API: \(error?.localizedDescription ?? " ")"))
                return
            }
            guard let data = data else {
                printDebug(url.absoluteString)
                completion(.Error(error?.localizedDescription ?? "Empty Data to show"))
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]{
                    printDebug(json)
                    completion(.Success(json))
                }
            } catch let error {
                print(url.absoluteString)
                print(error.localizedDescription)
                completion(.Error(error.localizedDescription))
                return
            }
            }
            
        task.resume()
     //   return task
        }
        return task
    }
    
    

    func getDataWith(completion: @escaping (APIResult<[String: AnyObject]>) -> Void) {
        DispatchQueue.global(qos:.userInteractive).async {
            let urlString = self.endPoint
            let postString = self.params  //.replacingOccurrences(of: "+", with: "%2B")
        print(postString)
        printDebug(urlString)
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        //var request = URLRequest(url: url)    //To increase the request time
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 100.0)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "content-Type")
        request.httpBody = postString.data(using: String.Encoding.ascii, allowLossyConversion: false)
        var configuration = URLSessionConfiguration.default
        if #available(iOS 13.0, *) {
            configuration.allowsConstrainedNetworkAccess = false
        } else {
            // Fallback on earlier versions
        }
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request) { (data, response, error) in
            //print("Data, response, error :\(data), \(response), \(error)")
            DispatchQueue.main.async {
            guard error == nil else{
                print("Here1", error as Any)
//                printDebug(url.absoluteString)
                
                return completion(.Error("Error Processing API: \(error?.localizedDescription ?? " ")"))}
            }
            guard let data = data else {
                print("Here2", error as Any)
//                printDebug(url.absoluteString)
                return completion(.Error(error?.localizedDescription ?? "Empty Data to show")) }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]{
//                    printDebug(json)
                    
                    print("What found", json, postString)
                    completion(.Success(json))
                }
            } catch let error {
//                print(url.absoluteString)
//                print(error.localizedDescription)
                return completion(.Error(error.localizedDescription))
            }
        } .resume()
    }
    }
}


private func printDebug<T>(_ item : T){
    #if DEBUG
        print(item)
    #endif
}

enum APIResult<T> {
    case Success(T)
    case Error(String)
}





