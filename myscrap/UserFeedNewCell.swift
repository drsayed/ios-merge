//
//  UserFeedNewCell.swift
//  myscrap
//
//  Created by MS1 on 10/25/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
class UserFeedNewCell: BaseCell {
    
    weak var delegate: FeedsDelegate?
    weak var updatedDelegate : UpdatedFeedsDelegate?
    var feedV2Service : FeedV2Model?
    

    
    @IBOutlet weak var timeLbl: TimeLabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: DesignationLabel!
    @IBOutlet weak var likeCountBtn: LikeCountButton!
    //@IBOutlet weak var commentCountBtn: CommentCountBtn!
    @IBOutlet weak var commentCountBtn: CommentCountBtn!
    
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
    
    // @IBOutlet weak var reportBtn: ReportButton!
    //@IBOutlet weak var likeImage: LikeImageButton!
    //@IBOutlet weak var likeBtn: LikeButton!
    //@IBOutlet weak var cmntImgBtn: CommentImageButton!
    //@IBOutlet weak var commentBtn: LikeButton!
    //@IBOutlet weak var shareBtn: UIButton!
    
    var offlineBtnAction : (() -> Void)? = nil
    var commentBtnAction : (() -> Void)? = nil
    var addCommentAction : (() -> Void)? = nil
    var likeBtnAction : (() -> Void)? = nil
    var dwnldBtnAction: (() -> Void)? = nil
    
    //DetailViewref
    var inDetailView = false
    
    
    var item : FeedItem? {
        didSet{
            guard let item = item else { return }
            configCell(withItem: item)
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
        //setupFriendViewTaps()
    }
    
//    private func setupFriendViewTaps() {
//        profileView.isUserInteractionEnabled = true
//        let profiletap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
//        profiletap.numberOfTapsRequired = 1
//        profileView.addGestureRecognizer(profiletap)
//        
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
//        tap.numberOfTapsRequired = 1
//        nameLbl.isUserInteractionEnabled = true
//        nameLbl.addGestureRecognizer(tap)
//        
//    }
    
    
    func configCell(withItem item : FeedItem){
        //MARK:- NAME LABEL
        setupNameLabel(reportedFeed: item)
        
         profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:true, rank:nil, isLevel: false, level: nil)
        
        // MARK:- PROFILE VIEW CONFIGURATION
        profileView.updateViews(name: item.postedUserName, url: item.profilePic, colorCode: item.colorCode)
        
        
        
        //MARK:- TIME LABEL
        timeLbl.text = "\(item.timeStamp)"
        print("Checking in wallvc : \(String(describing: timeLbl.text))")
        
        //MARK:- LIKE IMAGE AND COMMENT IMAGE
        likeImage.isLiked = item.likeStatus
        likeCountBtn.likeCount = item.likeCount
        //likeCountBtn.setTitle(item.likedByText, for: .normal)
        commentCountBtn.likeCount = item.likeCount
        commentCountBtn.commentCount = item.commentCount
        reportedView.isHidden = !item.isReported
        unReportBtn.isHidden =  !((item.reportedUserId == AuthService.instance.userId) || item.moderator == "1")
        
        if item.postedUserId == AuthService.instance.userId {
            reportImgBtn.isHidden = true
            reportBtn.isHidden = true
            reportStackView.isHidden = true
        } else {
            reportImgBtn.isHidden = false
            reportBtn.isHidden = false
            reportStackView.isHidden = false
        }
                
    }
    /* API V2.0*/
    func configCell(withItem item : FeedV2Item){
        //MARK:- NAME LABEL
        setupNameLabel(item: item)
        
//        profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:true, rank:nil, isLevel: false, level: nil)
        
        var isMod = false
        if item.moderator == "1"{
            isMod = true
        }
        profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: isMod, isNew:item.newJoined, rank:item.rank ,isLevel: item.isLevel, level: item.level)

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
                
                commentCountBtn.likeCount = item.likeCount
                commentCountBtn.commentCount = item.commentCount
            } else {
                likeCountBtn.isHidden = false
                commentCountBtn.isHidden = false
                likeCountBtn.likeCount = item.likeCount
               commentCountBtn.likeCount = item.likeCount
                commentCountBtn.commentCount = item.commentCount
            }
        }
        
        //MARK:- LIKE IMAGE AND COMMENT IMAGE
        //likeImage.isLiked = item.likeStatus
        
        //MARK:- LIKE IMAGE AND COMMENT IMAGE
        let likeCount = String(format: "%d", item.likeCount)
        likeBtn.setTitle(likeCount, for: .normal)
        likeImage.isLiked = item.likeStatus
        print("Like status : \(item.likeStatus)")
        let cmtCount = String(format: "%d", item.commentCount)
        commentBtn.setTitle(cmtCount, for: .normal)
        
        reportedView.isHidden = !item.isReported
        unReportBtn.isHidden =  !((item.reportedUserId == AuthService.instance.userId) || item.moderator == "1")
        
    }
    
    func setupNameLabel(reportedFeed : FeedItem){
        
        
        //MARK:- Designation Label
        designationLbl.textColor = UIColor.black
        
        
        if reportedFeed.userCompany != "" {
            designationLbl.text = "\(reportedFeed.postedUserDesignation) • \(reportedFeed.userCompany)"
        } else {
            designationLbl.text = reportedFeed.postedUserDesignation
        }
        
        //MARK:- NAME LABEL
        let attributedString = NSMutableAttributedString(string: reportedFeed.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.black])
        nameLbl.attributedText = attributedString
        
    }
    /* API V2.0*/
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
        
    }
    
//    @objc private func toFriendView(_ sender: UITapGestureRecognizer){
//        guard let item = item else { return }
//        delegate?.didTapForFriendView(id: item.postedUserId)
//
//    }
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
            
            if let item = item {
                delegate?.didTapcomment(item: item)
            }
            //        guard let item = item else { return }
            //        delegate?.didTapcomment(item: item)
            if inDetailView {
                //commentBtnAction?()
                
                //User can write comment here in detail page.
                //If no profile pic / no email / no mobile, user can't write comments.
                
                let profilePic = AuthService.instance.profilePic
                let email = AuthService.instance.email
                let mobile = AuthService.instance.mobile
                if (profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || profilePic == "") || (mobile == "" || email == ""){
                    //User can't add comment
                    addCommentAction?()
                } else {
                    commentBtnAction?()
                }
            } else {
                if let item = newItem {
                    updatedDelegate?.didTapcommentV2(item: item)
                }
            }
            
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func likeCountPressed(_ sender: LikeCountButton) {
        if network.reachability.isReachable == true {
            print("like count item tapped")
            //        guard let item = item else { return }
            //        delegate?.didTapLikeCount(item: item)
            guard let item = newItem else { return }
            updatedDelegate?.didTapLikeCountV2(item: item)
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
}
