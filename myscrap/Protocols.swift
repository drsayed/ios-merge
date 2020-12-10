//
//  Protocols.swift
//  myscrap
//
//  Created by MS1 on 10/5/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//


/*
import Foundation
protocol SingleNewsDelegate:NSObjectProtocol {
    func likeButtonPressed(cell: SingleNewsCell)
    func companyPressed(cell: SingleNewsCell)
    func likeCountPressed(cell: SingleNewsCell)
}
protocol SingleTableViewCellDelegate:NSObjectProtocol {
    func editBtnPRessed(cell: SingleNewsTableCell)
}
*/
protocol CommentDelegate:NSObjectProtocol {
    func editCommentPressed(cell:CommentsCell)
}
