//
//  SubMenuSignoutCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class SubMenuSignoutCell: UITableViewCell {

    @IBOutlet weak var signoutBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        signoutBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        signoutBtn.setTitle(String.fontAwesomeIcon(name: .powerOff), for: .normal)
        signoutBtn.titleLabel?.text = "Sign Out"
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func signoutBtnTapped(_ sender: UIButton) {
        
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SubMenuSignoutCell {
        let id = "SignoutCell"
        tableView.register(UINib(nibName: "SubMenuSignoutCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SubMenuSignoutCell
        return cell
    }
    
}
