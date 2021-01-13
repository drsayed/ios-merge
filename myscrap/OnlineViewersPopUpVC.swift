//
// OnlineViewersPopUpVC
//  myscrap
//
//  Created by MS1 on 6/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
protocol OnlineViewersDelegate:class {
    func onlineUserSelected(FriendID : String, AtIndex : Int)
}
class OnlineViewersPopUpVC: BaseVC {
    
    weak var delegateOnlineViewer : OnlineViewersDelegate?
    var userJoined = Array<[String:AnyObject]>()
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var roundCornerView: UIView!
    @IBOutlet weak var slideToDismiss: UIView!
    
    @IBOutlet weak var topSeperator: UIView!
    
    @IBOutlet weak var viewersCollectionView: UICollectionView!
    @IBOutlet weak var nameLable: UILabel!
    fileprivate var isInitiallyLoaded = false
    
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
    //    self.nameLable.text = friendName
        self.viewersCollectionView.delegate = self
        self.viewersCollectionView.dataSource = self
        
        // shadow
        self.roundCornerView.layer.shadowColor = UIColor.darkGray.cgColor
        self.roundCornerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.roundCornerView.layer.shadowOpacity = 0.7
        self.roundCornerView.layer.shadowRadius = 5
        
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewersCollectionView.reloadData()
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
 
    static func storyBoardInstance() -> OnlineViewersPopUpVC?{
        let st = UIStoryboard.LIVE
        return st.instantiateViewController(withIdentifier: OnlineViewersPopUpVC.id) as? OnlineViewersPopUpVC
    }
}
extension OnlineViewersPopUpVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userJoined.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnlineViewerCell.identifier, for: indexPath) as? OnlineViewerCell else { return UICollectionViewCell()
        }
        cell.configCell(item:self.userJoined[indexPath.row] )
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width:self.viewersCollectionView.frame.size.width, height: 80)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict  = self.userJoined[indexPath.row]
        
        delegateOnlineViewer?.onlineUserSelected(FriendID: dict["userId"] as! String, AtIndex: indexPath.row)
        self.dismiss(animated: true, completion: nil)

}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }

}
   
