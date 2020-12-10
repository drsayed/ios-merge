//
//  VotingScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 7/27/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class VotingScrollCell: BaseCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var voteTitleImage: UIImageView!
    
    var viewAllActionBlock: (() -> Void)? = nil
    var offlineActionBlock : (() -> Void)? = nil
    
    var voteItem : [VoteFeed]!
    var userData : PostedUserData?
    
    weak var delegate : VoteScrollDelegate?
    
    var item : FeedV2Item?{
        didSet{
            if let item = item?.voteData{
                voteItem = item
                for vote in voteItem {
                    for data in vote.user_data {
                        userData = data
                        print("Voter ID while fetching : \(vote.voterId)")
                        //                        configure(viewListing: lists, userData: userData)
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        voteTitleImage.image = UIImage.fontAwesomeIcon(name: .voteYea, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(VotingInsideScrollCell.Nib, forCellWithReuseIdentifier: VotingInsideScrollCell.identifier)
    }
    
    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        viewAllActionBlock?()
    }

}
extension VotingScrollCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Voting array count : \(voteItem.count)")
        return voteItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VotingInsideScrollCell.identifier, for: indexPath) as? VotingInsideScrollCell else { return UICollectionViewCell()}
        
        let vote = voteItem[indexPath.row]
        let userData = vote.user_data.last
        let name = userData!.name
        cell.voterName.text = name
        cell.viewBio.text = "▶ Vote"
//        let colorCode = userData?.colorcode
//        let initials = name.initials()
        let downloadURL = URL(string: userData!.profile_img)
        
        let voterViewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(voteView(tapGest:)))
        //tapGesture.delegate = self
        voterViewTap.numberOfTapsRequired = 1
        cell.voterView.isUserInteractionEnabled = true
        cell.voterView.tag = indexPath.row
        cell.voterView.addGestureRecognizer(voterViewTap)
        
        let voterImageTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(viewBio(tapGesture:)))
        voterImageTap.numberOfTapsRequired = 1
        cell.voterImageView.isUserInteractionEnabled = true
        cell.voterImageView.tag = indexPath.row
        cell.voterImageView.addGestureRecognizer(voterImageTap)
        
        SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
            if status{
                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                    cell.voterImageView.image = image
                    cell.spinner.stopAnimating()
                    cell.spinner.isHidden = true
                })
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                    if let error = error {
                        print("Error while downloading : \(error), Status :\(status), url :\(String(describing: downloadURL))")
                        cell.voterImageView.image = #imageLiteral(resourceName: "no-image")
                        cell.spinner.stopAnimating()
                        cell.spinner.isHidden = true
                    } else {
                        if image != nil {
                            SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                            cell.voterImageView.image = image
                            cell.spinner.stopAnimating()
                            cell.spinner.isHidden = true
                        } else {
                            print("Voter image is nil")
                            cell.voterImageView.image = #imageLiteral(resourceName: "default-profile-pic-png-5")
                            cell.spinner.stopAnimating()
                            cell.spinner.isHidden = true
                        }
                        
                    }
                })
            }
        }
        
        
        cell.offlineActionBlock = {
            self.offlineActionBlock?()
        }
        cell.shareBtnAction = { sender in
            print("Show voter id : \(vote.voterId)")
            self.delegate?.didShareBtnTapped(sender: sender, voterId: vote.voterId, voterName: name)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let voterId = voteItem[indexPath.item].voterId
//        print("Voter ID : \(voterId)")
//        delegate?.didTapVoteView(voterId: voterId, userId: "")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 185, height: 218)    //165 h : 188
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    @objc func viewBio(tapGesture:UITapGestureRecognizer){
        print("Label tag is:\(tapGesture.view!.tag)")
        let index = tapGesture.view!.tag
        let voterId = voteItem[tapGesture.view!.tag].voterId
        print("Voter ID : \(voterId)")
        delegate?.didTapVoterBio(index: index, voterId: voterId)
        
    }
    
    @objc func voteView(tapGest:UITapGestureRecognizer) {
            let voterId = voteItem[tapGest.view!.tag].voterId
            print("Voter ID : \(voterId)")
            delegate?.didTapVoteView(index: tapGest.view!.tag, voterId: voterId)
        }
    
}
