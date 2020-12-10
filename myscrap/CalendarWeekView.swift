//
//  CalendarWeekView.swift
//  myscrap
//
//  Created by MS1 on 12/16/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
final class CalendarWeekView: UIView {
    
    var insets: CGFloat = 0
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [createWeekLbl(text: "Sun"),
                                                createWeekLbl(text: "Mon"),
                                                createWeekLbl(text: "Tue"),
                                                createWeekLbl(text: "Wed"),
                                                createWeekLbl(text: "Thu"),
                                                createWeekLbl(text: "Fri"),
                                                createWeekLbl(text: "Sat")])
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 0.5
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(stackView)
        backgroundColor = UIColor.gray
        addConstraintWithFormat(format: "H:|[v0]|", views: stackView)
        addConstraintWithFormat(format: "V:|[v0]|", views: stackView)
    }
   
    private func createWeekLbl(text: String) -> UILabel{
        let lbl = UILabel()
        lbl.text = text
        lbl.textColor = UIColor.rgbColor(red: 193, green: 201, blue: 208)
        lbl.backgroundColor = UIColor.rgbColor(red: 73, green: 90, blue: 98)
        lbl.font = Fonts.NAME_FONT
        lbl.textAlignment = .center
        return lbl
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}







