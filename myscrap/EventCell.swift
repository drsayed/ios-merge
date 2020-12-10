//
//  EventCell.swift
//  myscrap
//
//  Created by MS1 on 12/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class EventCell: BaseCVCell {
    
    var eventItem: EventItem? {
        didSet{
            guard let item = eventItem, let _ = item.eventId , let _ = item.userId else { return }
            titleLbl.text = item.eventName
            dateLbl.text = item.startDate
            locationLbl.text = item.eventLocation
            if let backgroundImage = item.eventPicture {
                backgroundImageView.sd_setImage(with: URL(string: backgroundImage), placeholderImage: #imageLiteral(resourceName: "no_events_image_pink_blue_wt"), options: .refreshCached, completed: nil)
            } else {
                backgroundImageView.image = nil
            }
        }
    }
    
    
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "1512460093")
        iv.contentMode = .center
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let alphaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        return view
    }()
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        lbl.text = "7th BMR International Conference"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let dateImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        iv.image = #imageLiteral(resourceName: "event_calendar")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let dateLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "10/03/2018 at 9 : 00 AM to 12 : 00 PM"
        lbl.font = Fonts.DESIG_FONT
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let locationImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        iv.image = #imageLiteral(resourceName: "ic_location_on_48pt")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let locationLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Le Meridian, Dubai, U.A.E"
        lbl.font = Fonts.DESIG_FONT
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    
    override func setupViews() {
        super.setupViews()
        
        
        
        
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
        layer.masksToBounds = true

        addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        
        addSubview(alphaView)
        
        
        
        alphaView.addSubview(titleLbl)
        alphaView.addSubview(locationImageView)
        alphaView.addSubview(locationLbl)
        alphaView.addSubview(dateImageView)
        alphaView.addSubview(dateLbl)
        
        alphaView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: nil, bottom: bottomAnchor)
        
        titleLbl.anchor(leading: alphaView.leadingAnchor, trailing: alphaView.trailingAnchor, top: alphaView.topAnchor, bottom: locationImageView.topAnchor, padding: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
        
        locationImageView.anchor(leading: titleLbl.leadingAnchor, trailing: locationLbl.leadingAnchor, top: nil, bottom: dateImageView.topAnchor,padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5))
        locationImageView.setSize(size: CGSize(width: 20, height: 20))
        locationLbl.anchor(leading: nil, trailing: titleLbl.trailingAnchor, top: nil, bottom: nil)
        locationLbl.aligntoVerticalCenter([locationImageView])
        
        dateImageView.anchor(leading: titleLbl.leadingAnchor, trailing: dateLbl.leadingAnchor, top: nil, bottom: alphaView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5))
        dateImageView.setSize(size: CGSize(width: 20, height: 20))
        dateLbl.anchor(leading: nil, trailing: titleLbl.trailingAnchor, top: nil, bottom: nil)
        dateLbl.aligntoVerticalCenter([dateImageView])
        
        
    }
    
    
    private func createStack(_ views: [UIView]) -> UIStackView{
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 8
        return stack
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        /*
        var frame = self.bounds
        frame.size.width = min(frame.width, frame.height)
        frame.size.height = frame.width
        border.bounds = frame
        border.cornerRadius = frame.width*0.5
        border.position = CGPoint(x: frame.midX, y: frame.midY) */
        
    }
    
    
}
