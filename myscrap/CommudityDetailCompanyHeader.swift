//
//  CommudityDetailCompanyHeader.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class CommudityDetailCompanyHeader: BaseTableCell {
   


    
    @IBOutlet weak var companyAddress: UILabel!
    @IBOutlet weak var companyName: UILabel!
    var totalImages : NSArray = NSArray()
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var imageViewSlide: UICollectionView!
    
    @IBOutlet weak var imagesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var mobileNumberBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageViewSlide.dataSource = self
              self.imageViewSlide.delegate = self
              self.imageViewSlide.register(CompanyImageslCell.Nib, forCellWithReuseIdentifier: CompanyImageslCell.identifier)
    

    //add target for dots
    self.pageController .addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .touchUpInside)
   
    
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
           //move page to wanted page
           let page: Int? = sender.currentPage
        let   indexPath1  = IndexPath.init(row: page!, section:0)
        self.imageViewSlide.scrollToItem(at: indexPath1, at: .left, animated: true)
       }
    func setUpImages()  {
     
        self.pageController.numberOfPages = totalImages.count
           self.pageController.currentPage = 0
        self.imageViewSlide.reloadData()
        if totalImages.count == 1 || totalImages.count == 0
        {
            self.pageController.isHidden = true
    
        }
        else
        {
              self.pageController.isHidden = false
        }
        
        
    }
    
}
extension CommudityDetailCompanyHeader : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyImageslCell.identifier, for: indexPath) as? CompanyImageslCell else { return UICollectionViewCell()}
        
        let data = totalImages[indexPath.row] as! String
            let downloadURL = URL(string: data)
        
        cell.companyImageView.setImageWithIndicatorWithPlaceHolder(imageURL: data)

        
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
        return CGSize(width:self.imageViewSlide.frame.size.width, height: self.imageViewSlide.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    // If the scroll animation ended, update the page control to reflect the current page we are on
        self.pageController.currentPage = Int((self.imageViewSlide.contentOffset.x / self.imageViewSlide.contentSize.width) * CGFloat(self.totalImages.count))
    }

}
