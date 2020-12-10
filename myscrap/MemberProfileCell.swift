//
//  MemberProfileCell.swift
//  myscrap
//
//  Created by MyScrap on 11/24/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

@objc
protocol MemberProfileCellDelegate: class{
    func DidPressCompanyBtn(cell: BaseCell)
    func DidPressCall(cell: BaseCell,sender:UIButton)
    func DidPressChat(cell: BaseCell)
    func DidPressEmail(cell: BaseCell)
    func DidPressFavourite(cell: BaseCell)
    func DidPressLike(cell: MemberProfileCell)
    
    func DidPressFollowers(cell: MemberProfileCell)
    func DidPressFollowings(cell: MemberProfileCell)
    func DidPressFollowUser(cell: MemberProfileCell)

}

class MemberProfileCell: BaseCell {
    
    @IBOutlet weak var sliderView: MSSliderView!
    
    @IBOutlet weak var landPlaceholderImage: UIButton!
    @IBOutlet weak var transpView: UIView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var followUserButton  : UIButton!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var followerCount: UIButton!
    @IBOutlet weak var levelCount: UILabel!
    
    @IBOutlet weak var scoreCount: UILabel!
    @IBOutlet weak var foloowingCount: UIButton!
    @IBOutlet weak var followersBtn: UIButton!
    @IBOutlet weak var followingsBtn: UIButton!

    @IBOutlet weak var worksAtLbl: UIButton!
    
    @IBOutlet weak var favBtn: FavouriteButton!
    @IBOutlet weak var likeBtn: LikeButtonProfile!
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    weak var delegate: MemberProfileCellDelegate?
    fileprivate var profileItem:ProfileData?
    var onlineIcon: onlineView!
    
    @IBOutlet weak var statusBtn: UIButton!

    @IBOutlet var statusBtnWidthConstraint : NSLayoutConstraint!

    var data: ProfileService?{
        didSet{
            if let item = data{
                configure(with: item)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure(with item: ProfileService){
        
        if let images = item.imageList , !images.isEmpty {
            var data : [Images] = []
            for img in images{
                data.append(Images(imageURL: img, title: ""))
            }
            sliderView.dataSource = data
            if data.count > 1 {
                sliderView.img_count.isHidden = false
                sliderView.countView.isHidden = false
                sliderView.pageControl.isHidden = false
            }
            else
            {
                sliderView.img_count.isHidden = true
                sliderView.countView.isHidden = true
                sliderView.pageControl.isHidden = true
            }
        } else {
            sliderView.dataSource = [Images(imageURL: "", title: "")]
            sliderView.img_count.isHidden = true
            sliderView.countView.isHidden = true
            sliderView.pageControl.isHidden = true
        }
    }
    
    func configCell(item: ProfileData){
        //transpView.backgroundColor = UIColor.clear.withAlphaComponent(0.1)
        transpView.translatesAutoresizingMaskIntoConstraints = false
        profileTypeView.label.font = UIFont(name: "HelveticaNeue", size: 14)
        profileTypeView.label.allowsDefaultTighteningForTruncation = true
        //profileTypeView.label.sizeToFit()
        //likeBtn.isLiked = item.likeStatus
        //In api moderator and new joined user is missing
        profileTypeView.checkType = ProfileTypeScore(isAdmin: false, isMod: item.moderator, isNew: item.newJoined, rank: item.rank,isLevel:item.isLevel, level: item.level)
        
        
        let image = UIImage(named: "land-companies")?.withRenderingMode(.alwaysTemplate)
        landPlaceholderImage.setImage(image, for: .normal)
        landPlaceholderImage.tintColor = UIColor.darkGray

        if profileTypeView.checkType.isLevel {
            profileTypeView.isHidden = true
        }

        /*
        //Checking the condition which Profile type is
        if item.rank == "MOD" {
            profileTypeView.label.text = item.rank
            profileTypeView.label.textColor = UIColor.WHITE_ALPHA
            profileTypeView.backgroundColor = UIColor.MOD_COLOR
        }  else if item.rank == "NEW" {
            if item.isLevel {
                profileTypeView.label.text = "LEVEL \(item.level)"
                profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
            }  else {
                profileTypeView.label.text = item.rank
                profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                profileTypeView.backgroundColor = UIColor.NEW_COLOR
            }
        } else if item.rank == "ADMIN" {
            if item.isLevel {
                profileTypeView.label.text = "LEVEL \(item.level)"
                profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
            }  else {
                profileTypeView.label.text = item.rank
                profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
            }
        } else if item.rank == "NoRank"{
            //profileTypeView.label.text = "NoRank"
            //profileTypeView.label.textColor = UIColor.WHITE_ALPHA
            //profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
            if item.isLevel {
                profileTypeView.label.text = "LEVEL \(item.level)"
                profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
            }  else {
                profileTypeView.isHidden = true
            }
        } else {
            if item.isLevel {
                profileTypeView.label.text = "LEVEL \(item.level)"
                profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
            }  else {
                profileTypeView.label.text = item.rank
                profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
            }
        }
        print(profileTypeView.checkType, "Rank : \(item.rank), Height : \(profileTypeView.height) , Width  : \(profileTypeView.width)") */
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white]
        let memName = item.memName + ", "
        let attributedString1 = NSMutableAttributedString(string: memName , attributes:attrs1)
        
        let lowerCase = item.memDesignation.lowercased
        let titleCase = lowerCase().firstUppercased
        print("Captilized string : \(titleCase)")
        
        let attributedString2 = NSMutableAttributedString(string: titleCase, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        
        print("Attributes : \(attributedString1), \(attributedString2)")
        memberName.attributedText = attributedString1
        print("NAME of the member in Profile page : \(memName)")
        
        var onlineStatusStr = ""
        var imageStr = ""
        
        if item.lastSeen == "Online" {
            onlineStatusStr = String(format: " %@", item.lastSeen)
            imageStr = "icOnline"
            statusBtnWidthConstraint.constant = 80
        }
        else {
            statusBtnWidthConstraint.constant = 0
        }
        if attributedString1.string.count > 25 {
            print(attributedString2.string)
            onlineStatusStr = ""
            imageStr = "icOnline"
            statusBtnWidthConstraint.constant = 20
        }
        self.statusBtn.isUserInteractionEnabled = false
        self.statusBtn.setImage(UIImage(named: imageStr), for: .normal)
        self.statusBtn.setTitle(onlineStatusStr, for: .normal)

        //memberName.text = item.memName + ", " + titleCase
        //designationLbl.text = titleCase
        //designationLbl.text = item.designation
     //   scoreLbl.text = "• \(item.score) Score  •"
        scoreLbl.text = "Score"
        scoreCount.text = "\(item.score)"
        /*print("Likes count \(item.likes)")
        if item.likes == 0 {
            likesLbl.text = " \(item.likes) Like"
        } else {
            likesLbl.text = " \(item.likes) Likes"
        }*/
        
        //MARK:- Like label are using LEVELS
        likesLbl.text = "Level"
        levelCount.text = "\(item.level)"
        /*
        if item.lastSeen == "Online" {
            //self.addSubview(onlineIcon)
            //onlineIcon.anchor(leading: leadingAnchor, trailing: statusLbl.leadingAnchor, top: nil, bottom: nil)
            statusLbl.textColor = UIColor.ONLINE_COLOR
            statusLbl.text = "⬤ \(item.lastSeen)"
        } else {
            
            //statusLbl.text = "Last Online: \(item.lastSeen) ago"
            
            let date = Date(milliseconds: item.last_seen_timestamp)
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "hh:mm a"
                statusLbl.text = "last seen today at " + dateFormatter.string(from: date)
            } else if calendar.isDateInYesterday(date){
                dateFormatter.dateFormat = "hh:mm a"
                statusLbl.text = "last seen yesterday at " + dateFormatter.string(from: date)
            } else if (calendar.locale?.calendar.isDateInWeekend(date))! {
                dateFormatter.dateFormat = "hh:mm a"
                let day = date.dayOfWeek(date: date)
                statusLbl.text = "last seen " + day! + " at " + dateFormatter.string(from: date)
            }
            else {
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let time = date.splitDateTime()
                statusLbl.text = "last seen " + dateFormatter.string(from: date) + " at " + time!
            }
        } */
        
        if item.memCompany == "" {
            worksAtLbl.setTitle("Not provided", for: .normal)
        } else {
            worksAtLbl.setTitle(item.memCompany, for: .normal)
        }
        print("Favourite Bool : \(item.isFav)")
        favBtn.isFavourite = item.isFav
        likeBtn.isLiked = item.isLike
        
        self.followingsBtn.setTitle(String(format: "Following"), for: .normal)
        self.foloowingCount.setTitle(String(format: "%d", item.followingCount), for: .normal)

        var followerStr = "Followers"
        
        if item.followersCount == 1 {
            followerStr = "Follower"
        }

        self.followersBtn.setTitle(String(format: "%@", followerStr), for: .normal)
        self.followerCount.setTitle(String(format: "%d", item.followersCount), for: .normal)
        //followUserButton
        self.followUserButton.layer.cornerRadius = 5
        self.followUserButton.layer.masksToBounds = true
        
        if item.followStatusType == 0 {
            self.followUserButton.isEnabled = true
            self.followUserButton.setTitle("Follow", for: .normal)
            self.followUserButton.setImage(UIImage(named: "icFollow"), for: .normal)
            self.followUserButton.layer.borderColor = UIColor.white.cgColor
            self.followUserButton.layer.borderWidth = 1.0
            self.followUserButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
            self.followUserButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
            self.followUserButton.backgroundColor = UIColor.clear
        }
        else if item.followStatusType == 1 {
            self.followUserButton.isEnabled = true
            self.followUserButton.setTitle("Requested", for: .normal)
            self.followUserButton.setImage(UIImage(named: ""), for: .normal)
            self.followUserButton.layer.borderColor = UIColor.white.cgColor
            self.followUserButton.layer.borderWidth = 1.0
            self.followUserButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
            self.followUserButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
            self.followUserButton.backgroundColor = UIColor.clear
        }
        else if item.followStatusType == 2 {
            self.followUserButton.layer.borderColor = UIColor.clear.cgColor
            self.followUserButton.layer.borderWidth = 0
            self.followUserButton.setImage(UIImage(named: "ic_arrow_down")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.followUserButton.tintColor = .white
            self.followUserButton.setTitle("Following", for: .normal)
            self.followUserButton.backgroundColor = UIColor.GREEN_PRIMARY
            self.followUserButton.semanticContentAttribute = .forceRightToLeft
            self.followUserButton.isEnabled = true

        }
        
        if item.country != "" {
            self.countryLbl.textColor = UIColor.lightGray
            self.countryLbl.text = item.country
        }

    }
    
    @IBAction func favBtnTapped(_ sender: UIButton) {
        /*if favBtn.isFavourite == true {
            favBtn.isFavourite = false
        } else {
            favBtn.isFavourite = true
        }
        //favBtn.isFavourite = !favBtn.isFavourite
        print("Fav value is \(favBtn.isFavourite)")*/
        delegate?.DidPressFavourite(cell: self)
        
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        delegate?.DidPressLike(cell: self)
        
    }
    
    @IBAction func callBtnTapped(_ sender: UIButton) {
        delegate?.DidPressCall(cell: self,sender: sender)
    }
    
    @IBAction func chatBtnTapped(_ sender: UIButton) {
        //print("Delegate : \(delegate)")
        
        delegate?.DidPressChat(cell: self)
        
    }
    
    @IBAction func emailBtnTapped(_ sender: UIButton) {
        
        delegate?.DidPressEmail(cell: self)
    }
    
    @IBAction func companyBtnTapped(_ sender: UIButton) {
        if worksAtLbl.currentTitle != "Not provided" {
            delegate?.DidPressCompanyBtn(cell: self)
        }
    }
    
    @IBAction func followersButtonAction() {
        delegate?.DidPressFollowers(cell: self)
    }
    
    @IBAction func followingsButtonAction() {
        delegate?.DidPressFollowings(cell: self)
    }
    
    @IBAction func followUserButtonAction() {
        delegate?.DidPressFollowUser(cell: self)
    }
}
extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return String(prefix(1)).capitalized + dropFirst()
    }
}
extension String {
    func firstLetterUppercased() -> String {
        guard let first = first, first.isLowercase else { return self }
        return String(first).uppercased() + dropFirst()
    }
}
