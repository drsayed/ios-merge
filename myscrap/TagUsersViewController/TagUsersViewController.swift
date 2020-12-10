//
//  TagUsersViewController.swift
//  myscrap
//
//  Created by myscrap on 22/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class TagUsersViewController: UIViewController {

    @IBOutlet weak var backCloseButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var usersTagTableView : UITableView!
    @IBOutlet weak var searchCancelButton: UIButton!

    var dataManager: MentionsTableViewDataManager?
    var mentionsListner : SZMentionsListener?

    var mentionItems : [Mention]?

    var selectedTagArray = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.GREEN_PRIMARY
        
        self.usersTagTableView.isHidden = true

        if mentionItems != nil {
            if mentionItems!.count > 0 {
                self.dataManager?.mentions = mentionItems!
            }
        }
        self.setUpViews()
        
//        dataManager.textviewsCondition()
    }
    //MARK:- SetUpViews
    func setUpViews() {
        
        //textView
        self.textView.layer.cornerRadius = 5
        self.textView.layer.masksToBounds = true
        self.textView.text = "@"
        
        //usersTagTableView
        self.usersTagTableView.register(MemberTVC.classForCoder(), forCellReuseIdentifier: "cell")
        self.mentionsListner = SZMentionsListener(mentionTextView: textView, mentionsManager: self)
        self.mentionsListner?.textViewDidChange(textView)
        
        if let listner = mentionsListner{
            dataManager = MentionsTableViewDataManager(mentionTableView: usersTagTableView, mentionsListener: listner, mentionTextView: textView)
        } else {
            print("Listner is not available in view load")
        }
        
        self.usersTagTableView.delegate = dataManager
        self.usersTagTableView.dataSource = dataManager
        self.dataManager?.delegate = self

        self.usersTagTableView.isHidden = false
        self.usersTagTableView.reloadData()
    }

    static func storyBoardReference() -> TagUsersViewController? {
        let storyboard = UIStoryboard(name: "POST", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TagUsersViewController") as? TagUsersViewController
    }

    @IBAction func closeButtonAction(_ sender: Any) {

        if self.textView.text == "" {
            dismissController()
        } else {
            let alert = UIAlertController(title: "Do you want to discard ?", message: nil, preferredStyle: .actionSheet)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            let discardAction = UIAlertAction(title: "Discard", style: .destructive, handler: { [unowned self] (action) in
//                self.postImage = nil
                self.textView.text = ""
                self.dismissController()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(discardAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func dismissController(){
         self.view.endEditing(true)
         //didPost?(true)
//         didPost?(false, false)
         self.dismiss(animated: true, completion: nil)
     }
    
    @IBAction func doneButtonAction(_ sender: Any) {

        if let vc = AddPostV2Controller.storyBoardReference() {
            vc.tagArray = self.selectedTagArray
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK:- MentionsManagerDelegate
extension TagUsersViewController: MentionsManagerDelegate{
   
    func showMentionsListWithString(_ mentionsString: String) {
        usersTagTableView.isHidden = false
        dataManager?.filter(mentionsString)
    }
    
    func hideMentionsList() {
        usersTagTableView.isHidden = false
        dataManager?.filter(nil)
    }
    
    func didHandleMentionOnReturn() -> Bool {
        return true
    }
    
    func textviewsCondition() {
        
        if textView.text.contains("@") {

            if mentionItems != nil {
                if mentionItems!.count > 0 {
                    self.dataManager?.mentions = mentionItems!
                }
            }
        }
    }
}
//MARK:- MentionTableViewDelegate
extension TagUsersViewController: mentionTableViewDelegate {
    func passMentioned(tagname: String, tagId: String) {
        
        self.selectedTagArray.append(["tagId": tagId, "tagName": tagname])

        if textView.text != "" {

            let attbString = NSMutableAttributedString(string: textView.text + " " + tagname, attributes: [NSAttributedString.Key.foregroundColor : UIColor.MyScrapGreen, NSAttributedString.Key.font : UIFont(name:"HelveticaNeue", size: 17.0)])
            textView.attributedText = attbString
        } else {
            self.textView.attributedText = NSAttributedString(string: tagname, attributes: [NSAttributedString.Key.foregroundColor : UIColor.MyScrapGreen, NSAttributedString.Key.font : UIFont(name:"HelveticaNeue", size: 17.0)])
        }

    }
}
