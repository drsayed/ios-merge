//
//  LastMessageViewModel.swift
//  myscrap
//
//  Created by MyScrap on 4/22/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol LastMessagViewModelRepresentable: class{
    func deleteMessage(at indexPath: IndexPath)
    func insertMessage(at indexPath: IndexPath)
}


struct LastMessageViewModel  {
   
    
    
    var isFiltering = false
    
    weak var delegate: LastMessagViewModelRepresentable? 
    
    var messages : [MessageViewModel]
    
    var filteredMessages = [MessageViewModel]()
    
    enum EditingStyle{
        case insert(MessageViewModel, IndexPath)
        case delete(IndexPath)
        case none
    }
    
    mutating func updateMessages(msgs: [MessageViewModel]){
        messages = msgs
    }
    
    
    var numberOfItems: Int {
        if isFiltering{
            return filteredMessages.count
        } else {
            return messages.count
        }
    }
    
    func indexForMessage(message: MessageViewModel) -> Int? {
        if isFiltering{
            return filteredMessages.index(of: message)
        }
        return messages.index(of: message)
    }
    
    func messageForIndex(index: Int) -> MessageViewModel {
        if isFiltering{
            return filteredMessages[index]
        } else {
            return messages[index]
        }
    }
    
    mutating func insertNewMessage(_ message : MessageViewModel){
        if let index = indexForMessage(message: message){
            messages.remove(at: index)
            delegate?.deleteMessage(at: IndexPath(row: index, section: 0))
            messages.insert(message, at: 0)
            delegate?.insertMessage(at: IndexPath(row: 0, section: 0))
        } else {
            messages.insert(message, at: 0)
            delegate?.insertMessage(at: IndexPath(row: 0, section: 0))
        }
    }
    
    var editingStyle: EditingStyle {
        didSet{
            switch editingStyle{
            case .insert(let new, let ip):
                messages.insert(new, at: ip.row)
            case .delete(let ip):
                messages.remove(at: ip.row)
            default:
                break
            }
        }
    }
    
}



extension LastMessageViewModel {
    init(messages:[ MessageViewModel]) {
        self.messages = messages
        editingStyle = .none
    }
    
    
}



final class DemoViewModel{
    
}





























