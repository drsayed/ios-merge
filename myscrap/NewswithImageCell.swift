//
//  NewswithImageCell.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class NewswithImageCell: NewsTextCell {
    fileprivate let identifier = "identifier"
    fileprivate  var pictureURL = [PictureURL]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var leftView : LeftSliderView!
    @IBOutlet weak var rightView: RightSliderView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func configCell(item: FeedItem) {
        super.configCell(item: item)
        pictureURL = item.pictureURL
        collectionView.reloadData()
        pageControl.numberOfPages = pictureURL.count
    }
    
    private func setupViews(){
        setupSliderViews()
        setupCollectionView()
        setupPageControl()
    }

    private func setupSliderViews(){
        if pictureURL.count == 0 {
            self.leftView.isHidden = true
            self.rightView.isHidden = true
        }
    }
    
    private func setupCollectionView(){
//        collectionView.register(SliderCell.self, forCellWithReuseIdentifier: identifier)
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumLineSpacing = 0
//            layout.minimumInteritemSpacing = 0
//            layout.scrollDirection = .horizontal
//        }
    }
    
    private func setupPageControl(){
        pageControl.numberOfPages = pictureURL.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.GREEN_PRIMARY
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let pageWidth = scrollView.frame.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = currentPage
        }
    }
}

extension NewswithImageCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) // as! SliderCell
//        if let url = URL(string: pictureURL[indexPath.item].images) {
//            cell.imageView.sd_setImage(with: url, completed: nil)
//        } else {
//            cell.imageView.image = nil
//        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURL.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.PerformDetailNews(cell: self)
    }
}

extension NewswithImageCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
