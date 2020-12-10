//
//  EmailService.swift
//  myscrap
//
//  Created by MyScrap on 1/29/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

protocol EmailServiceDelegate: class {
    func DidSentMail(data:String)
    func DidReceivedData(array: [EmailInboxLists])
    func DidReceivedError(error: String)
    func DidReceiveMailData(data: [MailData])
    func DidReceiveViewMail(data:[ViewMailLists])
}

class EmailService {
    weak var eDelegate : EmailServiceDelegate?
    
    //Compose Mail
    func sendEmail(userId: String,subj: String, body: String, listingID: String) {
        let service = APIService()
        service.endPoint = Endpoints.ANONYM_EMAIL
        service.params = "userId=\(userId)&apiKey=\(API_KEY)&loggedInUser=\(AuthService.instance.userId)&subject=\(subj)&message=\(body)&listing_id=\(listingID)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleSendMailJson(dict: dict)
            case .Error(let error):
                print("Email not sent \(error)")
                //self?.delegate?.DidReceivedError(error: error)
            }
        }
    }
    
    //Conversation email
    func getMailInDetail(userId: String, listingID: String){
        let service = APIService()
        service.endPoint = Endpoints.GET_MAIL_DETAIL
        service.params = "userId=\(userId)&apiKey=\(API_KEY)&loggedInUser=\(AuthService.instance.userId)&listingId=\(listingID)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleMailJson(dict: dict)
            case .Error(let error):
                print("Get Mail in detail error \(error)")
                self?.eDelegate?.DidReceivedError(error: error)
            }
        }
    }
    
    //Contacts lists
    func getEmailLists() {
        let service = APIService()
        service.endPoint = Endpoints.GET_MY_MAILS
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handleJson(dict: dict)
            case .Error(let error):
                print("Get Emails error \(error)")
                self?.eDelegate?.DidReceivedError(error: error)
            }
        }
    }
    
    //MARK:- Compose Email JSON
    private func handleSendMailJson(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            let status = dict["status"] as? String
            if !error{
                if status == "Success" {
                    eDelegate?.DidSentMail(data: status!)
                }
            } else {
                print("Send Email error \(error)")
                self.eDelegate?.DidReceivedError(error: status!)
            }
        }
    }
    
    //MARK:- Contact list and Email JSON
    private func handleJson(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            let status = dict["status"] as? String
            if !error{
                if let emailData = dict["data"] as? [[String:AnyObject]]{
                    var emailLists = [EmailInboxLists]()
                    for obj in emailData{
                        let myItems = EmailInboxLists(Dict: obj)
                        emailLists.append(myItems)
                    }
                    eDelegate?.DidReceivedData(array: emailLists)
                }
                if status == "Success" {
                    eDelegate?.DidSentMail(data: status!)
                }
            } else {
                print("Email lists data error \(error)")
                self.eDelegate?.DidReceivedError(error: status!)
            }
        }
    }
    
    //MARK:- View Mail JSON
    private func handleMailJson(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            let status = dict["status"] as? String
            if !error{
                if let emailData = dict["data"] as? [[String:AnyObject]]{
                    
                    //ViewDetailed Email
                    var mailLists = [ViewMailLists]()
                    for datum in emailData {
                        let myLists = ViewMailLists(Dict: datum)
                        mailLists.append(myLists)
                    }
                    eDelegate?.DidReceiveViewMail(data: mailLists)
                }
                if status == "Success" {
                    eDelegate?.DidSentMail(data: status!)
                }
            } else {
                print("View email lists error \(error)")
                self.eDelegate?.DidReceivedError(error: status!)
            }
        }
    }
}

