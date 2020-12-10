//
//  VotingInsideScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 7/27/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

protocol VoteScrollDelegate : class {
    func didTapVoterBio(index: Int,voterId : String)
    func didTapVoteView(index: Int,voterId : String)
    func didTapUserProfile(userId: String)
    func didShareBtnTapped(sender : Any, voterId: String,voterName: String)
}

class VotingInsideScrollCell: BaseCell {

    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var voterImageView: UIImageView!
    @IBOutlet weak var voterName: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var viewBio: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var voterView: UIView!
    
    var shareBtnAction: ((Any) -> Void)?
    var offlineActionBlock : (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.startAnimating()
        curveView.backgroundColor = UIColor.clear
        //curveView.layer.shadowColor = UIColor.black.cgColor
        //curveView.layer.shadowOpacity = 0.1
        //curveView.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        //curveView.layer.shadowRadius = 2
        //curveView.layer.shadowPath = UIBezierPath(roundedRect: curveView.bounds, cornerRadius: 15).cgPath
        //curveView.layer.shouldRasterize = true
        //curveView.layer.rasterizationScale = UIScreen.main.scale
        
        // add the border to subview
        borderView.frame = curveView.bounds
        borderView.layer.cornerRadius = 15
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 0.1
        borderView.layer.masksToBounds = true
        
        //shareBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        //shareBtn.setTitle(String.fontAwesomeIcon(name: .share), for: .normal)
        //shareBtn.layer.shadowColor = UIColor.black.cgColor
        //shareBtn.layer.shadowRadius = 2
        //shareBtn.layer.shadowPath = UIBezierPath(roundedRect: shareBtn.bounds, cornerRadius: 5).cgPath
        //shareBtn.layer.shouldRasterize = true
        //shareBtn.layer.rasterizationScale = UIScreen.main.scale
    }

    @IBAction func shareBtnTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            shareBtnAction?(sender)
        } else {
            offlineActionBlock?()
        }
    }
}
