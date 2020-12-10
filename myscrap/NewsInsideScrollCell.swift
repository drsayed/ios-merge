//
//  NewsInsideScrollCell.swift
//  myscrap
//
//  Created by MyScrap on 3/23/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

protocol NewsDelegate : class {
    func didTapNews(Id: String)
}

class NewsInsideScrollCell: BaseCell {
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsDescripLbl: UILabel!
    @IBOutlet weak var newsPostedByLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        curveView.layer.cornerRadius = 10
        curveView.layer.borderWidth = 0.2
        curveView.layer.borderColor = UIColor.black.cgColor
        curveView.layer.shadowColor = UIColor.black.cgColor
        curveView.layer.shadowOffset = CGSize.zero
        curveView.layer.shadowOpacity = 1
        curveView.layer.shadowRadius = 10
        curveView.layer.masksToBounds = true
        
        newsTitleLbl.layer.shadowColor = UIColor.black.cgColor
        newsTitleLbl.layer.shadowRadius = 3.0
        newsTitleLbl.layer.shadowOpacity = 1.0
        newsTitleLbl.layer.shadowOffset = CGSize(width: 3, height: 2)
        newsTitleLbl.layer.masksToBounds = false
        
        newsTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLbl.numberOfLines = 0
    }

}
