//
//  MenuFeedCell.swift
//  myscrap
//
//  Created by MyScrap on 3/27/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuFeedCell: UITableViewCell {
    
    @IBOutlet weak var feedLbl: UILabel!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            feedLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
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
        if selected == true {
            textLabel?.textColor = UIColor.GREEN_PRIMARY
            detailTextLabel?.textColor = UIColor.GREEN_PRIMARY
        } else {
            textLabel?.textColor = UIColor.BLACK_ALPHA
            detailTextLabel?.textColor = UIColor.BLACK_ALPHA
        }
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuFeedCell {
        let id = "FeedsCell"
        tableView.register(UINib(nibName: "MenuFeedCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuFeedCell
        return cell
    }

}
