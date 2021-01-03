//
//  PhotosVC.swift
//  myscrap
//
//  Created by MS1 on 11/28/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices

class PhotosVC: BaseVC, FriendControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    enum VCType{
        case profile
        case company
    }
    var type: MemberType{
        return .photos
    }
    
    enum PhotoType{
        case list
        case grid
    }
    
    fileprivate var vcType: VCType = .profile
    
    fileprivate var photoType: PhotoType = .grid {
        didSet{
            self.collectionView.reloadData()
            updateBtns()
        }
    }
    
    fileprivate var photos = [INSPhotoViewable]()
    
    var index: Int = 0
    
    fileprivate let service = ProfileService()
    fileprivate var datasource = [PictureURL]()
    fileprivate var profile : ProfileData?
    fileprivate var companyProfileItem: CompanyProfileItem?

    var feedItemsV2 = [FeedV2Item]()

    var friendId : String?
    var notificationId = ""
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak private var noPhotoLbl:UILabel!
    @IBOutlet weak fileprivate var listBtn: UIButton!
    @IBOutlet weak fileprivate var gridBtn: UIButton!
    
    lazy var refreshControll : UIRefreshControl = {
        var rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rc
    }()
    
    @objc
    func refresh(){
        let time = DispatchTime(uptimeNanoseconds: 1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.refreshControll.endRefreshing()
        }
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    var isFromMyProfile : Bool = false

    override func viewWillAppear(_ animated: Bool) {
//        getProfile()
        
        if isFromMyProfile {
             let getFeedItems = self.populateFeedsArray(items: self.feedItemsV2)
             self.feedItemsV2 = getFeedItems
         }
         else {
             if self.feedItemsV2.count == 0 {
                 getProfile()
             }
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableScroll), name: Notification.Name("EnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableScroll), name: Notification.Name("DisableScroll"), object: nil)
        //self.navigationController?.isNavigationBarHidden = false
        service.delegate = self
        activityIndicator.startAnimating()
        //noPhotoLbl.isHidden = false
        setupViews()
        collectionView.isScrollEnabled = false
        updateBtns()
        updatePhotos()
//        scrollView.insertSubview(refreshControll, at: 0)
        scrollView.refreshControl = refreshControll
        
        if isFromMyProfile {
            navigationItem.title = "Photos"
        }
    }
    @objc
    func enableScroll(){
        collectionView.isScrollEnabled = true
    }
    @objc func disableScroll(){
        collectionView.isScrollEnabled = false
    }
    private func updatePhotos(){
        
    }
    
    
    private func updateBtns(){
//        let list = #imageLiteral(resourceName: "ic_list").withRenderingMode(.alwaysTemplate)
//        let grid = #imageLiteral(resourceName: "ic_apps").withRenderingMode(.alwaysTemplate)
        let list = UIImage(named: "icList1")?.withRenderingMode(.alwaysTemplate)
        let grid = UIImage(named: "icGrid")?.withRenderingMode(.alwaysTemplate)

        listBtn.setImage(list, for: .normal)
        gridBtn.setImage(grid, for: .normal)
        if photoType == .grid{
            gridBtn.tintColor = UIColor.GREEN_PRIMARY
            listBtn.tintColor = UIColor.BLACK_ALPHA
        } else {
            gridBtn.tintColor = UIColor.BLACK_ALPHA
            listBtn.tintColor = UIColor.GREEN_PRIMARY
        }
    }
    
    private func setupViews(){
        listBtn.tag = 0
        gridBtn.tag = 1
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        collectionView.register(PhotoGridCell.Nib, forCellWithReuseIdentifier: PhotoGridCell.identifier)
        collectionView.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
        collectionView.refreshControl = refreshControll
        
        view.addSubview(activityIndicator)
        activityIndicator.setTop(to: view.safeTop, constant: 30)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
    }
    
    private func getProfile() {
        friendId = UserDefaults.standard.object(forKey: "friendId") as? String
        print("Friend ID in PhotosVC : \(String(describing: friendId!))")
        var notId = ""
        if notificationId != ""{
            notId = "&notId=\(notificationId)"
        }
        
        //service.getFriendProfile(friendId: friendId!, notId: notId)
//        service.getUserImagesPage(friendId: friendId!)
        service.getFeedsPage(friendId: friendId!)

//        collectionView.reloadData()
    }
    

    @IBAction func didPressBtn(_ sender: UIButton){
        photoType = sender.tag == 0 ? .list : .grid
    }
    
    func configPictureURL(profileItem: CompanyProfileItem?,dataSource: [PictureURL]){
//        self.profile = profileItem
//        self.datasource = dataSource
    }
    
    func configPictureURL(profileItem: ProfileData?,dataSource: [PictureURL]){
        self.profile = profileItem
//        self.datasource = dataSource
    }
    

    
}



extension PhotosVC : ProfileServiceDelegate{
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            print("error")
            self.collectionView.reloadData()
        }
    }
    
    func DidReceiveProfileData(item: ProfileData) {
        DispatchQueue.main.sync {
            self.stopRefreshing()
            self.profile = item
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            self.collectionView.reloadData()
        }
    }
    
    func DidReceiveFeedItems(items: [FeedV2Item],pictureItems: [PictureURL]) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            //self.datasource = pictureItems
            /*
            print("Now on picture \(self.datasource)")
            if self.profile != nil && !self.datasource.isEmpty {
                print("Profile item : \(String(describing: self.profile)), Picture : \(self.datasource)")
                self.configPictureURL(profileItem: self.profile, dataSource: self.datasource)
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.stopAnimating()
                    self.noPhotoLbl.isHidden = true
                }
            }
            else {
                print("Profile in photos is empty")
            }
            self.collectionView.reloadData() */
            
            if items.count != 0 {
                self.feedItemsV2 = self.populateFeedsArray(items: items)
            }
            else {
            }
            
            self.collectionView.reloadData()
        }
    }
    
    
    func populateFeedsArray(items: [FeedV2Item]) -> [FeedV2Item] {
        
        self.stopRefreshing()

        var userFeedArray = [FeedV2Item]()
        
        if items.count > 0 {
            
            self.noPhotoLbl.isHidden = true

            var pictureURLArray = [PictureURL]()
            for checkItems in items {
                
                if checkItems.cellType == .feedImageCell || checkItems.cellType == .feedImageTextCell { ///!= .feedTextCell {
                    for obj in checkItems.pictureURL {
                        pictureURLArray.append(obj)
                    }
                    userFeedArray.append(checkItems)
                }
            }
            if pictureURLArray.count > 0 {
                self.datasource = pictureURLArray
            }
        }
        else {
            self.noPhotoLbl.isHidden = false
        }

        return userFeedArray
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


extension PhotosVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if service.imageList?.count != nil {
//            noPhotoLbl.isHidden = true
//            return (service.imageList?.count)!
//        } else {
//            noPhotoLbl.isHidden = false
//            return datasource.count
//        }
        
        switch photoType {
        case .list:
//            noPhotoLbl.isHidden = true
            return feedItemsV2.count
        default:
//            noPhotoLbl.isHidden = false
            return datasource.count
        }

        //return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       /* print("cell item : \(String(describing: profile)), cell Picture : \((service.imageList)!)")
        
        switch photoType {
        /*case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell() }
           
    
            if vcType == .profile {
                cell.configCell(item: datasource[indexPath.item], profileItem: profile)
            } else {
                cell.configCell(item: datasource[indexPath.item], profileItem: companyProfileItem)
            }
            
            cell.reportBtn.isHidden = true
            cell.delegate = self
            return cell*/
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridCell.identifier, for: indexPath) as? PhotoGridCell else { return UICollectionViewCell() }
            //cell.configCell(datasource[indexPath.item])
            cell.profilePicCell(url: (service.imageList?[indexPath.item])!)
            cell.delegate = self
            return cell
        } */

        switch photoType {
        case .list:
            let data  = feedItemsV2[indexPath.item]
            switch data.cellType{

                case .feedImageCell:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell()}
                    cell.updatedDelegate = self
                    
                    cell.newItem = data
                       cell.refreshImagesCollection()
//                    cell.dwnldBtnAction = {
//                        cell.dwnldBtn.isEnabled = false
//                        for imageCell in cell.feedImages.visibleCells   {
//                           let image = imageCell as! CompanyImageslCell
//                            UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
//                            cell.dwnldBtn.isEnabled = true
//                            }
//                    }
                    cell.offlineBtnAction = {
                        self.showToast(message: "No internet connection")
                    }
                    return cell
                case .feedImageTextCell:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageTextCell.identifier, for: indexPath) as? FeedImageTextCell else { return UICollectionViewCell()}
                    cell.updatedDelegate = self
                    cell.newItem = data
                       cell.refreshImagesCollection()
//                    cell.dwnldBtnAction = {
//                        cell.dwnldBtn.isEnabled = false
//                        for imageCell in cell.feedImages.visibleCells   {
//                           let image = imageCell as! CompanyImageslCell
//                            UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
//                            cell.dwnldBtn.isEnabled = true
//                            }
//                    }
                    cell.offlineBtnAction = {
                        self.showToast(message: "No internet connection")
                    }
                    return cell
                default:
                    return UICollectionViewCell()

            }
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridCell.identifier, for: indexPath) as? PhotoGridCell else { return UICollectionViewCell() }
//                cell.configCell(datasource[indexPath.item])
//                cell.profilePicCell(url: (service.imageList?[indexPath.item])!)
                
                let item = self.datasource[indexPath.item]
//                cell.imageView.setImagePLace
                
                if item.images != "" {
                    cell.imageView.sd_setImage(with: URL(string: item.images), placeholderImage: UIImage(named: "placeholderphoto"))
                }
                cell.delegate = self
                return cell
            }
    }
}

extension PhotosVC: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
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
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            /*switch photoType {
            case .list:
                let height:CGFloat =  heightForListCell(item: datasource[indexPath.item], width: self.view.frame.width)
                return CGSize(width: self.view.frame.width, height: height)
            default:
                return CGSize(width: ( view.frame.width - 2) / 3, height: view.frame.width / 3)
            }*/
    //        return CGSize(width: ( view.frame.width - 2) / 3, height: view.frame.width / 3)
            
    //        if feedItemsV2.count > 0 { //01OCT2019 HAJA added this condition
    //             let item = feedItemsV2[indexPath.item]
    //             let width = view.frame.width
    //            switch photoType {
    //            case .list:
    //                switch item.cellType{
    //                case .feedImageTextCell:
    //                   let height = FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
    //                   return CGSize(width: width, height: height)
    //                default:
    //                   let height = FeedsHeight.heightForImageCellV2(item: item, width: width)
    //                   return CGSize(width: width, height: height)
    //                }
    //            default:
    //                return CGSize(width: ( view.frame.width - 2) / 3, height: view.frame.width / 3)
    //            }
    //        }
    //        else {
    //            return CGSize(width: 0, height: 0)
    //        }
         let width = view.frame.width

            switch photoType {
            case .list:
             let item = feedItemsV2[indexPath.item]
                 switch item.cellType{
                   case .feedImageTextCell:
                     let height = FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
                     return CGSize(width: width, height: height)
                 default:
                    let height = FeedsHeight.heightForImageCellV2(item: item, width: width)
                    return CGSize(width: width, height: height)
                 }
            default:
               return CGSize(width: ( view.frame.width - 2) / 3, height: view.frame.width / 3)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if photoType == .grid{
            return 1
        }
        return 8
    }
    
    private func heightForListCell(item: PictureURL , width: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 75
        let bottomSpacing: CGFloat = 8
        let imageHeight: CGFloat = width
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing
        if !(item.likecount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    
    fileprivate func toImageVC(_ indexPath : IndexPath){
        
        //Skipping tab on image will present full screen image
        /*if photoType == .grid{
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoGridCell
            let currentPhoto = service.imageList![(indexPath as NSIndexPath).row]
            let galleryPreview = INSPhotosViewController(photos: service.imageList! as! [INSPhotoViewable], initialPhoto: currentPhoto as? INSPhotoViewable, referenceView: cell)
            galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
                if let index = self?.service.imageList!.index(where {$0 === photo}) {
                    let indexPath = IndexPath(item: index, section: 0)
                    return self?.collectionView.cellForItem(at: indexPath) as? PhotoGridCell
                }
                return nil
            }
            present(galleryPreview, animated: true, completion: nil)
        } else {
            let currentPhoto = datasource[(indexPath as NSIndexPath).row]
            let galleryPreview = INSPhotosViewController(photos: datasource, initialPhoto: currentPhoto, referenceView: nil)
            galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
                
                if let index = self?.datasource.index(where: {$0 === photo}) {
                    let indexPath = IndexPath(item: index, section: 0)
                    return self?.collectionView.cellForItem(at: indexPath) as? FeedImageCell
                }
                return nil
            }
            present(galleryPreview, animated: true, completion: nil)
            
            
        }*/
    }

}

extension PhotosVC: PhotoGridDelegate{
    func DidTapImageView(cell: PhotoGridCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center){
            
            if let vc = ScrollableImageVC.storyBoardInstance(){
                vc.image = self.datasource[indexPath.row].images
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        /*if let indexPath = collectionView.indexPathForItem(at: cell.center){
            //toImageVC(indexPath)
            
        }*/
    }
}


extension PhotosVC{
    static func storyBoardInstance() -> PhotosVC? {
        let st = UIStoryboard(name: StoryBoard.PROFILE, bundle: nil)
        return st.instantiateViewController(withIdentifier: PhotosVC.id) as? PhotosVC
    }
}

//extension PhotosVC: FeedsDelegate{
//    var feedsV2DataSource: [FeedV2Item] {
//        get {
//            return [FeedV2Item]()
//        }
//        set {
//            //nothing
//        }
//    }
//
//    var feedCollectionView: UICollectionView {
//        return collectionView
//    }
//
//    var feedsDataSource: [FeedItem] {
//        get {
//            return [FeedItem]()
//        }
//        set {
//            // nothing
//        }
//    }
//
//
//}

extension PhotosVC: UpdatedFeedsDelegate{
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
