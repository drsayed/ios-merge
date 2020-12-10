//
//  GuestListCell.swift
//  myscrap
//
//  Created by MS1 on 1/21/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol GuestListDelegate: class {
    func didTapGoing()
    func didTapInterested()
}

class GuestListCell: BaseCell {
    
    weak var delegate: GuestListDelegate?
    
    var event: EventItem?{
        didSet{
            guard let item = event  else  { return }
            if let count = item.goingCount, count > 0 {
                goigBtn.setTitle("\(count)", for: .normal)
            } else {
                goigBtn.setTitle("-", for: .normal)
            }
            
            if let count = item.interestedCount , count > 0 {
                interestBtn.setTitle("\(count)", for: .normal)
            } else {
                interestBtn.setTitle("-", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var goigBtn: UIButton!
    @IBOutlet weak var interestBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction private func goingTapped(){
        delegate?.didTapGoing()
    }
    
    @IBAction private func interestTapped(){
        delegate?.didTapInterested()
    }

}
