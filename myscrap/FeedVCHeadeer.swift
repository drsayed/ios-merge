//
//  CommudityFooter.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
protocol FeedVCHeaderCellDelegate:class{
    func tappedFriendSeelected(friendId: String)
}

 class FeedVCHeadeer: UICollectionReusableView {
    
    weak var delegate: FeedVCHeaderCellDelegate?
    var datasource = [ActiveUsers]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeaderFriendCell.Nib, forCellWithReuseIdentifier: HeaderFriendCell.identifier)

    }
    
    override func prepareForReuse() {
        collectionView.reloadData()
    }
    
}

extension FeedVCHeadeer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderFriendCell", for: indexPath) as? HeaderFriendCell else { return UICollectionViewCell() }
        cell.configFeedHeaderCell(item: datasource[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate{
            let item = datasource[indexPath.item]
            let vc = PhotosVC()
            vc.friendId = item.userid
            UserDefaults.standard.set(item.userid, forKey: "friendId")
            delegate.tappedFriendSeelected(friendId: item.userid!)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }

}
