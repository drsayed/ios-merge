//
//  CommentsCell.swift
//  myscrap
//
//  Created by MS1 on 6/21/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit



final class CommentsCell: UITableViewCell {
    @IBOutlet weak var profileView:UIView!
    @IBOutlet weak var InitialLabel:UILabel!
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var commentLabel:UILabel!
    @IBOutlet weak var editBtn:UIButton!
    
    
    weak var delegate:CommentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.alpha = 1.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configCell(comment:Like){
        
        // MARK :- PROFILE VIEW AND IMAGE CONFIGURATION
        
        profileView.backgroundColor = UIColor.init(hexString: comment.colorCode)
        InitialLabel.text = comment.name.initials()
        
        // MARK:- PROFILE IMAGE CONFIGURATION
        
        
        profileImage.setImageWithIndicator(imageURL: comment.likeProfilePic)
        
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        
        //MARK :- NAME LABEL CONFIGURATION
        nameLabel.text = comment.name
        nameLabel.font = Fonts.NAME_FONT
        nameLabel.textColor = UIColor.BLACK_ALPHA
        
        
        // MARK :- TIME LABEL CONFIGURATION
        
        timeLabel.text = comment.likeTimeStamp
        timeLabel.textColor = UIColor.gray
        timeLabel.font = Fonts.DESIG_FONT
        
        // MARK :- COMMENT LABEL CONFIGURATION
        
        commentLabel.text = comment.comment
        commentLabel.textColor = UIColor.BLACK_ALPHA
        commentLabel.font = Fonts.descriptionFont
        
        if comment.userId == UserDefaults.standard.value(forKey: "userid") as! String{
            
            editBtn.isHidden = false
        } else {
            
            editBtn.isHidden = true
        }
       
    }
    @IBAction func editButtonPressed(){
        if let delegate = self.delegate{
            delegate.editCommentPressed(cell: self)
        }
    }

    
    
}


