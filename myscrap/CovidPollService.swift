//
//  CovidPollService.swift
//  myscrap
//
//  Created by MyScrap on 15/03/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

protocol CovidServiceDelegate : class {
    //func DidReceivedData(data: [])
    func DidGetPollStatus(isPollDone:Bool)
    func DidReceiveCovidResponse(status:String)
    func DidReceivedCovidError(error: String)
}
class CovidPollService {
    weak var delegate : CovidServiceDelegate?
    
    func pollAnsSend(option:String) {
        let service = APIService()
        service.endPoint = Endpoints.UPDATE_COVID_POLL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&option=\(option)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool {
                    let status = dict["status"] as? String
                    if !error {
                        self?.delegate?.DidReceiveCovidResponse(status: status!)
                    } else {
                        self?.delegate?.DidReceivedCovidError(error: status!)
                    }
                }
            case .Error(let error):
                self?.delegate?.DidReceivedCovidError(error: error)
            }
        }
    }
    
    func getPollStatusForMe() {
        let service = APIService()
        service.endPoint = Endpoints.GET_CPOLL_STATUS
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool {
                    let status = dict["status"] as? String
                    if !error {
                        if let isPollDone = dict["isPollDone"] as? String {
                            if isPollDone == "true" {
                                self?.delegate?.DidGetPollStatus(isPollDone: true)
                            } else {
                                self?.delegate?.DidGetPollStatus(isPollDone: false)
                            }
                        } else {
                            self?.delegate?.DidReceivedCovidError(error: "Server error")
                        }
                    } else {
                        self?.delegate?.DidReceivedCovidError(error: status!)
                    }
                }
            case .Error(let error):
                self?.delegate?.DidReceivedCovidError(error: error)
            }
        }
    }
}
