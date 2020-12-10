//
//  ViewersCell.swift
//  myscrap
//
//  Created by MS1 on 7/20/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ViewersCell: UITableViewCell {

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLbl: NameLabel!
    @IBOutlet weak var desigLbl: DesignationLabel!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var timeLabel: TimeLable!
    @IBOutlet weak var newViewerView: newView!
    @IBOutlet weak var profiltTypeView: ProfileTypeView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.newViewerView.backgroundColor = UIColor.ONLINE_COLOR
        
    }

    
    func configCell(visit: VisitorItem){
        profileView.updateViews(name: visit.name, url: visit.profilePic, colorCode: visit.colorCode)
        nameLbl.text = visit.name
        desigLbl.text = visit.country != "" ? "\(visit.designation) • \(visit.country)" : visit.country
        timeLabel.text = visit.viewerDate
        profiltTypeView.checkType = ProfileTypeScore(isAdmin:false,isMod: visit.isMod, isNew:visit.isNew, rank:visit.rank, isLevel: visit.isLevel, level: visit.level)
        newViewerView.isHidden = !visit.isNewViewer
        
    }
    
    

}

