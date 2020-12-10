//
//  MarketPhotoOverlayViewable.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit

protocol MarketPhotoOverlayViewable: class {
    var photosViewController: MarketPhotosController? { get set}
    
    func populateWithPhoto(_ photo: MarketPhotoViewable)
    
    func setHidden(_ hidden: Bool, animated: Bool)
    
    func view() -> UIView
    
    

}
protocol TinderCardDelegate {
    func didInfoButtonTapped()
}

extension MarketPhotoOverlayViewable where Self: UIView{
    func view() -> UIView {
        return self
    }
}

class MarketPhotoOverlayView: UIView, MarketPhotoOverlayViewable{
    
    
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
    
    var delegate : TinderCardDelegate?
    //let vc = MarketPhotosController()
    
    let buttonMenu: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ellipsis2.png"), for: UIControl.State.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        //add function for button
        
        //set frame
        //button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        
        //let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        //self.navigationItem.rightBarButtonItem = barButton
        return button
    }()
    
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.white
        return pageControl
    }()
    
    private var topShadow: CAGradientLayer!
    private var bottomShadow: CAGradientLayer!
    
    
    private var currentPhoto: MarketPhotoViewable?
    
    var photosViewController: MarketPhotosController?{
        didSet{
            pageControl.numberOfPages = photosViewController!.dataSource.numberOfPhotos
        }
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupShadows()
        setupPageControl()
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
            button.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8),
            button.widthAnchor.constraint(equalToConstant: 30)
            ])
        
        topView.addSubview(buttonMenu)
        NSLayoutConstraint.activate([
            buttonMenu.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            buttonMenu.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -15),
            //buttonMenu.widthAnchor.constraint(equalToConstant: 30)
            ])
        
        
        
        let labelBottomAnchor = titleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -12)
        labelBottomAnchor.priority = UILayoutPriority(rawValue: 998)
        
        topView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8),
            labelBottomAnchor
            ])
        
        
        
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        buttonMenu.addTarget(self, action: #selector(rightBarPressed), for: .touchUpInside)
        
        
    }
    
    
    private func setupPageControl(){
        addSubview(pageControl)
        
        pageControl.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
        
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
    
    private func updateShadowFrames(){
        topShadow.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
        bottomShadow.frame = CGRect(x: 0, y: self.frame.height - 60, width: self.frame.width, height: 60)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowFrames()
    }
    
    func populateWithPhoto(_ photo: MarketPhotoViewable) {
        self.currentPhoto = photo
        
        if let controller = photosViewController, let index = controller.dataSource.indexOfPhoto(photo){
            titleLabel.text = photo.title
            pageControl.currentPage = index
            
        }
        
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
    
    /*@objc func rightBarPressed() {
        
        let Alert = UIAlertController(title: "Save Photo", message: nil, preferredStyle: .actionSheet)
        let alert = UIAlertAction(title: "OK", style: .default) { [unowned self] (action) in
            
            let vc = MarketPhotoViewController()
            print(vc.imageView.image)
            UIImageWriteToSavedPhotosAlbum((self.currentPhoto?.image)!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            /*if self.fetchedImage != nil {
             UIImageWriteToSavedPhotosAlbum(self.fetchedImage!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
             }
             else {
             print("Still image contains nil")
             }*/
            
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] (action) in
            print("Cancel pressed")
        }
        Alert.addAction(cancel)
        Alert.addAction(alert)
        Alert.view.tintColor = UIColor.GREEN_PRIMARY
        photosViewController?.present(Alert, animated: true, completion: nil)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            photosViewController?.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            photosViewController?.present(ac, animated: true)
        }
    }*/
    
    @objc func rightBarPressed() {
        print(delegate)
        delegate?.didInfoButtonTapped()
    }
    
    
}


extension UIPageControl {
    
    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
    
}
