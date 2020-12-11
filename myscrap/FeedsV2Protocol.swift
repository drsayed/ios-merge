//
//  FeedsV2Protocol.swift
//  myscrap
//
//  Created by MyScrap on 3/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import MessageUI

protocol UpdatedFeedsDelegate : class {
    
    var feedV2Service : FeedV2Model { get }
    
    /* API V2.0*/
    var feedCollectionView: UICollectionView { get }
    var feedsV2DataSource: [FeedV2Item] { get set }
    func didTapLikeV2(item: FeedV2Item,cell: UICollectionViewCell)
    func didTapDetailFeedsLikeV2(item: FeedV2Item, cell: UICollectionViewCell)
    func didTapcommentV2(item: FeedV2Item)
    func didTapFavouriteV2(item: FeedV2Item, cell: UICollectionViewCell)
    func didTapEditV2(item: FeedV2Item,cell: UICollectionViewCell)
    func didTapReportV2(item: FeedV2Item, cell: UICollectionViewCell)
    func didTapLikeCountV2(item: FeedV2Item)
    func didTapUnReportV2(item: FeedV2Item, cell: UICollectionViewCell)
    func didTapContinueReadingV2(item : FeedV2Item, cell: UICollectionViewCell)
    func didTapImageViewV2(atIndex: Int, item: FeedV2Item)
    func didTapEventV2(item: FeedV2Item)
    func didTapEventIntrestBtnV2(item: FeedV2Item)
    func didTapReportModV2(item: FeedV2Item, cell: UICollectionViewCell)
    func didTapForFriendView(id: String)
    func didTap(url: String)
    func didTapWebLinks(url: URL)
    func didTapListing(with id: String, userId: String)
    func didTapCompleteProfile(cell: UICollectionViewCell)
    func didTapClose(cell: UpdateProfileViewCell)
    func didTapShareV2(sender: UIButton, item : FeedV2Item)
    func didTapShareVideoV2(sender: UIButton, item : FeedV2Item)
    func didTapVideoViews(item:FeedV2Item, cell: UICollectionViewCell)
    func didTapDetailVideoViews(item:FeedV2Item, cell: UICollectionViewCell)
    func didTapVideoViewCountV2(item: FeedV2Item)
    
    
    //Company Of the Month
    func didTapCMLikeV2(item:FeedV2Item, cell : UICollectionViewCell)
    func didCMTapLikeCountV2(item: FeedV2Item)//Company of the Month Liked members count
    func didCMTapcommentV2(item: FeedV2Item)
    func didCMTapFavV2(item: FeedV2Item, cell: UICollectionViewCell)
    func didCMTapShareV2(sender: UIButton, item: FeedV2Item)
    func didTapShowLessV2(item: FeedV2Item, cell: PersonOfWeek)
    
    //Person of the Week
    func didTapPOWLikeV2(item:FeedV2Item, cell : UICollectionViewCell)
    func didPOWTapcommentV2(item: FeedV2Item)
    func didPOWTapLikeCountV2(item: FeedV2Item)
    func didPOWTapFavV2(item: FeedV2Item, cell: UICollectionViewCell)
    func didPOWTapShareV2(sender: UIButton, item: FeedV2Item)
    func didTapReadMoreV2(item: FeedV2Item, cell : PersonOfWeek)
    
    
    func didTapDeleteOwnPost(item: FeedV2Item, cell: UICollectionViewCell)
    
    
}
extension UpdatedFeedsDelegate where Self: UIViewController  {
    
    
    /* API V2.0*/
    var feedV2Service : FeedV2Model {
        return FeedV2Model()
    }
    
    /* API V2.0*/
    func didTapLikeV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.likeStatus = !item.likeStatus
            if item.likeStatus{
                
                if item.likeCount == 1 {
                    item.likedByText = "Liked by You and 1 other"
                } else if item.likeCount >= 2 {
                    item.likedByText = "Liked by You and \(item.likeCount) others"
                } else {
                    item.likedByText = "Liked by You"
                }
                item.likeCount += 1
            } else {
                item.likeCount -= 1
                if item.likeCount == 1 {
                    item.likedByText = "Liked by 1 other"
                } else if item.likeCount >= 2 {
                    item.likedByText = "Liked by \(item.likeCount) others"
                } else {
                    item.likedByText = ""
                }
            }
          

            if let portrateCell = feedCollectionView.cellForItem(at: indexPath) as? EmplPortraitVideoCell {
                         
                        let likeCount = String(format: "%d", item.likeCount)
                        portrateCell.likeBtn.setTitle(likeCount, for: .normal)
                        portrateCell.likeImage.isLiked = item.likeStatus
                if item.likeCount == 0 {
                    portrateCell.likeCountBtn.isHidden = true
                } else {
                    portrateCell.likeCountBtn.isHidden = false
                    portrateCell.likeCountBtn.setTitle(item.likedByText, for: .normal)

                }
            }
            else if let portrateCell = feedCollectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell {
                 
                        let likeCount = String(format: "%d", item.likeCount)
                        portrateCell.likeBtn.setTitle(likeCount, for: .normal)
                        portrateCell.likeImage.isLiked = item.likeStatus
                if item.likeCount == 0 {
                    portrateCell.likeCountBtn.isHidden = true
                } else {
                    portrateCell.likeCountBtn.isHidden = false
                    portrateCell.likeCountBtn.setTitle(item.likedByText, for: .normal)

                }
                   
                }
            else if let portrateCell = feedCollectionView.cellForItem(at: indexPath) as? LandScapVideoCell {
                 
                        let likeCount = String(format: "%d", item.likeCount)
                        portrateCell.likeBtn.setTitle(likeCount, for: .normal)
                        portrateCell.likeImage.isLiked = item.likeStatus
                if item.likeCount == 0 {
                    portrateCell.likeCountBtn.isHidden = true
                } else {
                    portrateCell.likeCountBtn.isHidden = false
                    portrateCell.likeCountBtn.setTitle(item.likedByText, for: .normal)

                }
                   
                }
            else if let portrateCell = feedCollectionView.cellForItem(at: indexPath) as? LandScapVideoTextCell {
                 
                        let likeCount = String(format: "%d", item.likeCount)
                        portrateCell.likeBtn.setTitle(likeCount, for: .normal)
                        portrateCell.likeImage.isLiked = item.likeStatus
                if item.likeCount == 0 {
                    portrateCell.likeCountBtn.isHidden = true
                } else {
                    portrateCell.likeCountBtn.isHidden = false
                    portrateCell.likeCountBtn.setTitle(item.likedByText, for: .normal)

                }
                   
                }
            else
            {
                UserDefaults.standard.set(true, forKey: "NoNeedToRrefresh")
                feedCollectionView.reloadItems(at: [indexPath])
                NotificationCenter.default.post(name: Notification.Name("VideoPlayedChanged"), object: nil)

            }
            
            feedCollectionView.collectionViewLayout.invalidateLayout()
          
            feedV2Service.postLike(postId: item.postId, frinedId: item.postedUserId)

        }
        
    }
    
    func didTapVideoViews(item:FeedV2Item, cell: UICollectionViewCell) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            
            //item.viewsCount += 1
            //feedCollectionView.reloadItems(at: [indexPath])
            
            feedV2Service.hitView(postId: item.postId)
        }
    }
    func didTapDetailVideoViews(item:FeedV2Item, cell: UICollectionViewCell) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            feedV2Service.hitView(postId: item.postId)
        }
    }
    
    func didTapDetailFeedsLikeV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest {
            showGuestAlert()
        } else {
            item.likeStatus = !item.likeStatus
            if item.likeStatus{
                item.likeCount += 1
            } else {
                item.likeCount -= 1
            }
            feedV2Service.postLike(postId: item.postId, frinedId: item.postedUserId)
        }
    }
    
    func didTapCMLikeV2(item:FeedV2Item, cell : UICollectionViewCell) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.cmlikeStatus = !item.cmlikeStatus
            if item.cmlikeStatus{
                item.cmlikeCount += 1
                feedCollectionView.reloadItems(at: [indexPath])
                feedV2Service.postCMLike(cmId:item.cmId, likeText: "like")
            } else {
                item.cmlikeCount -= 1
                feedCollectionView.reloadItems(at: [indexPath])
                feedV2Service.postCMLike(cmId:item.cmId, likeText: "dislike")
            }
        }
    }
    func didTapPOWLikeV2(item:FeedV2Item, cell : UICollectionViewCell) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.pwlikeStatus = !item.pwlikeStatus
            if item.pwlikeStatus{
                item.pwlikeCount += 1
                feedCollectionView.reloadItems(at: [indexPath])
                feedV2Service.postPOWLike(powId:item.powId, likeText: "like")
            } else {
                item.pwlikeCount -= 1
                feedCollectionView.reloadItems(at: [indexPath])
                feedV2Service.postPOWLike(powId:item.powId, likeText: "dislike")
            }
            
        }
    }
    
    /* API V2.0*/
    func didTapcommentV2(item: FeedV2Item){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            if item.postType == .eventPost{
                let vc = EventDetailVC()
                vc.eventId = item.eventId
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                performDetailVC(postId: item.postId,item: item)
            }
            
        }
    }
    /* API V2.0 Company of the Month*/
    func didCMTapcommentV2(item: FeedV2Item){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            if item.postType == .eventPost{
                let vc = EventDetailVC()
                vc.eventId = item.eventId
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                performCMDetailVC(cmId: item.cmId)
            }
            
        }
    }
    /* API V2.0 Person of week*/
    func didPOWTapcommentV2(item: FeedV2Item){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            if item.postType == .eventPost{
                let vc = EventDetailVC()
                vc.eventId = item.eventId
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                performPOWDetailVC(powId: item.powId)
            }
            
        }
    }
    /* API V2.0*/
    func didTapFavouriteV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else{
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.isPostFavourited = !item.isPostFavourited
            feedCollectionView.reloadItems(at: [indexPath])
            feedV2Service.postFavourite(postId: item.postId, friendId: item.postedUserId)
        }
    }
    func didCMTapFavV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else{
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.isPostFavourited = !item.isPostFavourited
            feedCollectionView.reloadItems(at: [indexPath])
            feedV2Service.postCMFavourite(cmId: item.cmId)
        }
    }
    func didPOWTapFavV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else{
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.pwisPostFavourited = !item.pwisPostFavourited
            feedCollectionView.reloadItems(at: [indexPath])
            feedV2Service.postPOWFavourite(powId: item.powId)
        }
    }
    //
    
    /* API V2.0*/
    func didTapEditV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest { showGuestAlert() } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { [unowned self] (report) in
                if let vc = EditPostVC.storyBoardReference(){
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
                    }
                    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                    self.present(navBarOnModal, animated: true, completion: nil)
                    //self.feedCollectionView.reloadData()
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { [unowned self] (report) in
                print("DS feeds : \(self.feedsV2DataSource)")
                print("indexpath :\(indexPath.item)")
                dump(self.feedsV2DataSource)
                self.feedsV2DataSource.remove(at: indexPath.item)
                self.feedV2Service.deletePost(postId: item.postId, albumId: item.albumId)
                self.feedCollectionView.performBatchUpdates({
                    self.feedCollectionView.deleteItems(at: [indexPath])
                }, completion: nil)
                self.showToast(message: "Post Deleted")
                self.feedCollectionView.reloadItems(at: [indexPath])
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = UIColor.GREEN_PRIMARY
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func didTapDeleteOwnPost(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest { showGuestAlert() } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { [unowned self] (report) in
                if let vc = EditPostVC.storyBoardReference(){
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
                    }
                    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
                    self.present(navBarOnModal, animated: true, completion: nil)
                    //self.feedCollectionView.reloadData()
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { [unowned self] (report) in
                print("DS feeds : \(self.feedsV2DataSource.count)")
                print("indexpath :\(indexPath.item)")
                dump(self.feedsV2DataSource)
                self.feedV2Service.deletePost(postId: item.postId, albumId: item.albumId)
                self.feedCollectionView.performBatchUpdates({
                    //self.feedCollectionView.deleteItems(at: [indexPath])
                }, completion: nil)
                self.feedsV2DataSource.remove(at: indexPath.item)
                print("DS after delete : \(self.feedsV2DataSource.count)")
                self.showToast(message: "Post Deleted")
                //self.feedCollectionView.reloadItems(at: [indexPath])
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = UIColor.GREEN_PRIMARY
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    /* API V2.0*/
    func didTapReportV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest {
            showGuestAlert()
        } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            print("Ind Path \(indexPath)")
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.view.tintColor = UIColor.GREEN_PRIMARY
            actionSheet.addAction(UIAlertAction(title: "Report Inappropriate Content", style: .destructive, handler: { [weak self] (report) in
                self?.showToast(message: "Post Reported")
                item.isReported = true
                item.reportedUserId = AuthService.instance.userId
                self?.feedCollectionView.reloadItems(at: [indexPath])
                self?.feedV2Service.reportPost(postId: item.postId, friendId: item.postedUserId)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
    

    /* API V2.0*/
    func didTapReportModV2(item: FeedV2Item, cell: UICollectionViewCell) {
        
        if AuthStatus.instance.isGuest {
            showGuestAlert()
        } else {
            let vc = ReportedVC()
            
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            print("Index Path : \(indexPath.item)")
            //let item = UserDefaults.standard.integer(forKey: "indexPath")
            //print("IndexPath : \(item)")
            
            //let dataSource = vc.dataSource
            //let obj = dataSource[(indexPath.item)]
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let unreportAction = UIAlertAction(title: "Undo Report", style: .default) { (action) in
                
                let actionSheet = UIAlertController(title: "Are you sure want to unreport?", message: nil, preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] (report) in
                    self?.showToast(message: "Post Un-Reported")
                    item.isReported = false
                    self?.removeCollectionViewCell(indexPath.item)
                    vc.performUnreport(reportId: item.reportId)
                    print("ReportID \(item.reportId)")
                    //vc.feedCollectionView.reloadData()
                }))
                //actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
                
                
                
            }
            let deletAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.removeCollectionViewCell(indexPath.item)
                self.showToast(message: "Report Deleted Succesfully")
                vc.deletePost(postId: item.postId)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.view.tintColor = UIColor.GREEN_PRIMARY
            alertController.addAction(unreportAction)
            alertController.addAction(deletAction)
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func removeCollectionViewCell(_ i : Int){
        feedCollectionView.performBatchUpdates({
            //let j = i + 1
            
            feedsV2DataSource.remove(at: i)
            let indexPath = IndexPath(item: i, section: 1)
            feedCollectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    func didTapVideoViewCountV2(item: FeedV2Item){
        guard !AuthStatus.instance.isGuest else {
            showGuestAlert()
            return
        }
        var viewCount = ""
        if item.viewsCount >= 2 {
            viewCount = String(format: "%d Views", item.viewsCount)
            performVideoViewListVC(postId: item.postId, viewCount: viewCount)
        } else if item.viewsCount == 1 {
            viewCount = String(format: "%d View", item.viewsCount)
            performVideoViewListVC(postId: item.postId, viewCount: viewCount)
        }
        
    }
    
    /* API V2.0*/
    func didTapLikeCountV2(item: FeedV2Item){
        guard !AuthStatus.instance.isGuest else {
            showGuestAlert()
            return
        }
        var likesCount = ""
        if item.likeCount >= 2 {
            likesCount = String(format: "%d Likes", item.likeCount)
            performLikeVC(for: item.postId, likeCount: likesCount)
        } else if item.likeCount == 1 {
            likesCount = String(format: "%d Like", item.likeCount)
            performLikeVC(for: item.postId, likeCount: likesCount)
        }
        
    }
    //Company of the Month
    func didCMTapLikeCountV2(item: FeedV2Item){
        guard !AuthStatus.instance.isGuest else {
            showGuestAlert()
            return
        }
        var likesCount = ""
        if item.cmlikeCount >= 2 {
            likesCount = String(format: "%d Likes", item.cmlikeCount)
        } else if item.cmlikeCount == 1 {
            likesCount = String(format: "%d Like", item.cmlikeCount)
        }
        performCMLikeVC(for: item.cmId, likeCount: likesCount)
    }
    //Person of week
    func didPOWTapLikeCountV2(item: FeedV2Item){
        guard !AuthStatus.instance.isGuest else {
            showGuestAlert()
            return
        }
        var likesCount = ""
        if item.pwlikeCount >= 2 {
            likesCount = String(format: "%d Likes", item.pwlikeCount)
        } else if item.pwlikeCount == 1 {
            likesCount = String(format: "%d Like", item.pwlikeCount)
        }
        performPOWLikeVC(for: item.powId, likeCount : likesCount)
    }
    /*API V2.0*/
    func didTapShareV2(sender: UIButton, item: FeedV2Item) {
        if AuthStatus.instance.isGuest {
            showGuestAlert()
        } else {
            performShare(sender: sender, postId: item.postId, postedUserId: item.postedUserId)
        }
    }
    
    func didTapShareVideoV2(sender: UIButton, item: FeedV2Item) {
        if AuthStatus.instance.isGuest {
            showGuestAlert()
        } else {
            performVideoShare(sender: sender, postId: item.postId, postedUserId:  item.postedUserId)
        }
    }
    
    func didCMTapShareV2(sender: UIButton, item: FeedV2Item) {
        if AuthStatus.instance.isGuest {
            showGuestAlert()
        } else {
            performCMShare(sender: sender, cmId: item.cmId)
        }
    }
    func didPOWTapShareV2(sender: UIButton, item: FeedV2Item) {
        if AuthStatus.instance.isGuest {
            showGuestAlert()
        } else {
            performPOWShare(sender: sender, powId: item.powId)
        }
    }
    
    /* API V2.0*/
    func didTapUnReportV2(item: FeedV2Item, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else  { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.view.tintColor = UIColor.GREEN_PRIMARY
            actionSheet.addAction(UIAlertAction(title: "Unreport Content", style: .destructive, handler: { [weak self] (report) in
                self?.showToast(message: "Post Unreported")
                item.isReported = false
                item.reportedUserId = ""
                self?.feedCollectionView.reloadItems(at: [indexPath])
                self?.feedV2Service.unReportPost(postId: item.postId, friendId: item.postedUserId, reportId: item.reportId)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    
    /* API V2.0*/
    func didTapContinueReadingV2(item : FeedV2Item, cell: UICollectionViewCell){
        if let indexPath = feedCollectionView.indexPathForItem(at: cell.center) {
            item.isCellExpanded = true

            if let portrateCell = feedCollectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell {
                portrateCell.statusTextView?.attributedText = item.descriptionStatus
                feedCollectionView.collectionViewLayout.invalidateLayout()

                }
            else if let portrateCell = feedCollectionView.cellForItem(at: indexPath) as? LandScapVideoTextCell {
                
                portrateCell.statusTextView?.attributedText = item.descriptionStatus
                feedCollectionView.collectionViewLayout.invalidateLayout()

        }else
            {
                feedCollectionView.performBatchUpdates({
                    self.feedCollectionView.reloadItems(at: [indexPath])
                 }, completion: nil)
            }

        } else {
            print("This is not the center cell")
        }
        
        
    }
    func didTapReadMoreV2(item: FeedV2Item, cell : PersonOfWeek) {
        if let indexPath = feedCollectionView.indexPathForItem(at: cell.center) {
            
            feedCollectionView.performBatchUpdates({
                
                //self.feedCollectionView.reloadItems(at: [indexPath])
                item.isCellExpanded = true
                print("rm button title : \(cell.readMoreBtn.currentTitle!)")
                cell.readMoreBtn.setAttributedTitle(NSAttributedString(string: "Show less...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.MyScrapGreen]), for: .normal)
                print("rm after button title : \(cell.readMoreBtn.currentTitle!)")
                
            }, completion: nil)
            
            
        } else {
            print("Hello read more")
        }
        
    }
    
    func didTapShowLessV2(item: FeedV2Item, cell: PersonOfWeek) {
//        guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
//
//        feedCollectionView.performBatchUpdates({
//            //self.feedCollectionView.reloadItems(at: [indexPath])
//            item.isCellExpanded = false
//        }, completion: nil)
        if let indexPath = feedCollectionView.indexPathForItem(at: cell.center) {
            feedCollectionView.performBatchUpdates({
                print("sl button title : \(cell.readMoreBtn.currentTitle!)")
                item.isCellExpanded = false
                cell.readMoreBtn.setAttributedTitle(NSAttributedString(string: "Read More...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.MyScrapGreen]), for: .normal)
                print("sl after button title : \(cell.readMoreBtn.currentTitle!)")
            }, completion: nil)
        } else {
            print("Hello show less")
        }
        
    }
    
    private func performDetailVC(postId: String,item: FeedV2Item){
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = postId
       // vc.feedV2Item = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func performCMDetailVC(cmId: String) {
        let vc = FeedsCMDetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.cmId = cmId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func performPOWDetailVC(powId: String) {
        let vc = FeedsPOWDetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.powId = powId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func performVideoViewListVC(postId: String, viewCount : String) {
        //Using the existing LikeController for Video View Lists
        let vc = VideoViewsVC()
        vc.title = viewCount
        vc.id = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func performLikeVC(for postId: String, likeCount : String){
        let vc = LikesController()
        vc.title = likeCount
        vc.id = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func performCMLikeVC(for cmId: String, likeCount : String){
        let vc = LikesController()
        vc.title = likeCount
        vc.cmId = cmId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func performPOWLikeVC(for powId: String, likeCount : String){
        let vc = LikesController()
        vc.title = likeCount
        vc.powId = powId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func performShare(sender : UIButton, postId: String, postedUserId: String) {
        let encodedListId = postId.toBase64()
        //let id = Int(listingId)!
        let firstActivityItem = "The product posted in Myscrap, Check out the link below"
        let secondActivityItem : NSURL = NSURL(string: "https://myscrap.com/ms/feedpost/\(encodedListId)")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: [])
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = sender
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
        //Sharing post GET points for owners API linking
        shareLinkPostGetPoints(postId: postId)
    }
    
    func performVideoShare(sender : UIButton, postId: String, postedUserId: String) {
        let encodedListId = postId.toBase64()
        //let id = Int(listingId)!
        NotificationCenter.default.post(name: Notification.Name("SharedOpen"), object: nil)

        let firstActivityItem = "The product posted in Myscrap, Check out the link below"
        let secondActivityItem : NSURL = NSURL(string: "https://myscrap.com/ms/video/\(encodedListId)")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: [])
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in

            if !UserDefaults.standard.bool(forKey: "NONeedToPlay")  {
                NotificationCenter.default.post(name: Notification.Name("SharedClosed"), object: nil)
            }
            else
            {
                UserDefaults.standard.set(false, forKey: "NONeedToPlay")

            }

        }
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]
  
        
        self.present(activityViewController, animated: true, completion: nil)
        //Sharing post GET points for owners API linking
        shareLinkPostGetPoints(postId: postId)
    }
    
    func shareLinkPostGetPoints(postId : String) {
        let api = APIService()
        api.endPoint = Endpoints.POST_LINK_SHARE
        api.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&postId=\(postId)"
        api.getDataWith { (result) in
            switch result{
            case .Success(let json):
                print("Success")
                if let error = json["error"] as? Bool {
                    if !error {
                        let status = json["status"] as? String
                        if  status == "Point added succesfully." {
                            print(" Share post get point for posted user \(status )")
                        }
                    }
                }
            case .Error(let error):
                print("Error :- \(error)")
            }
        }
    }
    
    func performCMShare(sender : UIButton, cmId: String) {
        let encodedListId = cmId.toBase64()
        //let id = Int(listingId)!
        let firstActivityItem = "The product posted in Myscrap, Check out the link below"
        let secondActivityItem : NSURL = NSURL(string: "http://myscrap.com/msmonthcompany/\(encodedListId)")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: [])
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = sender
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    func performPOWShare(sender : UIButton, powId: String) {
        let encodedPOWId = powId.toBase64()
        //let id = Int(listingId)!
        let firstActivityItem = "The product posted in Myscrap, Check out the link below"
        let secondActivityItem : NSURL = NSURL(string: "http://myscrap.com/msweekperson/\(encodedPOWId)")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: [])
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = sender
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    /* API V2.0*/
    func didTapImageViewV2(atIndex:Int, item: FeedV2Item){
        guard !(item.pictureURL.isEmpty) else { return }
        let vc = AlbumVC(index: atIndex, dataSource: item.pictureURL)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil )
    }
    
    func didTap(url: String){
        if url.isValidEmail(){
            if MFMailComposeViewController.canSendMail(){
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([url])
                present(mail, animated: true, completion: nil)
            }
        } else {
            var urlString = url
            if urlString.lowercased().hasPrefix("http://")==false && urlString.lowercased().hasPrefix("https://")==false {
                urlString = "http://".appending(urlString)
            }
            if let urlAddress = URL(string: urlString){
                let safariViewController = SFSafariViewController(url: urlAddress)
                safariViewController.preferredBarTintColor = .MyScrapGreen
                safariViewController.preferredControlTintColor = .WHITE_ALPHA
                present(safariViewController, animated: true, completion: nil)
            }
        }
    }
    
    /* API V2.0*/
    func didTapEventV2(item: FeedV2Item){
        let vc = EventDetailVC()
        vc.eventId = item.eventId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /* API V2.0*/
    func didTapEventIntrestBtnV2(item: FeedV2Item){
        item.isInterested = !item.isInterested
        feedCollectionView.reloadData()
        let service = APIService()
        service.endPoint = Endpoints.BASE_URL + "msInterested"
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&eventId=\(item.eventId)"
        service.getDataWith { result in
        }
    }
    
    func didTapWebLinks(url: URL){
        let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        svc.preferredBarTintColor = UIColor.GREEN_PRIMARY
        self.present(svc, animated: true, completion: nil)
    }
    
    func didTapListing(with id: String, userId: String){
        print(userId, "UserID", id, "Listing ID")
        let vc = DetailListingOfferVC.controllerInstance(with: id, with1: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapCompleteProfile(cell: UICollectionViewCell) {
        let vc = EditProfileController.storyBoardInstance()
        self.navigationController?.pushViewController(vc!, animated: true)
        
        //        if let vc = EditProfileController.storyBoardInstance(){
        //            vc.delegate = self
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    func didTapClose(cell: UpdateProfileViewCell) {
        //cell.isHidden = true
        UserDefaults.standard.set(true, forKey: "closeBtn")
        feedCollectionView.reloadSections(IndexSet(integer: 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1, height: 1)
    }
    
    func cgSize() {
        
    }
}




extension UpdatedFeedsDelegate where Self: FriendControllerDelegate{
    func didTapForFriendView(id: String){
        performFriendView(friendId: id)
    }
}

//extension FeedsDelegate where Self: UpdateProfileViewCellDelegete{
//    func performEditProfile(cell: UICollectionViewCell){
//        didTapCompleteProfile(cell: self)
//    }
//}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

