//
//  StoriesCVCell.swift
//  myscrap
//
//  Created by MyScrap on 2/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

protocol StoriesListingCell: class {
    func didTap(cell: MylistingCell)
    func didTapViewMore(cell: MylistingCell)
}

final class StoriesFeedsCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var watchAllBtn: UIButton!
    weak var delegate: StoriesModelDelegate?
    var datasource = [StoriesList]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func watchAllBtnTapped(_ sender: UIButton) {
        
    }
    
}

extension StoriesFeedsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoriesCVCell", for: indexPath) as? StoriesCVCell else { return UICollectionViewCell() }
        cell.configure(with: datasource[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 282, height: 172)
    }

    
}

final class StoriesCVCell: UICollectionViewCell{
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var subCategoryLbl: UILabel!
    @IBOutlet weak var curveView: UIView!
    
    
    
    var storyData: StoriesList?{
        didSet {
            if let item = storyData{
                configure(with: item)
            }
        }
    }
    
    override func awakeFromNib() {
        storyImageView.layer.borderWidth = 0.1
        curveView.layer.cornerRadius = 20
        curveView.layer.borderWidth = 0.1
        curveView.layer.borderColor = UIColor.black.cgColor
        curveView.layer.shadowColor = UIColor.black.cgColor
        curveView.layer.shadowOffset = CGSize.zero
        curveView.layer.shadowOpacity = 1
        curveView.layer.shadowRadius = 10
        curveView.layer.masksToBounds = true
    }
    
    func configure(with item: StoriesList){
        let attrString = NSAttributedString(string: "\(item.title)", attributes: [NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeWidth: -2.0, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
        storyLabel.attributedText = attrString
        storyImageView.sd_setImage(with: URL(string: item.blogImage), placeholderImage: #imageLiteral(resourceName: "no-image"), options: .refreshCached, completed: nil)
        categoryLbl.text = ""
        subCategoryLbl.text = "Read More"
        
    }
    
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        
    }
}
