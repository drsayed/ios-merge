//
//  CompanyTabBarCell.swift
//  myscrap
//
//  Created by MyScrap on 6/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class CompanyTabBarCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var horizontalBar : UIView!
    @IBOutlet weak var horizontalBarWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var horizontalBarleftConstraint: NSLayoutConstraint?
    @IBOutlet weak var scrollView : UIScrollView!
    
    
    fileprivate var identifier = "identifier"
    var titleArray = ["OVERVIEW", "EMPLOYEES", "REVIEWS", "PHOTOS", "INTEREST"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        horizontalBarleftConstraint?.constant = 0
        horizontalBarWidthConstraint?.constant = self.frame.width / CGFloat(titleArray.count)
        setupCollectionView()
    }
    
    func setupCollectionView() {
        scrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TabBarScrollCVCell.self, forCellWithReuseIdentifier: "tabScroll")
        //collectionView.register(TabBarScrollCVCell.self)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count : \(titleArray.count)")
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TabBarScrollCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabScroll", for: indexPath) as! TabBarScrollCVCell
        print("Arra y values : \(titleArray[indexPath.item])")
        cell.label.text = titleArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let xOffset = self.scrollView.frame.width * CGFloat(indexPath.item)
        let point = CGPoint(x: xOffset, y: 0)
        self.scrollView.setContentOffset(point, animated: true)
    }

}
extension CompanyTabBarCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let num = CGFloat(titleArray.count)
        print("Delegate : \(num)")
        return CGSize(width: self.frame.width / num, height: collectionView.frame.height)
    }
}
extension CompanyTabBarCell: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        let num = CGFloat(titleArray.count)
        horizontalBarleftConstraint?.constant = self.scrollView.contentOffset.x / num
        print(self.scrollView.contentOffset)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / self.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}
