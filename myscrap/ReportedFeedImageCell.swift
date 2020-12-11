//
//  ReportedFeedImageCell.swift
//  myscrap
//
//  Created by MS1 on 10/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage
import CoreGraphics
import Accelerate
class ReportedFeedImageCell: ReportedFeedTextCell {

    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedImages: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!

    @IBOutlet var feedImagesCollectionViewHeightConstraint : NSLayoutConstraint!
   @IBOutlet var fancyViewWidthConstraint : NSLayoutConstraint!

    var totalImages : Array = [PictureURL]()
    override func awakeFromNib() {
        super.awakeFromNib()
        if network.reachability.isReachable == true {
            feedImage.contentMode = .scaleAspectFill
            feedImage.clipsToBounds = true
            feedImage.isUserInteractionEnabled = true
            
          //  feedImages.delegate = self
         //   feedImages.dataSource = self

//            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//            tap.numberOfTapsRequired = 1
//            feedImage.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
        if let countView : UIView = self.viewWithTag(1000) {
            countView.layer.cornerRadius = countView.frame.height/2
               }
    }
    func refreshTable()  {
        
        self.feedImages.register(CompanyImageslCell.Nib, forCellWithReuseIdentifier: CompanyImageslCell.identifier)
          // self.totalImagesCountVieew.layer.cornerRadius = 10
        if self.newItem != nil && self.newItem!.pictureURL.count as Int > 0 {
            self.feedImages.delegate = self
                    self.feedImages.dataSource = self
             self.pageControll.numberOfPages = self.newItem!.pictureURL.count as Int
            if let countLable = self.viewWithTag(1001) as?  UILabel  {
               countLable.text = "1/\(self.newItem!.pictureURL.count as Int)"
                }
          //  self.imageCountLable.text = "1/\(self.newItem!.pictureURL.count as Int)"
                //  self.totalImages = item?.pictureURL
            if self.newItem!.pictureURL.count as Int == 1 {
                self.pageControll.isHidden = true
                 if let countView : UIView = self.viewWithTag(1000) {
                         countView.isHidden = true
                     }
            }
            else
            {
                self.pageControll.isHidden = false
                if let countView : UIView = self.viewWithTag(1000) {
                                        countView.isHidden = false
                                    }
                   
            }
                  self.feedImages.reloadData()
        }
      
    }
//    override func configCell(withItem item: FeedItem){
//        super.configCell(withItem: item)
//    }
    /* APIV2.0 */
    override func configCell(withItem item: FeedV2Item){
        super.configCell(withItem: item)
        //Download StackView hide for only FeedText
        dwnldStackView.isHidden = false
       

    }

    func refreshImagesCollection() {//refreshTable()  {
        self.feedImages.register(CompanyImageslCell.Nib, forCellWithReuseIdentifier: CompanyImageslCell.identifier)
          // self.totalImagesCountVieew.layer.cornerRadius = 10
        if self.newItem != nil && self.newItem!.pictureURL.count as Int > 0 {
            self.feedImages.delegate = self
                    self.feedImages.dataSource = self
             self.pageControll.numberOfPages = self.newItem!.pictureURL.count as Int
            if let countLable = self.viewWithTag(1001) as?  UILabel  {
               countLable.text = "1/\(self.newItem!.pictureURL.count as Int)"
                }
          //  self.imageCountLable.text = "1/\(self.newItem!.pictureURL.count as Int)"
                //  self.totalImages = item?.pictureURL
            if self.newItem!.pictureURL.count as Int == 1 {
                self.pageControll.isHidden = true
                 if let countView : UIView = self.viewWithTag(1000) {
                         countView.isHidden = true
                     }
            }
            else
            {
                self.pageControll.isHidden = false
                if let countView : UIView = self.viewWithTag(1000) {
                                        countView.isHidden = false
                                    }
                   
            }
            self.feedImages.reloadData()
            
            let viewWidth = UIScreen.main.bounds.width
            self.fancyViewWidthConstraint.constant = viewWidth
            self.feedImagesCollectionViewHeightConstraint.constant = viewWidth
        }
      
    }
   
    
    /*override func setupAPIViews(item:FeedItem){
        
        if let imageString = item.pictureURL.last?.images{
            feedImage.setImageWithIndicator(imageURL: imageString)
        }
    }*/
    /* APIV2.0 */
    override func setupAPIViews(item:FeedV2Item){
        
        if let imageString = self.newItem!.pictureURL.last?.images{
            feedImage.setImageWithIndicator(imageURL: imageString)
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer){
//        guard let item = item else { return }
//        delegate?.didTapImageView(item: item)
        
        /* APIV2.0 */
        
        guard let item = newItem else { return }
        updatedDelegate?.didTapImageViewV2(atIndex: sender.view!.tag, item: item)
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

    func setProfileImage(imageToResize: UIImage, onImageView: UIImageView) -> UIImage
    {
        let width = imageToResize.size.width
        let height = imageToResize.size.height

        var scaleFactor: CGFloat

        if(width > height)
        {
            scaleFactor = onImageView.frame.size.height / height;
        }
        else
        {
            scaleFactor = onImageView.frame.size.width / width;
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        imageToResize.draw(in: CGRect(x: 0, y: 0, width: width * scaleFactor, height: height * scaleFactor))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage!;
    }
}
extension ReportedFeedImageCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControll.currentPage = indexPath.item
        if let countLable  = self.viewWithTag(1001) as? UILabel {
    countLable.text = "\(indexPath.item+1)/\(self.newItem!.pictureURL.count as Int)"
              }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newItem!.pictureURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyImageslCell.identifier, for: indexPath) as? CompanyImageslCell else { return UICollectionViewCell()}
        
        cell.tag = indexPath.row
           let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
       tap.numberOfTapsRequired = 1
        cell.addGestureRecognizer(tap)
        
//        if let url = URL(string: pictureURL[indexPath.item].images) {
//            cell.imageView.sd_setImage(with: url, completed: nil)
//        } else {
//            cell.imageView.image = nil
//        }
        
        let data = self.newItem?.pictureURL[indexPath.row] as! PictureURL
        let urlString = data.images as String
        let downloadURL = URL(string:urlString )
        
         cell.companyImageView.setImageWithIndicator(imageURL: urlString)
//        cell.sd_setShowActivityIndicatorView(true)
//        cell.sd_setIndicatorStyle(.gray)
//       // cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//
//        cell.companyImageView.sd_setImage(with: downloadURL!, placeholderImage: UIImage(named: "App-Default"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
//            cell.companyImageView.image = image?.resize(to: cell.companyImageView.frame.size)
//        //    print("\(cell.companyImageView.contentClippingRect)")
//            // Perform operation.
//        })
//        cell.companyImageView.sd_setImage(with: imageURL, placeholderImage: "NOimage", options:nil
//        ) { (_: UIImage?, _: Error?, SDImageCacheType, _: URL?) in
//
//        }
//            SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
//                if status{
//                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
//                        cell.companyImageView.image = image
//                    })
//                } else {
//                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
//                        if let error = error {
//                            print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
//
//                            //cell.bigProfileIV.image = #imageLiteral(resourceName: "no-image")
//                        } else {
//                            SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
//                            cell.companyImageView.image = image
//                        }
//
//                    })
//                }
//            }
//
//            SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
//                if status{
//                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
//                        cell.companyImageView.image = image
//                    })
//                } else {
//                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
//                        if let error = error {
//                            print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
//
//                            //cell.bigProfileIV.image = #imageLiteral(resourceName: "no-image")
//                        } else {
//                            SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
//                            cell.companyImageView.image = image
//                        }
//
//                    })
//                }
//            }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width:self.feedImages.frame.size.width, height: self.feedImages.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        guard let item = newItem else { return }
        updatedDelegate?.didTapImageViewV2(atIndex: indexPath.item, item: item)
}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    // If the scroll animation ended, update the page control to reflect the current page we are on
        self.pageControll.currentPage = Int((self.feedImages.contentOffset.x / self.feedImages.contentSize.width) * CGFloat((self.newItem?.pictureURL.count ?? 0) as Int))
    
        if let countLable  = self.viewWithTag(1001) as? UILabel {
    countLable.text = "\(Int((self.feedImages.contentOffset.x / self.feedImages.contentSize.width) * CGFloat((self.newItem?.pictureURL.count ?? 0) as Int))+1)/\(self.newItem!.pictureURL.count as Int)"
              }
    }

}
