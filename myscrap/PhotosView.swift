//
//  PhotosView.swift
//  myscrap
//
//  Created by MyScrap on 12/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol PhotosViewable: class {
    var photosViewController: ScrollableImageVC? { get set}
    
    //func populateWithPhoto(_ photo: MarketPhotoViewable)
    
    func setHidden(_ hidden: Bool, animated: Bool)
    
    func view() -> UIView

}

extension PhotosViewable where Self: UIView{
    func view() -> UIView {
        return self
    }
}

class PhotosView : UIView, PhotosViewable {
    private (set) var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var button: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "closegallery"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var topShadow: CAGradientLayer!
    private var bottomShadow: CAGradientLayer!
    
    var photosViewController: ScrollableImageVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupShadows()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        addSubview(topView)
        let topViewheightlayout = topView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        topViewheightlayout.priority = UILayoutPriority(rawValue: 999)
        
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.topAnchor.constraint(equalTo: topAnchor),
            topViewheightlayout
            ])
        
        topView.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 15),
            button.widthAnchor.constraint(equalToConstant: 30)
            ])
        button.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
    }
    
    private func setupShadows(){
        let startColor = UIColor.black.withAlphaComponent(0.5)
        let endColor = UIColor.clear
        
        self.topShadow = CAGradientLayer()
        topShadow.colors = [startColor.cgColor, endColor.cgColor]
        self.layer.insertSublayer(topShadow, at: 0)
        
        self.bottomShadow = CAGradientLayer()
        bottomShadow.colors = [endColor.cgColor, startColor.cgColor]
        self.layer.insertSublayer(bottomShadow, at: 0)
        
        updateShadowFrames()
    }
    
    @objc func closeBtnTapped() {
        photosViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func updateShadowFrames(){
        topShadow.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
        bottomShadow.frame = CGRect(x: 0, y: self.frame.height - 60, width: self.frame.width, height: 60)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowFrames()
    }
    
    func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        if animated {
            self.isHidden = false
            self.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { () -> Void in
                self.alpha = hidden ? 0.0 : 1.0
            }, completion: { result in
                self.alpha = 1.0
                self.isHidden = hidden
            })
        } else {
            self.isHidden = hidden
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), hitView != self{
            return hitView
        }
        return nil
    }
    
    @objc
    private func closeButtonTapped(){
        photosViewController?.dismiss(animated: true, completion: nil)
    }
}
