//
//  AddPhotoImageView.swift
//  myscrap
//
//  Created by MS1 on 1/11/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
protocol AddPhotoImageViewDelegate: class {
    func didTappedImageView() -> Void
}


final class AddPhotoImageView: UIImageView{
    
    weak var mYDelegate: AddPhotoImageViewDelegate?

    
    let view : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.clear
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 0.5
        return v
    }()
    
    let imageView : UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "ic_photo_library").withRenderingMode(.alwaysTemplate)
        v.tintColor = UIColor.white
        v.contentMode = .scaleAspectFit
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 30)
        v.heightAnchor.constraint(equalToConstant: 30)
        return v
    }()
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.text = "ADD PHOTO"
        lbl.font = Fonts.likeCountFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        backgroundColor = UIColor.lightGray
        setupTap()
        setupCenterView()
    }
    
    private func setupCenterView(){
        
        addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        view.addSubview(imageView)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            imageView.rightAnchor.constraint(equalTo: label.leftAnchor, constant : -8),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            ])

        NSLayoutConstraint.activate([
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            ])
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    
    private func setupTap(){
        self.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddPhotoImageView.imageTapped))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(AddPhotoImageView.imageTapped))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture1)
    }
    
    
    @objc private func imageTapped(){
        mYDelegate?.didTappedImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}
