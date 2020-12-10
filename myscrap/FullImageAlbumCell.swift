//
//  FullImageAlbumCell.swift
//  myscrap
//
//  Created by MS1 on 2/25/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage
protocol ImageSwipeAlbumCVFullImageDelgate: class {
    func showingImage(image:UIImage)
}
class FullImageAlbumCell: BaseCVCell{
    var rightBarActionBlock: (() -> Void)? = nil
    weak var delegate: ImageSwipeAlbumCVFullImageDelgate?

    var pictureURL : PictureURL? {
        didSet{
            guard let pictures = pictureURL else { return }
            configureImage(with: pictures.images)
        }
    }
    
    
    
    private lazy var scrollView: UIScrollView = { [unowned self] in
        let sv = UIScrollView(frame: frame)
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
        }()
    
    public let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView(style: .white)
        aI.translatesAutoresizingMaskIntoConstraints = false
        aI.hidesWhenStopped = true
        return aI
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let buttonMenu: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        let menuImage = UIImage(named: "ellipsis2");
        let tintMenuImage = menuImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintMenuImage, for: .normal)
        button.tintColor = UIColor.white
        //button.setImage(UIImage(named: "ellipsis2.png"), for: UIControl.State.normal)
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
    
    override func setupViews() {
        
        contentView.addSubview(scrollView)
        
        scrollView.anchor(leading: contentView.leadingAnchor , trailing: contentView.trailingAnchor, top: contentView.topAnchor, bottom: contentView.bottomAnchor)
        
//        contentView.addSubview(buttonMenu)
//        buttonMenu.anchor(leading: nil, trailing: contentView.trailingAnchor, top: contentView.topAnchor, bottom: nil, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16), size: CGSize(width: 30, height: 30))
//        
//        buttonMenu.addTarget(self, action: #selector(rightBarPressed), for: .touchUpInside)
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        activityIndicator.anchorCenter(to: contentView)
        
        scrollView.addSubview(imageView)
        imageView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor)
        
        activityIndicator.startAnimating()
        
    }
    
    private func configureImage(with urlString: String){
        SDWebImageManager.shared().loadImage(with: URL(string: urlString), options: .refreshCached, progress: nil) {[weak self] (image, data,_, _, _, _) in
            guard let img = image else { return }
            self?.assignImage(with: img)
        }
    }
    
    private func assignImage(with image: UIImage){
        imageView.image = image
        activityIndicator.stopAnimating()
      //  imageView.sizeToFit()
        let screenSize = UIScreen.main.bounds
       let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight )
        
//        setZoomScale()
//        scrollViewDidZoom(scrollView)
    }
    
    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
    
     @objc func rightBarPressed() {
        rightBarActionBlock?()
    }
}

extension FullImageAlbumCell: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        if verticalPadding >= 0 {
            // Center the image on screen
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        } else {
            // Limit the image panning to the screen bounds
            scrollView.contentSize = imageViewSize
        }
    }
    
}

