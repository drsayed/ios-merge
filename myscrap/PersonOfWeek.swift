//
//  PersonOfWeek.swift
//  myscrap
//
//  Created by MyScrap on 7/14/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class PersonOfWeek: BaseCell {
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var favBtn: FavouriteButton!
    @IBOutlet weak var likeImage: LikeImageButton!
    @IBOutlet weak var totalLikes: LikeCountButton!
    @IBOutlet weak var commentImg: CommentImageButton!
    @IBOutlet weak var totalComments: CommentCountBtn!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerTitleLbl: UILabel!
    @IBOutlet weak var powDescriptionTextView: UserTagTextView!
    @IBOutlet weak var readMoreBtn: UIButton!
    
    var offlineActionBlock : (() -> Void)? = nil
    
    weak var updatedDelegate : UpdatedFeedsDelegate?
    var item : FeedV2Item? {
        didSet{
            guard let item = item else { return }
            configCell(withItem: item)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
//        powDescriptionTextView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
//        tap.numberOfTapsRequired = 1
//        powDescriptionTextView.addGestureRecognizer(tap)
        readMoreBtn.setTitle("Read More...", for: .normal)
    }
    /* API V2.0*/
    func configCell(withItem item : FeedV2Item){
        bannerTitleLbl.text = item.pwbannerTitle
        //powDescriptionTextView.text = item.pwdescription
        //print("Textview POW: \(powDescriptionTextView))")
        let data = Data(item._pwdescription.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            let desc = NSMutableAttributedString(attributedString: attributedString)
            desc.setBaseFont(baseFont: UIFont(name: "HelveticaNeue", size: 16)!, preserveFontSizes: true)
            print("Company cell description : \(desc)")
            powDescriptionTextView.attributedText = desc
        } else {
            powDescriptionTextView.attributedText = item.pwDescriptionStatus
        }
        
        dateLbl.text = item.pwtimestamp
        favBtn.isFavourite = item.pwisPostFavourited
        likeImage.isLiked = item.pwlikeStatus
        totalLikes.likeCount = item.pwlikeCount
        totalComments.likeCount = item.pwlikeCount
        totalComments.commentCount = item.pwcommentCount
        bannerImageView.sd_setImage(with: URL(string: item.pwbannerImage), completed: nil)
    }
    
    @IBAction func readMoreBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            if item!.isCellExpanded {
                updatedDelegate?.didTapShowLessV2(item: item!, cell: self)
                //readMoreBtn.setTitle("Reads More...", for: .normal)
                
            } else {
                //updatedDelegate?.didTapContinueReadingV2(item: item!, cell: self)
                //readMoreBtn.setTitle("Show Less...", for: .normal)
                updatedDelegate?.didTapReadMoreV2(item: item!, cell : self)
            }
        } else {
            offlineActionBlock?()
        }
        
        //readMoreActionBlock?()
        
    }
        
    
    @IBAction func favBtnTapped(_ sender: FavouriteButton) {
        if network.reachability.isReachable == true {
            guard  let item = item else { return }
            updatedDelegate?.didPOWTapFavV2(item: item, cell: self)
        } else {
            offlineActionBlock?()
        }
        
    }
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("like item pressed")
            guard let item = item else { return }
            if let del = updatedDelegate {
                print("delegate is there", del)
            }
            updatedDelegate?.didTapPOWLikeV2(item: item, cell: self)
        } else {
            offlineActionBlock?()
        }
        
    }
    @IBAction func likeCountTapped(_ sender: LikeCountButton) {
        if network.reachability.isReachable == true {
            print("like count item tapped")
            guard let item = item else { return }
            updatedDelegate?.didPOWTapLikeCountV2(item: item)
        } else {
            offlineActionBlock?()
        }
        
    }
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Comment item tapped")
            guard let item = item else { return }
            updatedDelegate?.didPOWTapcommentV2(item: item)
        } else {
            offlineActionBlock?()
        }     
    }
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            guard let item = item else { return }
            updatedDelegate?.didPOWTapShareV2(sender: sender, item: item)
        } else {
            offlineActionBlock?()
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
            updatedDelegate?.didTapContinueReadingV2(item: item!, cell: self)
            if let id = friendId {
                updatedDelegate?.didTapForFriendView(id: id)
            }
            if let _ = continueReading{
                updatedDelegate?.didTapContinueReadingV2(item: item!, cell: self)
            }
            
            if let link = webLink  {
                updatedDelegate?.didTap(url: link)
            }
        }
    }
}
