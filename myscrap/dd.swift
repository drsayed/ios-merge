//
//  MarketListingCell.swift
//  myscrap
//
//  Created by MyScrap on 6/6/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
/*
class MarketListingCell : BaseCVCell{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.green
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.BLACK_ALPHA
        return lbl
    }()
    
    let itemLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.BLACK_ALPHA
        return lbl
    }()
    
    let flagImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.green
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let countryLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.BLACK_ALPHA
        return lbl
    }()
    
    let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.BLACK_ALPHA
        return lbl
    }()
    
    
    
    let viewButton: CustomImageView = {
        let btn = CustomImageView()
        btn.image = #imageLiteral(resourceName: "cgtt")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.text = "123"
        return btn
    }()
    
    let chatButton: CustomImageView = {
        let btn = CustomImageView()
        btn.image = #imageLiteral(resourceName: "cgtt")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.text = "123456"
        return btn
    }()
    
    let viewMoreButton: CustomImageView = {
        let btn = CustomImageView()
        btn.image = #imageLiteral(resourceName: "cgtt")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.text = "123ed"
        return btn
    }()
    
    let innerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   
    
    
    override func setupViews() {
        backgroundColor = UIColor.red
        
        addSubview(imageView)
        addSubview(innerView)
        
        
        imageView.anchor(leading: leadingAnchor, trailing: nil, top: topAnchor, bottom: nil, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0))
        imageView.setSize(size: CGSize(width: 80, height: 80))
//
        viewButton.setSize(size: CGSize(width: 0, height: 20))
        chatButton.setSize(size: CGSize(width: 0, height: 20))
        viewMoreButton.setSize(size: CGSize(width: 0, height: 20))
//
//        let bottomStackView = UIStackView(arrangedSubviews: [viewButton, chatButton, viewMoreButton])
//        bottomStackView.axis = .horizontal
////        bottomStackView.spacing = 5
//        bottomStackView.alignment = .center
////        bottomStackView.distribution = .fill
////        bottomStackView.distribution = .fillProportionally
//        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(bottomStackView)
        
        innerView.anchor(leading: imageView.trailingAnchor, trailing: trailingAnchor, top: nil, bottom: imageView.bottomAnchor,padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        
        
        
    }
    
    
    
}
 
 */

class CustomImageView: UIView{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "cgtt")
        return iv
    }()
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "hello"
        return lbl
    }()
    
    @IBInspectable
    var text: String? {
        didSet{
            self.label.text = text
        }
    }
    
    @IBInspectable
    var image: UIImage?{
        didSet{
            self.imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(imageView)
        addSubview(label)
        
        backgroundColor = UIColor.blue
        
        imageView.anchor(leading: leadingAnchor, trailing: nil, top: topAnchor, bottom: bottomAnchor)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        label.setVerticalCenter(to: imageView)
        label.setAnchors(leading: imageView.trailingAnchor, trailing: trailingAnchor, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        imageView.image = image
        label.text = text
        
    }
}

