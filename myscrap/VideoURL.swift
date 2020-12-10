//
//  PictureURL.swift
//  myscrap
//
//  Created by MS1 on 7/11/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation


final class  VideoURL {
    

    
    private var _postId:String!
    private var _videoThumbnail:String!
    private var _videoType:String!
    private var _video:String!
     private var _download:String!
    private var _videoId:String!

   
    var postId:String{
        if _postId == nil{
            
            _postId = ""
        }
        return _postId
        
    }
    var videoThumbnail:String{
        
        if _videoThumbnail == nil{
            
            _videoThumbnail = ""
        }
        return _videoThumbnail
    }
    var video:String{
           
           if _video == nil{
               
               _video = ""
           }
           return _video
       }
    var videoType:String{
        
        if _videoType == nil{
            
            _videoType = ""
        }
        return _videoType
    }
    var download:String{
              
              if _download == nil{
                  
                  _download = ""
              }
              return _download
          }
       var videoId:String{
           
           if _videoId == nil{
               
               _videoId = ""
           }
           return _videoId
       }
       

    
    init(videoDict:Dictionary<String,AnyObject>){
        

        if let postId = videoDict["postId"] as? String{
                
            self._postId = postId
        }
        if let videoThumbnail = videoDict["videoThumbnail"] as? String{
            
            self._videoThumbnail = videoThumbnail
        }
        if let video = videoDict["video"] as? String{
            
            self._video = video
        }
        if let videoType = videoDict["videoType"] as? String{
                 
                 self._videoType = videoType
             }
             if let download = videoDict["download"] as? String{
                 
                 self._download = download
             }
        if let videoId = videoDict["videoId"] as? String{
                       
                       self._videoId = videoId
                   }
        
    }
    
   
}

