//
// EndLiveDownloadPopUpVC
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
protocol EndLiveWithDownloadDelegate : class {
    func downloadButtonPressed()
    func deleteButtonPressed()

}
class EndLiveDownloadPopUpVC: BaseVC {
    
    
    var showCloseButton = false
    var profileItem:ProfileData?
    weak var delegate : EndLiveWithDownloadDelegate?

    @IBOutlet weak var roundCornerView: UIView!
    @IBOutlet weak var slideToDismiss: UIView!

    @IBOutlet weak var downloadButtton: UIButton!
    @IBOutlet weak var dowloadTitleButton: UIButton!
    @IBOutlet weak var deleteButtton: UIButton!
    @IBOutlet weak var deleteTtitleButton: UIButton!
    //    var dataSource = [FeedV2Item]()
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
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
          //  self.slideToDismiss.addGestureRecognizer(swipeDown)
        self.slideToDismiss.isUserInteractionEnabled = false
    
        self.roundCornerView.layer.cornerRadius = 20
    //    self.nameLable.text = friendName
        self.topView.layer.cornerRadius =  self.topView.frame.size.height/2
        // shadow
        self.roundCornerView.layer.shadowColor = UIColor.darkGray.cgColor
        self.roundCornerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.roundCornerView.layer.shadowOpacity = 0.7
        self.roundCornerView.layer.shadowRadius = 5
        
        deleteButtton.setImage( UIImage.fontAwesomeIcon(name: .trash, style: .solid, textColor: UIColor.black , size: CGSize(width: 40, height: 40)), for: .normal)
        deleteButtton.layer.cornerRadius = deleteButtton.frame.size.height/2
        deleteButtton.layer.borderWidth = 1
        deleteButtton.layer.borderColor = UIColor.black.cgColor
        
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
    
   
    }
    @IBAction func downloadButtonPressed(_ sender: Any) {
        delegate?.downloadButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteButtonPressed()
        self.dismiss(animated: true, completion: nil)
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

 
    static func storyBoardInstance() -> EndLiveDownloadPopUpVC?{
        let st = UIStoryboard.LIVE
        return st.instantiateViewController(withIdentifier: EndLiveDownloadPopUpVC.id) as? EndLiveDownloadPopUpVC
    }
}
