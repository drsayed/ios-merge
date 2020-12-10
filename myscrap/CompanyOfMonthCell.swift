//
//  CompanyOfMonthCell.swift
//  myscrap
//
//  Created by MyScrap on 7/13/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class CompanyOfMonthCell: BaseCell {
    
    weak var updatedDelegate : UpdatedFeedsDelegate?

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var favBtn: FavouriteButton!
    @IBOutlet weak var likeImage: LikeImageButton!
    @IBOutlet weak var totalLikes: LikeCountButton!
    @IBOutlet weak var commentImg: CommentImageButton!
    @IBOutlet weak var totalComments: CommentCountBtn!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var bannerTitleLbl: UILabel!
    @IBOutlet weak var compDescriptionTextView: UserTagTextView!
   
    @IBOutlet weak var readMoreBtn: UIButton!
    var readMoreActionBlock: (() -> Void)? = nil
    var offlineActionBlock : (() -> Void)? = nil
    
    
    var item : FeedV2Item? {
        didSet{
            guard let item = item else { return }
            configCell(withItem: item)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        compDescriptionTextView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
//        tap.numberOfTapsRequired = 1
//        compDescriptionTextView.addGestureRecognizer(tap)
        
        
    }
    
    /* API V2.0*/
    func configCell(withItem item : FeedV2Item){
        bannerTitleLbl.text = item.bannerTitle
        
        let data = Data(item._cmdescription.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            let desc = NSMutableAttributedString(attributedString: attributedString)
            desc.setBaseFont(baseFont: UIFont(name: "HelveticaNeue", size: 16)!, preserveFontSizes: true)
            print("Company cell description : \(desc)")
            compDescriptionTextView.attributedText = desc
        } else {
            compDescriptionTextView.attributedText = item.cmDescriptionStatus
        }
        
        readMoreBtn.setTitle("Reads More...", for: .normal)
        
//        let style = NSMutableParagraphStyle()
//        style.lineSpacing = 8
//        let attributes = [NSAttributedStringKey.paragraphStyle : style]
        
        //compDescriptionTextView.attributedText = item.cmDescriptionStatus
        print("Textview : \(item.cmDescriptionStatus)")
        
        dateLbl.text = item.timeStamp
        favBtn.isFavourite = item.isPostFavourited
        likeImage.isLiked = item.likeStatus
        totalLikes.likeCount = item.likeCount
        totalComments.likeCount = item.likeCount
        totalComments.commentCount = item.commentCount
        companyImageView.sd_setImage(with: URL(string: item.companyImage), completed: nil)
        
    }
    
    @IBAction func readMoreBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            if item!.isCellExpanded {
                //updatedDelegate?.didTapShowLessV2(item: item!, cell: self)
                //readMoreBtn.setTitle("Reads More...", for: .normal)
                
            } else {
                //updatedDelegate?.didTapContinueReadingV2(item: item!, cell: self)
                //readMoreBtn.setTitle("Show Less...", for: .normal)
            }
        } else {
            offlineActionBlock?()
        }
        
        //readMoreActionBlock?()
        
    }
    
    
    
    @IBAction func favBtnTapped(_ sender: FavouriteButton) {
        if network.reachability.isReachable == true {
            guard  let item = item else { return }
            updatedDelegate?.didCMTapFavV2(item: item, cell: self)
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
            updatedDelegate?.didTapCMLikeV2(item: item, cell: self)
        } else {
            offlineActionBlock?()
        }
    }
    @IBAction func likeCountTapped(_ sender: LikeCountButton) {
        if network.reachability.isReachable == true {
            print("like count item tapped")
            guard let item = item else { return }
            updatedDelegate?.didCMTapLikeCountV2(item: item)
        } else {
            offlineActionBlock?()
        }
    }
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Comment item tapped")
            guard let item = item else { return }
            updatedDelegate?.didCMTapcommentV2(item: item)
        } else {
            offlineActionBlock?()
        }
    }
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            guard let item = item else { return }
            updatedDelegate?.didCMTapShareV2(sender: sender, item: item)
        } else {
            offlineActionBlock?()
        }
    }
    @IBAction func reportBtnTapped(_ sender: ReportButton) {
        if network.reachability.isReachable == true {
            print("report item tapped")
            if sender.tag == 0 {
                guard  let item = item else { return }
                updatedDelegate?.didTapReportV2(item: item, cell: self)
            } else {
                guard  let item = item else { return }
                updatedDelegate?.didTapReportModV2(item: item, cell: self)
            }
        } else {
            offlineActionBlock?()
        }
    }
    @IBAction func unreportBtnTapped(_ sender: UnReportBtn) {
        if network.reachability.isReachable == true {
            print("Unreport item tapped")
            guard  let item = item else { return }
            updatedDelegate?.didTapUnReportV2(item: item, cell: self)
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
            let showLess = textView.attributedText.attribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.SHOW_LESS), at: characterIndex, effectiveRange: nil) as? String
            let webLink = textView.attributedText.attribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.URL), at: characterIndex, effectiveRange: nil) as? String
            
            //updatedDelegate?.didTapContinueReadingV2(item: item!, cell: self)
            
            if let id = friendId {
                updatedDelegate?.didTapForFriendView(id: id)
            }
            if let _ = continueReading{
                updatedDelegate?.didTapContinueReadingV2(item: item!, cell: self)
            }
            if let _ = showLess {
                //updatedDelegate?.didTapShowLessV2(item: item!, cell: self)
            }
            
            if let link = webLink  {
                updatedDelegate?.didTap(url: link)
            }
        }
    }
}
extension NSMutableAttributedString {
    
    /// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
    func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = false) {
        let baseDescriptor = baseFont.fontDescriptor
        let wholeRange = NSRange(location: 0, length: length)
        beginEditing()
        enumerateAttribute(.font, in: wholeRange, options: []) { object, range, _ in
            guard let font = object as? UIFont else { return }
            // Instantiate a font with our base font's family, but with the current range's traits
            let traits = font.fontDescriptor.symbolicTraits
            guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
            let newSize = preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize
            let newFont = UIFont(descriptor: descriptor, size: newSize)
            self.removeAttribute(.font, range: range)
            self.addAttribute(.font, value: newFont, range: range)
        }
        endEditing()
    }
}
