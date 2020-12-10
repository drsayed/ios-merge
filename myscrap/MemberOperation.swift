//
//  FriendOperation.swift
//  myscrap
//
//  Created by MyScrap on 5/16/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
import CoreData

class MemberOperation{
    
     func fetchMembers(with context: NSManagedObjectContext) -> [Member]? {
        
        let fetchRequest: NSFetchRequest<Member> = Member.fetchRequest()
//        fetchRequest.resultType = .dictionaryResultType
        var results : [Member]?
        do {
            results = try context.fetch(fetchRequest)
        } catch {
            return nil
        }
        return results
    }
    
    func fetchMembersFromRemote(){
        let service = APIService()
        service.endPoint = Endpoints.ADD_CONTACTS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=0"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let service = MemmberModel()
                service.saveDatainBackground(dict: dict)
            case .Error(let error):
                print(error.description)
            }
        }
    }
    
    typealias completionHandler = (_ success: Bool, _ error: String?, _ data: [MemberItem]?) -> ()
    
    func getMembers(pageLoad: String,searchText: String, orderBy: String, completion: @escaping (APIResult<[MemberItem]>) -> ()) {
        let service = APIService()
        service.endPoint = Endpoints.ADD_CONTACTS_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&pageLoad=\(pageLoad)&searchText=\(searchText)&orderByText=\(orderBy)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                let data = self.handleJSON(dict: dict)
                completion(APIResult.Success(data))
            case .Error(let error):
                completion(APIResult.Error(error))
            }
        }
    }
    
    private func handleJSON(dict: [String:AnyObject]) -> [MemberItem] {
        var data = [MemberItem]()
        if let error = dict["error"] as? Bool{
            if !error{
                if let AddContactsData = dict["addContactsData"] as? [[String:AnyObject]]{
                    for obj in AddContactsData{
                        let item = MemberItem(Dict:obj)
                        data.append(item)
                    }
                }
                return data
            } else {
                print("Member's fetch error")
            }
        }
        return data
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
    
    func updtMember(with Jid: String,userId: String, name: String, profilePic: String, colorCode: String,designation: String? = nil,  with moc: NSManagedObjectContext) -> Member? {
        
        let fetchRequest : NSFetchRequest<Member> = Member.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "jid = %@", Jid)
        
//        var member: Member?
        
        do {
             if let memb = try moc.fetch(fetchRequest).first {
                return memb
             } else {
                if let memb = NSEntityDescription.insertNewObject(forEntityName: "Member", into: moc) as? Member{
                    memb.id = userId
                    memb.jid = Jid
                    memb.name = name
                    memb.profilePic = profilePic
                    memb.colorCode = colorCode
                    
                    if let desig = designation {
                        memb.designation = desig
                    }
                    
                    do {
                        try moc.save()
                        return memb
                    }
                    
                }
            }
        }
        catch {
            print("error executing fetch request: \(error)")
            return nil
        }
        
        return nil
        
    }
    
    
    
    func updateFriend(with jid: String,userId: String, name: String, profilePic: String,colorCode:String, designation: String? = nil, with moc: NSManagedObjectContext) -> Member?{
        let fetchRequest : NSFetchRequest<Member> = Member.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "jid = %@", jid)
        
        do {
            
            if let memb = try moc.fetch(fetchRequest).first{
                memb.profilePic = profilePic
                do {
                    try moc.save()
                    return memb
                }
            } else {
                let mem = Member(context: moc)
                mem.jid = jid
                mem.id = userId
                mem.name = name
                mem.profilePic = profilePic
                mem.colorCode = colorCode
                if let desig = designation{
                    mem.designation = desig
                }
                
                do {
                    try moc.save()
                    return mem
                }
            }
            
        } catch{
            print("Catched Error")
            return nil
        }
        
    }
    
    
    
    // Mark:- Add New Friend
    func createNewMember(userid : String, jid:String, profilePic:String, colorCode: String, name: String, context: NSManagedObjectContext, designation: String? = nil ) -> Member? {
        var memberToReturn : Member?
        if let member = NSEntityDescription.insertNewObject(forEntityName: "Member", into: context) as? Member{
            member.id = userid
            member.jid = jid
            member.name = name
            member.profilePic = profilePic
            member.colorCode = colorCode
            
            
            
            if let desig = designation {
                member.designation = desig
            }
            
            
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

    
    func getMembersWithoutDesignation(with jid: String, moc: NSManagedObjectContext) -> Member? {
        let fetchRequest : NSFetchRequest<Member> = Member.fetchRequest()
        let predicateExistsJId = NSPredicate(format: "jid = %@", jid)
        let predicateDesignation =  NSPredicate(format: "designation == nil")
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateExistsJId, predicateDesignation])
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try moc.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.first as? Member
        
        
    }
    
    func updateMember(with jid: String,userId: String , profilePic: String, colorCode:String, name: String, designation: String,  moc: NSManagedObjectContext){
        if !isMemberExists(with: jid, context: moc){
         let _ = createNewMember(userid: userId, jid: jid, profilePic: profilePic, colorCode: colorCode, name: name,  context: moc, designation: designation )
        }
    }
    
    func updateMember(of jid: String, designation: String, with moc: NSManagedObjectContext){
        let fetchRequest : NSFetchRequest<Member> = Member.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "jid = %@", jid)
        fetchRequest.fetchLimit = 1
        do {
            if let member = try moc.fetch(fetchRequest).first{
               member.designation = designation
            }
            do {
                try moc.save()
            } catch {
                print(error.localizedDescription)
            }
            
        } catch {
            print("executing error")
        }
    }
    
    
    
}
