//
//  MenuDiscoverCell.swift
//  myscrap
//
//  Created by MyScrap on 4/2/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuDiscoverCell: UITableViewCell {

    @IBOutlet weak var discoverLbl: UILabel!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            discoverLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
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

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuDiscoverCell {
        let id = "DiscoverCell"
        tableView.register(UINib(nibName: "MenuDiscoverCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuDiscoverCell
        return cell
    }
}
