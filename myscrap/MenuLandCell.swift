//
//  MenuLandCell.swift
//  myscrap
//
//  Created by MyScrap on 1/25/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class MenuLandCell: UITableViewCell {

    @IBOutlet weak var landLbl: UILabel!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            landLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
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
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuLandCell {
        let id = "LandCell"
        tableView.register(UINib(nibName: "MenuLandCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuLandCell
        return cell
    }
    
}
