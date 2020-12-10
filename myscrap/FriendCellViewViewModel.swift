//
//  FriendCellViewViewModel.swift
//  myscrap
//
//  Created by MS1 on 2/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


struct LikeCellViewModel: FriendCellViewViewModel {
    
    
    
    let member : MemberItem
    
    var isLevel: Bool {
        return member.isLevel
    }
    
    var level: String {
        return member.level
    }
    
    var name: String{
        return member.name
    }
    
    var profilePic: String{
        return member.profilePic
    }
    
    var designation: String{
        return member.designation
    }
    
    var country: String{
        return member.country
    }
    
    var isAdmin: Bool{
        return member.isAdmin
    }
    
    var isNew: Bool{
        return member.isNew //defaultly set as false in this module
    }
    
    var isMod: Bool{
        return member.isMod //defaultly set as false in this module
    }
    
    var score: String{
        return member.score
    }
    
    var rank: String{
        return member.rank
    }
    
    var colorCode: String{
        return member.colorCode
    }
    var cc : String {
        return member.colorcode
    }
    
    var id: String{
        return member.userId
    }
    var company: String{
        return member.userCompany
    }
    var points: String{
        if member.points == "" {
            return "0"
        }
        return member.points
    }
    
}

protocol FriendCellViewViewModel{
    
    var name: String { get }
    var profilePic: String { get }
    var designation: String { get }
    var country: String { get }
    var isAdmin: Bool { get }
    var isNew : Bool { get }
    var isMod: Bool { get }
    var score: String { get }
    var rank : String { get }
    var colorCode: String { get }
    var cc: String { get }
    var id: String { get }
    var isLevel: Bool { get }
    var level:String { get}
    var points:String { get}
    var company:String { get}
}

