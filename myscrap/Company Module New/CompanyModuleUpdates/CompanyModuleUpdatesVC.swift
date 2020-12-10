//
//  CompanyModuleUpdatesVC.swift
//  myscrap
//
//  Created by Apple on 21/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos

class CompanyModuleUpdatesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    var feedsManualCount = 0
    fileprivate var loadMore = true
    
    fileprivate var datasource = [FeedV2Item]()
    
    fileprivate let service = CompanyUpdatedService()
    
    var index = IndexPath()
    var visibleCellIndex = IndexPath()
    var muteVideo = true
    
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    //MARK:- Stored Properties for Scroll Delegate
    
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white

        self.getEmployeeData(pageLoad: 0, completion: { _ in })

        setupCollectionView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func setupCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        collectionView.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
//        collectionView.register(CommonImageCollectionViewCell.self, forCellWithReuseIdentifier: "CommonImageCollectionViewCell")
        
        collectionView.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
        collectionView.register(EmplPortraitVideoCell.Nib, forCellWithReuseIdentifier: EmplPortraitVideoCell.identifier)
        collectionView.register(EmplLandscVideoCell.Nib, forCellWithReuseIdentifier: EmplLandscVideoCell.identifier)
        collectionView.register(EmplPortrVideoTextCell.Nib, forCellWithReuseIdentifier: EmplPortrVideoTextCell.identifier)
        collectionView.register(EmplLandsVideoTextCell.Nib, forCellWithReuseIdentifier: EmplLandsVideoTextCell.identifier)
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        
    }

    
    @objc func handleRefresh(){
           if activityIndicator.isAnimating{
               activityIndicator.stopAnimating()
           }
        getEmployeeData(pageLoad: 0, completion: { _ in })
       }
    
    //MARK:- API
    func getEmployeeData(pageLoad: Int, completion: @escaping (Bool) -> ()) {
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getEmployeeFeeds(companyId: companyId!, pageLoad: "\(pageLoad)") { (result) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
                
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Feed data count",self.datasource.count)
                    self.feedsManualCount = self.datasource.count
                    let newData = data
                    //newData.removeDuplicates()
                    self.datasource = newData
                    self.collectionView.reloadData()
                    self.loadMore = true
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    
    private func getFeedsMore(pageLoad: Int, completion: @escaping (Bool) -> () ){
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getEmployeeFeeds(companyId: companyId!, pageLoad: "\(pageLoad)") { (result) in
            DispatchQueue.main.async {
                
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Feed data count",self.datasource.count)
                    self.feedsManualCount = self.datasource.count
                    var newData = self.datasource + data
                    //newData.removeDuplicates()
                    self.datasource = newData
                    self.collectionView.reloadData()
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    completion(true)
                }
            }
        }
    }
}


extension CompanyModuleUpdatesVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if datasource.count != 0 {
            return datasource.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data  = datasource[indexPath.item]
        print("Initialized cell type : \(data.cellType)")
        
        switch data.cellType{
            
        case .covidPoll:
            return UICollectionViewCell()
        case .feedTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTextCell.identifier, for: indexPath) as? FeedTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
//            cell.fancyViewWidthConstraint.constant = UIScreen.main.bounds.width
            return cell
        case .feedImageCell:
           
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.refreshImagesCollection()
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
//                UIImageWriteToSavedPhotosAlbum(cell.feedImage.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
//                cell.dwnldBtn.isEnabled = true
                
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

//             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonImageCollectionViewCell", for: indexPath) as? CommonImageCollectionViewCell else { return UICollectionViewCell()}
//
//            cell.updatedDelegate = self
//            cell.newItem = data
//            cell.imagesCollectionView.reloadData()
//
//            return cell
        case .feedImageTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageTextCell.identifier, for: indexPath) as? FeedImageTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.refreshImagesCollection()
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                UIImageWriteToSavedPhotosAlbum(cell.feedImage.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                cell.dwnldBtn.isEnabled = true
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            return cell
        case .feedVideoCell:
            return UICollectionViewCell()
        case .feedVideoTextCell:
            return UICollectionViewCell()
        case .feedPortrVideoCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortraitVideoCell.identifier, for: indexPath) as? EmplPortraitVideoCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
            }
            /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
            videoTap.numberOfTapsRequired = 1
            cell.thumbnailImg.isUserInteractionEnabled = true
            cell.thumbnailImg.addGestureRecognizer(videoTap)
            cell.thumbnailImg.tag = indexPath.row*/
            cell.playBtnAction = {
                //self.feedService.hitView(postId: data.postId)
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
                self.downloadVideo(path: data.downloadVideoUrl)
                cell.dwnldBtn.isEnabled = true
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            return cell
        case .feedLandsVideoCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplLandscVideoCell.identifier, for: indexPath) as? EmplLandscVideoCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
            }
            /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
            videoTap.numberOfTapsRequired = 1
            cell.thumbnailImg.isUserInteractionEnabled = true
            cell.thumbnailImg.addGestureRecognizer(videoTap)
            cell.thumbnailImg.tag = indexPath.row*/
            cell.playBtnAction = {
                //self.feedService.hitView(postId: data.postId)
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
                self.downloadVideo(path: data.downloadVideoUrl)
                cell.dwnldBtn.isEnabled = true
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            return cell
        case .feedPortrVideoTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortrVideoTextCell.identifier, for: indexPath) as? EmplPortrVideoTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
            videoTap.numberOfTapsRequired = 1
            cell.thumbnailImg.isUserInteractionEnabled = true
            cell.thumbnailImg.addGestureRecognizer(videoTap)
            cell.thumbnailImg.tag = indexPath.row*/
            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
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
                self.downloadVideo(path: data.downloadVideoUrl)
                cell.dwnldBtn.isEnabled = true
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            return cell
        case .feedLandsVideoTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplLandsVideoTextCell.identifier, for: indexPath) as? EmplLandsVideoTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
            videoTap.numberOfTapsRequired = 1
            cell.thumbnailImg.isUserInteractionEnabled = true
            cell.thumbnailImg.addGestureRecognizer(videoTap)
            cell.thumbnailImg.tag = indexPath.row*/
            self.visibleCellIndex = indexPath
            //cell.player.isMuted = muteVideo
            cell.muteBtnAction = {
                self.index = indexPath
                self.updateMuteBtn()
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
                self.downloadVideo(path: data.downloadVideoUrl)
                cell.dwnldBtn.isEnabled = true
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            return cell
        case .ads:
            return UICollectionViewCell()
        case .market:
            return UICollectionViewCell()
        case .userFeedTextCell:
            return UICollectionViewCell()
        case .userFeedImageCell:
            return UICollectionViewCell()
        case .userFeedImageTextCell:
            return UICollectionViewCell()
        case .newUser:
            return UICollectionViewCell()
        case .news:
            return UICollectionViewCell()
        case .companyMonth:
            return UICollectionViewCell()
        case .personWeek:
            return UICollectionViewCell()
        case .vote:
            return UICollectionViewCell()
        case .personWeekScroll:
            return UICollectionViewCell()
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
    
    func updateMuteBtn() {
        if let cell = collectionView.cellForItem(at: index) as? EmplPortraitVideoCell {
            
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if muteVideo {
                muteVideo = false
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                muteVideo = true
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplLandscVideoCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if muteVideo {
                muteVideo = false
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                muteVideo = true
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplPortrVideoTextCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if muteVideo {
                muteVideo = false
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                muteVideo = true
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplLandsVideoTextCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if muteVideo {
                muteVideo = false
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                muteVideo = true
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
    }
    
    @objc func videoDownloadNotify(_ notification: Notification){
        print("Video saved!")
        
        //self.showMessage(with: "Video Downloaded")
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let userActions = "User Actions"
        
        content.title = "MyScrap"
        content.body = "Video downloaded to the Gallery"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions
        
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.textLbl.text = "No Social Activity"
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
//        let width = view.safeAreaLayoutGuide.layoutFrame.width
        let width = bounds.width //view.frame.width

        print("Width of cell : \(width)")
        //let width = view.frame.width
        let item = datasource[indexPath.item]
        print("Get the raw values",item.cellType.rawValue)
        var height : CGFloat = 0
        //#8
        switch item.cellType{
        case .feedTextCell:
            height = FeedsHeight.heightforFeedTextCellV2(item: item , labelWidth: width - 16)
            return CGSize(width: width , height: height)
        case .feedImageCell:
            height = FeedsHeight.heightForImageCellV2(item: item, width: width)
            return CGSize(width: width, height: height)
        case .feedImageTextCell:
            height = FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
            print("Feed image text cell width : \(width)")
            return CGSize(width: width, height: height)        
        case .feedVideoCell:
            return CGSize(width: 0, height: 0)
        case .feedVideoTextCell:
            return CGSize(width: 0, height: 0)
        case .ads:
            return CGSize(width: 0, height: 0)
        case .market:
            return CGSize(width: 0, height: 0)
        case .userFeedTextCell:
            return CGSize(width: 0, height: 0)
        case .userFeedImageCell:
            return CGSize(width: 0, height: 0)
        case .userFeedImageTextCell:
            return CGSize(width: 0, height: 0)
        case .newUser:
            return CGSize(width: width, height: 355)
        case .news:
            return CGSize(width: width, height: 355)
        case .companyMonth:
            return CGSize(width: 0, height: 0)
        case .personWeek:
            return CGSize(width: 0, height: 0)
        case .vote:
            return CGSize(width: 0, height: 0)
        case .personWeekScroll:
            return CGSize(width: 0, height: 0)
        case .covidPoll:
            return CGSize(width: 0, height: 0)
        case .feedPortrVideoCell:
            height = FeedsHeight.heightForPortraitVideoCellV2(item: item, width: width)
            return CGSize(width: width, height: height + 20)
        case .feedLandsVideoCell:
            height = FeedsHeight.heightForLandsVideoCellV2(item: item, width: width)
            return CGSize(width: width, height: height + 20)
        case .feedPortrVideoTextCell:
            height = FeedsHeight.heightForPortraitVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
            print("Video Cell height : \(height)")
            return CGSize(width: width, height: height + 15)    //height + 30
        case .feedLandsVideoTextCell:
            height = FeedsHeight.heightForLandsVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
            print("Video Cell height : \(height)")
            return CGSize(width: width, height: height + 15)    //height + 30
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout();
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //let visibleCell = collectionView.dequeReusableCell(forIndexPath: indexPath) as?  FeedVideoTextCell
        if self.visibleCellIndex == indexPath {
            //NotificationCenter.default.post(name:.videoCellPlay, object: nil)
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            
            
            if let videoCell = cell as? EmplPortraitVideoCell {
                videoCell.player.isMuted = muteVideo
                if  videoCell.player.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoCell.player.play()
            }
            if let videoTextCell = cell as? EmplLandscVideoCell {
                videoTextCell.player.isMuted = muteVideo
                if videoTextCell.player.isMuted {
                    videoTextCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoTextCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoTextCell.player.play()
            }
            if let videoTextCell = cell as? EmplPortrVideoTextCell {
                videoTextCell.player.isMuted = muteVideo
                if videoTextCell.player.isMuted {
//                    videoTextCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoTextCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoTextCell.player.play()
            }
            if let videoTextCell = cell as? EmplLandsVideoTextCell {
                videoTextCell.player.isMuted = muteVideo
                if videoTextCell.player.isMuted {
                    videoTextCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoTextCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoTextCell.player.play()
            }
        } else {
            //NotificationCenter.default.post(name:.videoCellPause, object: nil)
            if let videoCell = cell as? EmplPortraitVideoCell {
                videoCell.player.pause()
            }
            if let videoTextCell = cell as? EmplLandscVideoCell {
                videoTextCell.player.pause()
            }
            if let videoTextCell = cell as? EmplPortrVideoTextCell {
                videoTextCell.player.pause()
            }
            if let videoTextCell = cell as? EmplLandsVideoTextCell {
                videoTextCell.player.pause()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /*if self.visibleCellIndex != indexPath {
            //NotificationCenter.default.post(name:.videoCellPlay, object: nil)
        } else {
            //NotificationCenter.default.post(name:.videoCellPause, object: nil)
            if let videoCell = cell as? FeedVideoCell {
                videoCell.player.pause()
            } else if let videoTextCell = cell as? FeedVideoTextCell {
                videoTextCell.player.pause()
            }
        }*/
        if let videoCell = cell as? EmplPortraitVideoCell {
            videoCell.player.pause()
        }
        if let videoTextCell = cell as? EmplLandscVideoCell {
            videoTextCell.player.pause()
        }
        if let videoTextCell = cell as? EmplPortrVideoTextCell {
            videoTextCell.player.pause()
        }
        if let videoTextCell = cell as? EmplLandsVideoTextCell {
            videoTextCell.player.pause()
        }
    }
       
       /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 && datasource.count == 0 {
        return CGSize(width: self.view.frame.width, height: view.frame.height - 300)
        }
        return CGSize.zero
        }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }*/
    
    
    //MARK:- Scroll View Actions

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            /**
             *  Re-size (Shrink) the top view only when the conditions meet:-
             *  1. The current offset of the table view should be greater than the previous offset indicating an upward scroll.
             *  2. The top view's height should be within its minimum height.
             *  3. Optional - Collapse the header view only when the table view's edge is below the above view - This case will occur if you are using Step 2 of the next condition and have a refresh control in the table view.
             */
            
            if delta > 0,
                topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
                scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            /**
             *  Re-size (Expand) the top view only when the conditions meet:-
             *  1. The current offset of the table view should be lesser than the previous offset indicating an downward scroll.
             *  2. Optional - The top view's height should be within its maximum height. Skipping this step will give a bouncy effect. Note that you need to write extra code in the outer view controller to bring back the view to the maximum possible height.
             *  3. Expand the header view only when the table view's edge is below the header view, else the table view should first scroll till it's offset is 0 and only then the header should expand.
             */
            
            if delta < 0,
                // topViewUnwrappedHeight < topViewHeightConstraintRange.upperBound,
                scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
//        else {
//            if !datasource.isEmpty{
//                let currentOffset = scrollView.contentOffset.y
//                let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//                let deltaOffset = maximumOffset - currentOffset
//                if deltaOffset <= 0 {
//                    if loadMore{
//
//                        loadMore = false
//                        self.getFeedsMore(pageLoad: datasource.count, completion: { _ in })
//                    }
//                }
//            }
//        }
        
        if !datasource.isEmpty{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                if loadMore{

                    loadMore = false
                    self.getFeedsMore(pageLoad: datasource.count, completion: { _ in })
                }
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if decelerate == false && scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
}


extension CompanyModuleUpdatesVC : UpdatedFeedsDelegate, FriendControllerDelegate {
    
    func didTapForFriendView(id: String) {
        print("Friend view")
        performFriendView(friendId: id)
    }
    
    //#2#7api after count
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return datasource
        }
        set {
            datasource = newValue
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView
    }
}

