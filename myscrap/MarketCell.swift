//
//  MarketCell.swift
//  myscrap
//
//  Created by MyScrap on 6/6/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


class MarketCell: BaseCVCell   {
    
    var marketItem: CountryListing? {
        didSet{
            guard let item = marketItem, let img = item.flagCode, let name = item.country, let count = item.count else { return }
            imageView.image = UIImage(named: img) ?? nil
            label.text = "\(name.firstCapitalized) [\(count)]"
        }
    }
    var productList: ProductListing? {
        didSet{
            guard let item = productList, let count = item.total_product, let name = item.isri_code else { return }
            imageView.image = nil
            label.text = "\(name) [\(count)]"
        }
    }
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let label: UILabel = {
        let lbl = UILabel()
        //lbl.numberOfLines = 0
        lbl.font = UIFont(name: "HelveticaNeue", size: 14)
        lbl.textColor = UIColor.BLACK_ALPHA
        //lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(label)
        
        imageView.setVerticalCenter(to: self)
        imageView.setSize(size: CGSize(width: 18, height: 18))
        imageView.setLeading(to: self.leadingAnchor, constant: 5)
        
        //label.setTop(to: topAnchor, constant: 5)
        label.setVerticalCenter(to: imageView)
        label.setLeading(to: imageView.trailingAnchor, constant: 5)
        label.setTrailing(to: self.trailingAnchor, constant: 5)
        
    }
}
