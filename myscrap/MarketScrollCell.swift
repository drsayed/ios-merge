//
//  MarketScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 3/16/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage


class MarketScrollCell: BaseCell {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var marketImage: UIImageView!
    
    @IBOutlet weak var topViewWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var insiderViewWidth: NSLayoutConstraint!
    var marketItem : [MarketFeed]!
    var userData : PostedUserData?
    var viewAllActionBlock: (() -> Void)? = nil
    var marketActionBlock: (() -> Void)? = nil
    var gomarketActionBlock: (() -> Void)? = nil
    var userActionBlock: (() -> Void)? = nil
    var gouserActionBlock: (() -> Void)? = nil
    var offlineActionBlock : (() -> Void)? = nil
    
    weak var delegate : MarketScrollDelegate?
    
    var item : FeedV2Item?{
        didSet{
            if let item = item?.data{
                marketItem = item
                for lists in item {
                    for data in lists.user_data {
                        userData = data
                        print("Listing Id : \(lists.listingId)")
//                        configure(viewListing: lists, userData: userData)
                    }
                }
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        marketImage.image = UIImage.fontAwesomeIcon(name: .shoppingCart, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(MarketInsideScrollCell.Nib, forCellWithReuseIdentifier: MarketInsideScrollCell.identifier)
        let viewWidth = UIScreen.main.bounds.width
        self.topViewWidthConstraints.constant = UIScreen.main.bounds.width
        self.insiderViewWidth.constant = UIScreen.main.bounds.width
        //collectionView.isScrollEnabled = false
    }

    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            viewAllActionBlock?()
        } else {
            offlineActionBlock?()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .notificationCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .bumpCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .visitorsCountChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userSignedOut, object: nil)
        NotificationCenter.default.removeObserver(self, name: .moderatorChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .profileCountChanged, object: nil)
    }

}
extension MarketScrollCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return (item?.data.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketInsideScrollCell.identifier, for: indexPath) as? MarketInsideScrollCell else { return UICollectionViewCell()}
        
        let market = marketItem[indexPath.row]
        let type = market.listingType
        let quant = market.quantity
        let countryName = market.countryName
        let flagCode = market.flagCode
        let imageTitle = market.listingProductName
        let userData = market.user_data.last
        let name = userData!.first_name + " " + userData!.last_name
        let desig = userData?.designation
        let comp = userData?.company
        
        let lowercase = imageTitle.lowercased()
        let titleCase = lowercase.firstCapitalized
        print("Product name is title case : \(titleCase)")
        cell.feedType.text = titleCase
        
        let attributedString = NSMutableAttributedString(string: type.uppercased() + "  ▶  ", attributes: [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.MyScrapGreen])
        let quantAttrib = NSAttributedString(string: "\(quant) MT", attributes: [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.black])
        attributedString.append(quantAttrib)
        cell.listingTypeLbl.attributedText = attributedString
        
        //cell.listingTypeLbl.text = type.uppercased() + " ▶ "
        
        cell.postedUserProfileIV.updateViews(name: name, url: userData!.profile_img, colorCode: userData!.colorcode)
        cell.userNameLbl.text = name
        if desig == "" {
            cell.designationLbl.text = "-"
        } else {
            cell.designationLbl.text = userData!.designation.uppercased()
        }
        if comp == "" {
            cell.companyLbl.text = "-"
        } else {
            cell.companyLbl.text = comp?.withoutWhitespace()
            
        }
        
        cell.countryLbl.text = countryName
        cell.flagImage.image = UIImage(named: flagCode) ?? nil
        
        let downloadURL = URL(string: marketItem[indexPath.row].listingImg)
        SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
            if status{
                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                    cell.listingImgView.image = image
                })
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                    if let error = error {
                        print("Error while downloading : \(error), Status :\(status), url :\(String(describing: downloadURL))")
                        cell.listingImgView.image = #imageLiteral(resourceName: "no-image")
                    } else {
                        SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                        cell.listingImgView.image = image
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
        cell.countryLbl.isUserInteractionEnabled = true
        cell.countryLbl.tag = indexPath.row
        cell.countryLbl.addGestureRecognizer(listingTitleTap)
        
        let marketViewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(marketListing(tapGesture:)))
        //tapGesture.delegate = self
        marketViewTap.numberOfTapsRequired = 1
        cell.marketView.isUserInteractionEnabled = true
        cell.marketView.tag = indexPath.row
        cell.marketView.addGestureRecognizer(marketViewTap)
        
        //#user name label tap
        let userLblTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
        //tapGesture.delegate = self
        userLblTap.numberOfTapsRequired = 1
        cell.userNameLbl.isUserInteractionEnabled = true
        cell.userNameLbl.tag = indexPath.row
        cell.userNameLbl.addGestureRecognizer(userLblTap)
        
        //#user profile image tap
        let userProfileImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
        //tapGesture.delegate = self
        userProfileImgTap.numberOfTapsRequired = 1
        cell.postedUserProfileIV.isUserInteractionEnabled = true
        cell.postedUserProfileIV.tag = indexPath.row
        cell.postedUserProfileIV.addGestureRecognizer(userProfileImgTap)
        
        //Profile view tap
        let profileViewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
        //tapGesture.delegate = self
        profileViewTap.numberOfTapsRequired = 1
        cell.profileView.isUserInteractionEnabled = true
        cell.profileView.tag = indexPath.row
        cell.profileView.addGestureRecognizer(profileViewTap)
        cell.offlineActionBlock = {
            self.offlineActionBlock?()
        }
        cell.shareBtnAction = { sender in
            print("Show listing id : \(market.listingId)")
            self.delegate?.didShareBtnTapped(sender: sender, listingId: market.listingId, userId: market.userId, image: cell.listingImgView.image!, imageURL: NSURL(string: self.marketItem[indexPath.row].listingImg)!)
        }
        
        //collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 165, height: 256)    //187.5 h : 279
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth : CGFloat = 165.0
        
        let numberOfCells = floor(self.insideView.frame.size.width / cellWidth)
        let edgeInsets = (self.insideView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        
        return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
        
    }*/
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if (context.nextFocusedIndexPath != nil) && !collectionView.isScrollEnabled {
            collectionView.scrollToItem(at: context.nextFocusedIndexPath!, at: .centeredHorizontally, animated: true)
        }
    }
    @objc func marketListing(tapGesture:UITapGestureRecognizer){
        if network.reachability.isReachable == true {
            print("Label tag is:\(tapGesture.view!.tag)")
            let userData = marketItem[tapGesture.view!.tag].user_data.last
            print("Market \n \n Listing Id : \(String(describing: marketItem[tapGesture.view!.tag]._listingId)), User Id : \((userData?.user_id)!)")
            delegate?.didTapMarketView(listingId: marketItem[tapGesture.view!.tag]._listingId, userId: (userData?.user_id)!)
        } else {
            offlineActionBlock?()
        }
    }
    @objc func userDetailsTapped(tapGesture:UITapGestureRecognizer){
        if network.reachability.isReachable == true {
            print("Label tag is:\(tapGesture.view!.tag)")
            let userData = marketItem[tapGesture.view!.tag].user_data.last
            delegate?.didTapUserProfile(userId: (userData?.user_id)!)
        } else {
            offlineActionBlock?()
        }
    }
}
