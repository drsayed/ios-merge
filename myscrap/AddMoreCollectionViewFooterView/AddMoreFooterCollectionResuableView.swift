//
//  AddMoreFooterCollectionResuableView.swift
//  myscrap
//
//  Created by Apple on 12/11/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

protocol AddMoreButtonDelegate : class {
    
    func didAddMoreButtonTapped(_ view: AddMoreFooterCollectionResuableView)
}

class AddMoreFooterCollectionResuableView: UICollectionReusableView {

    @IBOutlet var contentBackgroundView : UIView!
    @IBOutlet var addMoreButton : UIButton!
    
    weak var viewDelegate : AddMoreButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentBackgroundView.backgroundColor = UIColor.lightGray
        self.contentBackgroundView.layer.cornerRadius = 10
        self.contentBackgroundView.layer.masksToBounds = true
        
        self.addMoreButton.addTarget(self, action: #selector(addMoreButtonAction), for: .touchUpInside)
    }
    
    @objc func addMoreButtonAction() {
        
        self.viewDelegate?.didAddMoreButtonTapped(self)
    }
}
