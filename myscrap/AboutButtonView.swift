//
//  AboutButtonView.swift
//  myscrap
//
//  Created by MS1 on 2/1/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

enum ButtonTextType:String{
    case phone
    case website
    case address
    case info
    case joined
     case card
    //New items
    case location
    case hereto
    case profession
    case interested
    case dateofjoining
    case userBio
}

protocol AboutButtonViewDelegate: class {
    func didTapAlertButton(with text: String, of type: ButtonTextType)
}

class AboutButtonView: UIView{
    
    private var textType: ButtonTextType = .location
    
    weak var delegate: AboutButtonViewDelegate?
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.lightGray
        lbl.font = UIFont(name: "HelveticaNeue", size: 11)!
        lbl.backgroundColor = UIColor.clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let detailLbl: UILabel = {
        let lbl =  UILabel()
        lbl.numberOfLines = 0
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.GREEN_PRIMARY
        lbl.textAlignment = .left
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.IMAGE_BG_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        
        addSubview(label)
        label.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: nil, padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8))
        
        addSubview(detailLbl)
        detailLbl.anchor(leading: label.leadingAnchor, trailing: label.trailingAnchor, top: label.bottomAnchor, bottom: nil,padding:UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0))
        
        addSubview(borderView)
        borderView.anchor(leading: label.leadingAnchor, trailing: label.trailingAnchor, top: detailLbl.bottomAnchor, bottom: bottomAnchor,padding: UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0), size: CGSize.init(width: 0, height: 0.5))
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(AboutButtonView.tappedView))
        detailLbl.addGestureRecognizer(tap)
    }
    
    @objc private func tappedView(){
        if let text = label.text {
            delegate?.didTapAlertButton(with: text, of: textType)
        }
    }
    
    convenience init(title: String, buttonText: String, textType: ButtonTextType){
        self.init(frame: .zero)
        self.label.text = title
        self.detailLbl.text = buttonText
        self.textType = textType
        
        switch textType{
        case .location , .interested, .profession, .dateofjoining, .hereto, .userBio :
            detailLbl.textColor = UIColor.GREEN_PRIMARY
        default:
            detailLbl.textColor = UIColor.lightGray
        }
    
    }
}

