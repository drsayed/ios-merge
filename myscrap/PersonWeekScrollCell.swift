//
//  PersonWeekScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 8/4/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class PersonWeekScrollCell: BaseCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var viewAllActionBlock: (() -> Void)? = nil
    var offlineActionBlock : (() -> Void)? = nil
    
    var powItem : [POWScrollFeed]!
    
    weak var delegate : POWScrollDelegate?
    
    var item : FeedV2Item?{
        didSet{
            if let item = item?.powScrollData{
                powItem = item
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(PersonWeekInsideScroll.Nib, forCellWithReuseIdentifier: PersonWeekInsideScroll.identifier)
    }
    
    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        viewAllActionBlock?()
    }

}
extension PersonWeekScrollCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("POW Scroll array count : \(item?.powScrollData.count)")
        return (item?.powScrollData.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonWeekInsideScroll.identifier, for: indexPath) as? PersonWeekInsideScroll else { return UICollectionViewCell()}
        
        let pow = powItem[indexPath.row]
       
        cell.powName.text = pow.name
        cell.viewBio.text = "▶ View Details"
        cell.designationLbl.text = pow.designation + ", " + pow.userCompany + ","
        cell.countryLbl.text = pow.country
        
        //        let colorCode = userData?.colorcode
        //        let initials = name.initials()
        let downloadURL = URL(string: pow.bannerImage)
        
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
            if let error = error {
                print("Error while downloading : \(error), Status :\(status), url :\(String(describing: downloadURL))")
                cell.powImageView.image = #imageLiteral(resourceName: "no-image")
                cell.spinner.stopAnimating()
                cell.spinner.isHidden = true
            } else {
                SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                cell.powImageView.image = image
                cell.spinner.stopAnimating()
                cell.spinner.isHidden = true
            }
        })
        
        cell.offlineActionBlock = {
            self.offlineActionBlock?()
        }
        cell.shareBtnAction = { sender in
            print("Show pow id : \(pow.powId)")
            self.delegate?.didShareBtnTapped(sender: sender, powId: pow.powId)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let powId = (item?.powScrollData[indexPath.item].powId)!
        print("Pow ID : \(powId)")
        delegate?.didTapPOWView(powId: powId, userId: "")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 185, height: 218)    //187.5 h : 188
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

