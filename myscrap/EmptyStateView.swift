//
//  EmptyStateView.swift
//  myscrap
//
//  Created by MS1 on 10/18/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class EmptyStateView: UICollectionReusableView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLbl: UILabel!
    
    class var id : String{
        return String(describing: self)
    }
    class var nib: UINib{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    let MyScrap = "myscrap"
    
}

extension UIImageView{
    
    func setImageWithIndicator(imageURL:String) {
        guard !imageURL.isEmpty else {
            image = nil
            return
        }
        if let url = URL(string: imageURL) {
            self.sd_setShowActivityIndicatorView(true)
            self.sd_setIndicatorStyle(.gray)
            //self.sd_setImage(with: url, placeholderImage: UIImage(named: "no-image"), options: .refreshCached, completed: nil)
           self.sd_setImage(with: url, completed: nil)
        }
    
    }
    func setImageWithIndicatorWithPlaceHolder(imageURL:String){
        guard !imageURL.isEmpty else {
            image = nil
            return
        }
        if let url = URL(string: imageURL) {
            self.sd_setShowActivityIndicatorView(true)
            self.sd_setIndicatorStyle(.gray)
            self.sd_setImage(with: url, placeholderImage: UIImage(named: "no-image"), options: .refreshCached, completed: nil)
         //   self.sd_setImage(with: url, completed: nil)
        }
    
    }
}
