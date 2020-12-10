//
//  CommentHeaderView.swift
//  myscrap
//
//  Created by MyScrap on 3/17/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class CommentHeaderView: UICollectionReusableView{
    
    lazy var view : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 8, width: self.frame.width, height: self.frame.height))
        v.backgroundColor = UIColor.white
        v.addSubview(imageView)
        v.addSubview(commentLbl)
        v.addSubview(borderView)
        return v
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 16, y: 8, width: 20, height: 20))
        iv.image = #imageLiteral(resourceName: "comment").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.BLACK_ALPHA
        return iv
    }()
    
    lazy var commentLbl : UILabel = {
        let lbl = UILabel(frame: CGRect(x: 44, y: 8, width: self.frame.width - 44 - 16, height: 20))
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    lazy var borderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        self.backgroundColor = UIColor.clear
        addSubview(view)
    }
    
    func configCell(item: [CommentItem]){
        if item.count == 1 {
            commentLbl.text = "1 comment."
        } else {
            commentLbl.text = "\(item.count) comments."
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

