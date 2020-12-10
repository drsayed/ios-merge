//
//  FeedListingCell.swift
//  myscrap
//
//  Created by MyScrap on 8/23/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class FeedListingCell: BaseCell {
    
    weak var delegate: FeedsDelegate?

    var listingFeed: FeedItem?{
        didSet{
            if let item = listingFeed, let feed = item.listingFeed{
                configCell(with: feed)
            }
        }
    }
    
    @IBOutlet weak var listingIdLabel: UILabel!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var offerLabel: DesignationLabel!
    @IBOutlet weak var timeLabel: TimeLabel!
    @IBOutlet weak var textView: UserTagTextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func viewMorePressed(_ sender: ListingFeedViewMoreButton) {
        print("Posted userID : \(String(describing: listingFeed?.postedUserId))")
        delegate?.didTapListing(with: (listingFeed!.listingFeed!.listingId), userId: (listingFeed?.postedUserId)!)
        
    }
    
    private func configCell(with item : ListingFeed){
        listingIdLabel.text = "Market - Listing ID \(item.listingId)"
        titleLabel.text = item.listingTitle.capitalized
        offerLabel.attributedText = item.offerString
        profileView.updateViews(name: item.postedUserName, url: item.profilePic ?? ""  , colorCode: item.colorCode)
        textView.attributedText = item.attributedStatus
        timeLabel.text = listingFeed!.timeStamp
        if item.listingImg == "" || item.listingImg == "https://myscrap.com/uploads/listing_img/no-image.png" {
            imageViewHeight.constant = 0
            print("Image height",imageView.height)
        } else {
            imageView.sd_setImage(with: URL(string: item.listingImg ?? ""), completed: nil)
            imageViewHeight.constant = 400
            print("Listing Image :\(item.listingImg)")
        }
        
        viewLabel.text = item.viewCount
        
    }
    
}
