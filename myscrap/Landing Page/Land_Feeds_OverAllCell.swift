//
//  Land_Feeds_OverAllCell.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

protocol LandFeedsDelegate : class {
    func didTapSeeAll()
    func didTapFUserProfile(userId : String)
    func didTapFeedsData(postId: String)
    func triggerGuestAlert()
    func didTapLikeOrComment(postId: String)
    func didTap(url: String)
}
class Land_Feeds_OverAllCell: BaseCell {
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageIndicator: LandPageControl!
    
    var feedsItem : [LFeedsItem]!
    weak var delegate : LandFeedsDelegate?
    var service = LandingService()
    
    var item : LandingItems?{
        didSet{
            if let item = item?.dataFeeds{
                feedsItem = item
                print("Feeds Item : \(feedsItem)")
                collectionView.reloadData()
            }
            /*if let fetchedItem = item{
                print("Feeds Item : \(fetchedItem)")
                feedsItem = fetchedItem
            }*/
        }
    }
    //var item = [LFeedsItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(Land_Feeds_TextCell.Nib, forCellWithReuseIdentifier: Land_Feeds_TextCell.identifier)
        collectionView.register(Land_Feeds_ImageCell.Nib, forCellWithReuseIdentifier: Land_Feeds_ImageCell.identifier)
        collectionView.register(Land_Feeds_ImageTextCell.Nib, forCellWithReuseIdentifier: Land_Feeds_ImageTextCell.identifier)
        
        /*collectionView.layer.cornerRadius = 10.0
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.clear.cgColor
        collectionView.layer.masksToBounds = true
        
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        collectionView.layer.shadowRadius = 6.0
        collectionView.layer.shadowOpacity = 1.0
        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: collectionView.layer.cornerRadius).cgPath
        collectionView.layer.backgroundColor = UIColor.clear.cgColor*/
        
    }
    
    @IBAction func seeAllBtnTapped(_ sender: UIButton) {
        self.delegate?.didTapSeeAll()
    }
}
extension Land_Feeds_OverAllCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Feeds count : \(item?.dataFeeds.count)")
        pageIndicator.pages = (item?.dataFeeds.count)!
        //pageControl.numberOfPages = item.count
        return (item?.dataFeeds.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data  = item!.dataFeeds[indexPath.item]
        print("Initialized cell type : \(data.cellType)")
        switch data.cellType{
        case .landFeedTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Land_Feeds_TextCell.identifier, for: indexPath) as? Land_Feeds_TextCell else { return UICollectionViewCell()}
            collectionView.reloadItems(at: [indexPath])
            let statusText = data.status
            if (data.profilePic == "") {
                cell.profileImageView.image = #imageLiteral(resourceName: "blank_user")
            } else {
                cell.profileImageView.sd_setImage(with: URL(string: data.profilePic), completed: nil)
            }
            
            
            if statusText.contains("http") {
                cell.statusTextLbl.attributedText = data.textStatus
            } else {
                //cell.statusTextLbl.text = statusText
                cell.statusTextLbl.attributedText = data.textStatus
            }
            
            cell.desgCompLbl.text = data.userCompany == "" ? data.postedUserDesignation : "\(data.postedUserDesignation) • \(data.userCompany)"
            cell.userNameLbl.text = data.postedUserName
            cell.postTimeLbl.text = data.timeStamp
            
            cell.likeBtn.isLiked = data.likeStatus
            //cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + "•" + String(format: "%d", data.commentCount)
            
            let likeCountStr = String(format: "%d", data.likeCount)
            let commCountStr = String(format: "%d", data.commentCount)
            
            if data.likeCount != 0 && data.commentCount != 0 {
                if data.likeCount >= 2 && data.commentCount >= 2{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes • " + String(format: "%d", data.commentCount) + " Comments"
                } else if data.likeCount == 1 && data.commentCount == 1{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like • " + String(format: "%d", data.commentCount) + " Comment"
                } else if data.likeCount >= 2 && data.commentCount == 1{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes • " + String(format: "%d", data.commentCount) + " Comment"
                } else if data.likeCount == 1 && data.commentCount >= 2{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like • " + String(format: "%d", data.commentCount) + " Comments"
                }
            } else if data.likeCount <= 0 && data.commentCount <= 0 {
                cell.likesCmntLbl.text = ""
            } else if data.likeCount != 0 && data.commentCount <= 0{
                if data.likeCount == 1 {
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like"
                } else {
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes"
                }
            } else if data.likeCount <= 0 && data.commentCount != 0 {
                if data.commentCount == 1 {
                    cell.likesCmntLbl.text = String(format: "%d", data.commentCount) + " Comment"
                } else {
                    cell.likesCmntLbl.text = String(format: "%d", data.commentCount) + " Comments"
                }
            } else {
                print("Unexpected case in Text cell")
            }
            
            if data.userLike.count >= 1 && data.userLike.count >= 1{
                
            } 
            cell.userLike = data.userLike
            if data.userLike != [] && data.userComment != []{
                if data.userLike.count == 3 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    let thirdImg = data.userLike[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeSpacing.constant = 4
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                } else if data.userLike.count == 2 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 13
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                } else if data.userLike.count == 1 {
                    let firstImg = data.userLike[0]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 22
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                }
            } else if data.userLike == [] && data.userComment != [] {
                if data.userComment.count == 3 {
                    let firstImg = data.userComment[0]
                    let secondImg = data.userComment[1]
                    let thirdImg = data.userComment[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeSpacing.constant = 4
                } else if data.userComment.count == 2 {
                    let firstImg = data.userComment[0]
                    let secondImg = data.userComment[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 13
                } else if data.userComment.count == 1 {
                    let firstImg = data.userComment[0]
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 22
                }
            } else if data.userLike != [] && data.userComment == [] {
                if data.userLike.count == 3 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    let thirdImg = data.userLike[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeSpacing.constant = 4
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                } else if data.userLike.count == 2 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 13
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                    
                } else if data.userLike.count == 1 {
                    let firstImg = data.userLike[0]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 22
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                }
            } else if data.userLike == [] && data.userComment == [] {
                cell.firstLikeWidth.constant = 0
                cell.secondLikeWidth.constant = 0
                cell.thirdLikeWidth.constant = 0
                cell.likeSpacing.constant = 4
                
                cell.firstLikeIV.isHidden = true
                cell.secondLikeIV.isHidden = true
                cell.thirdLikeIV.isHidden = true
                print("Empty array nothing to show for comment & like")
            }
            else {
                cell.firstLikeWidth.constant = 0
                cell.secondLikeWidth.constant = 0
                cell.thirdLikeWidth.constant = 0
                cell.likeSpacing.constant = 4
                
                cell.firstLikeIV.isHidden = true
                cell.secondLikeIV.isHidden = true
                cell.thirdLikeIV.isHidden = true
                print("Both like and comment array is empty")
            }
            
            cell.likeBtnAction = { sender in
                if AuthStatus.instance.isGuest{
                    self.delegate?.triggerGuestAlert()
                } else {
                    data.likeStatus = !data.likeStatus
                    if data.likeStatus{
                        data.likeCount += 1
                        if AuthService.instance.profilePic == "" {
                            let profile = "https://myscrap.com/style/images/icons/no-profile-pic-female.png"
                            if data.userLike.count == 3 {
                                //data.userLike.insert(AuthService.instance.profilePic, at: 2)
                                data.userLike[2] = profile
                            } else if data.userLike.count == 2 {
                                data.userLike.insert(profile, at: 2)
                            } else if data.userLike.count == 1 {
                                print("I'm here...")
                                data.userLike.insert(profile, at: 1)
                            } else {
                                data.userLike.insert(profile, at: 0)
                            }
                        } else {
                            if data.userLike.count == 3 {
                                //data.userLike.insert(AuthService.instance.profilePic, at: 2)
                                data.userLike[2] = AuthService.instance.profilePic
                            } else if data.userLike.count == 2 {
                                data.userLike.insert(AuthService.instance.profilePic, at: 2)
                            } else if data.userLike.count == 1 {
                                print("I'm here...")
                                data.userLike.insert(AuthService.instance.profilePic, at: 1)
                            } else {
                                data.userLike.insert(AuthService.instance.profilePic, at: 0)
                            }
                        }
                        
                    } else {
                        data.likeCount -= 1
                        if AuthService.instance.profilePic == "" {
                            let profile = "https://myscrap.com/style/images/icons/no-profile-pic-female.png"
                            if data.userLike.count == 3 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(profile) {
                                    data.userLike.remove(at: 1)
                                } else if data.userLike[2].contains(profile){
                                    data.userLike.remove(at: 2)
                                } else {
                                    print("No profile is there to remove")
                                }
                            } else if data.userLike.count == 2 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(profile) {
                                    data.userLike.remove(at: 1)
                                }
                            } else if data.userLike.count == 1 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                }
                            } else {
                                print("No like count fetched")
                            }
                        } else {
                            if data.userLike.count == 3 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 1)
                                } else if data.userLike[2].contains(AuthService.instance.profilePic){
                                    data.userLike.remove(at: 2)
                                } else {
                                    print("No profile is there to remove")
                                }
                            } else if data.userLike.count == 2 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 1)
                                }
                            } else if data.userLike.count == 1 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                }
                            } else {
                                print("No like count fetched")
                            }
                        }
                    }
                    
                    self.service.postLike(postId: data.postId, frinedId: data.postedUserId)
                    collectionView.reloadItems(at: [indexPath])
                    cell.likeBtn.isLiked = data.likeStatus
                }
            }
            
            //Tap gesture
            let userLblTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
            //tapGesture.delegate = self
            userLblTap.numberOfTapsRequired = 1
            cell.userNameLbl.isUserInteractionEnabled = true
            cell.userNameLbl.tag = indexPath.row
            cell.userNameLbl.addGestureRecognizer(userLblTap)
            
            let userProfileImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
            //tapGesture.delegate = self
            userProfileImgTap.numberOfTapsRequired = 1
            cell.profileImageView.isUserInteractionEnabled = true
            cell.profileImageView.tag = indexPath.row
            cell.profileImageView.addGestureRecognizer(userProfileImgTap)
            
            let feedViewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(detailFeedsTapped(tapGesture:)))
            feedViewTap.numberOfTapsRequired = 1
            cell.statusView.isUserInteractionEnabled = true
            cell.statusView.tag = indexPath.row
            cell.statusView.addGestureRecognizer(feedViewTap)
            
            if data.status.contains("http") {
                let feedURLTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(urlTapped(tapGesture:)))
                feedURLTap.numberOfTapsRequired = 1
                cell.statusTextLbl.isUserInteractionEnabled = true
                cell.statusTextLbl.tag = indexPath.row
                cell.statusTextLbl.addGestureRecognizer(feedURLTap)
            }
            
            let likefImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likefImgTap.numberOfTapsRequired = 1
            cell.firstLikeIV.isUserInteractionEnabled = true
            cell.firstLikeIV.tag = indexPath.row
            cell.firstLikeIV.addGestureRecognizer(likefImgTap)
            
            let likeSImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeSImgTap.numberOfTapsRequired = 1
            cell.secondLikeIV.isUserInteractionEnabled = true
            cell.secondLikeIV.tag = indexPath.row
            cell.secondLikeIV.addGestureRecognizer(likeSImgTap)
            
            let likeTImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeTImgTap.numberOfTapsRequired = 1
            cell.thirdLikeIV.isUserInteractionEnabled = true
            cell.thirdLikeIV.tag = indexPath.row
            cell.thirdLikeIV.addGestureRecognizer(likeTImgTap)
            
            let likeTextTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeTextTap.numberOfTapsRequired = 1
            cell.likesCmntLbl.isUserInteractionEnabled = true
            cell.likesCmntLbl.tag = indexPath.row
            cell.likesCmntLbl.addGestureRecognizer(likeTextTap)
            
            return cell
        case .landFeedImageCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Land_Feeds_ImageCell.identifier, for: indexPath) as? Land_Feeds_ImageCell else { return UICollectionViewCell()}
            
            let downloadURL = URL(string: data.postedImage)
            SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
                if  status {
                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                        cell.feedsImageView.image = image
                        cell.spinner.stopAnimating()
                        cell.spinner.isHidden = true
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        if let error = error {
                            print("Error while downloading : \(error), Status :\(status), url :\(String(describing: downloadURL))")
                            cell.feedsImageView.image = #imageLiteral(resourceName: "no-image")
                            cell.spinner.stopAnimating()
                            cell.spinner.isHidden = true
                        } else {
                            SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                            cell.feedsImageView.image = image
                            cell.spinner.stopAnimating()
                            cell.spinner.isHidden = true
                        }
                    })
                }
            }
            
            
            //cell.feedsImageView.sd_setImage(with: URL(string: data.postedImage), completed: nil)
            cell.desgCompLbl.text = data.userCompany == "" ? data.postedUserDesignation : "\(data.postedUserDesignation) • \(data.userCompany)"
            if (data.profilePic == "") {
                cell.profileImageView.image = #imageLiteral(resourceName: "blank_user")
            } else {
                cell.profileImageView.sd_setImage(with: URL(string: data.profilePic), completed: nil)
            }
            
            cell.userNameLbl.text = data.postedUserName
            cell.postTimeLbl.text = data.timeStamp
            
            cell.likeBtn.isLiked = data.likeStatus
            if data.likeCount != 0 && data.commentCount != 0 {
                if data.likeCount >= 2 && data.commentCount >= 2{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes • " + String(format: "%d", data.commentCount) + " Comments"
                } else if data.likeCount == 1 && data.commentCount == 1{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like • " + String(format: "%d", data.commentCount) + " Comment"
                } else if data.likeCount >= 2 && data.commentCount == 1{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes • " + String(format: "%d", data.commentCount) + " Comment"
                } else if data.likeCount == 1 && data.commentCount >= 2{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like • " + String(format: "%d", data.commentCount) + " Comments"
                }
            } else if data.likeCount <= 0 && data.commentCount <= 0 {
                cell.likesCmntLbl.text = ""
            } else if data.likeCount != 0 && data.commentCount <= 0{
                if data.likeCount == 1 {
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like"
                } else {
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes"
                }
            } else if data.likeCount <= 0 && data.commentCount != 0 {
                if data.commentCount == 1 {
                    cell.likesCmntLbl.text = String(format: "%d", data.commentCount) + " Comment"
                } else {
                    cell.likesCmntLbl.text = String(format: "%d", data.commentCount) + " Comments"
                }
            } else {
                print("Unexpected case in Image cell")
            }
            
            if data.userLike != [] && data.userComment != []{
                if data.userLike.count == 3 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    let thirdImg = data.userLike[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeSpacing.constant = 4
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                } else if data.userLike.count == 2 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 13
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                } else if data.userLike.count == 1 {
                    let firstImg = data.userLike[0]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 22
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                }
            } else if data.userLike == [] && data.userComment != [] {
                if data.userComment.count == 3 {
                    let firstImg = data.userComment[0]
                    let secondImg = data.userComment[1]
                    let thirdImg = data.userComment[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeSpacing.constant = 4
                } else if data.userComment.count == 2 {
                    let firstImg = data.userComment[0]
                    let secondImg = data.userComment[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 13
                } else if data.userComment.count == 1 {
                    let firstImg = data.userComment[0]
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 22
                }
            } else if data.userLike != [] && data.userComment == [] {
                if data.userLike.count == 3 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    let thirdImg = data.userLike[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeSpacing.constant = 4
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                } else if data.userLike.count == 2 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 13
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                    
                } else if data.userLike.count == 1 {
                    let firstImg = data.userLike[0]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeSpacing.constant = 22
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                }
            } else if data.userLike == [] && data.userComment == [] {
                cell.firstLikeWidth.constant = 0
                cell.secondLikeWidth.constant = 0
                cell.thirdLikeWidth.constant = 0
                cell.likeSpacing.constant = 4
                
                cell.firstLikeIV.isHidden = true
                cell.secondLikeIV.isHidden = true
                cell.thirdLikeIV.isHidden = true
                print("Empty array nothing to show for comment & like")
            }
            else {
                cell.firstLikeWidth.constant = 0
                cell.secondLikeWidth.constant = 0
                cell.thirdLikeWidth.constant = 0
                cell.likeSpacing.constant = 4
                
                cell.firstLikeIV.isHidden = true
                cell.secondLikeIV.isHidden = true
                cell.thirdLikeIV.isHidden = true
                print("Both like and comment array is empty")
            }
            
            cell.likeBtnAction = { sender in
                if AuthStatus.instance.isGuest{
                    self.delegate?.triggerGuestAlert()
                } else {
                    data.likeStatus = !data.likeStatus
                    if data.likeStatus{
                        data.likeCount += 1
                        if AuthService.instance.profilePic == "" {
                            let profile = "https://myscrap.com/style/images/icons/no-profile-pic-female.png"
                            if data.userLike.count == 3 {
                                //data.userLike.insert(AuthService.instance.profilePic, at: 2)
                                data.userLike[2] = profile
                            } else if data.userLike.count == 2 {
                                data.userLike.insert(profile, at: 2)
                            } else if data.userLike.count == 1 {
                                print("I'm here...")
                                data.userLike.insert(profile, at: 1)
                            } else {
                                data.userLike.insert(profile, at: 0)
                            }
                        } else {
                            if data.userLike.count == 3 {
                                //data.userLike.insert(AuthService.instance.profilePic, at: 2)
                                data.userLike[2] = AuthService.instance.profilePic
                            } else if data.userLike.count == 2 {
                                data.userLike.insert(AuthService.instance.profilePic, at: 2)
                            } else if data.userLike.count == 1 {
                                print("I'm here...")
                                data.userLike.insert(AuthService.instance.profilePic, at: 1)
                            } else {
                                data.userLike.insert(AuthService.instance.profilePic, at: 0)
                            }
                        }
                        
                    } else {
                        data.likeCount -= 1
                        if AuthService.instance.profilePic == "" {
                            let profile = "https://myscrap.com/style/images/icons/no-profile-pic-female.png"
                            if data.userLike.count == 3 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(profile) {
                                    data.userLike.remove(at: 1)
                                } else if data.userLike[2].contains(profile){
                                    data.userLike.remove(at: 2)
                                } else {
                                    print("No profile is there to remove")
                                }
                            } else if data.userLike.count == 2 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(profile) {
                                    data.userLike.remove(at: 1)
                                }
                            } else if data.userLike.count == 1 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                }
                            } else {
                                print("No like count fetched")
                            }
                        } else {
                            if data.userLike.count == 3 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 1)
                                } else if data.userLike[2].contains(AuthService.instance.profilePic){
                                    data.userLike.remove(at: 2)
                                } else {
                                    print("No profile is there to remove")
                                }
                            } else if data.userLike.count == 2 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 1)
                                }
                            } else if data.userLike.count == 1 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                }
                            } else {
                                print("No like count fetched")
                            }
                        }
                    }
                    
                    self.service.postLike(postId: data.postId, frinedId: data.postedUserId)
                    collectionView.reloadItems(at: [indexPath])
                    cell.likeBtn.isLiked = data.likeStatus
                }
            }
            
            //Tap gesture
            let userLblTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
            //tapGesture.delegate = self
            userLblTap.numberOfTapsRequired = 1
            cell.userNameLbl.isUserInteractionEnabled = true
            cell.userNameLbl.tag = indexPath.row
            cell.userNameLbl.addGestureRecognizer(userLblTap)
            
            let userProfileImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
            //tapGesture.delegate = self
            userProfileImgTap.numberOfTapsRequired = 1
            cell.profileImageView.isUserInteractionEnabled = true
            cell.profileImageView.tag = indexPath.row
            cell.profileImageView.addGestureRecognizer(userProfileImgTap)
            
            let feedImageTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(detailFeedsTapped(tapGesture:)))
            feedImageTap.numberOfTapsRequired = 1
            cell.feedsImageView.isUserInteractionEnabled = true
            cell.feedsImageView.tag = indexPath.row
            cell.feedsImageView.addGestureRecognizer(feedImageTap)
            
            let likefImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likefImgTap.numberOfTapsRequired = 1
            cell.firstLikeIV.isUserInteractionEnabled = true
            cell.firstLikeIV.tag = indexPath.row
            cell.firstLikeIV.addGestureRecognizer(likefImgTap)
            
            let likeSImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeSImgTap.numberOfTapsRequired = 1
            cell.secondLikeIV.isUserInteractionEnabled = true
            cell.secondLikeIV.tag = indexPath.row
            cell.secondLikeIV.addGestureRecognizer(likeSImgTap)
            
            let likeTImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeTImgTap.numberOfTapsRequired = 1
            cell.thirdLikeIV.isUserInteractionEnabled = true
            cell.thirdLikeIV.tag = indexPath.row
            cell.thirdLikeIV.addGestureRecognizer(likeTImgTap)
            
            let likeTextTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeTextTap.numberOfTapsRequired = 1
            cell.likesCmntLbl.isUserInteractionEnabled = true
            cell.likesCmntLbl.tag = indexPath.row
            cell.likesCmntLbl.addGestureRecognizer(likeTextTap)
            
            return cell
        case .landFeedImageTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Land_Feeds_ImageTextCell.identifier, for: indexPath) as? Land_Feeds_ImageTextCell else { return UICollectionViewCell()}
            let statusText = data.status
            if (data.profilePic == "") {
                cell.profileImageView.image = #imageLiteral(resourceName: "blank_user")
            } else {
                cell.profileImageView.sd_setImage(with: URL(string: data.profilePic), completed: nil)
            }
            //cell.statusTextLbl.text = statusText
            if statusText.contains("http") {
                cell.statusTextLbl.attributedText = data.textImgStatus
            } else {
                //cell.statusTextLbl.text = statusText
                cell.statusTextLbl.attributedText = data.textImgStatus
            }
            //cell.feedsImageView.sd_setImage(with: URL(string: data.postedImage), completed: nil)
            
            let downloadURL = URL(string: data.postedImage)
            SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
                if  status {
                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                        cell.feedsImageView.image = image
                        cell.spinner.stopAnimating()
                        cell.spinner.isHidden = true
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        if let error = error {
                            print("Error while downloading : \(error), Status :\(status), url :\(String(describing: downloadURL))")
                            cell.feedsImageView.image = #imageLiteral(resourceName: "no-image")
                            cell.spinner.stopAnimating()
                            cell.spinner.isHidden = true
                        } else {
                            SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                            cell.feedsImageView.image = image
                            cell.spinner.stopAnimating()
                            cell.spinner.isHidden = true
                        }
                    })
                }
            }
            
            
            cell.desgCompLbl.text = data.userCompany == "" ? data.postedUserDesignation : "\(data.postedUserDesignation) • \(data.userCompany)"
            //cell.desgCompLbl.text = data.postedUserDesignation
            cell.userNameLbl.text = data.postedUserName
            cell.postTimeLbl.text = data.timeStamp
            
            cell.likeBtn.isLiked = data.likeStatus
            //cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + "•" + String(format: "%d", data.commentCount)
            if data.likeCount != 0 && data.commentCount != 0 {
                if data.likeCount >= 2 && data.commentCount >= 2{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes • " + String(format: "%d", data.commentCount) + " Comments"
                } else if data.likeCount == 1 && data.commentCount == 1{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like • " + String(format: "%d", data.commentCount) + " Comment"
                } else if data.likeCount >= 2 && data.commentCount == 1{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes • " + String(format: "%d", data.commentCount) + " Comment"
                } else if data.likeCount == 1 && data.commentCount >= 2{
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like • " + String(format: "%d", data.commentCount) + " Comments"
                }
            } else if data.likeCount <= 0 && data.commentCount <= 0 {
                cell.likesCmntLbl.text = ""
            } else if data.likeCount != 0 && data.commentCount <= 0{
                if data.likeCount == 1 {
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Like"
                } else {
                    cell.likesCmntLbl.text = String(format: "%d", data.likeCount) + " Likes"
                }
            } else if data.likeCount <= 0 && data.commentCount != 0 {
                if data.commentCount == 1 {
                    cell.likesCmntLbl.text = String(format: "%d", data.commentCount) + " Comment"
                } else {
                    cell.likesCmntLbl.text = String(format: "%d", data.commentCount) + " Comments"
                }
            } else {
                print("Unexpected case in Image + Text cell")
            }
            
            if data.userLike != [] && data.userComment != []{
                if data.userLike.count == 3 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    let thirdImg = data.userLike[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeImgSpacing.constant = 4
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                } else if data.userLike.count == 2 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeImgSpacing.constant = 13
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                } else if data.userLike.count == 1 {
                    let firstImg = data.userLike[0]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeImgSpacing.constant = 22
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                }
            } else if data.userLike == [] && data.userComment != [] {
                if data.userComment.count == 3 {
                    let firstImg = data.userComment[0]
                    let secondImg = data.userComment[1]
                    let thirdImg = data.userComment[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeImgSpacing.constant = 4
                } else if data.userComment.count == 2 {
                    let firstImg = data.userComment[0]
                    let secondImg = data.userComment[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeImgSpacing.constant = 13
                } else if data.userComment.count == 1 {
                    let firstImg = data.userComment[0]
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeImgSpacing.constant = 22
                }
            } else if data.userLike != [] && data.userComment == [] {
                if data.userLike.count == 3 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    let thirdImg = data.userLike[2]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    if thirdImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.thirdLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.thirdLikeIV.sd_setImage(with: URL(string: thirdImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 20
                    cell.likeImgSpacing.constant = 4
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = false
                } else if data.userLike.count == 2 {
                    let firstImg = data.userLike[0]
                    let secondImg = data.userLike[1]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    if secondImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.secondLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.secondLikeIV.sd_setImage(with: URL(string: secondImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 20
                    cell.thirdLikeWidth.constant = 0
                    cell.likeImgSpacing.constant = 13
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = false
                    cell.thirdLikeIV.isHidden = true
                    
                } else if data.userLike.count == 1 {
                    let firstImg = data.userLike[0]
                    
                    if firstImg == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                        cell.firstLikeIV.image = #imageLiteral(resourceName: "blank_user")
                    } else {
                        cell.firstLikeIV.sd_setImage(with: URL(string: firstImg), completed: nil)
                    }
                    
                    cell.firstLikeWidth.constant = 20
                    cell.secondLikeWidth.constant = 0
                    cell.thirdLikeWidth.constant = 0
                    cell.likeImgSpacing.constant = 22
                    
                    cell.firstLikeIV.isHidden = false
                    cell.secondLikeIV.isHidden = true
                    cell.thirdLikeIV.isHidden = true
                }
            } else if data.userLike == [] && data.userComment == [] {
                cell.firstLikeWidth.constant = 0
                cell.secondLikeWidth.constant = 0
                cell.thirdLikeWidth.constant = 0
                cell.likeImgSpacing.constant = 4
                
                cell.firstLikeIV.isHidden = true
                cell.secondLikeIV.isHidden = true
                cell.thirdLikeIV.isHidden = true
                print("Empty array nothing to show for comment & like")
            }
            else {
                cell.firstLikeWidth.constant = 0
                cell.secondLikeWidth.constant = 0
                cell.thirdLikeWidth.constant = 0
                cell.likeImgSpacing.constant = 4
                
                cell.firstLikeIV.isHidden = true
                cell.secondLikeIV.isHidden = true
                cell.thirdLikeIV.isHidden = true
                print("Both like and comment array is empty")
            }
            
            cell.likeBtnAction = { sender in
                if AuthStatus.instance.isGuest{
                    self.delegate?.triggerGuestAlert()
                } else {
                    data.likeStatus = !data.likeStatus
                    if data.likeStatus{
                        data.likeCount += 1
                        if AuthService.instance.profilePic == "" {
                            let profile = "https://myscrap.com/style/images/icons/no-profile-pic-female.png"
                            if data.userLike.count == 3 {
                                //data.userLike.insert(AuthService.instance.profilePic, at: 2)
                                data.userLike[2] = profile
                            } else if data.userLike.count == 2 {
                                data.userLike.insert(profile, at: 2)
                            } else if data.userLike.count == 1 {
                                print("I'm here...")
                                data.userLike.insert(profile, at: 1)
                            } else {
                                data.userLike.insert(profile, at: 0)
                            }
                        } else {
                            if data.userLike.count == 3 {
                                //data.userLike.insert(AuthService.instance.profilePic, at: 2)
                                data.userLike[2] = AuthService.instance.profilePic
                            } else if data.userLike.count == 2 {
                                data.userLike.insert(AuthService.instance.profilePic, at: 2)
                            } else if data.userLike.count == 1 {
                                print("I'm here...")
                                data.userLike.insert(AuthService.instance.profilePic, at: 1)
                            } else {
                                data.userLike.insert(AuthService.instance.profilePic, at: 0)
                            }
                        }
                        
                    } else {
                        data.likeCount -= 1
                        if AuthService.instance.profilePic == "" {
                            let profile = "https://myscrap.com/style/images/icons/no-profile-pic-female.png"
                            if data.userLike.count == 3 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(profile) {
                                    data.userLike.remove(at: 1)
                                } else if data.userLike[2].contains(profile){
                                    data.userLike.remove(at: 2)
                                } else {
                                    print("No profile is there to remove")
                                }
                            } else if data.userLike.count == 2 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(profile) {
                                    data.userLike.remove(at: 1)
                                }
                            } else if data.userLike.count == 1 {
                                if data.userLike[0].contains(profile) {
                                    data.userLike.remove(at: 0)
                                }
                            } else {
                                print("No like count fetched")
                            }
                        } else {
                            if data.userLike.count == 3 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 1)
                                } else if data.userLike[2].contains(AuthService.instance.profilePic){
                                    data.userLike.remove(at: 2)
                                } else {
                                    print("No profile is there to remove")
                                }
                            } else if data.userLike.count == 2 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                } else if data.userLike[1].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 1)
                                }
                            } else if data.userLike.count == 1 {
                                if data.userLike[0].contains(AuthService.instance.profilePic) {
                                    data.userLike.remove(at: 0)
                                }
                            } else {
                                print("No like count fetched")
                            }
                        }
                    }
                    
                    self.service.postLike(postId: data.postId, frinedId: data.postedUserId)
                    collectionView.reloadItems(at: [indexPath])
                    cell.likeBtn.isLiked = data.likeStatus
                }
            }
            
            //Tap gesture
            let userLblTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
            //tapGesture.delegate = self
            userLblTap.numberOfTapsRequired = 1
            cell.userNameLbl.isUserInteractionEnabled = true
            cell.userNameLbl.tag = indexPath.row
            cell.userNameLbl.addGestureRecognizer(userLblTap)
            
            let userProfileImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
            //tapGesture.delegate = self
            userProfileImgTap.numberOfTapsRequired = 1
            cell.profileImageView.isUserInteractionEnabled = true
            cell.profileImageView.tag = indexPath.row
            cell.profileImageView.addGestureRecognizer(userProfileImgTap)
            
            let feedTextTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(detailFeedsTapped(tapGesture:)))
            feedTextTap.numberOfTapsRequired = 1
            cell.statusTextLbl.isUserInteractionEnabled = true
            cell.statusTextLbl.tag = indexPath.row
            cell.statusTextLbl.addGestureRecognizer(feedTextTap)
            
            if data.status.contains("http") {
                let feedURLTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(urlTapped(tapGesture:)))
                feedURLTap.numberOfTapsRequired = 1
                cell.statusTextLbl.isUserInteractionEnabled = true
                cell.statusTextLbl.tag = indexPath.row
                cell.statusTextLbl.addGestureRecognizer(feedURLTap)
            }
            
            let feedImageTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(detailFeedsTapped(tapGesture:)))
            feedImageTap.numberOfTapsRequired = 1
            cell.feedsImageView.isUserInteractionEnabled = true
            cell.feedsImageView.tag = indexPath.row
            cell.feedsImageView.addGestureRecognizer(feedImageTap)
            
            let likefImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likefImgTap.numberOfTapsRequired = 1
            cell.firstLikeIV.isUserInteractionEnabled = true
            cell.firstLikeIV.tag = indexPath.row
            cell.firstLikeIV.addGestureRecognizer(likefImgTap)
            
            let likeSImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeSImgTap.numberOfTapsRequired = 1
            cell.secondLikeIV.isUserInteractionEnabled = true
            cell.secondLikeIV.tag = indexPath.row
            cell.secondLikeIV.addGestureRecognizer(likeSImgTap)
            
            let likeTImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeTImgTap.numberOfTapsRequired = 1
            cell.thirdLikeIV.isUserInteractionEnabled = true
            cell.thirdLikeIV.tag = indexPath.row
            cell.thirdLikeIV.addGestureRecognizer(likeTImgTap)
            
            let likeTextTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(likeOrCommentTapped(tapGesture:)))
            likeTextTap.numberOfTapsRequired = 1
            cell.likesCmntLbl.isUserInteractionEnabled = true
            cell.likesCmntLbl.tag = indexPath.row
            cell.likesCmntLbl.addGestureRecognizer(likeTextTap)
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let postId = item[indexPath.item].postId
        //self.delegate?.didTapFeedsData(postId: postId)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        print("Feeds cell height and width")
        return CGSize(width: self.collectionView.frame.width, height: 380)    //187.5 h : 279
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }*/
    
    
    /*func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(337 + 40)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView!.contentSize.width)
        var newPage = Float(self.pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }*/
    
    /*func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            var currentCellOffset = collectionView.contentOffset
            currentCellOffset.x += collectionView.frame.size.width / 2
            let indexPath = collectionView.indexPathForItem(at: currentCellOffset)
            if let indexPath = indexPath {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }*/
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Page indicator : \(indexPath.item)")
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
        self.pageIndicator.selectedPage = indexPath.item
    }
    
    /*func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.selectedPage = Int(page)
    }*/
    
    @objc func userDetailsTapped(tapGesture:UITapGestureRecognizer){
        let userId = item!.dataFeeds[tapGesture.view!.tag].postedUserId
        delegate?.didTapFUserProfile(userId: (userId))
    }
    
    @objc func detailFeedsTapped(tapGesture: UITapGestureRecognizer) {
        let postId = item!.dataFeeds[tapGesture.view!.tag].postId
        self.delegate?.didTapFeedsData(postId: postId)
    }
    
    @objc func likeOrCommentTapped(tapGesture: UITapGestureRecognizer) {
        let postId = item!.dataFeeds[tapGesture.view!.tag].postId
        self.delegate?.didTapLikeOrComment(postId: postId)
    }
    
    @objc func urlTapped(tapGesture: UITapGestureRecognizer) {
        let url = item!.dataFeeds[tapGesture.view!.tag].status
        self.delegate?.didTap(url: url)
    }
}
class LandPageControl: UIView {
    var pages: Int = 0 {
        didSet {
            guard pages != oldValue else { return }
            pages = max(0, pages)
            invalidateIntrinsicContentSize()
            dotViews = (0..<pages).map { _ in
                PagerCircularView(frame: CGRect(origin: .zero, size: CGSize(width: dotSize, height: dotSize)))
            }
        }
    }
    
    private var centerOffset = 0
    private var pageOffset = 0 {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIView.animate(withDuration: 0.2, animations: self.updatePositions)
            }
        }
    }
    
    var selectedPage: Int = 0 {
        didSet {
            guard selectedPage != oldValue else { return }
            selectedPage = max(0, min (selectedPage, pages - 1))
            updateColors()
            if (0..<centerDots).contains(selectedPage - pageOffset) {
                centerOffset = selectedPage - pageOffset
            } else {
                pageOffset = selectedPage - centerOffset
            }
        }
    }
    
    var dotColor = UIColor.lightGray { didSet { setNeedsDisplay() } }
    var selectedColor = #colorLiteral(red: 0.1306222081, green: 0.4233568311, blue: 0.1587615609, alpha: 1) { didSet { setNeedsDisplay() } }
    
    open var dotSize: CGFloat = 8 {
        didSet {
            dotSize = max(1, dotSize)
            dotViews.forEach { $0.frame = CGRect(origin: .zero, size: CGSize(width: dotSize, height: dotSize)) }
            updatePositions()
        }
    }
    
    open var spacing: CGFloat = 5 {
        didSet {
            spacing = max(1, spacing)
            updatePositions()
        }
    }
    
    private var dotViews: [UIView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            dotViews.forEach(addSubview)
            updateColors()
            updatePositions()
        }
    }
    
    var maxDots = 7 {
        didSet {
            maxDots = max(3, maxDots)
            if maxDots % 2 == 0 {
                maxDots += 1
                print("maxPages has to be an odd number")
            }
            invalidateIntrinsicContentSize()
            updatePositions()
        }
    }
    var centerDots = 2 {
        didSet {
            if centerDots % 2 == 0 {
                centerDots += 1
                print("centerDots has to be an odd number")
            }
            updatePositions()
        }
    }
    
    public init() {
        super.init(frame: .zero)
        isOpaque = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    /*override func draw(_ rect: CGRect) {
        let horizontalOffset = CGFloat(-pageOffset + 2) * (dotSize + spacing) + (rect.width - intrinsicContentSize.width) / 2
        let centerPage = 1 + pageOffset
        (0..<pages).forEach { page in
            (page == selectedPage ? selectedColor : dotColor).setFill()
            let center = CGPoint(x: horizontalOffset + rect.minX + dotSize / 2 + (dotSize + spacing) * CGFloat(page), y: rect.midY)
            var scale: CGFloat {
                let distance = abs(page - (1 + pageOffset))
                switch distance {
                case 0, 1: return 1
                case 2: return 0.66
                case 3: return 0.33
                case _: return 0
                }
            }
            let size = CGSize(width: dotSize, height: dotSize)
            let rect = CGRect(origin: center, size: size)
            UIBezierPath(ovalIn: rect).fill()
        }
    }*/
    
    override var intrinsicContentSize: CGSize {
        let pages = min(maxDots, self.pages)
        let width = CGFloat(pages) * dotSize + CGFloat(pages - 1) * spacing
        let height = dotSize
        return CGSize(width: width, height: height)
    }
    
    private var lastSize = CGSize.zero
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.size != lastSize else { return }
        lastSize = bounds.size
        updatePositions()
    }
    
    private func updateColors() {
        dotViews.enumerated().forEach { page, dot in
            dot.backgroundColor = page == selectedPage ? selectedColor : dotColor
        }
    }
    
    private func updatePositions() {
        let sidePages = (maxDots - centerDots) / 2
        let horizontalOffset = CGFloat(-pageOffset + sidePages) * (dotSize + spacing) + (bounds.width - intrinsicContentSize.width) / 2
        let centerPage = centerDots / 2 + pageOffset
        dotViews.enumerated().forEach { page, dot in
            let center = CGPoint(x: horizontalOffset + bounds.minX + dotSize / 2 + (dotSize + spacing) * CGFloat(page), y: bounds.midY)
            let scale: CGFloat = {
                let distance = abs(page - centerPage)
                if distance > (maxDots / 2) { return 0 }
                return [1, 0.66, 0.33, 0.16][max(0, min(3, distance - centerDots / 2))]
            }()
            dot.center = center
            dot.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
}
class PagerCircularView: UIView {
    override func tintColorDidChange() {
        self.backgroundColor = tintColor
    }
    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }*/
    
    override var frame: CGRect {
        didSet {
            updateCornerRadius()
        }
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
