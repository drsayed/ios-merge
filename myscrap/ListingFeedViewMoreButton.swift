//
//  ListingFeedViewMoreButton.swift
//  myscrap
//
//  Created by MyScrap on 8/23/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

@IBDesignable
final class ListingFeedViewMoreButton: UIButton{
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
        
    }
    
    private func setupViews(){
        backgroundColor = UIColor.MyScrapGreen
        titleLabel?.font = Fonts.descriptionFont
        setTitle("View More", for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 2.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        
    }
    
}
