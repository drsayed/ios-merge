//
//  SubMenuTopCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class SubMenuTopCell: UITableViewCell {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        closeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
//        closeBtn.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        print("Using tap gesture")
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SubMenuTopCell {
        let id = "TopCell"
        tableView.register(UINib(nibName: "SubMenuTopCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SubMenuTopCell
        return cell
    }
    
}
