//
//  FavouritePostsVC.swift
//  myscrap
//
//  Created by MS1 on 10/19/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices


class FavouritePostsVC: UICollectionViewController, FriendControllerDelegate {
    
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!

    internal var dataSource = [FeedItem]()
    internal var dataSourceV2 = [FeedV2Item]()
    fileprivate var initallyLoaded = false
    
    lazy var refreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return rf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupCollectionView()
        getFeeds()
        activityIndicator.startAnimating()
        
        
    }
    
    fileprivate func getFeeds(){
        fetchFavourite()
    }
    
    @objc private func handleRefresh(_ refresh : UIRefreshControl){
        activityIndicator.stopAnimating()
        fetchFavourite()
    }
    
    private func fetchFavourite(){
        service.fetchFavouritePosts { (result) in
            DispatchQueue.main.async {
                switch result{
                case .Success(let data):
                    self.dataSource = data
                case .Error(_):
                    print("Error Occured")
                }
                self.initallyLoaded = true
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    private func setupCollectionView(){
        //register colleciton
        collectionView?.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        collectionView?.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        collectionView?.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
        collectionView?.register(FeedEventCell.Nib, forCellWithReuseIdentifier: FeedEventCell.identifier)
        self.collectionView?.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        collectionView?.refreshControl = refreshControl
    }
}

extension FavouritePostsVC{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource[indexPath.item]
        switch  item.cellType {
        case .feedTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTextCell.identifier, for: indexPath) as? FeedTextCell else { return UICollectionViewCell()}
            cell.item = dataSource[indexPath.item]
            
            cell.reportBtn.isHidden = true
            cell.delegate = self
            return cell
        case .feedImageCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell() }
            cell.item = dataSource[indexPath.item]
            
            cell.reportBtn.isHidden = true
            return cell
        case .feedImageTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FeedImageTextCell.identifier, for: indexPath) as? FeedImageTextCell else { return UICollectionViewCell()}
            cell.item = dataSource[indexPath.item]
            cell.delegate = self
            
            cell.reportBtn.isHidden = true
            return cell
        case .eventCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FeedEventCell.identifier, for: indexPath) as? FeedEventCell else { return UICollectionViewCell()}
            cell.item = dataSource[indexPath.item]
            cell.delegate = self
            
            cell.reportBtn.isHidden = true
            return cell
            
        case .feedNewUserCell , .newsTextCell, .newsImageCell:
            assert(false, "unexpected Cell")
            return UICollectionViewCell()
        case .feedListingCell:
            assert(false, "unexpected Cell")
            return UICollectionViewCell()
        case .userFeedImageTextCell:
            print("Image text")
            return UICollectionViewCell()
        case .userFeedImageCell:
            print("Image")
            return UICollectionViewCell()
        case .userFeedTextCell:
            print("Text")
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as? EmptyStateView else { return UICollectionReusableView() }
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        cell.textLbl.text = "No Favourite Posts."
        return cell
    }
}






extension FavouritePostsVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        let item = dataSource[indexPath.item]
        switch item.cellType {
        case .feedTextCell:
            let height = FeedsHeight.heightforFeedTextCell(item: item , labelWidth: width - 16)
            return CGSize(width: width , height: height)
        case .feedImageCell:
            let height = FeedsHeight.heightForImageCell(item: item, width: width)
            return CGSize(width: width, height: height)
        case .feedImageTextCell:
            let height = FeedsHeight.heightForImageTextCell(item: item, width: width, labelWidth: width - 16)
            return CGSize(width: width, height: height)
        default:
             return CGSize(width: self.view.frame.width, height: 500)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return (dataSource.isEmpty && initallyLoaded) ? CGSize(width: self.view.frame.width, height: self.view.frame.height) : CGSize(width: self.view.frame.width, height: 0)
    }
}


extension FavouritePostsVC {
    fileprivate func performDetailsController(obj: FeedItem){
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = obj.postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func performLikeVC(obj: FeedItem){
        let vc = LikesController()
        vc.title = "Likes"
        vc.id = obj.postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func gotoFriendView(obj: FeedItem){
        performFriendView(friendId: obj.postedUserId)
    }
    
}




extension FavouritePostsVC: FeedsDelegate{
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return dataSourceV2
        }
        set {
            dataSourceV2 = newValue
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView!
    }
    
    var feedsDataSource: [FeedItem] {
        get {
            return dataSource
        }
        set {
            dataSource = newValue
        }
    }
}

