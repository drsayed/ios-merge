//
//  ReportedFeedImageCell.swift
//  myscrap
//
//  Created by MS1 on 10/10/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ReportedFeedImageCell: ReportedFeedTextCell {
    
    
    @IBOutlet weak var reportedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if network.reachability.isReachable == true {
            reportedImage.contentMode = .scaleAspectFill
            reportedImage.clipsToBounds = true
            reportedImage.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.numberOfTapsRequired = 1
            reportedImage.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer){
        //        guard let item = item else { return }
        //        delegate?.didTapImageView(item: item)
        /* APIV2.0 */
        guard let item = newItem else { return }
        updatedDelegate?.didTapImageViewV2(atIndex: 0, item: item)
    }
    
    override func configCell(withItem item: FeedV2Item) {
        super.configCell(withItem: item)
        reportedView.isHidden = true
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "Reported By • ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.BLACK_ALPHA, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 11)!]))
        attributedString.append(NSAttributedString(string: item.reportBy, attributes: [NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 11)!]))
        reportedLbl.attributedText = attributedString
    }
    override func setupAPIViews(item:FeedV2Item){
        
        if let imageString = item.pictureURL.last?.images{
            reportedImage.setImageWithIndicator(imageURL: imageString)
        }
    }
    
    func configCell(item: PictureURL, profileItem: ProfileData?){
        guard let profile = profileItem else { return }
        if profile.companyType == "" {
            configProfile(photo: item, profile: profile)
        } else {
            configCompany(photo: item, profile: profile)
        }
        
    }
    
    func configCell(item: PictureURL, profileItem: CompanyProfileItem?){
        guard let profile = profileItem else { return }
        if profile.companyType == "" {
            configProfile(photo: item, profile: profile)
        } else {
            configCompany(photo: item, profile: profile)
        }
        
    }
    
    private func configCompany(photo: PictureURL, profile: CompanyProfileItem){
        nameLbl.text = profile.companyName
        designationLbl.text = profile.companyType
        timeLbl.text = photo.timeStamp
        if photo.likecount == 0 && photo.commentCount == 0{
            likeCountBtn.isHidden = true
            commentCountBtn.isHidden = true
        } else if photo.likecount != 0 && photo.commentCount == 0 {
            likeCountBtn.isHidden = false
            commentCountBtn.isHidden = true
            
            likeCountBtn.likeCount = photo.likecount
        } else if photo.likecount == 0 && photo.commentCount != 0 {
            likeCountBtn.isHidden = true
            commentCountBtn.isHidden = false
            
            //commentCountBtn.likeCount = photo.likecount
            commentCountBtn.commentCount = photo.commentCount
        } else {
            likeCountBtn.isHidden = false
            commentCountBtn.isHidden = false
            likeCountBtn.likeCount = photo.likecount
            //commentCountBtn.likeCount = photo.likecount
            commentCountBtn.commentCount = photo.commentCount
        }
//        likeCountBtn.likeCount = photo.likecount
//        commentCountBtn.likeCount = photo.likecount
//        commentCountBtn.commentCount = photo.commentCount
        likeImage.isLiked = photo.likeStatus
        profileView.updateViews(name: profile.companyName ?? "", url: profile.companyImage ?? "", colorCode: "")
        
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.reportedImage.image = image
            }
        }
    }
    
    private func configCompany(photo: PictureURL, profile: ProfileData){
        nameLbl.text = profile.companyName
        designationLbl.text = profile.companyType
        timeLbl.text = photo.timeStamp
        likeCountBtn.likeCount = photo.likecount
        //commentCountBtn.likeCount = photo.likecount
        commentCountBtn.commentCount = photo.commentCount
        likeImage.isLiked = photo.likeStatus
        profileView.updateViews(name: profile.companyName, url: profile.profilePic, colorCode: profile.colorCode)
        
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.reportedImage.image = image
            }
        }
    }
    
    private func configProfile( photo: PictureURL , profile: ProfileData){
        nameLbl.text = profile.name
        designationLbl.text = profile.designation
        timeLbl.text = photo.timeStamp
        likeCountBtn.likeCount = photo.likecount
        //commentCountBtn.likeCount = photo.likecount
        commentCountBtn.commentCount = photo.commentCount
        likeImage.isLiked = photo.likeStatus
        profileView.updateViews(name: profile.name, url: profile.profilePic, colorCode: profile.colorCode)
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.reportedImage.image = image
            }
        }
    }
    
    private func configProfile( photo: PictureURL , profile: CompanyProfileItem){
        nameLbl.text = profile.companyName
        designationLbl.text = profile.companyType
        timeLbl.text = photo.timeStamp
        likeCountBtn.likeCount = photo.likecount
        //commentCountBtn.likeCount = photo.likecount
        commentCountBtn.commentCount = photo.commentCount
        likeImage.isLiked = photo.likeStatus
        profileView.updateViews(name: profile.companyName ?? "", url: profile.companyImage ?? "", colorCode: "")
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.reportedImage.image = image
            }
        }
    }

}











