//
//  BasementTopCell.swift
//  myscrap
//
//  Created by MyScrap on 4/6/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class BasementTopCell: BaseCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(OnlineMembersCell.Nib, forCellWithReuseIdentifier: OnlineMembersCell.identifier)
    }
    
}
extension BasementTopCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnlineMembersCell.identifier, for: indexPath) as? OnlineMembersCell else { return UICollectionViewCell()}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 150, height: 50)
    }
    
}
