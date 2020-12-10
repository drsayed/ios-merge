//
//  APIClient.swift
//  myscrap
//
//  Created by MyScrap on 5/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//
/*
import Foundation

typealias JSONCompletionHandler<T> = (Result<T,APIError>) -> Void

protocol APIClient {
    var session : URLSession { get }
    func fetch<T:Decodable>(with request: URLRequest, completion : @escaping JSONCompletionHandler<T>)
}

extension APIClient{
    var session: URLSession {
        return URLSession(configuration: .default)
    }
    func fetch<T:Decodable>(with request: URLRequest, completion : @escaping JSONCompletionHandler<T>){
        let task = session.dataTask(with: request) { (data, response, err) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(Result.failure(.requestFailed))
                return
            }
            
            print(httpResponse.statusCode)
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        print(T.self)
                        
                        let results = try JSONDecoder().decode(T.self, from: data)
                        completion(Result.success(results))
                    } catch {
                        completion(Result.failure(.jsonConversionFailure))
                    }
                } else {
                    completion(.failure(.invalidData))
                }
            } else {
               completion(Result.failure(.responseUnsuccessful))
            }
        }
        task.resume()
    }
}


*/
