//
//  ShowLMEItem.swift
//  myscrap
//
//  Created by MyScrap on 12/16/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

final class ShowLMEItem {
    
    //msLmeExchange API implementation
    private var _data : String!
    private var _name : String!
    private var _month : String!
    private var _lastt : String!
    private var _changes : String!
    private var _high : String!
    private var _low : String!
    private var _bid : String!
    private var _ask : String!
    private var _open : String!
    private var _settle : String!
    private var _open_interest : String!
    private var _volume : String!
    private var _action_time : String!
    private var _class : String!
    private var _lme_sign : String!
    private var _color_lme: String!
    private var _classimp : String!
    private var _symbol : String!
    
    var isSubscribed = false
    
    var placeholderDict: [String: AnyObject]{
        get {
            return UserDefaults.standard.value(forKey: "newplaceholderPrices") as! [String: AnyObject]
        } set {
            UserDefaults.standard.set(newValue, forKey: "newplaceholderPrices")
        }
    }
    
    private var n: String{
        if _name == nil{ _name = ""}
        return _name
    }
    private var m: String{
        if _month == nil{ _month = "-"}
        return _month
    }
    private var l: String{
        if _lastt == nil{ _lastt = "-"}
        return _lastt
    }
    private var c: String{
        if _changes == nil{ _changes = "-"}
        return _changes
    }
    
    private var chg:  String{
        return " \(c)"
    }
    
    var name:String{
        if _name == nil{ _name = ""}
        return _name
    }
    
    var month: String{
        return " \(m)"
    }
    
    var lastt:String {
        return " \(l)"
    }
    
    var symbol: String{
        if _symbol == nil{
            _symbol = ""
        }
        return _symbol
    }
    
    
    var change: NSAttributedString{
        /*if _changes.contains("-") {
            return NSAttributedString(string: "\(chg) ⬇︎", attributes: [.foregroundColor: UIColor.LMEredColor, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        } else {
            return NSAttributedString(string: "\(chg) ⬆︎", attributes: [.foregroundColor: UIColor.LMEgreenColor, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        }*/
        
        switch _symbol {
        case "+":
            return NSAttributedString(string: "\(chg) ⬆︎", attributes: [.foregroundColor: UIColor.LMEgreenColor, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        case "-":
            return NSAttributedString(string: "\(chg) ⬇︎", attributes: [.foregroundColor: UIColor.LMEredColor, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        default:
            return NSAttributedString(string: "-", attributes:  [.foregroundColor: UIColor.BLACK_ALPHA, .font : UIFont(name: "HelveticaNeue", size: 11)! ])
        }
    }
    
    
    
    /*init(data:String, name:String, month:String, lastt:String, changes:String, high:String, low:String, bid:String, ask:String, open:String, settle:String, open_interest:String, volume:String, action_time:String, classs:String, lme_sign:String, color_lme:String, classimp:String,  symboll:String) {
        
        //msLmeExchange API
        self._data = data
        self._name = name
        self._month = month
        self._lastt = lastt
        self._changes = changes
        self._high = high
        self._low = low
        self._bid = bid
        self._ask = ask
        self._open = open
        self._settle = settle
        self._open_interest = open_interest
        self._volume = volume
        self._action_time = action_time
        self._class = classs
        self._lme_sign = lme_sign
        self._color_lme = color_lme
        self._classimp = classimp
        self._symbol = symboll
    }*/
    
    init(name:String, month:String, lastt:String, changes:String, symbol: String) {
        self._name = name
        self._month = month
        self._lastt = lastt
        self._symbol = symbol
        self._changes = changes
    }
    
    
    static func getPlaceHolderLME() -> [ShowLMEItem] {
        var items = [ShowLMEItem]()
        let lme1 = ShowLMEItem(name: "Aluminium", month: "-", lastt: "-", changes: "-", symbol: "")
        let lme2 = ShowLMEItem(name: "Al Alloy", month: "-", lastt: "-", changes: "", symbol: "")
        let lme3 = ShowLMEItem(name: "Al Alloy NA", month: "-", lastt: "-", changes: "", symbol: "")
        let lme4 = ShowLMEItem(name: "Copper", month: "-", lastt: "-", changes: "", symbol: "")
        let lme5 = ShowLMEItem(name: "Nickel", month: "-", lastt: "-", changes: "", symbol: "")
        let lme6 = ShowLMEItem(name: "Lead", month: "-", lastt: "-", changes: "", symbol: "")
        let lme7 = ShowLMEItem(name: "Tin", month: "-", lastt: "-", changes: "", symbol: "")
        let lme8 = ShowLMEItem(name: "Zinc", month: "-", lastt: "-", changes: "", symbol: "")
        items.append(lme1);items.append(lme2);items.append(lme3);items.append(lme4);items.append(lme5);items.append(lme6);items.append(lme7);items.append(lme8);
        return items
    }
    
    static func getPlaceHolderComex() -> [ShowLMEItem] {
        var items = [ShowLMEItem]()
        let lme1 = ShowLMEItem(name: "Copper", month: "-", lastt: "-", changes: "-", symbol: "")
        let lme2 = ShowLMEItem(name: "Copper", month: "-", lastt: "-", changes: "", symbol: "")
        let lme3 = ShowLMEItem(name: "Copper", month: "-", lastt: "-", changes: "", symbol: "")
        let lme4 = ShowLMEItem(name: "Copper", month: "-", lastt: "-", changes: "", symbol: "")
        let lme5 = ShowLMEItem(name: "Silver", month: "-", lastt: "-", changes: "", symbol: "")
        let lme6 = ShowLMEItem(name: "Silver", month: "-", lastt: "-", changes: "", symbol: "")
        let lme7 = ShowLMEItem(name: "Gold", month: "-", lastt: "-", changes: "", symbol: "")
        let lme8 = ShowLMEItem(name: "Gold", month: "-", lastt: "-", changes: "", symbol: "")
        items.append(lme1);items.append(lme2);items.append(lme3);items.append(lme4);items.append(lme5);items.append(lme6);items.append(lme7);items.append(lme8);
        return items
    }
    
    static func getPlacHolderShanghai() -> [ShowLMEItem] {
        var items = [ShowLMEItem]()
        let lme1 = ShowLMEItem(name: "Aluminium", month: "-", lastt: "-", changes: "-", symbol: "")
        let lme2 = ShowLMEItem(name: "Aluminium", month: "-", lastt: "-", changes: "", symbol: "")
        let lme3 = ShowLMEItem(name: "Aluminium", month: "-", lastt: "-", changes: "", symbol: "")
        let lme4 = ShowLMEItem(name: "Copper", month: "-", lastt: "-", changes: "", symbol: "")
        let lme5 = ShowLMEItem(name: "Copper", month: "-", lastt: "-", changes: "", symbol: "")
        let lme6 = ShowLMEItem(name: "Copper", month: "-", lastt: "-", changes: "", symbol: "")
        let lme7 = ShowLMEItem(name: "Zinc", month: "-", lastt: "-", changes: "", symbol: "")
        let lme8 = ShowLMEItem(name: "Zinc", month: "-", lastt: "-", changes: "", symbol: "")
        let lme9 = ShowLMEItem(name: "Zinc", month: "-", lastt: "-", changes: "", symbol: "")
        let lme10 = ShowLMEItem(name: "Lead", month: "-", lastt: "-", changes: "", symbol: "")
        let lme11 = ShowLMEItem(name: "Lead", month: "-", lastt: "-", changes: "", symbol: "")
        let lme12 = ShowLMEItem(name: "Lead", month: "-", lastt: "-", changes: "", symbol: "")
        items.append(lme1);items.append(lme2);items.append(lme3);items.append(lme4);items.append(lme5);items.append(lme6);items.append(lme7);items.append(lme8);items.append(lme9);items.append(lme10);items.append(lme11);items.append(lme12)
        return items
    }
    
    
    
    
    //    title Cash inventory
    init(lmeDict: [String: AnyObject]) {
        if let name = lmeDict["name"] as? String{
            self._name = name
        }
        if let month = lmeDict["month"] as? String{
            self._month = month
        }
        if let last = lmeDict["last"] as? String{
            self._lastt = last
        }
        if let symbol = lmeDict["symbol"] as? String{
            self._symbol = symbol
        }
        if let change = lmeDict["changes"] as? String{
            self._changes = change
        }
    }
    
    
}

/*class NewExchange{
    
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
}*/
