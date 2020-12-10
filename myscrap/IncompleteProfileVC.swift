//
//  IncompleteProfileVC.swift
//  myscrap
//
//  Created by MyScrap on 02/07/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class IncompleteProfileVC: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    typealias DidRemoved = (Bool) -> Void
    var didRemove: DidRemoved?
    
    convenience init(didPost: @escaping DidRemoved){
        self.init()
        self.didRemove = didRemove
    }

    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    

    
    @IBAction func editProfileBtnTapped(_ sender: UIButton) {
      //  pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: EditProfileController.id)
        let vc = UIStoryboard(name: StoryBoard.PROFILE , bundle: nil).instantiateViewController(withIdentifier: EditProfileController.id) as? EditProfileController
        vc!.isFromIncompleteProfile = true
        let nav = UINavigationController(rootViewController: vc!)
        revealViewController().pushFrontViewController(nav, animated: true)
        didRemove?(true)
    }
    
 
    
  
    static func storyBoardInstance() -> IncompleteProfileVC? {
        let st = UIStoryboard.MAIN
        return st.instantiateViewController(withIdentifier: IncompleteProfileVC.id) as? IncompleteProfileVC
    }
    
    //MARK:- Push View Controller
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        guard !checkisGuest else {
            self.showGuestAlert(); return
        }
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let nav = UINavigationController(rootViewController: vc)
        revealViewController().pushFrontViewController(nav, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
