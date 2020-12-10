//
//  Land_Market_OverAllCell.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class Land_Market_OverAllCell: BaseCell {
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //var userData : PostedUserData?
    
    weak var delegate : LandMarketScrollDelegate?
    //var item = [LMarketItems]()
    var marketItem : [LMarketItems]!
    var viewAllActionBlock: (() -> Void)? = nil
    
    var item : LandingItems?{
        didSet{
            if let item = item?.data{
                marketItem = item
                collectionView.reloadData()
                /*for lists in fetchedItem {
                    for data in lists.user_data {
                        userData = data
                        print("Listing Id : \(lists.listingId)")
                        //                        configure(viewListing: lists, userData: userData)
                    }
                }*/
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(Land_Market_Scroll.Nib, forCellWithReuseIdentifier: Land_Market_Scroll.identifier)
        
        //collectionView.isScrollEnabled = false
    }
    
    @IBAction func seeAllBtnTapped(_ sender: UIButton) {
        viewAllActionBlock?()
    }
}
extension Land_Market_OverAllCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marketItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Land_Market_Scroll.identifier, for: indexPath) as? Land_Market_Scroll else { return UICollectionViewCell()}
        let market = marketItem[indexPath.row]
        let type = market.listingType
        let imageTitle = market.listingProductName
        let description =  market.description
        let userData = market.user_data.last
        let name = userData!.first_name + " " + userData!.last_name
        let desig = userData?.designation
        
        cell.typeLbl.text = type.uppercased()
        if (userData?.profile_img == "https://myscrap.com/style/images/icons/profile.png" || userData?.profile_img == "https://myscrap.com/style/images/icons/no-profile-pic-female.png") {
            cell.profileImageView.image = #imageLiteral(resourceName: "blank_user")
        } else {
            cell.profileImageView.sd_setImage(with: URL(string: userData!.profile_img), completed: nil)
        }
        cell.titleLbl.text = imageTitle
        cell.descriptionLbl.text = description
        cell.nameLbl.text = name
        cell.designationLbl.text = desig
        
        let downloadURL = URL(string: market.listingImg)
        SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
            if  status {
                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                    cell.listingImgView.image = image
                    cell.spinner.stopAnimating()
                    cell.spinner.isHidden = true
                })
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                    if let error = error {
                        print("Error while downloading : \(error), Status :\(status), url :\(String(describing: downloadURL))")
                        cell.listingImgView.image = #imageLiteral(resourceName: "no-image")
                        cell.spinner.stopAnimating()
                        cell.spinner.isHidden = true
                    } else {
                        SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                        cell.listingImgView.image = image
                        cell.spinner.stopAnimating()
                        cell.spinner.isHidden = true
                    }
                })
            }
        }
        
        //#listing Image
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(marketListing(tapGesture:)))
        //tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        cell.listingImgView.isUserInteractionEnabled = true
        cell.listingImgView.tag = indexPath.row
        cell.listingImgView.addGestureRecognizer(tapGesture)
        
        //#listing title
        let listingTitleTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(marketListing(tapGesture:)))
        //tapGesture.delegate = self
        listingTitleTap.numberOfTapsRequired = 1
        cell.titleLbl.isUserInteractionEnabled = true
        cell.titleLbl.tag = indexPath.row
        cell.titleLbl.addGestureRecognizer(listingTitleTap)
        
        //#listing type
        let listingTypeTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(marketListing(tapGesture:)))
        listingTypeTap.numberOfTapsRequired = 1
        cell.typeLbl.isUserInteractionEnabled = true
        cell.typeLbl.tag = indexPath.row
        cell.typeLbl.addGestureRecognizer(listingTypeTap)
        
        //#listing Description
        let listingDescTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(marketListing(tapGesture:)))
        listingDescTap.numberOfTapsRequired = 1
        cell.descriptionLbl.isUserInteractionEnabled = true
        cell.descriptionLbl.tag = indexPath.row
        cell.descriptionLbl.addGestureRecognizer(listingDescTap)
        
        //#user name label tap
        let userLblTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
        userLblTap.numberOfTapsRequired = 1
        cell.nameLbl.isUserInteractionEnabled = true
        cell.nameLbl.tag = indexPath.row
        cell.nameLbl.addGestureRecognizer(userLblTap)
        
        //#user profile image tap
        let userProfileImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
        userProfileImgTap.numberOfTapsRequired = 1
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.addGestureRecognizer(userProfileImgTap)
        
        //#user designation tap
        let userDesigTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
        userDesigTap.numberOfTapsRequired = 1
        cell.designationLbl.isUserInteractionEnabled = true
        cell.designationLbl.tag = indexPath.row
        cell.designationLbl.addGestureRecognizer(userDesigTap)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 271, height: 184)    //width : 231
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    @objc func marketListing(tapGesture:UITapGestureRecognizer){
        print("Label tag is:\(tapGesture.view!.tag)")
        let userData = marketItem[tapGesture.view!.tag].user_data.last
        print("Market \n \n Listing Id : \(String(describing: marketItem[tapGesture.view!.tag]._listingId)), User Id : \((userData?.user_id)!)")
        delegate?.didTapMarketView(listingId: marketItem[tapGesture.view!.tag]._listingId, userId: (userData?.user_id)!)
    }
    @objc func userDetailsTapped(tapGesture:UITapGestureRecognizer){
        print("Label tag is:\(tapGesture.view!.tag)")
        let userData = marketItem[tapGesture.view!.tag].user_data.last
        delegate?.didTapMUserProfile(userId: (userData?.user_id)!)
    }
}
