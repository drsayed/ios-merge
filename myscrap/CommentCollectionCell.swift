//
//  CommentCollectionCell.swift
//  myscrap
//
//  Created by MS1 on 11/23/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

protocol CommentCollectionCellDelegate: class {
    func didTapEditButton(cell: CommentCollectionCell)
    func didTapForFriendView(cell: CommentCollectionCell, id: String)
}

extension CommentCollectionCellDelegate  where Self: DetailsVC {
    func didTapEditButton(cell: CommentCollectionCell){
        
        guard let ip = collectionView?.indexPathForItem(at: cell.center) else { return }
        
        let item = commentDataSource[ip.item]
        
        let actions = [
            
            UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                if let vc = EditCommentController.storyBoardInstance() {
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    
                    print(item.comment)
                    
                    vc.item = item
                    vc.commentClosure = { [weak self] item in
                        print(item.comment)
                        self?.insertComment(comment: item.comment, editId: item.commentId)
                    }
                    vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.31)
                    self.present(vc, animated: true, completion: nil)
                }
            }),
            
            UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                //process delete
                self.commentDataSource.remove(at: ip.item)
                self.collectionView?.reloadData()
                if let postId = item.postId{
                    let service = APIService()
                    service.endPoint = Endpoints.COMMENT_DELETE_URL
                    service.params = "userId=\(AuthService.instance.userId)&postId=\(postId)&commentId=\(item.commentId)&apiKey=\(API_KEY)"
                    service.getDataWith(completion: { (_) in
                        print("api called")
                    })
                }
                
            }),
            
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ]
        AlertService.instance.showAlert(in: self, title: nil, message: nil, actions: actions)
    }
    
}

extension CommentCollectionCellDelegate  where Self: FeedsCMDetailsVC {
    func didTapEditButton(cell: CommentCollectionCell){
        
        guard let ip = collectionView?.indexPathForItem(at: cell.center) else { return }
        
        let item = commentDataSource[ip.item]
        
        let actions = [//For testing purpose commenting
            
            UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                if let vc = EditCommentCMVC.storyBoardInstance() {
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    
                    print(item.commentText)
                    
                    vc.item = item
                    vc.commentClosure = { [weak self] item in
                        print(item.commentText)
                        self?.insertComment(comment: item.commentText, editId: item.commentId)
                    }
                    vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.31)
                    self.present(vc, animated: true, completion: nil)
                }
            }),
 
            UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                //process delete
                self.commentDataSource.remove(at: ip.item)
                self.collectionView?.reloadData()
//                if let commentId = item.commentId{
                    let service = APIService()
                    service.endPoint = Endpoints.DELETE_COM_MONTH_COMMENT
                //cmId means here CommentId
                    service.params = "cmId=\(item.commentId)&apiKey=\(API_KEY)"
                    service.getDataWith(completion: { (_) in
                        print("api called")
                    })
//                }
 
            }),
            
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ]
        AlertService.instance.showAlert(in: self, title: nil, message: nil, actions: actions)
    }
    
}
extension CommentCollectionCellDelegate  where Self: FeedsPOWDetailsVC {
    func didTapEditButton(cell: CommentCollectionCell){
        
        guard let ip = collectionView?.indexPathForItem(at: cell.center) else { return }
        
        let item = commentDataSource[ip.item]
        
        let actions = [//For testing purpose commenting
            
            UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                if let vc = EditCommentPOWVC.storyBoardInstance() {
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    
                    print(item.commentText)
                    
                    vc.item = item
                    vc.commentClosure = { [weak self] item in
                        print(item.commentText)
                        self?.insertComment(comment: item.commentText, editId: item.commentId)
                    }
                    vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.31)
                    self.present(vc, animated: true, completion: nil)
                }
            }),
            
            UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                //process delete
                self.commentDataSource.remove(at: ip.item)
                self.collectionView?.reloadData()
                //                if let commentId = item.commentId{
                let service = APIService()
                service.endPoint = Endpoints.DELETE_POW_COMMENT_URL
                //cmId means here CommentId
                service.params = "powCommentId=\(item.commentId)&apiKey=\(API_KEY)&userId=\(AuthService.instance.userId)"
                service.getDataWith(completion: { (_) in
                    print("api called")
                })
                //                }
                
            }),
            
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ]
        AlertService.instance.showAlert(in: self, title: nil, message: nil, actions: actions)
    }
    
}

extension CommentCollectionCellDelegate where Self: FriendControllerDelegate{
    func didTapForFriendView(cell: CommentCollectionCell, id: String){
        performFriendView(friendId: id)
    }
}

class CommentCollectionCell: BaseCell {
    
    weak var delegate: CommentCollectionCellDelegate?
    
    @IBOutlet private weak var profileView: ProfileView!
    @IBOutlet private weak var userView: UserView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var desigLbl: UILabel!
    @IBOutlet private weak var commentLbl: UILabel!
    @IBOutlet weak var editButton: EditButton!
    @IBOutlet weak var commentTextView: UserTagTextView!
    var offlineBtnAction : (() -> Void)? = nil
    
    var item : CommentItem? {
        didSet{
            guard let item = item else { return }
            configcell(item: item)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTap()
        setupFriendViewTaps()
        
    }
    
    func setupTap(){
        if network.reachability.isReachable == true {
            commentTextView?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
            tap.numberOfTapsRequired = 1
            commentTextView?.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
    }
    private func setupFriendViewTaps() {
        if network.reachability.isReachable == true {
            profileView.isUserInteractionEnabled = true
            let profiletap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
            profiletap.numberOfTapsRequired = 1
            profileView.addGestureRecognizer(profiletap)
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
            tap.numberOfTapsRequired = 1
            nameLbl.isUserInteractionEnabled = true
            nameLbl.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
    }
    
    func configcell(item: CommentItem){
        print("Comment timestamp \(item.timeStamp)")
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
    
        
        editButton.isHidden = !(AuthService.instance.userId == item.userId)
        nameLbl.text = item.name
        /*if AuthService.instance.userId == item.userId {
            desigLbl.text = AuthService.instance.designation
        } else {
            desigLbl.text = item.designation
        }*/
        if item.timeStamp == "" {
            desigLbl.text = "Just now"
        } else {
            desigLbl.text = item.timeStamp
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        
        
        //let attributedString = NSMutableAttributedString(string: item.comment, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedStringKey.font: Fonts.descriptionFont, NSAttributedString.Key.paragraphStyle: style])
    
        commentTextView.attributedText = item.commentTextAttrib
        print("Comment : \(commentTextView.attributedText)")
    }
    
    @objc func DidTappedTextView(_ sender: UITapGestureRecognizer){
        let textView = sender.view as! UITextView
        let layoutManager = textView.layoutManager
        //location of tap in textview coordinates and taking the inset into account
        var location = sender.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        //character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        // if index is valid
        if characterIndex < textView.textStorage.length{
            let friendId = textView.attributedText.attribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.USERTAG), at: characterIndex, effectiveRange: nil) as? String
            let continueReading = textView.attributedText.attribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.CONTINUE_READING), at: characterIndex, effectiveRange: nil) as? String
            let webLink = textView.attributedText.attribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.URL), at: characterIndex, effectiveRange: nil) as? String
            
            if let id = friendId {
                delegate?.didTapForFriendView(cell: self, id: id)
            }
            if let _ = continueReading{
                //updatedDelegate?.didTapContinueReadingV2(item: newItem!, cell: self)
            }
            
            if let link = webLink  {
                //updatedDelegate?.didTap(url: link)
            }
        }
    }
    
    @objc private func toFriendView(_ sender: UITapGestureRecognizer){
        
        delegate?.didTapForFriendView(cell: self, id: item!.userId)
    }
    
    func configCMCell(item: CommentCMItem) {
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorcode)
        
        
        editButton.isHidden = !(AuthService.instance.userId == item.userId)
        nameLbl.text = item.name
        if item.timeStamp == "" {
            desigLbl.text = "Just now"
        } else {
            desigLbl.text = item.timeStamp
        }
        //commentTextView.text = item.commentText
        commentTextView.attributedText = item.commentTextAttrib
        print("Comment : \(commentTextView.attributedText)")
    }
    
    func configPOWCell(item: CommentPOWItem) {
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorcode)
        
        
        editButton.isHidden = !(AuthService.instance.userId == item.userId)
        nameLbl.text = item.name
        if item.timeStamp == "" {
            desigLbl.text = "Just now"
        } else {
            desigLbl.text = item.timeStamp
        }
        //commentTextView.text = item.commentText
        commentTextView.attributedText = item.commentTextAttrib
        print("Comment : \(commentTextView.attributedText)")
    }

    @IBAction func editButtonPressed(_ sender: EditButton) {
        delegate?.didTapEditButton(cell: self)
    }
    
}


class UserView: UIView{ }
