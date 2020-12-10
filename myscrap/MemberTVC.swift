//
//  File.swift
//  myscrap
//
//  Created by MS1 on 12/9/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class MemberTVC: UITableViewCell{
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let initials : UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.INIITIAL_FONT
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    let circleView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.black
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLbl, designationLbl, countryLbl])
        sv.spacing = 5
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    let nameLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.font = Fonts.NAME_FONT
        lbl.text = "Name"
        return lbl
    }()
    
    let designationLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.font = Fonts.DESIG_FONT
        lbl.text = "Designation"
        return lbl
    }()
    
    let countryLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.text = "Country"
        lbl.font = Fonts.DESIG_FONT
        return lbl
    }()
    
    
    
    var member : Mention? {
        didSet {
            guard let item = member else { return }
            if item.profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                circleView.isHidden = false
                initials.isHidden = false
                circleView.backgroundColor = UIColor(hexString: item.colorCode)
                initials.text = item.mentionName.initials()
            } else {
                circleView.isHidden = true
                initials.isHidden = true
                profileImageView.setImageWithIndicator(imageURL: item.profilePic)
            }
            
            nameLbl.text = item.mentionName
            designationLbl.text = item.designation
            countryLbl.text = item.country
        }
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews(){
        selectionStyle = .none
        
        addSubview(profileImageView)
        addSubview(circleView)
        addSubview(initials)
        addSubview(stackView)
        
        addConstraintWithFormat(format: "H:|-30-[v0(60)]-35-[v1]-8-|", options: .alignAllCenterY, views: profileImageView, stackView)
        addConstraintWithFormat(format: "V:|-8-[v0(60)]", views: profileImageView)          //top spacing
        addConstraintWithFormat(format: "V:|-8-[v0(60)]", views: circleView)
        
        
        
        circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        circleView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        initials.translatesAutoresizingMaskIntoConstraints = false
        initials.centerXAnchor.constraint(equalTo: circleView.centerXAnchor, constant: 0).isActive = true
        initials.centerYAnchor.constraint(equalTo: circleView.centerYAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIView{
    func addConstraintWithFormat(format: String  , views: UIView...){
        var dictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            dictionary["v\(index)"] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: dictionary))
    }
    
    func addConstraintWithFormat(format: String, options:NSLayoutConstraint.FormatOptions, views: UIView...){
        var dictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            dictionary["v\(index)"] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: nil, views: dictionary))
    }
}






