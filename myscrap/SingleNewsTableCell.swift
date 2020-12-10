//
//  SingleNewsTableCell.swift
//  myscrap
//
//  Created by MS1 on 9/5/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit
/*
class SingleNewsTableCell: UITableViewCell{
    
    weak var delegate: SingleTableViewCellDelegate?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let headingLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.descriptionFont
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.numberOfLines = 2
        return lbl
    }()
    let timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = UIFont(name: "HelveticaNeue", size: 11)
        lbl.textColor = UIColor.gray
        lbl.text = "hello 2"
        return lbl
    }()
    let editView: UIView = {
        let v1 = UIView()
        v1.translatesAutoresizingMaskIntoConstraints = false
        v1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        v1.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return v1
    }()
    let editBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let img = #imageLiteral(resourceName: "ellipsis2").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = UIColor.gray
        return btn
    }()
    lazy var lblStackView : UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 5
        sv.addArrangedSubview(self.headingLbl)
        sv.addArrangedSubview(self.timeLbl)
        sv.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        return sv
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.spacing = 5
        sv.autoresizingMask = [.flexibleHeight]
        sv.addArrangedSubview(self.lblStackView)
        sv.addArrangedSubview(self.editView)
        return sv
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    private func setupViews(){
        
        self.selectionStyle = .none
        
        // MARK:- TABLEVIEW
        self.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // MARK:- EDIT BUTTON
        editView.addSubview(editBtn)
        editBtn.leftAnchor.constraint(equalTo: self.editView.leftAnchor).isActive = true
        editBtn.topAnchor.constraint(equalTo: self.editView.topAnchor).isActive = true
        editBtn.addTarget(self, action: #selector(self.editButtonPressed(_:)), for: .touchUpInside)
        
        // MARK:- STACKVIEW
        self.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
    }
    func configCell(new: News , isEditor: Bool){
        if let url = URL(string: new.newsImage) {
            self.profileImageView.sd_setImage(with: url, completed: nil)
        } else {
            self.profileImageView.image = nil
        }
        headingLbl.text = new.heading
        let timestamp = new.timeStamp
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp!))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a  MMMM dd, yyyy"
        timeLbl.text = dateformatter.string(from: date)
        
        switch isEditor {
        case true:
            self.editView.isHidden = false
        default:
            self.editView.isHidden = true
        }
    }
    // MARK :- EDIT BUTTON PRESSES
    @objc func editButtonPressed(_ sender: UIButton){

        if let delegate = self.delegate{
            delegate.editBtnPRessed(cell: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
