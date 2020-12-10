//
//  Protocol-ExtVC.swift
//  myscrap
//
//  Created by MS1 on 12/12/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

protocol FriendControllerDelegate where Self:UIViewController  {
    func performFriendView(friendId: String)
}

extension FriendControllerDelegate{
    func performFriendView(friendId: String){
        switch friendId {
        case nil:
            return
        case "":
            return
        case AuthService.instance.userId:
            if let vc = ProfileVC.storyBoardInstance() {
                self.removeBackButtonTitle()

                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            if let vc = FriendVC.storyBoardInstance() {
                vc.friendId = friendId
                self.removeBackButtonTitle()
                UserDefaults.standard.set(friendId, forKey: "friendId")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension UIViewController{
    
    @objc
    func performConversationVC(friendId: String, profileName: String? , colorCode: String? ,profileImage: String?, jid: String, listingId: String, listingTitle: String, listingType: String, listingImg: String){
        
//        let context = app.persistentContainer.viewContext
//        let member = MemberOperation()
        
        if AuthStatus.instance.isGuest{
            self.showGuestAlert()
        } else {
            guard let vc = ConversationVC.storyBoardInstance() else { return }
            
            vc.friendId = friendId
            vc.profileName = profileName ?? ""
            vc.colorCode = colorCode ?? ""
            vc.profileImage = profileImage ?? ""
            vc.jid = jid
            
            //Market POST Link Send as Chat Message
            vc.listingId = listingId
            vc.listingTitle = listingTitle
            vc.listingType = listingType
            vc.listingImg = listingImg
            
            print("Friend ID : \(friendId), Profile Name : \(profileName!), Color Code : \(colorCode!), ProfileImage : \(profileImage!), JID :\(jid)")
            
            self.navigationController?.pushViewController(vc, animated: true)
            /*if member.isMemberExists(with: jid, context: context) {
                vc.member = member.getMember(with: jid, moc: context)
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                guard let name = profileName, let colorCode = colorCode, let profilepic = profileImage else { return }
                if let member = member.createNewMember(userid: friendId, jid: jid, profilePic: profilepic, colorCode: colorCode, name: name, context: context) {
                        vc.member = member
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
            }*/
        }
    }
}


extension UIViewController{
    func removeBackButtonTitle(){
        self.navigationItem.backBarButtonItem?.title = " "
    }
}
