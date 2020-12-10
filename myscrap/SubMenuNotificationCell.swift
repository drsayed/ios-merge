//
//  SubMenuNoticationCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class SubMenuNotificationCell: UITableViewCell {

    @IBOutlet weak var notifIV: CircularImageView!
    @IBOutlet weak var notifLbl: UILabel!
    @IBOutlet weak var notifBtn: UIButton!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            notifLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            self.backgroundColor = selected ? UIColor(hexString: "#e9f0e9") : UIColor.white
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notifBtn.tintColor = .white
        notifBtn.layer.cornerRadius = 20
        notifBtn.clipsToBounds = true
        notifBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        notifBtn.setTitle(String.fontAwesomeIcon(name: .bell), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SubMenuNotificationCell {
        let id = "NotificationCell"
        tableView.register(UINib(nibName: "SubMenuNotificationCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SubMenuNotificationCell
        return cell
    }
    
}
