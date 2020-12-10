//
//  VotingService.swift
//  myscrap
//
//  Created by MyScrap on 8/5/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

protocol VotingServiceDelegate : class {
    func didReceiveError(error: String)
    func didReceiveBio(name: String, designation: String, company: String, profile_img: String, office: String, phone: String, email: String, country: String, bioDescription: String, awardDescription: String, pictureUrl: [String], userId: String)
    func didReceiveVoters(lists : [VotingItems], isVoteDone : Bool, isPollClosed: Bool)
    func didReceiveVotingResult(lists: [VotingItems], isPollClosed: Bool)
    func didVoteStatus(message: String)
}

class VotingService {
    
    weak var delegate : VotingServiceDelegate?
    
    func getVoterBio(voterId: String) {
        
        var name = ""
        var designation = ""
        var company = ""
        var profile_img = ""
        var office = ""
        var phone = ""
        var email = ""
        var country = ""
        var bioDescription = ""
        var awardDescription = ""
        var pictureUrl = [""]
        var userId = ""
        
        let service = APIService()
        service.endPoint = Endpoints.GET_BIO_VOTER
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&voterId=\(voterId)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                if let message = dict["status"] as? String {
                    if message != "success" {
                        self.delegate?.didReceiveError(error: message)
                    }
                }
                if let nameBio = dict["name"] as? String {
                    name = nameBio
                }
                if let designationBio = dict["designation"] as? String {
                    designation = designationBio
                }
                if let companyBio = dict["company"] as? String {
                    company = companyBio
                }
                if let profile_imgBio = dict["profile_img"] as? String {
                    profile_img = profile_imgBio
                }
                if let officeBio = dict["office"] as? String {
                    office = officeBio
                }
                if let phoneBio = dict["phone"] as? String {
                    phone = phoneBio
                }
                if let emailBio = dict["email"] as? String {
                    email = emailBio
                }
                if let countryBio = dict["country"] as? String {
                    country = countryBio
                }
                if let bioDescriptionBio = dict["bioDescription"] as? String {
                    bioDescription = bioDescriptionBio
                }
                if let awardDescriptionBio = dict["awardDescriptionhtml"] as? String {
                    awardDescription = awardDescriptionBio
                    print("award Desc")
                }
                if let pictureUrlBio = dict["pictureUrl"] as? [String] {
                    pictureUrl = pictureUrlBio
                }
                
                if let userid = dict["userid"] as? String {
                    userId = userid
                }
                self.delegate?.didReceiveBio(name: name, designation: designation, company: company, profile_img: profile_img, office: office, phone: phone, email: email, country: country, bioDescription: bioDescription, awardDescription: awardDescription, pictureUrl: pictureUrl, userId : userId)
                
            case .Error(let error):
                
                self.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    func getVotersLists() {
        let service = APIService()
        //service.endPoint = Endpoints.GET_VOTERS_LIST
        service.endPoint = Endpoints.GET_VOTER_LIST_REM_POLL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                self.handleJSONVoterLists(dict: dict)
            case .Error(let error):
                self.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    func handleJSONVoterLists(dict: [String: AnyObject]) {
        
        let error = dict["error"] as! Bool
        if !error {
            let isVoteDone = dict["isVoteDone"] as! Bool
            let isPollClosed = dict["isPollClosed"] as! Bool
            if let voterListArray = dict["voter_list"] as? [[String : AnyObject]] {
                var votersLists = [VotingItems]()
                for list in voterListArray{
                    let putList = VotingItems(dict: list)
                    votersLists.append(putList)
                    print("Handle Json : \(putList)")
                }
                delegate?.didReceiveVoters(lists: votersLists, isVoteDone : isVoteDone, isPollClosed: isPollClosed)
            }
        } else {
            if let message = dict["status"] as? String {
                if message != "success" {
                    self.delegate?.didReceiveError(error: "\(message)")
                }
            }
            //delegate?.didReceiveError(error: "Error fetching voters list")
        }
        
    }
    
    func voteNominee(voterId: String, lat: String, long: String) {
        let service = APIService()
        //service.endPoint = Endpoints.VOTE_NOMINEE
        //updated  api
        service.endPoint = Endpoints.VOTE_NOMINEE_LATLONG
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&voterId=\(voterId)&latitude=\(lat)&longitude=\(long)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                self.handleJSONVoteNominee(dict: dict)
            case .Error(let error):
                self.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    func handleJSONVoteNominee(dict: [String: AnyObject]) {
        let status = dict["status"] as! String
        let error = dict["error"] as! Bool
        if !error {
            if status == "success" {
                delegate?.didVoteStatus(message: status)
            } else {
                delegate?.didReceiveError(error: "Error while voting")
            }
        } else {
            delegate?.didReceiveError(error: "Error fetching voters list")
        }
        
    }
    
    func getVoteResults() {
        let service = APIService()
        //service.endPoint = Endpoints.VIEW_VOTING_RESULT
        service.endPoint = Endpoints.VIEW_VOTING_RESULT_POLL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)"
        service.getDataWith { (result) in
            switch result{
            case .Success(let dict):
                self.handleJSONVoteResult(dict: dict)
            case .Error(let error):
                self.delegate?.didReceiveError(error: error)
            }
        }
    }
    
    func handleJSONVoteResult(dict: [String: AnyObject]) {
        let error = dict["error"] as! Bool
        if !error {
            let isPollClosed = dict["isPollClosed"] as! Bool
            if let voterListArray = dict["votingResult"] as? [[String : AnyObject]] {
                var votersLists = [VotingItems]()
                for list in voterListArray{
                    let putList = VotingItems(dict: list)
                    votersLists.append(putList)
                    print("Handle Json percent: \(putList.percentage)")
                }
                //delegate?.didReceiveVoters(lists: votersLists, isVoteDone: false)
                delegate?.didReceiveVotingResult(lists: votersLists, isPollClosed: isPollClosed)
            }
        } else {
            delegate?.didReceiveError(error: "Error fetching voters list")
        }
        
    }
}
