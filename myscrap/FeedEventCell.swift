//
//  FeedEventCell.swift
//  myscrap
//
//  Created by MS1 on 1/24/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class FeedEventCell: FeedImageTextCell {
    
    
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventMonthLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var interestImgBtn: UIButton!
    @IBOutlet weak var interestBtn: UIButton!
    @IBOutlet weak var eventView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        interestImgBtn.setImage(#imageLiteral(resourceName: "ui_event_interested").withRenderingMode(.alwaysTemplate), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(FeedEventCell.eventViewtapped))
        tap.numberOfTapsRequired = 1
        eventView.isUserInteractionEnabled = true
        eventView.addGestureRecognizer(tap)
    }
    
    
    @objc func eventViewtapped(){
        guard let item = item else { return }
        delegate?.didTapEvent(item: item)
    }
    
    override func configCell(withItem item: FeedItem) {
        super.configCell(withItem: item)

        if item.isInterested{
            interestImgBtn.tintColor = UIColor.GREEN_PRIMARY
            interestBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        } else {
            interestImgBtn.tintColor = UIColor.black
            interestBtn.setTitleColor(UIColor.black, for: .normal)
        }
        
        
        
        eventNameLbl.text = item.eventName
        
        feedImage.sd_setShowActivityIndicatorView(true)
        feedImage.sd_setImage(with: URL(string: item.eventPicture), completed: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowColor = UIColor.gray
        
        let attritute = [NSAttributedString.Key.shadow: shadow]
        
        if let startDate = item.eventDate,
            let date = dateFormatter.date(from: startDate){
            dateFormatter.dateFormat = "MMM"
            eventMonthLbl.attributedText = NSAttributedString(string: dateFormatter.string(from: date), attributes: attritute)
            dateFormatter.dateFormat = "dd"
            eventDateLbl.attributedText = NSAttributedString(string: dateFormatter.string(from: date), attributes: attritute)
        } else {
            eventMonthLbl.attributedText = NSAttributedString(string: " ", attributes: attritute)
            eventDateLbl.attributedText = NSAttributedString(string: " ", attributes: attritute)
        }
        
    }
    
    
    @IBAction func interesTBtnTapped(_ sender: Any){
        guard let item = item else { return }
        delegate?.didTapEvent(item: item)
    }
}
