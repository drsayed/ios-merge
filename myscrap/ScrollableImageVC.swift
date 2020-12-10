//
//  ScrollableImageVC.swift
//  myscrap
//
//  Created by MyScrap on 12/17/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage
class ScrollableImageVC : UIViewController {
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    var images: [String]?
    var image : String!
    /*var closeButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "closegallery"), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnTapped(_sender:)), for: .touchUpInside)
        return btn
    }()*/
    
    private var statusBarHidden = false
    
    var overlayView: PhotosView = PhotosView(frame: .zero){
        willSet{
            overlayView.view().removeFromSuperview()
        }
        didSet{
            overlayView.photosViewController = self
            overlayView.view().autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView.view().frame = view.bounds
            view.addSubview(overlayView.view())
        }
    }
    
    private(set) lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleSingleTapGestureRecognizer(_:)))
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statusBarHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = UIColor.black
        view.tintColor = UIColor.white
        view.addGestureRecognizer(singleTapGestureRecognizer)
        
        overlayView.photosViewController = self
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
        setupOverlayView()
        
        //self.navigationController?.isNavigationBarHidden = true
        let photos = URL(string: image!)
        SDWebImageManager.shared().cachedImageExists(for: photos) { (status) in
            if status{
                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: photos?.absoluteString, done: { (image, _, _) in
                    self.imageView.contentMode = .scaleAspectFit
                    self.imageView.image = image
                })
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: photos, options: .continueInBackground, progress: nil, completed: { (image, _, _, _) in
                    SDImageCache.shared().store(image, forKey: photos?.absoluteString)
                    self.imageView.contentMode = .scaleAspectFit
                    self.imageView.image = image
                })
            }

            
        /*let numOfBtns = images?.count
        
        for i in 0..<images!.count {
            let url = images?[i]
            let photos = URL(string: url!)
            
            
            //adding close button into scroll view
            scrollView.addSubview(closeButton)
            closeButton.frame = CGRect(x: 20 + (i * 20), y: 30, width: 30, height: 40)
            print("Button x : \(closeButton.x)")
            
            
            SDWebImageManager.shared().cachedImageExists(for: photos) { (status) in
                if status{
                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: photos?.absoluteString, done: { (image, _, _) in
                        let imageView = UIImageView()
                        let x = self.view.frame.size.width * CGFloat(i)
                        imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        imageView.contentMode = .scaleAspectFit
                        imageView.image = image
                        
                        self.scrollView.contentSize.width = self.scrollView.frame.size.width * CGFloat(i + 1)
                        self.scrollView.addSubview(imageView)
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: photos, options: .continueInBackground, progress: nil, completed: { (image, _, _, _) in
                        SDImageCache.shared().store(image, forKey: photos?.absoluteString)
                        let imageView = UIImageView()
                        let x = self.view.frame.size.width * CGFloat(i)
                        imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        imageView.contentMode = .scaleAspectFit
                        imageView.image = image
                        
                        self.scrollView.contentSize.width = self.scrollView.frame.size.width * CGFloat(i + 1)
                        self.scrollView.addSubview(imageView)
                    })
                }
            }*/
        }
        //self.scrollView.contentSize.height = CGFloat(45 * numOfBtns!)
        
        
        
    }
    
    private func setupOverlayView(){
        overlayView.view().autoresizingMask = [.flexibleHeight, .flexibleWidth]
        overlayView.view().frame = view.bounds
        view.addSubview(overlayView.view())
        overlayView.setHidden(false, animated: false)
    }
    
    
    static func storyBoardInstance() -> ScrollableImageVC? {
        let st = UIStoryboard(name: StoryBoard.PROFILE, bundle: nil)
        return st.instantiateViewController(withIdentifier: ScrollableImageVC.id) as? ScrollableImageVC
    }
    
    override var prefersStatusBarHidden: Bool{
        if let parentStatusBarHidden = presentingViewController?.prefersStatusBarHidden, parentStatusBarHidden {
            return parentStatusBarHidden
        }
        return statusBarHidden
    }

    @objc
    private func handleSingleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        overlayView.setHidden(!overlayView.view().isHidden, animated: true)
    }
}
