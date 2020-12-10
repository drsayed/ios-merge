//
//  MenuVisitorsCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MenuVisitorsCell: UITableViewCell {

    @IBOutlet weak var visitorsLbl: UILabel!
    @IBOutlet weak var bageLbl: BadgeSwift!
    var cellSelected: Bool?{
        didSet{
            guard let selected = cellSelected else { return }
            visitorsLbl.textColor = selected ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
            self.backgroundColor = selected ? UIColor(hexString: "#e9f0e9") : UIColor.white
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bageLbl.isHidden = true
        setupBadgeCountObservers()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupBadgeCountObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(menuTableItemsChanded(_:)), name: .visitorsCountChanged, object: nil)
    }
    
    @objc private func menuTableItemsChanded(_ notification: Notification){
        let visitCount = NotificationService.instance.visitorsCount!
        if visitCount == 0 {
            bageLbl.isHidden = true
        } else {
            bageLbl.isHidden = false
            bageLbl.text =  "\(visitCount)"
        }
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuVisitorsCell {
        let id = "VisitorsCell"
        tableView.register(UINib(nibName: "MenuVisitorsCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MenuVisitorsCell
        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .visitorsCountChanged, object: nil)
    }
    
}
