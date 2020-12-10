//
//  Height_helper.swift
//  myscrap
//
//  Created by MS1 on 10/12/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit
extension FavouritePostsVC{
    internal func heightforNewsTextCell(indexPath: IndexPath) -> CGFloat{
        let obj = dataSource[indexPath.item]
        var staticHeight:CGFloat = 150
        // heading label height
        if obj.heading != "" {
            staticHeight += messageHeight(forText: obj.heading, forWidth: self.view.frame.width - 16, forFont: Fonts.newsHeadingFont!) + 5
        }
        // subheading label height
        if obj.subHeading != "" {
            staticHeight += messageHeight(forText: obj.subHeading, forWidth: self.view.frame.width - 16, forFont: Fonts.newsSubHeadingFont) + 5
        }
        // time label height
        staticHeight += 25
        
        staticHeight += heightForAttributed(for: obj.newsDescription, for: self.view.frame.width - 16)
        
        // like stack height
        if obj.likeCount != 0 || obj.commentCount != 0 {
            staticHeight += 35
        }
        // like btn height
        staticHeight += 46
        
        return staticHeight
    }
    
    
    
    internal func heightforNewsImageCell(indexPath: IndexPath) -> CGFloat{
        let obj = dataSource[indexPath.item]
        
        var staticHeight:CGFloat = 150
        // heading label height
        if obj.heading != "" {
            staticHeight += messageHeight(forText: obj.heading, forWidth: self.view.frame.width - 16, forFont: Fonts.newsHeadingFont!) + 5
        }
        // subheading label height
        if obj.subHeading != "" {
            staticHeight += messageHeight(forText: obj.subHeading, forWidth: self.view.frame.width - 16, forFont: Fonts.newsSubHeadingFont) + 5
        }
        // image height
        staticHeight += self.view.frame.width - 16 + 5
        
        // time label height
        staticHeight += 25
        
        // like stack height
        if obj.likeCount != 0 || obj.commentCount != 0 {
            staticHeight += 35
        }
        // like btn height
        staticHeight += 46
        
        staticHeight += heightForAttributed(for: obj.newsDescription, for: self.view.frame.width - 16) + 5
        return staticHeight
    }
    
    internal func heightforFeedTextCell(indexPath: IndexPath) -> CGFloat{
        let obj = dataSource[indexPath.item]
        var staticHeight:CGFloat = 155
        staticHeight += heightForAttributed(for: obj.description, for: self.view.frame.width - 32)
        // like stack height
        if obj.likeCount != 0 || obj.commentCount != 0 {
            staticHeight += 35
        }
        return staticHeight
    }
    internal func heightforFeedImageCell(indexPath: IndexPath) -> CGFloat{
        let obj = dataSource[indexPath.item]
        var staticHeight: CGFloat = 155 + self.view.frame.width
        if (obj.commentCount != 0) || (obj.likeCount != 0) {
            staticHeight += 35
        }
        return staticHeight
    }
    internal func heightForFeedImageTextcell(indexPath:IndexPath) -> CGFloat{
        let obj = dataSource[indexPath.item]
        var staticHeight: CGFloat = 162 + self.view.frame.width
        staticHeight += heightForAttributed(for: obj.description, for: self.view.frame.width - 32)
        if (obj.commentCount != 0) || (obj.likeCount != 0) {
            staticHeight += 35
        }
        return staticHeight
    }
    fileprivate func messageHeight(forText text: String , forWidth width: CGFloat, forFont font: UIFont) -> CGFloat{
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = font
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth:CGFloat = width
        let maxsize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxsize)
        return neededSize.height
    }
    
    private func heightForAttributed(for text: NSAttributedString, for width : CGFloat) -> CGFloat{
        let label = UILabel()
        label.attributedText = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth: CGFloat = width
        let maxSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxSize)
        return neededSize.height
    }
    /*private func heightForText(for text: String, for width : CGFloat) -> CGFloat{
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth: CGFloat = width
        let maxSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxSize)
        return neededSize.height
    }*/
}


