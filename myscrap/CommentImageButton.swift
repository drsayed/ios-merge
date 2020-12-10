//
//  CommentImageButton.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

@IBDesignable
class CommentImageButton: UIButton {

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
        setImage(#imageLiteral(resourceName: "commentFeed_48x48"), for: .normal)
        //setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysTemplate), for: .normal)
      //  tintColor = UIColor.BLACK_ALPHA
    }

}

@IBDesignable
class CommentImageV2Button: UIButton {
    
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
        //withRenderingMode(.alwaysTemplate)
        //contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        setImage(#imageLiteral(resourceName: "commentFeed_48x48"), for: .normal)
       // tintColor = UIColor.BLACK_ALPHA
    }
    
}
