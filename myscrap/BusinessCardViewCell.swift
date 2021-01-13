//
//  BusinessCardViewCell.swift
//  myscrap
//
//  Created by MS1 on 10/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

protocol BusinessCardTap {
    func businessCardTap(cell:UICollectionViewCell?,index:Int, dataSource:[PictureURL])
}

class BusinessCardViewCell: BaseTableCell {

    @IBOutlet weak var feedImages: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var pageCountView: UIView!
    @IBOutlet weak var pageCountLable: UILabel!
    @IBOutlet weak var cardHideView: UIView!
    @IBOutlet weak var sendRequestButton: CorneredButton!
    var businessCardTapDelegate:BusinessCardTap?
    var cardFront = ""
    var cardBack   = ""
    var cardCount = 0
    var dataSource:[PictureURL] = []
   
    
    var newItem : ProfileData? {
          didSet{
              guard let item = newItem else { return }
                
                if item.cardFront != "" ||  item.cardBack != "" {
                          
                               // stackView.addArrangedSubview(createButtonView(title:"Business Card", type: .card))
                                 if item.cardFront != "" &&  item.cardBack != ""
                                 {
                                  cardCount = 2
                                  cardFront = item.cardFront
                                  cardBack = item.cardBack
                                    dataSource.append(PictureURL(imageURL: URL(string: item.cardFront), thumbnailImageURL: nil))
                                    dataSource.append(PictureURL(imageURL: URL(string: item.cardBack), thumbnailImageURL: nil))
                                    }
                        else  if item.cardFront != ""
                          {
                           cardCount = 1
                           cardFront =  item.cardFront
                           cardBack = ""
                            dataSource.append(PictureURL(imageURL: URL(string: item.cardFront), thumbnailImageURL: nil))
                             }
                          else  if item.cardBack != ""
                          {
                           cardCount = 1
                           cardFront = ""
                           cardBack =  item.cardBack
                            dataSource.append(PictureURL(imageURL: URL(string: item.cardBack), thumbnailImageURL: nil))
                             }
            }
            self.refreshTable()
          }
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageCountView.layer.cornerRadius =  self.pageCountView.frame.size.height/2
       // self.contentView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)


    }

    func refreshTable()  {
        
        
        self.feedImages.register(BusinessCardCell.Nib, forCellWithReuseIdentifier: BusinessCardCell.identifier)
          // self.totalImagesCountVieew.layer.cornerRadius = 10
        if cardCount > 0 {
            self.feedImages.delegate = self
            self.feedImages.dataSource = self
             self.pageControll.numberOfPages = cardCount
            if let countLable = self.viewWithTag(1001) as?  UILabel  {
               countLable.text = "1/\(cardCount)"
                }
          //  self.imageCountLable.text = "1/\(self.newItem!.pictureURL.count as Int)"
                //  self.totalImages = item?.pictureURL
            if cardCount == 1 {
                self.pageControll.isHidden = true
                   self.pageCountView.isHidden = false
            }
            else
            {
                self.pageControll.isHidden = false
               self.pageCountView.isHidden = false
                   
            }
                  self.feedImages.reloadData()
        }
      
    }
   
    
    /*override func setupAPIViews(item:FeedItem){
        
        if let imageString = item.pictureURL.last?.images{
            feedImage.setImageWithIndicator(imageURL: imageString)
        }
    }*/
 
  
    
}
extension BusinessCardViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCardCell.identifier, for: indexPath) as? BusinessCardCell else { return UICollectionViewCell()}
        var downloadURL : URL =   URL(string: cardFront)!
        if indexPath.item == 0{
             downloadURL = URL(string: cardFront)!
        }
        else
        {
            downloadURL = URL(string: cardBack)!

        }
            SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
                if status{
                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL.absoluteString, done: { (image, data, type) in
                        cell.companyImageView.image = image
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        if let error = error {
                            print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
                           
                            //cell.bigProfileIV.image = #imageLiteral(resourceName: "no-image")
                        } else {
                            SDImageCache.shared().store(image, forKey: downloadURL.absoluteString)
                            cell.companyImageView.image = image
                        }
                        
                    })
                }
            }
        

        
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
      
    //    guard let item = newItem else { return }
    //    updatedDelegate?.didTapImageViewV2(atIndex: indexPath.item, item: item)
        
        businessCardTapDelegate?.businessCardTap(cell: collectionView.cellForItem(at: indexPath), index: indexPath.row, dataSource: dataSource)
}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    // If the scroll animation ended, update the page control to reflect the current page we are on
        self.pageControll.currentPage = Int((self.feedImages.contentOffset.x / self.feedImages.contentSize.width) * CGFloat((cardCount) as Int))
    
        if let countLable  = self.viewWithTag(1001) as? UILabel {
    countLable.text = "\(Int((self.feedImages.contentOffset.x / self.feedImages.contentSize.width) * CGFloat((cardCount) as Int))+1)/\((cardCount) as Int)"
              }
    }

}
