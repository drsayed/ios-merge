//
//  UserListImageCell.swift
//  myscrap
//
//  Created by MyScrap on 12/15/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class UserListImageCell: UserFeedTextCell {

    @IBOutlet weak var feedImage: UIImageView!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        feedImage.contentMode = .scaleAspectFill
        feedImage.clipsToBounds = true
        feedImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 1
      //  feedImage.addGestureRecognizer(tap)
    }
      
    override func setupTap(){
        
    }
    
    private func setupDescription(item: FeedV2Item){
        
    }
    
    override func configCell(withItem item: FeedV2Item){
        super.configCell(withItem: item)
    }
    
    override func setupAPIViews(item:FeedV2Item){
        
        if let imageString = item.pictureURL.last?.images{
            feedImage.setImageWithIndicator(imageURL: imageString)
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer){
        guard let item = newItem else { return }
        updatedDelegate?.didTapImageViewV2(atIndex:0, item: item)
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
        //likeCountBtn.likeCount = photo.likecount
        //commentCountBtn.likeCount = photo.likecount
        //commentCountBtn.commentCount = photo.commentCount
        
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
        
        likeImage.isLiked = photo.likeStatus
        profileView.updateViews(name: profile.companyName ?? "", url: profile.companyImage ?? "", colorCode: "")
        
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.feedImage.image = image
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
                self.feedImage.image = image
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
                self.feedImage.image = image
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
                self.feedImage.image = image
            }
        }
    }
}
