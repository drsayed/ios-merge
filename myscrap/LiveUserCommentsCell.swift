//
//  LiveUserCommentsCell.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit


final class LiveUserCommentsCell: BaseCell{
    
    @IBOutlet weak var darkBackground: UIView!
    @IBOutlet weak var profileView: ProfileView!

    @IBOutlet weak var nameAndMessahe: UILabel!
    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
  
    override func layoutSubviews() {
        self.darkBackground.layer.cornerRadius =   self.frame.size.height/2
        self.darkBackground.clipsToBounds = true
       
    }
    override func awakeFromNib() {
           super.awakeFromNib()

       }
    func configCell(item: CommentMessage){
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
        self.nameAndMessahe.text =  "\( item.name) : \(item.messageText)"
         }
  
}

