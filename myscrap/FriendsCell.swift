//
//  FriendsCell.swift
//  myscrap
//
//  Created by MS1 on 2/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class FriendsCell: BaseTableCell {
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var pointsCount: UILabel!
    
    @IBOutlet weak var countLable: UILabel!
    var viewModel: FriendCellViewViewModel? {
        didSet{
            guard let model = viewModel else { return }
            configCell(with: model)
        }
    }
    
    private func configCell(with viewModel: FriendCellViewViewModel){
        print("cc code... \(viewModel.colorCode)")
        if viewModel.colorCode == "" {
            profileView.updateViews(name: viewModel.name, url: viewModel.profilePic, colorCode: viewModel.cc)
        } else {
            profileView.updateViews(name: viewModel.name, url: viewModel.profilePic, colorCode: viewModel.colorCode)
        }
        
        nameLbl.text = viewModel.name
        if viewModel.company != nil && viewModel.company != "" && viewModel.company != " " {
            
                designationLbl.text = viewModel.designation + "  •  " + viewModel.company
        }
        else
        {
            designationLbl.text = viewModel.designation

        }
        countryLbl.text = viewModel.country
        pointsCount.text = viewModel.points
        profileTypeView.checkType = (isAdmin:viewModel.isAdmin ,isMod: viewModel.isMod, isNew:viewModel.isNew, rank:viewModel.rank, isLevel: viewModel.isLevel, level: viewModel.level)
    }
    
    /*private func configCMCell(with viewModel: FriendCellViewViewModel){
        profileView.updateViews(name: viewModel.name, url: viewModel.profilePic, colorCode: viewModel.colorCode)
        nameLbl.text = viewModel.name
        designationLbl.text = viewModel.designation
        countryLbl.text = viewModel.country
        profileTypeView.checkType = (isAdmin:viewModel.isAdmin ,isMod: viewModel.isMod, isNew:viewModel.isNew, rank:viewModel.score)
    }*/
    
}
