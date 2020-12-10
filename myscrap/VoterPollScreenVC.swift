//
//  VoterPollScreenVC.swift
//  myscrap
//
//  Created by MyScrap on 10/10/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import CoreLocation

class VoterPollScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var resultBtn: UIButton!
    
    let service = VotingService()
    var votersDataSource = [VotingItems?]()
    var voterId = ""
    var selectedIndex:IndexPath?
    var isVoteDone = false
    var isPollClosed = false
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupTableView()
        voteBtn.layer.cornerRadius = 8
        voteBtn.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //shareBtn.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.fontAwesome(ofSize: 20, style: .solid)], for: .normal)
        //shareBtn.title = String.fontAwesomeIcon(name: .shareAlt)
        
        //shareBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        //shareBtn.setTitle(String.fontAwesomeIcon(name: .share), for: .normal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        //navigationItem.title = "Poll"
        spinner.startAnimating()
        getVotersListAPI()
    }
    
    func getVotersListAPI() {
        service.getVotersLists()
        service.delegate = self
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        let encodedVoterId = voterId.toBase64()
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
    
    @IBAction func voteBtnTapped(_ sender: UIButton) {
        //voteBtn.isEnabled = false
        spinnerView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        spinnerView.isHidden = false
        spinner.startAnimating()
        if voterId == "" {
            print("Error in Radio button, nothing selected")
            let alert = UIAlertController(title: "Ouch!", message: "Please select the person whom you wants to vote", preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            voteBtn.isEnabled = true
            spinnerView.isHidden = true
            spinner.stopAnimating()
        } else {
            
            //getting current location
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                if let currentLocation = locManager.location {
                    print(currentLocation.coordinate.latitude)
                    print(currentLocation.coordinate.longitude)
                    let lat = String(currentLocation.coordinate.latitude)
                    let long = String(currentLocation.coordinate.longitude)
                    service.voteNominee(voterId: voterId, lat: lat, long: long)
                }
                
            } else {
                service.voteNominee(voterId: voterId, lat: "", long: "")
            }
            
            print("Selected voterId : \(voterId)")
            
            service.delegate = self
        }
        
    }
    
    @IBAction func resultBtnTapped(_ sender: UIButton) {
        if isPollClosed {
            if let vc = VotingResultVC.storyBoardInstance() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if self.isVoteDone {
                if let vc = VotingResultVC.storyBoardInstance() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Oops!", message: "To check the poll results, kindly VOTE for the nominee.", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    VoterPollScreenVC().dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
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
    
    func setupTableView() {
        //var frame = tableView.frame
        //frame.size.height = tableView.contentSize.height
        //tableView.frame = frame
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if votersDataSource.count != 0 {
            return votersDataSource.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VoterPollTVCell = tableView.dequeueReusableCell(withIdentifier: "vote_poll", for: indexPath) as! VoterPollTVCell
        
        let row = votersDataSource[indexPath.row]
        cell.voterName.setTitle(row?.name, for: .normal)
        cell.voterImageView.sd_setImage(with: URL(string: row!.profile_img), completed: nil)
        cell.selectionStyle = .none
        
        if isVoteDone {
            if row!.isSelected {
                 cell.voterRadioBtn.isSelected = true
                 //cell.voterRadioBtn.isEnabled = true
                //cell.voterRadioBtn.isUserInteractionEnabled = false
            } else {
                cell.voterRadioBtn.isSelected = false
                cell.voterRadioBtn.isEnabled = false
            }
            
        } else {
            if selectedIndex == indexPath {
                cell.voterRadioBtn.isSelected = true
            } else {
                cell.voterRadioBtn.isSelected = false
            }
        }
        cell.bioActionBlock = {
            if let vc = ViewBioVoteVC.storyBoardInstance() {
                vc.voterId = row!.voterId
                vc.fromPoll = true
                //vc.navigationItem.title = "Vote for Best Trader"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        //cell.voterRadioBtn = cell.voterRadioBtn.otherButtons[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell: VoterPollTVCell = tableView.dequeueReusableCell(withIdentifier: "vote_poll", for: indexPath) as! VoterPollTVCell
//        cell.voterRadioBtn.isSelected = true
        let row = indexPath.row
        let id = votersDataSource[row]?.voterId
        voterId = id!
        selectedIndex = indexPath
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    static func controllerInstance(voterId: String) -> VoterPollScreenVC {
        let vc = VoterPollScreenVC()
        vc.voterId = voterId
        return vc
    }
    
    static func storyBoardInstance() -> VoterPollScreenVC? {
        let st = UIStoryboard.Vote
        return st.instantiateViewController(withIdentifier: VoterPollScreenVC.id) as? VoterPollScreenVC
    }

}
extension VoterPollScreenVC: VotingServiceDelegate {
    func didReceiveVoters(lists: [VotingItems], isVoteDone: Bool, isPollClosed: Bool) {
        DispatchQueue.main.async {
            self.votersDataSource = lists
            self.isVoteDone = isVoteDone
            self.isPollClosed = isPollClosed
            if self.isPollClosed {
                self.voteBtn.isEnabled = false
                self.voteBtn.backgroundColor = .lightGray
                self.resultBtn.setTitleColor(.MyScrapGreen, for: .normal)
            } else {
                if self.isVoteDone{
                    self.voteBtn.isEnabled = false
                    self.voteBtn.backgroundColor = .lightGray
                    //self.resultBtn.isHidden = false
                    self.resultBtn.setTitleColor(.MyScrapGreen, for: .normal)
                } else {
                    //self.resultBtn.isHidden = true
                    self.resultBtn.setTitleColor(.lightGray, for: .normal)
                }
            }
            
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.spinner.stopAnimating()
            self.spinnerView.isHidden = true
        }
    }
    
    
    func didReceiveVotingResult(lists: [VotingItems], isPollClosed: Bool) {
        print("This will not triggered")
    }
    
    func didReceiveError(error: String) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            /*let alert = UIAlertController(title: "ERROR!", message: "There are some technical issue found while fetching voters list. Please try again later..", preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)*/
            
            self.spinner.isHidden = true
            self.spinnerView.isHidden = true
            if network.reachability.isReachable == true {
                if error == "Invalid voterid" {
                    print("Voter id wrong")
                } else if error == "Invalid userid" {
                    print("User id is wrong")
                } else {
                    let alert = UIAlertController(title: "Oops!", message: "\(error)", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Oops!", message: "Seems no Internet Connection, please try again.", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func didReceiveBio(name: String, designation: String, company: String, profile_img: String, office: String, phone: String, email: String, country: String, bioDescription: String, awardDescription: String, pictureUrl: [String],userId: String) {
        print("This method will not triggered")
    }
    
    func didVoteStatus(message: String) {
        print("Vote done")
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            if let vc = VotingResultVC.storyBoardInstance() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
