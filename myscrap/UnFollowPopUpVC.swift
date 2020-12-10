//
// UnFollowPopUpVC
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
protocol UnFollowDelegate:class {
    func UnFollowPressed(FriendID : String, AtIndex : Int)
}
class UnFollowPopUpVC: BaseVC {
    
    weak var delegateUnfollow : UnFollowDelegate?

    @IBOutlet weak var roundCornerView: UIView!
    @IBOutlet weak var slideToDismiss: UIView!
    
    @IBOutlet weak var topSeperator: UIView!
    
    @IBOutlet weak var nameLable: UILabel!
    fileprivate var isInitiallyLoaded = false
    
    @IBOutlet weak var unfollowButton: UIButton!
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
        self.roundCornerView.layer.cornerRadius = 20
        self.topSeperator.layer.cornerRadius = self.topSeperator.frame.height/2
        self.nameLable.text = friendName
        
        // shadow
        self.roundCornerView.layer.shadowColor = UIColor.darkGray.cgColor
        self.roundCornerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.roundCornerView.layer.shadowOpacity = 0.7
        self.roundCornerView.layer.shadowRadius = 5
        self.unfollowButton.setTitleColor(.red, for: .normal)
        
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }
    override func viewWillDisappear(_ animated: Bool) {
    
        

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
    @IBAction func unfollowButtonPressed(_ sender: Any) {
     
        delegateUnfollow?.UnFollowPressed(FriendID: friendID!, AtIndex: indexValue!)
        self.dismiss(animated: true, completion: nil)

    }
    static func storyBoardInstance() -> UnFollowPopUpVC?{
        let st = UIStoryboard.profile
        return st.instantiateViewController(withIdentifier: UnFollowPopUpVC.id) as? UnFollowPopUpVC
    }
}
   
