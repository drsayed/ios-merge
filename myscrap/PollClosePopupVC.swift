//
//  PollClosePopupVC.swift
//  myscrap
//
//  Created by MyScrap on 11/7/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class PollClosePopupVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
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
        
        //let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUPGesture))
        //swipeUp.direction = .up
        //self.view.addGestureRecognizer(swipeUp)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    @objc func swipeUPGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == .up {
            print("Swipe Up")
            self.removeAnimate()
        }
        
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.removeAnimate()
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
    
    static func storyBoardInstance() -> PollClosePopupVC? {
        let st = UIStoryboard.Vote
        return st.instantiateViewController(withIdentifier: PollClosePopupVC.id) as? PollClosePopupVC
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
