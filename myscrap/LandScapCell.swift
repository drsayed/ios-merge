//
//  LandScapCell.swift
//  myscrap
//
//  LandScapCell.swift
//  myscrap
//
//  Created by MyScrap on 23/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos
protocol LandScapFullScreenDelegate:class {
    func  LandScapVideoFullScreenPressed(player : AVPlayer)
}
class LandScapCell: BaseCell {
    @IBOutlet weak var playButton: UIButton!
    
    weak var delegate: LandScapFullScreenDelegate?

    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var playerControllsView: UIView!
    
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var videoView: UIView!
       @IBOutlet weak var muteBtn: UIButton!
       @IBOutlet weak var thumbnailImg: UIImageView!
       @IBOutlet weak var playBtn: UIButton!
       @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var playBackTimeLbl: UILabel!
    var hideTimer: Timer?
    
    var indexPath : Int =  0
    var isHideControlls : Bool = true {
        didSet
        {
            if !isHideControlls
            {
                self.hideTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.hideeControlls), userInfo: nil, repeats: false)
            }
            else{
                
                self.hideTimer?.invalidate()
                self.hideTimer = nil

            }
        }
    }
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
    var timeObserverControlls: Any?
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
           spinner.startAnimating()
           spinner.hidesWhenStopped = true
        self.playerControllsView.isHidden = true
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
//           }
           
           let muteImg = #imageLiteral(resourceName: "mute-60x60")
           let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           
           let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
           let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           
           if player.isMuted {
               //player.isMuted = false
               muteBtn.setImage(tintMuteImg, for: .normal)
           } else {
               //player.isMuted = true
               muteBtn.setImage(tintUnmuteImg, for: .normal)
           }
        
         // playBackTimeLbl.isHidden = true
        muteBtn.addTarget(self, action: #selector(updateMute), for: .touchUpInside)

       //    muteBtn .addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
           //NotificationCenter.default.addObserver(self, selector: #selector(videoDidPlay(notification:)), name: Notification.Name.videoCellPlay, object: nil)
           //NotificationCenter.default.addObserver(self, selector: #selector(videoDidPause(notification:)), name: Notification.Name.videoCellPause, object: nil)
           
           //Video view tap for Mute and unmute
           let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
           videoTap.numberOfTapsRequired = 1
           videoView.isUserInteractionEnabled = true
        self.addGestureRecognizer(videoTap)
        playerView.contentMode =  UIView.ContentMode.scaleAspectFill
       }
    func TimeDurationFormater(time: Int) -> String {
            var currentTimeString =  ""
        if time < 10 {
           
            currentTimeString = "00:0\(time)"
        }
        else  if time < 60  {
            currentTimeString = "00:\(time)"
        }
        else
        {
            let minutes = time/60
            let seconds = time%60
            if minutes < 10 && seconds < 10 {
               
                currentTimeString = "0\(minutes):0\(seconds)"
            }
            else  if minutes < 10 && seconds > 10   {
                currentTimeString = "0\(minutes):\(seconds)"
            }
            else  if minutes > 10 && seconds < 10   {
                currentTimeString = "\(minutes):0\(seconds)"
            }
            else
            {
                currentTimeString = "\(minutes):\(seconds)"
            }
            
        }
        return currentTimeString
    }
    @IBAction func fullscreenPressed(_ sender: Any) {
        delegate?.LandScapVideoFullScreenPressed(player: playerView.playerLayer.player!)

    }
    @IBAction func mutePressed(_ sender: Any) {
//     //   self.updateMute()
    }
    @IBAction func progressbarChanged(_ sender: Any) {
     //  let segment =  sender as UISegmentedControl
        self.playerView.seek(to:CMTimeMake(value: Int64(progressBar.value), timescale: 1))
    }
    @IBAction func PlayPausePressed(_ sender: UIButton) {
        
        if  self.playButton.isSelected {
            self.pause()
            self.playButton.isSelected = false
        }
        else
        {
            self.resume()
            self.playButton.isSelected = true
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
                    //thumbnailImg.isHidden = false
                    //videoView.isHidden = true
                   }
               }
           } else if keyPath == "rate" {
               if player.rate > 0   {
                   print("video total seconds : \(player.rate)")
               }
           }
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
            setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
                     thumbnailImg.isHidden = false
      //  }
        if inDetailView {
            playBtn.isHidden = false
        }
        else{
            playBtn.isHidden = false
        }
           videoView.isHidden = true
           thumbnailImg.contentMode = .scaleAspectFill
           thumbnailImg.clipsToBounds = true
           
           self.thumbnailImg.setImageWithIndicator(imageURL: item.videoThumbnail)
           setupVideoLayer(videoUrl: URL(string: item.videoUrl)!)
            
        if player.rate == 0 {
          //  addPeriodicTimeObserver()
            addPeriodicTimeObserverForControls()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
      //  setupVideoLayer(videoUrl: URL(string: newItem!.videoUrl)!)
      //  adjustIconWidths()`
        spinner.center = self.center
        self.updateConstraintsIfNeeded()
        self.layoutIfNeeded()
    }
    func configCell(withItem item: VideoURL) {
        
           if inDetailView {
                    setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
                   self.thumbnailImg.setImageWithIndicator(imageURL: item.videoThumbnail)
                             thumbnailImg.isHidden = false
                             videoView.isHidden = true
                         playerControllsView.isHidden = true
                             thumbnailImg.contentMode = .scaleAspectFill
                             thumbnailImg.clipsToBounds = true
                }
        else
           {
            setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
           self.thumbnailImg.setImageWithIndicator(imageURL: item.videoThumbnail)
            thumbnailImg.isHidden = false
            videoView.isHidden = true
            spinner.startAnimating()
         //   playerView.pla
            playerView.play(for: URL(string: item.video)!)
            playerView.stateDidChanged = { [self] state in
                switch state {
                case .none:
                    print("none")
                case .error(let error):
                    print("error - \(error.localizedDescription)")
                case .loading:
                    self.spinner.startAnimating()
                    print("loading")
                case .paused(let playing, let buffering):
                    print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
                case .playing:
                    self.videoView.isHidden = false
                    self.playerControllsView.isHidden = false
                    self.isHideControlls = false
                    self.playButton.isSelected = true
                    self.spinner.stopAnimating()
                    print("playing")
                }
            }
          //  self.addPeriodicTimeObserver()
            if playerView.state != .playing {
                    //   addPeriodicTimeObserver()
                addPeriodicTimeObserverForControls()

                   }
        }
         
           
            
       
    }
    
           //MARK:- NAME LABEL
       
    @objc func updateMute()  {
        
          let muteImg = #imageLiteral(resourceName: "mute-60x60")
                  let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                  
                  let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
                  let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                  
                  if self.playerView.isMuted {
                      //muteVideo = false
                      self.playerView.isMuted = false
                    UserDefaults.standard.setValue("1", forKey: "MuteValue")
                      self.muteBtn.setImage(tintUnmuteImg, for: .normal)
                  } else {
                      //muteVideo = true
                    UserDefaults.standard.setValue("0", forKey: "MuteValue")

                      self.playerView.isMuted = true
                      self.muteBtn.setImage(tintMuteImg, for: .normal)
                  }
    }
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
     //gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        timeObserverToken = playerView.addPeriodicTimeObserver(forInterval: time, queue: .main) { [self] time in
            // update player transport UI
      
             self.gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: false)
             let currentTime = self.playerView.currentDuration //CMTimeGetSeconds((self.playerView.currentDuration))
                
                let duration = self.playerView.totalDuration //CMTimeGetSeconds((self.playerView.totalDuration)!)
       
        
    
                    let secs = Int(duration - currentTime)
                 self.playBackTimeLbl.isHidden = false
                 self.playBackTimeLbl.text = NSString(format: "00:%02d", secs) as String//"\(secs/60):\(secs%60)"
                
            
        }
    }
       func addPeriodicTimeObserverForControls() {
           // Notify every half second
           let timeScale = CMTimeScale(NSEC_PER_SEC)
           let time = CMTime(seconds: 1, preferredTimescale: timeScale)
        //gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        timeObserverControlls = playerView.addPeriodicTimeObserver(forInterval: time, queue: .main) { [self] time in
               // update player transport UI
         
             
                let currentTime = self.playerView.currentDuration //CMTimeGetSeconds((self.playerView.currentDuration))
                   
                   let duration = self.playerView.totalDuration //CMTimeGetSeconds((self.playerView.totalDuration)!)
            if duration > 0
            {
                progressBar.minimumValue = 0
                progressBar.maximumValue =  Float(duration)
                let normalizedTime = Float(currentTime / (duration) )
                let secs = Int(duration - currentTime)
                let dur = Int(duration)
                progressBar.value = Float(currentTime)
                var currentTimeString = ""
                var durationTimeString = ""
                let time = Int(progressBar.value)
                var timeDuration = Int(duration)
                if Double(timeDuration) < duration {
                    timeDuration = timeDuration + 1
                }
                currentTimeString  =  self.TimeDurationFormater(time: time)
                durationTimeString  =  self.TimeDurationFormater(time: timeDuration)

                self.timeLable.text = currentTimeString + "/" + "\(durationTimeString)"
              //  self.timeLable.text = "\(secs/60):\(secs%60)" + "/" +  "\(dur/60):\(dur%60)" // "\(NSString(format: "%02d:%02d", "\(secs/60)","\(secs%60)"))"
            }
           
       
//                       let secs = Int(duration - currentTime)
//                    self.playBackTimeLbl.isHidden = false
//                    self.playBackTimeLbl.text = NSString(format: "00:%02d", secs) as String//"\(secs/60):\(secs%60)"
                   
               
           }
       }
    
    @objc func runTimedCode() {
        DispatchQueue.main.async {
            self.gameTimer!.invalidate()
            self.playBackTimeLbl.isHidden = true
            self.removePeriodicTimeObserver()
        }
    }
    @objc func hideeControlls() {
        self.playerControllsView.isHidden = true
    }
       func removePeriodicTimeObserver() {
           if let timeObserverToken = timeObserverToken {
               playerView.removeTimeObserver(timeObserverToken)
               self.timeObserverToken = nil
           }
       }
    
       @objc func videoViewTapped(tapGesture: UITapGestureRecognizer) {
        self.playerControllsView.isHidden = !self.playerControllsView.isHidden
        isHideControlls = self.playerControllsView.isHidden
      
           if inDetailView {
               if network.reachability.isReachable == true {
                guard let item = newVedio else { return }
                //Here updating the view count in feeds
                updatedDelegate?.didTapVideoViews(item: item, cell: self)
               } else {
                   offlineBtnAction?()
               }
           } else {
               if network.reachability.isReachable == true {
                guard let item = newVedio else { return }
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
       
       /*func setupVideoLayer(videoUrl: URL) {
           let requestUrl = URLRequest(url: videoUrl)
           if let cachedResponse = cache.cachedResponse(for: requestUrl) {
               print("Cached URL :\(cachedResponse.response.url)")
               player.replaceCurrentItem(with: AVPlayerItem(url: cachedResponse.response.url!))
               self.videoView.layer.insertSublayer(playerLayer, at: 0)
           } else {
               player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
               self.videoView.layer.insertSublayer(playerLayer, at: 0)
           }
           
           //player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
           /*if let video = showVideo {
            player.replaceCurrentItem(with: AVPlayerItem(url: video))
            }*/
           
           //2. Create AVPlayer object
           //let asset = AVAsset(url: showVideo!)
           //let playerItem = AVPlayerItem(asset: asset)
           //player = AVPlayer(playerItem: playerItem)
           
           //3. Create AVPlayerLayer object
           /*let playerLayer = AVPlayerLayer(player: player)
           playerLayer.frame = self.videoView.bounds //bounds of the view in which AVPlayer should be displayed
           playerLayer.videoGravity = .resizeAspectFill
           */
           //4. Add playerLayer to view's layer
           //self.videoView.layer.addSublayer(playerLayer)
           
           
           NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name:
               NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
       }*/
       
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
           playerLayer .removeFromSuperlayer()
        //player.removeAllItems()
        let playerItem = AVPlayerItem(url: videoUrl)
     //   player.insert(AVPlayerItem(url: videoUrl), after: nil)
          player.replaceCurrentItem(with:playerItem)
           playerLayer = AVPlayerLayer(player: player)
          player.automaticallyWaitsToMinimizeStalling = false
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        self.videoView.width = width
        playerLayer.frame = self.videoView.bounds //bounds of the view in which AVPlayer should be displayed
        
        //playerLayer.frame = CGRect(x: self.videoView.x, y: self.videoView.y - 110.0, width: width, height: self.videoView.height)
           print("Video frame height : \(playerLayer.frame)")
        //   playerLayer.videoGravity = .resizeAspectFill
        playerLayer.videoGravity = .resizeAspect
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
           
//           thumbnailImg.isHidden = true
//           videoView.isHidden = false
           NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
       }
       
       func downloadVideo(item : FeedV2Item) {
           let videoImageUrl = item.videoUrl
           
           DispatchQueue.global(qos: .background).async {
               if let url = URL(string: videoImageUrl), let urlData = NSData(contentsOf: url) {
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
       
       
//       @objc func videoDidPlay(notification: NSNotification) {
//           if spinner.isAnimating {
//               spinner.stopAnimating()
//           }
//           do{
//               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
//               try AVAudioSession.sharedInstance().setActive(true)
//           }catch{
//               //some meaningful exception handling
//               print("Couldn't able to stop the background music playback")
//           }
//        playerView.play(for: URL(string: newVedio!.video)!)
//       }
       
//       @objc func videoDidPause(notification: NSNotification){
//           player.pause()
//           do{
//               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
//               try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
//           }catch{
//               //some meaningful exception handling
//               print("Couldn't start the background play back once when video paused")
//           }
//       }
       
       @objc func videoDidEnd(notification: NSNotification) {
           print("video ended")
           //playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        playerView.seek(to: CMTime.zero)
           //playPauseBtn.tag = 0
        playerView.play(for: URL(string: newVedio!.video)!)
       }
       
       
       
       
       
       @IBAction func playBtnTapped(_ sender: UIButton) {
           if network.reachability.isReachable == true {
               guard let item = newItem else { return }
               updatedDelegate?.didTapVideoViews(item: item, cell: self,videoId: newVedio!.videoId)
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
       
    func play() {
        
        playerView.play(for: URL(string: newVedio!.video)!)
      //  playerView.isHidden = false
    }
    
    func pause() {
        playerView.pause(reason: .hidden)
        self.playButton.isSelected = false
    }
    func resume() {
        playerView.resume()
        self.playButton.isSelected = true
    }
}

//extension LandScapCell: CachingPlayerItemDelegate {
//
//    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
//        print("File is downloaded and ready for storing")
//    }
//
//    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
//        print("\(bytesDownloaded)/\(bytesExpected)")
//    }
//
//    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
//        print("Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
//    }
//
//    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
//        print(error)
//    }
//
//}
