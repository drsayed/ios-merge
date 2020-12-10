//
//  ForgotPwdServices.swift
//  myscrap
//
//  Created by MyScrap on 10/26/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

protocol ForgotPwdServiceDelegate : class {
    func didReceiveError(error: String)
    func didCodeSent(message: String)
}

class ForgotPwdServices {
    weak var delegate : ForgotPwdServiceDelegate?
    
    func sendCode(email: String) {
        let service = APIService()
        service.endPoint = Endpoints.SEND_PASSWORD_CODE
        service.params = "reg_email=\(email)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                print("Result is success, pwd code sent")
                
            case .Error(let error):
                print("Pwd code can't be sent to this email")
            }
        }
    }
    
    func handleCodeSent(dict: [String: AnyObject]) {
        let status = dict["status"] as! String
        let error = dict["error"] as! Bool
        if !error {
            if status == "success" {
                //self.delegate?.didCodeSent(message: <#T##String#>)
            } else {
                delegate?.didReceiveError(error: "Error while voting")
            }
        } else {
            delegate?.didReceiveError(error: "Error fetching voters list")
        }
        
    }
}
