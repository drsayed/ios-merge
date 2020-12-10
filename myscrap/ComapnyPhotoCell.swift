//
//  ComapnyPhotoCell.swift
//  myscrap
//
//  Created by MyScrap on 6/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class ComapnyPhotoCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    var companyData: CompanyItems?{
        didSet {
            if let item = companyData{
                configure(with: item)
            }
        }
    }
    
    var companyImages : [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PhotoScrollCVCell.self, forCellWithReuseIdentifier: "photoScroll")
    }
    
    func configure(with item: CompanyItems){
        //Right now userSeen parameters works as a opposite manner, so if seen = false (Normal) text.
        companyImages = item.companyImages
//        setupCollectionView()
//        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if companyImages!.count != 0 {
            return companyImages!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoScrollCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoScroll", for: indexPath) as! PhotoScrollCVCell
//        cell.compImage.image = #imageLiteral(resourceName: "pexels-photo-132038")
        let imgUrl = companyImages?[indexPath.row]
        if let urlString = imgUrl , let url = URL(string: urlString){
            
            SDWebImageManager.shared().cachedImageExists(for: url) { (status) in
                if status{
                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, data, type) in
                        
                        cell.compImage.image = image
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        SDImageCache.shared().store(image, forKey: url.absoluteString)
                        
                        cell.compImage.image = image
                    })
                }
            }
        } else {
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: nil, progress: nil, completed: { (image, data, error, status) in
                print("Company image cannot be downloaded : \(error)")
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 258, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    

}

