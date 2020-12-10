//
//  SubMenuHeaderCell.swift
//  myscrap
//
//  Created by MyScrap on 3/31/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class SubMenuHeaderCell: UITableViewCell {

    @IBOutlet weak var backMenuLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let origImage = UIImage(named: "arrow_left");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        backBtn.setImage(tintedImage, for: .normal)
        backBtn.tintColor = UIColor.darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SubMenuHeaderCell {
        let id = "HeaderCell"
        tableView.register(UINib(nibName: "SubMenuHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SubMenuHeaderCell
        return cell
    }
    
}
