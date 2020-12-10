//
//  NewsCell.swift
//  myscrap
//
//  Created by MS1 on 8/27/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell{
    
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    var newsType: NewsType = .WasteRecycling
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        newsImg.contentMode = .scaleAspectFill
        newsImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(news: News){
        if let url = URL(string: news.newsImage) {
            newsImg.sd_setImage(with: url, completed: nil)
        }
        headingLbl.text = news.heading
        timeLbl.text = String.init(describing: news.timeStamp)
    }
    
}
