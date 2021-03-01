//
//  CommudityFooter.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
protocol FeedVCHeaderCellDelegate:class{
    func tappedFriendSeelected(activeuser: ActiveUsers, isLive: Bool)
}

 class FeedVCHeadeer: UICollectionReusableView {
    
    static var liveCount = 0
    weak var delegate: FeedVCHeaderCellDelegate?
    var datasource = [ActiveUsers]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeaderFriendCell.Nib, forCellWithReuseIdentifier: HeaderFriendCell.identifier)
        collectionView.register(LiveFriendCell.Nib, forCellWithReuseIdentifier: LiveFriendCell.identifier)

    }
    
    override func prepareForReuse() {
        collectionView.reloadData()
    }
    func addAnimationIfNeeded()  {
        for videoParentCell in collectionView.visibleCells   {
            if let portrateCell = videoParentCell as? LiveFriendCell {
             portrateCell.addAnimation()
            }
        }
    }
}

extension FeedVCHeadeer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       if let cellAnimation = cell as? LiveFriendCell
        {
            cellAnimation.addAnimation()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = datasource[indexPath.item]
        if item.live! {
            
            let identifire = "LiveFriendCell"
          
     //       self.collectionView.register(LiveFriendCell.Nib, forCellWithReuseIdentifier: identifire)
   
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifire, for: indexPath) as? LiveFriendCell else { return UICollectionViewCell() }
         
            
            cell.configFeedHeaderCell(item: datasource[indexPath.item])
//            cell.addAnimation()
            FeedVCHeadeer.liveCount += 1
            return cell
        }
        else
        {
         
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderFriendCell", for: indexPath) as? HeaderFriendCell else { return UICollectionViewCell() }
         
            
            cell.configFeedHeaderCell(item: datasource[indexPath.item])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate{
            let item = datasource[indexPath.item]
            let vc = PhotosVC()
            vc.friendId = item.userid
            UserDefaults.standard.set(item.userid, forKey: "friendId")
            delegate.tappedFriendSeelected(activeuser:item, isLive: item.live!)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }

}
