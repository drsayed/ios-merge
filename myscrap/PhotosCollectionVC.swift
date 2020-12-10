//
//  PhotosCollectionVC.swift
//  myscrap
//
//  Created by MS1 on 11/14/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosCollectionVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView : UICollectionView!
    let button : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect(x: 16, y: 36, width: 50, height: 50)
        btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return btn
    }()
    
    private let identifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        view.addSubview(button)
    }
    
    @objc private func buttonPressed(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
}





class PhotosCollectionCell: UICollectionViewCell , UIScrollViewDelegate{
    
    lazy var scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor.blue
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 3
        sv.delegate = self
        return sv
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.IMAGE_BG_COLOR
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "emptysocialactivity")
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    func setupViews(){
        
        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
        scrollView.addSubview(imageView)
        updateContentInsets()
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
//            ])
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContentInsets()
    }
    
    private func updateContentInsets(){
        
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                let ratio = ratioW < ratioH ? ratioW:ratioH
                let newWidth = image.size.width*ratio
                let newHeight = image.size.height*ratio
                let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))
                scrollView.contentInset = UIEdgeInsets(top: top , left: left, bottom: top , right: left )
            }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







