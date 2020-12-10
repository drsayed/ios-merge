//
//  VoterResultVC.swift
//  myscrap
//
//  Created by MyScrap on 10/12/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class VoterResultVC: UIViewController {

    let service = VotingService()
    var datasource = [VotingItems?]()
    
    @IBOutlet weak var firstVoterName: UILabel!
    @IBOutlet weak var secVoterName: UILabel!
    @IBOutlet weak var thirdVoterName: UILabel!
    @IBOutlet weak var fourthVoterName: UILabel!
    @IBOutlet weak var fifthVoterName: UILabel!
    @IBOutlet weak var sixthVoterName: UILabel!
    @IBOutlet weak var seventhVoterName: UILabel!
    @IBOutlet weak var eightVoterName: UILabel!
    @IBOutlet weak var ninthVoterName: UILabel!
    @IBOutlet weak var tenthVoterName: UILabel!
    
    @IBOutlet weak var firstWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var secViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var fifthViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sixthViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var seventhViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var eightViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ninthViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tenthViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstVote: UILabel!
    @IBOutlet weak var secVote: UILabel!
    @IBOutlet weak var thirdVote: UILabel!
    @IBOutlet weak var fourthVote: UILabel!
    @IBOutlet weak var fifthVote: UILabel!
    @IBOutlet weak var sixthVote: UILabel!
    @IBOutlet weak var seventhVote: UILabel!
    @IBOutlet weak var eigthVote: UILabel!
    @IBOutlet weak var ninthVote: UILabel!
    @IBOutlet weak var tenthVote: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerView: UIView!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Poll Detail"
        navigationItem.hidesBackButton = true
    }
    
    func getVotersResultAPI() {
        service.getVoteResults()
        service.delegate = self
    }
    
    @IBAction func returnBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    static func storyBoardInstance() -> VoterResultVC? {
        let st = UIStoryboard.Vote
        return st.instantiateViewController(withIdentifier: VoterResultVC.id) as? VoterResultVC
    }

}
extension VoterResultVC : VotingServiceDelegate {
    func didReceiveError(error: String) {
        print("Error occured while fetching results")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ERROR!", message: "There are some technical issue found while fetching voters list. Please try again later..", preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didReceiveVotingResult(lists: [VotingItems], isPollClosed: Bool) {
        print("This will not triggered")
    }
    
    func didReceiveBio(name: String, designation: String, company: String, profile_img: String, office: String, phone: String, email: String, country: String, bioDescription: String, awardDescription: String, pictureUrl: [String],userId: String) {
        print("View Bio will not triggered in Result page")
    }
    
    func didReceiveVoters(lists: [VotingItems], isVoteDone : Bool, isPollClosed: Bool) {
        DispatchQueue.main.async {
            //self.spinner.stopAnimating()
            //self.spinnerView.isHidden = true
            //self.datasource = lists
            //self.tableView.reloadData()
            //self.tableView.layoutIfNeeded()
            //if self.datasource.count == 4 {
                //self.tableView.heightAnchor.constraint(equalToConstant: self.tableView.contentSize.height + 20).isActive = true
            //} else if self.datasource.count == 5 {
                //self.tableView.heightAnchor.constraint(equalToConstant: self.tableView.contentSize.height + 80).isActive = true
            //}
            
            self.firstVoterName.text = lists[0].name
            self.secVoterName.text = lists[1].name
            self.thirdVoterName.text = lists[2].name
            self.fourthVoterName.text = lists[3].name
            self.fifthVoterName.text = lists[4].name
            self.sixthVoterName.text = lists[5].name
            self.seventhVoterName.text = lists[6].name
            self.eightVoterName.text = lists[7].name
            self.ninthVoterName.text = lists[8].name
            self.tenthVoterName.text = lists[9].name
            
            let percentage1 = lists[0].percentage
            if percentage1 <= 10 && percentage1 > 0{
                self.firstWidthConstraint.constant = 34.3
            } else if percentage1 <= 20 && percentage1 >= 10{
                self.firstWidthConstraint.constant = 68.6
            } else if percentage1 <= 30 && percentage1 >= 20{
                self.firstWidthConstraint.constant = 102.9
            } else if percentage1 <= 40 && percentage1 >= 30{
                self.firstWidthConstraint.constant = 137.2
            } else if percentage1 <= 50 && percentage1 >= 40{
                self.firstWidthConstraint.constant = 171.5
            } else if percentage1 <= 60 && percentage1 >= 50{
                self.firstWidthConstraint.constant = 205.8
            } else if percentage1 <= 70 && percentage1 >= 60{
                self.firstWidthConstraint.constant = 240.1
            } else if percentage1 <= 80 && percentage1 >= 70{
                self.firstWidthConstraint.constant = 274.4
            } else if percentage1 <= 90 && percentage1 >= 80{
                self.firstWidthConstraint.constant = 308.7
            } else if percentage1 <= 100 && percentage1 >= 90{
                self.firstWidthConstraint.constant = 343
            } else {
                self.firstWidthConstraint.constant = 0
            }
            
            let percentage2 = lists[1].percentage
            if percentage2 <= 10 && percentage2 > 0{
                self.secViewWidthConstraint.constant = 34.3
            } else if percentage2 <= 20 && percentage2 >= 10{
                self.secViewWidthConstraint.constant = 68.6
            } else if percentage2 <= 30 && percentage2 >= 20{
                self.secViewWidthConstraint.constant = 102.9
            } else if percentage2 <= 40 && percentage2 >= 30{
                self.secViewWidthConstraint.constant = 137.2
            } else if percentage2 <= 50 && percentage2 >= 40{
                self.secViewWidthConstraint.constant = 171.5
            } else if percentage2 <= 60 && percentage2 >= 50{
                self.secViewWidthConstraint.constant = 205.8
            } else if percentage2 <= 70 && percentage2 >= 60{
                self.secViewWidthConstraint.constant = 240.1
            } else if percentage2 <= 80 && percentage2 >= 70{
                self.secViewWidthConstraint.constant = 274.4
            } else if percentage2 <= 90 && percentage2 >= 80{
                self.secViewWidthConstraint.constant = 308.7
            } else if percentage2 <= 100 && percentage2 >= 90 {
                self.secViewWidthConstraint.constant = 343
            } else {
                self.secViewWidthConstraint.constant = 0
            }
            
            let percentage3 = lists[2].percentage
            if percentage3 <= 10 && percentage3 > 0{
                self.thirdViewWidthConstraint.constant = 34.3
            } else if percentage3 <= 20 && percentage3 >= 10{
                self.thirdViewWidthConstraint.constant = 68.6
            } else if percentage3 <= 30 && percentage3 >= 20{
                self.thirdViewWidthConstraint.constant = 102.9
            } else if percentage3 <= 40 && percentage3 >= 30{
                self.thirdViewWidthConstraint.constant = 137.2
            } else if percentage3 <= 50 && percentage3 >= 40{
                self.thirdViewWidthConstraint.constant = 171.5
            } else if percentage3 <= 60 && percentage3 >= 50{
                self.thirdViewWidthConstraint.constant = 205.8
            } else if percentage3 <= 70 && percentage3 >= 60{
                self.thirdViewWidthConstraint.constant = 240.1
            } else if percentage3 <= 80 && percentage3 >= 70{
                self.thirdViewWidthConstraint.constant = 274.4
            } else if percentage3 <= 90 && percentage3 >= 80{
                self.thirdViewWidthConstraint.constant = 308.7
            } else if percentage3 <= 100 && percentage3 >= 90{
                self.thirdViewWidthConstraint.constant = 343
            }
            else {
                self.thirdViewWidthConstraint.constant = 0
            }
            
            let percentage4 = lists[3].percentage
            if percentage4 <= 10 && percentage4 > 0{
                self.fourthViewWidthConstraint.constant = 34.3
            } else if percentage4 <= 20 && percentage4 >= 10{
                self.fourthViewWidthConstraint.constant = 68.6
            } else if percentage4 <= 30 && percentage4 >= 20{
                self.fourthViewWidthConstraint.constant = 102.9
            } else if percentage4 <= 40 && percentage4 >= 30{
                self.fourthViewWidthConstraint.constant = 137.2
            } else if percentage4 <= 50 && percentage4 >= 40{
                self.fourthViewWidthConstraint.constant = 171.5
            } else if percentage4 <= 60 && percentage4 >= 50{
                self.fourthViewWidthConstraint.constant = 205.8
            } else if percentage4 <= 70 && percentage4 >= 60{
                self.fourthViewWidthConstraint.constant = 240.1
            } else if percentage4 <= 80 && percentage4 >= 70{
                self.fourthViewWidthConstraint.constant = 274.4
            } else if percentage4 <= 90 && percentage4 >= 80{
                self.fourthViewWidthConstraint.constant = 308.7
            } else if percentage4 <= 100 && percentage4 >= 90{
                self.fourthViewWidthConstraint.constant = 343
            }
            else {
                self.fourthViewWidthConstraint.constant = 0
            }
            
            let percentage5 = lists[4].percentage
            if percentage5 <= 10 && percentage5 > 0{
                self.fifthViewWidthConstraint.constant = 34.3
            } else if percentage5 <= 20 && percentage5 >= 10{
                self.fifthViewWidthConstraint.constant = 68.6
            } else if percentage5 <= 30 && percentage5 >= 20{
                self.fifthViewWidthConstraint.constant = 102.9
            } else if percentage5 <= 40 && percentage5 >= 30{
                self.fifthViewWidthConstraint.constant = 137.2
            } else if percentage5 <= 50 && percentage5 >= 40{
                self.fifthViewWidthConstraint.constant = 171.5
            } else if percentage5 <= 60 && percentage5 >= 50{
                self.fifthViewWidthConstraint.constant = 205.8
            } else if percentage5 <= 70 && percentage5 >= 60{
                self.fifthViewWidthConstraint.constant = 240.1
            } else if percentage5 <= 80 && percentage5 >= 70{
                self.fifthViewWidthConstraint.constant = 274.4
            } else if percentage5 <= 90 && percentage5 >= 80{
                self.fifthViewWidthConstraint.constant = 308.7
            } else if percentage4 <= 100 && percentage4 >= 90{
                self.fifthViewWidthConstraint.constant = 343
            }
            else {
                self.fifthViewWidthConstraint.constant = 0
            }
            
            let percentage6 = lists[5].percentage
            if percentage6 <= 10 && percentage6 > 0{
                self.sixthViewWidthConstraint.constant = 34.3
            } else if percentage6 <= 20 && percentage6 >= 10{
                self.sixthViewWidthConstraint.constant = 68.6
            } else if percentage6 <= 30 && percentage6 >= 20{
                self.sixthViewWidthConstraint.constant = 102.9
            } else if percentage6 <= 40 && percentage6 >= 30{
                self.sixthViewWidthConstraint.constant = 137.2
            } else if percentage6 <= 50 && percentage6 >= 40{
                self.sixthViewWidthConstraint.constant = 171.5
            } else if percentage6 <= 60 && percentage6 >= 50{
                self.sixthViewWidthConstraint.constant = 205.8
            } else if percentage6 <= 70 && percentage6 >= 60{
                self.sixthViewWidthConstraint.constant = 240.1
            } else if percentage6 <= 80 && percentage6 >= 70{
                self.sixthViewWidthConstraint.constant = 274.4
            } else if percentage6 <= 90 && percentage6 >= 80{
                self.sixthViewWidthConstraint.constant = 308.7
            } else if percentage4 <= 100 && percentage4 >= 90{
                self.sixthViewWidthConstraint.constant = 343
            }
            else {
                self.sixthViewWidthConstraint.constant = 0
            }
            
            let percentage7 = lists[6].percentage
            if percentage7 <= 10 && percentage7 > 0{
                self.seventhViewWidthConstraint.constant = 34.3
            } else if percentage7 <= 20 && percentage7 >= 10{
                self.seventhViewWidthConstraint.constant = 68.6
            } else if percentage7 <= 30 && percentage7 >= 20{
                self.seventhViewWidthConstraint.constant = 102.9
            } else if percentage7 <= 40 && percentage7 >= 30{
                self.seventhViewWidthConstraint.constant = 137.2
            } else if percentage7 <= 50 && percentage7 >= 40{
                self.seventhViewWidthConstraint.constant = 171.5
            } else if percentage7 <= 60 && percentage7 >= 50{
                self.seventhViewWidthConstraint.constant = 205.8
            } else if percentage7 <= 70 && percentage7 >= 60{
                self.seventhViewWidthConstraint.constant = 240.1
            } else if percentage7 <= 80 && percentage7 >= 70{
                self.seventhViewWidthConstraint.constant = 274.4
            } else if percentage7 <= 90 && percentage7 >= 80{
                self.seventhViewWidthConstraint.constant = 308.7
            } else if percentage7 <= 100 && percentage7 >= 90{
                self.seventhViewWidthConstraint.constant = 343
            }
            else {
                self.seventhViewWidthConstraint.constant = 0
            }
            
            let percentage8 = lists[7].percentage
            if percentage8 <= 10 && percentage8 > 0{
                self.eightViewWidthConstraint.constant = 34.3
            } else if percentage8 <= 20 && percentage8 >= 10{
                self.eightViewWidthConstraint.constant = 68.6
            } else if percentage8 <= 30 && percentage8 >= 20{
                self.eightViewWidthConstraint.constant = 102.9
            } else if percentage8 <= 40 && percentage8 >= 30{
                self.eightViewWidthConstraint.constant = 137.2
            } else if percentage8 <= 50 && percentage8 >= 40{
                self.eightViewWidthConstraint.constant = 171.5
            } else if percentage8 <= 60 && percentage8 >= 50{
                self.eightViewWidthConstraint.constant = 205.8
            } else if percentage8 <= 70 && percentage8 >= 60{
                self.eightViewWidthConstraint.constant = 240.1
            } else if percentage8 <= 80 && percentage8 >= 70{
                self.eightViewWidthConstraint.constant = 274.4
            } else if percentage8 <= 90 && percentage8 >= 80{
                self.eightViewWidthConstraint.constant = 308.7
            } else if percentage8 <= 100 && percentage8 >= 90{
                self.eightViewWidthConstraint.constant = 343
            }
            else {
                self.eightViewWidthConstraint.constant = 0
            }
            
            let percentage9 = lists[8].percentage
            if percentage9 <= 10 && percentage9 > 0{
                self.ninthViewWidthConstraint.constant = 34.3
            } else if percentage9 <= 20 && percentage9 >= 10{
                self.ninthViewWidthConstraint.constant = 68.6
            } else if percentage9 <= 30 && percentage9 >= 20{
                self.ninthViewWidthConstraint.constant = 102.9
            } else if percentage9 <= 40 && percentage9 >= 30{
                self.ninthViewWidthConstraint.constant = 137.2
            } else if percentage9 <= 50 && percentage9 >= 40{
                self.ninthViewWidthConstraint.constant = 171.5
            } else if percentage9 <= 60 && percentage9 >= 50{
                self.ninthViewWidthConstraint.constant = 205.8
            } else if percentage9 <= 70 && percentage9 >= 60{
                self.ninthViewWidthConstraint.constant = 240.1
            } else if percentage9 <= 80 && percentage9 >= 70{
                self.ninthViewWidthConstraint.constant = 274.4
            } else if percentage9 <= 90 && percentage9 >= 80{
                self.ninthViewWidthConstraint.constant = 308.7
            } else if percentage9 <= 100 && percentage9 >= 90{
                self.ninthViewWidthConstraint.constant = 343
            }
            else {
                self.ninthViewWidthConstraint.constant = 0
            }
            
            let percentage10 = lists[9].percentage
            if percentage10 <= 10 && percentage10 > 0{
                self.tenthViewWidthConstraint.constant = 34.3
            } else if percentage10 <= 20 && percentage10 >= 10{
                self.tenthViewWidthConstraint.constant = 68.6
            } else if percentage10 <= 30 && percentage10 >= 20{
                self.tenthViewWidthConstraint.constant = 102.9
            } else if percentage10 <= 40 && percentage10 >= 30{
                self.tenthViewWidthConstraint.constant = 137.2
            } else if percentage10 <= 50 && percentage10 >= 40{
                self.tenthViewWidthConstraint.constant = 171.5
            } else if percentage10 <= 60 && percentage10 >= 50{
                self.tenthViewWidthConstraint.constant = 205.8
            } else if percentage10 <= 70 && percentage10 >= 60{
                self.tenthViewWidthConstraint.constant = 240.1
            } else if percentage10 <= 80 && percentage10 >= 70{
                self.tenthViewWidthConstraint.constant = 274.4
            } else if percentage10 <= 90 && percentage10 >= 80{
                self.tenthViewWidthConstraint.constant = 308.7
            } else if percentage10 <= 100 && percentage10 >= 90{
                self.tenthViewWidthConstraint.constant = 343
            }
            else {
                self.tenthViewWidthConstraint.constant = 0
            }
            
            let percentageString1 = String(format: "%d", lists[0].percentage)
            let voteCountString1 = String(format: "%d", lists[0].votingCount)
            let attribPercentString1 = NSMutableAttributedString(string: percentageString1 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString1 == "1" || voteCountString1 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString1 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString1.append(attribVoteCountString)
                self.firstVote.attributedText = attribPercentString1
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString1 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString1.append(attribVoteCountString)
                self.firstVote.attributedText = attribPercentString1
            }
            
            let percentageString2 = String(format: "%d", lists[1].percentage)
            let voteCountString2 = String(format: "%d", lists[1].votingCount)
            let attribPercentString2 = NSMutableAttributedString(string: percentageString2 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString2 == "1" || voteCountString2 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString2 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString2.append(attribVoteCountString)
                self.secVote.attributedText = attribPercentString2
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString2 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString2.append(attribVoteCountString)
                self.secVote.attributedText = attribPercentString2
            }
            
            let percentageString3 = String(format: "%d", lists[2].percentage)
            let voteCountString3 = String(format: "%d", lists[2].votingCount)
            let attribPercentString3 = NSMutableAttributedString(string: percentageString3 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString3 == "1" || voteCountString3 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString3 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString3.append(attribVoteCountString)
                self.thirdVote.attributedText = attribPercentString3
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString3 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString3.append(attribVoteCountString)
                self.thirdVote.attributedText = attribPercentString3
            }
            
            let percentageString4 = String(format: "%d", lists[3].percentage)
            let voteCountString4 = String(format: "%d", lists[3].votingCount)
            let attribPercentString4 = NSMutableAttributedString(string: percentageString4 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString4 == "1" || voteCountString4 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString4 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString4.append(attribVoteCountString)
                self.fourthVote.attributedText = attribPercentString4
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString4 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString4.append(attribVoteCountString)
                self.fourthVote.attributedText = attribPercentString4
            }
            
            let percentageString5 = String(format: "%d", lists[4].percentage)
            let voteCountString5 = String(format: "%d", lists[4].votingCount)
            let attribPercentString5 = NSMutableAttributedString(string: percentageString5 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString5 == "1" || voteCountString5 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString5 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString5.append(attribVoteCountString)
                self.fifthVote.attributedText = attribPercentString5
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString5 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString5.append(attribVoteCountString)
                self.fifthVote.attributedText = attribPercentString5
            }
            
            let percentageString6 = String(format: "%d", lists[5].percentage)
            let voteCountString6 = String(format: "%d", lists[5].votingCount)
            let attribPercentString6 = NSMutableAttributedString(string: percentageString6 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString6 == "1" || voteCountString6 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString6 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString6.append(attribVoteCountString)
                self.sixthVote.attributedText = attribPercentString6
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString6 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString6.append(attribVoteCountString)
                self.sixthVote.attributedText = attribPercentString6
            }
            
            let percentageString7 = String(format: "%d", lists[6].percentage)
            let voteCountString7 = String(format: "%d", lists[6].votingCount)
            let attribPercentString7 = NSMutableAttributedString(string: percentageString7 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString7 == "1" || voteCountString7 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString7 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString7.append(attribVoteCountString)
                self.seventhVote.attributedText = attribPercentString7
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString7 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString7.append(attribVoteCountString)
                self.seventhVote.attributedText = attribPercentString7
            }
            
            let percentageString8 = String(format: "%d", lists[7].percentage)
            let voteCountString8 = String(format: "%d", lists[7].votingCount)
            let attribPercentString8 = NSMutableAttributedString(string: percentageString8 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString8 == "1" || voteCountString8 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString8 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString8.append(attribVoteCountString)
                self.eigthVote.attributedText = attribPercentString8
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString8 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString8.append(attribVoteCountString)
                self.eigthVote.attributedText = attribPercentString8
            }
            
            let percentageString9 = String(format: "%d", lists[8].percentage)
            let voteCountString9 = String(format: "%d", lists[8].votingCount)
            let attribPercentString9 = NSMutableAttributedString(string: percentageString9 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString9 == "1" || voteCountString9 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString9 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString9.append(attribVoteCountString)
                self.ninthVote.attributedText = attribPercentString9
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString9 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString9.append(attribVoteCountString)
                self.ninthVote.attributedText = attribPercentString9
            }
            
            let percentageString10 = String(format: "%d", lists[9].percentage)
            let voteCountString10 = String(format: "%d", lists[9].votingCount)
            let attribPercentString10 = NSMutableAttributedString(string: percentageString10 + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)!])
            if voteCountString10 == "1" || voteCountString10 == "0" {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString10 + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString10.append(attribVoteCountString)
                self.tenthVote.attributedText = attribPercentString10
            } else {
                let attribVoteCountString = NSMutableAttributedString(string: " (" + voteCountString10 + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                attribPercentString10.append(attribVoteCountString)
                self.tenthVote.attributedText = attribPercentString10
            }
            
            
            self.spinner.stopAnimating()
            self.spinnerView.isHidden = true
        }
    }
    
    func didVoteStatus(message: String) {
        print("Voting status will not triggered in Result page")
    }
    
    
}

