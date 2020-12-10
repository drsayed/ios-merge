//
//  PictureURL.swift
//  myscrap
//
//  Created by MS1 on 7/11/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import SDWebImage


final class  PictureURL: INSPhotoViewable {
    func loadImageWithCompletionHandler(_ completion: @escaping (UIImage?, Error?) -> ()) {
        
        if let url = imageURL {
            SDWebImageManager.shared().loadImage(with: url, options: .refreshCached, progress: nil, completed: { (image, _, error, _, _, _) in
                completion(image, error)
            })
        } else {
            completion(nil, NSError(domain: "PhotoDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load image"]))
        }
    }
    
    func loadThumbnailImageWithCompletionHandler(_ completion: @escaping (UIImage?, Error?) -> ()) {

        if let url = thumbnailImageURL {
            SDWebImageManager.shared().loadImage(with: url, options: .refreshCached, progress: nil, completed: { (image, _, error, _, _, _) in
                completion(image, error)
        })
        }else {
            completion(nil, NSError(domain: "PhotoDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load image"]))
        }
    }
    
    var attributedTitle: NSAttributedString?
    
    
    
    init(urlString: String) {
        self._image = urlString
    }
    
    init(image: UIImage?, thumbnailImage: UIImage?) {
        self.image = image
        self.thumbnailImage = thumbnailImage
    }
    
    init(imageURL: URL?, thumbnailImageURL: URL?) {
        self.imageURL = imageURL
        self.thumbnailImageURL = thumbnailImageURL
    }
    
    init (imageURL: URL?, thumbnailImage: UIImage) {
        self.imageURL = imageURL
        self.thumbnailImage = thumbnailImage
    }
    
    var image: UIImage?
    
    var thumbnailImage: UIImage?
    
    var imageURL: URL?
    
    var thumbnailImageURL: URL?
    
    
    
    private var _userId:String!
    private var _postId:String!
    private var _image:String!
    private var _timeStamp:Int!
    
    var likecount:Int!
    
    var commentCount:Int!
    
    var likeStatus:Bool!
    
    
    var userId:String{
        if _userId == nil{
            
            _userId = ""
        }
        return _userId
        
    }
    var postId:String{
        
        if _postId == nil{
            
            _postId = ""
        }
        return _postId
    }
    
    var images:String{
        
        if _image == nil{
            
            _image = ""
        }
        return _image
    }
    
    var timeStamp: String {
        if _timeStamp == nil {
            _timeStamp = 0
        }
        let date = NSDate(timeIntervalSince1970: Double(_timeStamp))
            let datemonthformatter = DateFormatter()
            datemonthformatter.dateFormat =  "dd MMM"   //"MMM dd YYYY hh:mm a"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let dateString = datemonthformatter.string(from: date as Date)
            let timeString = timeFormatter.string(from: date as Date)
            return "\(dateString) at \(timeString)"
    }
    
    
    init(pictureDict:Dictionary<String,AnyObject>){
        
        if let likeCount = pictureDict["likeCount"] as? Int{
            
            self.likecount = likeCount
        }
        if let commentCount = pictureDict["commentCount"] as? Int{
            
            self.commentCount = commentCount
        }
        
        if let likestatus = pictureDict["likeStatus"] as? Bool{
            
            self.likeStatus = likestatus
        }
        if let userId = pictureDict["userId"] as? String{
                
            self._userId = userId
        }
        if let postId = pictureDict["postid"] as? String{
            
            self._postId = postId
        }
        if let image = pictureDict["images"] as? String{
            
            self._image = image
        }
        if let timeStamp = pictureDict["timeStamp"] as? Int{
            
            self._timeStamp = timeStamp
        }
        
        if let image = pictureDict["images"] as? String{
            self.imageURL = URL(string: image)
            self.thumbnailImageURL = URL(string: image)
        }
        
    }
    
   
}

