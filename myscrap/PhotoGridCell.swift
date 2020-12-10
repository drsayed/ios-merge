//
//  PhotoGridCell.swift
//  myscrap
//
//  Created by MS1 on 11/28/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoGridDelegate: class {
    func DidTapImageView(cell: PhotoGridCell)
}

class PhotoGridCell: BaseCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: PhotoGridDelegate?
    var imageList:[String]?
    
    override func awakeFromNib() {
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
    }
    
    func configCell(_ photo: PictureURL){
        
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.imageView.image = image
            }
        }
        
        /*
        imageView.sd_setIndicatorStyle(.white)
        imageView.sd_setShowActivityIndicatorView(true)
        if let url = URL(string: imageURL){
            imageView.sd_setImage(with: url, completed: nil)
        } */
    }
    
    func profilePicCell(url: String){
        let photos = URL(string: url)
        SDWebImageManager.shared().cachedImageExists(for: photos) { (status) in
            if status{
                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: photos?.absoluteString, done: { (image, _, _) in
                    self.imageView.image = image
                })
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: photos, options: .continueInBackground, progress: nil, completed: { (image, _, _, _) in
                    SDImageCache.shared().store(image, forKey: photos?.absoluteString)
                    self.imageView.image = image
                })
            }
        }
        
        /*let service = ProfileService()
        let photos = service.imageList
        for photo in  photos!{
            let url = URL(string: photo)
            
            
            
        }*/
        
        /*
         imageView.sd_setIndicatorStyle(.white)
         imageView.sd_setShowActivityIndicatorView(true)
         if let url = URL(string: imageURL){
         imageView.sd_setImage(with: url, completed: nil)
         } */
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer){
        delegate?.DidTapImageView(cell: self)
    }
}
