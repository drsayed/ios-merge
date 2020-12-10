//
//  MenuNearbyCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuNearbyCell: UITableViewCell {

    @IBOutlet weak var nearbyLbl: UILabel!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            nearbyLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
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
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuNearbyCell {
        let id = "PeopleNearbyCell"
        tableView.register(UINib(nibName: "MenuNearbyCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuNearbyCell
        return cell
    }
}
