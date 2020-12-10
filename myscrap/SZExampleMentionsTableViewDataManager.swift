//
//  SZExampleMentionsTableViewDataManager.swift
//  myscrap
//
//  Created by MS1 on 12/14/17.
//  Copyright © 2017 sayedmetal. All rights reserved.
//

import Foundation

class MentionsTableViewDataManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var listener: SZMentionsListener?
    var mentions = [SZExampleMention](){
        didSet{
            tableView?.reloadData()
        }
    }
    
    private var tableView: UITableView?
    private var filterString: String?
    
    init(mentionTableView: UITableView, mentionsListener: SZMentionsListener) {
        tableView = mentionTableView
        tableView!.register(
            MemberTVC.classForCoder(),
            forCellReuseIdentifier: "cell")
        listener = mentionsListener
    }
    
    func filter(_ string: String?) {
        filterString = string
        tableView?.reloadData()
    }
    
    private func mentionsList() -> [SZExampleMention] {
        var filteredMentions = mentions
        
        if (filterString?.count ?? 0 > 0) {
            filteredMentions = mentions.filter() {
                if let type = ($0 as SZExampleMention).mentionName as String! {
                    return type.lowercased().contains(filterString!.lowercased())
                } else {
                    return false
                }
            }
        }
        
        return filteredMentions
    }
    
    func firstMentionObject() -> SZExampleMention? {
        return mentionsList().first
    }
    
    func addMention(_ mention: SZExampleMention) {
        listener!.addMention(mention)
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
        self.addMention(mentionsList()[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
