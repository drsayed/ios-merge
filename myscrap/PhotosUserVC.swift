//
//  PhotosUserVC.swift
//  myscrap
//
//  Created by MyScrap on 12/13/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SafariServices

class PhotosUserVC: BaseVC, FriendControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    enum VCType{
        case profile
        case company
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
    
    fileprivate var datasource = [PictureURL]()
    fileprivate var profile : ProfileData?
    fileprivate var companyProfileItem: CompanyProfileItem?
    var dataSourceV2 = [FeedV2Item]()
    let service = ProfileService()

    
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
    private func refresh(){
        let time = DispatchTime(uptimeNanoseconds: 1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.refreshControll.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        noPhotoLbl.isHidden = !datasource.isEmpty
        setupViews()
        updateBtns()
        updatePhotos()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableScroll), name: Notification.Name("EnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableScroll), name: Notification.Name("DisableScroll"), object: nil)
        //        scrollView.insertSubview(refreshControll, at: 0)
        scrollView.refreshControl = refreshControll
        service.delegate = self
        scrollView.isScrollEnabled = false
        collectionView.isScrollEnabled = false
        scrollView.delegate = self
        collectionView.delegate = self
        self.getProfile()
    }
    @objc
    func enableScroll(){
        scrollView.isScrollEnabled = true
        collectionView.isScrollEnabled = true
    }
    @objc func disableScroll(){
        scrollView.isScrollEnabled = false
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
    @objc func handleRefresh(){
        //if activityIndicator.isAnimating { activityIndicator.stopAnimating() }
        //isRefreshing = true
        self.getProfile()
    }
    
    func getProfile(){
        //service.getUserProfile(pageLoad: "\(dataSource.count)")
        service.getUserProfile(pageLoad: "0")
    }
    private func setupViews(){
        listBtn.tag = 0
        gridBtn.tag = 1
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserListImageCell.Nib, forCellWithReuseIdentifier: UserListImageCell.identifier)
        collectionView.register(PhotoGridCell.Nib, forCellWithReuseIdentifier: PhotoGridCell.identifier)
    }
    
    
    @IBAction func didPressBtn(_ sender: UIButton){
        photoType = sender.tag == 0 ? .list : .grid
    }
    
    func configPictureURL(profileItem: CompanyProfileItem?,dataSource: [PictureURL]){
        //        self.profile = profileItem
        self.datasource = dataSource
    }
    
    func configPictureURL(profileItem: ProfileData?,dataSource: [PictureURL]){
        self.profile = profileItem
        self.datasource = dataSource
    }
    
    
    
}


extension PhotosUserVC : UICollectionViewDelegate{
    
}


extension PhotosUserVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch photoType {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserListImageCell.identifier, for: indexPath) as? UserListImageCell else { return UICollectionViewCell() }
            
            if vcType == .profile {
                cell.configCell(item: datasource[indexPath.item], profileItem: profile)
            } else {
                cell.configCell(item: datasource[indexPath.item], profileItem: companyProfileItem)
            }
            cell.feedImage.isHidden = false
            cell.reportBtn.isHidden = true
            cell.delegate = self
       //     cell.updatedDelegate = self
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridCell.identifier, for: indexPath) as? PhotoGridCell else { return UICollectionViewCell() }
            cell.configCell(datasource[indexPath.item])
          
            cell.delegate = self
            return cell
        }
    }
}

extension PhotosUserVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch photoType {
        case .list:
            let height:CGFloat =  heightForListCell(item: datasource[indexPath.item], width: self.view.frame.width)
            return CGSize(width: self.view.frame.width, height: height+15)
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
            height += 45
        }
        return height
    }
    
    fileprivate func toImageVC(_ indexPath : IndexPath){
        if photoType == .grid{
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoGridCell
            let currentPhoto = datasource[(indexPath as NSIndexPath).row]
            let galleryPreview = INSPhotosViewController(photos: datasource, initialPhoto: currentPhoto, referenceView: cell)
            galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
                if let index = self?.datasource.index(where: {$0 === photo}) {
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
            
            
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            //let screenSize = UIScreen.main.bounds
            if scrollView.contentOffset.y <= 2 {
                self.collectionView.isScrollEnabled = false
                self.scrollView.isScrollEnabled = false
            }
        else
            {
                self.collectionView.isScrollEnabled = true
                self.scrollView.isScrollEnabled = true
            }
            
        }else{
           
            // Dragging up
        }
      
    }
}

extension PhotosUserVC: PhotoGridDelegate{
    func DidTapImageView(cell: PhotoGridCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center){
            toImageVC(indexPath)
        }
    }
}


extension PhotosUserVC{
    static func storyBoardInstance() -> PhotosUserVC? {
        let st = UIStoryboard(name: StoryBoard.PROFILE, bundle: nil)
        return st.instantiateViewController(withIdentifier: PhotosUserVC.id) as? PhotosUserVC
    }
}

extension PhotosUserVC: FeedsDelegate{
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return [FeedV2Item]()
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
            return [FeedItem]()
        }
        set {
            // nothing
        }
    }
//
//
}
extension PhotosUserVC: ProfileServiceDelegate{
    func DidReceiveProfileData(item: ProfileData) {
        
    }
    
    func DidReceiveError(error: String) {
        print("error")
    }
    
    
    func DidReceiveFeedItems(items: [FeedV2Item], pictureItems: [PictureURL]) {
            DispatchQueue.main.async {
                self.dataSourceV2 = items
                self.datasource = pictureItems
                self.collectionView.reloadData()
            }
    }
}

//extension UserProfileVC: UpdatedFeedsDelegate {
//var datasource: [FeedV2Item] {
//    get {
//        print("feedsv2DS : \(dataSourceV2)")
//        return dataSourceV2
//    }
//    set {
//        dataSourceV2 = newValue
//    }
//}
//}
