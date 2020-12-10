//
//  EventHeaderCell.swift
//  myscrap
//
//  Created by MS1 on 1/22/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
protocol EventHeaderCellDelegate: class{
    func didTapInterestedBtn(cell: EventHeaderCell)
    func didTapGoingBtn(cell: EventHeaderCell)
    func didTapShareBtn(cell: EventHeaderCell)
    func didTapmoreBtn(cell: EventHeaderCell)
}


class EventHeaderCell: BaseCell {
    
    weak var delegate: EventHeaderCellDelegate?
    
    var event: EventItem?{
        didSet{
            guard let item = event else { return }
            if item.isInterested{
                interestImgBtn.tintColor = UIColor.GREEN_PRIMARY
                interestBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
            } else {
                interestImgBtn.tintColor = UIColor.black
                interestBtn.setTitleColor(UIColor.black, for: .normal)
            }
            
            intrestedStackView.isHidden = item.isGoing
            
            if item.isGoing{
                goingImgBtn.tintColor = UIColor.GREEN_PRIMARY
                goingBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
            } else {
                goingImgBtn.tintColor = UIColor.black
                goingBtn.setTitleColor(UIColor.black, for: .normal)
            }
            
            
            
            titleLabel.text = item.eventName ?? " "
            detailLabel.text = item.eventDetail ?? " "
            
            imageView.sd_setImage(with: URL(string: item.eventPicture ?? " "), placeholderImage: #imageLiteral(resourceName: "no_events_image_pink_blue_wt"), options: .refreshCached, completed: nil)
            timeLbl.text = item.eventTimeDescription
            locationLbl.text = item.eventLocation
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            
            
            let shadow = NSShadow()
            shadow.shadowBlurRadius = 3
            shadow.shadowOffset = CGSize(width: 3, height: 3)
            shadow.shadowColor = UIColor.gray
            
            let attritute = [NSAttributedString.Key.shadow: shadow]
            
            if let startDate = item.startDate,
                let date = dateFormatter.date(from: startDate){
                dateFormatter.dateFormat = "MMM"
                monthLbl.attributedText = NSAttributedString(string: dateFormatter.string(from: date), attributes: attritute)
                dateFormatter.dateFormat = "dd"
                dateLbl.attributedText = NSAttributedString(string: dateFormatter.string(from: date), attributes: attritute)
            } else {
                monthLbl.attributedText = NSAttributedString(string: " ", attributes: attritute)
                dateLbl.attributedText = NSAttributedString(string: " ", attributes: attritute)
            }
            
        }
    }
    
    @IBOutlet weak var interestBtn: UIButton!
    @IBOutlet weak var goingBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var intrestedStackView: UIStackView!
    @IBOutlet weak var interestImgBtn: UIButton!
    @IBOutlet weak var goingImgBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        goingImgBtn.setImage(#imageLiteral(resourceName: "ui_event_going_l").withRenderingMode(.alwaysTemplate), for: .normal)
        goingImgBtn.tintColor = UIColor.black
        interestImgBtn.setImage(#imageLiteral(resourceName: "ui_event_interested").withRenderingMode(.alwaysTemplate), for: .normal)
        interestImgBtn.tintColor = UIColor.black
        
    }

    @IBAction func goingClicked(_ sender: Any) {
        delegate?.didTapGoingBtn(cell: self)
    }
    
    @IBAction func interestClicked(_ sender: Any) {
        delegate?.didTapInterestedBtn(cell: self)
    }
    
    @IBAction func shareBtnClicked(_ sender: Any){
        delegate?.didTapShareBtn(cell: self)
    }
    
    @IBAction func moreBtnClicked(_ sender: Any){
        delegate?.didTapmoreBtn(cell: self)
    }
 
    

    
}
