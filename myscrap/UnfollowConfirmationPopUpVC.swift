//
// UnfollowConfirmationPopUpVC
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
protocol unFollowConfirmDelegate : class {
    func unFollowPressed(FriendID : String)
  
}
class UnfollowConfirmationPopUpVC: BaseVC {
    
    var friendId = ""
    var liveUserNameValue = ""
    var liveUserImageValue  = ""
    var liveUserProfileColor = ""
    var liveUsertopicValue = ""
    var followingStatus = false
    
    var profileItem:ProfileData?
    weak var delegate : unFollowConfirmDelegate?

    @IBOutlet weak var unFollowLableTitle: UILabel!
    @IBOutlet weak var roundCornerView: UIView!
    @IBOutlet weak var slideToDismiss: UIView!
    @IBOutlet weak var userProfileVIew: ProfileView!
    
    @IBOutlet weak var unFollowButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
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
        
        self.unFollowButton.layer.cornerRadius =  self.unFollowButton.frame.size.height/2
        self.unFollowButton.layer.borderWidth = 1
        self.unFollowButton.layer.borderColor = UIColor.darkGray.cgColor
        self.cancelButton.layer.cornerRadius =  self.cancelButton.frame.size.height/2
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.layer.borderColor = UIColor.darkGray.cgColor
        self.roundCornerView.layer.cornerRadius = 20
    //    self.nameLable.text = friendName
        
        // shadow
        self.roundCornerView.layer.shadowColor = UIColor.darkGray.cgColor
        self.roundCornerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.roundCornerView.layer.shadowOpacity = 0.7
        self.roundCornerView.layer.shadowRadius = 5
        
    }
    func setupViews()  {
        
        
        
       // guard let item = profileItem else { return }

//        if item.followStatusType != 2
//        {
//            followingStatus = false
//        }
//        else{
//            followingStatus = true
//        }
        
        userProfileVIew.updateViews(name:liveUserNameValue, url: liveUserImageValue , colorCode: liveUserProfileColor)
        
        let differentColorText = "Unfollow \(liveUserNameValue)?"
        let st = "Are you sure you want to " + "\(differentColorText)" //+ "\n"

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        
        let attributedString = NSMutableAttributedString(string: st, attributes: [.foregroundColor: UIColor.BLACK_ALPHA,NSAttributedString.Key.font: Fonts.descriptionFont, NSAttributedString.Key.paragraphStyle: style])
        
            let ranges = st.subStringranges(of: differentColorText)
            for range in ranges{
                let rnge: NSRange = st.nsRange(from: range)
                
                attributedString.addAttribute(NSAttributedString.Key(rawValue: MSTextViewAttributes.USERTAG), value: friendId, range: rnge)
                attributedString.addAttribute(.foregroundColor, value: UIColor.GREEN_PRIMARY, range: rnge)
                attributedString.addAttribute(.font, value: Fonts.userTagFont, range: rnge)
                
           
        }
        unFollowLableTitle.attributedText = attributedString
     //   profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:profileItem?.newJoined, rank:profileItem?.rank ,isLevel: profileItem?.isLevel, level: profileItem?.level)

    }
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    override func viewWillDisappear(_ animated: Bool) {
    
        

    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
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
 
    @IBAction func unFollowerButtonPresssed(_ sender: Any) {
        delegate?.unFollowPressed(FriendID: friendId)
        self.dismiss(animated: true, completion: nil)
    }
    
 
    static func storyBoardInstance() -> UnfollowConfirmationPopUpVC?{
        let st = UIStoryboard.LIVE
        return st.instantiateViewController(withIdentifier: UnfollowConfirmationPopUpVC.id) as? UnfollowConfirmationPopUpVC
    }
}
