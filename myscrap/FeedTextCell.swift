//
//  FeedTextCell.swift
//  myscrap
//
//  Created by MS1 on 10/10/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SwiftLinkPreview

class FeedTextCell: FeedNewUserCell   {

    @IBOutlet weak var linkPreviewHeight: NSLayoutConstraint!
    @IBOutlet weak var statusTextView: UserTagTextView?
    @IBOutlet weak var favouriteBtn: FavouriteButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var spinnerView: NVActivityIndicatorView!
    @IBOutlet weak var linkPreviewView: UIView!
    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var linkDescriptionLbl: UILabel!
    @IBOutlet weak var shortLinkLbl: UILabel!
    
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet var fancyViewWidthConstraint : NSLayoutConstraint!

    //LinkPreview
    private var result = Response()
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    
    //weak var updatedDelegate : UpdatedFeedsDelegate?
    /* API V2.0*/
    override var newItem : FeedV2Item? {
        didSet{
            guard let item = newItem else { return }
            configCell(withItem: item)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTap()
        statusTextView?.delegate = self
        setupFriendViewTaps()
        
        let viewWidth = UIScreen.main.bounds.width
        self.fancyViewWidthConstraint.constant = UIScreen.main.bounds.width
    }
    
    
    override func configCell(withItem item: FeedV2Item) {
        super.configCell(withItem: item)
        if item.postedUserId != AuthService.instance.userId {
            /*editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            editButton.setTitleColor(.black, for: .normal)
            editButton.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal)
            editButton.setImage(UIImage(named: ""), for: .normal)
            print("I'm here in edit")
            editButton.isHidden = false*/
            editButton.setTitle("", for: .normal)
            editButton.setImage(#imageLiteral(resourceName: "arrow-triple").withRenderingMode(.alwaysOriginal), for: .normal)
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
        
        var isMod = false
        if item.moderator == "1"{
            isMod = true
        }
        profileTypeView!.checkType = ProfileTypeScore(isAdmin:false,isMod: isMod, isNew:item.newJoined, rank:item.rank, isLevel: item.isLevel, level: item.level)// (isAdmin:false,isMod: item.moderator == "1", isNew:item.newJoined, rank:item.rank, isLevel: item.isLevel, level: item.level)
        
        //Download StackView hide for FeedText
        dwnldStackView.isHidden = true
        
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
    
    func initPhase2(item: FeedV2Item){
        
    }
    
    func setupTap(){
        if network.reachability.isReachable == true {
            statusTextView?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
            tap.numberOfTapsRequired = 1
            statusTextView?.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
    }
    
    func setupAPIViews(item:FeedV2Item){
        statusTextView?.attributedText = item.descriptionStatus
        
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
            linkPreviewView.isHidden = true
        }
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
    @IBAction func likeImgTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("LIKE ***")
            guard let newItem = newItem else { return }
            if let del = updatedDelegate {
                print("delegate is there in feed v2 item", del)
            }
            updatedDelegate?.didTapLikeV2(item: newItem, cell: self)
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
    
    @IBAction func commentTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Comment ***")
            guard let newItem = newItem else { return }
            updatedDelegate?.didTapcommentV2(item: newItem)
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
    
    @IBAction func unreportBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Unreport ***")
            guard  let newItem = newItem else { return }
            updatedDelegate?.didTapUnReportV2(item: newItem, cell: self)
        } else {
            offlineBtnAction?()
        }
    }
}


extension FeedTextCell: UITextViewDelegate{
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        delegate?.didTap(url: URL)
//        return false
//    }
}


