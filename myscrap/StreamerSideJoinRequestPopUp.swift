//
// StreamerSideJoinRequestPopUp
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
protocol StreamerSideJoinRequestDelegate : class {
    func acceptJoinRequest(FriendID : String,controller : StreamerSideJoinRequestPopUp)

}
class StreamerSideJoinRequestPopUp: BaseVC {
    
    var friendId = ""
    var liveUserNameValue = ""
    var liveUserImageValue  = ""
    var liveUserProfileColor = ""
    var liveUsertopicValue = ""
    var followingStatus = false
    var profileItem:ProfileData?
    weak var delegate : StreamerSideJoinRequestDelegate?

    @IBOutlet weak var roundCornerView: UIView!
    @IBOutlet weak var slideToDismiss: UIView!
    @IBOutlet weak var userProfileVIew: ProfileView!
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var detailsLable: UILabel!

    @IBOutlet weak var streamerProfileView: ProfileView!
    
  
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendRequestButton: UIButton!
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
        
        self.sendRequestButton.layer.cornerRadius = 10


        self.roundCornerView.layer.cornerRadius = 20
    //    self.nameLable.text = friendName
        
        // shadow
        self.roundCornerView.layer.shadowColor = UIColor.darkGray.cgColor
        self.roundCornerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.roundCornerView.layer.shadowOpacity = 0.7
        self.roundCornerView.layer.shadowRadius = 5
        
    }
    func setupViews()  {
        
        
        streamerProfileView.layer.borderColor = UIColor.white.cgColor
        streamerProfileView.layer.borderWidth = 2
        userProfileVIew.layer.borderColor = UIColor.white.cgColor
        userProfileVIew.layer.borderWidth = 2
        
        userProfileVIew.updateViews(name:liveUserNameValue, url: liveUserImageValue , colorCode: liveUserProfileColor)
        streamerProfileView.updateViews(name:AuthService.instance.fullName, url: AuthService.instance.profilePic , colorCode: AuthService.instance.colorCode)
        titleLable.text = "\(liveUserNameValue) wants to be in this video."
        detailsLable.text = "People who can see \(liveUserNameValue)'s live videos will be able to watch"
        sendRequestButton.setTitle("Go Live with \(liveUserNameValue)", for: .normal)


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
 
    @IBAction func sendButtonPresssed(_ sender: Any) {
        delegate?.acceptJoinRequest(FriendID: friendId, controller : self)
       self.dismiss(animated: true, completion: nil)
    }
    
    
    static func storyBoardInstance() -> StreamerSideJoinRequestPopUp?{
        let st = UIStoryboard.LIVE
        return st.instantiateViewController(withIdentifier: StreamerSideJoinRequestPopUp.id) as? StreamerSideJoinRequestPopUp
    }
}
