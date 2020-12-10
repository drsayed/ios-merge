//
//  PreviewSImagePostCell.swift
//  myscrap
//
//  Created by MyScrap on 2/9/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class PreviewSImagePostCell: BaseCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var deleteImage: UIButton!
    
    @IBOutlet weak var addMorePhotosButton: UIButton!
    @IBOutlet weak var addMorePhotos: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupPostImageView(image: UIImage) {
        postImageView.image = image
    }

}
