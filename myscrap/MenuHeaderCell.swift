//
//  MenuHeaderCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuHeaderCell: UITableViewCell {

    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            //contentView.backgroundColor = selected ? UIColor.GREEN_ALPHA : UIColor.white
            textLabel?.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            detailTextLabel?.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
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
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuHeaderCell {
        let id = "HeaderCell"
        tableView.register(UINib(nibName: "MenuHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuHeaderCell
        return cell
    }
}
