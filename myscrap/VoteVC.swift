//
//  VoteVC.swift
//  myscrap
//
//  Created by MyScrap on 8/1/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import DLRadioButton

class VoteVC: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var voterOneIV: UIImageView!
    @IBOutlet weak var voterTwoIV: UIImageView!
    @IBOutlet weak var voterThreeIV: UIImageView!
    @IBOutlet weak var voterFourIV: UIImageView!
    @IBOutlet weak var voterFiveIV: UIImageView!
    @IBOutlet weak var voterSixIV: UIImageView!
    @IBOutlet weak var voterSevenIV: UIImageView!
    @IBOutlet weak var voterEightIV: UIImageView!
    @IBOutlet weak var voterNineIV: UIImageView!
    @IBOutlet weak var voterTenIV: UIImageView!
    
    @IBOutlet weak var firstNameRB: DLRadioButton!
    @IBOutlet weak var secNameRB: DLRadioButton!
    @IBOutlet weak var thirdNameRB: DLRadioButton!
    @IBOutlet weak var fourthNameRB: DLRadioButton!
    @IBOutlet weak var fifthNameRB: DLRadioButton!
    @IBOutlet weak var sixthNameRB: DLRadioButton!
    @IBOutlet weak var seventhNameRB: DLRadioButton!
    @IBOutlet weak var eighthNameRB: DLRadioButton!
    @IBOutlet weak var ninthNameRB: DLRadioButton!
    @IBOutlet weak var tenthNameRB: DLRadioButton!
    
    @IBOutlet weak var firstNameBtn: UIButton!
    @IBOutlet weak var secNameBtn: UIButton!
    @IBOutlet weak var thirdNameBtn: UIButton!
    @IBOutlet weak var fourthNameBtn: UIButton!
    @IBOutlet weak var fifthNameBtn: UIButton!
    @IBOutlet weak var sixthNameBtn: UIButton!
    @IBOutlet weak var seventhNameBtn: UIButton!
    @IBOutlet weak var eighthNameBtn: UIButton!
    @IBOutlet weak var ninthNameBtn: UIButton!
    @IBOutlet weak var tenthNameBtn: UIButton!
    
    @IBOutlet weak var firstBioBtn: UIButton!
    @IBOutlet weak var secBioBtn: UIButton!
    @IBOutlet weak var thirdBioBtn: UIButton!
    @IBOutlet weak var fourthBioBtn: UIButton!
    @IBOutlet weak var fifthBioBtn: UIButton!
    @IBOutlet weak var sixthBioBtn: UIButton!
    @IBOutlet weak var seventhBioBtn: UIButton!
    @IBOutlet weak var eighthBioBtn: UIButton!
    @IBOutlet weak var ninthBioBtn: UIButton!
    @IBOutlet weak var tenthBioBtn: UIButton!
    
    @IBOutlet weak var secViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingFourConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingSecTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingThirdTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spacingFourBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var fifthViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fifthViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var sixViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sevenViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eightViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tenViewHeightConstraint: NSLayoutConstraint!
    
    //@IBOutlet weak var fourthRBHeightConstraint: NSLayoutConstraint!
    //@IBOutlet weak var forthBioHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var resultBtn: UIButton!
    
    let service = VotingService()
    var votersCount = [VotingItems?]()
    
    var firstVoterId = ""
    var secVoterId = ""
    var thirdVoterId = ""
    var fourthVoterId = ""
    var fifthVoterId = ""
    var sixthVoterId = ""
    var seventhVoterId = ""
    var eighthVoterId = ""
    var ninethVoterId = ""
    var tenthVoterId = ""
    
    
    var oneRB = false
    var twoRB = false
    var threeRB = false
    var fourRB = false
    var fiveRB = false
    var sixRB = false
    var sevenRB = false
    var eightRB = false
    var nineRB = false
    var tenRB = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.firstNameBtn.setTitle("", for: .normal)
        self.secNameBtn.setTitle("", for: .normal)
        self.thirdNameBtn.setTitle("", for: .normal)
        self.fourthNameBtn.setTitle("", for: .normal)
        self.fifthNameBtn.setTitle("", for: .normal)
        self.sixthNameBtn.setTitle("", for: .normal)
        self.seventhNameBtn.setTitle("", for: .normal)
        self.eighthNameBtn.setTitle("", for: .normal)
        self.ninthNameBtn.setTitle("", for: .normal)
        self.tenthNameBtn.setTitle("", for: .normal)
        
        firstNameRB.animationDuration = 0.0
        secNameRB.animationDuration = 0.0
        thirdNameRB.animationDuration = 0.0
        fourthNameRB.animationDuration = 0.0
        fifthNameRB.animationDuration = 0.0
        sixthNameRB.animationDuration = 0.0
        seventhNameRB.animationDuration = 0.0
        eighthNameRB.animationDuration = 0.0
        ninthNameRB.animationDuration = 0.0
        tenthNameRB.animationDuration = 0.0
        
        voteBtn.layer.cornerRadius = 8
        voteBtn.clipsToBounds = true
        
        firstNameRB.iconSize = 20
        secNameRB.iconSize = 20
        thirdNameRB.iconSize = 20
        fourthNameRB.iconSize = 20
        fifthNameRB.iconSize = 20
        sixthNameRB.iconSize = 20
        seventhNameRB.iconSize = 20
        eighthNameRB.iconSize = 20
        ninthNameRB.iconSize = 20
        tenthNameRB.iconSize = 20
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shareBtn.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.fontAwesome(ofSize: 20, style: .solid)], for: .normal)
        shareBtn.title = String.fontAwesomeIcon(name: .shareAlt)
        //shareBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        //shareBtn.setTitle(String.fontAwesomeIcon(name: .share), for: .normal)
        
        //navigationItem.title = "Poll"
        spinner.startAnimating()
        getVotersListAPI()
    }
    
    func getVotersListAPI() {
        service.getVotersLists()
        service.delegate = self
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        let encodedVoterId = firstVoterId.toBase64()
        //let id = Int(listingId)!
        //let firstActivityItem = "Check out the link below and Vote for \(firstNameBtn.currentTitle!) from MyScrap"
        let secondActivityItem : NSURL = NSURL(string: "https://myscrap.com/ms/vote/poll")!
        //let secondActivityItem : NSURL = NSURL(string: "iOSMyScrapApp://myscrap.com/marketLists/\(id)/userId\(userId)")!
        
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [secondActivityItem], applicationActivities: [])
        
        // This lines is for the popover you need to show in iPad
        //activityViewController.popoverPresentationController?.sourceView = (sender as! UIBarButtonItem)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func firstNameTapped(_ sender: UIButton) {
        oneRB = true
        twoRB = false
        threeRB = false
        fourRB = false
        fiveRB = false
        firstNameRB.isSelected = true
        sixRB = false
        sevenRB = false
        eightRB = false
        nineRB = false
        tenRB = false
    }
    @IBAction func secNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = true
        threeRB = false
        fourRB = false
        fiveRB = false
        secNameRB.isSelected = true
        sixRB = false
        sevenRB = false
        eightRB = false
        nineRB = false
        tenRB = false
    }
    @IBAction func thirdNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = false
        threeRB = true
        fourRB = false
        fiveRB = false
        thirdNameRB.isSelected = true
        sixRB = false
        sevenRB = false
        eightRB = false
        nineRB = false
        tenRB = false
    }
    @IBAction func fourthNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = false
        threeRB = false
        fourRB = true
        fiveRB = false
        fourthNameRB.isSelected = true
        sixRB = false
        sevenRB = false
        eightRB = false
        nineRB = false
        tenRB = false
    }
    @IBAction func fifthNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = false
        threeRB = false
        fourRB = false
        fiveRB = true
        fifthNameRB.isSelected = true
        sixRB = false
        sevenRB = false
        eightRB = false
        nineRB = false
        tenRB = false
    }
    
    @IBAction func sixNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = false
        threeRB = false
        fourRB = false
        fiveRB = false
        sixRB = true
        sixthNameRB.isSelected = true
        sevenRB = false
        eightRB = false
        nineRB = false
        tenRB = false
    }
    
    @IBAction func sevenNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = false
        threeRB = false
        fourRB = false
        fiveRB = false
        sixRB = false
        sevenRB = true
        seventhNameRB.isSelected = true
        eightRB = false
        nineRB = false
        tenRB = false
    }
    @IBAction func eightNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = false
        threeRB = false
        fourRB = false
        fiveRB = false
        sixRB = false
        sevenRB = false
        eightRB = true
        eighthNameRB.isSelected = true
        nineRB = false
        tenRB = false
    }
    @IBAction func nineNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = false
        threeRB = false
        fourRB = false
        fiveRB = false
        sixRB = false
        sevenRB = false
        eightRB = false
        nineRB = true
        ninthNameRB.isSelected = true
        tenRB = false
    }
    @IBAction func tenNameTapped(_ sender: UIButton) {
        oneRB = false
        twoRB = false
        threeRB = false
        fourRB = false
        fiveRB = true
        sixRB = false
        sevenRB = false
        eightRB = false
        nineRB = false
        tenRB = true
        tenthNameRB.isSelected = true
    }
    @IBAction func firstBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = firstVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = firstVoterId
            vc.fromPoll = true
            vc.navigationItem.title = "Vote for Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func secBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = secVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = secVoterId
            vc.fromPoll = true
            vc.navigationItem.title = "Vote For Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func thirdBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = thirdVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = thirdVoterId
            vc.fromPoll = true
            vc.navigationItem.title = "Vote for Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func fourthBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = fourthVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = fourthVoterId
            vc.fromPoll = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func fifthBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = fifthVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = fifthVoterId
            vc.fromPoll = true
            vc.navigationItem.title = "Vote for Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func sixthBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = sixthVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = sixthVoterId
            vc.fromPoll = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func sevenBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = seventhVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = seventhVoterId
            vc.fromPoll = true
            vc.navigationItem.title = "Vote for Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func eightBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = eighthVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = eighthVoterId
            vc.fromPoll = true
            vc.navigationItem.title = "Vote for Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func nineBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = ninethVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = ninethVoterId
            vc.fromPoll = true
            vc.navigationItem.title = "Vote for Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func tenBioTapped(_ sender: UIButton) {
//        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
//        self.addChildViewController(popOverVC)
//        popOverVC.voterId = tenthVoterId
//        popOverVC.view.frame = self.spinnerView.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        if let vc = ViewBioVoteVC.storyBoardInstance() {
            vc.voterId = tenthVoterId
            vc.fromPoll = true
            vc.navigationItem.title = "Vote for Best Trader"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func voteBtnTapped(_ sender: UIButton) {
        voteBtn.isEnabled = false
        /*if oneRB {
            service.voteNominee(voterId: firstVoterId)
        } else if twoRB {
            service.voteNominee(voterId: secVoterId)
        } else if threeRB {
            service.voteNominee(voterId: thirdVoterId)
        } else if fourRB {
            service.voteNominee(voterId: fourthVoterId)
        } else if fiveRB {
            service.voteNominee(voterId: fifthVoterId)
        } else if sixRB {
            service.voteNominee(voterId: sixthVoterId)
        } else if sevenRB {
            service.voteNominee(voterId: seventhVoterId)
        } else if eightRB {
            service.voteNominee(voterId: eighthVoterId)
        } else if nineRB {
            service.voteNominee(voterId: ninethVoterId)
        } else if tenRB {
            service.voteNominee(voterId: tenthVoterId)
        } else {
            print("Error in Radio button, nothing selected")
            let alert = UIAlertController(title: "ERROR!", message: "Please select the person whom you wants to vote", preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }*/
        service.delegate = self
    }
    @IBAction func resultBtnTapped(_ sender: UIButton) {
        if let vc = VoterResultVC.storyBoardInstance() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func voteDone() {
        
        if votersCount.count <= 3 {
            
        } else if votersCount.count <= 4 {
            
        }
    }
    
    @IBAction func supportContact(_ sender: UIButton) {
        guard let vc = ConversationVC.storyBoardInstance() else { return }
        vc.friendId = "32"
        vc.profileName = "Jessica Syth"
        vc.colorCode = "#996515"
        vc.profileImage = "https://myscrap.com/style/images/user_profile/5222sz160x1601501248781.jpg"
        vc.jid = "jessica32@myscrap.com"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    static func storyBoardInstance() -> VoteVC? {
        let st = UIStoryboard.Vote
        return st.instantiateViewController(withIdentifier: VoteVC.id) as? VoteVC
    }
    
    static func controllerInstance(voterId: String, selectedRb: Bool) -> VoteVC {
        let vc = VoteVC()
        vc.firstVoterId = voterId
        vc.oneRB = selectedRb
        return vc
    }

}
extension VoteVC : VotingServiceDelegate {
    func didVoteStatus(message: String) {
        print("Vote done")
        DispatchQueue.main.async {
            if let vc = VoterResultVC.storyBoardInstance() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func didReceiveError(error: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ERROR!", message: "There are some technical issue found while fetching voters list. Please try again later..", preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didReceiveBio(name: String, designation: String, company: String, profile_img: String, office: String, phone: String, email: String, country: String, bioDescription: String, awardDescription: String, pictureUrl: [String],userId: String) {
        print("Get Voters bio will not triggered here")
    }
    
    func didReceiveVoters(lists: [VotingItems], isVoteDone : Bool, isPollClosed: Bool) {
        
        DispatchQueue.main.async {
            self.votersCount = lists
            
            if lists.count != 0 {
                
                if isVoteDone {
                    self.voteBtn.isEnabled = false
                    self.voteBtn.backgroundColor = .lightGray
                    
//                    self.firstNameRB.iconColor = .lightGray
//                    self.secNameRB.iconColor = .lightGray
//                    self.thirdNameRB.iconColor = .lightGray
//                    self.fourthNameRB.iconColor = .lightGray
//                    self.fifthNameRB.iconColor = .lightGray
                    
                    self.firstNameRB.isUserInteractionEnabled = false
                    self.firstNameRB.isEnabled = false
                    self.secNameRB.isUserInteractionEnabled = false
                    self.secNameRB.isEnabled = false
                    self.thirdNameRB.isUserInteractionEnabled = false
                    self.thirdNameRB.isEnabled = false
                    self.fourthNameRB.isUserInteractionEnabled = false
                    self.fourthNameRB.isEnabled = false
                    self.fifthNameRB.isUserInteractionEnabled = false
                    self.fifthNameRB.isEnabled = false
                    self.sixthNameRB.isUserInteractionEnabled = false
                    self.sixthNameRB.isEnabled = false
                    self.seventhNameRB.isUserInteractionEnabled = false
                    self.seventhNameRB.isEnabled = false
                    self.eighthNameRB.isUserInteractionEnabled = false
                    self.eighthNameRB.isEnabled = false
                    self.ninthNameRB.isUserInteractionEnabled = false
                    self.ninthNameRB.isEnabled = false
                    self.tenthNameRB.isUserInteractionEnabled = false
                    self.tenthNameRB.isEnabled = false
                    
                    self.firstNameBtn.isEnabled = false
                    self.firstNameBtn.isUserInteractionEnabled = false
                    self.secNameBtn.isEnabled = false
                    self.secNameBtn.isUserInteractionEnabled = false
                    self.thirdNameBtn.isEnabled = false
                    self.thirdNameBtn.isUserInteractionEnabled = false
                    self.fourthNameBtn.isEnabled = false
                    self.fourthNameBtn.isUserInteractionEnabled = false
                    self.fifthNameBtn.isEnabled = false
                    self.fifthNameBtn.isUserInteractionEnabled = false
                    self.sixthNameBtn.isEnabled = false
                    self.sixthNameBtn.isUserInteractionEnabled = false
                    self.seventhNameBtn.isEnabled = false
                    self.seventhNameBtn.isUserInteractionEnabled = false
                    self.eighthNameBtn.isEnabled = false
                    self.eighthNameBtn.isUserInteractionEnabled = false
                    self.ninthNameBtn.isEnabled = false
                    self.ninthNameBtn.isUserInteractionEnabled = false
                    self.tenthNameBtn.isEnabled = false
                    self.tenthNameBtn.isUserInteractionEnabled = false
                    
                    self.resultBtn.isEnabled = true
                    self.resultBtn.setTitleColor(.MyScrapGreen, for: .normal)
                    
                    if lists[0].isSelected {
                        self.firstNameRB.isSelected = true
                        self.firstNameRB.isEnabled = true
                    } else if lists[1].isSelected {
                        self.secNameRB.isSelected = true
                        self.secNameRB.isEnabled = true
                    } else if lists[2].isSelected {
                        self.thirdNameRB.isSelected = true
                        self.thirdNameRB.isEnabled = true
                    } else if lists[3].isSelected {
                        self.fourthNameRB.isSelected = true
                        self.fourthNameRB.isEnabled = true
                    } else if lists[4].isSelected {
                        self.fifthNameRB.isSelected = true
                        self.fifthNameRB.isEnabled = true
                    } else if lists[5].isSelected {
                        self.sixthNameRB.isSelected = true
                        self.sixthNameRB.isEnabled = true
                    } else if lists[6].isSelected {
                        self.seventhNameRB.isSelected = true
                        self.seventhNameRB.isEnabled = true
                    } else if lists[7].isSelected {
                        self.eighthNameRB.isSelected = true
                        self.eighthNameRB.isEnabled = true
                    } else if lists[8].isSelected {
                        self.ninthNameRB.isSelected = true
                        self.ninthNameRB.isEnabled = true
                    } else if lists[9].isSelected {
                        self.tenthNameRB.isSelected = true
                        self.tenthNameRB.isEnabled = true
                    }
                    
                } else {
                    self.voteBtn.isEnabled = true
                    if self.oneRB {
                        self.firstNameRB.isSelected = true
                    } else if self.twoRB {
                        self.secNameRB.isSelected = true
                    } else if self.threeRB {
                        self.thirdNameRB.isSelected = true
                    } else if self.fourRB {
                        self.fourthNameRB.isSelected = true
                    } else if self.fiveRB {
                        self.fifthNameRB.isSelected = true
                    } else if self.sixRB {
                        self.sixthNameRB.isSelected = true
                    } else if self.sevenRB {
                        self.seventhNameRB.isSelected = true
                    } else if self.eightRB {
                        self.eighthNameRB.isSelected = true
                    } else if self.nineRB {
                        self.ninthNameRB.isSelected = true
                    } else if self.tenRB {
                        self.tenthNameRB.isSelected = true
                    } else {
                        self.firstNameRB.isSelected = true
                    }
                    //self.resultBtn.isEnabled = false
                    //self.resultBtn.setTitleColor(.lightGray, for: .normal)
                }
                /*if lists.count >= 5 {
                    if lists[0].isSelected {
                        self.firstNameRB.isSelected = true
                    } else if lists[1].isSelected {
                        self.secNameRB.isSelected = true
                    } else if lists[2].isSelected {
                        self.thirdNameRB.isSelected = true
                    } else if lists[3].isSelected {
                        self.fourthNameRB.isSelected = true
                    } else {
                        self.fifthNameRB.isSelected = true
                    }
                    
                    self.firstVoterId = lists[0].voterId
                    self.secVoterId = lists[1].voterId
                    self.thirdVoterId = lists[2].voterId
                    self.fourthVoterId = lists[3].voterId
                    self.fifthVoterId = lists[4].voterId
                    
                    self.voterOneIV.sd_setImage(with: URL(string: lists[0].profile_img), completed: nil)
                    self.voterTwoIV.sd_setImage(with: URL(string: lists[1].profile_img), completed: nil)
                    self.voterThreeIV.sd_setImage(with: URL(string: lists[2].profile_img), completed: nil)
                    self.voterFourIV.sd_setImage(with: URL(string: lists[3].profile_img), completed: nil)
                    self.voterFiveIV.sd_setImage(with: URL(string: lists[4].profile_img), completed: nil)
                    
                    self.firstNameBtn.setTitle(lists[0].name, for: .normal)
                    self.secNameBtn.setTitle(lists[1].name, for: .normal)
                    self.thirdNameBtn.setTitle(lists[2].name, for: .normal)
                    self.fourthNameBtn.setTitle(lists[3].name, for: .normal)
                    self.fifthNameBtn.setTitle(lists[4].name, for: .normal)
                    
                    
                    
                } else if lists.count == 4 {
                    if lists[0].isSelected {
                        self.firstNameRB.isSelected = true
                    } else if lists[1].isSelected {
                        self.secNameRB.isSelected = true
                    } else if lists[2].isSelected {
                        self.thirdNameRB.isSelected = true
                    } else if lists[3].isSelected {
                        self.fourthNameRB.isSelected = true
                    }
                    self.fifthViewHeightConstraint.constant = 0
                    self.fifthViewConstraint.constant = 0
                    
                    self.fifthNameRB.isHidden = true
                    self.fifthNameBtn.isHidden = true
                    self.fifthBioBtn.isHidden = true
                    
                    self.firstVoterId = lists[0].voterId
                    self.secVoterId = lists[1].voterId
                    self.thirdVoterId = lists[2].voterId
                    self.fourthVoterId = lists[3].voterId
                    
                    self.voterOneIV.sd_setImage(with: URL(string: lists[0].profile_img), completed: nil)
                    self.voterTwoIV.sd_setImage(with: URL(string: lists[1].profile_img), completed: nil)
                    self.voterThreeIV.sd_setImage(with: URL(string: lists[2].profile_img), completed: nil)
                    self.voterFourIV.sd_setImage(with: URL(string: lists[3].profile_img), completed: nil)
                    
                    self.firstNameBtn.setTitle(lists[0].name, for: .normal)
                    self.secNameBtn.setTitle(lists[1].name, for: .normal)
                    self.thirdNameBtn.setTitle(lists[2].name, for: .normal)
                    self.fourthNameBtn.setTitle(lists[3].name, for: .normal)
                } else if lists.count == 3 {
                    if lists[0].isSelected {
                        self.firstNameRB.isSelected = true
                    } else if lists[1].isSelected {
                        self.secNameRB.isSelected = true
                    } else if lists[2].isSelected {
                        self.thirdNameRB.isSelected = true
                    }
                    self.fifthViewHeightConstraint.constant = 0
                    self.fourthViewHeightConstraint.constant = 0
                    //self.forthBioHeightConstraint.constant = 0
                    //self.fourthRBHeightConstraint.constant = 0
                    self.spacingFourConstraint.constant = 0
                    self.spacingFourBottomConstraint.constant = 0
                    
                    self.fourthNameRB.isHidden = true
                    self.fifthNameRB.isHidden = true
                    self.fourthNameBtn.isHidden = true
                    self.fifthNameBtn.isHidden = true
                    self.fourthBioBtn.isHidden = true
                    self.fifthBioBtn.isHidden = true
                    
                    
                    self.firstVoterId = lists[0].voterId
                    self.secVoterId = lists[1].voterId
                    self.thirdVoterId = lists[2].voterId
                    
                    self.voterOneIV.sd_setImage(with: URL(string: lists[0].profile_img), completed: nil)
                    self.voterTwoIV.sd_setImage(with: URL(string: lists[1].profile_img), completed: nil)
                    self.voterThreeIV.sd_setImage(with: URL(string: lists[2].profile_img), completed: nil)
                    
                    self.firstNameBtn.setTitle(lists[0].name, for: .normal)
                    self.secNameBtn.setTitle(lists[1].name, for: .normal)
                    self.thirdNameBtn.setTitle(lists[2].name, for: .normal)
                } else if lists.count == 2 {
                    self.firstVoterId = lists[0].voterId
                    self.secVoterId = lists[1].voterId
                    
                    self.voterOneIV.sd_setImage(with: URL(string: lists[0].profile_img), completed: nil)
                    self.voterTwoIV.sd_setImage(with: URL(string: lists[1].profile_img), completed: nil)
                    
                    //Default selection of radio button
                    if lists[0].isSelected {
                        self.firstNameRB.isSelected = true
                    } else if lists[1].isSelected {
                        self.secNameRB.isSelected = true
                    }
                    
                    self.thirdNameRB.isHidden = true
                    self.fourthNameRB.isHidden = true
                    self.fifthNameRB.isHidden = true
                    
                    self.thirdNameBtn.isHidden = true
                    self.fourthNameBtn.isHidden = true
                    self.fifthNameBtn.isHidden = true
                    
                    self.thirdBioBtn.isHidden = true
                    self.fourthBioBtn.isHidden = true
                    self.fifthBioBtn.isHidden = true
                    
                    //Assigning height
                    self.fifthViewHeightConstraint.constant = 0
                    self.fourthViewHeightConstraint.constant = 0
                    //self.forthBioHeightConstraint.constant = 0
                    self.thirdViewHeightConstraint.constant = 0
                    //self.fourthRBHeightConstraint.constant = 0
                    self.spacingFourConstraint.constant = 0
                    self.spacingFourBottomConstraint.constant = 0
                    self.spacingThirdTopConstraint.constant = 0
                    
                    self.firstNameBtn.setTitle(lists[0].name, for: .normal)
                    self.secNameBtn.setTitle(lists[1].name, for: .normal)
                    
                    
                } else if lists.count == 1 {
                    if lists[0].isSelected {
                        self.firstNameRB.isSelected = true
                    }
                    
                    self.voterOneIV.sd_setImage(with: URL(string: lists[0].profile_img), completed: nil)
                    
                    self.firstVoterId = lists[0].voterId
                    
                    self.secNameRB.isHidden = true
                    self.thirdNameRB.isHidden = true
                    self.fourthNameRB.isHidden = true
                    self.fifthNameRB.isHidden = true
                    
                    self.secNameBtn.isHidden = true
                    self.thirdNameBtn.isHidden = true
                    self.fourthNameBtn.isHidden = true
                    self.fifthNameBtn.isHidden = true
                    
                    self.secBioBtn.isHidden = true
                    self.thirdBioBtn.isHidden = true
                    self.fourthBioBtn.isHidden = true
                    self.fifthBioBtn.isHidden = true
                    
                    //Assigning height
                    self.fifthViewHeightConstraint.constant = 0
                    self.fourthViewHeightConstraint.constant = 0
                    //self.forthBioHeightConstraint.constant = 0
                    self.thirdViewHeightConstraint.constant = 0
                    self.secViewHeightConstraint.constant = 0
                    //self.fourthRBHeightConstraint.constant = 0
                    self.spacingFourConstraint.constant = 0
                    self.spacingFourBottomConstraint.constant = 0
                    self.spacingThirdTopConstraint.constant = 0
                    self.spacingSecTopConstraint.constant = 0
                    
                    self.firstNameBtn.setTitle(lists[0].name, for: .normal)
                    
                    
                } else {
                    print("Voters array is empty")
                }*/
                
                
                self.firstVoterId = lists[0].voterId
                self.voterOneIV.sd_setImage(with: URL(string: lists[0].profile_img), completed: nil)
                self.firstNameBtn.setTitle(lists[0].name, for: .normal)
                self.secVoterId = lists[1].voterId
                self.voterTwoIV.sd_setImage(with: URL(string: lists[1].profile_img), completed: nil)
                self.secNameBtn.setTitle(lists[1].name, for: .normal)
                self.thirdVoterId = lists[2].voterId
                self.voterThreeIV.sd_setImage(with: URL(string: lists[2].profile_img), completed: nil)
                self.thirdNameBtn.setTitle(lists[2].name, for: .normal)
                self.fourthVoterId = lists[3].voterId
                self.voterFourIV.sd_setImage(with: URL(string: lists[3].profile_img), completed: nil)
                self.fourthNameBtn.setTitle(lists[3].name, for: .normal)
                self.fifthVoterId = lists[4].voterId
                self.voterFiveIV.sd_setImage(with: URL(string: lists[4].profile_img), completed: nil)
                self.fifthNameBtn.setTitle(lists[4].name, for: .normal)
                self.sixthVoterId = lists[5].voterId
                self.voterSixIV.sd_setImage(with: URL(string: lists[5].profile_img), completed: nil)
                self.sixthNameBtn.setTitle(lists[5].name, for: .normal)
                self.seventhVoterId = lists[6].voterId
                self.voterSevenIV.sd_setImage(with: URL(string: lists[6].profile_img), completed: nil)
                self.seventhNameBtn.setTitle(lists[6].name, for: .normal)
                self.eighthVoterId = lists[7].voterId
                self.voterEightIV.sd_setImage(with: URL(string: lists[7].profile_img), completed: nil)
                self.eighthNameBtn.setTitle(lists[7].name, for: .normal)
                self.ninethVoterId = lists[8].voterId
                self.voterNineIV.sd_setImage(with: URL(string: lists[8].profile_img), completed: nil)
                self.ninthNameBtn.setTitle(lists[8].name, for: .normal)
                self.tenthVoterId = lists[9].voterId
                self.voterTenIV.sd_setImage(with: URL(string: lists[9].profile_img), completed: nil)
                self.tenthNameBtn.setTitle(lists[9].name, for: .normal)
                
            } else {
                print("No voters list available")
                let alert = UIAlertController(title: "OOPS!", message: "No Voters found", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            self.spinner.stopAnimating()
            self.spinnerView.isHidden = true
            
            
        }
    }
    func didReceiveVotingResult(lists: [VotingItems], isPollClosed: Bool) {
        print("This will not triggered")
    }
    
}
