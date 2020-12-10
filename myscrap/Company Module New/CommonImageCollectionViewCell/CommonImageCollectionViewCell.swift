//
//  CommonImageCollectionViewCell.swift
//  myscrap
//
//  Created by Apple on 20/11/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class CommonImageCollectionViewCell: UICollectionViewCell {
    
    var contentBGView : UIView!
    
    var profileContentView : CommonUserProfileContentView!
    
    var imagesCollectionView : UICollectionView!
    
    var bottomDownloadView : CommonUserBottomDownloadView!
    
    var newItem : FeedV2Item? {
        didSet{
            guard let item = newItem else { return }
            configCell(withItem: item)
        }
    }
    
    weak var updatedDelegate : UpdatedFeedsDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(withItem item: FeedV2Item) {
                
//        profileContentView.profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: false, isNew:true, rank:nil, isLevel: false, level: nil)
        
        // MARK:- PROFILE VIEW CONFIGURATION
//        profileContentView.profileTypeView.updateViews(name: item.postedUserName, url: item.profilePic, colorCode: item.colorCode)
        
        if item.profilePic != "" {
            if let url = URL(string: item.profilePic) {
                profileContentView.profileImageView.sd_setImage(with: url, completed: nil)
            }
        }
        else {
            profileContentView.profileImageView.image = nil
        }
    
        if item.colorCode != "" {
            self.profileContentView.profileImageView.backgroundColor = UIColor.init(hexString: item.colorCode)
        }
                
        //MARK:- NAME LABEL
        let attributedString = NSMutableAttributedString(string: item.postedUserName, attributes: [.font: Fonts.NAME_FONT, .foregroundColor: UIColor.black])
        profileContentView.userNameLabel.attributedText = attributedString

        //MARK:- Designation Label
        if item.userCompany != "" {
            profileContentView.designationLabel.text = "\(item.postedUserDesignation) • \(item.userCompany)"
        } else {
            profileContentView.designationLabel.text = item.postedUserDesignation
        }

        if item.timeStamp != "" {
            self.profileContentView.postedDateLabel.text = item.timeStamp
        }
        
        if bottomDownloadView != nil {
            self.bottomDownloadView.feedsNewItem = item
            self.bottomDownloadView.feedsDelegate = updatedDelegate
        }
    }
    func setUpViews() {
        
        //contentBGView
        self.contentBGView = UIView()
        self.contentBGView.translatesAutoresizingMaskIntoConstraints = false
        self.contentBGView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.contentBGView)

        //profileContentView
        self.profileContentView = CommonUserProfileContentView()
        self.profileContentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentBGView.addSubview(self.profileContentView)
        
        
        //imagesCollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.imagesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.register(CompanyImageslCell.Nib, forCellWithReuseIdentifier: CompanyImageslCell.identifier)
        self.imagesCollectionView.backgroundColor = UIColor.white
        self.contentBGView.addSubview(self.imagesCollectionView)
        
        //bottomDownloadView
        self.bottomDownloadView = CommonUserBottomDownloadView()
        self.bottomDownloadView.translatesAutoresizingMaskIntoConstraints = false
        self.contentBGView.addSubview(self.bottomDownloadView)
        
        self.setUpConstraints()
    }
    
    //MARK:- setUpConstraints
    func setUpConstraints() {
        //contentBGView
        self.contentBGView.leadingAnchor.constraint(equalTo: self.contentBGView.superview!.leadingAnchor, constant: 0).isActive = true
        self.contentBGView.trailingAnchor.constraint(equalTo: self.contentBGView.superview!.trailingAnchor, constant: 0).isActive = true
        self.contentBGView.topAnchor.constraint(equalTo: self.contentBGView.superview!.topAnchor, constant: 0).isActive = true
        self.contentBGView.bottomAnchor.constraint(equalTo: self.contentBGView.superview!.bottomAnchor, constant: 0).isActive = true

        //profileContentView
        self.profileContentView.leadingAnchor.constraint(equalTo: self.profileContentView.superview!.leadingAnchor, constant: 0).isActive = true
        self.profileContentView.trailingAnchor.constraint(equalTo: self.profileContentView.superview!.trailingAnchor, constant: 0).isActive = true
        self.profileContentView.topAnchor.constraint(equalTo: self.profileContentView.superview!.topAnchor, constant: 0).isActive = true
        self.profileContentView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        //imagesCollectionView
        self.imagesCollectionView.leadingAnchor.constraint(equalTo: self.imagesCollectionView.superview!.leadingAnchor, constant: 0).isActive = true
        self.imagesCollectionView.trailingAnchor.constraint(equalTo: self.imagesCollectionView.superview!.trailingAnchor, constant: 0).isActive = true
        self.imagesCollectionView.topAnchor.constraint(equalTo: self.profileContentView.bottomAnchor, constant: 0).isActive = true
        self.imagesCollectionView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        //profileContentView
        self.bottomDownloadView.leadingAnchor.constraint(equalTo: self.bottomDownloadView.superview!.leadingAnchor, constant: 0).isActive = true
        self.bottomDownloadView.trailingAnchor.constraint(equalTo: self.bottomDownloadView.superview!.trailingAnchor, constant: 0).isActive = true
        self.bottomDownloadView.topAnchor.constraint(equalTo: self.imagesCollectionView.bottomAnchor, constant: 0).isActive = true
        self.bottomDownloadView.bottomAnchor.constraint(equalTo: self.bottomDownloadView.superview!.bottomAnchor, constant: 0).isActive = true

//        self.bottomDownloadView.heightAnchor.constraint(equalToConstant: 100).isActive = true

    }
}

extension CommonImageCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newItem!.pictureURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyImageslCell.identifier, for: indexPath) as? CompanyImageslCell else { return UICollectionViewCell()}
        
        cell.tag = indexPath.row
           let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
       tap.numberOfTapsRequired = 1
        cell.addGestureRecognizer(tap)

//        cell.companyImageView.contentMode = .scaleAspectFit
        
        if self.newItem != nil {
            let data = self.newItem!.pictureURL[indexPath.row]
            
            if let urlString = data.images as? String {
                cell.companyImageView.setImageWithIndicator(imageURL: urlString)
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth = UIScreen.main.bounds.width
//        let cellHeight = UIScreen.main.bounds.height
        
        return CGSize(width:cellWidth, height: 400)
    }

    
    @objc private func handleTap(_ sender: UITapGestureRecognizer){

    }
}
