//
//  NearFriendsCell.swift
//  myscrap
//
//  Created by MS1 on 10/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
protocol FeedHeaderCellDelegate:class{
    func tappedFriend(friendId: String)
}

final class FeedHeaderCell: UICollectionViewCell {
    
    weak var delegate: FeedHeaderCellDelegate?
    var datasource = [ActiveUsers]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepareForReuse() {
        collectionView.reloadData()
    }
    
}

extension FeedHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearFriendsCell", for: indexPath) as? NearFriendsCell else { return UICollectionViewCell() }
        cell.configFeedHeaderCell(item: datasource[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate{
            let item = datasource[indexPath.item]
            let vc = PhotosVC()
            vc.friendId = item.userid
            UserDefaults.standard.set(item.userid, forKey: "friendId")
            delegate.tappedFriend(friendId: item.userid!)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 70)
    }

}

final class NearFriendsCell: UICollectionViewCell{
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
    @IBOutlet weak var onlineView: onlineView!
    
    
    func configCell(item: ActiveUsers){
        profileView.updateViews(name: item.name!, url: item.profilePic!, colorCode: item.colorCode!)
        if item.moderator == "1" {
            profileTypeView.isHidden = false
            profileTypeView.label.text = "MOD"
            profileTypeView.backgroundColor = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
        } else {
            profileTypeView.isHidden = true
            profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:false, rank:item.rank,isLevel: item.isLevel!, level: item.level!)
        }
        //profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank)
        onlineView.isHidden = !item.online
    }
    func configFeedHeaderCell(item: ActiveUsers) {
        
        profileView.updateViews(name: item.name!, url: item.profilePic!, colorCode: item.colorCode!)
        if item.moderator == "1" {
            profileTypeView.isHidden = false
            profileTypeView.label.text = "MOD"
            profileTypeView.backgroundColor = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
        } else {
            profileTypeView.isHidden = false
            profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:item.newJoined, rank:item.rank,isLevel: item.isLevel!, level: item.level!)
        }
        /*if item.newJoined == true {
            print("User name on scroll : \(item.name)")
            profileTypeView.isHidden = false
            profileTypeView.label.text = "NEW"
            profileTypeView.backgroundColor = UIColor.NEW_COLOR
        }
        if item.moderator == "0" && item.newJoined == false {
            profileTypeView.isHidden = true
        }*/
        profileTypeView.translatesAutoresizingMaskIntoConstraints = false
//                profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: item.isMod, isNew:item.isNew, rank:item.rank)
        onlineView.isHidden = !item.online
    }
}
