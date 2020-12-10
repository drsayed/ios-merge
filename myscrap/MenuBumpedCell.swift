//
//  MenuBumpedCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuBumpedCell: UITableViewCell {

    @IBOutlet weak var bumpedLbl: UILabel!
    @IBOutlet weak var badgeLbl: BadgeSwift!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            bumpedLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            self.backgroundColor = selected ? UIColor(hexString: "#e9f0e9") : UIColor.white
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        badgeLbl.isHidden = true
        setupBadgeCountObservers()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupBadgeCountObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(menuTableItemsChanded(_:)), name: .visitorsCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(menuTableItemsChanded(_:)), name: .bumpCountChanged, object: nil)
    }
    
    @objc private func menuTableItemsChanded(_ notification: Notification){
        if let bumpCount = NotificationService.instance.bumpCount {
            if bumpCount == 0 {
                badgeLbl.isHidden = true
            } else {
                badgeLbl.isHidden = false
                badgeLbl.text =  "\(bumpCount)"
            }
        }
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuBumpedCell {
        let id = "BumpedCell"
        tableView.register(UINib(nibName: "MenuBumpedCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuBumpedCell
        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .bumpCountChanged, object: nil)
    }
}
