//
//  AlbumCell.swift
//  myscrap
//
//  Created by MS1 on 7/11/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit


final class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    
    override func awakeFromNib() {
        
        self.image.contentMode = .scaleAspectFill
        self.image.clipsToBounds = true
        
    }
    
    func configCell(picture: PictureURL){
        image.setImageWithIndicator(imageURL: picture.images)
        }
    
}
