//
//  LikesVC.swift
//  myscrap
//
//  Created by MS1 on 10/28/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

/*

import UIKit

class LikesVC: BaseVC, FriendControllerDelegate {
    
    enum MemberType{
        case postLike
        case none
    }
    
    fileprivate var dataSource = [MemberItem]()
    fileprivate var id = ""
    fileprivate var postId = ""
    fileprivate var postedUserId: String?
    fileprivate var memberType: MemberType = .postLike
    fileprivate let service = DetailService()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        print("Modaaa id" , id)
        service.delegate = self
    }
    
    private func setupViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MemberCell.Nib, forCellWithReuseIdentifier: MemberCell.identifier)
        collectionView.refreshControl = refreshControl
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.isEmpty{
            activityIndicator.startAnimating()
        }
        getData()
    }
    
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        getData()
    }
    
    private func getData(){
        service.getLikes(postedUserId: id, postId: postId)
    }
    
    fileprivate func updateCollectionView(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        collectionView.reloadData()
    }
    
    func receivingData(dataSource: [MemberItem]?, id: String, type: MemberType,postId: String){
        if let item = dataSource{
            self.dataSource = item
        }
        self.postId = postId
        self.id = id
        self.memberType = type
        switch type {
        case .postLike:
            self.navigationItem.title = "Likes"
        default:
            self.navigationItem.title = ""
        }
    }
    
}

extension LikesVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       performFriendView(friendId: dataSource[indexPath.item].userId)
    }
}

extension LikesVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCell.identifier, for: indexPath) as! MemberCell
        cell.configLike(item: dataSource[indexPath.item])
        return cell
    }
}

extension LikesVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 114)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension LikesVC: DetailDelegate{
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            //todo:- show error
        }
    }
    
    func DidReceiveDetails(feed: FeedItem?, members: [MemberItem], comment: [CommentItem]) {
        DispatchQueue.main.async {
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            self.dataSource = members
            self.collectionView.reloadData()
        }
    }
    
    
    static func storyBoardInstance() -> LikesVC? {
        let storyboard = UIStoryboard(name: StoryBoard.COMMENT, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: LikesVC.id) as? LikesVC
    }
    
}
*/
