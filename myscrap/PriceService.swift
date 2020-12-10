//
//  PriceService.swift
//  myscrap
//
//  Created by MS1 on 11/22/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

typealias successItems = (lme: [LMEItem] , comex: [LMEItem] , shanghai :[LMEItem], lmeTime: String, newyorkTime: String, shanghaiTime: String)
typealias updatedSuccessItems = (forex : [ForexItem], lme : [LondonLMEItem],lmeOfficial : [LondonLMEOfficialItem], comex : [ComexItem], nymex : [NymexItem], forexTime: String, lmeTime : String, comexTime : String, nymexTime : String, lmeShow: String)
typealias updatedSuccessForExchange = (shanghai : [ShanghaiItem], lme : [LondonLMEItem], comex : [ComexItem], shanghaiTime: String, lmeTime : String, comexTime : String, lmeDataShow : String)
typealias updatedSuccessAvrageCommudityPrice = (avgCommudityItemsUAE : [AvrageCommudityPriceDubai], avgCommudityItemsIndia : [AvrageCommudityPriceIndia], isDone : String)

protocol PriceServiceDelegate: class {
    func DidReceiveError(error: String)
    func DidReceiveLMEItems(lme: [ShowLMEItem], comex: [ShowLMEItem] , shanghai :[ShowLMEItem], lmeTime: String, newyorkTime: String, shanghaiTime: String)
    //func DidReceiveItems(comex: [LMEItem] , shanghai :[LMEItem], newyorkTime: String, shanghaiTime: String)
    func DidReceiveValidCoupon(status: String)
    //func DidReceiveLMEData(lme: [ShowLMEItem], lmeTime: String)
}

final class PriceService{
    
    weak var delegate: PriceServiceDelegate?
    
    func fetchLME()  -> URLSessionTask? {
        let service = APIService()
        service.endPoint = Endpoints.LME_EXCHANGE_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        return service.getTaskAndDataWith(completion: { [weak self] result in
            switch result{
            case .Success(let dict):
                self?.handleLME(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        })
    }
    func fetchPricesUpdated(completion: @escaping (Bool, updatedSuccessItems?) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.GET_UPDATED_PRICES
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        //        print(service.endPoint)
        //        print(service.params)
        service.getDataWith { [weak self] result in
            switch result {
            case .Success(let dict):
                //                print(dict)
                if let error = dict["error"] as? Bool{
                    if !error{
                        var forexItems = [ForexItem]()
                        var lmeItems = [LondonLMEItem]()
                        var comexItems = [ComexItem]()
                        var nymexItems = [NymexItem]()
                        var lmeOfficialItems = [LondonLMEOfficialItem]()
                        var forexTime = ""
                        var lmeTime = ""
                        var lmeOfficialTime = ""
                        var comexTime = ""
                        var nymexTime = ""
                        var lme_Show = ""
                        
                        if let main_lme_data = dict["lme_data"] as? [String: AnyObject] {
                            if let forexData = main_lme_data["forex_data"] as? [[String:AnyObject]]{
                                for data in forexData{
                                    let forex = ForexItem(dict: data)
                                    forexItems.append(forex)
                                }
                            }
                            if let lmeData = main_lme_data["lme_data"] as? [[String:AnyObject]]{
                                for data in lmeData{
                                    let lme = LondonLMEItem(dict: data)
                                    lmeItems.append(lme)
                                }
                            }
                            if let lmeOfficialData = main_lme_data["lme_officals"] as? [[String:AnyObject]]{
                                for data in lmeOfficialData{
                                    let lme = LondonLMEOfficialItem(dict: data)
                                    lmeOfficialItems.append(lme)
                                }
                            }
                            if let comexData = main_lme_data["comex_data"] as? [[String:AnyObject]]{
                                for data in comexData{
                                    let comex = ComexItem(dict: data)
                                    comexItems.append(comex)
                                }
                            }
                            if let nymexData = main_lme_data["nymex_data"] as? [[String:AnyObject]]{
                                for data in nymexData{
                                    let nymex = NymexItem(dict: data)
                                    nymexItems.append(nymex)
                                }
                            }
                            if let nymexGasData = main_lme_data["nymex_data_gas"] as? [[String:AnyObject]]{
                                for dataGas in nymexGasData{
                                    let nymexGas = NymexItem(dict: dataGas)
                                    nymexItems.append(nymexGas)
                                }
                            }
                            if let fTime = main_lme_data["forex_last_update"] as? String{
                                forexTime = fTime
                            }
                            if let lTime = main_lme_data["lme_last_update"] as? String{
                                lmeOfficialTime = lTime
                            }
                            if let ctime = main_lme_data["comex_last_update"] as? String{
                                comexTime = ctime
                            }
                            if let nTime = main_lme_data["nymex_last_update"] as? String{
                                nymexTime = nTime
                            }
                            
                            if let lmeShow = main_lme_data["show_lme"] as? Int {
                                if lmeShow == 0 {
                                    lme_Show = "0"      //unsubscribed
                                } else if lmeShow == 1{
                                    lme_Show = "1"            //which is subscried
                                }
                                
                            }
                        }
                        
                        
                        completion(true, (forex : forexItems, lme: lmeItems,lmeOfficial: lmeOfficialItems, comex: comexItems, nymex : nymexItems, forexTime : forexTime, lmeTime : lmeOfficialTime, comexTime: comexTime, nymexTime: nymexTime,lmeShow: lme_Show))
                        //completion(true, (lme: lmeItems, comex: comexItems, shanghai: shanghaiItems, lmeTime: lmeTime, newyorkTime: comexTime, shanghaiTime: shanghaiTime))
                    } else {
                        completion(false, nil)
                    }
                }
            case .Error(let _):
                completion(false, nil)
            }
        }
    }
    
    func fetchPrices()  -> URLSessionTask? {
        let service = APIService()
        service.endPoint = Endpoints.EXCHANGE_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        return service.getTaskAndDataWith(completion: { [weak self] result in
            switch result{
            case .Success(let dict):
                self?.handlePrice(dict: dict)
            case .Error(let error):
                self?.delegate?.DidReceiveError(error: error)
            }
        })
    }
    
    func subscribeLME(email:String, completion: @escaping (Bool, successItems?) -> ()){
        let service = APIService()
        service.endPoint = Endpoints.SUBSCRIBE_LME_URL
        service.params = "userId=\(AuthService.instance.userId)&email=\(email)&status=1&apiKey=\(API_KEY)"
        //        print(service.endPoint)
        //        print(service.params)
        service.getDataWith { [weak self] result in
            switch result {
            case .Success(let dict):
                //                print(dict)
                if let error = dict["error"] as? Bool{
                    if !error{
                        var lmeItems = [LMEItem]()
                        var comexItems = [LMEItem]()
                        var shanghaiItems = [LMEItem]()
                        var lmeTime = ""
                        var comexTime = ""
                        var shanghaiTime = ""
                        
                        if let lmeSubscription = dict["lmeSubscription"] as? String , let intstatus = Int(lmeSubscription) {
                            //AuthStatus.instance.setLMEStatus = intstatus
                        }
                        if let lmeShowData = dict["showLmeData"] as? Int {
                            if lmeShowData == 0 {
                                AuthStatus.instance.setLMEStatus = lmeShowData      //unsubscribed
                            } else if lmeShowData == 1{
                                AuthStatus.instance.setLMEStatus = 2            //which is subscried
                            }
                            
                        }
                        if let ltime = dict["londonTime"] as? String{
                            lmeTime = ltime
                        }
                        if let stime = dict["shanghaiTime"] as? String{
                            shanghaiTime = stime
                        }
                        if let ctime = dict["newYorkTime"] as? String{
                            comexTime = ctime
                        }
                        
                        if let lmeData = dict["lmeData"] as? [[String:AnyObject]]{
                            for data in lmeData{
                                let lme = LMEItem(lmeDict: data)
                                lmeItems.append(lme)
                            }
                        }
                        if let comexData = dict["comexData"] as? [[String:AnyObject]]{
                            for data in comexData{
                                let lme = LMEItem(lmeDict: data)
                                comexItems.append(lme)
                            }
                        }
                        if let shanghaiData = dict["shanghaiData"] as? [[String:AnyObject]]{
                            for data in shanghaiData{
                                let lme = LMEItem(lmeDict: data)
                                shanghaiItems.append(lme)
                            }
                        }
                        //                        delegate?.DidReceiveItems(lme: lmeItems, comex: comexItems, shanghai: shanghaiItems, lmeTime: lmeTime, newyorkTime: comexTime, shanghaiTime: shanghaiTime)
                        
                        completion(true, (lme: lmeItems, comex: comexItems, shanghai: shanghaiItems, lmeTime: lmeTime, newyorkTime: comexTime, shanghaiTime: shanghaiTime))
                        
                    } else {
                        //                        delegate?.DidReceiveError(error: "Error in Json.. PricesAPI")
                        completion(false, nil)
                    }
                }
            case .Error(let _):
                //                self?.delegate?.DidReceiveError(error: error)
                completion(false, nil)
            }
        }
    }
    
    func promoCheck(couponCode: String) {
        let api = APIService()
        api.endPoint = Endpoints.CHECK_COUPON_CODE
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&couponCode=\(couponCode)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let json):
                self.handleCouponDict(dict: json)
            case .Error(let error):
                self.delegate?.DidReceiveError(error: error)
            }
        }
    }
    
    private func handleCouponDict(dict: [String:AnyObject]) {
        if let error = dict["error"] as? Bool{
            if !error{
                var resultStatus = ""
                
                if let status = dict["status"] as? String {
                    resultStatus = status
                }
                delegate?.DidReceiveValidCoupon(status: resultStatus)
            }
            else {
                delegate?.DidReceiveError(error: "Invalid Coupon code.")
            }
        }
    }
    
    private func handlePrice(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                //var lmeItems = [LMEItem]()
                var comexItems = [LMEItem]()
                var shanghaiItems = [LMEItem]()
                //var lmeTime = ""
                var comexTime = ""
                var shanghaiTime = ""
                
                /*if let lmeSubscription = dict["lmeSubscription"] as? String , let intstatus = Int(lmeSubscription) {
                 print("LME status in PriceService")
                 
                 //AuthStatus.instance.setLMEStatus = intstatus
                 }*/
                /*if let lmeData = dict["lme_data"] as? [[String:AnyObject]]{
                 for data in lmeData{
                 let lme = LMEItem(lmeDict: data)
                 lmeItems.append(lme)
                 }
                 }*/
                if let comexData = dict["comexData"] as? [[String:AnyObject]]{
                    for data in comexData{
                        let lme = LMEItem(lmeDict: data)
                        comexItems.append(lme)
                    }
                }
                if let shanghaiData = dict["shanghaiData"] as? [[String:AnyObject]]{
                    for data in shanghaiData{
                        let lme = LMEItem(lmeDict: data)
                        shanghaiItems.append(lme)
                    }
                }
                
                /*if let ltime = dict["londonTime"] as? String{
                 lmeTime = ltime
                 }*/
                if let stime = dict["shanghaiTime"] as? String{
                    shanghaiTime = stime
                }
                if let ctime = dict["newYorkTime"] as? String{
                    comexTime = ctime
                }
                
                
                //delegate?.DidReceiveItems(comex: comexItems, shanghai: shanghaiItems, newyorkTime: comexTime, shanghaiTime: shanghaiTime)
                
            } else {
                delegate?.DidReceiveError(error: "Error in Json.. PricesAPI")
            }
        }
    }
    
    private func handleLME(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                var lmeItems = [ShowLMEItem]()
                var comexItems = [ShowLMEItem]()
                var shanghaiItems = [ShowLMEItem]()
                var lmeTime = ""
                var comexTime = ""
                var shanghaiTime = ""
                
                
                /*if let lmeSubscription = dict["lmeSubscription"] as? String , let intstatus = Int(lmeSubscription) {
                 print("LME status in PriceService")
                 //AuthStatus.instance.setLMEStatus = intstatus
                 }*/
                if let data = dict["data"] as? [String: AnyObject] {
                    if let lmeShowData = data["show_data"] as? Int {
                        if lmeShowData == 0 {
                            AuthStatus.instance.setLMEStatus = lmeShowData      //unsubscribed
                        } else if lmeShowData == 1{
                            AuthStatus.instance.setLMEStatus = 2            //which is subscried
                        }
                        
                    }
                    
                    if let lmeData = data["lme_data"] as? [[String:AnyObject]]{
                        for valueOfLME in lmeData{
                            let typeOfData = valueOfLME["data"] as? String
                            if typeOfData == "LME" {
                                let ltime = valueOfLME["action_time"] as? String
                                lmeTime = ltime!
                                print("LME Time :\(lmeTime)")
                                let lme = ShowLMEItem(lmeDict: valueOfLME)
                                lmeItems.append(lme)
                            }
                            else if typeOfData == "COMEX"{
                                let ltime = valueOfLME["action_time"] as? String
                                comexTime = ltime!
                                print("Comex Time :\(comexTime)")
                                let com = ShowLMEItem(lmeDict: valueOfLME)
                                comexItems.append(com)
                            }
                            else if typeOfData == "SHFE"{
                                let ltime = valueOfLME["action_time"] as? String
                                shanghaiTime = ltime!
                                print("Shangai Time :\(shanghaiTime)")
                                let shng = ShowLMEItem(lmeDict: valueOfLME)
                                shanghaiItems.append(shng)
                            }
                            
                        }
                    }
                }
                
                
                delegate?.DidReceiveLMEItems(lme: lmeItems, comex: comexItems, shanghai: shanghaiItems, lmeTime: lmeTime, newyorkTime: comexTime, shanghaiTime: shanghaiTime)
                
            } else {
                delegate?.DidReceiveError(error: "Error in Json.. PricesAPI")
            }
        }
    }
    func fetchPricesForExchange(completion: @escaping (Bool, updatedSuccessForExchange?) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.EXCHANGE_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        //        print(service.endPoint)
        //        print(service.params)
        service.getDataWith { [weak self] result in
            switch result {
            case .Success(let dict):
                //                print(dict)
                if let error = dict["error"] as? Bool{
                    if !error{
                        var shanghaiItems = [ShanghaiItem]()
                        var lmeItems = [LondonLMEItem]()
                        var comexItems = [ComexItem]()
                        var shanghaiTime = ""
                        var lmeTime = ""
                        var comexTime = ""
                        var lmeShow : String! = "";
                        
                        if let comexData = dict["comexData"] as? [[String:AnyObject]]{
                            for data in comexData{
                                let comex = ComexItem(dict: data)
                                comexItems.append(comex)
                            }
                        }
                        
                        
                        if let lmeData = dict["lmeData"] as? [[String:AnyObject]]{
                            for data in lmeData{
                                let lme = LondonLMEItem(dict: data)
                                lmeItems.append(lme)
                            }
                        }
                        
                        if let shanghaiData = dict["shanghaiData"] as? [[String:AnyObject]]{
                            for data in shanghaiData{
                                let shanghai = ShanghaiItem(dict: data)
                                shanghaiItems.append(shanghai)
                            }
                        }
                        
                        if let shTime = dict["shanghaiTime"] as? String{
                            shanghaiTime = shTime
                        }
                        if let lTime = dict["lmeShow"] as? String{
                            lmeTime = lTime
                        }
                        if let ctime = dict["comexTime"] as? String{
                            comexTime = ctime
                        }
                        var myString: Int! = dict["lmeShow"] as! Int
                       // var myString2: Int! =  Int(dict["lmeShow"]?0)
                        lmeShow = "\(myString ?? 10000)"
                        
                        
                        completion(true, (shanghai : shanghaiItems, lme : lmeItems, comex : comexItems, shanghaiTime: shanghaiTime, lmeTime : lmeTime, comexTime : comexTime,lmeDataShow: lmeShow))
                        //completion(true, (lme: lmeItems, comex: comexItems, shanghai: shanghaiItems, lmeTime: lmeTime, newyorkTime: comexTime, shanghaiTime: shanghaiTime))
                    } else {
                        completion(false, nil)
                    }
                }
            case .Error(let _):
                completion(false, nil)
            }
        }
    }
    
    func fetchAvrageCommudityPrices(completion: @escaping (Bool, updatedSuccessAvrageCommudityPrice?) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.GET_Commodity_Avg_Price
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        //        print(service.endPoint)
        //        print(service.params)
        service.getDataWith { [weak self] result in
            switch result {
            case .Success(let dict):
                //                print(dict)
                if let error = dict["error"] as? Bool{
                    if !error{
                        var avrageCommudityItemDubai = [AvrageCommudityPriceDubai]()
                        var avrageCommudityItemIndia = [AvrageCommudityPriceIndia]()
                        
                        
                        if let forexData = dict["dataForUae"] as? [[String:AnyObject]]{
                            for data in forexData{
                                let forex = AvrageCommudityPriceDubai(dict: data)
                                avrageCommudityItemDubai.append(forex)
                            }
                        }
                        if let forexData = dict["dataForIndia"] as? [[String:AnyObject]]{
                            for data in forexData{
                                let forex = AvrageCommudityPriceIndia(dict: data)
                                avrageCommudityItemIndia.append(forex)
                            }
                        }
                        
                        completion(true, (avgCommudityItemsUAE : avrageCommudityItemDubai ,avgCommudityItemsIndia : avrageCommudityItemIndia , isDone : ""))
                        //completion(true, (lme: lmeItems, comex: comexItems, shanghai: shanghaiItems, lmeTime: lmeTime, newyorkTime: comexTime, shanghaiTime: shanghaiTime))
                    } else {
                        completion(false, nil)
                    }
                }
            case .Error(let _):
                completion(false, nil)
            }
        }
    }
    func fetchPricesForReport(completion: @escaping (Bool, updatedSuccessForExchange?) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.EXCHANGE_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        //        print(service.endPoint)
        //        print(service.params)
        service.getDataWith { [weak self] result in
            switch result {
            case .Success(let dict):
                //                print(dict)
                if let error = dict["error"] as? Bool{
                    if !error{
                        var shanghaiItems = [ShanghaiItem]()
                        var lmeItems = [LondonLMEItem]()
                        var comexItems = [ComexItem]()
                        var shanghaiTime = ""
                        var lmeTime = ""
                        var comexTime = ""
                        var lmeShow : String! = "";
                        
                        if let comexData = dict["comexData"] as? [[String:AnyObject]]{
                            for data in comexData{
                                let comex = ComexItem(dict: data)
                                comexItems.append(comex)
                            }
                        }
                        
                        
                        if let lmeData = dict["lmeData"] as? [[String:AnyObject]]{
                            for data in lmeData{
                                let lme = LondonLMEItem(dict: data)
                                lmeItems.append(lme)
                            }
                        }
                        
                        if let shanghaiData = dict["shanghaiData"] as? [[String:AnyObject]]{
                            for data in shanghaiData{
                                let shanghai = ShanghaiItem(dict: data)
                                shanghaiItems.append(shanghai)
                            }
                        }
                        
                        if let shTime = dict["shanghaiTime"] as? String{
                            shanghaiTime = shTime
                        }
                        if let lTime = dict["lmeShow"] as? String{
                            lmeTime = lTime
                        }
                        if let ctime = dict["comexTime"] as? String{
                            comexTime = ctime
                        }
                        var myString: Int! = dict["lmeShow"] as! Int
                       // var myString2: Int! =  Int(dict["lmeShow"]?0)
                        lmeShow = "\(myString ?? 10000)"
                        
                        
                        completion(true, (shanghai : shanghaiItems, lme : lmeItems, comex : comexItems, shanghaiTime: shanghaiTime, lmeTime : lmeTime, comexTime : comexTime,lmeDataShow: lmeShow))
                        //completion(true, (lme: lmeItems, comex: comexItems, shanghai: shanghaiItems, lmeTime: lmeTime, newyorkTime: comexTime, shanghaiTime: shanghaiTime))
                    } else {
                        completion(false, nil)
                    }
                }
            case .Error(let _):
                completion(false, nil)
            }
        }
    }
    
}
