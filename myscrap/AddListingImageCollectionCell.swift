//
//  AddListingImageCollectionCell.swift
//  myscrap
//
//  Created by MyScrap on 7/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import Gallery

class AddListingImageCollectionCell: UICollectionViewCell{
    
    typealias Handler = (UICollectionViewCell) -> ()
    
    var onCloseButtonClick: Handler?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "add-bg")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var image: Image? {
        didSet{
            print("show")
            if let item = image{
                item.resolve { (image) in
                    if let img = image {
                        self.imageView.image = img
                    }
                }
            } else {
                imageView.image =  #imageLiteral(resourceName: "add-bg")
            }
        }
    }
    
//    private let closeBtn: UIButton = {
//        let btn = UIButton()
//        btn.setImage(#imageLiteral(resourceName: "bumpedClose"), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    
    
    private func setupViews(){
        addSubview(imageView)
        imageView.setSize(size: CGSize(width: 50, height: 50))
        imageView.centertoSuperView()
        
//        addSubview(closeBtn)
//        closeBtn.setSize(size: CGSize(width: 20, height: 20))
//        closeBtn.anchor(leading: nil, trailing: imageView.trailingAnchor, top: imageView.topAnchor, bottom: nil)
//        closeBtn.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func closeButtonPressed(){
        print("Close Pressed")
        onCloseButtonClick?(self)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
}

