//
//  FeedVideoCell.swift
//  myscrap
//
//  Created by MyScrap on 2/12/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos

class FeedVideoCell: BaseCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var favouriteBtn: FavouriteButton!
    @IBOutlet weak var timeLbl: TimeLabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: DesignationLabel!
    @IBOutlet weak var reportedView: ReportedView!
    @IBOutlet weak var unReportBtn: UnReportBtn!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var muteBtn: UIButton!
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var commentCountBtn: VideoCommentCountBtn!
    @IBOutlet weak var viewCount: ViewCountButton!
    
    @IBOutlet weak var likeImage: LikeImageV2FeedButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var comImgBtn: CommentImageV2Button!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var downloadImgBtn: UIButton!
    @IBOutlet weak var dwnldBtn: UIButton!
    @IBOutlet weak var shareImgBtn: ShareImageV2Button!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var reportImgBtn: ReportImgV2Button!
    @IBOutlet weak var reportBtn: UIButton!
    //@IBOutlet weak var reportBtnWidth: NSLayoutConstraint!
    //@IBOutlet weak var reportBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var reportStackView: UIStackView!
    
    @IBOutlet var feedImagesCollectionViewHeightConstraint : NSLayoutConstraint!

    weak var updatedDelegate : UpdatedFeedsDelegate?
    var feedV2Service : FeedV2Model?
    
    var offlineBtnAction : (() -> Void)? = nil
    var commentBtnAction : (() -> Void)? = nil
    var likeBtnAction : (() -> Void)? = nil
    
    var playBtnAction: (() -> Void)? = nil
    var dwnldBtnAction: (() -> Void)? = nil
    
    var muteBtnAction: (() -> Void)? = nil
    
    var inDetailView = false
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    //var thumbnailImg = UIImageView()
    
    private var cache = URLCache.shared
    
    
    /* API V2.0*/
    var newItem : FeedV2Item? {
        didSet{
            guard let item = newItem else { return }
            configCell(withItem: item)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        setupFriendViewTaps()
        
        player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        if #available(iOS 12.0, *) {
            player.preventsDisplaySleepDuringVideoPlayback = false
        } else {
            // Fallback on earlier versions
        }
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidPlay(notification:)), name: Notification.Name.videoCellPlay, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidPause(notification:)), name: Notification.Name.videoCellPause, object: nil)
        
        //Video view tap for Mute and unmute
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
        videoTap.numberOfTapsRequired = 1
        videoView.isUserInteractionEnabled = true
        videoView.addGestureRecognizer(videoTap)
        
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
    /*
    override func prepareForReuse() {
        super.prepareForReuse()
        player = AVPlayer(playerItem: nil)
        videoView.layer.sublayers?[0].removeFromSuperlayer()
        videoView.setNeedsDisplay()
    }
    */
    
    func configCell(withItem item: FeedV2Item) {
        
        //setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
        thumbnailImg.isHidden = false
        videoView.isHidden = true
        thumbnailImg.contentMode = .scaleAspectFill
        thumbnailImg.clipsToBounds = true
        
        self.thumbnailImg.setImageWithIndicator(imageURL: item.videoThumbnail)
        setupVideoLayer(videoUrl: URL(string: item.videoUrl)!)

        
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
                
                commentCountBtn.viewCount = item.viewsCount
                commentCountBtn.commentCount = item.commentCount
            } else {
                viewCount.isHidden = false
                commentCountBtn.isHidden = false
                viewCount.viewCount = item.viewsCount
                commentCountBtn.viewCount = item.viewsCount
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
            //editButton.isHidden = false
            editButton.setTitle("", for: .normal)
            editButton.setImage(#imageLiteral(resourceName: "arrow-double").withRenderingMode(.alwaysOriginal), for: .normal)
            //editButton.tintColor = UIColor.BLACK_ALPHA
            editButton.isHidden = false
        } else {
            editButton.isHidden = false
            editButton.setTitle("", for: .normal)
            editButton.setImage(#imageLiteral(resourceName: "ellipsis2").withRenderingMode(.alwaysTemplate), for: .normal)
            editButton.tintColor = UIColor.BLACK_ALPHA
        }
        //editButton.isHidden = !(item.postedUserId == AuthService.instance.userId)
        favouriteBtn.isFavourite = item.isPostFavourited
        
        profileTypeView?.checkType = (isAdmin:false,isMod: item.moderator == "1", isNew:item.newJoined, rank:item.rank ,isLevel: item.isLevel, level: item.level)
        
        setupVideoLayer(videoUrl: URL(string: item.videoUrl)!)
        //setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
        
        if item.postedUserId == AuthService.instance.userId {
            reportImgBtn.isHidden = true
            reportBtn.isHidden = true
            reportStackView.isHidden = true
        } else {
            reportImgBtn.isHidden = false
            reportBtn.isHidden = false
            reportStackView.isHidden = false
        }
    }
    @objc func videoViewTapped(tapGesture: UITapGestureRecognizer) {
        muteBtnAction?()
        if inDetailView {
            if network.reachability.isReachable == true {
                guard let item = newItem else { return }
                //In detail view just calling the api
                updatedDelegate?.didTapDetailVideoViews(item: item, cell: self,videoId: "")
            } else {
                offlineBtnAction?()
            }
        } else {
            if network.reachability.isReachable == true {
                guard let item = newItem else { return }
                //Here updating the view count in feeds
                updatedDelegate?.didTapVideoViews(item: item, cell: self,videoId: "")
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
        self.thumbnailImg.sd_setImage(with: videoUrl, completed: nil)
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
        
        
        player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds //bounds of the view in which AVPlayer should be displayed
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
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name:
            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
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
    
    func setupNameLabel(item : FeedV2Item){
        
        //MARK:- Designation Label
        //designationLbl.textColor = UIColor.white
        
        if item.userCompany != "" {
            designationLbl.text = "\(item.postedUserDesignation) • \(item.userCompany)"
        } else {
            designationLbl.text = item.postedUserDesignation
        }
        
        //MARK:- NAME LABEL
        //let attributedString = NSMutableAttributedString(string: item.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.white])
        //nameLbl.attributedText = attributedString
        nameLbl.text = item.postedUserName
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
            updatedDelegate?.didTapVideoViews(item: item, cell: self,videoId: "")
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
                commentBtnAction?()
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
