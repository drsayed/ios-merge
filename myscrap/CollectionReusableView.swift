//
//  CollectionReusableView.swift
//  myscrap
//
//  Created by MyScrap on 6/30/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit


class CollectionReusableView: UICollectionReusableView{
    
    let grayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.cvColor
        return view
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Sell Offers"
        lbl.font = Fonts.newsTitleFont
        return lbl
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.seperatorColor
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        backgroundColor = UIColor.white
        
        addSubview(grayView)
        grayView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: nil)
        grayView.setSize(size: CGSize(width: 0, height: 15))
        grayView.dropShadow()
        
        addSubview(label)
        
        label.anchor(leading: leadingAnchor, trailing: nil, top: grayView.bottomAnchor, bottom: nil, padding: UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 0))
        
        addSubview(seperatorView)
        
        seperatorView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: nil, bottom: bottomAnchor,padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        seperatorView.setSize(size: CGSize(width: 0, height: 1))
        
    }
}


private extension UIView{
    func dropShadow(){
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    
}
