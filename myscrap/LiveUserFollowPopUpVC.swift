//
// LiveUserFollowPopUpVC
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
protocol LiveUserFollowDelegate : class {
    func followButtonpressed(FriendID : String, toFollowStatus : Int,controller : LiveUserFollowPopUpVC)
    func chatButtonpressed(FriendID : String, toFollowStatus : Int)
    func followerCountPressed(FriendID : String)
    func FollowingCountPressed(FriendID : String)
}
class LiveUserFollowPopUpVC: BaseVC {
    
    var friendId = ""
    var liveUserNameValue = ""
    var liveUserImageValue  = ""
    var liveUserProfileColor = ""
    var liveUsertopicValue = ""
    var followingStatus = false
    var profileItem:ProfileData?
    weak var delegate : LiveUserFollowDelegate?

    @IBOutlet weak var roundCornerView: UIView!
    @IBOutlet weak var slideToDismiss: UIView!
    @IBOutlet weak var userProfileVIew: ProfileView!
    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
    
    @IBOutlet weak var followerLableButton: UIButton!
    @IBOutlet weak var followerCountButton: UIButton!
    @IBOutlet weak var followingLableButton: UIButton!
    @IBOutlet weak var followingCountButton: UIButton!
    @IBOutlet weak var lavelLableButton: UILabel!
    
    @IBOutlet weak var scoreCountButton: UILabel!
    @IBOutlet weak var scoreLableButton: UILabel!
    @IBOutlet weak var lavelCountButton: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    var friendName : String?
    var friendID : String?
    var indexValue : Int?
//    var dataSource = [FeedV2Item]()
  
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
            swipeDown.direction = .down
            self.slideToDismiss.addGestureRecognizer(swipeDown)
        
        self.chatButton.layer.cornerRadius =  self.chatButton.frame.size.height/2

        self.followButton.layer.cornerRadius =  self.followButton.frame.size.height/2

        self.roundCornerView.layer.cornerRadius = 20
    //    self.nameLable.text = friendName
        
        // shadow
        self.roundCornerView.layer.shadowColor = UIColor.darkGray.cgColor
        self.roundCornerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.roundCornerView.layer.shadowOpacity = 0.7
        self.roundCornerView.layer.shadowRadius = 5
        
    }
    func setupViews()  {
        
        
        
        guard let item = profileItem else { return }

//        if item.followStatusType != 2
//        {
//            followingStatus = false
//        }
//        else{
//            followingStatus = true
//        }
        
        userProfileVIew.updateViews(name:liveUserNameValue, url: liveUserImageValue , colorCode: liveUserProfileColor)
        profileTypeView.label.font = UIFont(name: "HelveticaNeue", size: 14)
        profileTypeView.label.allowsDefaultTighteningForTruncation = true

        if item.moderator {
           // profileTypeView.isHidden = false
            profileTypeView.label.text = "MOD"
            profileTypeView.backgroundColor = UIColor(red: 153/255, green: 101/255, blue: 21/255, alpha: 1.0)
        } else {
          //  profileTypeView.isHidden = true
            profileTypeView.checkType = ProfileTypeScore(isAdmin: false, isMod: false, isNew: item.newJoined, rank: item.rank,isLevel:item.isLevel, level: item.level)
        }
    
        
        scoreLableButton.text = "Score"
        scoreCountButton.text = "\(item.score)"
        
        lavelLableButton.text = "Level"
        lavelCountButton.text = "\(item.level)"
        
        self.followerLableButton.setTitle(String(format: "Following"), for: .normal)
        self.followerCountButton.setTitle(String(format: "%d", item.followingCount), for: .normal)

        var followerStr = "Followers"
        
        if item.followersCount == 1 {
            followerStr = "Follower"
        }

        self.followerLableButton.setTitle(String(format: "%@", followerStr), for: .normal)
        self.followerCountButton.setTitle(String(format: "%d", item.followersCount), for: .normal)
        if followingStatus {

            followButton.setTitle("Following", for: .normal)
            followButton.setImage( UIImage.fontAwesomeIcon(name: .check, style: .solid, textColor: UIColor.white , size: CGSize(width: 20, height: 20)), for: .normal)
        }
        else
        {
            followButton.setTitle("Follow", for: .normal)
            followButton.setImage( UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: UIColor.white , size: CGSize(width: 20, height: 20)), for: .normal)
        }
        
        let image = UIImage(named: "ic_chat")?.withRenderingMode(.alwaysTemplate)
        chatButton.setImage(image, for: .normal)
        chatButton.tintColor = .white
     //   profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:profileItem?.newJoined, rank:profileItem?.rank ,isLevel: profileItem?.isLevel, level: profileItem?.level)

    }
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    override func viewWillDisappear(_ animated: Bool) {
    
        

    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == .right {
            print("Swipe Right")
       }
       else if gesture.direction == .left {
            print("Swipe Left")
       }
       else if gesture.direction == .up {
            print("Swipe Up")
       }
       else if gesture.direction == .down {
        self.dismiss(animated: true, completion: nil)
       }
    }
 
    @IBAction func FollowerButtonPresssed(_ sender: Any) {
        delegate?.followerCountPressed(FriendID: friendId)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func FollowingButtonPresssed(_ sender: Any) {
        delegate?.FollowingCountPressed(FriendID: friendId)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func FollowButtonPressed(_ sender: Any) {
        delegate?.followButtonpressed(FriendID: friendId, toFollowStatus: followingStatus ? 1 : 0 , controller: self)
       // self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func ChatButtonPressed(_ sender: Any) {
        
        delegate?.chatButtonpressed(FriendID: friendId, toFollowStatus: followingStatus ? 1 : 0)
        self.dismiss(animated: true, completion: nil)


    }
    static func storyBoardInstance() -> LiveUserFollowPopUpVC?{
        let st = UIStoryboard.LIVE
        return st.instantiateViewController(withIdentifier: LiveUserFollowPopUpVC.id) as? LiveUserFollowPopUpVC
    }
}
