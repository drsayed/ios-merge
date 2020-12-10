//
//  MentionsTableViewDataManager.swift
//  myscrap
//
//  Created by MS1 on 12/14/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
protocol mentionTableViewDelegate: class {
    func passMentioned(tagname: String, tagId: String)
}

class MentionsTableViewDataManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var listener: SZMentionsListener?   //3rd Party Lib for mention with @
    private var textView : UITextView?
    var mentions = [Mention](){
        didSet{
            tableView?.reloadData()
        }
    }
    
    private var tableView: UITableView?
    private var filterString: String?
    var delegate : mentionTableViewDelegate?

    
    init(mentionTableView: UITableView, mentionsListener: SZMentionsListener,mentionTextView : UITextView) {
        tableView = mentionTableView
        tableView!.register(
            MemberTVC.classForCoder(),
            forCellReuseIdentifier: "cell")
        listener = mentionsListener
        textView = mentionTextView
        
    }
    
    func filter(_ string: String?) {
        filterString = string
        //tableView?.isHidden = false //Custom Mah
        tableView?.reloadData()
    }
    
    private func mentionsList() -> [Mention] {
        var filteredMentions = mentions
        
        if (filterString?.count ?? 0 > 0) {
             /*
            filteredMentions = mentions.filter() {
                if let type = ($0 as Mention).mentionName.firstLetter() as String? {
                    //let filter_first = mentions.filter { $0.mentionName.contains(type.firstLetter()) }
                    
                    let new_type = ($0 as Mention).mentionName as String?
                    //print("New Type: \(new_type), Filter: \(filterString)")
                    if type.lowercased() == filterString {
                        return type.lowercased().contains(filterString!.lowercased())
                    } else if type.lowercased() == filterString!.firstLetter() && (new_type?.lowercased().contains(filterString!.lowercased()))!{
                        return new_type!.lowercased().contains(filterString!.lowercased())
                    } else {
                        return false
                    }
                    
                } else {
                    return false
                }
            } */
            
            filteredMentions = mentions.filter { $0.mentionName.lowercased().contains(filterString!) }

        }
      
         
    //    }
        return filteredMentions
    }
    
    func firstMentionObject() -> Mention? {
        return mentionsList().first
    }
    
    func addMention(_ mention: Mention) {
        let isFound = listener!.addMention(mention)
        if !isFound {
            print("Couldn't add the mentioners into list")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionsList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MemberTVC else { return UITableViewCell() }
        cell.member = mentionsList()[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (textView?.text.contains("@"))! {
            self.addMention(mentionsList()[indexPath.row])
        } else {
            let name = mentionsList()[indexPath.row].mentionName
            let id = mentionsList()[indexPath.row].mentionId
            let mention = mentionsList()[indexPath.row]
            //delegate = AddPostV2Controller()
            delegate!.passMentioned(tagname: name, tagId: id)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

