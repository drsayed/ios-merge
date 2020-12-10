//
//  FavouriteVC.swift
//  myscrap
//
//  Created by MS1 on 10/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class FavouriteVC: BaseRevealVC {
    
    fileprivate var identifier = "identifier"
    var titleArray = ["MEMBERS", "POST" , "COMPANY" , "MODERATOR" ]

    @IBOutlet weak var horizontalBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var horizontalBarWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var horizontalBarleftConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        horizontalBarleftConstraint?.constant = 0
        horizontalBarWidthConstraint?.constant = self.view.frame.width / CGFloat(titleArray.count)
        setupCollectionView()
    }
    private func setupCollectionView(){
        scrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NewsBarCell.self, forCellWithReuseIdentifier: "identifier")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
 
    
}
extension FavouriteVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? NewsBarCell else {return UICollectionViewCell() }
        cell.label.text = titleArray[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
}

extension FavouriteVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let num = CGFloat(titleArray.count)
        return CGSize(width: self.view.frame.width / num, height: collectionView.frame.height)
    }
}

extension FavouriteVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let xOffset = self.scrollView.frame.width * CGFloat(indexPath.item)
        let point = CGPoint(x: xOffset, y: 0)
        self.scrollView.setContentOffset(point, animated: true)
    }
}

extension FavouriteVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        let num = CGFloat(titleArray.count)
        horizontalBarleftConstraint?.constant = self.scrollView.contentOffset.x / num
        print(self.scrollView.contentOffset)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}


