//
//  Land_Online_OverAllCell.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class Land_Online_OverAllCell: BaseCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var rankView: ProfileTypeView!
    @IBOutlet weak var onlineView: CircleView!
    
    //var activeUsersItem : [LOnlineItems]!
    //var item = [LOnlineItems]()
    var onlineItem = [LOnlineItems]()
    weak var delegate : LandOnlineScrollDelegate?
    
    var item : LandingItems?{
        didSet{
            if let item = item?.activeFriendsData{
                onlineItem = item
                collectionView.reloadData()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        //collectionView.register(Land_Online_UsersCell.Nib, forCellWithReuseIdentifier: Land_Online_UsersCell.identifier)
    }
}
extension Land_Online_OverAllCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onlineItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Online_UsersCell", for: indexPath) as? Land_Online_UsersCell else { return UICollectionViewCell()}
        let data = onlineItem[indexPath.item]
        let profilePic = data.profilePic
        let newUser = data.newJoined
        let mod = data.moderator
        if profilePic != "" {
            cell.profileImageView.sd_setImage(with: URL(string: profilePic!), completed: nil)
        } else {
            cell.profileImageView.image = #imageLiteral(resourceName: "blank_user")
        }
        
        if mod == "1" {
            cell.rankView.isHidden = false
            cell.rankView.label.text = "MOD"
             cell.rankView.backgroundColor = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
        }
        if newUser == true {
            print("User name on scroll : \(data.name)")
             cell.rankView.isHidden = false
             cell.rankView.label.text = "NEW"
             cell.rankView.backgroundColor = UIColor.NEW_COLOR
        }
        if mod == "0" && newUser == false {
             cell.rankView.isHidden = true
        }
         cell.rankView.translatesAutoresizingMaskIntoConstraints = false
        
        //cell.rankView.checkType = (isAdmin:false,isMod: mod == "1", isNew: newUser, rank:"")
        cell.onlineView.isHidden = !data.online
        
        let imageTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDetailsTapped(tapGesture:)))
        //tapGesture.delegate = self
        imageTap.numberOfTapsRequired = 1
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.addGestureRecognizer(imageTap)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 50, height: 61)    //187.5 h : 279
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    @objc func userDetailsTapped(tapGesture:UITapGestureRecognizer){
        let data = onlineItem[tapGesture.view!.tag]
        let userId = data.userid!
        let name = data.name!
        let colorCode = data.colorCode!
        let profilePic = data.profilePic!
        let jid = data.jId!
        delegate?.didTapOnlineUser(friendId: userId, name: name, colorCode: colorCode, profileImage: profilePic, jid: jid)
    }
}
