//
//  ReportedFeedTextCell.swift
//  myscrap
//
//  Created by MS1 on 10/10/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SwiftLinkPreview
class ReportedFeedTextCell: FeedNewUserCell {
    
    @IBOutlet weak var linkPreviewHeight: NSLayoutConstraint!
    @IBOutlet weak var linkViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var spinnerView: NVActivityIndicatorView!
    @IBOutlet weak var linkPreviewView: UIView!
    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var linkDescriptionLbl: UILabel!
    @IBOutlet weak var shortLinkLbl: UILabel!
    
    @IBOutlet weak var reportedLbl: UILabel!
    @IBOutlet weak var descriptionText: UserTagTextView!
    @IBOutlet weak var editBtn: EditButton!
    @IBOutlet weak var favBtn: FavouriteButton!
    @IBOutlet weak var likeCommentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var likeCommentsDistance: NSLayoutConstraint!
    @IBOutlet weak var updatedProfileText: UILabel!
    
    //LinkPreview
    private var result = Response()
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    
    override var newItem : FeedV2Item? {
        didSet{
            guard let item = newItem else { return }
            configCell(withItem: item)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTap()
        //descriptionText?.delegate = self
        setupFriendViewTaps()
    }
    

    override func configCell(withItem item: FeedV2Item) {
        super.configCell(withItem: item)
        reportedView.isHidden = true
//        favBtn.isFavourite = item.isPostFavourited
        setupAPIViews(item: item)
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "Reported By • ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.BLACK_ALPHA, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 11)!]))
        attributedString.append(NSAttributedString(string: item.reportBy, attributes: [NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 11)!]))
        reportedLbl.attributedText = attributedString
        reportedLbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(reportedByTap(_:)))
        tap.numberOfTapsRequired = 1
        reportedLbl?.addGestureRecognizer(tap)
        if item.postType == .friendProfilePost {
            updatedProfileText.text = "Updated profile picture."
        }
        else
        {
            updatedProfileText.text = ""
        }
        if (item.likeCount == 0 && item.commentCount == 0  && item.viewsCount == 0 ){
            likeCommentViewHeight.constant = 0
        }
        else{
            likeCommentViewHeight.constant = 22
        }
        if (item.likeCount == 0) {
          
     likeCommentsDistance.constant = -30
        }
        else{
            
   likeCommentsDistance.constant = 10
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
    
    @objc func reportedByTap(_ sender: UITapGestureRecognizer){
        guard let item = newItem else { return }
        updatedDelegate?.didTapForFriendView(id: item.reportedUserId)
    }
    
   
    
    func setupTap(){
        if network.reachability.isReachable == true {
            descriptionText?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
            tap.numberOfTapsRequired = 1
            descriptionText?.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
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
    func setupAPIViews(item:FeedV2Item){
        
        if item.status.contains("http") {
            spinnerView.color = .MyScrapGreen
            spinnerView.type = .ballPulseSync
            spinnerView.startAnimating()
            if linkPreviewView.isHidden {
                linkPreviewView.isHidden = false
                linkPreviewView.layer.cornerRadius = 8
                linkPreviewView.clipsToBounds = true
                linkPreviewView.layer.borderWidth = 0.5
                linkPreviewHeight.constant = 400
                linkViewTopSpace.constant = 10
                linkPreviewView.layer.borderColor = UIColor.lightGray.cgColor
                linkDescriptionLbl.text = ""
                shortLinkLbl.text = ""
                
                
            }
            /*if let url = self.slp.extractURL(text: item.status),
                let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString) {
                
                self.result = cached
                self.setupLinkPreview()
                
                printResult(result)
                
            } else {
                
            }*/
            self.slp.preview(item.status, onSuccess: { result in
                
                self.printResult(result)
                
                self.result = result
                self.setupLinkPreview()
                
            }, onError: { error in
                print(error)
                print("Unable to get the link preview ")
                                
            })
        } else {
            linkPreviewHeight.constant = 0
            linkViewTopSpace.constant = 0
            linkPreviewView.isHidden = true
        }
        
        if (item.likeCount == 0 && item.commentCount == 0  && item.viewsCount == 0 ){
            likeCommentViewHeight.constant = 0
            
        }
        else{
            
            
            likeCommentViewHeight.constant = 22
            if (item.likeCount == 0) {
              
                likeCommentsDistance.constant = -30
            }
            else{
                
                likeCommentsDistance.constant = 10
            }
        }
        if inDetailView {
            likeCommentViewHeight.constant = 0
        }
        descriptionText?.attributedText = item.descriptionStatus
    }
    func printResult(_ result: Response) {
        print("url: ", result.url ?? "no url")
        print("finalUrl: ", result.finalUrl ?? "no finalUrl")
        print("canonicalUrl: ", result.canonicalUrl ?? "no canonicalUrl")
        print("title: ", result.title ?? "no title")
        print("images: ", result.images ?? "no images")
        print("image: ", result.image ?? "no image")
        print("video: ", result.video ?? "no video")
        print("icon: ", result.icon ?? "no icon")
        print("description: ", result.description ?? "no description")
    }
    @IBAction func editBtnPressed(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            guard let item = newItem else { return }
            updatedDelegate?.didTapEditV2(item: item, cell: self)
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
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
        guard  let item = newItem else { return }
        updatedDelegate?.didTapFavouriteV2(item: item, cell: self)
    }
    func setupLinkPreview() {
        
        
        if let value = self.result.images {
            
            if !value.isEmpty {
                if let imageString = value.first {
                    if imageString.contains("blank.png") {
                        self.linkImageView.image = #imageLiteral(resourceName: "no-image")
                    } else {
                        self.linkImageView.sd_setImage(with: URL(string: imageString), completed: nil)
                    }
                    print("Preview image url : \(imageString) ")
                    
                }
            }
        }
        
        if let value: String = self.result.description {
            
            self.linkDescriptionLbl?.text = value.isEmpty ? "No description" : value
            
        } else {
            
            self.linkDescriptionLbl?.text = "No description"
            
        }
        if let value: String = self.result.canonicalUrl {
            
            self.shortLinkLbl?.text = value.isEmpty ? "No description" : value
            
        } else {
            
            self.shortLinkLbl?.text = "No description"
            
        }
        self.spinnerView.stopAnimating()
        let imgtap = UITapGestureRecognizer(target: self, action: #selector(setupLinkTap(_:)))
        imgtap.numberOfTapsRequired = 1
        linkImageView?.addGestureRecognizer(imgtap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(setupLinkTap(_:)))
        tap.numberOfTapsRequired = 1
        linkPreviewView?.addGestureRecognizer(tap)
    }
    
    @objc func setupLinkTap(_ sender: UITapGestureRecognizer) {
        if let link = self.result.finalUrl?.absoluteString {
            updatedDelegate?.didTap(url: link)
        }
        
    }
    @IBAction func likeImgTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("LIKE ***")
            guard let item = newItem else { return }
            if let del = updatedDelegate {
                print("delegate is there in feed item", del)
            }
            updatedDelegate?.didTapLikeV2(item: item, cell: self)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func likeCountTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Like count")
            guard let item = newItem else { return }
            updatedDelegate?.didTapLikeCountV2(item: item)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func commentCountTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Comment count ***")
            guard let item = newItem else { return }
            updatedDelegate?.didTapcommentV2(item: item)
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
