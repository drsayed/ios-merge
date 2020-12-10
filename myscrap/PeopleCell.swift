//
//  PeopleCell.swift
//  myscrap
//
//  Created by MS1 on 2/6/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol PeopleCellDelegate : class {
    func didPressChatButton(friendId: String, profileName: String? , colorCode: String? ,profileImage: String?, jid: String)
}
class PeopleCell: BaseTableCell {
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var distanceLabel:UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    
    var delegate : PeopleCellDelegate?
    //Update all details
    var name = ""
    var friendId = ""
    var colorCode = ""
    var profilePic = ""
    var jid = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
            // Initialization code
    }
    
    
    func congigPeople(people:PeopleNearByItem){
    
        //MARK :- NAME LABEL CONFIGURATION
    
        nameLbl.text = people.username
        nameLbl.font = Fonts.NAME_FONT
        distanceLabel.text = "Within \(people.distance)"
        distanceLabel.font = Fonts.DESIG_FONT
        profileView.updateViews(name: people.username, url: people.userimage, colorCode: people.colorcode)
        profileTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: people.moderator, isNew:people.newJoined, rank:people.rank, isLevel: people.isLevel, level: people.level)
        
        //Assigning all values
        name = people.username
        friendId = people.userId
        colorCode = people.colorcode
        profilePic = people.userimage
        jid = people.jid
        
    }
    @IBAction func chatBnTapped(_ sender: UIButton) {
        delegate?.didPressChatButton(friendId: friendId, profileName: name, colorCode: colorCode, profileImage: profilePic, jid: jid)
    }
    
}

class newView: UIView{
    let topLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    func setupView() {
        self.backgroundColor = UIColor.GREEN_PRIMARY
        self.layer.cornerRadius = self.frame.height / 2
        topLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        topLabel.textAlignment = NSTextAlignment.center
        topLabel.font = Fonts.TOP_FONT
        topLabel.textColor = UIColor.WHITE_ALPHA
        topLabel.text = "NEW"
        self.addSubview(topLabel)
    }
        
}
