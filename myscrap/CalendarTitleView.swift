//
//  CalendarTitleView.swift
//  myscrap
//
//  Created by MS1 on 12/14/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CalendarTitleView: UIView{
    

    
    var title: String?{
        didSet{
            titleLbl.text = title
        }
    }
    
    
    weak var calendarVC : CalendarVC?
    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        lbl.textColor = UIColor.white
        lbl.text = "January 2016"
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let leftButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "arrow_left"), for: .normal)
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.rgbColor(red: 222, green: 221, blue: 226)
        btn.addTarget(self, action: #selector(CalendarTitleView.didPressLeftButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private let rightButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "arrow_right"), for: .normal)
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.rgbColor(red: 222, green: 221, blue: 226)
        btn.addTarget(self, action: #selector(CalendarTitleView.didPressRightButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    
    @objc private func didPressLeftButton(_ sender: UIButton){
        calendarVC?.scrollCalendar(segment: .previous)
    }
    
    @objc private func didPressRightButton(_ sender: UIButton){
        calendarVC?.scrollCalendar(segment: .next)
    }
    
    private func setupViews(){
        
        backgroundColor = UIColor.rgbColor(red: 37, green: 54, blue: 64)

        addSubview(titleLbl)
        addSubview(rightButton)
        addSubview(leftButton)
        
        addConstraintWithFormat(format: "H:|-8-[v0(30)]-8-[v1]-8-[v2(30)]-8-|",options: .alignAllCenterY, views: leftButton,titleLbl,rightButton)
        addConstraintWithFormat(format: "V:[v0(30)]", views: leftButton)
        addConstraintWithFormat(format: "V:[v0(30)]", views: rightButton)
        titleLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



