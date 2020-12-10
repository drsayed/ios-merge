//
//  VotingResultVC.swift
//  myscrap
//
//  Created by MyScrap on 8/8/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class VotingResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var returnToPollBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerView: UIView!
    
    let service = VotingService()
    var datasource = [VotingItems?]()
    
    var pollingClosed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        spinner.startAnimating()
        spinnerView.isHidden = false
        getVotersResultAPI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        //navigationItem.title = "Poll Detail"
        //navigationItem.hidesBackButton = true
    }
    
    func getVotersResultAPI() {
        service.getVoteResults()
        service.delegate = self
    }
    
    func setupTableView() {
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.register(VotingResultTVCell.self, forCellReuseIdentifier: "vote_result")
    }
    
    @IBAction func returnBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datasource.count != 0 {
            return datasource.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VotingResultTVCell = tableView.dequeueReusableCell(withIdentifier: "vote_result", for: indexPath) as! VotingResultTVCell
        print("Name : \(datasource[indexPath.row]?.name)")
        print("Percentage : \(datasource[indexPath.row]?.percentage)")
        cell.nameLbl.text = datasource[indexPath.row]?.name
        
        let percentageString = String(format: "%d", datasource[indexPath.row]!.percentage)
        /*let voteCountString = String(format: "%d", datasource[indexPath.row]!.votingCount)
        let attribPercentString = NSMutableAttributedString(string: percentageString + "%", attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
        if voteCountString == "1" || voteCountString == "0" {
            let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString + " vote)", attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 15)!])
            attribPercentString.append(attribVoteCountString)
            cell.resultLbl.attributedText = attribPercentString
        } else {
            let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString + " votes)", attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 15)!])
            attribPercentString.append(attribVoteCountString)
            cell.resultLbl.attributedText = attribPercentString
        }*/
        
        cell.resultLbl.text = percentageString + "%"
        
        
        
        
        let percentage = datasource[indexPath.row]!.percentage
        if percentage <= 10 && percentage > 0{
            cell.percentBarWidthConstraint.constant = 34.3
        } else if percentage <= 20 && percentage >= 10{
            cell.percentBarWidthConstraint.constant = 68.6
        } else if percentage <= 30 && percentage >= 20{
            cell.percentBarWidthConstraint.constant = 102.9
        } else if percentage <= 40 && percentage >= 30{
            cell.percentBarWidthConstraint.constant = 137.2
        } else if percentage <= 50 && percentage >= 40{
            cell.percentBarWidthConstraint.constant = 171.5
        } else if percentage <= 60 && percentage >= 50{
            cell.percentBarWidthConstraint.constant = 205.8
        } else if percentage <= 70 && percentage >= 60{
            cell.percentBarWidthConstraint.constant = 240.1
        } else if percentage <= 80 && percentage >= 70{
            cell.percentBarWidthConstraint.constant = 274.4
        } else if percentage <= 90 && percentage >= 80{
            cell.percentBarWidthConstraint.constant = 308.7
        } else if percentage <= 100 && percentage >= 90{
            print("Width of Bar :\(cell.percentBackBar.width)")
            cell.percentBarWidthConstraint.constant = self.view.width - 32
            
            //cell.percentBarWidthConstraint.constant = 343
        } else {
            cell.percentBarWidthConstraint.constant = 0
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    static func storyBoardInstance() -> VotingResultVC? {
        let st = UIStoryboard.Vote
        return st.instantiateViewController(withIdentifier: VotingResultVC.id) as? VotingResultVC
    }
    
    func showingPollClosePopup() {
        let popOverVC = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "PollClosePopupVC") as! PollClosePopupVC
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
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
extension VotingResultVC : VotingServiceDelegate {
    func didReceiveError(error: String) {
        
        print("Error occured while fetching results")
        DispatchQueue.main.async {
            if self.spinner.isAnimating {
                self.spinner.stopAnimating()
            }
            self.spinnerView.isHidden = false
            if network.reachability.isReachable == true {
                if error == "Invalid voterid" {
                    print("Voter id wrong")
                } else if error == "Invalid userid" {
                    print("User id is wrong")
                } else {
                    let alert = UIAlertController(title: "Oops!", message: "\(error)", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Oops!", message: "Seems no Internet Connection, please try again.", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func didReceiveBio(name: String, designation: String, company: String, profile_img: String, office: String, phone: String, email: String, country: String, bioDescription: String, awardDescription: String, pictureUrl: [String],userId: String) {
        print("View Bio will not triggered in Result page")
    }
    
    func didReceiveVoters(lists: [VotingItems], isVoteDone : Bool, isPollClosed: Bool) {
        print("Voters list will be empty")
    }
    
    func didVoteStatus(message: String) {
        print("Voting status will not triggered in Result page")
    }
    func didReceiveVotingResult(lists: [VotingItems], isPollClosed: Bool) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinnerView.isHidden = true
            self.datasource = lists
            self.tableView.reloadData()
            self.pollingClosed = isPollClosed
            if self.pollingClosed {
                //self.showMessage(with: "Poll has been Closed")
                let alert = UIAlertController(title: "Oops!", message: "Poll has been Closed", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                //self.showingPollClosePopup()
            }
            
            //self.tableView.layoutIfNeeded()
            /*if self.datasource.count == 4 {
             self.tableView.heightAnchor.constraint(equalToConstant: self.tableView.contentSize.height + 20).isActive = true
             } else if self.datasource.count == 5 {
             self.tableView.heightAnchor.constraint(equalToConstant: self.tableView.contentSize.height + 80).isActive = true
             }*/
            
        }
    }
    
}
