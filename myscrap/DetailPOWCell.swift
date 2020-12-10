//
//  DetailPOWCell.swift
//  myscrap
//
//  Created by MyScrap on 7/20/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class DetailPOWCell: BaseCell {

    weak var updatedDelegate : UpdatedFeedsDelegate?
    var commentActionBlock: (() -> Void)? = nil
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var favBtn: FavouriteButton!
    @IBOutlet weak var likeImage: LikeImageButton!
    @IBOutlet weak var commentImg: CommentImageButton!
    @IBOutlet weak var bannerTitleLbl: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var powDescriptionTextView: UserTagTextView!
    
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
        
        //resizeForHeight()
    }
    
    func resizeForHeight(){
        powDescriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        let fixedWidth = powDescriptionTextView.frame.size.width
        powDescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        powDescriptionTextView.isScrollEnabled = false
    }
    
    /* API V2.0*/
    func configCell(withItem item : FeedV2Item){
        bannerTitleLbl.text = item.pwbannerTitle
        let htmlString = Data(item.pwdescription.utf8)
        //let htmlAttrib = item.cmDescriptionStatus.string.convertHtml()
        //item.cmDescriptionStatus.append(htmlAttrib)
        let attrib = item.pwdescription
        let convertFromHtml = attrib.convertHtml()
        //compDescriptionTextView.attributedText = item.cmDescriptionStatus
        let desc = NSMutableAttributedString(attributedString: convertFromHtml)
        desc.setBaseFont(baseFont: UIFont(name: "HelveticaNeue", size: 16)!, preserveFontSizes: true)
        powDescriptionTextView.attributedText = desc
        //powDescriptionTextView.text = item.pwdescription
        print("Textview : \(item.pwdescription), html string : \(htmlString)")
        
        dateLbl.text = item.pwtimestamp
        favBtn.isFavourite = item.pwisPostFavourited
        likeImage.isLiked = item.pwlikeStatus
        bannerImageView.sd_setImage(with: URL(string: item.pwbannerImage), completed: nil)
        //totalLikes.likeCount = item.likeCount
        //totalComments.likeCount = item.likeCount
        //totalComments.commentCount = item.commentCount
        
        
        
    }
    
    @IBAction func favBtnTapped(_ sender: FavouriteButton) {
        guard  let item = item else { return }
        updatedDelegate?.didPOWTapFavV2(item: item, cell: self)
    }
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        print("like item pressed")
        guard let item = item else { return }
        if let del = updatedDelegate {
            print("delegate is there", del)
        }
        updatedDelegate?.didTapPOWLikeV2(item: item, cell: self)
    }
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        print("Comment item tapped")
        commentActionBlock?()
    }
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        guard let item = item else { return }
        updatedDelegate?.didPOWTapShareV2(sender: sender, item: item)
        
    }

}
