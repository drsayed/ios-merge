//
//  MarketPhotoViewController.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit

class MarketPhotoViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView(frame: view.frame)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.delegate = self
        return scrollview
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView(style: .white)
        aI.translatesAutoresizingMaskIntoConstraints = false
        aI.hidesWhenStopped = true
        aI.sizeToFit()
        return aI
    }()
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var marketVC : MarketPhotosController?
    var photo: MarketPhotoViewable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        print("View Height",view.height)
        
        //let playerSubview = marketView as MarketPhotoOverlayView
        //view.addSubview(playerSubview)
        //playerSubview.delegate = self
        
        view.addSubview(scrollView)
        

            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant : 0)
                ])
//        }
        
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])
        
        if let image = photo.image {
            assignImage(with: image)
        } else {
            activityIndicator.startAnimating()
            photo.loadImageWithCompletionHandler { [weak self] (image, error) in
                let completeLoading = {
                    self?.activityIndicator.stopAnimating()
                    if let img = image{
                        self?.assignImage(with: img)
                    }
                }
                if Thread.isMainThread{
                    completeLoading()
                } else {
                    DispatchQueue.main.async(execute: {
                        completeLoading()
                    })
                }
            }
        }
    }
    
    private func assignImage(with image: UIImage){
        
        imageView.image = image
        activityIndicator.stopAnimating()
        imageView.sizeToFit()
        setZoomScale()
        scrollViewDidZoom(scrollView)
    }
    
    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }

}


extension MarketPhotoViewController: UIScrollViewDelegate{
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




