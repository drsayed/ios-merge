//
//  OnlinePresenceModel.swift
//  myscrap
//
//  Created by MyScrap on 3/4/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//
import Foundation

protocol OnlinePresenceModelDelegate: class {
    func didReceivedFailure(error: String)
    func didReceiveData(data: [OnlinePresence])
    func didReceiveOfflineData(data: [OnlinePresence])
    func didReceiveUserData(data: [OnlinePresence])
}

class OnlinePresenceModel {
    
    var delegate: OnlinePresenceModelDelegate?
    
    func sendPresence(xmppUserId:String){
        let api = APIService()
        api.endPoint = Endpoints.SEND_PRESENCE
        api.params = "xmppUserId=\(xmppUserId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let array):
                self.handleOnlineJSON(array: array)
            case .Error(let error):
                self.delegate?.didReceivedFailure(error: error)
            }
        }
    }
    
    func sendOffline(xmppUserId: String){
        let api = APIService()
        api.endPoint = Endpoints.SEND_PRESENCE
        api.params = "xmppUserId=\(xmppUserId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let array):
                self.handleOfflineJSON(array: array)
            case .Error(let error):
                self.delegate?.didReceivedFailure(error: error)
            }
        }
    }
    
    func getUserData(xmppUserId:String) {
        let api = APIService()
        api.endPoint = Endpoints.SEND_PRESENCE
        api.params = "xmppUserId=\(xmppUserId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let array):
                self.handleUserJSON(array: array)
            case .Error(let error):
                self.delegate?.didReceivedFailure(error: error)
            }
        }
    }
        
    private func handleOnlineJSON(array: [String:AnyObject]) {
        if let error = array["error"] as? Bool{
            
            if !error{
                if let isOwned = array["isOwned"] as? [String:AnyObject]{
                    var send = [OnlinePresence]()
                    let onlinePresence = OnlinePresence(dict: isOwned)
                    send.append(onlinePresence)
                    self.delegate?.didReceiveData(data: send)
                }
            } else {
                if let status = array["status"] as? String {
                    self.delegate?.didReceivedFailure(error: status)
                }
            }
        }
    }
    
    private func handleOfflineJSON(array: [String:AnyObject]) {
        if let error = array["error"] as? Bool{
            
            if !error{
                if let isOwned = array["isOwned"] as? [String:AnyObject]{
                    var send = [OnlinePresence]()
                    let offlinePresence = OnlinePresence(dict: isOwned)
                    send.append(offlinePresence)
                    self.delegate?.didReceiveOfflineData(data: send)
                }
            } else {
                if let status = array["status"] as? String {
                    self.delegate?.didReceivedFailure(error: status)
                }
            }
        }
    }
    
    private func handleUserJSON(array: [String:AnyObject]) {
        if let error = array["error"] as? Bool{
            
            if !error{
                if let isOwned = array["isOwned"] as? [String:AnyObject]{
                    var send = [OnlinePresence]()
                    let offlinePresence = OnlinePresence(dict: isOwned)
                    send.append(offlinePresence)
                    self.delegate?.didReceiveUserData(data: send)
                }
            } else {
                if let status = array["status"] as? String {
                    self.delegate?.didReceivedFailure(error: status)
                }
            }
        }
    }
}
