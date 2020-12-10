//
//  FeedsPOWDetailsVC.swift
//  myscrap
//
//  Created by MyScrap on 7/20/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import IQKeyboardManagerSwift

class FeedsPOWDetailsVC: BaseCVC , FriendControllerDelegate {

    private var isFirstLayout: Bool = false
    let av = UIActivityIndicatorView(style: .whiteLarge)
    
    
    
    private lazy var commentInputView: MSInputView = { [unowned self] in
        let iv = MSInputView()
        iv.delegate = self
        iv.inputTextView.placeholder = "Write a Comment..."
        return iv
        }()
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var inputAccessoryView: UIView?{
        return commentInputView
    }
    
    //fileprivate var feedItem: FeedItem?
    /* API V2.0 */
    fileprivate var feedV2Item: FeedV2Item?
    var commentDataSource = [CommentPOWItem]()
    
    fileprivate var feedService = FeedModel()
    fileprivate var service = DetailService()
    
    fileprivate let commentHeader = "commentHeader"
    
    
    
    var powId = ""
    var notificationId = ""
    
    //    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupCollectionView()
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
            ])
        
        
        if feedV2Item == nil{
            self.activityIndicator.startAnimating()
        }
        getDetails()
        service.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        self.getDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    private func endEditing(){
        
    }
    
    private func setupCollectionView(){
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(CommentCollectionCell.Nib, forCellWithReuseIdentifier: CommentCollectionCell.identifier)
        collectionView?.register(LikesCountCell.Nib, forCellWithReuseIdentifier: LikesCountCell.identifier)
        collectionView?.register(DetailPOWCell.Nib, forCellWithReuseIdentifier: DetailPOWCell.identifier)
        collectionView?.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: commentHeader)
        collectionView?.keyboardDismissMode = .interactive
        let tap = UITapGestureRecognizer(target: self, action: #selector(cvTapped))
        tap.numberOfTapsRequired = 1
        collectionView?.addGestureRecognizer(tap)
    }
    
    
    @objc
    private func cvTapped(){
        commentInputView.inputTextView.resignFirstResponder()
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl){
        if activityIndicator.isAnimating{
            self.activityIndicator.stopAnimating()
        }
        self.getDetails()
    }
    
    fileprivate func getDetails(){
        service.getPOWDetails(powId: powId)
    }
    
    //Insert&Edit comment for company of the month
    func insertComment(comment: String, editId: String? = nil){
        guard let feed = feedV2Item else { return }
        
        if let window = UIApplication.shared.keyWindow {
            let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            window.addSubview(overlay)
            
            av.center = overlay.center
            av.startAnimating()
            overlay.addSubview(av)
            
            service.insertEditPOWComment(powId: powId, commentText: comment, editCommentId: editId) {[weak self] (callbackComment) in
                DispatchQueue.main.async {
                    self?.av.stopAnimating()
                    overlay.removeFromSuperview()
                    if let cmt = callbackComment {
                        self?.commentDataSource = cmt
                        self?.collectionView?.reloadData()
                        self?.collectionView?.scrollToLastItem(animated: false)
                    }
                }
            }
        }
    }
    
    static func controllerInstance(powId: String) -> FeedsPOWDetailsVC {
        let layout = UICollectionViewFlowLayout()
        let vc = FeedsPOWDetailsVC(collectionViewLayout: layout)
        vc.powId = powId
        return vc
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch  section {
        case 0:
            guard let _ = feedV2Item else { return 0 }
            return 1
        case 1:
            if feedV2Item?.likeCount != nil {
                //                let returnNum = feedV2Item?.likeCount
                return 1
            } else {
                return 0
            }
            
        default:
            return commentDataSource.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let item = feedV2Item else { return }
            let vc = LikesController()
            vc.powId = item.powId
            vc.title = "Likes"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let userId = commentDataSource[indexPath.row].userId
            performFriendView(friendId: userId)
        } else {
            print("nothing")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let data = feedV2Item else { return UICollectionViewCell() }
            switch data.cellType{
            case .covidPoll:
                return UICollectionViewCell()
            case .feedImageCell:
                return UICollectionViewCell()
            case .feedImageTextCell:
                return UICollectionViewCell()
            case .feedTextCell:
                return UICollectionViewCell()
            case .feedVideoCell:
                return UICollectionViewCell()
            case .feedVideoTextCell:
                return UICollectionViewCell()
            case .companyMonth:
                return UICollectionViewCell()
            case .personWeek:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPOWCell.identifier, for: indexPath) as? DetailPOWCell else { return UICollectionViewCell()}
                cell.item = data
                cell.updatedDelegate = self
                cell.commentActionBlock = {
                    
                    self.commentInputView.inputTextView.becomeFirstResponder()
                    //self.collectionView?.scrollToLastItem(animated: true)
                }
                return cell
            case .market:
                return UICollectionViewCell()
            case .ads:
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
            case .vote:
                return UICollectionViewCell()
            case .personWeekScroll:
                return UICollectionViewCell()
            case .feedPortrVideoCell:
                return UICollectionViewCell()
            case .feedLandsVideoCell:
                return UICollectionViewCell()
            case .feedPortrVideoTextCell:
                return UICollectionViewCell()
            case .feedLandsVideoTextCell:
                return UICollectionViewCell()
            }
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesCountCell.identifier, for: indexPath) as? LikesCountCell else { return UICollectionViewCell() }
            cell.configCell(item: feedV2Item)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionCell.identifier, for: indexPath) as? CommentCollectionCell else { return UICollectionViewCell()}
            cell.configPOWCell(item: commentDataSource[indexPath.item])
            cell.delegate = self
            return cell
        }
    }
    
    fileprivate func performDetailsController(obj: FeedV2Item){
        
        let vc = FeedsPOWDetailsVC()
        vc.powId = obj.powId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    fileprivate func performLikeVC(obj: FeedV2Item){
        let vc = LikesController()
        vc.powId = obj.powId
        vc.title = "Likes"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension FeedsPOWDetailsVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            guard let item = feedV2Item else { return CGSize.zero }
            let width = view.frame.width
            switch item.cellType{
            case .covidPoll:
                return CGSize(width: 0, height: 0)
            case .feedTextCell:
                return CGSize(width: 0, height: 0)
            case .feedImageCell:
                return CGSize(width: 0, height: 0)
            case .feedImageTextCell:
                return CGSize(width: 0, height: 0)
            case .feedVideoCell:
                return CGSize(width: 0, height: 0)
            case .feedVideoTextCell:
                return CGSize(width: 0, height: 0)
            case .companyMonth:
                return CGSize(width: 0, height: 0)
            case .personWeek:
                let height = FeedsHeight.heightForDetailPersonOfWeekCellV2(item: item, labelWidth: width - 16)  //Aligning width by omitting (leading & trailing)
                return CGSize(width: width, height: height)
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
                return CGSize(width: 0, height: 0)
            case .news:
                return CGSize(width: 0, height: 0)
            case .vote:
                return CGSize(width: 0, height: 0)
            case .personWeekScroll:
                return CGSize(width: 0, height: 0)
            case .feedPortrVideoCell:
                return CGSize(width: 0, height: 0)
            case .feedLandsVideoCell:
                return CGSize(width: 0, height: 0)
            case .feedPortrVideoTextCell:
                return CGSize(width: 0, height: 0)
            case .feedLandsVideoTextCell:
                return CGSize(width: 0, height: 0)
            }
        } else if indexPath.section == 1 {
            
            return CGSize(width: self.view.frame.width, height: 37)
        } else {
            //setting dynamic height for comments
            let height = FeedsHeight.heightForCommentPersonOfWeekCellV2(item: commentDataSource[indexPath.item], labelWidth: self.view.frame.width)
            return CGSize(width: self.view.frame.width, height: height) //changed the static height 87
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 8 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return section == 0 ? 8 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section{
        case 0:
            return UIEdgeInsets.zero
        default:
            return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        }
    }
}
extension FeedsPOWDetailsVC: DetailDelegate{
    func DidReceivePOWDetails(feed: FeedV2Item?, comment: [CommentPOWItem]) {
        DispatchQueue.main.async {
            self.feedV2Item = feed
            self.commentDataSource = comment
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            self.collectionView?.reloadData()
        }
    }
    
    func DidReceiveCMDetails(feed: FeedV2Item?, comment: [CommentCMItem]) {
        DispatchQueue.main.async {
            print("PERson of the week CM will not happen")
        }
    }
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            print("error")
        }
    }
    
    func DidReceiveDetails(feed: FeedV2Item?, members: [MemberItem], comment: [CommentItem]) {
        print("This will not trigger here..")
    }
}
extension FeedsPOWDetailsVC: MSInputViewDelegate{
    func didPressAddButton() {
        
    }
    func  didPressCameraButton() {
        
    }
    func didPressSendButton(with text: String) {
        if AuthStatus.instance.isGuest{
            showGuestAlert()
        } else {
            //For testing purpose commented out
            self.insertComment(comment: text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}

extension FeedsPOWDetailsVC: UpdatedFeedsDelegate{
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return [feedV2Item!]
        }
        set {
            feedV2Item = newValue.first
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView!
    }
    
    
    
    func didTapEditV2(item: FeedV2Item, cell: UICollectionViewCell) {
        print("Edit button Pressed")
    }
}
extension FeedsPOWDetailsVC: CommentCollectionCellDelegate{}
