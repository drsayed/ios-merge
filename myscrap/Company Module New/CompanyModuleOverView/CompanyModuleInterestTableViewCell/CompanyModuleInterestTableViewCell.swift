//
//  CompanyModuleInterestTableViewCell.swift
//  myscrap
//
//  Created by Apple on 25/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class CompanyModuleInterestTableViewCell: UITableViewCell {
        
    var collectionView : UICollectionView!
    var collectionViewHeightConstraint : NSLayoutConstraint!
    
    var interestTypeArr = [String]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        //collectionView
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CompanyInterestCollectionViewCell.self, forCellWithReuseIdentifier: "CompanyInterestCollectionViewCell")
        self.collectionView.backgroundColor = .white
        self.collectionView.isScrollEnabled = false
        self.contentView.addSubview(self.collectionView)
        
        
        //collectionView
        self.collectionView.leadingAnchor.constraint(equalTo: self.collectionView.superview!.leadingAnchor, constant: 0).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.collectionView.superview!.trailingAnchor, constant: 0).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.collectionView.superview!.topAnchor, constant: 0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.collectionView.superview!.bottomAnchor, constant: 0).isActive = true
        self.collectionViewHeightConstraint = self.collectionView.heightAnchor.constraint(equalToConstant: 50)
        self.collectionViewHeightConstraint.isActive = true

    }
}


//MARK:- UICollectionViewDelegate , dataSource for Interests
extension CompanyModuleInterestTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 6
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interestTypeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyInterestCollectionViewCell", for: indexPath) as! CompanyInterestCollectionViewCell
        cell.titleLabel.textColor = UIColor.WHITE_ALPHA
        cell.contentBGView.backgroundColor = UIColor.GREEN_PRIMARY
        cell.titleLabel.text = interestTypeArr[indexPath.item]
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = Fonts.DESIG_FONT
        
        label.text = self.interestTypeArr[indexPath.item] ///COMPANY_BUSINESS_TYPE_ARRAY[indexPath.item]
        return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)

        //            return CGSize(width: self.view.frame.width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    
}


class CompanyInterestCollectionViewCell : UICollectionViewCell {
    
    var contentBGView : UIView!
    var titleLabel : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.white
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        self.contentBGView = UIView()
        self.contentBGView.translatesAutoresizingMaskIntoConstraints = false
        self.contentBGView.backgroundColor = UIColor.WHITE_ALPHA
        self.contentBGView.layer.cornerRadius = 5.0
        self.contentBGView.clipsToBounds = true
        self.contentBGView.layer.borderColor = UIColor.MyScrapGreen.cgColor
        self.contentBGView.layer.borderWidth = 1.0
        self.contentView.addSubview(self.contentBGView)
                
        
        //titleLabel
        self.titleLabel = UILabel()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = Fonts.DESIG_FONT
//        self.label.textColor = UIColor.MyScrapGreen
        self.contentBGView.addSubview(self.titleLabel)

        //contentBGView
        self.contentBGView.leadingAnchor.constraint(equalTo: self.contentBGView.superview!.leadingAnchor, constant: 0).isActive = true
        self.contentBGView.trailingAnchor.constraint(equalTo: self.contentBGView.superview!.trailingAnchor, constant: 0).isActive = true
        self.contentBGView.topAnchor.constraint(equalTo: self.contentBGView.superview!.topAnchor, constant: 0).isActive = true
        self.contentBGView.bottomAnchor.constraint(equalTo: self.contentBGView.superview!.bottomAnchor, constant: -5).isActive = true

        //titleLabel
        self.titleLabel.centerXAnchor.constraint(equalTo: self.titleLabel.superview!.centerXAnchor, constant: 0).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.titleLabel.superview!.centerYAnchor, constant: 0).isActive = true
    }
}
