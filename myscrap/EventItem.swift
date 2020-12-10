//
//  CalendarItem.swift
//  myscrap
//
//  Created by MS1 on 12/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

struct EventItem{
    
    var eventId: String?
    var eventPicture: String?
    var eventName: String?
    var userId: String?
    var startDate: String?
    var endDate: String?
    var startTime: String?
    var endTime:String?
    var eventLocation: String?
    var eventDetail: String?
    var eventPrivacy: String?
    var eventGuest: String?
    var eventTime: Int?
    var interestedCount: Int?
    var goingCount: Int?
    var isGoing: Bool = false
    var isInterested: Bool = false
    
    var eventTimeDescription: String{
        if let strDt = startDate, let endDt = endDate, let strTime = startTime, let endTm = endTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let StartingDate = dateFormatter.date(from: strDt), let endingDate = dateFormatter.date(from: endDt) {
                dateFormatter.dateFormat = "E, dd/MM/yyyy"
                let finalStartDate = dateFormatter.string(from: StartingDate)
                let finalEndDate = dateFormatter.string(from: endingDate)
                return "\(finalStartDate) - \(finalEndDate) at \(strTime) at \(endTm)"
            }
        }
        return " "
    }
    
    
    init(JsonDictionary: [String: AnyObject]) {
        if let eventId = JsonDictionary["eventId"] as? String{
            self.eventId = eventId
        }
        if let eventPicture = JsonDictionary["eventPicture"] as? String{
            self.eventPicture = eventPicture
        }
        if let eventName = JsonDictionary["eventName"] as? String{
            self.eventName = eventName
        }
        if let userId = JsonDictionary["userId"] as? String{
            self.userId = userId
        }
        if let startDate = JsonDictionary["startDate"] as? String{
            self.startDate = startDate
        }
        if let endDate = JsonDictionary["endDate"] as? String{
            self.endDate = endDate
        }
        if let startTime = JsonDictionary["startTime"] as? String{
            self.startTime = startTime
        }
        if let endTime = JsonDictionary["endTime"] as? String{
            self.endTime = endTime
        }
        if let eventLocation = JsonDictionary["eventLocation"] as? String{
            self.eventLocation = eventLocation
        }
        if let eventDetail = JsonDictionary["eventDetail"] as? String{
            self.eventDetail = eventDetail
        }
        if let eventPrivacy = JsonDictionary["eventPrivacy"] as? String{
            self.eventPrivacy = eventPrivacy
        }
        if let eventPrivacy = JsonDictionary["eventGuest"] as? String{
            self.eventPrivacy = eventPrivacy
        }
        if let eventPrivacy = JsonDictionary["eventTime"] as? String{
            self.eventPrivacy = eventPrivacy
        }
        if let interestedCount = JsonDictionary["interestedCount"] as? Int{
            self.interestedCount = interestedCount
        }
        if let goingCount = JsonDictionary["goingCount"] as? Int{
            self.goingCount = goingCount
        }
        
        if let isGoing = JsonDictionary["isGoing"] as? Bool{
            self.isGoing = isGoing
        }
        if let isInterested = JsonDictionary["isInterested"] as? Bool{
            self.isInterested = isInterested
        }
        if let eventPicture = JsonDictionary["eventPicture"] as? String{
            self.eventPicture = eventPicture
        }
    }
    
    typealias handler = (_ success: Bool, _ error:String? ,_ dataSource: [EventItem]? ) -> ()
    
    static func getEvents(completion: @escaping handler ){
        let service = APIService()
        service.endPoint = Endpoints.CALENDAR_EVENTS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error {
                        if let eventData = dict["eventData"] as? [[String: AnyObject]] {
                            var datas = [EventItem]()
                            for obj in eventData{
                                let event = EventItem(JsonDictionary: obj)
                                datas.append(event)
                            }
                            completion(true, nil, datas)
                        }
                    } else{
                        completion(false, "Error in after receving Json", nil)
                    }
                }
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    static func getInvitedEvents(completion: @escaping handler){
        let service = APIService()
        service.endPoint = Endpoints.CALENDAR_INVITES_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error {
                        var datas = [EventItem]()
                        if let eventData = dict["eventData"] as? [[String: AnyObject]] {
                            for obj in eventData{
                                let event = EventItem(JsonDictionary: obj)
                                datas.append(event)
                            }
                            completion(true, nil, datas)
                        } else {
                            completion(false, "No events after json", datas)
                        }
                    } else{
                        completion(false, "Error in after receving Json", nil)
                    }
                }
            case .Error(let error):
                completion(false, error, nil)
            }
        }
    }
    
    typealias eventHandler = (_ success: Bool, _ error:String? ,_ event: [EventItem]? ) -> ()
    
    static func getSingleEvent(id: String, completion: @escaping eventHandler){
        let service = APIService()
        service.endPoint = Endpoints.EVENT_DETAILS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&eventId=\(id)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool{
                    if !error {
                        var datas = [EventItem]()
                        if let eventData = dict["eventData"] as? [[String: AnyObject]] {
                            for obj in eventData{
                                let event = EventItem(JsonDictionary: obj)
                                datas.append(event)
                            }
                            completion(true, nil, datas)
                        } else {
                            completion(false, "No events after json", datas)
                        }
                    } else{
                        completion(false, "Error in after receving Json", nil)
                    }
                }
            case .Error(let error):
                completion(false, error, nil)
            }
            
        }
    }
    typealias insetEventHandler = (  _ success: Bool) -> ()
    
    static func insertEvent(startTime:String,endTime:String,eventName:String,eventPicture:String,startDate:String,enddate:String,location:String,details:String,eventId:String,eventType:String, _ completionHandler: @escaping insetEventHandler){
        let service = APIService()
        service.endPoint = Endpoints.CREATE_EVENT_URL
        
        var ipAdress = ""
        if AuthService.instance.getIFAddresses().count >= 1 {
            ipAdress = AuthService.instance.getIFAddresses().description
        }
    
        service.params = "eventName=\(eventName)&eventPicture=\(eventPicture)&userId=\(AuthService.instance.userId)&startDate=\(startDate)&endDate=\(enddate)&startTime=\(startTime)&endTime=\(endTime)&eventLocation=\(location)&eventDetail=\(details)&eventPrivacy=\(eventType)&eventGuest=0&eventId=\(eventId)&ipAddress=\(ipAdress)&apiKey=\(API_KEY)".replacingOccurrences(of: "+", with: "%2B")
        print("Calendar event params : \(service.params)")
        service.getDataWith {(result) in
            switch result{
            case .Success( let dict):
                print(dict)
                completionHandler(true)
            case .Error(let error):
                print(error)
                completionHandler(false)
            }
        }

    }
    
    
}


struct params{
    
    static let userId = "userId"
    static let apiKey = "apiKey"
    static let eventName = "eventName"
    
    static func dictionary() -> [String: String]{
        var dict = [String: String]()
        
        dict[userId] = AuthService.instance.userId
        dict[apiKey] = API_KEY
        
        return dict
    }
    
}


