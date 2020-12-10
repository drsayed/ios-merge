//
//  LandAdExteriorCell.swift
//  myscrap
//
//  Created by MyScrap on 2/2/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

protocol LandAdScrollDelegate : class {
    func didTapAdImage(url: String)
}
class LandAdExteriorCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var adItem = [LAdsItemV2]()
    weak var delegate : LandAdScrollDelegate?
    
    var item : LandingItemsV2?{
        didSet{
            if let item = item?.dataAds{
                adItem = item
                collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextPage (){
        let pageWidth:CGFloat = self.collectionView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.collectionView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        
        self.collectionView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.collectionView.frame.height), animated: true)
    }
}
extension LandAdExteriorCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandAdInteriorCell", for: indexPath) as? LandAdInteriorCell else { return UICollectionViewCell()}
        let url = URL(string: adItem[indexPath.row].AdsImage)
        cell.adImageView.sd_setAnimationImages(with: [url ?? URL(string: "")!])
        
        let imageTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(webUrlTapped(tapGesture:)))
        //tapGesture.delegate = self
        imageTap.numberOfTapsRequired = 1
        cell.adImageView.isUserInteractionEnabled = true
        cell.adImageView.tag = indexPath.row
        cell.adImageView.addGestureRecognizer(imageTap)
        
        cell.pageIndicator.numberOfPages = adItem.count
        cell.pageIndicator.currentPage = indexPath.item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Page indicator : \(indexPath.item)")
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandAdInteriorCell", for: indexPath) as? LandAdInteriorCell
        cell?.pageIndicator.currentPage = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    @objc func webUrlTapped(tapGesture:UITapGestureRecognizer){
        let data = adItem[tapGesture.view!.tag]
        let websiteUrl = data.websiteAds
        
        delegate?.didTapAdImage(url: websiteUrl)
    }
    
    
}
