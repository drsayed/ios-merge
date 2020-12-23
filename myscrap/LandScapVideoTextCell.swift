//
//  LandScapVideoTextCell.swift
//  myscrap
//
//  Created by MyScrap on 23/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos
protocol LandScapVideoTextDelegate:class {
    func LandScapTextVideoChanged()
    func LandScapVideoTextFullScreenPressed(player: AVPlayer)
}
class LandScapVideoTextCell: BaseCell {
    weak var delegateVideoChange : LandScapVideoTextDelegate?
    @IBOutlet var fancyViewWidthConstraint : NSLayoutConstraint!

     @IBOutlet weak var editButton: UIButton!
       @IBOutlet weak var favouriteBtn: FavouriteButton!
       @IBOutlet weak var timeLbl: TimeLabel!
       @IBOutlet weak var nameLbl: UILabel!
       @IBOutlet weak var designationLbl: DesignationLabel!
           var muteVideo = true
       @IBOutlet weak var reportedView: ReportedView!
       @IBOutlet weak var unReportBtn: UnReportBtn!
       @IBOutlet weak var profileView: ProfileView!
       @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
       @IBOutlet weak var videosCountView: UIView!
       @IBOutlet weak var videosCoutLable: UILabel!
       @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var videosCollection: UICollectionView!
    var visibleCellIndex = IndexPath()

       @IBOutlet weak var statusTextView: UserTagTextView!
       @IBOutlet weak var videoView: UIView!
       @IBOutlet weak var muteBtn: UIButton!
       @IBOutlet weak var thumbnailImg: UIImageView!
       @IBOutlet weak var playBtn: UIButton!
       @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var playBackTimeLbl: UILabel!
       
       @IBOutlet weak var likeCountBtn: UIButton!
       @IBOutlet weak var commentCountBtn: VideoCommentCountBtn!
       @IBOutlet weak var viewCount: ViewCountButton!
    @IBOutlet weak var likeCommentViewHeight: NSLayoutConstraint!

       @IBOutlet weak var likeImage: LikeImageV2FeedButton!
       @IBOutlet weak var likeBtn: UIButton!
       @IBOutlet weak var commentBtn: UIButton!
       @IBOutlet weak var comImgBtn: CommentImageV2Button!
       @IBOutlet weak var downloadImgBtn: UIButton!
       @IBOutlet weak var dwnldBtn: UIButton!
       @IBOutlet weak var shareImgBtn: ShareImageV2Button!
       @IBOutlet weak var shareBtn: UIButton!
       @IBOutlet weak var reportImgBtn: ReportImgV2Button!
       @IBOutlet weak var reportBtn: UIButton!
       @IBOutlet weak var reportBtnWidth: NSLayoutConstraint!
       @IBOutlet weak var reportBtnHeight: NSLayoutConstraint!
       @IBOutlet weak var reportStackView: UIStackView!
       
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
       
       var player = AVPlayer()
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
            self.refreshTable()
           }
       }
       
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
           setupTap()
           setupFriendViewTaps()
        visibleCellIndex = IndexPath(item: 0, section: 0)
        self.videosCountView.layer.cornerRadius =   self.videosCountView.frame.size.height/2
        let viewWidth = UIScreen.main.bounds.width
        self.fancyViewWidthConstraint.constant = UIScreen.main.bounds.width
//           spinner.startAnimating()
//           spinner.hidesWhenStopped = true
//           //player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
//           player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
//           if #available(iOS 10.0, *) {
//               player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
//           } else {
//               player.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
//           }
//           player.isMuted = true
//           if #available(iOS 12.0, *) {
//               player.preventsDisplaySleepDuringVideoPlayback = false
//           } else {
//               // Fallback on earlier versions
//           }
//
//           let muteImg = #imageLiteral(resourceName: "mute-60x60")
//           let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//
//           let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
//           let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//
//           if player.isMuted {
//               //player.isMuted = false
//               muteBtn.setImage(tintMuteImg, for: .normal)
//           } else {
//               //player.isMuted = true
//               muteBtn.setImage(tintUnmuteImg, for: .normal)
//           }
//           playBackTimeLbl.isHidden = true
           
           /*
           let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
           videoTap.numberOfTapsRequired = 1
           thumbnailImg.isUserInteractionEnabled = true
           thumbnailImg.addGestureRecognizer(videoTap)
       */
           
           //thumbnailImg.frame = CGRect(x: self.videoView.x, y: self.videoView.y, width: self.width, height: 400)
           
           //self.videoView.addSubview(self.thumbnailImg)
           //thumbnailImg.contentMode = .scaleAspectFill
           
           //NotificationCenter.default.addObserver(self, selector: #selector(videoDidPlay(notification:)), name: Notification.Name.videoCellPlay, object: nil)
           //NotificationCenter.default.addObserver(self, selector: #selector(videoDidPause(notification:)), name: Notification.Name.videoCellPause, object: nil)
           
           
           
           /*cache = URLCache(memoryCapacity: 100, diskCapacity: 100, diskPath: nil) // replace capacities with your own values
           playerLayer = AVPlayerLayer(player: player)
           print("Video Text view frame : \(videoView.bounds)")
           playerLayer.frame = self.videoView.bounds  //bounds of the view in which AVPlayer should be displayed
           //playerLayer.frame = CGRect(x: self.videoView.x, y: 0, width: self.width, height: 400)
           print("Player Text view frame : \(playerLayer.frame)")
           playerLayer.videoGravity = .resizeAspectFill
           */
           
           
           //Video view tap for Mute and unmute
//           let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
//           videoTap.numberOfTapsRequired = 1
//           videoView.isUserInteractionEnabled = true
//           videoView.addGestureRecognizer(videoTap)
            
       }
    func SetLikeCountButton()  {
        guard  let item = newItem else { return }
        if item.likeStatus{
            
            if item.likeCount == 1 {
                item.likedByText = "Liked by You and 1 other"
            } else if item.likeCount >= 2 {
                item.likedByText = "Liked by You and \(item.likeCount) others"
            } else {
                item.likedByText = "Liked by You"
            }
            item.likeCount += 1
        }
        self.likeCountBtn.setTitle(item.likedByText, for: .normal)

    }
    func UpdateLable()  {
        if let countLable  = self.viewWithTag(1001) as? UILabel {
    countLable.text = "\(Int((self.videosCollection.contentOffset.x / self.videosCollection.contentSize.width) * CGFloat((self.newItem?.videoURL.count ?? 0) as Int))+1)/\(self.newItem!.videoURL.count as Int)"
          
    }
    }
    @objc func pauseVisibleVideos()  {
        
       for videoCell in self.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
    }
    @objc func playingVideoDidEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            //Video time be set to 0
            
            /*-----------------------------------------------*/
            playerItem.seek(to: CMTime.zero) { (reachedEnd) in
                if reachedEnd {
                    print("Visible video started")
                }
            }
        }
    }
    
    @objc func pausedVideoDidEnd(notification: Notification) {
        
        if let player = notification.object as? AVPlayer {
            print("Visible video ended")
            player.pause()
            
            /*let playerItem = player.currentItem
            let currentItem = player.currentItem?.currentTime()
            playerItem!.seek(to: currentItem!) { (reachedPause) in
                if reachedPause {
                    print("Paused video started")
                    player.pause()
                }
            }*/
        }
    }

       func refreshTable()  {
             
                self.videosCollection.register(LandScapCell.Nib, forCellWithReuseIdentifier: LandScapCell.identifier)
                  // self.totalImagesCountVieew.layer.cornerRadius = 10
                if self.newItem != nil && self.newItem!.videoURL.count as Int > 0 {
                    self.videosCollection.delegate = self
                            self.videosCollection.dataSource = self
                     self.pageController.numberOfPages = self.newItem!.videoURL.count as Int
                   
                    
                    self.videosCoutLable.text = "1/\(self.newItem!.videoURL.count as Int)"
                        
                  //  self.imageCountLable.text = "1/\(self.newItem!.videoURL.count as Int)"
                        //  self.totalImages = item?.videoURL
                    if self.newItem!.videoURL.count as Int == 1 {
                        self.pageController.isHidden = true
                            self.videosCountView.isHidden = true
                       
                    }
                    else
                    {
                        self.pageController.isHidden = false
                     
                        self.videosCountView.isHidden = false
                    
                           
                    }
                          self.videosCollection.reloadData()
                }
              
            }
            
       override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "status" {
               if player.status == .readyToPlay {
                   print("Player got ready to play Video")
               }
           } else if keyPath == "timeControlStatus" {
               if #available(iOS 10.0, *) {
                   if player.timeControlStatus == .playing {
                       print("Video started")
                       thumbnailImg.isHidden = true
                       videoView.isHidden = false
                       spinner.stopAnimating()
                   } else {
                       print("Video not playing")
                   }
               }
           } else if keyPath == "rate" {
               if player.rate > 0   {
                   print("video total seconds : \(player.rate)")
               }
           }
       }
       
       /*override func prepareForReuse() {
           super.prepareForReuse()
           player = AVPlayer(playerItem: nil)
           videoView.layer.sublayers?[0].removeFromSuperlayer()
           videoView.setNeedsDisplay()
       }*/
       
       func configCell(withItem item: FeedV2Item) {
           //setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
//           thumbnailImg.isHidden = false
//           videoView.isHidden = true
//           thumbnailImg.contentMode = .scaleAspectFill
//           thumbnailImg.clipsToBounds = true
//
//           self.thumbnailImg.setImageWithIndicator(imageURL: item.videoThumbnail)
//           setupVideoLayer(videoUrl: URL(string: item.videoUrl)!)
//           if player.rate == 0 {
//                addPeriodicTimeObserver()
//           }
           
           
           //MARK:- NAME LABEL
           setupNameLabel(item: item)
           
           profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:item.newJoined, rank:nil, isLevel: item.isLevel, level: item.level)
           
           // MARK:- PROFILE VIEW CONFIGURATION
           profileView.updateViews(name: item.postedUserName, url: item.profilePic, colorCode: item.colorCode)
           
           
           
           //MARK:- TIME LABEL
           timeLbl.text = "\(item.timeStamp)"
           print("Checking in wallvc : \(String(describing: timeLbl.text))")
           
           if inDetailView {
               likeCountBtn.isHidden = true
               commentCountBtn.isHidden = true
               viewCount.isHidden = true
           } else {
               if item.viewsCount == 0 && item.commentCount == 0{
                   viewCount.isHidden = true
                   commentCountBtn.isHidden = true
               } else if item.viewsCount != 0 && item.commentCount == 0 {
                   viewCount.isHidden = false
                   commentCountBtn.isHidden = true
                   
                   viewCount.viewCount = item.viewsCount
               } else if item.viewsCount == 0 && item.commentCount != 0 {
                   viewCount.isHidden = true
                   commentCountBtn.isHidden = false
                   
                   commentCountBtn.viewCount = item.likeCount
                   commentCountBtn.commentCount = item.commentCount
               } else {
                   viewCount.isHidden = false
                   commentCountBtn.isHidden = false
                   viewCount.viewCount = item.viewsCount
                   commentCountBtn.viewCount = item.likeCount
                   commentCountBtn.commentCount = item.commentCount
               }
               if item.likeCount == 0 {
                   likeCountBtn.isHidden = true
               } else {
                   likeCountBtn.isHidden = false
                   likeCountBtn.setTitle(item.likedByText, for: .normal)
                   //likeCountBtn.likeCount = item.likeCount
                   
               }
           }
           
           //MARK:- LIKE IMAGE AND COMMENT IMAGE
           let likeCount = String(format: "%d", item.likeCount)
           likeBtn.setTitle(likeCount, for: .normal)
           likeImage.isLiked = item.likeStatus
           let cmtCount = String(format: "%d", item.commentCount)
           commentBtn.setTitle(cmtCount, for: .normal)
           
           reportedView.isHidden = !item.isReported
           unReportBtn.isHidden =  !((item.reportedUserId == AuthService.instance.userId) || item.moderator == "1")
           
           if item.postedUserId != AuthService.instance.userId {
               //editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
               //editButton.setTitleColor(.black, for: .normal)
               //editButton.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal)
               //editButton.setImage(UIImage(named: ""), for: .normal)
               //print("I'm here in edit")
               //editButton.isHidden = false
               
               editButton.setTitle("", for: .normal)
               editButton.setImage(#imageLiteral(resourceName: "arrow-double").withRenderingMode(.alwaysOriginal), for: .normal)
               //editButton.tintColor = UIColor.BLACK_ALPHA
               print("I'm here in edit")
               editButton.isHidden = false
           } else {
               editButton.isHidden = false
               editButton.setTitle("", for: .normal)
               editButton.setImage(#imageLiteral(resourceName: "ellipsis2").withRenderingMode(.alwaysTemplate), for: .normal)
               editButton.tintColor = UIColor.BLACK_ALPHA
           }
           //editButton.isHidden = !(item.postedUserId == AuthService.instance.userId)
           favouriteBtn.isFavourite = item.isPostFavourited
           setupAPIViews(item: item)
           profileTypeView?.checkType = (isAdmin:false,isMod: item.moderator == "1", isNew:item.newJoined, rank:item.rank, isLevel: item.isLevel, level: item.level)
           
           //setupVideoLayer(videoUrl: URL(string: item.videoUrl)!)
           //setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
           
           if item.postedUserId == AuthService.instance.userId {
               reportImgBtn.isHidden = true
               reportBtn.isHidden = true
               //reportBtnWidth.constant = 0
               //reportBtnHeight.constant = 0
               reportStackView.isHidden = true
           } else {
               reportImgBtn.isHidden = false
               reportBtn.isHidden = false
               //reportBtnWidth.constant = 25
               //reportBtnHeight.constant = 25
               reportStackView.isHidden = false
           }
        if (item.likeCount == 0 && item.commentCount == 0  && item.viewsCount == 0 ){
            likeCommentViewHeight.constant = 0
        }
        else{
            likeCommentViewHeight.constant = 22
        }
       }
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1, preferredTimescale: timeScale)

        //gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [self] time in
            // update player transport UI
            if self.player.currentItem?.status == .readyToPlay {
                
                self.gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: false)
                let currentTime = CMTimeGetSeconds((self.player.currentTime()))
                
                let duration = CMTimeGetSeconds((self.player.currentItem?.asset.duration)!)
             
                    let secs = Int(duration - currentTime)
                 self.playBackTimeLbl.isHidden = false
                 self.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
                
            }
        }
    }
    
    @objc func runTimedCode() {
        DispatchQueue.main.async {
            self.gameTimer!.invalidate()
            self.playBackTimeLbl.isHidden = true
            self.removePeriodicTimeObserver()
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
       
       @objc func videoViewTapped(tapGesture: UITapGestureRecognizer) {
           /*var tagId = tapGesture.view!.tag
           let muteImg = #imageLiteral(resourceName: "mute-60x60")
           let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           
           let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
           let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           
           if tagId == 0 {
               if player.isMuted {
                   player.isMuted = false
                   muteBtn.setImage(tintMuteImg, for: .normal)
               } else {
                   player.isMuted = true
                   muteBtn.setImage(tintUnmuteImg, for: .normal)
               }
               tagId = 1
           } else {
               if player.isMuted {
                   player.isMuted = false
                   muteBtn.setImage(tintMuteImg, for: .normal)
               } else {
                   player.isMuted = true
                   muteBtn.setImage(tintUnmuteImg, for: .normal)
               }
               tagId = 0
           }*/
           muteBtnAction?()
           if inDetailView {
               if network.reachability.isReachable == true {
                   guard let item = newItem else { return }
                   //In detail view just calling the api
                   updatedDelegate?.didTapDetailVideoViews(item: item, cell: self)
               } else {
                   offlineBtnAction?()
               }
           } else {
               if network.reachability.isReachable == true {
                   guard let item = newItem else { return }
                   //Here updating the view count in feeds
                   updatedDelegate?.didTapVideoViews(item: item, cell: self)
               } else {
                   offlineBtnAction?()
               }
           }
           //playBtnAction?()
       }
       
       func setupThumbnail(videoUrl: URL) {
           
           
           /*self.getThumbnailImageFromVideoUrl(url: videoUrl) { (thumbImage) in
               self.thumbnailImg.image = thumbImage
           }*/
           //let thumbImage = getThumbnailCache(url: videoUrl)
           //self.thumbnailImg.image = thumbImage
           //self.thumbnailImg.sd_setImage(with: videoUrl, completed: nil)
           
       }
       
       func getThumbnailCache(url: URL) -> UIImage? {
           let request = URLRequest(url: url)
           let cache = URLCache.shared
           
           if let cachedResponse = cache.cachedResponse(for: request), let image = UIImage(data: cachedResponse.data) {
               return image
           }
           /*
           let asset = AVAsset(url: url) //2
           let imageGenerator = AVAssetImageGenerator(asset: asset) //3
           imageGenerator.appliesPreferredTrackTransform = true //4
           
           var time = asset.duration
           //time.value = min(time.value, 2)
           //time.value = min(1, 1)
           let thumnailTime = CMTimeMake(2, 1)
           
           var image: UIImage?
           
           do {
               let cgImage = try imageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
               image = UIImage(cgImage: cgImage)
           } catch {
               print("Thumbnail image load Error",error.localizedDescription) //10
           }
           */
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
               avAssetImageGenerator.maximumSize = CGSize(width: self.width, height: 600)
               
               //let thumnailTime = CMTimeMakeWithSeconds(0.5, 1) //5
               let thumnailTime = CMTimeMake(value: 2, timescale: 1)
               do {
                   let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                   let thumbImage = UIImage(cgImage: cgThumbImage) //7
                   DispatchQueue.main.async { //8
                       completion(thumbImage) //9
                   }
               } catch {
                   print("Thumbnail image load",error.localizedDescription) //10
                   DispatchQueue.main.async {
                       completion(nil) //11
                   }
               }
           }
       }
       /*
       func setupVideoLayer(videoUrl: URL) {
           let requestUrl = URLRequest(url: videoUrl)
           if let cachedResponse = cache.cachedResponse(for: requestUrl) {
               print("Cached URL :\(cachedResponse.response.url)")
               player.replaceCurrentItem(with: AVPlayerItem(url: cachedResponse.response.url!))
               self.videoView.layer.insertSublayer(playerLayer, at: 0)
           } else {
               player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
               self.videoView.layer.insertSublayer(playerLayer, at: 0)
           }
       }
       */
       func setupVideoLayer(videoUrl: URL) {
           
           //player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
           /*if let video = showVideo {
            player.replaceCurrentItem(with: AVPlayerItem(url: video))
            }*/
           
           //2. Create AVPlayer object
           //let asset = AVAsset(url: showVideo!)
           //let playerItem = AVPlayerItem(asset: asset)
           //player = AVPlayer(playerItem: playerItem)
           
           //3. Create AVPlayerLayer object
           //playerLayer = AVPlayerLayer(player: player)
           //playerLayer.frame = self.videoView.bounds //bounds of the view in which AVPlayer should be displayed
           //playerLayer.videoGravity = .resizeAspectFill
           
           //4. Add playerLayer to view's layer
           //self.videoView.layer.addSublayer(playerLayer)
           
           //self.videoView.layer.insertSublayer(playerLayer, at: 0)
           spinner.startAnimating()
           
           
           player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
           playerLayer = AVPlayerLayer(player: player)
           let bounds = UIScreen.main.bounds
           let width = bounds.size.width
           self.videoView.width = width
           playerLayer.frame = self.videoView.bounds //bounds of the view in which AVPlayer should be displayed
          //playerLayer.frame = CGRect(x: self.videoView.x, y: self.videoView.y - 110.0, width: width, height: self.videoView.height)
           print("Video frame height : \(playerLayer.frame)")
           playerLayer.videoGravity = .resize
           //self.videoView.layer.addSublayer(playerLayer)
           self.videoView.layer.insertSublayer(playerLayer, at: 0)
           
           //player.play()
           let muteImg = #imageLiteral(resourceName: "mute-60x60")
           let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           
           let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
           let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           
           if player.isMuted {
               muteBtn.setImage(tintMuteImg, for: .normal)
           } else {
               muteBtn.setImage(tintUnmuteImg, for: .normal)
           }
           
           
           //thumbnailImg.isHidden = true
           //videoView.isHidden = false
        //NotificationCenter.default.addObserver(self, selector: #selector(self.videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
       }
       
       func downloadVideo(item : FeedV2Item) {
           let videoImageUrl = item.videoUrl
           
           DispatchQueue.global(qos: .background).async {
               if let url = URL(string: videoImageUrl),
                   let urlData = NSData(contentsOf: url) {
                   let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                   let filePath="\(documentsPath)/MSVIDEO.mp4"
                   DispatchQueue.main.async {
                       urlData.write(toFile: filePath, atomically: true)
                       PHPhotoLibrary.shared().performChanges({
                           PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                       }) { completed, error in
                           if completed {
                               print("Video is saved!")
                           }
                       }
                   }
               }
           }
       }
       
       func setupNameLabel(item : FeedV2Item){
           
           //MARK:- Designation Label
           //designationLbl.textColor = UIColor.white
           
           if item.userCompany != "" {
               designationLbl.text = "\(item.postedUserDesignation) • \(item.userCompany)"
           } else {
               designationLbl.text = item.postedUserDesignation
           }
           
           //MARK:- NAME LABEL
           let attributedString = NSMutableAttributedString(string: item.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.black])
           nameLbl.attributedText = attributedString
           //nameLbl.text = item.postedUserName
           print("Posted user Name in video text cell : \(nameLbl.text)")
           
       }
       
       @objc func videoDidPlay(notification: NSNotification) {
           if spinner.isAnimating {
               spinner.stopAnimating()
           }
           
           do{
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
               try AVAudioSession.sharedInstance().setActive(true)
           }catch{
               //some meaningful exception handling
               print("Couldn't able to stop the background music playback")
           }
           
           player.play()
       }
       
       @objc func videoDidPause(notification: NSNotification){
           
           player.pause()
           do{
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
               try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
           }catch{
               //some meaningful exception handling
               print("Couldn't start the background play back once when video paused")
           }
       }
       
       @objc func videoDidEnd(notification: NSNotification) {
           print("video ended")
           //playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
           player.seek(to: CMTime.zero)
           //playPauseBtn.tag = 0
           player.play()
       }
       
       func setupTap(){
           if network.reachability.isReachable == true {
               statusTextView?.isUserInteractionEnabled = true
               let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
               tap.numberOfTapsRequired = 1
               statusTextView?.addGestureRecognizer(tap)
           } else {
               offlineBtnAction?()
           }
       }
       
       func setupAPIViews(item:FeedV2Item){
           statusTextView?.attributedText = item.descriptionStatus
       }
       
       private func setupFriendViewTaps() {
           if network.reachability.isReachable == true {
               profileView.isUserInteractionEnabled = true
               let profiletap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
               profiletap.numberOfTapsRequired = 1
               profileView.addGestureRecognizer(profiletap)
               
               
               let tap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
               tap.numberOfTapsRequired = 1
               nameLbl.isUserInteractionEnabled = true
               nameLbl.addGestureRecognizer(tap)
           } else {
               offlineBtnAction?()
           }
       }
       
       @objc private func toFriendView(_ sender: UITapGestureRecognizer){
           guard let item = newItem else { return }
           updatedDelegate?.didTapForFriendView(id: item.postedUserId)
       }
       
       @objc func DidTappedTextView(_ sender: UITapGestureRecognizer){
           let textView = sender.view as! UITextView
           let layoutManager = textView.layoutManager
           //location of tap in textview coordinates and taking the inset into account
           var location = sender.location(in: textView)
           location.x -= textView.textContainerInset.left
           location.y -= textView.textContainerInset.top
           //character index at tap location
           let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
           // if index is valid
           if characterIndex < textView.textStorage.length{
               let friendId = textView.attributedText.attribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.USERTAG), at: characterIndex, effectiveRange: nil) as? String
               let continueReading = textView.attributedText.attribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.CONTINUE_READING), at: characterIndex, effectiveRange: nil) as? String
               let webLink = textView.attributedText.attribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.URL), at: characterIndex, effectiveRange: nil) as? String
               
               if let id = friendId {
                   updatedDelegate?.didTapForFriendView(id: id)
               }
               if let _ = continueReading{
                   updatedDelegate?.didTapContinueReadingV2(item: newItem!, cell: self)
               }
               
               if let link = webLink  {
                   updatedDelegate?.didTap(url: link)
               }
           }
       }
       
       @IBAction func playBtnTapped(_ sender: UIButton) {
           if network.reachability.isReachable == true {
               guard let item = newItem else { return }
               updatedDelegate?.didTapVideoViews(item: item, cell: self)
           } else {
               offlineBtnAction?()
           }
           playBtnAction?()
       }
       
       @IBAction func videoViewBtnTapped(_sender: UIButton) {
           if network.reachability.isReachable {
               guard let item = newItem else { return }
               updatedDelegate?.didTapVideoViewCountV2(item: item)
           } else {
               offlineBtnAction?()
           }
       }
       
       @IBAction func editBtnPressed(_ sender: UIButton) {
           if network.reachability.isReachable == true {
               guard let item = newItem else { return }
               if item.postedUserId != AuthService.instance.userId {
                   updatedDelegate?.didTapForFriendView(id: item.postedUserId)
               } else {
                   updatedDelegate?.didTapEditV2(item: item, cell: self)
               }
               
           } else {
               offlineBtnAction?()
           }
           //        guard let item = item else { return }
           //        delegate?.didTapEdit(item: item, cell: self)
       }
       
       @IBAction func favouriteBtnPressed(_ sender: UIButton) {
           if network.reachability.isReachable == true {
               guard  let item = newItem else { return }
               updatedDelegate?.didTapFavouriteV2(item: item, cell: self)
           } else {
               offlineBtnAction?()
           }
           //        guard  let item = item else { return }
           //        delegate?.didTapFavourite(item: item, cell: self)
       }
       
       @IBAction func likePressed(_ sender: UIButton){
           if network.reachability.isReachable == true {
               print("LIKE ***")
               if inDetailView {
                   guard let item = newItem else { return }
                   updatedDelegate?.didTapDetailFeedsLikeV2(item: item, cell: self)
                   likeBtnAction?()
               } else {
                   guard let item = newItem else { return }
                   if let del = updatedDelegate {
                       print("delegate is there", del)
                   }
                   updatedDelegate?.didTapLikeV2(item: item, cell: self)
               }
           } else {
               offlineBtnAction?()
           }
       }
       
       @IBAction func toDetailsVC(_ sender: UIButton){
           
           if network.reachability.isReachable == true {
               print("Comment ***")
               guard let newItem = newItem else { return }
               //downloadVideo(item: newItem)
               if inDetailView {
                   //commentBtnAction?()
                
                    //User can write comment here in detail page.
                    //If no profile pic / no email / no mobile, user can't write comments.
                    
                    let profilePic = AuthService.instance.profilePic
                    let email = AuthService.instance.email
                    let mobile = AuthService.instance.mobile
                    if (profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || profilePic == "") || (mobile == "" || email == ""){
                        //User can't add comment
                        addCommentAction?()
                    } else {
                        commentBtnAction?()
                    }
               } else {
                   updatedDelegate?.didTapcommentV2(item: newItem)
               }
           } else {
               offlineBtnAction?()
           }
       }
       
       @IBAction func likeCountPressed(_ sender: LikeCountButton) {
           if network.reachability.isReachable == true {
               print("Like count")
               guard let newItem = newItem else { return }
               updatedDelegate?.didTapLikeCountV2(item: newItem)
           } else {
               offlineBtnAction?()
           }
       }
       
       @IBAction func dwnldBtnTapped(_ sender: UIButton) {
           self.dwnldBtnAction?()
           //guard let item = newItem else { return }
           //downloadVideo(item: item)
       }
       @IBAction func shareBtnTapped(_ sender: UIButton){
           if network.reachability.isReachable == true {
               guard let item = newItem else { return }
               updatedDelegate?.didTapShareVideoV2(sender: sender, item: item)
           } else {
               offlineBtnAction?()
           }
       }
       
       @IBAction func unreportBtnPressed(_ sender: UnReportBtn) {
           if network.reachability.isReachable == true {
               print("Unreport ***")
               guard  let newItem = newItem else { return }
               updatedDelegate?.didTapUnReportV2(item: newItem, cell: self)
           } else {
               offlineBtnAction?()
           }
       }
       
       @IBAction func reportBtnPressed(_ sender: UIButton) {
           if network.reachability.isReachable == true {
               print("Report ***")
               if sender.tag == 0 {
                   guard  let newItem = newItem else { return }
                   updatedDelegate?.didTapReportV2(item: newItem, cell: self)
               } else {
                   guard  let newItem = newItem else { return }
                   updatedDelegate?.didTapReportModV2(item: newItem, cell: self)
                   
               }
           } else {
               offlineBtnAction?()
           }
       }

}
extension LandScapVideoTextCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           let muteImg = #imageLiteral(resourceName: "mute-60x60")
           let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           
           let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
           let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           if let videoCell = cell as? LandScapCell {
            
            videoCell.playerView.isMuted = true
            if  videoCell.playerView.isMuted {
                videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
            } else {
                videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            }
            videoCell.pause()
 
}
//           if let videoCell = cell as? EmplLandscVideoCell {
//               //if videoCell.player.timeControlStatus == .playing {
//                   videoCell.player.isMuted = muteVideo
//                   if  videoCell.player.isMuted {
//                       videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                   } else {
//                       videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                   }
//                   videoCell.player.pause()
//                   videoCell.player.actionAtItemEnd = .pause
//               NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                   NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                   //videoCell.player.pause()
//               //}
//           }
//           if let videoCell = cell as? EmplPortrVideoTextCell {
//               //if videoCell.player.timeControlStatus == .playing {
//                   videoCell.player.isMuted = muteVideo
//                   if  videoCell.player.isMuted {
//                       videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                   } else {
//                       videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                   }
//                   videoCell.player.pause()
//                   videoCell.player.actionAtItemEnd = .pause
//               NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                   NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                   //videoCell.player.pause()
//               //}
//           }
//           if let videoCell = cell as? EmplLandsVideoTextCell {
//               //if videoCell.player.timeControlStatus == .playing {
//                   videoCell.player.isMuted = muteVideo
//                   if  videoCell.player.isMuted {
//                       videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                   } else {
//                       videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                   }
//                   videoCell.player.pause()
//                   videoCell.player.actionAtItemEnd = .pause
//               NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                   NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                   //videoCell.player.pause()
//               //}
//           }
       }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        visibleCellIndex = indexPath
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        if let videoCell = cell as? LandScapCell {
            let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
               if muteValue == "1"
               {
                muteVideo =  false
               }
                else
               {
                muteVideo =  true
               }
                videoCell.playerView.isMuted = muteVideo
                if  videoCell.playerView.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
              //  videoCell.pause()
//            videoCell.playerView.player.currentItem?.seek(to: CMTime(), completionHandler: { (_) in
//                player.play()
//            })
//                videoCell.player.actionAtItemEnd = .none
//
//                NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
                
            
        }
//        if let videoCell = cell as? PortraitVideoCell {
//            if videoCell.player.rate >= 0 {
//                videoCell.player.isMuted = muteVideo
//                if  videoCell.player.isMuted {
//                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                } else {
//                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                }
//                videoCell.player.play()
//                videoCell.player.actionAtItemEnd = .none
//
//                NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//
//            }
//        }
//        if let videoCell = cell as? PortraitVideoCell {
//            if videoCell.player.rate >= 0 {
//                videoCell.player.isMuted = muteVideo
//                if  videoCell.player.isMuted {
//                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                } else {
//                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                }
//                videoCell.player.play()
//                videoCell.player.actionAtItemEnd = .none
//
//                NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//
//            }
//        }
//        if let videoCell = cell as? EmplLandsVideoTextCell {
//           if videoCell.player.rate >= 0 {
//                videoCell.player.isMuted = muteVideo
//                if  videoCell.player.isMuted {
//                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                } else {
//                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                }
//                videoCell.player.play()
//                videoCell.player.actionAtItemEnd = .none
//
//                NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//
//            }
//        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newItem!.videoURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandScapCell.identifier, for: indexPath) as? LandScapCell else { return UICollectionViewCell()}
                      // cell.updatedDelegate = self
             //cell.indexPath = indexPath.row
         //      cell.newItem = self.newItem
        cell.newVedio = self.newItem!.videoURL[indexPath.row]
        cell.pause()
        cell.delegate = self
                       /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                        videoTap.numberOfTapsRequired = 1
                        cell.thumbnailImg.isUserInteractionEnabled = true
                        cell.thumbnailImg.addGestureRecognizer(videoTap)
                        cell.thumbnailImg.tag = indexPath.row*/
                      // self.visibleCellIndex = indexPath
                 cell.layoutIfNeeded()
               return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
   let item =  self.newItem!.videoURL[indexPath.row]
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        
             if   item.videoType == "landscape" {
              //   return CGSize(width:self.videosCollection.frame.size.width, height: 300)
return CGSize(width:screenWidth, height: 420)
             }
        else
             {
                return CGSize(width:screenWidth, height:420)

        }
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
        let currentPage : Int = Int((self.videosCollection.contentOffset.x / self.videosCollection.contentSize.width) * CGFloat((self.newItem?.videoURL.count ?? 0) as Int))
        self.pageController.currentPage = currentPage
        
                let muteImg = #imageLiteral(resourceName: "mute-60x60")
               let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
    let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
//        var visibleRect = CGRect()
//                visibleRect.origin = scrollView.contentOffset
//                visibleRect.size = scrollView.bounds.size
//
//
//
//                //print("minY : \(visibleRect.minY) \nmidY : \(visibleRect.midY) \nmaxY : \(visibleRect.maxY)")
//
//                let cgPoint = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.maxX)


//        guard let indexPath = self.videosCollection.indexPathForItem(at: cgPoint) else { return}
//                //let storedIndexPath = self.visibleCellIndex
//                let visibleCellIndexPath = self.videosCollection.indexPathsForVisibleItems
//                var centerIndexPath = IndexPath(row: NSNotFound, section: NSNotFound)
//        for cell in self.videosCollection.visibleCells
//        {
//            let  Index = self.videosCollection.indexPath(for: cell)
//            if Index != visibleCellIndex {
//                let videoCell = cell as! PortraitVideoCell
//                videoCell.playerView.isMuted = true
//                if  videoCell.playerView.isMuted {
//                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                } else {
//                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                }
//                videoCell.pause()
//            }
//        }
        self.pauseVisibleVideos()
        delegateVideoChange?.LandScapTextVideoChanged()

      //  NotificationCenter.default.post(name: Notification.Name("VideoPlayedChanged"), object: nil)

//        if visibleCellIndex.item != 0 && visibleCellIndex.item != ((self.newItem?.videoURL.count)!-1) {
//            let indexPathPre = IndexPath(row: visibleCellIndex.item-1, section: visibleCellIndex.section)
//            let indexPathNext = IndexPath(row: visibleCellIndex.item+1, section: visibleCellIndex.section)
//
//            let muteImg = #imageLiteral(resourceName: "mute-60x60")
//            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//
//            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
//            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//
//            if let videoCell = self.videosCollection.cellForItem(at: indexPathPre) as? PortraitVideoCell {
//                videoCell.videoView.isHidden = false
//                videoCell.playerView.isMuted = true
//                if  videoCell.playerView.isMuted {
//                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                } else {
//                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                }
//            videoCell.pause()
//            }
//
//            if let videoCell1 = self.videosCollection.cellForItem(at: indexPathNext) as? PortraitVideoCell {
//                videoCell1.videoView.isHidden = false
//                videoCell1.playerView.isMuted = true
//                if  videoCell1.playerView.isMuted {
//                    videoCell1.muteBtn.setImage(tintMuteImg, for: .normal)
//                } else {
//                    videoCell1.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                }
//                videoCell1.pause()
//            }
//
//        }
//
//}
//        }
        
        
        if let countLable  = self.viewWithTag(1001) as? UILabel {
    countLable.text = "\(Int((self.videosCollection.contentOffset.x / self.videosCollection.contentSize.width) * CGFloat((self.newItem?.videoURL.count ?? 0) as Int))+1)/\(self.newItem!.videoURL.count as Int)"
          
    }
    }
}

extension LandScapVideoTextCell : LandScapFullScreenDelegate
{
    func LandScapVideoFullScreenPressed(player: AVPlayer) {
        delegateVideoChange?.LandScapVideoTextFullScreenPressed(player: player)
    }
    
   
}
