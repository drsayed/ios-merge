//
//  NewsScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 3/16/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class NewsScrollCell: BaseCell {

    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var newsData : [NewsFeed]!
    var viewAllActionBlock: (() -> Void)? = nil
    
    var item : FeedV2Item?{
        didSet{
            if let item = item?.dataNews{
                newsData = item
                for data in item {
                    print("new user name : \(data.id)")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(NewsInsideScrollCell.Nib, forCellWithReuseIdentifier: NewsInsideScrollCell.identifier)
        newsImageView.image = UIImage.fontAwesomeIcon(name: .newspaper, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
    }

    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        
    }
}
extension NewsScrollCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsInsideScrollCell.identifier, for: indexPath) as? NewsInsideScrollCell else { return UICollectionViewCell()}
        
        let data = newsData[indexPath.row]
        
        
        cell.newsTitleLbl.text = data.title
        
        SDWebImageManager.shared().cachedImageExists(for: URL(string: data.newsBanner)) { (status) in
            if status{
                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: data.newsBanner, done: { (image, dataa, type) in
                    cell.newsImageView.image = image
                })
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: data.newsBanner), options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, dataa, error, status) in
                    if let error = error {
                        print("Error while downloading : \(error), Status :\(status), url :\(data.newsBanner)")
                    } else {
                        SDImageCache.shared().store(image, forKey: data.newsBanner)
                        cell.newsImageView.image = image
                    }
                })
            }
        }
        cell.newsDescripLbl.text = data.description
        let newsBy = "- " + data.newsBy.uppercased()
        print("News By : \(newsBy)")
        cell.newsPostedByLbl.text = newsBy
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 175, height: 279)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = newUserData[indexPath.row]
//        delegate?.didTapProfile(userId: (data.userId))
    }
}
