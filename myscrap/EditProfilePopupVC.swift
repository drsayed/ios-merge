//
//  EditProfilePopupVC.swift
//  myscrap
//
//  Created by MyScrap on 02/07/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class EditProfilePopupVC: UIViewController {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var contentLBL: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    typealias DidRemoved = (Bool) -> Void
    var didRemove: DidRemoved?
    
    convenience init(didPost: @escaping DidRemoved){
        self.init()
        self.didRemove = didRemove
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.popupView.clipsToBounds = true
        self.popupView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.removeAnimate()
        didRemove?(true)
    }
    
    @IBAction func editProfileBtnTapped(_ sender: UIButton) {
        pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: EditProfileController.id)
        didRemove?(true)
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    static func storyBoardInstance() -> EditProfilePopupVC? {
        let st = UIStoryboard.MAIN
        return st.instantiateViewController(withIdentifier: EditProfilePopupVC.id) as? EditProfilePopupVC
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
