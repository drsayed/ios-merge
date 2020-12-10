//
//  GuestAlertView.swift
//  myscrap
//
//  Created by MS1 on 7/23/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import Foundation




extension UIViewController{
    
    func showGuestAlert(){
        let alert = UIAlertController(title: "Guest Login", message: "Login into MyScrap or create an account.", preferredStyle: .alert)
        let notNowAction = UIAlertAction(title: "NOT NOW", style: .default, handler: nil)
        let LoginAction = UIAlertAction(title: "LOGIN", style: .default) { (action) in
            
            
            print("go to signin page")
            
            UserDefaults.standard.set(false, forKey: "isGuest")
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            if let test = SignInViewController.storyBoardInstance(){
                self.present(test, animated: true, completion: nil)
            }
        }
        
        alert.addAction(notNowAction)
        alert.addAction(LoginAction)
        
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        
        
        present(alert, animated: true, completion: nil)
    }

    
}




