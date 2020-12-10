//
//  News.swift
//  myscrap
//
//  Created by MS1 on 8/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

final class News{
    var postId:String?
    var heading: String?
    var postedUserName:String?
    var timeStamp:Int?
    var status:String?
    private var _likeStatus: Bool!
    var subHeading: String?
    var postedUserId: String?
    var publishLocation:String?
    var publisherMagazine:String?
    private var _likeCount: Int?
    var commentCount: Int?
    var _pictureURL:[PictureURL]!
    private var _newsImage: String!
    private var _newsId:String!
    var _commentDict:[Like]!
    
    var commentDict:[Like]{
        if _commentDict == nil{
            _commentDict = [Like]()
        }
        return _commentDict
    }
    
    var newsId:String{
        if _newsId == nil{
            _newsId = ""
        }
        return _newsId
    }
    
    var newsImage:String{
        if _newsImage == nil{
            _newsImage = ""
        }
        return _newsImage
    }
    
    var likeData: [Like]{
        if _likeData == nil{
            _likeData = [Like]()
        }
        return _likeData
    }
    private var _likeData: [Like]!
    var publisherUrl: String?
    
    var likeStatus:Bool!
    
    var pictureURL:[PictureURL]{
        if _pictureURL == nil{
            _pictureURL = [PictureURL]()
        }
        return _pictureURL
    }
    var likeCount: Int!
    
    
    init(newsDict: [String:AnyObject]) {
        if let postedUserId = newsDict["postedUserId"] as? String{
            self.postedUserId = postedUserId
        }
        if let postId = newsDict["postId"] as? String{
            self.postId = postId
        }
        if let timestamp = newsDict["timeStamp"] as? Int{
            self.timeStamp = timestamp
        }
        if let status = newsDict["status"] as? String{
            self.status = status
        }
        if let likeCount = newsDict["likeCount"] as? Int{
            self.likeCount = likeCount
        }
        if let commentCount = newsDict["commentCount"] as? Int{
            self.commentCount = commentCount
        }
        if let picture = newsDict["pictureUrl"] as? [[String:AnyObject]]{
             var pict  = [PictureURL]()
            
            for obj in picture{
                let pic = PictureURL(pictureDict: obj)
                pict.append(pic)
            }
            self._pictureURL = pict
        }
        if let heading = newsDict["heading"] as? String{
            self.heading = heading
        }
        if let subHeading = newsDict["subHeading"] as? String{
            self.subHeading = subHeading
        }
        if let publishLocation = newsDict["publishLocation"] as? String{
            self.publishLocation = publishLocation
        }
        if let publisherUrl = newsDict["publisherUrl"] as? String{
            self.publisherUrl = publisherUrl
        }
        if let publisherMagazine = newsDict["publisherMagazine"] as? String{
            self.publisherMagazine = publisherMagazine
        }
        if let likeStatus = newsDict["likeStatus"] as? Bool{
            self.likeStatus = likeStatus
        }
        if let likedata = newsDict["likeData"] as? [[String:AnyObject]]{
            var likes = [Like]()
            for obj in likedata{
                let like = Like(likeDict: obj)
                likes.append(like)
            }
            self._likeData = likes
        }
        if let commentData = newsDict["commentData"] as? [[String:AnyObject]]{
            var comments = [Like]()
            for obj in commentData{
                let cmnt = Like(commentDict: obj)
                comments.append(cmnt)
            }
            self._commentDict = comments
        }
        if let newsImage = newsDict["newsPic"] as? String{
            self._newsImage = newsImage
        }
        if let newsId = newsDict["postId"] as? String{
            self._newsId = newsId
        }
    }
    
}

