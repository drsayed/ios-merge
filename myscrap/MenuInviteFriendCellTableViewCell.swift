//
//  MenuInviteFriendCellTableViewCell.swift
//  myscrap
//
//  Created by MyScrap on 5/21/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuInviteFriendCellTableViewCell: UITableViewCell {

    @IBOutlet weak var inviteLbl: UILabel!
    
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            inviteLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
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
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuInviteFriendCellTableViewCell {
        let id = "MenuInviteFriendCellTableViewCell"
        tableView.register(UINib(nibName: "MenuInviteFriendCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuInviteFriendCellTableViewCell
        return cell
    }
    
}
