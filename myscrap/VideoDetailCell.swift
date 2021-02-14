//
//  VideoDetailCell.swift
//  myscrap
//
//  Created by MyScrap on 23/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos

class VideoDetailCell: BaseCell {



       @IBOutlet weak var thumbnailImg: UIImageView!
       @IBOutlet weak var playBtn: UIButton!
       
    
    var indexPath : Int =  0
       weak var updatedDelegate : UpdatedFeedsDelegate?
       var feedV2Service : FeedV2Model?
       
       var offlineBtnAction : (() -> Void)? = nil
       var commentBtnAction : (() -> Void)? = nil
       var addCommentAction : (() -> Void)? = nil
       var likeBtnAction : (() -> Void)? = nil
       
       var playBtnAction: (() -> Void)? = nil
       var dwnldBtnAction: (() -> Void)? = nil
       
       var muteBtnAction: (() -> Void)? = nil
       
       var inDetailView = false
       
       var player = AVQueuePlayer()
       var playerLayer = AVPlayerLayer()
       var timeObserverToken: Any?
    
        var gameTimer: Timer?
       
       //var thumbnailImg = UIImageView()
       
       private var cache = URLCache.shared
       
       
       /* API V2.0*/
       var newItem : FeedV2Item? {
           didSet{
               guard let item = newItem else { return }
               configCell(withItem: item)
           }
   
       }
       var newVedio : VideoURL? {
                didSet{
                    guard let item = newVedio else { return }
                    configCell(withItem: item)
                }
            }
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
    
//           setupFriendViewTaps()
           
           //player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
//        player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
//        if #available(iOS 10.0, *) {
//            player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
//        } else {
//            player.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
//        }
//        player.isMuted = true
//           if #available(iOS 12.0, *) {
//               player.preventsDisplaySleepDuringVideoPlayback = false
//           } else {
//               // Fallback on earlier versions
//
        
         // playBackTimeLbl.isHidden = true

       //    muteBtn .addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
           //NotificationCenter.default.addObserver(self, selector: #selector(videoDidPlay(notification:)), name: Notification.Name.videoCellPlay, object: nil)
           //NotificationCenter.default.addObserver(self, selector: #selector(videoDidPause(notification:)), name: Notification.Name.videoCellPause, object: nil)
           
           //Video view tap for Mute and unmute
       }
       
       /*
       override func prepareForReuse() {
           super.prepareForReuse()
           player = AVPlayer(playerItem: nil)
           videoView.layer.sublayers?[0].removeFromSuperlayer()
           videoView.setNeedsDisplay()
       }
       */
       
       func configCell(withItem item: FeedV2Item) {
           
         // c
         //   setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
                     thumbnailImg.isHidden = false
      //  }
        playBtn.isHidden = false

        
           thumbnailImg.contentMode = .scaleAspectFill
           thumbnailImg.clipsToBounds = true
           
           self.thumbnailImg.setImageWithIndicator(imageURL: item.videoThumbnail)
       //    setupVideoLayer(videoUrl: URL(string: item.videoUrl)!)
            
      
    }
    override func layoutSubviews() {
        super.layoutSubviews()
      //  setupVideoLayer(videoUrl: URL(string: newItem!.videoUrl)!)
      //  adjustIconWidths()`
       
        self.updateConstraintsIfNeeded()
        self.layoutIfNeeded()
    }
    func configCell(withItem item: VideoURL) {
        
                 //   setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
                   self.thumbnailImg.setImageWithIndicator(imageURL: item.videoThumbnail)
                             thumbnailImg.isHidden = false
                       
                             thumbnailImg.contentMode = .scaleAspectFill
                             thumbnailImg.clipsToBounds = true
                
        
           
         
           
            
       
    }
    
    @IBAction func playBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            guard let item = newVedio else { return }
            //Here updating the view count in feeds
            updatedDelegate?.didTapVideoViews(item: item, cell: self)
            
        } else {
            offlineBtnAction?()
        }
        playBtnAction?()
    }
           //MARK:- NAME LABEL
       

       func getThumbnailCache(url: URL) -> UIImage? {
           let request = URLRequest(url: url)
           let cache = URLCache.shared
           
           if let cachedResponse = cache.cachedResponse(for: request), let image = UIImage(data: cachedResponse.data) {
               return image
           }
      
           var image: UIImage?
           self.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
               if let image = image, let data = image.pngData(), let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
                   let cachedResponse = CachedURLResponse(response: response, data: data)
                   cache.storeCachedResponse(cachedResponse, for: request)
                   
               }
               image = thumbImage
           }
           return image
           
           
       }
       
       func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
           DispatchQueue.global().async { //1
               let asset = AVAsset(url: url) //2
               let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
               avAssetImageGenerator.appliesPreferredTrackTransform = true //4
               let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
               
               do {
                   let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                   let thumbImage = UIImage(cgImage: cgThumbImage) //7
                   DispatchQueue.main.async { //8
                       completion(thumbImage) //9
                   }
               } catch {
                   print(error.localizedDescription) //10
                   DispatchQueue.main.async {
                       completion(nil) //11
                   }
               }
           }
       }
      

}
