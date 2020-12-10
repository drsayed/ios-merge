//
//  TabBarScrollCVCell.swift
//  myscrap
//
//  Created by MyScrap on 6/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class TabBarScrollCVCell: BaseCell {
    
    let selectedFont = UIFont(name: "HelveticaNeue-Medium", size: 13)
    let font = UIFont(name: "HelveticaNeue", size: 13)!
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.text = "hello"
        lbl.font = UIFont(name: "HelveticaNeue", size: 13)!
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpViews()
    }

    func setUpViews(){
        self.addSubview(label)
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //label.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), size: CGSize(width: 100, height: 30))
        
    }
    override var isHighlighted: Bool{
        
        didSet{
            label.textColor = isHighlighted || isSelected ? UIColor.GREEN_PRIMARY: UIColor.BLACK_ALPHA
            label.font = isHighlighted || isSelected ? selectedFont: font
        }
    }
    override var isSelected: Bool{
        didSet{
            label.textColor = isHighlighted || isSelected ? UIColor.GREEN_PRIMARY: UIColor.BLACK_ALPHA
            label.font = isHighlighted || isSelected ? selectedFont: font
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
