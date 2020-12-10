//
//  DetailCMCell.swift
//  myscrap
//
//  Created by MyScrap on 7/16/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class DetailCMCell: BaseCell {

    weak var updatedDelegate : UpdatedFeedsDelegate?
    var commentActionBlock: (() -> Void)? = nil
    
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
    @IBOutlet weak var reportBtn: ReportButton!
    @IBOutlet weak var reportedView: ReportedView!
    @IBOutlet weak var unreportBtn: UnReportBtn!
    
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
        let htmlString = Data(item.cmdescription.utf8)
        //let htmlAttrib = item.cmDescriptionStatus.string.convertHtml()
        //item.cmDescriptionStatus.append(htmlAttrib)
        let attrib = item.cmdescription
        let convertFromHtml = attrib.convertHtml()
        //compDescriptionTextView.attributedText = item.cmDescriptionStatus
        let desc = NSMutableAttributedString(attributedString: convertFromHtml)
        desc.setBaseFont(baseFont: UIFont(name: "HelveticaNeue", size: 16)!, preserveFontSizes: true)
        compDescriptionTextView.attributedText = desc
        print("Textview : \(item.cmDescriptionStatus), html string : \(htmlString)")
        
        dateLbl.text = item.timeStamp
        favBtn.isFavourite = item.isPostFavourited
        likeImage.isLiked = item.likeStatus
        //totalLikes.likeCount = item.likeCount
        //totalComments.likeCount = item.likeCount
        //totalComments.commentCount = item.commentCount
        companyImageView.sd_setImage(with: URL(string: item.companyImage), completed: nil)
        
        //reportedView.isHidden = !item.isReported
        //print("Report View : \(reportedView.isHidden)")
        //unreportBtn.isHidden =  !((item.reportedUserId == AuthService.instance.userId) || item.moderator == "1")
        // unreportBtn.isHidden = true
        //reportBtn.isHidden = true
        //reportedView.isHidden = true
    }
    
    @IBAction func favBtnTapped(_ sender: FavouriteButton) {
        guard  let item = item else { return }
        updatedDelegate?.didCMTapFavV2(item: item, cell: self)
    }
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        print("like item pressed")
        guard let item = item else { return }
        if let del = updatedDelegate {
            print("delegate is there", del)
        }
        updatedDelegate?.didTapCMLikeV2(item: item, cell: self)
    }
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        print("Comment item tapped")
        commentActionBlock?()
    }
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        guard let item = item else { return }
        updatedDelegate?.didCMTapShareV2(sender: sender, item: item)
    }

}
