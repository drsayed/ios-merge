//
//  FavouritesBar.swift
//  myscrap
//
//  Created by MS1 on 10/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit
class FavouritesBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    let cellId = "CellId"
    let titleArray = ["MEMBERS","POST","COMPANY","MODERATOR"]
    var horizontalBarLeftConstraint:NSLayoutConstraint?
    var horizontalBarWidthConstraint:NSLayoutConstraint?
    weak var favouritesVC: FavouriteVC?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    } ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setUpHorizontalBar()
        setupShadow()
    }
    func setupShadow(){
        layer.shadowColor = UIColor(red: UIColor.SHADOW_GRAY, green: UIColor.SHADOW_GRAY, blue: UIColor.SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
    func setupCollectionView(){
        self.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.register(NewsBarCell.self, forCellWithReuseIdentifier: cellId)
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    
    // MARK :- SETTIUP MENU SLIDER ON TOP
    func setUpHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.GREEN_PRIMARY
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalBarView)
        
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue", size: 13)!
        lbl.textColor = UIColor.gray
        lbl.textAlignment = .center
        lbl.text = titleArray.first
        horizontalBarLeftConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        horizontalBarWidthConstraint = horizontalBarView.widthAnchor.constraint(equalToConstant: lbl.intrinsicContentSize.width + 30 )
        horizontalBarWidthConstraint?.isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsBarCell
        cell.label.font = UIFont(name: "HelveticaNeue", size: 13)!
        cell.label.text = titleArray[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  favouritesVC?.scrolltoNewsIndex(index: indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue", size: 13)!
        lbl.textColor = UIColor.gray
        lbl.textAlignment = .center
        lbl.text = titleArray[indexPath.item]
        return CGSize(width: lbl.width, height: self.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

