//
//  MarketAdvPopUpVC.swift
//  myscrap
//
//  Created by MyScrap on 9/7/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MarketAdvPopUpVC: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var marketIV: UIImageView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        marketIV.image = UIImage.fontAwesomeIcon(name: .shoppingCart, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        self.popupView.clipsToBounds = true
        self.popupView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        tap.numberOfTapsRequired = 1
        tapView.isUserInteractionEnabled = true
        tapView.addGestureRecognizer(tap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUPGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    @objc func swipeUPGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
         if gesture.direction == .up {
            print("Swipe Up")
            self.removeAnimate()
        }
        
    }
    
    /**
     Tapped Market Ad Image
     **/
    @objc func tapDetected() {
        pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
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
    
    static func storyBoardInstance() -> MarketAdvPopUpVC? {
        let st = UIStoryboard.MAIN
        return st.instantiateViewController(withIdentifier: MarketAdvPopUpVC.id) as? MarketAdvPopUpVC
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
