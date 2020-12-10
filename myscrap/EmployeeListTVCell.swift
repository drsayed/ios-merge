//
//  EmployeeListTVCell.swift
//  myscrap
//
//  Created by MyScrap on 6/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class EmployeeListTVCell: UITableViewCell {

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    var employeeData : Employees? {
        didSet {
            if let user = employeeData{
                configure(employee: user)
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("Name in cell : \(nameLbl)")
    }
    
    
    func configure(employee: Employees) {
        nameLbl.text = employee.name
        designationLbl.text = employee.designation + " • " + employee.companyName
        countryLbl.text = employee.country
        
        let name = employee.first_name + " " + employee.last_name
        profileView.updateViews(name: name, url: employee.profilePic, colorCode: employee.colorcode)
        print("Rank..... \(employee.rank)")
        if employee.rank == "MOD" {
            profileTypeView.isHidden = false
            profileTypeView.label.text = employee.rank
            profileTypeView.label.textColor = UIColor.WHITE_ALPHA
            profileTypeView.backgroundColor = UIColor.MOD_COLOR
        } else if employee.rank == "NEW" {
            profileTypeView.isHidden = false
            profileTypeView.label.text = employee.rank
            profileTypeView.label.textColor = UIColor.WHITE_ALPHA
            profileTypeView.backgroundColor = UIColor.NEW_COLOR
        } else if employee.rank == "ADMIN" {
            profileTypeView.isHidden = false
            profileTypeView.label.text = employee.rank
            profileTypeView.label.textColor = UIColor.WHITE_ALPHA
            profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
        } else if employee.rank == "NoRank"{
//            profileTypeView.label.text = employee.rank
//            profileTypeView.label.textColor = UIColor.WHITE_ALPHA
//            profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
            profileTypeView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
