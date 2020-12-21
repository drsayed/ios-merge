//
//  WallViewController.swift
//  myscrap
//
//  Created by MyScrap on 11/29/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import Photos
class WallViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var refreshControll : UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    var visibleCellIndex = IndexPath()

    fileprivate let feedService = FeedModel()
    fileprivate let service = ProfileService()
    fileprivate var feedItems = [FeedItem]()
    fileprivate var feedItemsV2 = [FeedV2Item]()
    var friendId : String?
    var notificationId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

     //   NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("VideoPlayedChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("SharedOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("SharedClosed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("PlayUserCurrentVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("DeletedVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("PauseAllVideos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("PauseAllProfileVideos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableScroll), name: Notification.Name("EnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableScroll), name: Notification.Name("DisableScroll"), object: nil)
        
        service.delegate = self
        setupViews()
        collectionView.isScrollEnabled = false
        // Do any additional setup after loading the view.
    }
    @objc
    func enableScroll(){
        collectionView.isScrollEnabled = true
    }
    @objc func disableScroll(){
        collectionView.isScrollEnabled = false
    }
    @objc
    func handleRefresh(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        getProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if feedItemsV2.count == 0 {
            self.activityIndicator.startAnimating()
            getProfile()
        }
       // self.scrollViewDidEndScrolling()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
        NotificationCenter.default.removeObserver(self, name: .videoDownloaded, object: nil)
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        if let portrateCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplPortraitVideoCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                    
                    //cell.player.isMuted = true
                    //if videoCell.player.timeControlStatus == .playing {
                    
                        videoCell.pause()
    //                    videoCell.player.actionAtItemEnd = .pause
    //                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                    //}
                }
            }
      else  if let portrateCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplPortrVideoTextCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                    
                    //cell.player.isMuted = true
                    //if videoCell.player.timeControlStatus == .playing {
                 
                        videoCell.pause()
    //                    videoCell.player.actionAtItemEnd = .pause
    //                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                    //}
                }
            }
      else if let portrateCell = collectionView.cellForItem(at: visibleCellIndex) as? LandScapVideoCell {
           
              for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                  
                  //cell.player.isMuted = true
                  //if videoCell.player.timeControlStatus == .playing {
                     
                      videoCell.pause()
  //                    videoCell.player.actionAtItemEnd = .pause
  //                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                  //}
              }
          }
      else if let portrateCell = collectionView.cellForItem(at: visibleCellIndex) as? LandScapVideoTextCell {
           
              for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                  
                  //cell.player.isMuted = true
                  //if videoCell.player.timeControlStatus == .playing {
                     
                      videoCell.pause()
  //                    videoCell.player.actionAtItemEnd = .pause
  //                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                  //}
              }
          }
        
//            if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplLandscVideoCell {
//                //cell.player.isMuted = true
//                //if videoCell.player.timeControlStatus == .playing {
//                    videoCell.player.isMuted = true
//                    if  videoCell.player.isMuted {
//                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                    } else {
//                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                    }
//                    videoCell.player.pause()
//                    videoCell.player.actionAtItemEnd = .pause
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                //}
//            }
//            if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplPortrVideoTextCell {
//                //cell.player.isMuted = true
//               //if videoCell.player.timeControlStatus == .playing {
//                    videoCell.player.isMuted = true
//                    if  videoCell.player.isMuted {
//                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                    } else {
//                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                    }
//                    videoCell.player.pause()
//                    videoCell.player.actionAtItemEnd = .pause
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                //}
//            }
//            if let videoCell = collectionView.cellForItem(at: visibleCellIndex) as? EmplLandsVideoTextCell {
//                //cell.player.isMuted = true
//                //if videoCell.player.timeControlStatus == .playing {
//                    videoCell.player.isMuted = true
//                    if  videoCell.player.isMuted {
//                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                    } else {
//                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                    }
//                    videoCell.player.pause()
//                    videoCell.player.actionAtItemEnd = .pause
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
//                //}
//            }
//        }
    }
    
    @objc func pauseVisibleVideos()  {
        
        for videoParentCell in collectionView.visibleCells   {
            
                var indexPathNotVisible = collectionView!.indexPath(for: videoParentCell)
            
            if let videoParentwithoutTextCell = videoParentCell as? EmplPortraitVideoCell
            {
                for videoCell in videoParentwithoutTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? EmplPortrVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            if let videoParentTextCell = videoParentCell as? LandScapVideoCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            if let videoParentTextCell = videoParentCell as? LandScapVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            }
        
    }
    func downloadVideo(path : String) {
        self.showMessage(with: "Download begins!")
        let videoImageUrl = path
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let filePath="\(documentsPath)/MSVIDEO.mp4"
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoImageUrl),
                let urlData = NSData(contentsOf: url) {
                
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            
                            DispatchQueue.main.async {
                                //Triggering the videoDownloadNotify method.
                                NotificationCenter.default.post(name: .videoDownloaded, object: nil)
                            }
                        } else {
                            if let dwnldError = error {
                                DispatchQueue.main.async {
                                    print("Download Failed : \(dwnldError.localizedDescription)")
                                    self.showMessage(with: "Failed to download the video")
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func feed_image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    private func getProfile() {
        friendId = UserDefaults.standard.object(forKey: "friendId") as? String
        print("Friend ID in Wall VC : \(String(describing: friendId!))")
        var notId = ""
        if notificationId != ""{
            notId = "&notId=\(notificationId)"
        }
        //service.getFriendProfile(friendId: friendId!, notId: notId)
        service.getFeedsPage(friendId: friendId!)
    }
    
    private func setupViews(){
        //collectionView.register(UserProfileCell.Nib, forCellWithReuseIdentifier: UserProfileCell.identifier)
        //collectionView.register(FeedNewUserCell.Nib, forCellWithReuseIdentifier: FeedNewUserCell.identifier)
        collectionView.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        collectionView.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        collectionView.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmplPortrVideoTextCell.Nib, forCellWithReuseIdentifier: EmplPortrVideoTextCell.identifier)

        collectionView.register(EmplPortraitVideoCell.Nib, forCellWithReuseIdentifier: EmplPortraitVideoCell.identifier)
              collectionView.register(LandScapVideoTextCell.Nib, forCellWithReuseIdentifier: LandScapVideoTextCell.identifier)
              collectionView.register(LandScapVideoCell.Nib, forCellWithReuseIdentifier: LandScapVideoCell.identifier)
              collectionView.register(EmplLandsVideoTextCell.Nib, forCellWithReuseIdentifier: EmplLandsVideoTextCell.identifier)
              collectionView.register(AdvertismentCell.Nib, forCellWithReuseIdentifier: AdvertismentCell.identifier)
              collectionView.register(MarketScrollCell.Nib, forCellWithReuseIdentifier: MarketScrollCell.identifier)
              collectionView.register(NewUserScrollCell.Nib, forCellWithReuseIdentifier: NewUserScrollCell.identifier)
              collectionView.register(NewsScrollCell.Nib, forCellWithReuseIdentifier: NewsScrollCell.identifier)
              collectionView.register(CompanyOfMonthCell.Nib, forCellWithReuseIdentifier: CompanyOfMonthCell.identifier)
              collectionView.register(PersonOfWeek.Nib, forCellWithReuseIdentifier: PersonOfWeek.identifier)
              collectionView.register(PersonWeekScrollCell.Nib, forCellWithReuseIdentifier: PersonWeekScrollCell.identifier)
              collectionView.register(VotingScrollCell.Nib, forCellWithReuseIdentifier: VotingScrollCell.identifier)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WallViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        if let portrateCell = cell as? EmplPortraitVideoCell {
         
            for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
              
            //cell.player.isMuted = true
            //if videoCell.player.timeControlStatus == .playing {
                videoCell.playerView.isMuted = true
                if  videoCell.player.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoCell.pause()
//                videoCell.player.actionAtItemEnd = .pause
//                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
          }
        }
        else if let portrateCell = cell as? EmplPortrVideoTextCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                  
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                    videoCell.playerView.isMuted = true
                    if  videoCell.player.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    videoCell.pause()
    //                videoCell.player.actionAtItemEnd = .pause
    //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                //}
            }
        }
        else if let portrateCell = cell as? LandScapVideoCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                  
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                    videoCell.playerView.isMuted = true
                    if  videoCell.player.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    videoCell.pause()
    //                videoCell.player.actionAtItemEnd = .pause
    //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                //}
            }
        }
            else if let portrateCell = cell as? LandScapVideoTextCell {
                 
                    for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                      
                    //cell.player.isMuted = true
                    //if videoCell.player.timeControlStatus == .playing {
                        videoCell.playerView.isMuted = true
                        if  videoCell.player.isMuted {
                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                        } else {
                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                        }
                        videoCell.pause()
        //                videoCell.player.actionAtItemEnd = .pause
        //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                    //}
                }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            //let visibleCell = collectionView.dequeReusableCell(forIndexPath: indexPath) as?  FeedVideoTextCell
                //NotificationCenter.default.post(name:.videoCellPlay, object: nil)
                let muteImg = #imageLiteral(resourceName: "mute-60x60")
                let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
                let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                
                if let portrateCell = cell as? EmplPortraitVideoCell {
                 
                    for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                          
                        //cell.player.isMuted = true
                        //if videoCell.player.timeControlStatus == .playing {
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
                        let item = feedItemsV2[indexPath.item]
                        if item.isReported {
                            videoCell.pause()
                        }
                        else
                        {
                            videoCell.resume()
                        }
                        //}
                    }
                }
                else if let portrateCell = cell as? EmplPortrVideoTextCell {
                     
                        for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                            
                            //cell.player.isMuted = true
                            //if videoCell.player.timeControlStatus == .playing {
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
                            let item = feedItemsV2[indexPath.item]
                            if item.isReported {
                                videoCell.pause()
                            }
                            else
                            {
                                videoCell.resume()
                            }                            //}
                        }
                    }
                else if let portrateCell = cell as? LandScapVideoCell {
                     
                        for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                            
                            //cell.player.isMuted = true
                            //if videoCell.player.timeControlStatus == .playing {
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
                            let item = feedItemsV2[indexPath.item]
                            if item.isReported {
                                videoCell.pause()
                            }
                            else
                            {
                                videoCell.resume()
                            }                            //}
                        }
                    }
                else if let portrateCell = cell as? LandScapVideoTextCell {
                     
                        for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                            
                            //cell.player.isMuted = true
                            //if videoCell.player.timeControlStatus == .playing {
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
                            let item = feedItemsV2[indexPath.item]
                            if item.isReported {
                                videoCell.pause()
                            }
                            else
                            {
                                videoCell.resume()
                            }                            //}
                        }
                    }
            cell.layoutSubviews()
            cell.layoutIfNeeded()
     
            
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data  = feedItemsV2[indexPath.item]
        switch data.cellType{
            /*case .feedNewUserCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedNewUserCell.identifier, for: indexPath) as? FeedNewUserCell else { return UICollectionViewCell()}
                cell.delegate = self
                cell.item = data
                print("Cell item in wall : \(cell.item)")
                return cell*/
            case .feedTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTextCell.identifier, for: indexPath) as? FeedTextCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.editButton.isHidden = true
             /*   if data.rank == "MOD" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.MOD_COLOR
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "NEW" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.NEW_COLOR
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "ADMIN" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "NoRank"{
                    //cell.profileTypeView.label.text = "NoRank"
                    //cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    //cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = true
                }
                else {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = false
                }*/
                return cell
            case .feedImageCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.refreshImagesCollection()
                cell.editButton.isHidden = true
               /* if data.rank == "MOD" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.MOD_COLOR
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "NEW" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.NEW_COLOR
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "ADMIN" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "NoRank"{
                    //cell.profileTypeView.label.text = "NoRank"
                    //cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    //cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = true
                }
                else {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = false
                }*/
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    for imageCell in cell.feedImages.visibleCells   {
                       let image = imageCell as! CompanyImageslCell
                        UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                        cell.dwnldBtn.isEnabled = true
                        }
                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                return cell
            case .feedImageTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageTextCell.identifier, for: indexPath) as? FeedImageTextCell else { return UICollectionViewCell()}
                cell.updatedDelegate = self
                cell.newItem = data
                cell.refreshImagesCollection()
                cell.editButton.isHidden = true
                cell.dwnldBtnAction = {
                    cell.dwnldBtn.isEnabled = false
                    for imageCell in cell.feedImages.visibleCells   {
                       let image = imageCell as! CompanyImageslCell
                        UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                        cell.dwnldBtn.isEnabled = true
                        }
                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
               /* if data.rank == "MOD" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.MOD_COLOR
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "NEW" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.NEW_COLOR
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "ADMIN" {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = false
                } else if data.rank == "NoRank"{
                    //cell.profileTypeView.label.text = "NoRank"
                    //cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    //cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = true
                }
                else {
                    cell.profileTypeView.label.text = data.rank
                    cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                    cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                    cell.profileTypeView.isHidden = false
                }*/
                return cell
            case .feedPortrVideoCell:
                           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortraitVideoCell.identifier, for: indexPath) as? EmplPortraitVideoCell else { return UICollectionViewCell()}
                           cell.updatedDelegate = self
                           cell.newItem = data
                          self.visibleCellIndex = indexPath
                cell.delegateVideoChange = self
                cell.editButton.isHidden = true
                           cell.refreshTable()
                cell.dwnldBtnAction = {
        cell.dwnldBtn.isEnabled = false
       for imageCell in cell.videosCollection.visibleCells   {
          let videoCell = imageCell as! PortraitVideoCell
           self.downloadVideo(path: videoCell.newVedio!.video)
           cell.dwnldBtn.isEnabled = true
           }
     
    }
                           /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                            videoTap.numberOfTapsRequired = 1
                            cell.thumbnailImg.isUserInteractionEnabled = true
                            cell.thumbnailImg.addGestureRecognizer(videoTap)
                            cell.thumbnailImg.tag = indexPath.row*/
                       //    self.visibleCellIndex = indexPath
                           //cell.player.isMuted = muteVideo
//                           cell.muteBtnAction = {
//                               self.index = indexPath
//                               self.updateMuteBtn()
//                           }
//                           cell.playBtnAction = {
//                               let urlString = data.videoUrl
//                               let videoURL = URL(string: urlString)
//                               let player = AVPlayer(url: videoURL!)
//                               let playerViewController = AVPlayerViewController()
//                               playerViewController.player = player
//                               self.present(playerViewController, animated: true) {
//                                   playerViewController.player!.play()
//                               }
//                           }
     
//                           cell.offlineBtnAction = {
//                               self.showToast(message: "No internet connection")
//                           }
                           return cell
                       case .feedLandsVideoCell:
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandScapVideoCell.identifier, for: indexPath) as? LandScapVideoCell else { return UICollectionViewCell()}
                        cell.updatedDelegate = self
                        cell.newItem = data
                        cell.delegateVideoChange = self
                        cell.editButton.isHidden = true
                        cell.refreshTable()
                        /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                         videoTap.numberOfTapsRequired = 1
                         cell.thumbnailImg.isUserInteractionEnabled = true
                         cell.thumbnailImg.addGestureRecognizer(videoTap)
                         cell.thumbnailImg.tag = indexPath.row*/
                        self.visibleCellIndex = indexPath
                        //cell.player.isMuted = muteVideo
                        cell.muteBtnAction = {
//                            self.index = indexPath
//                            self.updateMuteBtn()
                        }
                        cell.playBtnAction = {
                            let urlString = data.videoUrl
                            let videoURL = URL(string: urlString)
                            let player = AVPlayer(url: videoURL!)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            self.present(playerViewController, animated: true) {
                                playerViewController.player!.play()
                            }
                        }
                        cell.dwnldBtnAction = {
                            cell.dwnldBtn.isEnabled = false
                           for imageCell in cell.videosCollection.visibleCells   {
                              let videoCell = imageCell as! LandScapCell
                               self.downloadVideo(path: videoCell.newVedio!.video)
                               cell.dwnldBtn.isEnabled = true
                               cell.dwnldBtn.isEnabled = true
                               }
                         
                        }
                        cell.offlineBtnAction = {
                            self.showToast(message: "No internet connection")
                        }
                          cell.layoutIfNeeded()
                        return cell
                       case .feedPortrVideoTextCell:
                           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortrVideoTextCell.identifier, for: indexPath) as? EmplPortrVideoTextCell else { return UICollectionViewCell()}
                           cell.updatedDelegate = self
                        cell.delegateVideoChange = self
                           cell.newItem = data
                        cell.editButton.isHidden = true
                        self.visibleCellIndex = indexPath

                           cell.refreshTable()
                        cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
               for imageCell in cell.videosCollection.visibleCells   {
                  let videoCell = imageCell as! PortraitVideoCell
                   self.downloadVideo(path: videoCell.newVedio!.video)
                   cell.dwnldBtn.isEnabled = true
                   }
             
            }
                           /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                            videoTap.numberOfTapsRequired = 1
                            cell.thumbnailImg.isUserInteractionEnabled = true
                            cell.thumbnailImg.addGestureRecognizer(videoTap)
                            cell.thumbnailImg.tag = indexPath.row*/
//                           self.visibleCellIndex = indexPath
//                           //cell.player.isMuted = muteVideo
//                           cell.muteBtnAction = {
//                               self.index = indexPath
//                               self.updateMuteBtn()
//                           }
//                           cell.playBtnAction = {
//                               let urlString = data.videoUrl
//                               let videoURL = URL(string: urlString)
//                               let player = AVPlayer(url: videoURL!)
//                               let playerViewController = AVPlayerViewController()
//                               playerViewController.player = player
//                               self.present(playerViewController, animated: true) {
//                                   playerViewController.player!.play()
//                               }
//                           }
//                           cell.dwnldBtnAction = {
//                               cell.dwnldBtn.isEnabled = false
//                               self.downloadVideo(path: data.downloadVideoUrl)
//                               cell.dwnldBtn.isEnabled = true
//                           }
//                           cell.offlineBtnAction = {
//                               self.showToast(message: "No internet connection")
//                           }
                           return cell
                       case .feedLandsVideoTextCell:
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandScapVideoTextCell.identifier, for: indexPath) as? LandScapVideoTextCell else { return UICollectionViewCell()}
                        cell.updatedDelegate = self
                        cell.newItem = data
                        cell.editButton.isHidden = true
                        cell.delegateVideoChange = self
                        cell.refreshTable()

                      
                        /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                         videoTap.numberOfTapsRequired = 1
                         cell.thumbnailImg.isUserInteractionEnabled = true
                         cell.thumbnailImg.addGestureRecognizer(videoTap)
                         cell.thumbnailImg.tag = indexPath.row*/
                        self.visibleCellIndex = indexPath
                        //cell.player.isMuted = muteVideo
                        cell.muteBtnAction = {
//                            self.index = indexPath
//                            self.updateMuteBtn()
                        }
                        cell.playBtnAction = {
                            let urlString = data.videoUrl
                            let videoURL = URL(string: urlString)
                            let player = AVPlayer(url: videoURL!)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            self.present(playerViewController, animated: true) {
                                playerViewController.player!.play()
                            }
                        }
                        cell.dwnldBtnAction = {
                            cell.dwnldBtn.isEnabled = false
                           for imageCell in cell.videosCollection.visibleCells   {
                              let videoCell = imageCell as! LandScapCell
                               self.downloadVideo(path: videoCell.newVedio!.video)
                               cell.dwnldBtn.isEnabled = true
                               }
                         
                        }
                        cell.offlineBtnAction = {
                            self.showToast(message: "No internet connection")
                        }
                        cell.layoutSubviews()
                           cell.layoutIfNeeded()
                        return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Items in section : \(feedItemsV2.count)")
        return feedItemsV2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.textLbl.text = "No Social Activity"
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        return cell
    }
    
}

extension WallViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         let item = feedItemsV2[indexPath.item]
         let width = view.frame.width
         switch item.cellType{
         case .feedImageCell:
            var height = FeedsHeight.heightForImageCellV2(item: item, width: width)
             if item.likeCount == 0 && item.commentCount == 0 &&  item.viewsCount == 0 {
                height =  height + 20
            }
            return CGSize(width: width, height: height)
         case .feedImageTextCell:
            var height = FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
            if item.likeCount == 0 && item.commentCount == 0 &&  item.viewsCount == 0 {
               height =  height + 20
           }
            return CGSize(width: width, height: height)
            case .feedPortrVideoCell:
                        let   height = FeedsHeight.heightForPortraitVideoCellV2(item: item, width: width)
                           return CGSize(width: width, height: height )
                       case .feedLandsVideoCell:
                          let height = FeedsHeight.heightForLandsVideoCellV2(item: item, width: width)
                           return CGSize(width: width, height: height )
                       case .feedPortrVideoTextCell:
                          let height = FeedsHeight.heightForPortraitVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                           print("Video Cell height : \(height)")
                           return CGSize(width: width, height: height )    //height + 30
                       case .feedLandsVideoTextCell:
                       let    height = FeedsHeight.heightForLandsVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                           print("Video Cell height : \(height)")
                           return CGSize(width: width, height: height )    //height + 30
         default:
            let height = FeedsHeight.heightforFeedTextCellV2(item: item , labelWidth: width - 16)
            return CGSize(width: width , height: height)
         
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
     if section == 1 && feedItemsV2.count == 0 {
     return CGSize(width: self.view.frame.width, height: view.frame.height - 300)
     }
     return CGSize.zero
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func pauseAllVideos(indexPath : IndexPath)  {
        
        for videoParentCell in collectionView.visibleCells   {
            
                var indexPathNotVisible = collectionView!.indexPath(for: videoParentCell)
            if indexPath != indexPathNotVisible {
            
            if let videoParentwithoutTextCell = videoParentCell as? EmplPortraitVideoCell
            {
                for videoCell in videoParentwithoutTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? EmplPortrVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
                if let videoParentTextCell = videoParentCell as? LandScapVideoCell
                {
                    for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                        print("You can stop play the video from here")
                            videoCell.pause()
                        

                    }
                }
                if let videoParentTextCell = videoParentCell as? LandScapVideoTextCell
                {
                    for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                        print("You can stop play the video from here")
                            videoCell.pause()
                        

                    }
                }
            }
        }
    }
    @objc func scrollViewDidEndScrolling() {
        
        let centerPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        let collectionViewCenterPoint = self.view.convert(centerPoint, to: collectionView)

   let muteImg = #imageLiteral(resourceName: "mute-60x60")
   let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
   
   let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
   let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
var muteVideo : Bool = false
   
        if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
            self.pauseAllVideos(indexPath: indexPath)
            if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? EmplPortraitVideoCell
            {
                
                let data  = feedItemsV2[indexPath.item]

               for videoCell in collectionViewCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
               
              //  videoCell.backgroundColor = .red

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
                if data.isReported {
                    videoCell.pause()
                }
                else
                {
                    videoCell.resume()
                   
                }
                      
                self.pauseAllVideos(indexPath: indexPath)
               }
                collectionViewCell.UpdateLable()

            }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell
          {
             for videoCell in collectionViewCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
              //  videoCell.backgroundColor = .red
                let data  = feedItemsV2[indexPath.item]
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

                if data.isReported {
                    videoCell.pause()
                }
                else
                {
                    videoCell.resume()
                    
                }
                self.pauseAllVideos(indexPath: indexPath)
             }
            collectionViewCell.UpdateLable()

          }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? LandScapVideoCell
          {
             for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
              //  videoCell.backgroundColor = .red
                let data  = feedItemsV2[indexPath.item]
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

                if data.isReported {
                    videoCell.pause()
                }
                else
                {
                    videoCell.resume()
                    
                }
                self.pauseAllVideos(indexPath: indexPath)
             }
            collectionViewCell.UpdateLable()

          }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? LandScapVideoTextCell
          {
             for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
              //  videoCell.backgroundColor = .red
                let data  = feedItemsV2[indexPath.item]
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

                if data.isReported {
                    videoCell.pause()
                }
                else
                {
                    videoCell.resume()
                    
                }
                self.pauseAllVideos(indexPath: indexPath)
             }
            collectionViewCell.UpdateLable()

          }
   }
        else
        {
            self.pauseVisibleVideos()
        }
}
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            //let screenSize = UIScreen.main.bounds
            if scrollView.contentOffset.y <= 2 {
                self.collectionView.isScrollEnabled = false
            }
        else
            {
                self.collectionView.isScrollEnabled = true
            }
            
        }else{
           
            // Dragging up
        }
        self.scrollViewDidEndScrolling()
      
    }
//
//
//
//
//        var visibleRect = CGRect()
//                visibleRect.origin = scrollView.contentOffset
//                visibleRect.size = scrollView.bounds.size
//
//
//                let muteImg = #imageLiteral(resourceName: "mute-60x60")
//                let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//
//                let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
//                let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//                //print("minY : \(visibleRect.minY) \nmidY : \(visibleRect.midY) \nmaxY : \(visibleRect.maxY)")
//
//                let cgPoint = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.maxY)
//
//
//                guard let indexPath = collectionView.indexPathForItem(at: cgPoint) else { return}
//                //let storedIndexPath = self.visibleCellIndex
//                let visibleCellIndexPath = self.collectionView.indexPathsForVisibleItems
//                var centerIndexPath = IndexPath(row: NSNotFound, section: NSNotFound)
//                //let centerPoint   = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.minY)
//                //guard let centerIndexPath: IndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
//                for allIndex in visibleCellIndexPath {
//                    if visibleCellIndexPath.count == 0 {
//                        centerIndexPath = IndexPath(row: feedItemsV2.count - 1, section: 1)
//                    } else {
//                        centerIndexPath = allIndex
//                    }
//                    print("Visible index path :\(centerIndexPath)")
//                }
//
//
//                print("Get Center IndexPath : \(centerIndexPath) \nCurrent IndexPath :\(indexPath)")
//        if centerIndexPath < indexPath {
//            //I can get the previous cell now
//
//            if let portrateCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplPortraitVideoCell {
//                //previous cell is video
//                var cellVisibRect = portrateCell.frame
//                cellVisibRect.size = portrateCell.bounds.size
//
//                let cellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Lands Text: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 300
//
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                let screenSize = UIScreen.main.bounds
//                let screenHeight = screenSize.height
//                for videoCell in portrateCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
//
//
//                if y <= 300 || y > maxY { //For landscape ==> 3
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = true
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//
//                        videoCell.player.pause()
//                    }
//                } else if y > 300 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
////                        let timeScale = CMTimeScale(NSEC_PER_SEC)
////                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                         videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                         let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                         let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                         let secs = Int(duration - currentTime)
//                         videoCell.playBackTimeLbl.isHidden = false
//                         videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                         /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                         videoCell.playBackTimeLbl.isHidden = true
//                         if let timeObserverToken = videoCell.timeObserverToken {
//                         videoCell.player.removeTimeObserver(timeObserverToken)
//                         videoCell.timeObserverToken = nil
//                         }
//                         }*/
//                         }
//                         }*/
//
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            }
//          else if let portrateCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplPortrVideoTextCell {
//                //previous cell is video
//                var cellVisibRect = portrateCell.frame
//                cellVisibRect.size = portrateCell.bounds.size
//
//                let cellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Lands Text: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 300
//
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                let screenSize = UIScreen.main.bounds
//                let screenHeight = screenSize.height
//                for videoCell in portrateCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
//
//
//                if y <= 300 || y > maxY { //For landscape ==> 3
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = true
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//
//                        videoCell.player.pause()
//                    }
//                } else if y > 300 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
////                        let timeScale = CMTimeScale(NSEC_PER_SEC)
////                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                         videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                         let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                         let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                         let secs = Int(duration - currentTime)
//                         videoCell.playBackTimeLbl.isHidden = false
//                         videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                         /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                         videoCell.playBackTimeLbl.isHidden = true
//                         if let timeObserverToken = videoCell.timeObserverToken {
//                         videoCell.player.removeTimeObserver(timeObserverToken)
//                         videoCell.timeObserverToken = nil
//                         }
//                         }*/
//                         }
//                         }*/
//
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            }
//        }
//        else {
//            if let portrateCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplPortraitVideoCell {
//                //previous cell is video
//                var cellVisibRect = portrateCell.frame
//                cellVisibRect.size = portrateCell.bounds.size
//
//                let cellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Lands Text: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 150
//
//                for videoCell in portrateCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
//
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                if y <= 800 { //For landscape ==> 3
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//                        videoCell.player.isMuted = true
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                        videoCell.player.pause()
//
//                    }
//                } else if y > 800 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
////                        let timeScale = CMTimeScale(NSEC_PER_SEC)
////                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                         videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                         let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                         let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                         let secs = Int(duration - currentTime)
//                         videoCell.playBackTimeLbl.isHidden = false
//                         videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                         /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                         videoCell.playBackTimeLbl.isHidden = true
//                         if let timeObserverToken = videoCell.timeObserverToken {
//                         videoCell.player.removeTimeObserver(timeObserverToken)
//                         videoCell.timeObserverToken = nil
//                         }
//                         }*/
//                         }
//                         }*/
//
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            }
//            else if let portrateCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplPortrVideoTextCell {
//                //previous cell is video
//                var cellVisibRect = portrateCell.frame
//                cellVisibRect.size = portrateCell.bounds.size
//
//                let cellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: portrateCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Portrait text video: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 150
//
//                for videoCell in portrateCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                if y >= 1150 { //<=
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
////                        if muteValue == "1"
////                        {
////                            videoCell.player.isMuted = false
////                        }
////                         else
////                        {
////                            videoCell.player.isMuted = true
////                        }
//                        videoCell.player.isMuted = true
//
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                        videoCell.player.pause()
//
//                    }
//                } else if y < 1150 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
//                        if muteValue == "1"
//                        {
//                            videoCell.player.isMuted = false
//                        }
//                         else
//                        {
//                            videoCell.player.isMuted = true
//                        }
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
////                        let timeScale = CMTimeScale(NSEC_PER_SEC)
////                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                         videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                         let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                         let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//                         print("Duration : \(duration)")
//                         let secs = Int(duration - currentTime)
//                         videoCell.playBackTimeLbl.isHidden = false
//                         videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                         /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                         videoCell.playBackTimeLbl.isHidden = true
//                         if let timeObserverToken = videoCell.timeObserverToken {
//                         videoCell.player.removeTimeObserver(timeObserverToken)
//                         videoCell.timeObserverToken = nil
//                         }
//                         }*/
//                         }
//                         }*/
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            }
//        }
//
//
//        /*
//
//        //While scrolling the collection this function will triggered
//
//        var visibleRect = CGRect()
//        visibleRect.origin = scrollView.contentOffset
//        visibleRect.size = scrollView.bounds.size
//
//
//        let muteImg = #imageLiteral(resourceName: "mute-60x60")
//        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//
//        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
//        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        //print("minY : \(visibleRect.minY) \nmidY : \(visibleRect.midY) \nmaxY : \(visibleRect.maxY)")
//
//        let cgPoint = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.maxY)
//
//
//        guard let indexPath = collectionView.indexPathForItem(at: cgPoint) else { return}
//        //let storedIndexPath = self.visibleCellIndex
//        let visibleCellIndexPath = self.collectionView.indexPathsForVisibleItems
//        var centerIndexPath = IndexPath(row: NSNotFound, section: NSNotFound)
//        //let centerPoint   = CGPoint(x: scrollView.bounds.origin.x, y: visibleRect.minY)
//        //guard let centerIndexPath: IndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
//        for allIndex in visibleCellIndexPath {
//            if visibleCellIndexPath.count == 0 {
//                centerIndexPath = IndexPath(row: feedDatasource.count - 1, section: 1)
//            } else {
//                centerIndexPath = allIndex
//            }
//            print("Visible index path :\(centerIndexPath)")
//        }
//
//
//        print("Get Center IndexPath : \(centerIndexPath) \nCurrent IndexPath :\(indexPath)")
//        if centerIndexPath < indexPath {
//            //I can get the previous cell now
//            if let videoCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplLandsVideoTextCell {
//                //previous cell is video
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Previous Y of Cell is Lands Text: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 150
//
//
////                if y >= -150 &&  y <= 150{
////                    print("You can stop playing the video from here")
////                }
//                if y <= 150 { //<=
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//
//                        videoCell.player.actionAtItemEnd = .pause
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                        videoCell.player.pause()
//
//                    }
//                } else if y > 150 {
//                    print("Reverse scroll you can play")
//                    if videoCell.player.timeControlStatus == .paused {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//
//
//                            videoCell.player.actionAtItemEnd = .none
//                            NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                }
//            }
//            else if let videoCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplPortrVideoTextCell {
//                            //previous cell is video
//                            var cellVisibRect = videoCell.frame
//                            cellVisibRect.size = videoCell.bounds.size
//
//                            let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY) //maxY
//                            let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                            let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                            let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                            print("Previous Y of Cell is Portrait text video: \(rectCell.y)")
//                            //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                            let y = rectCell.y
//                            let maxY = y + 150
//
//
//            //                if y >= -150 &&  y <= 150{
//            //                    print("You can stop playing the video from here")
//            //                }
//                            if y <= 150 { //<=
//                                print("You can stop play the video from here")
//                                if videoCell.player.timeControlStatus == .playing {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    videoCell.player.actionAtItemEnd = .pause
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                                    videoCell.player.pause()
//
//                                }
//                            } else if y > 150 {
//                                print("Reverse scroll you can play")
//                                if videoCell.player.timeControlStatus == .paused {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    let timeScale = CMTimeScale(NSEC_PER_SEC)
//                                    let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                                    /*if videoCell.player.currentItem?.status == .readyToPlay {
//                                        videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                            let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                            let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//                                            print("Duration : \(duration)")
//                                            let secs = Int(duration - currentTime)
//                                            videoCell.playBackTimeLbl.isHidden = false
//                                            videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                                videoCell.playBackTimeLbl.isHidden = true
//                                                if let timeObserverToken = videoCell.timeObserverToken {
//                                                    videoCell.player.removeTimeObserver(timeObserverToken)
//                                                    videoCell.timeObserverToken = nil
//                                                }
//                                            }*/
//                                        }
//                                    }*/
//
//
//
//                                    videoCell.player.actionAtItemEnd = .none
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                                    videoCell.player.play()
//                                }
//                            }
//                        }
//            else if let videoCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplLandscVideoCell {
//                            //previous cell is video
//                            var cellVisibRect = videoCell.frame
//                            cellVisibRect.size = videoCell.bounds.size
//
//                            let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY) //maxY
//                            let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                            let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                            let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                            print("Previous Y of Cell is Landscape video: \(rectCell.y)")
//                            //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                            let y = rectCell.y
//                            let maxY = y + 150
//
//
//            //                if y >= -150 &&  y <= 150{
//            //                    print("You can stop playing the video from here")
//            //                }
//                            if y <= 150 { //<=
//                                print("You can stop play the video from here")
//                                if videoCell.player.timeControlStatus == .playing {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    videoCell.player.actionAtItemEnd = .pause
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                                    videoCell.player.pause()
//
//                                }
//                            } else if y > 150 {
//                                print("Reverse scroll you can play")
//                                if videoCell.player.timeControlStatus == .paused {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    let timeScale = CMTimeScale(NSEC_PER_SEC)
//                                    let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                                    /*if videoCell.player.currentItem?.status == .readyToPlay {
//                                        videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                            let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                            let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//                                            print("Duration : \(duration)")
//                                            let secs = Int(duration - currentTime)
//                                            videoCell.playBackTimeLbl.isHidden = false
//                                            videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                                videoCell.playBackTimeLbl.isHidden = true
//                                                if let timeObserverToken = videoCell.timeObserverToken {
//                                                    videoCell.player.removeTimeObserver(timeObserverToken)
//                                                    videoCell.timeObserverToken = nil
//                                                }
//                                            }*/
//                                        }
//                                    }*/
//
//
//
//                                    videoCell.player.actionAtItemEnd = .none
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                                    videoCell.player.play()
//                                }
//                            }
//                        }
//            else if let videoCell = self.collectionView.cellForItem(at: centerIndexPath) as? EmplPortraitVideoCell {
//                            //previous cell is video
//                            var cellVisibRect = videoCell.frame
//                            cellVisibRect.size = videoCell.bounds.size
//
//                            let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY) //maxY
//                            let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                            let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                            let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                            print("Previous Y of Cell is Portrait video: \(rectCell.y)")
//                            //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                            let y = rectCell.y
//                            let maxY = y + 150
//
//
//            //                if y >= -150 &&  y <= 150{
//            //                    print("You can stop playing the video from here")
//            //                }
//                            if y <= 150 { //<=
//                                print("You can stop play the video from here")
//                                if videoCell.player.timeControlStatus == .playing {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    videoCell.player.actionAtItemEnd = .pause
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(notification:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player)
//                                    videoCell.player.pause()
//
//                                }
//                            } else if y > 150 {
//                                print("Reverse scroll you can play")
//                                if videoCell.player.timeControlStatus == .paused {
//                                    videoCell.player.isMuted = muteVideo
//                                    if  videoCell.player.isMuted {
//                                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                                    } else {
//                                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                                    }
//                                    let timeScale = CMTimeScale(NSEC_PER_SEC)
//                                    let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                                    /*if videoCell.player.currentItem?.status == .readyToPlay {
//                                        videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                            let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                            let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//                                            print("Duration : \(duration)")
//                                            let secs = Int(duration - currentTime)
//                                            videoCell.playBackTimeLbl.isHidden = false
//                                            videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                                videoCell.playBackTimeLbl.isHidden = true
//                                                if let timeObserverToken = videoCell.timeObserverToken {
//                                                    videoCell.player.removeTimeObserver(timeObserverToken)
//                                                    videoCell.timeObserverToken = nil
//                                                }
//                                            }*/
//                                        }
//                                    }*/
//
//
//
//                                    videoCell.player.actionAtItemEnd = .none
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                                    NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                                    videoCell.player.play()
//                                }
//                            }
//                        }
//                //Checking for next cell also contains video
//            else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandsVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let y = rectCell.y
//                print("Next cell Land text video Y postion is : \(y)")
//            } else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let y = rectCell.y
//                print("Next cell Portr text video Y postion is : \(y)")
//            }  else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplPortraitVideoCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let y = rectCell.y
//                print("Next cell portr video Y postion is : \(y)")
//            } else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandscVideoCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY) //maxY
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let y = rectCell.y
//                print("Next cell lands video Y postion is : \(y)")
//            }
//
//        } /*else if centerIndexPath == indexPath{
//            if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandsVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Y of Cell is Lands Text: \(rectCell.y)")
//                //print("max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y - 150
//
//
//                /*if y >= -150 &&  y <= 150{
//                    print("You can start play the video from here")
//                }*/
//                if y <= 400 { //y <= 150 edited : 05:20 PM Apr 29th 20'20
//                    print("You can start play the video from here")
//                    if videoCell.player.rate >= 0 {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//                        videoCell.player.play()
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                } else if y > 400 {
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                    }
//                }
//            }
//            else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Y of Cell is Portrait text: \(rectCell.y)")
//                //print("max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y - 150
//
//
//                /*if y >= -150 &&  y <= 150{
//                    print("You can start play the video from here")
//                }*/
//                if y <= 400 { //y <= 150 edited : 05:20 PM Apr 29th 20'20
//                    print("You can start play the video from here")
//                    if videoCell.player.rate >= 0 {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                } else if y > 400 {
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                    }
//                }
//            }
//            else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandscVideoCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Y of Cell is Land: \(rectCell.y)")
//                //print("max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y - 150
//
//
//                /*if y >= -150 &&  y <= 150{
//                    print("You can start play the video from here")
//                }*/
//                if y <= 400 { //y <= 150 edited : 05:20 PM Apr 29th 20'20
//                    print("You can start play the video from here")
//                    if videoCell.player.rate >= 0 {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                } else if y > 400 {
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                    }
//                }
//            }
//            else if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplPortraitVideoCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.minY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//                let maxCellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let maxRectCell = collectionView.convert(maxCellCG, to: collectionView.superview)
//
//                print("Y of Cell is Portrait: \(rectCell.y)")
//                //print("max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y - 150
//
//
//                /*if y >= -150 &&  y <= 150{
//                    print("You can start play the video from here")
//                }*/
//                if y <= 400 { //y <= 150 edited : 05:20 PM Apr 29th 20'20
//                    print("You can start play the video from here")
//                    if videoCell.player.rate >= 0 {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        let timeScale = CMTimeScale(NSEC_PER_SEC)
//                        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//                        /*if videoCell.player.currentItem?.status == .readyToPlay {
//                            videoCell.timeObserverToken = videoCell.player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//                                let currentTime = CMTimeGetSeconds(videoCell.player.currentTime())
//
//                                let duration = CMTimeGetSeconds((videoCell.player.currentItem?.asset.duration)!)
//
//                                let secs = Int(duration - currentTime)
//                                videoCell.playBackTimeLbl.isHidden = false
//                                videoCell.playBackTimeLbl.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String//"\(secs/60):\(secs%60)"
//                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                    videoCell.playBackTimeLbl.isHidden = true
//                                    if let timeObserverToken = videoCell.timeObserverToken {
//                                        videoCell.player.removeTimeObserver(timeObserverToken)
//                                        videoCell.timeObserverToken = nil
//                                    }
//                                }*/
//                            }
//                        }*/
//
//
//                        videoCell.player.actionAtItemEnd = .none
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                            NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        videoCell.player.play()
//                    }
//                } else if y > 400 {
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                    }
//                }
//            }
//        }*/
//        /*else if centerIndexPath > indexPath {
//            //I can get the next cell now
//            if let videoCell = self.collectionView.cellForItem(at: indexPath) as? EmplLandsVideoTextCell {
//                var cellVisibRect = videoCell.frame
//                cellVisibRect.size = videoCell.bounds.size
//
//                let cellCG = CGPoint(x: videoCell.x, y: cellVisibRect.maxY)
//                let rectCell = collectionView.convert(cellCG, to: collectionView.superview)
//
//
//
//                print("Next Y of Cell is: \(rectCell.y)")
//                //print("Previous max Y of cell is : \(maxRectCell.y)")
//
//                let y = rectCell.y
//                let maxY = y + 150
//
//
//                //                if y >= -150 &&  y <= 150{
//                //                    print("You can stop playing the video from here")
//                //                }
//                if y <= 150 { //<=
//                    print("You can stop play the video from here")
//                    if videoCell.player.timeControlStatus == .playing {
//                        videoCell.player.isMuted = muteVideo
//                        if  videoCell.player.isMuted {
//                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                        } else {
//                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                        }
//                        videoCell.player.pause()
//                        videoCell.player.actionAtItemEnd = .pause
//                        //NotificationCenter.default.addObserver(self, selector: #selector(self.pausedVideoDidEnd(cell:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//
//                    } else if y >= rectCell.y {
//                        print("Reverse scroll you can play")
//                        if videoCell.player.timeControlStatus == .paused {
//                            videoCell.player.isMuted = muteVideo
//                            if  videoCell.player.isMuted {
//                                videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
//                            } else {
//                                videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
//                            }
//                            videoCell.player.play()
//                            videoCell.player.actionAtItemEnd = .none
//                            NotificationCenter.default.addObserver(self, selector: #selector(self.playingVideoDidEnd(notification:)), name:
//                                NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:  videoCell.player.currentItem)
//                        }
//                    }
//
//                }
//            }
//        }*/
// */
//
//    }
        
}

extension WallViewController : ProfileServiceDelegate{
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            print("error")
            //self.collectionView.reloadData()
        }
    }
    
    func DidReceiveProfileData(item: ProfileData) {
        
    }
    
    func DidReceiveFeedItems(items: [FeedV2Item],pictureItems: [PictureURL]) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            print("Wall Items : \(items.last?.postuserId)")
            self.feedItemsV2 = items
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates(nil, completion: {
                (result) in
                // ready
                self.pauseVisibleVideos()
            })
          
        }
    }
    
    private func stopRefreshing(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        if refreshControll.isRefreshing{
            refreshControll.endRefreshing()
        }
    }
}

extension WallViewController: UpdatedFeedsDelegate, FriendControllerDelegate{
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return feedItemsV2
        }
        set {
            feedItemsV2 = newValue
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView
    }
}
extension WallViewController : PortraitVideoDelegate
{
    func PortraitVideoFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    func PortraitVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    
    
}
extension WallViewController : PortraitVideoTextDelegate
{
    func PortraitTextVideoFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    func PortraitTextVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    
    
}
extension WallViewController : LandScapVideoDelegate
{
    func LandScapVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    func LandScapVideoFullScreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
}
extension WallViewController : LandScapVideoTextDelegate
{
    func LandScapTextVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    func LandScapVideoTextFullScreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
extension WallViewController : AVPlayerViewControllerDelegate
{
    func playerViewController(_: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator)
    {
        self.scrollViewDidEndScrolling()
    }
}
