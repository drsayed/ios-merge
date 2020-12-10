//
//  LMEItem.swift
//  myscrap
//
//  Created by MS1 on 11/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

final class LMEItem {
    private var _title : String!
    private var _contract : String!
    private var _last : String!
    private var _change: String!
    private var _symbol: String!
    
    var isSubscribed = false
    
    var placeholderDict: [String: AnyObject]{
        get {
            return UserDefaults.standard.value(forKey: "placeholderPrices") as! [String: AnyObject]
        } set {
            UserDefaults.standard.set(newValue, forKey: "placeholderPrices")
        }
    }
    
    private var t: String{
        if _title == nil{ _title = ""}
        return _title
    }
    
    private var m: String{
        if _contract == nil { _contract = "-"}
        return _contract
    }
    
    private var l:String {
        if _last == nil { _last = "-"}
        return _last
    }
    
    var symbol: String{
        if _symbol == nil{
            _symbol = ""
        }
        return _symbol
    }
    
    
    
    var title:String{
        if _title == nil { _title = ""}
        return _title
    }
    
    var month: String{
       return " \(m)"
    }
    
    var last:String {
       return " \(l)"
    }
    
    private var c:  String{
        if _change == nil { _change = "" }
        return _change
    }
    
    private var chg:  String{
        return " \(c)"
    }
    
    var change: NSAttributedString{
        switch _symbol {
        case "+":
            return NSAttributedString(string: "\(chg) ⬆︎", attributes: [.foregroundColor: UIColor.LMEgreenColor, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        case "-":
            return NSAttributedString(string: "-\(chg) ⬇︎", attributes: [.foregroundColor: UIColor.LMEredColor, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        default:
             return NSAttributedString(string: "-", attributes:  [.foregroundColor: UIColor.BLACK_ALPHA, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        }
    }
    
    init(title:String, contract:String, last: String, change:String , symbol: String) {
        self._title = title
        self._contract = contract
        self._last = last
        self._symbol = symbol
        self._change = change
        
    }
    
    
   
    /*static func getPlaceHolderLME() -> [LMEItem] {
     var items = [LMEItem]()
     let lme1 = LMEItem(title: "Aluminium", contract: "3M", last: "-", change: "-", symbol: "")
     let lme2 = LMEItem(title: "Al Alloy", contract: "3M", last: "-", change: "", symbol: "")
     let lme3 = LMEItem(title: "Al Alloy NA", contract: "3M", last: "-", change: "", symbol: "")
     let lme4 = LMEItem(title: "Copper", contract: "3M", last: "-", change: "", symbol: "")
     let lme5 = LMEItem(title: "Nickel", contract: "3M", last: "-", change: "", symbol: "")
     let lme6 = LMEItem(title: "Lead", contract: "3M", last: "-", change: "", symbol: "")
     let lme7 = LMEItem(title: "Tin", contract: "3M", last: "-", change: "", symbol: "")
     let lme8 = LMEItem(title: "Zinc", contract: "3M", last: "-", change: "", symbol: "")
     items.append(lme1);items.append(lme2);items.append(lme3);items.append(lme4);items.append(lme5);items.append(lme6);items.append(lme7);items.append(lme8);
     return items
     }*/
    
    static func getPlaceHolderComex() -> [LMEItem]{
        var items = [LMEItem]()
        let lme1 = LMEItem(title: "Copper", contract: "-", last: "-", change: "-", symbol: "")
        let lme2 = LMEItem(title: "Copper", contract: "-", last: "-", change: "", symbol: "")
        let lme3 = LMEItem(title: "Copper", contract: "-", last: "-", change: "", symbol: "")
        let lme4 = LMEItem(title: "Copper", contract: "-", last: "-", change: "", symbol: "")
        let lme5 = LMEItem(title: "Silver", contract: "-", last: "-", change: "", symbol: "")
        let lme6 = LMEItem(title: "Silver", contract: "-", last: "-", change: "", symbol: "")
        let lme7 = LMEItem(title: "Gold", contract: "-", last: "-", change: "", symbol: "")
        let lme8 = LMEItem(title: "Gold", contract: "-", last: "-", change: "", symbol: "")
        items.append(lme1);items.append(lme2);items.append(lme3);items.append(lme4);items.append(lme5);items.append(lme6);items.append(lme7);items.append(lme8)
        return items
    }
    
    static func getPlacHolderShanghai() -> [LMEItem]{
        var items = [LMEItem]()
        let lme1 = LMEItem(title: "Aluminium", contract: "-", last: "-", change: "-", symbol: "")
        let lme2 = LMEItem(title: "Aluminium", contract: "-", last: "-", change: "", symbol: "")
        let lme3 = LMEItem(title: "Aluminium", contract: "-", last: "-", change: "", symbol: "")
        let lme4 = LMEItem(title: "Copper", contract: "-", last: "-", change: "", symbol: "")
        let lme5 = LMEItem(title: "Copper", contract: "-", last: "-", change: "", symbol: "")
        let lme6 = LMEItem(title: "Copper", contract: "-", last: "-", change: "", symbol: "")
        let lme7 = LMEItem(title: "Zinc", contract: "-", last: "-", change: "", symbol: "")
        let lme8 = LMEItem(title: "Zinc", contract: "-", last: "-", change: "", symbol: "")
        let lme9 = LMEItem(title: "Zinc", contract: "-", last: "-", change: "", symbol: "")
        let lme10 = LMEItem(title: "Lead", contract: "-", last: "-", change: "", symbol: "")
        let lme11 = LMEItem(title: "Lead", contract: "-", last: "-", change: "", symbol: "")
        let lme12 = LMEItem(title: "Lead", contract: "-", last: "-", change: "", symbol: "")
        items.append(lme1);items.append(lme2);items.append(lme3);items.append(lme4);items.append(lme5);items.append(lme6);items.append(lme7);items.append(lme8);items.append(lme9);items.append(lme10);items.append(lme11);items.append(lme12)
        return items
    }
    
    
//    title Cash inventory
    init(lmeDict: [String: AnyObject]) {
        if let title = lmeDict["title"] as? String{
            self._title = title
        }
        if let contract = lmeDict["contract"] as? String{
            self._contract = contract
        }
        if let symbol = lmeDict["symbol"] as? String{
            self._symbol = symbol
        }
        if let last = lmeDict["last"] as? String{
            self._last = last
        }
        if let change = lmeDict["change"] as? String{
            self._change = change
        }
        if let month = lmeDict["month"] as? String{
            self._contract = month
        }
    }
    
    
}

class Exchange{
    
    private var _last : String!
    private var _change : String!
    private var _symbol: String!
    
    
    var last: String{
        if _last == nil || _last == "" { _last = "-" } ; return _last
    }
    private var chg:String{
        if _change == nil || _change == "0" || _change == "" {
            _change = "-"
        }
        return _change
    }
    
    var change : NSAttributedString{
        if _symbol == "-"{
            return NSAttributedString(string: "-\(chg) ⬇︎", attributes: [.foregroundColor: UIColor.red, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        } else if _symbol == "+"{
            return NSAttributedString(string: "\(chg) ⬆︎", attributes: [.foregroundColor: UIColor.GREEN_PRIMARY, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        } else {
            return NSAttributedString(string: chg, attributes:  [.foregroundColor: UIColor.BLACK_ALPHA, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        }
    }
    
    init(exchangeDict: [String:AnyObject]) {
        if let last = exchangeDict["last"] as? String{
            self._last = last
        }
        if let change = exchangeDict["change"] as? String{
            self._change = change
        }
        if let symbol = exchangeDict["symbol"] as? String{
            self._symbol = symbol
        }
    }
    
    init(last: String, change: String, symbol: String){
        self._last = last
        self._change = change
        self._symbol = symbol
    }
}
