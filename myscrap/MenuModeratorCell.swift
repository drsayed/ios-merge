//
//  MenuModeratorCell.swift
//  myscrap
//
//  Created by MyScrap on 4/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuModeratorCell: UITableViewCell {
    
    @IBOutlet weak var moderatorLbl: UILabel!
    @IBOutlet weak var badgeLbl: BadgeSwift!
    
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            moderatorLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
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
        NotificationCenter.default.addObserver(self, selector: #selector(moderatorChanged(_:)), name: .moderatorChanged, object: nil)
    }
    @objc private func moderatorChanged(_ notification: Notification){
        let modCount = NotificationService.instance.moderatorCount!
        if modCount == 0 {
            badgeLbl.isHidden = true
        } else {
            badgeLbl.isHidden = false
            badgeLbl.text =  "\(modCount)"
        }
    }
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuModeratorCell {
        let id = "ModeratorCell"
        tableView.register(UINib(nibName: "MenuModeratorCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuModeratorCell
        return cell
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .moderatorChanged, object: nil)
    }
}
