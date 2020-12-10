//
//  Helper-AppDelegate.swift
//  myscrap
//
//  Created by MS1 on 10/5/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate{
    
    internal func checkUpdateVersion(){
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            guard let info = Bundle.main.infoDictionary, let identifier = info["CFBundleIdentifier"] as? String, let url = URL(string: "http://itunes.apple.com/us/lookup?bundleId=\(identifier)")
            else {
                return
            }
            do {
                print("identifier :\(identifier)")
                let data = try Data(contentsOf: url)
                guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
                    return
                }
                if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
                    print("Result of app store in array : \(result)")
                    print("version in app store", version);
                    if version != currentVersion.replacingOccurrences(of: " ", with: "") {
                        print("both version : \(version) / \(currentVersion)")
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Update Available", message: "A new version of MyScrap is available, Please Update now.", preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: "Next time", style: UIAlertAction.Style.default, handler: nil))
                            alertController.addAction(UIAlertAction(title: "Update", style: .cancel, handler: { (_) in
                                
                                if let url = URL(string: "https://itunes.apple.com/us/app/myscrap/id1233167019?ls=1&mt=8"), UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                                }
                            }))
                            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                            alertWindow.rootViewController = UIViewController()
                            alertWindow.windowLevel = UIWindow.Level.alert + 1;
                            alertWindow.makeKeyAndVisible()
                            alertController.view.tintColor = UIColor.GREEN_PRIMARY
                            alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                        }
                        
                    } else {
                        print("Version is up to date")
                    }
                }
            } catch let err {
                print("APP STORE VERSION FETCH ERROR")
                print(err.localizedDescription)
            }
            
            
            /*print("app Version : \(version) ")
            let service = APIService()
            service.endPoint = Endpoints.NEW_VERSION_URL
            service.params = "version=\(version)&apiKey=\(API_KEY)"
            service.getDataWith(completion: { (result) in
                switch result{
                case .Success(let dict):
                    self.handleUpdate(dict: dict)
                case .Error(_):
                    print("Error Receiving update from server")
                }
            })*/
        }
    }
    
    private func handleUpdate(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                if let updated = dict["versionUpdate"] as? Bool{
                    if updated == true{
                        return
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Update Available", message: "A new version of MyScrap is available, Please Update now.", preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: "Next time", style: UIAlertAction.Style.default, handler: nil))
                            alertController.addAction(UIAlertAction(title: "Update", style: .cancel, handler: { (_) in
                                
                                if let url = URL(string: "https://itunes.apple.com/us/app/myscrap/id1233167019?ls=1&mt=8"), UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                                }
                            }))
                            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                            alertWindow.rootViewController = UIViewController()
                            alertWindow.windowLevel = UIWindow.Level.alert + 1;
                            alertWindow.makeKeyAndVisible()
                            alertController.view.tintColor = UIColor.GREEN_PRIMARY
                            alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }
}
