//
//  CommonUserBottomDownloadView.swift
//  myscrap
//
//  Created by Apple on 23/11/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class CommonUserBottomDownloadView: UIView {

    var contentBackgroundView : UIView!
    
    var likesAndCommentsContentView : UIView!
    var likesCountButton : UIButton!
    var commentsCountButton : UIButton!
    
    
    var downloadContentView : UIView!
    var downloadContentTopSeparatorView : UIView!
    var downloadStackView : UIStackView!
    var likeButton : UIButton!
    var commentButton : UIButton!
    var downloadButton : UIButton!
    var shareButton : UIButton!
    var reportButton : UIButton!
    
    var likesAndCommentViewHeightConstraint : NSLayoutConstraint!
    
    var feedsNewItem : FeedV2Item? {
        didSet{
            guard let item = feedsNewItem else { return }
            configView(withItem: item)
        }
    }

    var offlineBtnAction : (() -> Void)? = nil
    var commentBtnAction : (() -> Void)? = nil
    var addCommentAction : (() -> Void)? = nil
    var likeBtnAction : (() -> Void)? = nil
    var dwnldBtnAction: (() -> Void)? = nil
    
    //DetailViewref
    var inDetailView = false

    weak var feedsDelegate : UpdatedFeedsDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configView(withItem item: FeedV2Item) {

        if item.pictureURL.count > 0 {
            
            self.likesAndCommentViewHeightConstraint.constant = 40

            //Like
            let likesCountStr = self.setUpLikeAndCommentsText(count: item.likeCount, text: "Likes")
            self.likesCountButton.setTitle(likesCountStr, for: .normal)

            //Comment
            let commentCountStr = self.setUpLikeAndCommentsText(count: item.commentCount, text: "Comments")
            self.commentsCountButton.setTitle(commentCountStr, for: .normal)
        }
        else {
            self.likesAndCommentViewHeightConstraint.constant = 0
        }

    }
    
    //MARK:- set Up Like And Comments Text
    func setUpLikeAndCommentsText(count: Int, text: String) -> String{
        
        var titleStr = "\t"
        if count > 0 {
            var likeStr : String = text
            if count == 1 {
                likeStr = String(likeStr.dropLast())
            }
            titleStr = String(format: "%d %@", count, likeStr)
        }
        return titleStr
    }
    //MARK:- setUpViews
    func setUpViews() {
     
        //contentBackgroundView
        self.contentBackgroundView = UIView()
        self.contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.contentBackgroundView.backgroundColor = UIColor.white
        self.addSubview(self.contentBackgroundView)

        //likesAndCommentsContentView
        self.likesAndCommentsContentView = UIView()
        self.likesAndCommentsContentView.translatesAutoresizingMaskIntoConstraints = false
        self.likesAndCommentsContentView.backgroundColor = UIColor.white
        self.contentBackgroundView.addSubview(self.likesAndCommentsContentView)

        self.likesCountButton =  self.setUpButton(title: " ",imgStr:"",isFromStackView: false)
        self.likesCountButton.addTarget(self, action: #selector(likesCountButtonAction), for: .touchUpInside)

        self.commentsCountButton =  self.setUpButton(title: " ",imgStr:"",isFromStackView: false)
        self.commentsCountButton.addTarget(self, action: #selector(commentsCountButtonAction), for: .touchUpInside)

        
        //downloadContentView
        self.downloadContentView = UIView()
        self.downloadContentView.translatesAutoresizingMaskIntoConstraints = false
        self.downloadContentView.backgroundColor = UIColor.white
        self.contentBackgroundView.addSubview(self.downloadContentView)

        //downloadContentTopSeparatorView
        self.downloadContentTopSeparatorView = UIView()
        self.downloadContentTopSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self.downloadContentTopSeparatorView.backgroundColor = UIColor.MSPaleGrayColor
        self.downloadContentView.addSubview(self.downloadContentTopSeparatorView)

        //downloadStackView
        self.downloadStackView = UIStackView()
        self.downloadStackView.translatesAutoresizingMaskIntoConstraints = false
        self.downloadStackView.distribution = UIStackView.Distribution.equalSpacing
        self.downloadStackView.axis = .horizontal
        self.downloadStackView.spacing = 8
        self.downloadContentView.addSubview(self.downloadStackView)
        
        //likeButton
        self.likeButton = self.setUpButton(title: "0", imgStr: "likefeed_48x48", isFromStackView: true)
        self.likeButton.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        
        //commentButton
        self.commentButton = self.setUpButton(title: "0", imgStr: "commentFeed_48x48", isFromStackView: true)
        self.commentButton.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)

        //downloadButton
        self.downloadButton = self.setUpButton(title: "Download", imgStr: "downloadFeed", isFromStackView: true)
        self.downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)

        //shareButton
        self.shareButton = self.setUpButton(title: "Share", imgStr: "shareFeed", isFromStackView: true)
        self.shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)

        //reportButton
        self.reportButton = self.setUpButton(title: "Report", imgStr: "reportFeed", isFromStackView: true)
        self.reportButton.addTarget(self, action: #selector(reportButtonAction), for: .touchUpInside)

        self.setUpConstraints()
     
    }
    
    func setUpButton(title: String,imgStr: String, isFromStackView : Bool) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.HelveticaNeueRegular(fontSize: 14)
        button.setTitleColor(UIColor.black, for: .normal)

        if isFromStackView {
            button.setImage(UIImage(named: imgStr), for: .normal)
            button.alignTextUnderImage(imgsize: CGSize(width: 25, height: 25), spacing: 2)
            self.downloadStackView.addArrangedSubview(button)
        }
        else {
            self.likesAndCommentsContentView.addSubview(button)
        }

        return button
    }
    
    //MARK:- setUpConstraints
    func setUpConstraints() {
        
        //contentBackgroundView
        self.contentBackgroundView.leadingAnchor.constraint(equalTo: self.contentBackgroundView.superview!.leadingAnchor, constant: 0).isActive = true
        self.contentBackgroundView.trailingAnchor.constraint(equalTo: self.contentBackgroundView.superview!.trailingAnchor, constant: 0).isActive = true
        self.contentBackgroundView.topAnchor.constraint(equalTo: self.contentBackgroundView.superview!.topAnchor, constant: 0).isActive = true
        self.contentBackgroundView.bottomAnchor.constraint(equalTo: self.contentBackgroundView.superview!.bottomAnchor, constant: 0).isActive = true

        
        //likesAndCommentsContentView
        self.likesAndCommentsContentView.leadingAnchor.constraint(equalTo: self.likesAndCommentsContentView.superview!.leadingAnchor, constant: 0).isActive = true
        self.likesAndCommentsContentView.trailingAnchor.constraint(equalTo: self.likesAndCommentsContentView.superview!.trailingAnchor, constant: 0).isActive = true
        self.likesAndCommentsContentView.topAnchor.constraint(equalTo: self.likesAndCommentsContentView.superview!.topAnchor, constant: 0).isActive = true
        self.likesAndCommentViewHeightConstraint = self.likesAndCommentsContentView.heightAnchor.constraint(equalToConstant: 40)
        self.likesAndCommentViewHeightConstraint.isActive = true
        
        //likesCountButton
        self.likesCountButton.leadingAnchor.constraint(equalTo: self.likesCountButton.superview!.leadingAnchor, constant: 10).isActive = true
        self.likesCountButton.topAnchor.constraint(equalTo: self.likesCountButton.superview!.topAnchor, constant: 5).isActive = true
        self.likesCountButton.bottomAnchor.constraint(equalTo: self.likesCountButton.superview!.bottomAnchor, constant: -5).isActive = true

        //commentsCountButton
        self.commentsCountButton.trailingAnchor.constraint(equalTo: self.commentsCountButton.superview!.trailingAnchor, constant: -10).isActive = true
        self.commentsCountButton.topAnchor.constraint(equalTo: self.commentsCountButton.superview!.topAnchor, constant: 5).isActive = true
        self.commentsCountButton.bottomAnchor.constraint(equalTo: self.commentsCountButton.superview!.bottomAnchor, constant: -5).isActive = true

        //downloadContentView
        self.downloadContentView.leadingAnchor.constraint(equalTo: self.downloadContentView.superview!.leadingAnchor, constant: 0).isActive = true
        self.downloadContentView.trailingAnchor.constraint(equalTo: self.downloadContentView.superview!.trailingAnchor, constant: 0).isActive = true
        self.downloadContentView.topAnchor.constraint(equalTo: self.likesAndCommentsContentView.bottomAnchor, constant: 0).isActive = true
        self.downloadContentView.bottomAnchor.constraint(equalTo: self.downloadContentView.superview!.bottomAnchor, constant: 0).isActive = true

        self.downloadContentView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        //downloadContentTopSeparatorView
        self.downloadContentTopSeparatorView.leadingAnchor.constraint(equalTo: self.downloadContentTopSeparatorView.superview!.leadingAnchor, constant: 10).isActive = true
        self.downloadContentTopSeparatorView.trailingAnchor.constraint(equalTo: self.downloadContentTopSeparatorView.superview!.trailingAnchor, constant: -10).isActive = true
        self.downloadContentTopSeparatorView.topAnchor.constraint(equalTo: self.downloadContentTopSeparatorView.superview!.topAnchor, constant: 0).isActive = true
        self.downloadContentTopSeparatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true

        
        //downloadStackView
        self.downloadStackView.leadingAnchor.constraint(equalTo: self.downloadStackView.superview!.leadingAnchor, constant: 20).isActive = true
        self.downloadStackView.trailingAnchor.constraint(equalTo: self.downloadStackView.superview!.trailingAnchor, constant: -20).isActive = true
        self.downloadStackView.topAnchor.constraint(equalTo: self.downloadContentTopSeparatorView.bottomAnchor, constant: 5).isActive = true
        self.downloadStackView.bottomAnchor.constraint(equalTo: self.downloadStackView.superview!.bottomAnchor, constant: 0).isActive = true

//        self.downloadContentView.centerXAnchor.constraint(equalTo: self.downloadContentView.superview!.centerXAnchor, constant: 0).isActive = true
//        self.downloadContentView.centerYAnchor.constraint(equalTo: self.downloadContentView.superview!.centerYAnchor, constant: 0).isActive = true
    }
}

//extension UIButton {
//    func alignVertical(spacing: CGFloat = 6.0) {
//        guard let imageSize = self.imageView?.image?.size,
//            let text = self.titleLabel?.text,
//            let font = self.titleLabel?.font
//            else { return }
//        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
//        let labelString = NSString(string: text)
//        let titleSize = labelString.size(withAttributes: [kCTFontAttributeName as NSAttributedStringKey: font])
//        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
//        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
//        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
//    }
//}

extension CommonUserBottomDownloadView {
    
    @objc func commentsCountButtonAction(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Comment count ***")
            guard let newItem = feedsNewItem else { return }
            feedsDelegate?.didTapcommentV2(item: newItem)
        } else {
            offlineBtnAction?()
        }
    }
    
    
    @objc func likeButtonAction(){
        if network.reachability.isReachable == true {
            print("like item pressed")
            //        guard let item = item else { return }
            //        if let del = delegate {
            //            print("delegate is there", del)
            //        }
            //        delegate?.didTapLike(item: item, cell: self)
            
            
            
//            if inDetailView {
//                guard let item = feedsItem else { return }
//                feedsDelegate?.didTapDetailFeedsLikeV2(item: item, cell: self)
//                likeBtnAction?()
//            } else {
//                if let item = feedsItem {
//                    delegate?.didTapLike(item: item, cell: self)
//                }
                
//                guard let item = feedsNewItem else { return }
//               if let del = feedsDelegate {
//                    print("delegate is there", del)
//                }
//                feedsDelegate?.didTapLikeV2(item: item, cell: self)
                
//            }
            
        } else {
            offlineBtnAction?()
        }
    }
    
    
    @objc func commentButtonAction(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Comment ***")
            guard let newItem = feedsNewItem else { return }
            feedsDelegate?.didTapcommentV2(item: newItem)
        } else {
            offlineBtnAction?()
        }
    }
    
//    @objc func toDetailsVC(_ sender: UIButton){
//        if network.reachability.isReachable == true {
//            print("Comment item tapped")
//
//            if let item = item {
//                delegate?.didTapcomment(item: item)
//            }
//            //        guard let item = item else { return }
//            //        delegate?.didTapcomment(item: item)
//            if inDetailView {
//                //commentBtnAction?()
//
//                //User can write comment here in detail page.
//                //If no profile pic / no email / no mobile, user can't write comments.
//
//                let profilePic = AuthService.instance.profilePic
//                let email = AuthService.instance.email
//                let mobile = AuthService.instance.mobile
//                if (profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || profilePic == "") || (mobile == "" || email == ""){
//                    //User can't add comment
//                    addCommentAction?()
//                } else {
//                    commentBtnAction?()
//                }
//            } else {
//                if let item = newItem {
//                    updatedDelegate?.didTapcommentV2(item: item)
//                }
//            }
//
//        } else {
//            offlineBtnAction?()
//        }
//    }
    
    @objc func likesCountButtonAction(_ sender: LikeCountButton) {
        if network.reachability.isReachable == true {
            print("like count item tapped")
            //        guard let item = item else { return }
            //        delegate?.didTapLikeCount(item: item)
            guard let item = feedsNewItem else { return }
            feedsDelegate?.didTapLikeCountV2(item: item)
        } else {
            offlineBtnAction?()
        }
    }
    
    @objc func downloadButtonAction() {
        dwnldBtnAction?()
    }
    
    @objc func shareButtonAction(_ sender: UIButton){
        if network.reachability.isReachable == true {
            guard let item = feedsNewItem else { return }
            feedsDelegate?.didTapShareV2(sender: sender, item: item)
        } else {
            offlineBtnAction?()
        }
    }
    
    @objc func unReportButtonAction() {

    }
//    @objc func unreportBtnPressed(_ sender: UnReportBtn) {
//        if network.reachability.isReachable == true {
//            print("Unreport item tapped")
//            //        guard  let item = item else { return }
//            //        delegate?.didTapUnReport(item: item, cell: self)
//            guard  let item = feedItem else { return }
//            feedsDelegate?.didTapUnReportV2(item: item, cell: self)
//        } else {
//            offlineBtnAction?()
//        }
//    }
    
    @objc func reportButtonAction(sender : UIButton) {
//        if network.reachability.isReachable == true {
//            print("report item tapped")
//            if sender.tag == 0 {
//                //            guard  let item = item else { return }
//                //            delegate?.didTapReport(item: item, cell: self)
//
//                guard  let item = feedsNewItem else { return }
//                feedsDelegate?.didTapReportV2(item: item, cell: self)
//
//            } else {
//                //            guard  let item = item else { return }
//                //            delegate?.didTapReportMod(item: item, cell: self)
//
//                guard  let item = feedsNewItem else { return }
//                feedsDelegate?.didTapReportModV2(item: item, cell: self)
//            }
//        } else {
//            offlineBtnAction?()
//        }
    }
}
