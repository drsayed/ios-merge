//
//  APIClient.swift
//  myscrap
//
//  Created by MyScrap on 6/30/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

final class APIClient{
    
    lazy var baseURL: String = {
        //        return "192.168.1.125"
        return "myscrap.com"
        //return "http://216.172.171.51/~papiunit/"
    }()
    
 
    
    struct Hello : Decodable {
        var hello : String
    }
    
    
    typealias JSONCompletionHandler<T: Decodable> = (Result<T,APIError>) -> Void
    
    
    
    @discardableResult
    func getDataWith<T: Decodable>(with subpath: String, media: [Media]? = nil, requestType: RequestType = .post, params : [String: String]?, completion: @escaping  JSONCompletionHandler<T>) -> URLSessionTask{
        var component = URLComponents()
        component.host = baseURL
        component.scheme = URLComponents.https
        component.path = "/ios/" + subpath
        print(component.url)
        
        
        var req = URLRequest(url: component.url!)
        req.httpMethod = requestType.rawValue
        var headers = req.allHTTPHeaderFields ?? [:]
        let boundary = generateBoundary()
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        req.allHTTPHeaderFields = headers
        if requestType == .post, let parameters = params {
            print(parameters)
            let dataBody = createDataBody(withParameters: parameters, media: media, boundary: boundary)
            req.httpBody = dataBody
        }
        
        let task = URLSession.shared.dataTask(with: req) { (data , response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(Result.failure(.requestFailed))
            }
            if httpResponse.statusCode == 200 {
                print("Data market abcdef: \(data)")
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(JSONResult<T>.self, from: data)
                        
                        print(T.self)
                        print(result)
                        print(data)
                        
                        if let item = result.data{
                            completion(Result.success(item))
                        } else {
                            completion(Result.failure(APIError.jsonParsingFailure))
                        }
                    } catch {
                        completion(Result.failure(APIError.jsonConversionFailure))
                    }
                } else {
                    completion(Result.failure(APIError.jsonConversionFailure))
                }
            } else {
                completion(Result.failure(APIError.responseUnsuccessful))
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    func getMarketDataWith<T: Decodable>(with subpath: String, media: [Media]? = nil, requestType: RequestType = .post, params : [String: String]?, completion: @escaping  JSONCompletionHandler<T>) -> URLSessionTask{
        var component = URLComponents()
        component.host = baseURL
        component.scheme = URLComponents.https
        component.path = "/ios/" + subpath
        print(component.url)
        
        
        var req = URLRequest(url: component.url!)
        req.httpMethod = requestType.rawValue
        var headers = req.allHTTPHeaderFields ?? [:]
        let boundary = generateBoundary()
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        req.allHTTPHeaderFields = headers
        if requestType == .post, let parameters = params {
            print(parameters)
            let dataBody = createDataBody(withParameters: parameters, media: media, boundary: boundary)
            req.httpBody = dataBody
        }
        
        let task = URLSession.shared.dataTask(with: req) { (data , response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(Result.failure(.requestFailed))
            }
            if httpResponse.statusCode == 200 {
                print("Data : \(data)")
                if let data = data {
                    do {
                        print("i am here new born");
                        let result = try JSONDecoder().decode(JSONResult<T>.self, from: data)
//                        let result = try JSONDecoder().decode(ListJSONResult<T>.self, from: data)
                        print("this is sparta : \(result)")
//
//                        print(T.self)
//                        print(result)
//                        print(data)
//
//                        if let item = result.data{
//                            completion(Result.success(item))
//                        } else {
//                            completion(Result.failure(APIError.jsonParsingFailure))
//                        }
                    } catch {
                        completion(Result.failure(APIError.jsonConversionFailure))
                    }
                } else {
                    completion(Result.failure(APIError.jsonConversionFailure))
                }
            } else {
                completion(Result.failure(APIError.responseUnsuccessful))
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
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
}
