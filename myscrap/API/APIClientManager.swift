//
//  APIClientManager.swift
//  myscrap
//
//  Created by myscrap on 13/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//


import UIKit
import Alamofire

protocol APIClientManagerDelegate {
    
    func APIOnSuccess(jsonObject: [String:Any]?, jsonArray: [[String: Any]]?, requestCode: Int);
    func APIOnFailure(code: Int, message: String, json: [String:Any], requestCode: Int);
    func APIOnError(requestCode: Int);
    
}

class APIClientManager {
    
    public static var activityIndicator: ActivityIndicator!;

    public static func ExecuteRequest(url:String,
                                      parameters:[String : Any],
                                      httpmethod: HTTPMethod,
                                      showIndicator: Bool = false,
                                      view: UIView? = nil,
                                      requestCode: Int = 0,
                                      completionHandler:
                            @escaping (_ reponseDict: [String : Any]?,
                                    _ isSuccess: Bool,
                                    _ requestCode: Int,
                                    _ message : String) -> Void)
    {
            
            print(url)
            if (showIndicator)
            {
                self.activityIndicator = ActivityIndicator();
                self.activityIndicator.showActivityIndicator(uiView: view!);
            }
            
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

    
        Alamofire.request(urlString!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil
        ).responseJSON(completionHandler: { (response) in
            

            if (showIndicator)
            {
                self.activityIndicator.hideActivityIndicator(uiView: view!);
            }
            
            switch response.result {
            case .success:
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: response.data!, options: [])  as? [String:Any] {

                        let error = JSONUtils.GetBoolFromObject(object: json, key: "error")
                        
                        var isSuccess = false
                        if error == false {
                            isSuccess = true
                        }
//                        let errorStr : String = JSONUtils.GetStringFromObject(object: json, key: "error")

//                        let successString: String = JSONUtils.GetStringFromObject(object: json, key: "status")
//                        var isSuccess = false
//                        if successString == "success" {
//                            isSuccess = true
//                        }
//                        else {
//
//                            if errorStr != "" {
//                            }
//                        }
                        completionHandler(json, isSuccess, requestCode,"")

                    }
                    else
                    { // Error
                        completionHandler(nil, false, requestCode,"")
                    }
                } catch let error as NSError {  // Error
                    completionHandler(nil, false, requestCode,"")
                    
                }
                break
                
            case .failure(let error): //Error
                print(error)
                completionHandler(nil, false, requestCode,"")
            }
        })
    }
    
     public static func ExecuteRequestUploadImageToServer(url:String,
                                       parameters:[String : Any],
                                       headers:[String : Any],
                                       showIndicator: Bool = false,
                                       view: UIView? = nil,
                                       selectedImage: UIImage!,
                                       fileName: String,
                                       requestCode: Int = 0,
                                       completionHandler:
                             @escaping (_ reponseDict: [String : Any]?,
                                     _ isSuccess: Bool,
                                     _ requestCode: Int,
                                     _ message : String) -> Void) {

            if (showIndicator)
            {
//                self.activityIndicator = ActivityIndicator();
//                self.activityIndicator.showActivityIndicator(uiView: view!)//showActivityIndicatorWithoutBackground(uiView: view!)
            }
                
        Alamofire.upload(multipartFormData: { MultipartFormData in
            
            guard let imageData = selectedImage.jpegData(compressionQuality: 0.75)  else { return }
            
            MultipartFormData.append(imageData, withName: fileName, fileName: "image.png", mimeType: "image/jpeg")

        }, to: url, method: .post, headers: headers as? HTTPHeaders){ (result) in
            
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        
                        if (showIndicator)
                        {
//                            self.activityIndicator.hideActivityIndicator(uiView: view!);
                        }

                        switch response.result {
                            
                        case .success(_):
                            do {
                                
                                if let json = try JSONSerialization.jsonObject(with: response.data!, options: [])  as? [String:Any] {
                                    
                                    completionHandler(json, true, requestCode,"")

                                }
                                else {
                                    completionHandler(nil, false, requestCode,"")

                                }
                            }
                            catch let error as NSError {
                                
                                print("Error result",error)
                                
                                completionHandler(nil, false, requestCode,"")
                            }
                            
                            break
                        case .failure(let error):
                            completionHandler(nil, false, requestCode,"")
                            print("server error: \(error.localizedDescription)")
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
}
