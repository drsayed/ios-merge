//
//  CovidPollPopupVC.swift
//  myscrap
//
//  Created by MyScrap on 14/03/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class CovidPollPopupVC: UIViewController {

    @IBOutlet weak var option1Btn: CorneredButton!
    @IBOutlet weak var option2Btn: CorneredButton!
    @IBOutlet weak var option3Btn: CorneredButton!
    @IBOutlet weak var option4Btn: CorneredButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var popupView: EachCorneredView!
    
    //Model Class service
    fileprivate var service = CovidPollService()
    
    //Track the controller status
    typealias DidPoll = (Bool) -> Void
    var didPoll: DidPoll?
    
    convenience init(didPoll: @escaping DidPoll){
        self.init()
        self.didPoll = didPoll
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        //Setting up the Popup view design
        self.popupView.clipsToBounds = true
        //self.popupView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()

        // Setting up the button background color and Text color
        option1Btn.setTitleColor(.black, for: .normal)
        option2Btn.setTitleColor(.black, for: .normal)
        option3Btn.setTitleColor(.black, for: .normal)
        option4Btn.setTitleColor(.black, for: .normal)
        
        option1Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option2Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option3Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option4Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        
        //Setting up the Font for Buttons
        option1Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option2Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option3Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option4Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        //Enabling all the buttons
        option1Btn.isUserInteractionEnabled = true
        option2Btn.isUserInteractionEnabled = true
        option3Btn.isUserInteractionEnabled = true
        option4Btn.isUserInteractionEnabled = true
        
        //Swipe up to remove this UI
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUPGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        //Calling Model class service
        service.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    //MARK :- Recognising Swipeup Gesture
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
        UIView.animate(withDuration: 2.00, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    static func storyBoardInstance() -> CovidPollPopupVC? {
        let st = UIStoryboard.MAIN
        return st.instantiateViewController(withIdentifier: CovidPollPopupVC.id) as? CovidPollPopupVC
    }
    
    @IBAction func option1BtnTapped(_ sender: UIButton) {
        // Customizing the button background color and Text color
        option1Btn.setTitleColor(.white, for: .normal)
        option2Btn.setTitleColor(.black, for: .normal)
        option3Btn.setTitleColor(.black, for: .normal)
        option4Btn.setTitleColor(.black, for: .normal)
        
        option1Btn.backgroundColor = UIColor.MyScrapGreen
        option2Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option3Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option4Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        
        //Customizing the Button title font
        option1Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        option2Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option3Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option4Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        //Calling the api to insert the poll answer
        sendPollAns(option: "1")
        
        //Disable all the buttons
        option1Btn.isUserInteractionEnabled = false
        option2Btn.isUserInteractionEnabled = false
        option3Btn.isUserInteractionEnabled = false
        option4Btn.isUserInteractionEnabled = false
    }
    @IBAction func option2BtnTapped(_ sender: Any) {
        // Customizing the button background color and Text color
        option1Btn.setTitleColor(.black, for: .normal)
        option2Btn.setTitleColor(.white, for: .normal)
        option3Btn.setTitleColor(.black, for: .normal)
        option4Btn.setTitleColor(.black, for: .normal)
        
        option1Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option2Btn.backgroundColor = UIColor.MyScrapGreen
        option3Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option4Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        
        //Customizing the Button title font
        option1Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option2Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        option3Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option4Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        //Calling the api to insert the poll answer
        sendPollAns(option: "2")
        
        //Disable all the buttons
        option1Btn.isUserInteractionEnabled = false
        option2Btn.isUserInteractionEnabled = false
        option3Btn.isUserInteractionEnabled = false
        option4Btn.isUserInteractionEnabled = false
    }
    @IBAction func option3BtnTapped(_ sender: Any) {
        // Customizing the button background color and Text color
        option1Btn.setTitleColor(.black, for: .normal)
        option2Btn.setTitleColor(.black, for: .normal)
        option3Btn.setTitleColor(.white, for: .normal)
        option4Btn.setTitleColor(.black, for: .normal)
        
        option1Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option2Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option3Btn.backgroundColor = UIColor.MyScrapGreen
        option4Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        
        //Customizing the Button title font
        option1Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option2Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option3Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        option4Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        //Calling the api to insert the poll answer
        sendPollAns(option: "3")
        
        //Disable all the buttons
        option1Btn.isUserInteractionEnabled = false
        option2Btn.isUserInteractionEnabled = false
        option3Btn.isUserInteractionEnabled = false
        option4Btn.isUserInteractionEnabled = false
    }
    @IBAction func option4BtnTapped(_ sender: UIButton) {
        // Setting up the button background color and Text color
        option1Btn.setTitleColor(.black, for: .normal)
        option2Btn.setTitleColor(.black, for: .normal)
        option3Btn.setTitleColor(.black, for: .normal)
        option4Btn.setTitleColor(.white, for: .normal)
        
        option1Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option2Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option3Btn.backgroundColor = UIColor(hexString: "#D3D3D3")
        option4Btn.backgroundColor = UIColor.MyScrapGreen
        
        //Customizing the Button title font
        option1Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option2Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option3Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        option4Btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        
        //Calling the api to insert the poll answer
        sendPollAns(option: "4")
        
        //Disable all the buttons
        option1Btn.isUserInteractionEnabled = false
        option2Btn.isUserInteractionEnabled = false
        option3Btn.isUserInteractionEnabled = false
        option4Btn.isUserInteractionEnabled = false
    }
    
    func sendPollAns(option: String) {
        removeAnimate()
        service.pollAnsSend(option: option)
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
extension CovidPollPopupVC : CovidServiceDelegate {
    func DidGetPollStatus(isPollDone:Bool) {
        DispatchQueue.main.async {
            print("")
        }
    }
    func DidReceiveCovidResponse(status: String) {
        print("Status : \(status)")
        DispatchQueue.main.async {
            if status == "Polling successfully done" {
                //AlertView.instance.showAlert(title: "Thank You", message: "You have successfully polled", alertType: .success)
                self.showToast(message: "Thank You! for your voting")
                self.didPoll?(true)
            } else {
                //AlertView.instance.showAlert(title: "OOPS", message: status, alertType: .failure)
                self.showToast(message: status)
                self.didPoll?(false)
            }
        }
    }
    
    func DidReceivedCovidError(error: String) {
        //AlertView.instance.showAlert(title: "OOPS", message: "Your poll was unsuccessfully. Please try again later", alertType: .failure)
        DispatchQueue.main.async {
            self.showToast(message: error)
        }
    }
}
