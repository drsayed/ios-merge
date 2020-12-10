//
//  ChatHistoryOperation.swift
//  myscrap
//
//  Created by MyScrap on 5/16/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class ChatHistoryOperation: AsyncOperation{
    
    var jid: String
    
    var resultLoaded: Bool?
    
    init(jid: String){
        self.jid = jid
    }
    
    var result: Result<[String: AnyObject], APIError>?
    
    override func main() {
        if isCancelled { return }
        let msg = MessageOperation()
        let app = UIApplication.shared.delegate as! AppDelegate
        let moc = app.persistentContainer.viewContext
//        msg.loadChatList (with: moc) { (res) in
//            if isCancelled { return }
//        }
    }
    
    
    
}
