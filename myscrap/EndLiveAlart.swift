//
//  CustomAlertView.swift
//  myscrap
//
//  Created by MyScrap on 7/4/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class EndLiveAlart: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    
    var delegate: EndLiveViewDelegate?
    var selectedOption = "First"
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()

    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        delegate?.cancelEndLiveButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSetButton(_ sender: Any) {
        delegate?.okEndLiveButtonTapped(selectedOption: selectedOption, textFieldValue: "")
        self.dismiss(animated: true, completion: nil)
        
    }
    

}

extension EndLiveAlart: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> EndLiveAlart?{
        return UIStoryboard(name: StoryBoard.LIVE, bundle: nil).instantiateViewController(withIdentifier: EndLiveAlart.id) as? EndLiveAlart
    }
}


