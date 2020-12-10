//
//  PeopleNearByItem.swift
//  myscrap
//
//  Created by MS1 on 11/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

class PeopleNearByItem{
    
    //people near by
    private var _userId: String!
    private var _username: String!
    private var _userimage: String!
    private var _profileLetter: String!
    private var _short_name: String!
    private var _company: String!
    private var _moderator: Bool!
    private var _colorcode: String!
    private var _designation: String!
    private var _distance: String!
    private var _newJoined: Bool!
    private var _jid: String!
    private var _online: Bool!
    private var _points: String!
    private var _rank: String!
    private var _isLevel: Bool!
    private var _level: String!
    
    
    var isAdmin: Bool = false
    
    var userId:String{
        if _userId == nil { _userId = "" } ; return _userId
    }
    var username:String{
        if _username == nil { _username = "" } ; return _username
    }
    var userimage:String{
        if _userimage == nil || _userimage == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || _userimage == "https://myscrap.com/style/images/icons/profile.png" {
            _userimage = ""
        }
        return _userimage
    }
    var profileLetter:String{
        if _profileLetter == nil { _profileLetter = "" } ; return _profileLetter
    }
    var short_name:String{
        if _short_name == nil { _short_name = "" } ; return _short_name
    }
    var company:String{
        if _company == nil { _company = "" } ; return _company
    }
    var moderator:Bool{
        if _moderator == nil
        {
            _moderator = false
        }
        return _moderator
        
    }
    var colorcode:String{
        if _colorcode == nil { _colorcode = "" } ; return _colorcode
    }
    var designation:String{
        if _designation == nil { _designation = "" } ; return _designation
    }
    var distance: String{
        if _distance == nil { _distance = ""} ; return _distance
    }
    var jid:String{
        if _jid == nil { _jid = "" } ; return _jid
    }
    var newJoined:Bool{
        if _newJoined == nil
        {
            _newJoined = true
        }
        return _newJoined
    }
    var online:Bool{
        if _online == nil {
            _online = false
            
        }
        return _online
    }
    var points:String{
        if _points == nil { _points = "" } ; return _points
    }
    var rank:String{
        if _rank == nil { _rank = "" } ; return _rank
    }
    
    var isLevel:Bool {
        if _isLevel == nil { _isLevel = false}; return _isLevel
    }
    
    var level: String {
        if _level == nil { _level = "" }; return _level
    }
    
//    var isMod:Bool {
//        if _isMod == "1" { return true }
//        else { return false }
//    }
    
    
    init(Dict:Dictionary<String,AnyObject>) {
//        super.init(Dict: Dict)
        
        //people near by
        if let userId = Dict["userId"] as? String{
            self._userId = userId
        }
        if let username = Dict["username"] as? String{
            self._username = username
        }
        if let userimage = Dict["userimage"] as? String{
            self._userimage = userimage
        }
        if let profileLetter = Dict["profileLetter"] as? String{
            self._profileLetter = profileLetter
        }
        if let short_name = Dict["short_name"] as? String{
            self._short_name = short_name
        }
        if let company = Dict["company"] as? String{
            self._company = company
        }
        if let moderator = Dict["moderator"] as? Bool{
            self._moderator = moderator
        }
        if let colorcode = Dict["colorcode"] as? String{
            self._colorcode = colorcode
        }
        if let designation = Dict["designation"] as? String{
            self._designation = designation
        }
        if let distance = Dict["distance"] as? String{
            self._distance = distance
        }
        if let jid = Dict["jid"] as? String{
            self._jid = jid
        }
        if let newJoined = Dict["newJoined"] as? Bool{
            self._newJoined = newJoined
        }
        if let online = Dict["online"] as? Bool{
            self._online = online
        }
        if let points = Dict["points"] as? String{
            self._points = points
        }
        if let rank = Dict["rank"] as? String{
            self._rank = rank
        }
        
        if let isLevel = Dict["isLevel"] as? Bool {
            self._isLevel = isLevel
        }
        if let level = Dict["level"] as? String {
            self._level = level
        }
    }
    
}

protocol PeopleNearByDelegate : class {
    func DidReceiveError(error: String)
    func DidReceiveData(data: [PeopleNearByItem], locShared : String)
}


class PeopleService{
    
    weak var delegate: PeopleNearByDelegate?
    
    func getPeopleNearBy(lat: String, long: String){
        let service = APIService()
        service.endPoint = Endpoints.PEOPLE_NEAR_BY_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&userLatitude=\(lat)&userLongitude=\(long)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                self?.handlePeopleNearBy(dict: dict)
            case .Error(let error):
                if let delegate = self?.delegate{
                    delegate.DidReceiveError(error: error)
                }
            }
        }
    }
    
    //MARK:- PEOPLE NEAR BY
    private func handlePeopleNearBy(dict: [String:AnyObject]){
        if let error = dict["error"] as? Bool{
            if !error{
                let locShared = dict["locationShared"] as? String
                if let AddContactsData = dict["data"] as? [[String:AnyObject]]{
                    var data = [PeopleNearByItem]()
                    for obj in AddContactsData{
                        let item = PeopleNearByItem(Dict:obj)
                        data.append(item)
                    }
                    delegate?.DidReceiveData(data: data, locShared: locShared!)
                }
            } else {
                self.delegate?.DidReceiveError(error: "Error in api")
            }
        }
    }
}
