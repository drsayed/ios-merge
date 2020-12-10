//
//  HeghtforHeaderCell.swift
//  myscrap
//
//  Created by MS1 on 1/23/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

extension EventDetailVC{
    
    func heightForHeaderCell(item: EventItem) -> CGFloat{
        
        let imageHeight = (collectionView.frame.width / 2) + 5
        let titleLblHeight = heightForLabel(forText: item.eventName, forWidth: collectionView.frame.width - 96, forfont: UIFont(name: "HelveticaNeue-Bold", size: 20)!) + 5
        let detailLblHeight = heightForLabel(forText: item.eventDetail, forWidth: collectionView.frame.width - 96, forfont:  UIFont(name: "HelveticaNeue", size: 14)!) + 5
        let menuHeight: CGFloat = 61 + 8
        let descriptionLblHeight = heightForLabel(forText: item.eventTimeDescription, forWidth: collectionView.frame.width - 49, forfont: UIFont(name: "HelveticaNeue", size: 14)!) + 5 + 16 + 5 + 17 + 5.5
        let fullHeight = imageHeight + titleLblHeight + detailLblHeight + menuHeight + descriptionLblHeight
        
        return fullHeight
    }
    func heightForLabel(forText text: String?, forWidth width: CGFloat , forfont font: UIFont) -> CGFloat{
        let label = UILabel()
        label.font = font
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth: CGFloat = width
        let maxSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxSize)
        return neededSize.height
    }
    
}
