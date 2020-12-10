//
//  SubMenuAccountCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class SubMenuAccountCell: UITableViewCell {

    @IBOutlet weak var accountIV: CircularImageView!
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var accountBtn: UIButton!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            accountLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            self.backgroundColor = selected ? UIColor(hexString: "#e9f0e9") : UIColor.white
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        accountBtn.tintColor = .white
        accountBtn.layer.cornerRadius = 20
        accountBtn.clipsToBounds = true
        accountBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        accountBtn.setTitle(String.fontAwesomeIcon(name: .userAlt), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SubMenuAccountCell {
        let id = "AccountCell"
        tableView.register(UINib(nibName: "SubMenuAccountCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SubMenuAccountCell
        return cell
    }
    
}
