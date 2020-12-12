//
//  ReportedVideoTextCell.swift
//  myscrap
//
//  Created by MyScrap on 2/22/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos


protocol VideoTextsOnReportPlayerDelegate : class {
    func playReportedTextVedio(url: String)
    func PortraitTextVideoChanged()
}
class ReportedVideoTextCell: BaseCell {
    var visibleCellIndex = IndexPath()

    @IBOutlet weak var videosCountView: UIView!
    @IBOutlet weak var videosCoutLable: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
 @IBOutlet weak var videosCollection: UICollectionView!
    weak var videoPlayerDelegate : VideoTextsOnReportPlayerDelegate?
    @IBOutlet weak var updatedProfileText: UILabel!

    @IBOutlet weak var reportedLbl: UILabel!
    @IBOutlet weak var descriptionText: UserTagTextView!
    @IBOutlet weak var editButton: EditButton!
    @IBOutlet weak var favouriteBtn: FavouriteButton!
    @IBOutlet weak var reportedImage: UIImageView!
    
    @IBOutlet weak var timeLbl: TimeLabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: DesignationLabel!
    @IBOutlet weak var reportedView: ReportedView!
    @IBOutlet weak var unReportBtn: UnReportBtn!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var likeCountBtn: LikeCountButton!
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
    
    var offlineBtnAction : (() -> Void)? = nil
    var commentBtnAction : (() -> Void)? = nil
    var likeBtnAction : (() -> Void)? = nil
    
    var playBtnAction: (() -> Void)? = nil
    
    var inDetailView = false
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    //weak var delegate: FeedsDelegate?
    weak var updatedDelegate : UpdatedFeedsDelegate?
    var feedV2Service : FeedV2Model?
    
    var newItem : FeedV2Item? {
        didSet{
            guard let item = newItem else { return }
            configCell(withItem: item)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.videosCountView.layer.cornerRadius =   self.videosCountView.frame.size.height/2

        if network.reachability.isReachable == true {
            thumbnailImg.contentMode = .scaleAspectFill
            thumbnailImg.clipsToBounds = true
            thumbnailImg.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.numberOfTapsRequired = 1
            thumbnailImg.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
    }
    func UpdateLable()  {
        if let countLable  = self.viewWithTag(1001) as? UILabel {
    countLable.text = "\(Int((self.videosCollection.contentOffset.x / self.videosCollection.contentSize.width) * CGFloat((self.newItem?.videoURL.count ?? 0) as Int))+1)/\(self.newItem!.videoURL.count as Int)"
          
    }
    }
    @objc func pauseVisibleVideos()  {
        
       for videoCell in self.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
    }
    @objc  func playButtonPresssed(sender: UIButton!){
       //...
        let objVide = self.newItem!.videoURL[self.pageController.currentPage]
        videoPlayerDelegate?.playReportedTextVedio(url: objVide.video)
    }
    @objc private func handleTap(_ sender: UITapGestureRecognizer){
        playBtnAction?()
    }
    func refreshTable()  {
          
             self.videosCollection.register(PortraitVideoCell.Nib, forCellWithReuseIdentifier: PortraitVideoCell.identifier)
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
    func configCell(withItem item: FeedV2Item) {
        
        reportedView.isHidden = true
        
        if item.postType == .friendProfilePost {
            updatedProfileText.text = "Updated profile picture."
        }
        else
        {
            updatedProfileText.text = ""
        }
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "Reported By • ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.BLACK_ALPHA, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 11)!]))
        attributedString.append(NSAttributedString(string: item.reportBy, attributes: [NSAttributedString.Key.foregroundColor : UIColor.GREEN_PRIMARY, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 11)!]))
        reportedLbl.attributedText = attributedString
        reportedLbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(reportedByTap(_:)))
        tap.numberOfTapsRequired = 1
        reportedLbl?.addGestureRecognizer(tap)
        
        //MARK:- NAME LABEL
        setupNameLabel(item: item)
        
        profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:true, rank:nil, isLevel: false, level: nil)
        
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
        
        //reportedView.isHidden = !item.isReported
        //unReportBtn.isHidden =  !((item.reportedUserId == AuthService.instance.userId) || item.moderator == "1")
        
        if item.postedUserId != AuthService.instance.userId {
            //editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            //editButton.setTitleColor(.black, for: .normal)
            //editButton.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal)
            //editButton.setImage(UIImage(named: ""), for: .normal)
            //print("I'm here in edit")
            //editButton.isHidden = false
            
            editButton.setTitle("", for: .normal)
            editButton.setImage(#imageLiteral(resourceName: "arrow-double").withRenderingMode(.alwaysTemplate), for: .normal)
            editButton.tintColor = UIColor.BLACK_ALPHA
            print("I'm here in edit")
            editButton.isHidden = false
        } else {
            editButton.isHidden = false
            editButton.setTitle("", for: .normal)
            editButton.setImage(#imageLiteral(resourceName: "ellipsis2").withRenderingMode(.alwaysTemplate), for: .normal)
            editButton.tintColor = UIColor.BLACK_ALPHA
        }
        //editButton.isHidden = !(item.postedUserId == AuthService.instance.userId)
        if let  fav  = item.isPostFavourited as? Bool
        {
            favouriteBtn.isFavourite = fav
        }
   
        
        profileTypeView?.checkType = (isAdmin:false,isMod: item.moderator == "1", isNew:item.newJoined, rank:item.rank, isLevel: item.isLevel, level: item.level)
        descriptionText?.attributedText = item.descriptionStatus
     //   setupThumbnail(videoUrl: URL(string: item.videoThumbnail)!)
    }
    
    func setupThumbnail(videoUrl: URL) {
        
        /*self.getThumbnailImageFromVideoUrl(url: videoUrl) { (thumbImage) in
         self.thumbnailImg.image = thumbImage
         }*/
        //let thumbImage = getThumbnailCache(url: videoUrl)
        //self.thumbnailImg.image = thumbImage
        self.thumbnailImg.sd_setImage(with: videoUrl, completed: nil)
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
    
    @objc func reportedByTap(_ sender: UITapGestureRecognizer){
        guard let item = newItem else { return }
        updatedDelegate?.didTapForFriendView(id: item.reportedUserId)
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
    
    func setupTap(){
        if network.reachability.isReachable == true {
            descriptionText?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(DidTappedTextView(_:)))
            tap.numberOfTapsRequired = 1
            descriptionText?.addGestureRecognizer(tap)
        } else {
            offlineBtnAction?()
        }
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
    
    @IBAction func dwnldBtnTapped(_ sender: UIButton) {
        
    }
    @IBAction func shareBtnTapped(_ sender: UIButton){
        if network.reachability.isReachable == true {
            guard let item = newItem else { return }
            updatedDelegate?.didTapShareVideoV2(sender: sender, item: item)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            guard let item = newItem else { return }
            updatedDelegate?.didTapEditV2(item: item, cell: self)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func unreportBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Unreport ***")
            guard  let newItem = newItem else { return }
            updatedDelegate?.didTapUnReportV2(item: newItem, cell: self)
        } else {
            offlineBtnAction?()
        }
    }
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
        guard  let item = newItem else { return }
        updatedDelegate?.didTapFavouriteV2(item: item, cell: self)
    }
    
    @IBAction func likeImgTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("LIKE ***")
            guard let item = newItem else { return }
            if let del = updatedDelegate {
                print("delegate is there in feed item", del)
            }
            updatedDelegate?.didTapLikeV2(item: item, cell: self)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func likeCountTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Like count")
            guard let item = newItem else { return }
            updatedDelegate?.didTapLikeCountV2(item: item)
        } else {
            offlineBtnAction?()
        }
    }
    
    @IBAction func commentCountTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Comment count ***")
            guard let item = newItem else { return }
            if inDetailView {
                commentBtnAction?()
            } else {
                updatedDelegate?.didTapcommentV2(item: item)
            }
        } else {
            offlineBtnAction?()
        }
    }
    @IBAction func reportBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            print("Report ***")
            /*if sender.tag == 0 {
                guard  let newItem = newItem else { return }
                updatedDelegate?.didTapReportV2(item: newItem, cell: self)
            } else {
                guard  let newItem = newItem else { return }
                updatedDelegate?.didTapReportModV2(item: newItem, cell: self)
                
            }*/
            
            //Unreporting or Deleting the reported content
            guard  let newItem = newItem else { return }
            updatedDelegate?.didTapReportModV2(item: newItem, cell: self)
        } else {
            offlineBtnAction?()
        }
    }

}
extension ReportedVideoTextCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           let muteImg = #imageLiteral(resourceName: "mute-60x60")
           let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           
           let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
           let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
           if let videoCell = cell as? PortraitVideoCell {
            
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
        
        if let videoCell = cell as? PortraitVideoCell {
            var muteVideo : Bool = false
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
            videoCell.pause()
         
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortraitVideoCell.identifier, for: indexPath) as? PortraitVideoCell else { return UICollectionViewCell()}
                      // cell.updatedDelegate = self
             //cell.indexPath = indexPath.row
         //      cell.newItem = self.newItem
        cell.inDetailView = false //inDetailView
        cell.newVedio = self.newItem!.videoURL[indexPath.row]
                       /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                        videoTap.numberOfTapsRequired = 1
                        cell.thumbnailImg.isUserInteractionEnabled = true
                        cell.thumbnailImg.addGestureRecognizer(videoTap)
                        cell.thumbnailImg.tag = indexPath.row*/
                      // self.visibleCellIndex = indexPath
        cell.playBtn.tag = indexPath.row
        cell.playBtn.addTarget(self, action:#selector(self.playButtonPresssed), for: .touchUpInside)
      //  cell.playBtnAction
         
        cell.videoView.isHidden = false
          cell.thumbnailImg.isHidden = true
        
          cell.playBtn.isHidden = true
           cell.layoutIfNeeded()
               cell.layoutSubviews()
        cell.pause()
        cell.updateConstraintsIfNeeded()
        
               return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
   let item =  self.newItem!.videoURL[indexPath.row]
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        
             if   item.videoType == "landscape" {
              //   return CGSize(width:self.videosCollection.frame.size.width, height: 300)
return CGSize(width:screenWidth, height: 250)
             }
        else
             {
                return CGSize(width:screenWidth, height:250)

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
    
        self.pauseVisibleVideos()
        videoPlayerDelegate?.PortraitTextVideoChanged()
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
