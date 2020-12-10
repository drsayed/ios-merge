//
//  SubMenuProfileCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class SubMenuProfileCell: UITableViewCell {
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var profileLbl: UILabel!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            profileLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            self.backgroundColor = selected ? UIColor(hexString: "#e9f0e9") : UIColor.white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileBtn.tintColor = .white
//        profileBtn.layer.cornerRadius = 20
//        profileBtn.clipsToBounds = true
        profileBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        profileBtn.setTitle(String.fontAwesomeIcon(name: .user), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SubMenuProfileCell {
        let id = "ProfileCell"
        tableView.register(UINib(nibName: "SubMenuProfileCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SubMenuProfileCell
        return cell
    }
    
}
