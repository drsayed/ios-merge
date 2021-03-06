//
//  EmplImageTextCell.swift
//  myscrap
//
//  Created by MyScrap on 23/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class EmplImageTextCell: BaseCell {
    
    @IBOutlet weak var feedImage: UIImageView!
    
    weak var delegate: FeedsDelegate?
    weak var updatedDelegate : UpdatedFeedsDelegate?
    var feedV2Service : FeedV2Model?
    
    @IBOutlet weak var timeLbl: TimeLabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: DesignationLabel!
    @IBOutlet weak var likeCountBtn: LikeCountButton!
    //@IBOutlet weak var commentCountBtn: CommentCountBtn!
    @IBOutlet weak var commentCountBtn: CommentCountBtnV2!
    
    @IBOutlet weak var statusTextView: UserTagTextView?
    @IBOutlet weak var favouriteBtn: FavouriteButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var likeImage: LikeImageV2FeedButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var cmntImgBtn: CommentImageButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var downloadImgBtn: UIButton!
    @IBOutlet weak var dwnldBtn: UIButton!
    @IBOutlet weak var shareImgBtn: ShareImageV2Button!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var reportImgBtn: ReportImgV2Button!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var reportStackView: UIStackView!
    @IBOutlet weak var dwnldStackView: UIStackView!
    
    @IBOutlet weak var reportedView: ReportedView!
    @IBOutlet weak var unReportBtn: UnReportBtn!
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: FeedProfileTypeView!
    
    var offlineBtnAction : (() -> Void)? = nil
    var commentBtnAction : (() -> Void)? = nil
    var likeBtnAction : (() -> Void)? = nil
    var dwnldBtnAction: (() -> Void)? = nil
    
    //DetailViewref
    var inDetailView = false
    
    
    var item : FeedItem? {
        didSet{
            guard let item = item else { return }
            //configCell(withItem: item)
        }
    }
    
    var newItem : FeedV2Item? {
        didSet{
            guard let item = newItem else { return }
            configCell(withItem: item)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        if network.reachability.isReachable == true {
            feedImage.contentMode = .scaleAspectFill
            feedImage.clipsToBounds = true
            feedImage.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.numberOfTapsRequired = 1
            feedImage.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
        
        setupFriendViewTaps()
        setupTap()
    }
    
    /* API V2.0*/
    func configCell(withItem item : FeedV2Item){
        //MARK:- NAME LABEL
        setupNameLabel(item: item)
        
        profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:true, rank:nil, isLevel: false, level: nil)
        
        // MARK:- PROFILE VIEW CONFIGURATION
        profileView.updateViews(name: item.postedUserName, url: item.profilePic, colorCode: item.colorCode)
        
        
        
        //MARK:- TIME LABEL
        timeLbl.text = "\(item.timeStamp)"
        print("Checking in wallvc : \(String(describing: timeLbl.text))")
        
        /*if inDetailView {
         
         likeCountBtn.isHidden = true
         commentCountBtn.isHidden = true
         commentCountBtn.isHidden = true
         } else {
         likeCountBtn.likeCount = item.likeCount
         commentCountBtn.likeCount = item.likeCount
         commentCountBtn.commentCount = item.commentCount
         }*/
        if inDetailView {
            likeCountBtn.isHidden = true
            commentCountBtn.isHidden = true
        } else {
            if item.likeCount == 0 && item.commentCount == 0{
                likeCountBtn.isHidden = true
                commentCountBtn.isHidden = true
            } else if item.likeCount != 0 && item.commentCount == 0 {
                likeCountBtn.isHidden = false
                commentCountBtn.isHidden = true
                
                likeCountBtn.likeCount = item.likeCount
            } else if item.likeCount == 0 && item.commentCount != 0 {
                likeCountBtn.isHidden = true
                commentCountBtn.isHidden = false
                
                //commentCountBtn.likeCount = item.likeCount
                commentCountBtn.commentCount = item.commentCount
            } else {
                likeCountBtn.isHidden = false
                commentCountBtn.isHidden = false
                likeCountBtn.likeCount = item.likeCount
                //commentCountBtn.likeCount = item.likeCount
                commentCountBtn.commentCount = item.commentCount
            }
        }
        
        //MARK:- LIKE IMAGE AND COMMENT IMAGE
        //likeImage.isLiked = item.likeStatus
        
        //MARK:- LIKE IMAGE AND COMMENT IMAGE
        let likeCount = String(format: "%d", item.likeCount)
        likeBtn.setTitle(likeCount, for: .normal)
        likeImage.isLiked = item.likeStatus
        let cmtCount = String(format: "%d", item.commentCount)
        commentBtn.setTitle(cmtCount, for: .normal)
        
        reportedView.isHidden = !item.isReported
        unReportBtn.isHidden =  !((item.reportedUserId == AuthService.instance.userId) || item.moderator == "1")
        
        
        //Post config common
        if item.postedUserId != AuthService.instance.userId {
            /*editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
             editButton.setTitleColor(.black, for: .normal)
             editButton.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal)
             editButton.setImage(UIImage(named: ""), for: .normal)
             print("I'm here in edit")
             editButton.isHidden = false*/
            editButton.setTitle("", for: .normal)
            editButton.setImage(#imageLiteral(resourceName: "arrow-double").withRenderingMode(.alwaysOriginal), for: .normal)
            //editButton.tintColor = UIColor.BLACK_ALPHA
            editButton.isHidden = false
        } else {
            editButton.isHidden = false
            editButton.setTitle("", for: .normal)
            editButton.setImage(#imageLiteral(resourceName: "ellipsis2").withRenderingMode(.alwaysTemplate), for: .normal)
            editButton.tintColor = UIColor.BLACK_ALPHA
        }
        //editButton.isHidden = !(item.postedUserId == AuthService.instance.userId)
        favouriteBtn.isFavourite = item.isPostFavourited
        setupAPIViews(item: item)
        profileTypeView?.checkType = (isAdmin:false,isMod: item.moderator == "1", isNew:item.newJoined, rank:item.rank, isLevel: item.isLevel, level: item.level)
        
        //Download StackView hide for only FeedText
        dwnldStackView.isHidden = false
        
    }
    
    func setupAPIViews(item:FeedV2Item){
        statusTextView?.attributedText = item.descriptionStatus
        if let imageString = item.pictureURL.last?.images{
            feedImage.setImageWithIndicator(imageURL: imageString)
        }
    }
    
    func setupTap(){
        statusTextView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
        tap.numberOfTapsRequired = 1
        statusTextView?.addGestureRecognizer(tap)
    }
    
    func setupNameLabel(item : FeedV2Item){
        //Here previously designation label and name label color set as white, For maha ref keeping the note
        //MARK:- Designation Label
        designationLbl.textColor = UIColor.black
        
        if item.userCompany != "" {
            designationLbl.text = "\(item.postedUserDesignation) • \(item.userCompany)"
        } else {
            designationLbl.text = item.postedUserDesignation
        }
        print("Posted user name : \(item.postedUserName)")
        //MARK:- NAME LABEL
        let attributedString = NSMutableAttributedString(string: item.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.black])
        nameLbl.attributedText = attributedString
        
        //Post config common
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
    
    @objc private func toFriendView(_ sender: UITapGestureRecognizer){
        guard let item = newItem else { return }
        updatedDelegate?.didTapForFriendView(id: item.postedUserId)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer){
        //        guard let item = item else { return }
        //        delegate?.didTapImageView(item: item)
        /* APIV2.0 */
        guard let item = newItem else { return }
        updatedDelegate?.didTapImageViewV2(atIndex: 0, item: item)
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
                updatedDelegate?.didTapForFriendView(id: id)
            }
            if let _ = continueReading{
                updatedDelegate?.didTapContinueReadingV2(item: newItem!, cell: self)
            }
            
            if let link = webLink  {
                updatedDelegate?.didTap(url: link)
            }
        }
    }
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            guard let item = newItem else { return }
            if item.postedUserId != AuthService.instance.userId {
                updatedDelegate?.didTapForFriendView(id: item.postedUserId)
            } else {
                updatedDelegate?.didTapEditV2(item: item, cell: self)
            }
            
        } else {
            offlineBtnAction?()
        }
        //        guard let item = item else { return }
        //        delegate?.didTapEdit(item: item, cell: self)
    }
    
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            guard  let item = newItem else { return }
            updatedDelegate?.didTapFavouriteV2(item: item, cell: self)
        } else {
            offlineBtnAction?()
        }
        //        guard  let item = item else { return }
        //        delegate?.didTapFavourite(item: item, cell: self)
    }
    
    func modReport() {
        //        guard  let item = item else { return }
        //        delegate?.didTapReportMod(item: item, cell: self)
        guard  let item = newItem else { return }
        updatedDelegate?.didTapReportModV2(item: item, cell: self)
    }
    
    @IBAction func likePressed(_ sender: UIButton){
        if network.reachability.isReachable == true {
            print("like item pressed")
            //        guard let item = item else { return }
            //        if let del = delegate {
            //            print("delegate is there", del)
            //        }
            //        delegate?.didTapLike(item: item, cell: self)
            
            
            
            if inDetailView {
                guard let item = newItem else { return }
                updatedDelegate?.didTapDetailFeedsLikeV2(item: item, cell: self)
                likeBtnAction?()
            } else {
                if let item = item {
                    delegate?.didTapLike(item: item, cell: self)
                }
                
                guard let item = newItem else { return }
                if let del = updatedDelegate {
                    print("delegate is there", del)
                }
                updatedDelegate?.didTapLikeV2(item: item, cell: self)
                
            }
            
        } else {
            offlineBtnAction?()
        }
    }
    @IBAction func toDetailsVC(_ sender: UIButton){
        if network.reachability.isReachable == true {
            print("Comment item tapped")
            
//            if let item = item {
//                delegate?.didTapcomment(item: item)
//            }
            //        guard let item = item else { return }
            //        delegate?.didTapcomment(item: item)
            if inDetailView {
                commentBtnAction?()
            } else {
                if let item = newItem {
                    updatedDelegate?.didTapcommentV2(item: item)
                }
            }
            
        } else {
            offlineBtnAction?()
        }
    }
    
    
    @IBAction func likeCountTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Like count")
            guard let newItem = newItem else { return }
            updatedDelegate?.didTapLikeCountV2(item: newItem)
        } else {
            offlineBtnAction?()
        }
    }
    
    
    @IBAction func commentCountTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Comment count ***")
            guard let newItem = newItem else { return }
            updatedDelegate?.didTapcommentV2(item: newItem)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func dwnldBtnTapped(_ sender: UIButton) {
        dwnldBtnAction?()
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton){
        if network.reachability.isReachable == true {
            guard let item = newItem else { return }
            updatedDelegate?.didTapShareV2(sender: sender, item: item)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func unreportBtnPressed(_ sender: UnReportBtn) {
        if network.reachability.isReachable == true {
            print("Unreport item tapped")
            //        guard  let item = item else { return }
            //        delegate?.didTapUnReport(item: item, cell: self)
            guard  let item = newItem else { return }
            updatedDelegate?.didTapUnReportV2(item: item, cell: self)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func unreportBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Unreport ***")
            guard  let newItem = newItem else { return }
            updatedDelegate?.didTapUnReportV2(item: newItem, cell: self)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func reportBtnPressed(_ sender: ReportButton) {
        if network.reachability.isReachable == true {
            print("report item tapped")
            if sender.tag == 0 {
                //            guard  let item = item else { return }
                //            delegate?.didTapReport(item: item, cell: self)
                
                guard  let item = newItem else { return }
                updatedDelegate?.didTapReportV2(item: item, cell: self)
                
            } else {
                //            guard  let item = item else { return }
                //            delegate?.didTapReportMod(item: item, cell: self)
                
                guard  let item = newItem else { return }
                updatedDelegate?.didTapReportModV2(item: item, cell: self)
            }
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func reportBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Report ***")
            if sender.tag == 0 {
                guard  let newItem = newItem else { return }
                updatedDelegate?.didTapReportV2(item: newItem, cell: self)
            } else {
                guard  let newItem = newItem else { return }
                updatedDelegate?.didTapReportModV2(item: newItem, cell: self)
                
            }
        } else {
            offlineBtnAction?()
        }
    }

}
