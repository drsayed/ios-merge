//
//  NewUserScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 3/16/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class NewUserScrollCell: BaseCell {

    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userImage: UIImageView!
    var newUserData : [NewUserFeed]!
    var viewAllActionBlock: (() -> Void)? = nil
    var offlineActionBlock : (() -> Void)? = nil
    
     weak var delegate : NewUserDelegate?
    
    var item : FeedV2Item?{
        didSet{
            if let item = item?.datauser{
                newUserData = item
                for data in item {
                    print("new user name : \(data.username)")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(NewUserInsideScrollCell.Nib, forCellWithReuseIdentifier: NewUserInsideScrollCell.identifier)
        userImage.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
    }
    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            viewAllActionBlock?()
        } else {
            offlineActionBlock?()
        }
        
    }
    
}
extension NewUserScrollCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newUserData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewUserInsideScrollCell.identifier, for: indexPath) as? NewUserInsideScrollCell else { return UICollectionViewCell()}
        
        let data = newUserData[indexPath.row]
        let fetched_data = data
        if data.userimage == "https://myscrap.com/style/images/user_profile/" || data.userimage == "" {
            cell.profileView.updateViews(name: data.username, url: data.userimage, colorCode: data.colorcode)
            cell.bigProfileIV.isHidden = true
        } else {
            cell.bigProfileIV.isHidden = false
            //cell.bigProfileIV.sd_setImage(with: URL(string: data.userimage), completed: nil)
            let downloadURL = URL(string: data.userimage)
            SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
                if status{
                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                        cell.bigProfileIV.image = image
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        if let error = error {
                            print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
                            cell.bigProfileIV.isHidden = true
                            cell.profileView.updateViews(name: fetched_data.username, url: fetched_data.userimage, colorCode: fetched_data.colorcode)
                            //cell.bigProfileIV.image = #imageLiteral(resourceName: "no-image")
                        } else {
                            SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                            cell.bigProfileIV.image = image
                        }
                        
                    })
                }
            }
            
        }
        cell.profileType.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:true, rank:nil, isLevel: false, level: nil)
        // MARK:- PROFILE VIEW CONFIGURATION
        
        cell.userNameLbl.text = data.username
        cell.designationLbl.text = data.designation
        if data.company == "" {
            cell.companyLbl.text = "-"
        } else {
            cell.companyLbl.text = data.company
        }
        
        cell.joinedLbl.text = data.joining_date
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 188, height: 279)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if network.reachability.isReachable == true {
            let data = newUserData[indexPath.row]
            delegate?.didTapProfile(userId: (data.userId))
        } else {
            offlineActionBlock?()
        }
    }
}
