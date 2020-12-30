//
//  ReportedVC.swift
//  myscrap
//
//  Created by MS1 on 10/10/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import StoreKit
import Photos
import UserNotifications
import AVKit
import AVFoundation
import DKImagePickerController
final class ReportedVC: BaseRevealVC {
    
     lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(ReportedFeedTextCell.Nib, forCellWithReuseIdentifier: ReportedFeedTextCell.identifier)
        cv.register(ReportedFeedImageCell.Nib, forCellWithReuseIdentifier: ReportedFeedImageCell.identifier)
        cv.register(ReportedFeedImageTextCell.Nib, forCellWithReuseIdentifier: ReportedFeedImageTextCell.identifier)
        cv.register(ReportedVideoCell.Nib, forCellWithReuseIdentifier: ReportedVideoCell.identifier)
        cv.register(ReportedVideoTextCell.Nib, forCellWithReuseIdentifier: ReportedVideoTextCell.identifier)
        cv.register(ReportCompanyAdminCollectionViewCell.Nib, forCellWithReuseIdentifier: ReportCompanyAdminCollectionViewCell.identifier)
        cv.register(ReportedLandscapVideoCell.Nib, forCellWithReuseIdentifier: ReportedLandscapVideoCell.identifier)
        cv.register(ReportedLanscapVideoTextCell.Nib, forCellWithReuseIdentifier: ReportedLanscapVideoTextCell.identifier)
        cv.register(CompanyAdminRequestCell.Nib, forCellWithReuseIdentifier: CompanyAdminRequestCell.identifier)

        
        cv.backgroundColor = UIColor(hexString: "EFEFEF")
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var refreshControll: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rf
    }()
    

    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .gray)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    fileprivate var model = FeedModel()
    internal var dataSource = [FeedItem]() {
        didSet{
            DispatchQueue.main.async {
                if self.refreshControll.isRefreshing{
                    self.refreshControll.endRefreshing()
                }
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    fileprivate var modelV2 = FeedV2Model()
    internal var dataSourceV2 = [FeedV2Item]()
    internal var adminRequests = [AdminRequestModel]()
    fileprivate var expandedIndexPaths = [IndexPath]()
    fileprivate var hide = false
    
    fileprivate var companyDataArray = [CompanyItems]()
    var apiService = CompanyUpdatedService()

    // MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = UIColor.white
        setupCollectionView()
        //model.delegate = self
        //modelV2.delegate = self
        activityIndicator.startAnimating()
        /*model.getReportedPosts(completion: { (members) in
            DispatchQueue.main.async {
                self.dataSource = members
                self.collectionView.performBatchUpdates({
                    let indexSet = IndexSet(integer: 0)
                    self.collectionView.reloadSections(indexSet)
                }, completion: nil)
            }
        })*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("SharedOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("SharedClosed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("DeletedVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("PauseAllVideos"), object: nil)

       
        modelV2.getReportedPosts(completion: { (members, companyItems, requests) in
            DispatchQueue.main.async {
                self.dataSourceV2 = members
                self.companyDataArray = companyItems
                self.adminRequests = requests

                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
                self.collectionView.performBatchUpdates(nil, completion: {
                    (result) in
                    self.scrollViewDidEndScrolling()
                })
            
//                self.collectionView.performBatchUpdates({
//                    let indexSet = IndexSet(integer: 0)
//                 //   self.collectionView.reloadSections(indexSet)
//                }, completion: nil)
            }
        })
        collectionView.addSubview(refreshControll)
        self.collectionView.alwaysBounceVertical = true;

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
    
    // MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    //MARK:- VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        self.pauseVisibleVideos()
        super.viewWillDisappear(animated)
       
     //   NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

    }
    
    //MARK:- SETUP COLLECTIONVIEW
    private func setupCollectionView(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            ])
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
            ])
        
    }
    
    @objc
    private func refresh(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        
        modelV2.getReportedPosts(completion: { (members, companyItems, requests)  in
            DispatchQueue.main.async {
                if self.refreshControll.isRefreshing {
                    self.refreshControll.endRefreshing()
                }
                self.dataSourceV2 = members
                self.companyDataArray = companyItems
                self.adminRequests = requests

                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
//                self.collectionView.performBatchUpdates({
//                    let indexSet = IndexSet(integer: 0)
//                    self.collectionView.reloadSections(indexSet)
//                }, completion: nil)
            }
        })
        /*model.getReportedPosts(completion: { (members) in
            DispatchQueue.main.async {
                self.dataSource = members
                self.collectionView.performBatchUpdates({
                    let indexSet = IndexSet(integer: 0)
                    self.collectionView.reloadSections(indexSet)
                }, completion: nil)
            }
        })*/
        self.collectionView.reloadData()
    }
    
    func respondToRequest(isAccepted:Bool, type:String, index:Int) {
        var titleStr:String {
            // 0 for new company request, 1 for admin request
            if isAccepted {
               return type == "0" ? "Are you sure you want to accept company request?" : "Are you sure you want to accept admin request?"
            }
            else {
              return type == "0" ? "Are you sure you want to reject company request?" : "Are you sure you want to reject admin request?"
            }
        }
        
        var status: String { // 0 for accepted, 1 for rejected
            return isAccepted ? "1" : "0"
        }
        
        let reqRespAlert = RequestResponseAlertView()
        reqRespAlert.displayAlert(withSuperView: self, title: titleStr, buttonAction: { [unowned self] in
            
            self.apiService.respondAdminRequest(view:self.view,companyId: adminRequests[index].companyId!, userID: adminRequests[index].userId!, type: status, success: { [unowned self] (message) in
                
                self.adminRequests.remove(at: index)
                self.collectionView.reloadData()
                
            }, failure: { (error) in
                
                showAlert(message: error)
            })
        })
    }
}

extension ReportedVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
        if dataSourceV2.count > 0 {
            print("Count : \(dataSourceV2.count)")
            return dataSourceV2.count
        }
        else {
            return 0
        }*/
        if section == 0 {
            return self.companyDataArray.count
        }
        else if section == 1 {
            return self.dataSourceV2.count
        }
        else if section == 2 {
            return adminRequests.count
        }
        else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportCompanyAdminCollectionViewCell.identifier, for: indexPath) as? ReportCompanyAdminCollectionViewCell else { return UICollectionViewCell()}
            
            let data = self.companyDataArray[indexPath.item]
            cell.companyItem = data
            cell.ownCompBtn.tag = indexPath.row
            cell.ownCompBtn.addTarget(self, action: #selector(reportedButtonAction), for: .touchUpInside)
            
            return cell
        }
        else if indexPath.section == 1 {

            let data = dataSourceV2[indexPath.item]
            UserDefaults.standard.set(indexPath.item, forKey: "indexPath")
            print("Data",data.cellType)
            switch data.cellType {
            case .feedTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedFeedTextCell.identifier, for: indexPath) as? ReportedFeedTextCell else { return UICollectionViewCell() }
                cell.newItem = data
                cell.updatedDelegate = self
              //  cell.reportBtn.tag = 1
                return cell
            case .feedImageCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedFeedImageCell.identifier, for: indexPath) as? ReportedFeedImageCell else { return UICollectionViewCell() }
                cell.updatedDelegate = self
                cell.newItem = data
                cell.refreshImagesCollection()
                cell.SetLikeCountButton()
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
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedFeedImageTextCell.identifier, for: indexPath) as?
                    ReportedFeedImageTextCell else { return UICollectionViewCell() }
                cell.updatedDelegate = self
                cell.newItem = data
                cell.refreshImagesCollection()
                cell.SetLikeCountButton()
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

            case .feedPortrVideoCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedVideoCell.identifier, for: indexPath) as?
                    ReportedVideoCell else { return UICollectionViewCell() }
                cell.newItem = data
                cell.updatedDelegate = self
                cell.videoPlayerDelegate = self
                cell.refreshTable()
                cell.reportBtn.tag = 1
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
                      let videoCell = imageCell as! PortraitVideoCell
                       self.downloadVideo(path: videoCell.newVedio!.video)
                       cell.dwnldBtn.isEnabled = true
                       cell.dwnldBtn.isEnabled = true
                       }

                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                return cell
            case .feedLandsVideoCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedLandscapVideoCell.identifier, for: indexPath) as?
                        ReportedLandscapVideoCell else { return UICollectionViewCell() }
                cell.newItem = data
                cell.updatedDelegate = self
                cell.videoPlayerDelegate = self
                cell.refreshTable()
                cell.reportBtn.tag = 1
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
                return cell
            case .feedPortrVideoTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedVideoTextCell.identifier, for: indexPath) as?
                    ReportedVideoTextCell else { return UICollectionViewCell() }
                cell.newItem = data
                cell.updatedDelegate = self
                cell.videoPlayerDelegate = self
                cell.refreshTable()
                cell.reportBtn.tag = 1
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
                      let videoCell = imageCell as! PortraitVideoCell
                       self.downloadVideo(path: videoCell.newVedio!.video)
                       cell.dwnldBtn.isEnabled = true
                       cell.dwnldBtn.isEnabled = true
                       }

                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                return cell
            case .feedLandsVideoTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedLanscapVideoTextCell.identifier, for: indexPath) as?
                        ReportedLanscapVideoTextCell else { return UICollectionViewCell() }
                cell.newItem = data
                cell.updatedDelegate = self
                cell.videoPlayerDelegate = self
                cell.refreshTable()
                cell.reportBtn.tag = 1
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
                return cell
            case .feedVideoCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedVideoCell.identifier, for: indexPath) as?
                    ReportedVideoCell else { return UICollectionViewCell() }
                cell.newItem = data
                cell.updatedDelegate = self
                cell.refreshTable()
                cell.reportBtn.tag = 1
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
                      let videoCell = imageCell as! PortraitVideoCell
                       self.downloadVideo(path: videoCell.newVedio!.video)
                       cell.dwnldBtn.isEnabled = true
                       cell.dwnldBtn.isEnabled = true
                       }

                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                return cell
            case .feedVideoTextCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportedVideoTextCell.identifier, for: indexPath) as?
                    ReportedVideoTextCell else { return UICollectionViewCell() }
                cell.newItem = data
                cell.updatedDelegate = self
                cell.refreshTable()
                cell.reportBtn.tag = 1
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
                      let videoCell = imageCell as! PortraitVideoCell
                       self.downloadVideo(path: videoCell.newVedio!.video)
                       cell.dwnldBtn.isEnabled = true
                       cell.dwnldBtn.isEnabled = true
                       }

                }
                cell.offlineBtnAction = {
                    self.showToast(message: "No internet connection")
                }
                return cell
            default:
                assert(false, "Not expecting a cell")
                return UICollectionViewCell()
            }
        }
        else if indexPath.section == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyAdminRequestCell.identifier, for: indexPath) as? CompanyAdminRequestCell else { return UICollectionViewCell()}
            let item = adminRequests[indexPath.row]
            cell.requestItem = item
            cell.acceptAction = { [unowned self] in
                self.respondToRequest(isAccepted: true, type: item.type!, index: indexPath.row)
            }
            cell.rejectAction = { [unowned self] in
                self.respondToRequest(isAccepted: false, type: item.type!, index: indexPath.row)
            }
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  let vc = CompanyHeaderModuleVC.storyBoardInstance() {
            let request = adminRequests[indexPath.row]
            vc.title = request.companyName
            vc.companyId = request.companyId
            UserDefaults.standard.set(vc.title, forKey: "companyName")
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func pauseVisibleVideos()  {
        
        for videoParentCell in collectionView.visibleCells   {
            
            var indexPathNotVisible = collectionView.indexPath(for: videoParentCell)
            
            if let videoParentwithoutTextCell = videoParentCell as? ReportedVideoTextCell
            {
                for videoCell in videoParentwithoutTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? ReportedVideoCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            if let videoParentTextCell = videoParentCell as? ReportedLandscapVideoCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            if let videoParentTextCell = videoParentCell as? ReportedLanscapVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
           
            }
        
    }
    func pauseAllVideos(indexPath : IndexPath)  {
        
        for videoParentCell in collectionView.visibleCells   {
            
            var indexPathNotVisible = collectionView.indexPath(for: videoParentCell)
            if indexPath != indexPathNotVisible {
            
            if let videoParentwithoutTextCell = videoParentCell as? ReportedVideoCell
            {
                for videoCell in videoParentwithoutTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? ReportedVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? ReportedLandscapVideoCell
                {
                    for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                        print("You can stop play the video from here")
                            videoCell.pause()
                        

                    }
                }
                if let videoParentTextCell = videoParentCell as? ReportedLanscapVideoTextCell
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
            
            
            
            if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? ReportedVideoCell
            {
                

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
             
                    var point = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.center, to: self.view)
                    let buttonAbsoluteFrame = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.bounds, to: self.view)

                   
                    if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                        // Point lies inside the bounds.
                        videoCell.resume()
                    }
                    else
                    {
                        videoCell.pause()
                    }
    
                self.pauseAllVideos(indexPath: indexPath)
               }
                collectionViewCell.UpdateLable()
            }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? ReportedVideoTextCell
          {
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

                   print(indexPath)

                    var point = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.center, to: self.view)
                    let buttonAbsoluteFrame = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.bounds, to: self.view)


                    if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                        // Point lies inside the bounds.
                        videoCell.resume()
                    }
                    else
                    {
                        videoCell.pause()
                    }
//
               
           
                self.pauseAllVideos(indexPath: indexPath)
             }
            collectionViewCell.UpdateLable()
          }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? ReportedLandscapVideoCell
          {
             for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
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

                   print(indexPath)

                    var point = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.center, to: self.view)
                    let buttonAbsoluteFrame = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.bounds, to: self.view)


                    if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                        // Point lies inside the bounds.
                        videoCell.resume()
                    }
                    else
                    {
                        videoCell.pause()
                    }
//
               
           
                self.pauseAllVideos(indexPath: indexPath)
             }
            collectionViewCell.UpdateLable()
          }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? ReportedLanscapVideoTextCell
          {
             for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
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

                   print(indexPath)

                    var point = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.center, to: self.view)
                    let buttonAbsoluteFrame = collectionViewCell.videosCollection.convert(collectionViewCell.videosCollection.bounds, to: self.view)


                    if ( buttonAbsoluteFrame.contains(centerPoint) ) {
                        // Point lies inside the bounds.
                        videoCell.resume()
                    }
                    else
                    {
                        videoCell.pause()
                    }
//
               
           
                self.pauseAllVideos(indexPath: indexPath)
             }
            collectionViewCell.UpdateLable()
          }
          
   }
}
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrolling()
        
    }
    
    
    //MARK:- Actions
    @objc func reportedButtonAction(sender: UIButton) {
        
        let data = self.companyDataArray[sender.tag]

        let reportCompanyDropDown = DropDown()
        reportCompanyDropDown.anchorView = sender
        reportCompanyDropDown.bottomOffset = CGPoint(x: sender.frame.origin.x, y:(reportCompanyDropDown.anchorView?.plainView.bounds.height)!)
        reportCompanyDropDown.dataSource = ["Undo Report","Delete"]
        reportCompanyDropDown.cellHeight = 45.0
        
        reportCompanyDropDown.direction = .bottom
        
        reportCompanyDropDown.dropDownWidth = 200
        reportCompanyDropDown.setupCornerRadius(3)
        reportCompanyDropDown.backgroundColor = UIColor.white

        reportCompanyDropDown.show()
        reportCompanyDropDown.selectionAction = {[unowned self] (index: Int, item: String) in

            var titleStr = ""
            var reportStr = ""
            if index == 0 { // Undo Report
                                
                titleStr = "Are you sure you want to un report this company?"
                reportStr = "4"
                if data.reportedType == "0" { //0 is for admin
                    reportStr = "3" // delete admin of the company
                    titleStr = "Are you sure you want to un report this admin?"
                }
            }
            else if index == 1 { // Delete
                
                reportStr = "1" // delete the company
                titleStr = "Are you sure you want to delete this company?"

            }
            
            if titleStr != "" && data.compnayId != "" && reportStr != "" {
                self.reportCompanyAlert(title: titleStr,
                                        reportTypeStr: reportStr,
                                        companyId: data.compnayId,
                                        index: sender.tag)
            }

        }

    }
    
    func reportCompanyAlert(title: String, reportTypeStr: String, companyId:String, index : Int) {
        
        self.showPopUpAlert(title: title, message: "", actionTitles: ["No","Yes"], actions: [{action1 in

        },
        {action2 in

            //Undo Report API
            
            if companyId != "" {
                self.apiService.deleteCompanyReport(view: self.view,
                                                    companyId: companyId,
                                                    reportType: reportTypeStr) { (isSuccess) in
                    if isSuccess! {
                        
                        DispatchQueue.main.async {
                            self.companyDataArray.remove(at: index)
                            self.collectionView.reloadData()
                            self.showToast(message: "Company Unreported")
                        }
                    }
                }

            }
        }])

    }
}

extension ReportedVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        if indexPath.section == 0 {
            return  CGSize(width:  width, height: 480)
        }
        else if indexPath.section == 1 {

            let item = dataSourceV2[indexPath.item]
            var height : CGFloat = 0
            /*switch item.cellType{
             case .feedNewUserCell:
             height += FeedsHeight.heightForNewUserCell(item: item, viewWidth: width)
             return CGSize(width: width , height: height)
             case .feedTextCell:
             height += FeedsHeight.heightforFeedTextCellV2(item: item , labelWidth: width - 16)
             return CGSize(width: width , height: height)
             case .feedImageCell:
             height += FeedsHeight.heightForImageCellV2(item: item, width: width)
             return CGSize(width: width, height: height)
             case .feedImageTextCell:
             height += FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
             return CGSize(width: width, height: height)
             case .newsTextCell:
             height += FeedsHeight.heightForNewsTextCell(item: item, labelWidth: width - 16)
             return CGSize(width: width, height: height)
             case .newsImageCell:
             height += FeedsHeight.heightForNewsImageCell(item: item, labelWidth: width - 16)
             return CGSize(width: width, height: height)
             case .eventCell:
             height += FeedsHeight.heightForImageTextCell(item: item, width: width, labelWidth: width - 16)
             return CGSize(width: width, height: height)
             case .feedListingCell:
             return CGSize(width: width, height: height)
             case .userFeedImageTextCell:
             print("Image text")
             return CGSize(width: width, height: height)
             case .userFeedImageCell:
             print("Image")
             return CGSize(width: width, height: height)
             case .userFeedTextCell:
             print("Text")
             return CGSize(width: width, height: height)
             }*/
            switch item.cellType{
            case .covidPoll:
                return CGSize(width: 0, height: 0)
            case .feedTextCell:
                height += FeedsHeight.heightforFeedTextCellV2(item: item , labelWidth: width - 16)
                if item.status.contains("http") {
                    height -= 410
                }
                else
                {
                    height -= 0
                }
                return CGSize(width: width , height: height + 30)
            case .feedImageCell:
                height += FeedsHeight.heightForImageCellV2(item: item, width: width)
                return CGSize(width: width, height: height + 35)
            case .feedImageTextCell:
                height += FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
                return CGSize(width: width, height: height + 30)
            case .feedVideoCell:
                height += FeedsHeight.heightForVideoCellV2(item: item, width: width)
                return CGSize(width: width, height: height + 30)
            case .feedVideoTextCell:
                height += FeedsHeight.heightForVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                print("Video Cell height : \(height)")
                return CGSize(width: width, height: height + 35)
            case .ads:
                //height += messageHeight(for: item.description)
                //print("height of ad : \(height)")
                //return CGSize(width: width, height: height + 362)  //469 //500
                return CGSize(width: 0, height: 0)
            case .market:
                //print("Width of market scroll: \(width)")
                //return CGSize(width: width, height: 330)    //355
                return CGSize(width: 0, height: 0)
            case .userFeedTextCell:
                return CGSize(width: 0, height: 0)
            case .userFeedImageCell:
                return CGSize(width: 0, height: 0)
            case .userFeedImageTextCell:
                return CGSize(width: 0, height: 0)
            case .newUser:
                return CGSize(width: width, height: 355 )
            case .news:
                return CGSize(width: width, height: 355)
            case .companyMonth:
                //guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyOfMonthCell.identifier, for: indexPath) as? CompanyOfMonthCell else { return CGSize(width: 0, height: 0)}
                //height = FeedsHeight.heightForCompanyOfMonthCellV2(item: item, labelWidth: width - 16)  //Aligning width by omitting (leading & trailing)
                //print("Height of COM cell : \(height)")
                //return CGSize(width: width, height: height)
                return CGSize(width: 0, height: 0)
            case .personWeek:
                //height = FeedsHeight.heightForPersonOfWeekCellV2(item: item, labelWidth: width - 16)  //Aligning width by omitting (leading & trailing)
                //print("Height of POW cell : \(height)")
                //return CGSize(width: width, height: height)
                return CGSize(width: 0, height: 0)
            case .vote:
                //return CGSize(width: width, height: 290)    //260
                return CGSize(width: 0, height: 0)
            case .personWeekScroll:
                //return CGSize(width: width, height: 290)
                return CGSize(width: 0, height: 0)
            case .feedPortrVideoCell:
                height = FeedsHeight.heightForPortraitVideoCellV2(item: item, width: width)
                return CGSize(width: width, height: height + 60)
            case .feedPortrVideoTextCell:
                height = FeedsHeight.heightForPortraitVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                print("Video Cell height : \(height)")
                return CGSize(width: width, height: height + 65)    //height + 30
            case .feedLandsVideoCell:
                height = FeedsHeight.heightForLandsVideoCellV2(item: item, width: width)
                return CGSize(width: width, height: height + 60 )
            case .feedLandsVideoTextCell:
                height = FeedsHeight.heightForLandsVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
                print("Video Cell height : \(height)")
                return CGSize(width: width, height: height + 65 )    //height + 30
            }
        }
        else {
            return  CGSize(width:  width, height: 353)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}

extension ReportedVC: FeedDelegate{
    func didReceivedFailure(error: String) {
        print(error)
    }
    
    func didReceiveData(data: [FeedItem]) {
        self.dataSource = data
        self.collectionView.reloadData()
    }
}

extension ReportedVC {
    
    private func showAlertForButton(){
        let alertController = UIAlertController(title: "Moderator Alert", message: "Please Unreport the post for further actions.", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.GREEN_PRIMARY
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    
   func removeCollectionViewCell(_ i : Int){
    self.pauseVisibleVideos()
        self.collectionView.performBatchUpdates({
            //let j = i + 1
            dataSource.remove(at: i)
            let indexPath = IndexPath(item: i, section: 0)
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    func performUnreport(reportId:String){
        self.pauseVisibleVideos()
        let service = APIService()
        service.endPoint = Endpoints.UNREPORT_URL
        service.params = "userId=\(AuthService.instance.userId)&reportId=\(reportId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Post UnReported")
            case .Error(_):
                print("Cant unreport")
            }
        }
    }
    
    func deletePost(postId:String){
        self.pauseVisibleVideos()
        let api = APIService()
        api.endPoint = Endpoints.DELETE_POST_URL
        api.params = "postId=\(postId)&albumId=&userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success( _):
                print("Deleted Post Succesfully")
            case .Error(let error):
                print("Error in deleting Post" , error )
            }
        }
    }
    
    func editReport() {
        
        //didTapReportMod(cell: FeedNewUserCell())
    }
    
    /*func didTapReportMod(cell: FeedNewUserCell) {
        
        if AuthStatus.instance.isGuest {
            showGuestAlert()
        } else {
            
            guard let indexPath = collectionView.indexPathForItem(at: cell.center) else {
                print("Now", feedCollectionView.indexPathForItem(at: cell.center) as Any)
                return }
            print("Index Path : \(indexPath)")
            //let item = UserDefaults.standard.integer(forKey: "indexPath")
            //print("IndexPath : \(item)")
            let obj = dataSource[(indexPath.item)]
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let unreportAction = UIAlertAction(title: "Undo Report", style: .default) { (action) in
                self.removeCollectionViewCell(indexPath.item)
                self.performUnreport(reportId: obj.reportId)
                
            }
            let deletAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.removeCollectionViewCell(indexPath.item)
                self.deletePost(postId: obj.postId)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.view.tintColor = UIColor.GREEN_PRIMARY
            alertController.addAction(unreportAction)
            alertController.addAction(deletAction)
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
        }
        
        //        if let indexPath = feedCollectionView.indexPathForItem(at: cell.center) {
        //            let obj = dataSource[(indexPath.item)]
        //
        //            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //            let unreportAction = UIAlertAction(title: "Undo Report", style: .default) { (action) in
        //                self.removeCollectionViewCell(indexPath.item)
        //                self.performUnreport(reportId: obj.reportId)
        //
        //            }
        //            let deletAction = UIAlertAction(title: "Delete", style: .destructive) { action in
        //                self.removeCollectionViewCell(indexPath.item)
        //                self.deletePost(postId: obj.postId)
        //            }
        //
        //            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //            alertController.view.tintColor = UIColor.GREEN_PRIMARY
        //            alertController.addAction(unreportAction)
        //            alertController.addAction(deletAction)
        //            alertController.addAction(cancel)
        //            present(alertController, animated: true, completion: nil)
        //        }
    }*/
    
}

/*extension ReportedVC: FeedsDelegate, FriendControllerDelegate{
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return dataSourceV2
        }
        set {
            dataSourceV2 = newValue
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView
    }
    
    var feedsDataSource: [FeedItem] {
        get {
            return dataSource
        }
        set {
            dataSource = newValue
        }
    }
}*/
extension ReportedVC : UpdatedFeedsDelegate {
   
    
    func didTapForFriendView(id: String) {
        print("not using")
        if let vc = FriendVC.storyBoardInstance(){
            vc.friendId = id
            vc.notificationId = ""
            vc.isfromCardNoti = ""
            UserDefaults.standard.set(id, forKey: "friendId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
   
    //#2#7api after count
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return dataSourceV2
        }
        set {
            dataSourceV2 = newValue
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView
    }
    
    func didTapEditV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest { showGuestAlert() } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { [unowned self] (report) in
                /*if let vc = EditPostVC.storyBoardReference(){
                 vc.title = "Edit Post"
                 if let imageTextCell = cell as? FeedImageTextCell{
                 vc.postImage = imageTextCell.feedImage.image
                 }
                 if let imageCell = cell as? FeedImageCell{
                 vc.postImage = imageCell.feedImage.image
                 }
                 let text = item.status
                 vc.postText = text
                 vc.editPostId = item.postId
                 vc.didPost = { succes in
                 print("returned")
                 if !self.topLoader.isAnimating {
                 self.topSpinnerHeightConstraint.constant = 58
                 self.topLoader.startAnimating()
                 }
                 self.active.startAnimating()
                 self.refreshContol.beginRefreshing()
                 self.handleRefresh()
                 }
                 let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                 self.present(navBarOnModal, animated: true, completion: nil)
                 //self.feedCollectionView.reloadData()
                 
                 }*/
                if let vc = AddPostV2Controller.storyBoardReference(){
                    vc.title = "Edit Post"
                    if let imageTextCell = cell as? FeedImageTextCell{
                        vc.isImage = true
                        vc.postImage = imageTextCell.feedImage.image
                    } else if let imageCell = cell as? FeedImageCell{
                        vc.isImage = true
                        vc.postImage = imageCell.feedImage.image
                    } else {
                        vc.isVideo = true
                        vc.videoPickedUrl = URL(string: item.videoUrl)
                    }
                    
                    let text = item.status
                    vc.postText = text
                    vc.editPostId = item.postId
                    print("Post Id : \(vc.editPostId)")
                    vc.didPost = { succes, isVideoPosted in
                        print("returned")
                    }
                    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                    self.present(navBarOnModal, animated: true, completion: nil)
                    //self.feedCollectionView.reloadData()
                    
                }
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { [unowned self] (report) in
                //print("DS feeds : \(self.feedsV2DataSource)")
                //dump(self.feedsV2DataSource)
                /*if let window = UIApplication.shared.keyWindow {
                 
                 
                 let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
                 overlay.alpha = 0.5
                 overlay.backgroundColor = UIColor.black
                 window.addSubview(overlay)
                 
                 self.feedsV2DataSource.remove(at: indexPath.item)
                 self.feedV2Service.deletePost(postId: item.postId, albumId: item.albumId)
                 self.feedCollectionView.performBatchUpdates({
                 self.feedCollectionView.deleteItems(at: [indexPath])
                 }, completion: nil)
                 self.showToast(message: "Post Deleted")
                 if !self.topLoader.isAnimating {
                 self.topSpinnerHeightConstraint.constant = 58
                 self.topLoader.startAnimating()
                 //overlay.removeFromSuperview()
                 }
                 self.active.startAnimating()
                 self.refreshContol.beginRefreshing()
                 self.handleRefresh()
                 
                 }*/
                self.pauseVisibleVideos()
                
                self.feedsV2DataSource.remove(at: indexPath.item)
                self.feedV2Service.deletePost(postId: item.postId, albumId: item.albumId)
                self.feedCollectionView.performBatchUpdates({
                    self.feedCollectionView.deleteItems(at: [indexPath])
                }, completion: nil)
                self.showToast(message: "Post Deleted")
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = UIColor.GREEN_PRIMARY
            present(actionSheet, animated: true, completion: nil)
        }
    }
}
extension ReportedVC: VideoTextsOnReportPlayerDelegate{
    func ReportedVideoTextFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func PortraitTextVideoChanged() {
        pauseVisibleVideos()
        self.scrollViewDidEndScrolling()
    }
    
    
    func playReportedTextVedio(url: String) {
             let urlString = url
                   let videoURL = URL(string: urlString)
                   let player = AVPlayer(url: videoURL!)
                   let playerViewController = AVPlayerViewController()
                   playerViewController.player = player
        playerViewController.delegate = self
                   self.present(playerViewController, animated: true) {
                       playerViewController.player!.play()
                   }
    }
    
}

extension ReportedVC: LandscapVideoTextsOnReportPlayerDelegate{
    func ReportedLandscapVideoTextFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func LandscapTextVideoChanged() {
        pauseVisibleVideos()
        self.scrollViewDidEndScrolling()
    }
    
    
    func playLandscapReportedTextVedio(url: String) {
             let urlString = url
                   let videoURL = URL(string: urlString)
                   let player = AVPlayer(url: videoURL!)
                   let playerViewController = AVPlayerViewController()
                   playerViewController.player = player
        playerViewController.delegate = self
                   self.present(playerViewController, animated: true) {
                       playerViewController.player!.play()
                   }
    }
    
}
extension ReportedVC: VideoOnReportedPlayerDelegate{
    func ReportedVideoFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func PortraitVideoChanged() {
        pauseVisibleVideos()
        self.scrollViewDidEndScrolling()
    }
    func playReportedVedio(url: String) {
             let urlString = url
                   let videoURL = URL(string: urlString)
                   let player = AVPlayer(url: videoURL!)
                   let playerViewController = AVPlayerViewController()
                   playerViewController.player = player
        playerViewController.delegate = self
                   self.present(playerViewController, animated: true) {
                       playerViewController.player!.play()
                   }
    }
    
}
extension ReportedVC: VideoOnLandscapReportedPlayerDelegate{
    func ReportedLandscapVideoFullscreenPressed(player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func LandscapVideoChanged() {
        pauseVisibleVideos()
        self.scrollViewDidEndScrolling()
    }
    func playLandscapReportedVedio(url: String) {
             let urlString = url
                   let videoURL = URL(string: urlString)
                   let player = AVPlayer(url: videoURL!)
                   let playerViewController = AVPlayerViewController()
                   playerViewController.player = player
        playerViewController.delegate = self
                   self.present(playerViewController, animated: true) {
                       playerViewController.player!.play()
                   }
    }
    
}
extension ReportedVC : AVPlayerViewControllerDelegate
{
    func playerViewController(_: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator)
    {
        self.scrollViewDidEndScrolling()
    }
}



