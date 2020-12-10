//
//  DownloadImgButton.swift
//  myscrap
//
//  Created by MyScrap on 2/20/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

@IBDesignable
class DownloadImgV2Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    private func setupViews(){
        //withRenderingMode(.alwaysTemplate)v
        setImage(#imageLiteral(resourceName: "download_72*72"), for: .normal)
   //     tintColor = UIColor.BLACK_ALPHA
    }
}
