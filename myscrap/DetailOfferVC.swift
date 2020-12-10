//
//  DetailOfferVC.swift
//  myscrap
//
//  Created by MyScrap on 7/19/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class DetailListingOfferVC: UIViewController{
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom)
        
        
    }
    
    
    
    
    
    
}
