//
//  CompaniesCell.swift
//  myscrap
//
//  Created by MS1 on 1/27/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class CompaniesCell: BaseTableCell {

    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var typeLbl:UILabel!
    @IBOutlet weak var countryLbl:UILabel!
    
    @IBOutlet weak var profileImage: CircularImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLbl.font = Fonts.NAME_FONT
        nameLbl.textColor = UIColor.BLACK_ALPHA
        countryLbl.font = Fonts.DESIG_FONT
        countryLbl.textColor = UIColor.BLACK_ALPHA
        typeLbl.font = Fonts.DESIG_FONT
        typeLbl.textColor = UIColor.BLACK_ALPHA
        nameLbl.numberOfLines = 2
        
        profileImage.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configCell(company: CompanyItem){
        
        nameLbl.text = company.name
        typeLbl.text = company.companyType
        if company.country == "" {
            countryLbl.text = "  "
        } else {
            countryLbl.text = company.country
        }
        
        if let url = URL(string:company.image ) {
            profileImage.sd_setImage(with: url, completed: nil)
        }
        
        
    }
    
    func configCellSignUP(company: SignUPCompanyItem) {
        nameLbl.text = company.name
        typeLbl.text = company.companyType
        if company.country == "" {
            countryLbl.text = "  "
        } else {
            countryLbl.text = company.country
        }
        
        if let url = URL(string:company.image ) {
            profileImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    func configDiscoverCell(company: DiscoverItems){
        
        nameLbl.text = company.name
        typeLbl.text = company.companyType
        if company.country == "" {
            countryLbl.text = "  "
        } else {
            countryLbl.text = company.country
        }
        if company.image == "" || company.image == "https://myscrap.com/" {
            profileImage.image = #imageLiteral(resourceName: "company")
        } else {
            if let url = URL(string:company.image ) {
                profileImage.sd_setImage(with: url, completed: nil)
            }
        }
 
    }
    
    func configComapnyCell(company: Companies){
        nameLbl.text = company.name
        typeLbl.text = company.category
        if company.Country == "" {
            countryLbl.text = "  "
        } else {
            countryLbl.text = company.Country
        }
        if let url = URL(string: company.imageURL) {
            profileImage.sd_setImage(with: url, completed: nil)
        }
        
        
    }
    
}
