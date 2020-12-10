//
//  SubMenuMessageCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class SubMenuMessageCell: UITableViewCell {

    @IBOutlet weak var msgIV: CircularImageView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var msgBtn: UIButton!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            msgLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            self.backgroundColor = selected ? UIColor(hexString: "#e9f0e9") : UIColor.white
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        msgBtn.tintColor = .white
        msgBtn.layer.cornerRadius = 20
        msgBtn.clipsToBounds = true
        msgBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        msgBtn.setTitle(String.fontAwesomeIcon(name: .envelope), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SubMenuMessageCell {
        let id = "MessageCell"
        tableView.register(UINib(nibName: "SubMenuMessageCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SubMenuMessageCell
        return cell
    }
}
