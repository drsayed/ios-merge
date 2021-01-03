
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

protocol FeedsDelegate : class {
    
    var service : FeedModel { get }
    
    var feedCollectionView: UICollectionView { get }
    var feedsDataSource: [FeedItem] { get set }
    func didTapLike(item: FeedItem,cell: UICollectionViewCell)
    func didTapcomment(item: FeedItem)
    func didTapFavourite(item: FeedItem, cell: UICollectionViewCell)
    func didTapEdit(item: FeedItem,cell: UICollectionViewCell)
    func didTapReport(item: FeedItem, cell: UICollectionViewCell)
    func didTapLikeCount(item: FeedItem)
    func didTapUnReport(item: FeedItem, cell: UICollectionViewCell)
    func didTapContinueReading(item : FeedItem, cell: UICollectionViewCell)
    func didTapForFriendView(id: String)
    func didTapImageView(item: FeedItem)
    func didTap(url: String)
    func didTapEvent(item: FeedItem)
    func didTapEventIntrestBtn(item: FeedItem)
    func didTapWebLinks(url: URL)
    
    func didTapListing(with id: String, userId: String)
    func didTapCompleteProfile(cell: UICollectionViewCell)
    func didTapClose(cell: UpdateProfileViewCell)
    func didTapReportMod(item: FeedItem, cell: UICollectionViewCell)
    
}

//extension FeedsDelegate: MFMailComposeViewControllerDelegate{
//
//}

extension FeedsDelegate where Self: UIViewController  {
    
//    @objc
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
    
    var service : FeedModel{
        return FeedModel()
    }
    
    func didTapLike(item: FeedItem, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.likeStatus = !item.likeStatus
            if item.likeStatus{
                item.likeCount += 1
            } else {
                item.likeCount -= 1
            }
            feedCollectionView.reloadItems(at: [indexPath])
            service.postLike(postId: item.postId, frinedId: item.postedUserId)
        }
        
    }
    
    func didTapcomment(item: FeedItem){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            if item.postType == .eventPost{
                let vc = EventDetailVC()
                vc.eventId = item.eventId
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                performDetailVC(postId: item.postId)
            }
            
        }
    }
    
    func didTapFavourite(item: FeedItem, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else{
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.isPostFavourited = !item.isPostFavourited
            feedCollectionView.reloadItems(at: [indexPath])
            service.postFavourite(postId: item.postId, friendId: item.postedUserId)
        }
    }
    
    func didTapEdit(item: FeedItem, cell: UICollectionViewCell){
        if AuthStatus.instance.isGuest { showGuestAlert() } else {
            guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { [unowned self] (report) in
                if let vc = EditPostVC.storyBoardReference(){
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
                self.feedsDataSource.remove(at: indexPath.item)
                self.service.deletePost(postId: item.postId, albumId: item.albumId)
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
    
    func didTapReport(item: FeedItem, cell: UICollectionViewCell){
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
               self?.service.reportPost(postId: item.postId, friendId: item.postedUserId)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func didTapReportMod(item: FeedItem, cell: UICollectionViewCell) {
        
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
            
            feedsDataSource.remove(at: i)
            let indexPath = IndexPath(item: i, section: 0)
            feedCollectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    func didTapLikeCount(item: FeedItem){
        guard !AuthStatus.instance.isGuest else {
            showGuestAlert()
            return
        }
        performLikeVC(for: item.postId)
    }

    
    func didTapUnReport(item: FeedItem, cell: UICollectionViewCell){
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
                   self?.service.unReportPost(postId: item.postId, friendId: item.postedUserId, reportId: item.reportId)
                }))
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func didTapContinueReading(item : FeedItem, cell: UICollectionViewCell){
        guard let indexPath = feedCollectionView.indexPathForItem(at: cell.center) else { return }
            item.isCellExpanded = true
            feedCollectionView.performBatchUpdates({
                self.feedCollectionView.reloadItems(at: [indexPath])
            }, completion: nil)
    }
//    func didTapForFriendView(id: String){
//        if let vc = FriendVC.storyBoardInstance() {
//        vc.friendId = id
//        self.removeBackButtonTitle()
//        UserDefaults.standard.set(id, forKey: "friendId")
//        self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    private func performDetailVC(postId: String){
        let vc = DetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postId = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func performLikeVC(for postId: String){
        let vc = LikesController()
        vc.title = "Likes"
        vc.id = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func performCMLikeVC(for cmId: String){
        let vc = LikesController()
        vc.title = "Likes"
        vc.cmId = cmId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didTapImageView(item: FeedItem){
        guard !(item.pictureURL.isEmpty) else { return }
        let vc = AlbumVC(index: 0, dataSource: item.pictureURL)
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
                present(safariViewController, animated: true, completion: nil)
            }
        }
    }
    
    func didTapEvent(item: FeedItem){
        let vc = EventDetailVC()
        vc.eventId = item.eventId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapEventIntrestBtn(item: FeedItem){
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




extension FeedsDelegate where Self: FriendControllerDelegate{
    func didTapForFriendView(id: String){
        performFriendView(friendId: id)
    }
}

//extension FeedsDelegate where Self: UpdateProfileViewCellDelegete{
//    func performEditProfile(cell: UICollectionViewCell){
//        didTapCompleteProfile(cell: self)
//    }
//}

extension UIViewController : MFMailComposeViewControllerDelegate{
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

