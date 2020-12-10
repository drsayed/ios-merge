//
//  PhotoScrollCVCell.swift
//  myscrap
//
//  Created by MyScrap on 6/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class PhotoScrollCVCell: BaseCell {
    
    @IBOutlet weak var companyIV: UIImageView!
    
    let compImage : UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "no-image")
        iv.contentMode = ContentMode.scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    func setupView() {
        self.addSubview(compImage)
        compImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        compImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        compImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        compImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Phooto scroll awaken")
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implementedin Photo scroll cell")
    }
    

}
