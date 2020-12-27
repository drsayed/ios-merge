//
//  FeedsHeight.swift
//  myscrap
//
//  Created by MS1 on 10/31/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import Foundation
struct FeedsHeight {
    
    static func heightForNewUserCell(item: FeedItem, viewWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let newJoinedLbl: CGFloat = 15
        let spacing: CGFloat = 8
        let timeLabel: CGFloat = 11
        let timeSpacing: CGFloat = 8
        let backgroundHeight: CGFloat = viewWidth/2
        let likeHeight : CGFloat = 35 + 5
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing   + likeHeight + bottomLikeSpacing + newJoinedLbl + spacing + spacing + timeLabel + timeSpacing + backgroundHeight
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    
    static func heightforFeedTextCell(item: FeedItem , labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 75
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.description, for: labelWidth)
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + labelHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    /* API V2.0*/
    static func heightforFeedTextCellV2(item: FeedV2Item , labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.descriptionStatus, for: labelWidth) 
        let linkPreviewSpacing : CGFloat = 16
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8    //8
        let seperator : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + labelHeight  + likeHeight + bottomLikeSpacing + seperator + linkPreviewSpacing
        if item.status.contains("http") {
            height += 400
        } else {
            height += 0
        }
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    static func heightforDetailFeedTextCellV2(item: FeedV2Item , labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.descriptionStatus, for: labelWidth)
        let linkPreviewSpacing : CGFloat = 16
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8    //8
        let seperator : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + labelHeight  + likeHeight + bottomLikeSpacing + seperator + linkPreviewSpacing
        if item.status.contains("http") {
            height += 360
        } else {
            height -= 16
        }
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    static func heightforUserFeedTextCellV2(item: FeedV2Item , labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //95
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.descriptionStatus, for: labelWidth)  + 10
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8    //8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + labelHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    
    static func heightForImageCell(item: FeedItem , width: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 75
        let bottomSpacing: CGFloat = 8
        let imageHeight: CGFloat = width
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    /* API V2.0*/
    static func heightForImageCellV2(item: FeedV2Item , width: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8 + 5
         var imageHeight: CGFloat = width
         if  item.pictureURL.count as Int == 1 {
              imageHeight  = width
        }
        else
         {
             imageHeight = width
        }
       
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        else
        {
            height += 20
        }
        return height
    }
    static func heightForUserFeedImageCellV2(item: FeedV2Item , width: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //95
        let bottomSpacing: CGFloat = 8 +  5
        var imageHeight: CGFloat = width
        if  item.pictureURL.count as Int == 1 {
                            imageHeight  = width
                      }
                      else
                       {
                           imageHeight = width
                      }
        let likeHeight : CGFloat = 15
        let bottomLikeSpacing : CGFloat = 8
       // let bottomViewheight : CGFloat = 60
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 50
        }
        else
        {
            height += 15
        }
        return height
    }
    
    static func heightForListingFeedCell(width: CGFloat, text: NSAttributedString, labelWidth: CGFloat) -> CGFloat{
        let space = 8 + 15 + 8 + 1 + 8 + 60 + 5  + 5 + width * 9 / 16 + 8 + 30 + 9
        let labelheigh = LabelHeight.heightForAttributed(for: text, for: labelWidth)
        return space + labelheigh
    }
    
    static func heightForListingFeedTextCell(width: CGFloat, text: NSAttributedString, labelWidth: CGFloat) -> CGFloat{
        let space = 8 + 15 + 8 + 1 + 8 + 60 + 5  + 5 + width * 9 / 16 + 8 + 30 + 9
        let labelheigh = LabelHeight.heightForAttributed(for: text, for: labelWidth)
        return space + labelheigh
    }
    
    static func heightForImageTextCell(item: FeedItem , width: CGFloat,labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 75
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.description, for: labelWidth)
        let labelSpacing: CGFloat = 5
        let imageHeight: CGFloat = width
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    
    /* API V2.0*/
    static func heightForImageTextCellV2(item: FeedV2Item , width: CGFloat,labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8 
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.descriptionStatus, for: labelWidth) + 15
        let labelSpacing: CGFloat = 5
         var imageHeight: CGFloat = width
         if  item.pictureURL.count as Int == 1 {
                     imageHeight  = width
               }
               else
                {
                    imageHeight = width
               }
       let likeHeight : CGFloat = 0
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 50
        }
        else
        {
            height += 20
        }
        return height
    }
    static func heightForVideoCellV2(item: FeedV2Item , width: CGFloat) -> CGFloat{
        /*let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8
        //let imageHeight: CGFloat = width
        let videoHeight: CGFloat = 400
        /*if item.videoType == "landscape" {
            videoHeight -= 100
        }*/
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + videoHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height*/
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8
        let imageHeight: CGFloat = 375
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 35
        }
        return height
    }
    static func heightForDetailVideoCellV2(item: FeedV2Item , width: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8
        let imageHeight: CGFloat = 375
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        let height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing
        /*if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 35
        }*/
        return height
    }
    static func heightForVideoTextCellV2(item: FeedV2Item , width: CGFloat,labelWidth: CGFloat) -> CGFloat{
        /*let videoHeight: CGFloat = 400
        /*if item.videoType == "landscape" {
            videoHeight -= 100
        }*/
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.descriptionStatus, for: labelWidth)
        let labelSpacing: CGFloat = 5
        
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + videoHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height*/
        //Commented again to lanscape and portrait video
        /*let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 60       //95
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.videoHeightForAttributed(for: item.descriptionStatus, for: labelWidth)
        let labelSpacing: CGFloat = 5
        let imageHeight: CGFloat = width
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 35
        }*/
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 60       //95
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.videoHeightForAttributed(for: item.descriptionStatus, for: labelWidth)
        let labelSpacing: CGFloat = 5
        let imageHeight: CGFloat = 375
        /*if item.videoType == "landscape" {
            imageHeight -= 187.5
        }*/
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 35
        }
        return height
    }
    static func heightForDetailVideoTextCellV2(item: FeedV2Item , width: CGFloat,labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 60       //95
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.videoHeightForAttributed(for: item.descriptionStatus, for: labelWidth)
        let labelSpacing: CGFloat = 5
        let imageHeight: CGFloat = 375
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        let height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        /*if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 35
        }*/
        return height
    }
    
    static func heightForPortraitVideoCellV2(item: FeedV2Item , width: CGFloat) -> CGFloat{
        
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8
         var imageHeight: CGFloat = 230
              if item.videoURL.count > 1 {
                           imageHeight = 230
                    }
                    else
                    {
                          imageHeight  = 230
                    }
      
        let likeHeight : CGFloat = 5
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 45
        }
        else
        {
            height += 25
        }
        return height
    }
    
    static func heightForPortraitVideoTextCellV2(item: FeedV2Item , width: CGFloat,labelWidth: CGFloat) -> CGFloat{
        
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 60       //95
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.videoHeightForAttributed(for: item.descriptionStatus, for: labelWidth) + 15
        let labelSpacing: CGFloat = 5
           var imageHeight: CGFloat = 230
        if item.videoURL.count > 1 {
                     imageHeight = 230
              }
              else
              {
                    imageHeight  = 230
              }
        /*if item.videoType == "landscape" {
            imageHeight -= 187.5
        }*/
        let likeHeight : CGFloat = 15
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 65
        }
        else
        {
            height += 0
        }
        return height
    }
    
    static func heightForLandsVideoCellV2(item: FeedV2Item , width: CGFloat) -> CGFloat{
        
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //60
        let bottomSpacing: CGFloat = 8 + 5
         var imageHeight: CGFloat = 420
              if item.videoURL.count > 1 {
                           imageHeight = 420
                    }
                    else
                    {
                          imageHeight  = 420
                    }
      
        let likeHeight : CGFloat = 5
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 40
        }
        else
        {
            height += 15
        }
        return height
    }
    
    static func heightForLandsVideoTextCellV2(item: FeedV2Item , width: CGFloat,labelWidth: CGFloat) -> CGFloat{
        
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 60       //95
        let bottomSpacing: CGFloat = 8
        let labelHeight: CGFloat = LabelHeight.videoHeightForAttributed(for: item.descriptionStatus, for: labelWidth) + 15
        let labelSpacing: CGFloat = 5
           var imageHeight: CGFloat = 420
        if item.videoURL.count > 1 {
                     imageHeight = 420
              }
              else
              {
                    imageHeight  = 420
              }
        /*if item.videoType == "landscape" {
            imageHeight -= 187.5
        }*/
        let likeHeight : CGFloat = 15
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        if !(item.likeCount == 0 && item.commentCount == 0 && item.viewsCount == 0){
            height += 55
        }
        else
        {
            height += 05
        }
        return height
    }
    
    static func heightForCompanyOfMonthCellV2(item: FeedV2Item, labelWidth: CGFloat) -> CGFloat {
        let topSpacing: CGFloat = 8
        let logoImage: CGFloat = 60
        let logoSpacing: CGFloat = 19
        let bannerTitleHeight: CGFloat = 20
        let bannerTitleSpacing: CGFloat = 18
        let imageHeight: CGFloat = 120
        let imageSpacing: CGFloat = 20
        //let attrib = item._cmdescription
        //let convertFromHtml = attrib!.convertHtml()
        //let desc = NSMutableAttributedString(attributedString: convertFromHtml)
        //desc.setBaseFont(baseFont: UIFont(name: "HelveticaNeue", size: 16)!, preserveFontSizes: true)
        let labelHeight = LabelHeight.heightForAttributed(for: item.cmDescriptionStatus, for: labelWidth)
        //let labelHeight : CGFloat = 140
        let labelSpacing: CGFloat = 8   //20
        let readMoreBtn : CGFloat = 32
        let readMoreSpacing : CGFloat = 8
        //let bottomSpacing: CGFloat = 8
        
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + logoImage + logoSpacing + bannerTitleHeight + bannerTitleSpacing + imageHeight + imageSpacing + labelHeight + labelSpacing + readMoreBtn + readMoreSpacing + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        } else if item.likeCount == 0 && item.commentCount == 0 {
            height -= 35
        }
        return height
    }
    static func heightForPersonOfWeekCellV2(item: FeedV2Item, labelWidth: CGFloat) -> CGFloat {
        let topSpacing: CGFloat = 8
        let logoImage: CGFloat = 60
        let logoSpacing: CGFloat = 19
        let bannerTitleHeight: CGFloat = 20
        let bannerTitleSpacing: CGFloat = 18
        let imageHeight: CGFloat = 100  //180
        let imageSpacing: CGFloat = 20
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.pwDescriptionStatus, for: labelWidth)
        //let labelHeight : CGFloat = 140
        //let bottomSpacing: CGFloat = 8
        let labelSpacing: CGFloat = 8       //20
        let readMoreBtn : CGFloat = 32
        //let readMoreSpacing : CGFloat = 8
        let likeHeight : CGFloat = 35
        let bottomLikeSpacing : CGFloat = 8
        //var height = topSpacing + logoImage + logoSpacing + bannerTitleHeight + bannerTitleSpacing + imageHeight + imageSpacing + labelHeight + labelSpacing + readMoreBtn + readMoreSpacing + likeHeight + bottomLikeSpacing
        var height = topSpacing + logoImage + logoSpacing + bannerTitleHeight + bannerTitleSpacing + imageHeight + imageSpacing + labelHeight + labelSpacing + readMoreBtn + likeHeight + bottomLikeSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        } else if item.likeCount == 0 && item.commentCount == 0 {
            height -= 35
        }
        return height
    }
    static func heightForDetailCompanyOfMonthCellV2(item: FeedV2Item, labelWidth: CGFloat) -> CGFloat {
        let topSpacing: CGFloat = 8
        let logoImage: CGFloat = 60
        let logoSpacing: CGFloat = 19
        let bannerTitleHeight: CGFloat = 20
        let bannerTitleSpacing: CGFloat = 18
        let imageHeight: CGFloat = 120
        let imageSpacing: CGFloat = 20
        let labelHeight: CGFloat = LabelHeight.heightForLabel(for: item.cmdescription, for: labelWidth, for: UIFont(name: "HelveticaNeue", size: 16)!)
        //let labelHeight : CGFloat = 140
        let labelSpacing: CGFloat = 8   //20
//        let bottomSpacing: CGFloat = 8
//        let likeHeight : CGFloat = 35
//        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + logoImage + logoSpacing + bannerTitleHeight + bannerTitleSpacing + imageHeight + imageSpacing + labelHeight + labelSpacing
        /*if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }*/
        return height
    }
    static func heightForDetailPersonOfWeekCellV2(item: FeedV2Item, labelWidth: CGFloat) -> CGFloat {
        let topSpacing: CGFloat = 8
        let logoImage: CGFloat = 60
        let logoSpacing: CGFloat = 19
        let bannerTitleHeight: CGFloat = 20
        let bannerTitleSpacing: CGFloat = 18
        let imageHeight: CGFloat = 150
        let imageSpacing: CGFloat = 20
        let labelHeight: CGFloat = LabelHeight.heightForLabel(for: item.pwdescription, for: labelWidth, for: UIFont(name: "HelveticaNeue", size: 16)!)
        //let labelHeight : CGFloat = 140
        let labelSpacing: CGFloat = 8       //20
        //let bottomSpacing: CGFloat = 8
        //let likeHeight : CGFloat = 35
        //let bottomLikeSpacing : CGFloat = 8
        let height = topSpacing + logoImage + logoSpacing + bannerTitleHeight + bannerTitleSpacing + imageHeight + imageSpacing + labelHeight + labelSpacing
        /*if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }*/
        return height
    }
    //Setting Dynamic height for detail feeds comment text
    static func heightForCommentFeedsV2(item: CommentItem, labelWidth: CGFloat) -> CGFloat {
        let topSpacing: CGFloat = 8
        let logoImage: CGFloat = 60
        let logoSpacing: CGFloat = 12
        //let labelHeight: CGFloat = LabelHeight.heightForLabel(for: item.comment, for: labelWidth, for: UIFont(name: "HelveticaNeue", size: 15)!)
        let textViewHeight: CGFloat = LabelHeight.heightForAttributed(for: item.commentTextAttrib, for: labelWidth)
        let labelSpacing: CGFloat = 8
        let height = topSpacing + logoImage + logoSpacing + textViewHeight + labelSpacing
        return height
    }
    //Setting Dynamic height for comment Text in Company of the Month
    static func heightForCommentCompanyOfMonthCellV2(item: CommentCMItem, labelWidth: CGFloat) -> CGFloat {
        let topSpacing: CGFloat = 8
        let logoImage: CGFloat = 60
        let logoSpacing: CGFloat = 12
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.commentTextAttrib, for: labelWidth)
        let labelSpacing: CGFloat = 8
        let height = topSpacing + logoImage + logoSpacing + labelHeight + labelSpacing
        return height
    }
    //Setting Dynamic height for comment Text in Person of Week
    static func heightForCommentPersonOfWeekCellV2(item: CommentPOWItem, labelWidth: CGFloat) -> CGFloat {
        let topSpacing: CGFloat = 8
        let logoImage: CGFloat = 60
        let logoSpacing: CGFloat = 12
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.commentTextAttrib, for: labelWidth)
        let labelSpacing: CGFloat = 8
        let height = topSpacing + logoImage + logoSpacing + labelHeight + labelSpacing
        return height
    }
    static func heightForUserFeedImageTextCellV2(item: FeedV2Item , width: CGFloat,labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let favouriteViewHeight: CGFloat = 95       //95
        let bottomSpacing: CGFloat = 8 + 8
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.descriptionStatus, for: labelWidth)
        let labelSpacing: CGFloat = 5
        var imageHeight: CGFloat = width
        if  item.pictureURL.count as Int == 1 {
                            imageHeight  = width
                      }
                      else
                       {
                           imageHeight = width
                      }
        let likeHeight : CGFloat = 10
        let bottomLikeSpacing : CGFloat = 8
        var height = topSpacing + favouriteViewHeight + bottomSpacing + imageHeight  + likeHeight + bottomLikeSpacing + labelHeight + labelSpacing
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 55
        }
        else
        {
            height += 15
        }
        return height
    }
    
    static func heightForNewsTextCell(item: FeedItem, labelWidth: CGFloat) -> CGFloat{
        let topSpacing: CGFloat = 8
        let newsTitle: CGFloat = 22 + 5
        let profileView: CGFloat = 60 + 5
        let subheading = LabelHeight.heightForLabel(for: item.subHeading, for: labelWidth, for: Fonts.newsSubHeadingFont) + 5
        let dateStack: CGFloat = 25
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.newsDescription, for: labelWidth) + 5
        let bottomSpacing: CGFloat = 8
        let likeHeight : CGFloat = 35
        var height = topSpacing + newsTitle  + profileView + subheading + dateStack + labelHeight + bottomSpacing + likeHeight
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
        return height
    }
    
    static func heightForNewsImageCell(item: FeedItem, labelWidth: CGFloat) -> CGFloat{
        
        let topSpacing: CGFloat = 8
        let newsTitle: CGFloat = 22 + 5
        let profileView: CGFloat = 60 + 5
        let subheading = LabelHeight.heightForLabel(for: item.subHeading, for: labelWidth, for: Fonts.newsSubHeadingFont) + 5
        let labelHeight: CGFloat = LabelHeight.heightForAttributed(for: item.newsDescription, for: labelWidth) + 5
        let dateStack: CGFloat = 25
        let bottomSpacing: CGFloat = 8
        let likeHeight : CGFloat = 35
        var height = topSpacing + newsTitle + profileView + subheading + dateStack + labelHeight + bottomSpacing + likeHeight
        if !(item.likeCount == 0 && item.commentCount == 0){
            height += 35
        }
    
        return height + labelWidth + 5  // collectionview Width
    }
}

struct LabelHeight{
    
    static func heightForAttributed(for text:NSAttributedString, for width: CGFloat) -> CGFloat{
        
        let textView = UserTagTextView()
        textView.isScrollEnabled = false
        textView.attributedText = text
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        let maxLabelWidth: CGFloat = width
        let maxSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = textView.sizeThatFits(maxSize)
        return neededSize.height
    }
    
    static func videoHeightForAttributed(for text:NSAttributedString, for width: CGFloat) -> CGFloat{
        
        
        let textView = UserTagTextView()
        textView.isScrollEnabled = false
        textView.attributedText = text
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        let maxLabelWidth: CGFloat = width
        let maxSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = textView.sizeThatFits(maxSize)
        return neededSize.height
        
//        let textView = UserTagTextView()
//        textView.isScrollEnabled = false
//        textView.attributedText = text
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        // Remove all padding
//        textView.textContainerInset = .zero
//        // This option has a default value of 5.0.
//        // So we set this option to 0.0 instead of
//        // setting the view.contentInset
//        textView.textContainer.lineFragmentPadding = 0.0
//        let maxLabelWidth: CGFloat = width
//        let maxSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
//        let neededSize = textView.sizeThatFits(maxSize)
//        return neededSize.height
    }
    
    static func heightForLabel(for text: String, for Width: CGFloat , for font: UIFont) -> CGFloat{
        let label = UILabel()
        label.font = font
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth: CGFloat = Width
        let maxSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxSize)
        return neededSize.height
    }
    
}
extension String {
    
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
}
