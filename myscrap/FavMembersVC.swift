//
//  FavMembersVC.swift
//  myscrap
//
//  Created by MS1 on 10/19/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class FavMembersVC: UICollectionViewController, FriendControllerDelegate  {
    
    fileprivate var dataSource = [MemberItem]()
    fileprivate var service = MemmberModel()
    fileprivate var initallyLoaded = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    lazy var refreshControll : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return rf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        service.delegate = self
        service.getFavourites()
        activityIndicator.startAnimating()
        setupCollectionView()
    }

    private func setupCollectionView(){
        collectionView?.register(MemberCell.Nib, forCellWithReuseIdentifier: MemberCell.identifier)
        self.collectionView?.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        collectionView?.refreshControl = refreshControll
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    
    @objc private func refresh(_ sender: UIRefreshControl){
        service.getFavourites()
    }

}


extension FavMembersVC{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        performFriendView(friendId: item.userId)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as? EmptyStateView else { return UICollectionReusableView() }
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        cell.textLbl.text = "NO MEMBERS TO SHOW"
        return cell
    }
   
    
}
extension FavMembersVC{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCell.identifier, for: indexPath) as? MemberCell else { return UICollectionViewCell() }
        cell.configCell(item: dataSource[indexPath.row], isFavourite: true)
        cell.delegate = self
        return cell
    }
}

extension FavMembersVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 114)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return (dataSource.isEmpty && initallyLoaded) ? CGSize(width: self.view.frame.width, height: self.view.frame.height) : CGSize.zero
    }
}

extension FavMembersVC: MemberDelegate{
    func DidReceivedData(data: [MemberItem]) {
        DispatchQueue.main.async {
            self.initallyLoaded = true
            if self.refreshControll.isRefreshing{
                self.refreshControll.endRefreshing()
            }
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            self.dataSource = data
            self.collectionView?.reloadData()
        }
    }
    
    func DidReceivedError(error: String) {
        DispatchQueue.main.async {
            self.initallyLoaded = true
            if self.refreshControll.isRefreshing{
                self.refreshControll.endRefreshing()
            }
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            self.collectionView?.reloadData()
        }
    }
}


extension FavMembersVC:MembersCellDelegate{
    func favouriteBtnPressed(cell: MemberCell) {
//        let reachability = Reachability()!
//        if reachability.connection != .none{
            if let indexPath = collectionView?.indexPathForItem(at: cell.center){
                let item = dataSource[indexPath.item]
                self.collectionView?.performBatchUpdates({
                    self.dataSource.remove(at: indexPath.item)
                    self.collectionView?.deleteItems(at: [indexPath])
                }, completion: nil)
                self.showToast(message: "Removed from Favourites")
                service.postFavourite(friendId: item.userId)
            }
//        } else {
//            self.showToast(message: "Internet not Connected")
//        }
    }
}

