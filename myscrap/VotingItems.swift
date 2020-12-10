//
//  VotingItems.swift
//  myscrap
//
//  Created by MyScrap on 8/5/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

class VotingItems {
    
    //Voters LIST Started
    private var _voterId : String!
    private var _profile_img : String!
    private var _name : String!
    var isSelected : Bool!
    
    //Vote Nominee
    private var _percentage : Int!
    private var _votingCount : Int!
    
    var voterId : String {
        if _voterId == nil{ _voterId = ""};
        return _voterId
    }
    var profile_img : String {
        if _profile_img == nil{ _profile_img = ""};
        return _profile_img
    }
    var name : String {
        if _name == nil{ _name = ""};
        return _name
    }
    var percentage : Int {
        if _percentage == nil{ _percentage = 0};
        return _percentage
    }
    var votingCount : Int {
        if _votingCount == nil{ _votingCount = 0};
        return _votingCount
    }
    
    init (dict: [String: AnyObject]){
        if let voterId = dict["voterId"] as? String {
            self._voterId = voterId
        }
        if let profile_img = dict["profile_img"] as? String {
            self._profile_img = profile_img
        }
        if let name = dict["name"] as? String {
            self._name = name
        }
        if let percentage = dict["percentage"] as? Int {
            self._percentage = percentage
        }
        if let votingCount = dict["votingCount"] as? Int {
            self._votingCount = votingCount
        }
        if let isSelected = dict["isSelected"] as? Bool {
            self.isSelected = isSelected
        }
    }
    //End of Voters LIST
    
    
}
