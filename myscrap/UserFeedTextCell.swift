//
//  UserFeedTextCell.swift
//  myscrap
//
//  Created by MyScrap on 12/15/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class UserFeedTextCell: UserFeedNewCell {

    @IBOutlet weak var statusTextView: UserTagTextView?
    @IBOutlet weak var favouriteBtn: FavouriteButton!
    @IBOutlet weak var editButton: EditButton!
    @IBOutlet weak var editBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpacingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTap()
        statusTextView?.delegate = self
    }
    
    override func configCell(withItem item: FeedV2Item) {
        setupNameLabel(item: item)
        super.configCell(withItem: item)
        
        editButton!.isHidden = !(item.postedUserId == AuthService.instance.userId)
        
        favouriteBtn!.isFavourite = item.isPostFavourited
        favouriteBtn.isHidden = true
        setupAPIViews(item: item)
//        profileTypeView?.checkType = (isAdmin:false,isMod: item.moderator == "1", isNew:item.newJoined, rank:item.rank ,isLevel: item.isLevel, level: item.level)
        
        //HAJA 16Sep2020 Added bottom line
        var isMod = false
        if item.moderator == "1"{
            isMod = true
        }
        profileTypeView?.checkType = ProfileTypeScore(isAdmin:false,isMod: isMod, isNew:item.newJoined, rank:item.rank ,isLevel: item.isLevel, level: item.level)

        //editBtnHeightConstraint.constant = 0
        //favBottomConstraint.constant = 30
        //verticalSpacingConstraint.constant = -5
    }
    
    
    
    func initPhase2(item: FeedV2Item){
        
    }
    
    func setupTap(){
        statusTextView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
        tap.numberOfTapsRequired = 1
        statusTextView?.addGestureRecognizer(tap)
    }
    
    func setupAPIViews(item:FeedV2Item){
        statusTextView?.attributedText = item.descriptionStatus
    }
    
    override func setupNameLabel(item : FeedV2Item){
        
        //MARK:- Designation Label
        designationLbl.text = item.userCompany == "" ? item.postedUserDesignation : "\(item.postedUserDesignation) • \(item.userCompany)"
        
        switch  item.postType {
        case .friendProfilePost , .userProfilePost:
            let attributedString = NSMutableAttributedString(string: item.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.BLACK_ALPHA])
            let updatedProfilePicture = NSAttributedString(string: " updated profile picture.", attributes: [.font: Fonts.NAME_EXTENT_FONT])
            attributedString.append(updatedProfilePicture)
            nameLbl.attributedText = attributedString
        case .friendUserPost:
            let attributedString = NSMutableAttributedString(string: item.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.BLACK_ALPHA])
            if let fname = item.postedFriendName {
                let postedattribute = NSAttributedString(string: " ► \(fname)",/* posted friend name here*/ attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.BLACK_ALPHA])
                attributedString.append(postedattribute)
            }
            nameLbl.attributedText = attributedString
        case .none:
            let attributedString = NSMutableAttributedString(string: item.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.BLACK_ALPHA])
            if let fname = item.postedFriendName {
                let postedattribute = NSAttributedString(string: " ► \(fname)",/* posted friend name here*/ attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.BLACK_ALPHA])
                attributedString.append(postedattribute)
            }
            nameLbl.attributedText = attributedString
        case .eventPost:
            let attributedString = NSMutableAttributedString(string: item.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.BLACK_ALPHA])
            let updatedProfilePicture = NSAttributedString(string: " has posted an event.", attributes: [.font: Fonts.NAME_EXTENT_FONT])
            attributedString.append(updatedProfilePicture)
            nameLbl.attributedText = attributedString
        }
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
                delegate?.didTapForFriendView(id: id)
            }
            if let _ = continueReading{
                delegate?.didTapContinueReading(item: item!, cell: self)
            }
            
            if let link = webLink  {
                delegate?.didTap(url: link)
            }
        }
    }
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        guard let item = newItem else { return }
        //updatedDelegate?.didTapEditV2(item: item, cell: self)
        updatedDelegate?.didTapDeleteOwnPost(item: item, cell: self)
        //updatedDelegate?.feedCollectionView.reloadData()
    }
    
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
        guard  let item = newItem else { return }
        updatedDelegate?.didTapFavouriteV2(item: item, cell: self)
    }
    
    func modReport() {
        guard  let item = newItem else { return }
        updatedDelegate?.didTapReportModV2(item: item, cell: self)
    }
    func SetLikeCountButton()  {
        guard  let item = newItem else { return }
        if item.likeStatus{
            
            if item.likeCount == 2 {
                item.likedByText = "Liked by You and 1 other"
            } else if item.likeCount > 2 {
                item.likedByText = "Liked by You and \(item.likeCount-1) others"
            } else {
                item.likedByText = "Liked by You"
            }
          //  item.likeCount += 1
        }
        else {
          //  item.likeCount -= 1
//            if item.likeCount == 1 {
//                item.likedByText = "Liked by 1 other"
//            } else if item.likeCount >= 2 {
//                item.likedByText = "Liked by \(item.likeCount) others"
//            } else {
//                item.likedByText = ""
//            }
        }
        self.likeCountBtn.setTitle(item.likedByText, for: .normal)

    }
}
extension UserFeedTextCell: UITextViewDelegate{
    //    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    //        delegate?.didTap(url: URL)
    //        return false
    //    }
}
