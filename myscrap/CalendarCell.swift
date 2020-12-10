//
//  CalendarCell.swift
//  myscrap
//
//  Created by MS1 on 12/14/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dateLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.NAME_FONT
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    lazy var selectedView : UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(hexString: "#CCCCCC")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var eventView : UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.GREEN_PRIMARY
        return view
    }()
    
    var eventsFromTheServer : [String: String] = [:]
    
    
    private func setupViews() {
        
        backgroundColor = UIColor(hexString: "#DEDEE0")

        addSubview(selectedView)
        addSubview(dateLbl)
        
        NSLayoutConstraint.activate([
            selectedView.widthAnchor.constraint(equalTo: widthAnchor),
            selectedView.heightAnchor.constraint(equalTo: heightAnchor),
            selectedView.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectedView.centerYAnchor.constraint(equalTo: centerYAnchor)            
            ])
        
        NSLayoutConstraint.activate([
            dateLbl.topAnchor.constraint(equalTo: topAnchor),
            dateLbl.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLbl.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLbl.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}


