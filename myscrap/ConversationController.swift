//
//  ConversationController.swift
//  myscrap
//
//  Created by MyScrap on 4/25/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData
import XMPPFramework


private let reuseIdentifier = "Cell"

/*

class ConversationController: UICollectionViewController {
    
    var member : Member!
    fileprivate var dataSource = [MessageModel]()
    
    fileprivate var shouldScrollToBottom = true
    
    
    lazy var profileView : CircleView = {
        let pv = CircleView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = UIColor(hexString: member.colorCode)
        return pv
    }()
    lazy var initialLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        lbl.text = member.name?.initials() ?? "G U"
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()
    lazy var profileImageView: CircularImageView = {
        let pv = CircularImageView()
        pv.contentMode = .scaleAspectFill
        if let url = URL(string: member.profileImage) {
            pv.sd_setImage(with: url, completed: nil)
        }
        return pv
    }()
    
    let stackView : UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sv.axis = .vertical
        return sv
    }()
    
    let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15)!
        return lbl
    }()
    
    let onlineLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.text = ""
        lbl.font = UIFont(name: "HelveticaNeue", size: 15)!
        return lbl
    }()
    
    
    
    private lazy var commentInputView: MSInputView = { [unowned self] in
        let iv = MSInputView()
        iv.delegate = self
        iv.inputTextView.placeholder = "Write a message..."
        return iv
        }()
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var inputAccessoryView: UIView?{
        return commentInputView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavView()
        loadMessages()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    
    private func setupNavView(){
        
        
        let titleView = UIView()
        titleView.backgroundColor = UIColor.clear
        titleView.autoresizingMask = .flexibleWidth
        titleView.frame = CGRect(x: 0, y: 0, width: 400, height: 42)
        
        titleView.addSubview(profileView)
        profileView.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
        
        titleView.addSubview(initialLbl)
        initialLbl.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
        
        titleView.addSubview(profileImageView)
        profileImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.height, height: titleView.frame.height)
        
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(onlineLbl)
        titleView.addSubview(stackView)
        stackView.frame = CGRect(x: titleView.frame.height + 5, y: 0, width: titleView.frame.width - titleView.frame.height - 5 , height: titleView.frame.height)
        
        
        
        self.navigationItem.titleView = titleView
        nameLbl.text = member.name
    }
    
    
    
    
    func loadMessages(){
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let moc = delegate.persistentContainer.viewContext
        guard let id = member.jid else { return }
        let request : NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "member.jid = %@", id)
        request.sortDescriptors = Message.defaultDescriptors
        
        do {
            let messages = try moc.fetch(request)
            var model = [MessageModel]()
            for message in messages {
                if let text = message.text {
                    model.append(MessageModel(text: text, isSender: message.isSender))
                }
            }
            dataSource = model
            collectionView?.reloadData()
//            self.scrollToBottom()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScrollToBottom{
            shouldScrollToBottom = false
            collectionView?.scrollToLastItem()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false

//        setupMsgObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
//        removeMsgObservers()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = dataSource[indexPath.item]
        switch  message.isSender {
        case true:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderCell
            cell.messageLbl.text = message.text
            return cell
        case false:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.messageLabel.text = message.text
            return cell
        }
    }
}




extension ConversationController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let msg = dataSource[indexPath.item]
        let height = messageHeight(for: msg.text)
        return CGSize(width: self.view.frame.width, height: height + 22)
    }
    
    fileprivate func messageHeight(for text: String) -> CGFloat{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "HelveticaNeue", size: 17)!
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth:CGFloat = 240
        let maxsize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxsize)
        return neededSize.height
    }
}


extension ConversationController: MSInputViewDelegate{
    func didPressSendButton(with text: String) {
        guard let jid = member.jid , let userID = member.id , let uName = member.name , let uColor = member.colorCode  else { return }
        XMPPService.instance.sendMessage(with: text, to: jid, userId: userID, fromId: AuthService.instance.userId, uImage: member.profilePic ?? "" , fImage: AuthService.instance.profilePic, uName: uName , fName: AuthService.instance.fullName, uColor: uColor, fColor: AuthService.instance.colorCode)
        
    }
}

extension ConversationController{
    static func storyBoardInstance() -> ConversationController? {
        return UIStoryboard.chat.instantiateViewController(withIdentifier: ConversationController.id) as? ConversationController
    }
}   */

