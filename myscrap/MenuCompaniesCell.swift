//
//  MenuCompaniesCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuCompaniesCell: UITableViewCell {

    @IBOutlet weak var companiesLbl: UILabel!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            companiesLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            self.backgroundColor = selected ? UIColor(hexString: "#e9f0e9") : UIColor.white
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuCompaniesCell {
        let id = "CompaniesCell"
        tableView.register(UINib(nibName: "MenuCompaniesCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuCompaniesCell
        return cell
    }
    
}
