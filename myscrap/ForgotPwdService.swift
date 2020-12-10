//
//  ForgotPwdService.swift
//  myscrap
//
//  Created by MyScrap on 12/5/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

protocol ForgotPwdDelegate: class {
    func didReceiveResponse(message: String)
    func didReceiveError(error: String)
}

class ForgotPwdService {
    
    weak var delegate: ForgotPwdDelegate?
    
    func sendEmailCode(email : String){
        let service = APIService()
        service.endPoint = Endpoints.SEND_PASSWORD_CODE
        service.params = "reg_email=\(email)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                _ = self?.verifyEmailJSON(dict: dict)
            case .Error(let error):
                self?.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    func verifyCode(email: String, otp: String){
        let service = APIService()
        service.endPoint = Endpoints.VERIFY_CODE_EMAIL
        service.params = "reg_email=\(email)&code=\(otp)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let status = dict["msg"] as? String {
                    self?.delegate?.didReceiveResponse(message: status)
                }
            case .Error(let error):
                self?.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    func recreatePwd(email: String, password: String){
        let service = APIService()
        service.endPoint = Endpoints.RECREATE_PASSWORD
        service.params = "email=\(email)&newpassword=\(password)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let status = dict["msg"] as? String {
                    self?.delegate?.didReceiveResponse(message: status)
                }
            case .Error(let error):
                self?.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    private func verifyEmailJSON(dict: [String:AnyObject]) {
        if let error = dict["error"] as? Bool{
            if !error{
                if let status = dict["status"] as? String {
                    self.delegate?.didReceiveResponse(message: status)
                }
            } else {
                if let status = dict["status"] as? String {
                    self.delegate?.didReceiveError(error: status)
                } else {
                    self.delegate?.didReceiveError(error: "Something went wrong while verifying EMAIL!! Please try again ")
                }
            }
        }
    }
}
