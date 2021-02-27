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

    @IBOutlet weak var profileTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var nameAndMessahe: UILabel!
    @IBOutlet weak var profileTypeView: OnlineProfileTypeView!
    @IBOutlet weak var nameLableTopConstaints: NSLayoutConstraint!
    
    override func layoutSubviews() {
        if self.frame.size.height > 30  {
            profileTopConstraints.constant = 0
            nameLableTopConstaints.constant = 0
            self.darkBackground.layer.cornerRadius =   10

        }
        else
        {
            profileTopConstraints.constant = 0
            nameLableTopConstaints.constant = 5
            self.darkBackground.layer.cornerRadius =   self.frame.size.height/2

        }
        self.darkBackground.clipsToBounds = true
        self.darkBackground.backgroundColor = UIColor.black.withAlphaComponent(0.65)

    }
    override func awakeFromNib() {
           super.awakeFromNib()
        self.darkBackground.backgroundColor = UIColor.black.withAlphaComponent(0.65)

       }
    func configCell(item: CommentMessage){
        profileView.updateViews(name: item.name, url: item.profilePic, colorCode: item.colorCode)
   
        if item.messageText.contains("Joined!") {
            let quote = "\( item.name) \(item.messageText)"
            let attributedQuote = NSMutableAttributedString(string: quote)

            attributedQuote.addAttribute(.foregroundColor, value: UIColor.yellow, range: NSRange(location: item.name.length+1, length: item.messageText.length))
            self.nameAndMessahe.attributedText = attributedQuote
        }
        else
        {
            let quote = "\( item.name): \(item.messageText)"
            let attributedQuote = NSMutableAttributedString(string: quote)
            self.nameAndMessahe.attributedText = attributedQuote
        }
       
        
         }
  
}

