//
//  PricesItem.swift
//  myscrap
//
//  Created by MyScrap on 17/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation

class ForexItem {
    private var _name: String!
    private var _price: String!
    
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var price:String{
        if _price == nil { _price = "" } ; return _price
    }
    
    init(dict: [String: AnyObject]){
        if let name = dict["name"] as? String{
            self._name = name
        }
        if let price = dict["price"] as? String{
            self._price = price
        }
    }
    
}
//class LondonLMEItem {
//    private var _change: String!
//    private var _contract: String!
//    private var _last: String!
//    private var _symbol: String!
//    private var _title: String!
//
//    var change:String{
//        if _change == nil { _change = "" } ; return _change
//    }
//    var contract:String{
//        if _contract == nil { _contract = "" } ; return _contract
//    }
//    var last:String{
//        if _last == nil { _last = "" } ; return _last
//    }
//    var symbol:String{
//        if _symbol == nil { _symbol = "" } ; return _symbol
//    }
//    var title:String{
//        if _title == nil { _title = "" } ; return _title
//    }
//
//    init(dict: [String: AnyObject]){
//        if let change = dict["change"] as? String{
//            self._change = change
//        }
//        if let contract = dict["contract"] as? String{
//            self._contract = contract
//        }
//        if let last = dict["last"] as? String{
//            self._last = last
//        }
//        if let symbol = dict["symbol"] as? String{
//            self._symbol = symbol
//        }
//        if let title = dict["title"] as? String{
//            self._title = title
//        }
//    }
//}
class LondonLMEOfficialItem {
    
 
    
    private var _name: String!
    private var _date: String!
    private var _change: String!
    private var _price: String!
    private var _symbol: String!
    
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var date:String{
        if _date == nil { _date = "" } ; return _date
    }
    var change:String{
        if _change == nil { _change = "" } ; return _change
    }
    var price:String{
        if _price == nil { _price = "" } ; return _price
    }
    var symbol:String{
        if _symbol == nil { _symbol = "" } ; return _symbol
    }
    
    init(dict: [String: AnyObject]){
        if let name = dict["name"] as? String{
            self._name = name
        }
        if let date = dict["date"] as? String{
            self._date = date
        }
        if let change = dict["change"] as? String{
            self._change = change
        }
        if let price = dict["price"] as? String{
            self._price = price
        }
        if let symbol = dict["symbol"] as? String{
            self._symbol = symbol
        }
    }
}
class LondonLMEItem {
    
    
    private var _title: String!
    private var _last: String!
    private var _change: String!
    private var _contract: String!
    private var _symbol: String!
    
    var title:String{
        if _title == nil { _title = "" } ; return _title
    }
    var last:String{
        if _last == nil { _last = "" } ; return _last
    }
    var change:String{
        if _change == nil { _change = "" } ; return _change
    }
    var contract:String{
        if _contract == nil { _contract = "" } ; return _contract
    }
    var symbol:String{
        if _symbol == nil { _symbol = "" } ; return _symbol
    }
    
    init(dict: [String: AnyObject]){
        if let title = dict["title"] as? String{
            self._title = title
        }
        if let last = dict["last"] as? String{
            self._last = last
        }
        if let change = dict["change"] as? String{
            self._change = change
        }
        if let contract = dict["contract"] as? String{
            self._contract = contract
        }
        if let symbol = dict["symbol"] as? String{
            self._symbol = symbol
        }
    }
}

class ComexItem {
    

    private var _title: String!
    private var _last: String!
    private var _change: String!
    private var _month: String!
    private var _symbol: String!
    
    var title:String{
        if _title == nil { _title = "" } ; return _title
    }
    var last:String{
        if _last == nil { _last = "" } ; return _last
    }
    var change:String{
        if _change == nil { _change = "" } ; return _change
    }
    var month:String{
        if _month == nil { _month = "" } ; return _month
    }
    var symbol:String{
        if _symbol == nil { _symbol = "" } ; return _symbol
    }
    
    init(dict: [String: AnyObject]){
        if let title = dict["title"] as? String{
            self._title = title
        }
        if let last = dict["last"] as? String{
            self._last = last
        }
        if let change = dict["change"] as? String{
            self._change = change
        }
        if let month = dict["month"] as? String{
            self._month = month
        }
        if let symbol = dict["symbol"] as? String{
            self._symbol = symbol
        }
    }
}
//class ComexItem {
//
//    private var _title: String!
//    private var _last: String!
//    private var _month: String!
//    private var _symbol: String!
//    private var _change: String!
//
//    var title:String{
//        if _title == nil { _title = "" } ; return _title
//    }
//    var last:String{
//        if _last == nil { _last = "" } ; return _last
//    }
//    var month:String{
//        if _month == nil { _month = "" } ; return _month
//    }
//    var symbol:String{
//        if _symbol == nil { _symbol = "" } ; return _symbol
//    }
//    var change:String{
//        if _change == nil { _change = "" } ; return _change
//    }
//    init(dict: [String: AnyObject]){
//        if let title = dict["title"] as? String{
//            self._title = title
//        }
//        if let last = dict["last"] as? String{
//            self._last = last
//        }
//        if let month = dict["month"] as? String{
//            self._month = month
//        }
//        if let change = dict["change"] as? String{
//            self._change =  change
//        }
//        if let symbol = dict["symbol"] as? String{
//                   self._symbol =  symbol
//               }
//    }
//}

class AvrageCommudityPriceIndia {

    private var _avgPrice: String!
    private var _commodityName: String!
    private var _commodityid: String!
    private var _countryName: String!
    private var _symbol: String!
    private var _change: String!
    private var _diff: String!

    var avgPrice:String{
        if _avgPrice == nil { _avgPrice = "" } ; return _avgPrice
    }
    var commodityName:String{
        if _commodityName == nil { _commodityName = "" } ; return _commodityName
    }
    var commodityid:String{
        if _commodityid == nil { _commodityid = "" } ; return _commodityid
    }
    var countryName:String{
        if _countryName == nil { _countryName = "" } ; return _countryName
    }
    var symbol:String{
        if _symbol == nil { _symbol = "" } ; return _symbol
    }
    var change:String{
        if _change == nil { _change = "" } ; return _change
    }
    var diff:String{
           if _diff == nil { _diff = "" } ; return _diff
       }
    init(dict: [String: AnyObject]){
        if let avgPrice = dict["avgPrice"] as? String{
            self._avgPrice = avgPrice
        }
        if let commodityName = dict["commodityName"] as? String{
            self._commodityName = commodityName
        }
        if let commodityid = dict["commodityid"] as? String{
            self._commodityid = commodityid
        }
        if let countryName = dict["countryName"] as? String{
                   self._countryName = countryName
               }
        if let change = dict["change"] as? String{
            self._change =  change
        }
        if let symbol = dict["symbol"] as? String{
                   self._symbol =  symbol
               }
        if let diff = dict["diff"] as? String{
            self._diff =  diff
        }
    }
}
class AvrageCommudityPriceDubai {

    private var _avgPrice: String!
    private var _commodityName: String!
    private var _commodityid: String!
    private var _countryName: String!
    private var _symbol: String!
    private var _change: String!

    var avgPrice:String{
        if _avgPrice == nil { _avgPrice = "" } ; return _avgPrice
    }
    var commodityName:String{
        if _commodityName == nil { _commodityName = "" } ; return _commodityName
    }
    var commodityid:String{
        if _commodityid == nil { _commodityid = "" } ; return _commodityid
    }
    var countryName:String{
        if _countryName == nil { _countryName = "" } ; return _countryName
    }
    var symbol:String{
        if _symbol == nil { _symbol = "" } ; return _symbol
    }
    var change:String{
        if _change == nil { _change = "" } ; return _change
    }
    init(dict: [String: AnyObject]){
        if let avgPrice = dict["avgPrice"] as? String{
            self._avgPrice = avgPrice
        }
        if let commodityName = dict["commodityName"] as? String{
            self._commodityName = commodityName
        }
        if let commodityid = dict["commodityid"] as? String{
            self._commodityid = commodityid
        }
        if let countryName = dict["countryName"] as? String{
                   self._countryName = countryName
               }
        if let change = dict["change"] as? String{
            self._change =  change
        }
        if let symbol = dict["symbol"] as? String{
                   self._symbol =  symbol
               }
    }
}
class ShanghaiItem {

    private var _title: String!
    private var _last: String!
    private var _month: String!
    private var _symbol: String!
    private var _change: String!
    
    var title:String{
        if _title == nil { _title = "" } ; return _title
    }
    var last:String{
        if _last == nil { _last = "" } ; return _last
    }
    var month:String{
        if _month == nil { _month = "" } ; return _month
    }
    var symbol:String{
        if _symbol == nil { _symbol = "" } ; return _symbol
    }
    var change:String{
        if _change == nil { _change = "" } ; return _change
    }
    init(dict: [String: AnyObject]){
        if let title = dict["title"] as? String{
            self._title = title
        }
        if let last = dict["last"] as? String{
            self._last = last
        }
        if let month = dict["month"] as? String{
            self._month = month
        }
        if let change = dict["change"] as? String{
            self._change =  change
        }
        if let symbol = dict["symbol"] as? String{
                   self._symbol =  symbol
               }
    }
}
class NymexItem {
    private var _name: String!
    private var _spot_month: String!
    private var _change: String!
    
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var spot_month:String{
        if _spot_month == nil { _spot_month = "" } ; return _spot_month
    }
    var change:String{
        if _change == nil { _change = "" } ; return _change
    }
    
    init(dict: [String: AnyObject]){
        if let name = dict["name"] as? String{
            self._name = name
        }
        if let spot_month = dict["spot_month"] as? String{
            self._spot_month = spot_month
        }
        if let change = dict["change"] as? String{
            self._change =  change
        }
    }
}
class CommudityPriceReport {

    private var _companyName: String!
    private var _commodityname: String!
    private var _countryName: String!
    private var _countryId: String!
    private var _price: String!
    private var _commodityid: String!
    private var _companyId: String!

    var companyName:String{
        if _companyName == nil { _companyName = "" } ; return _companyName
    }
    var commodityname:String{
        if _commodityname == nil { _commodityname = "" } ; return _commodityname
    }
    var countryName:String{
        if _countryName == nil { _countryName = "" } ; return _countryName
    }
    var countryId:String{
        if _countryId == nil { _countryId = "" } ; return _countryId
    }
    var price:String{
        if _price == nil { _price = "" } ; return _price
    }
    var commodityid:String{
        if _commodityid == nil { _commodityid = "" } ; return _commodityid
    }
    var companyId:String{
          if _companyId == nil { _companyId = "" } ; return _companyId
      }
    init(dict: [String: AnyObject]){
        if let companyName = dict["companyName"] as? String{
            self._companyName = companyName
        }
        if let commodityname = dict["commodityname"] as? String{
            self._commodityname = commodityname
        }
        if let countryName = dict["countryName"] as? String{
            self._countryName = countryName
        }
        if let countryId = dict["countryId"] as? String{
                   self._countryId = countryId
               }
        if let price = dict["price"] as? String{
            self._price =  price
        }
        if let commodityid = dict["commodityid"] as? String{
                   self._commodityid =  commodityid
               }
        if let companyId = dict["companyId"] as? String{
                          self._companyId =  companyId
                      }
    }
}
class CommodityDetail {

    private var _commodityid: String!
    private var _description: String!
    private var _images: Array<String>!
    private var _name: String!
   

    var commodityid:String{
        if _commodityid == nil { _commodityid = "" } ; return _commodityid
    }
    var description:String{
        if _description == nil { _description = "" } ; return _description
    }
    var images: Array<String>{
        if _images == nil { _images = [] } ; return _images
    }
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
   
    init(dict: [String: AnyObject]){
        if let commodityid = dict["commodityid"] as? String{
            self._commodityid = commodityid
        }
        if let description = dict["description"] as? String{
            self._description = description
        }
        if let images = dict["images"] as? Array<String>{
            self._images = images
        }
        if let name = dict["name"] as? String{
                   self._name = name
               }
       
    }
}
class CompanyPrice {

    private var _commodityid: String!
    private var _companyid: String!
    private var _address: String!
    private var _description: String!
    private var _name: String!
   private var _phoneNo: String!
    private var _premimum: String!
    private var _countryCode: String!
    

    var commodityid:String{
        if _commodityid == nil { _commodityid = "" } ; return _commodityid
    }
    var countryCode:String{
        if _countryCode == nil { _countryCode = "" } ; return _countryCode
    }
    var companyid:String{
        if _companyid == nil { _companyid = "" } ; return _companyid
    }
    var address:String{
           if _address == nil { _address = "" } ; return _address
       }
    var description:String{
        if _description == nil { _description = "" } ; return _description
    }
    var name:String{
        if _name == nil { _name = "" } ; return _name
    }
    var phoneNo:String{
           if _phoneNo == nil { _phoneNo = "" } ; return _phoneNo
       }
    var premimum:String{
              if _premimum == nil { _premimum = "" } ; return _premimum
          }
   
    init(dict: [String: AnyObject]){
        if let commodityid = dict["commodityid"] as? String{
            self._commodityid = commodityid
        }
        if let companyid = dict["companyid"] as? String{
                  self._companyid = companyid
              }
        if let address = dict["address"] as? String{
            self._address = address
        }
        if let description = dict["description"] as? String{
            self._description = description
        }
        if let name = dict["name"] as? String{
                   self._name = name
               }
        if let phoneNo = dict["phoneNo"] as? String{
                       self._phoneNo = phoneNo
                   }
        if let countryCode = dict["countryCode"] as? String{
                       self._countryCode = countryCode
                   }
        if let premimum = dict["premimum"] as? Int{
                              self._premimum = "\(premimum)"
                          }
       
    }
}
