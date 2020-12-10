//
//  MenuPricesCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuPricesCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            priceLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            self.backgroundColor = selected ? UIColor(hexString: "#e9f0e9") : UIColor.white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuPricesCell {
        let id = "PricesCell"
        tableView.register(UINib(nibName: "MenuPricesCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuPricesCell
        return cell
    }
}
