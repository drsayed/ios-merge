//
//  Member-Ext.swift
//  myscrap
//
//  Created by MS1 on 11/9/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import CoreData

extension Member{

    var profileImage: String {
        guard let img = profilePic , img != "https://myscrap.com/style/images/icons/profile.png" , img != "https://myscrap.com/style/images/icons/no-profile-pic-female.png" else {
            return ""
        }
        return img
    }
    
    var cCode: String {
        return colorCode ?? "41A33B"
    }
    
    
    




    func isMemberExists(with Jid: String, context: NSManagedObjectContext) -> Bool {
        let fetchRequest : NSFetchRequest<Member> = Member.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "jid = %@", Jid)
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    
    // Mark:- Add New Friend
    func createNewMember(userid : String, jid:String, profilePic:String, colorCode: String, name: String, context: NSManagedObjectContext) -> Member? {
        var memberToReturn : Member?
        if let member = NSEntityDescription.insertNewObject(forEntityName: "Member", into: context) as? Member{
            member.id = userid
            member.jid = jid
            member.name = name
            member.profilePic = profilePic
            member.colorCode = colorCode
            memberToReturn = member
        }
        do {
            try context.save()
        } catch let err {
            print(err.localizedDescription)
        }
        return memberToReturn
    }
    

    func getMember(with jid: String , moc: NSManagedObjectContext) -> Member{
        let fetchRequest : NSFetchRequest<Member> = Member.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "jid = %@", jid)
        fetchRequest.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try moc.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.first as! Member
    }

    
    
    
//    // get friend by id
//    func getMember(id: String,moc: NSManagedObjectContext) -> Member{
//        let fetchRequest : NSFetchRequest<Member> = Member.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
//        fetchRequest.fetchLimit = 1
//        var results: [NSManagedObject] = []
//        do {
//            results = try moc.fetch(fetchRequest)
//        }
//        catch {
//            print("error executing fetch request: \(error)")
//        }
//        return results.first as! Member
//    }
    
}
