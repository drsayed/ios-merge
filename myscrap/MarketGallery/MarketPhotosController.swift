//
//  MarketPhotoController.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit
class MarketPhotosController: UIViewController{
    
    
  /*  The overlayview displayed over photos */
    
    var overlayView: MarketPhotoOverlayView = MarketPhotoOverlayView(frame: .zero){
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
    
    var currentPhotoViewController: MarketPhotoViewController?{
        return pageViewController.viewControllers?.first as? MarketPhotoViewController
    }
    
    var currentPhoto: MarketPhotoViewable?{
        return currentPhotoViewController?.photo
    }

    private (set) var pageViewController: UIPageViewController!
    private (set) var dataSource: MarketGalleryDataSource
    var fetchedImage : UIImage?
    var photo : MarketPhotoViewable!
    
    private var statusBarHidden = false
    
    init(photos: [MarketPhotoViewable],initialPhoto: MarketPhotoViewable? = nil, referenceView: UIView? = nil){
        dataSource = MarketGalleryDataSource(photos: photos)
        super.init(nibName : nil, bundle : nil)
        initialSetupWithInitialPhoto(initialPhoto)
        // starting view and ending View
    }
    
    
    private func initialSetupWithInitialPhoto(_ initialPhoto: MarketPhotoViewable? = nil){
        overlayView.photosViewController = self
        setupPageViewControllerWithInitialPhoto(initialPhoto)
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
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
        pageViewController.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        pageViewController.didMove(toParent: self)
        
        setupOverlayView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statusBarHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        updateCurrentPhotosInformation()
    }
    
    @objc func rightBarPressed() {
        let Alert = UIAlertController(title: "Save Photo", message: nil, preferredStyle: .actionSheet)
        let alert = UIAlertAction(title: "OK", style: .default) { [unowned self] (action) in
            
            if let image = self.currentPhoto!.image {
                print("Contains image but not possible")
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                
                self.currentPhoto!.loadImageWithCompletionHandler { [weak self] (image, error) in
                    UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self!.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
            
            
            //UIImageWriteToSavedPhotosAlbum((self.currentPhoto?.image)!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
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
        self.present(Alert, animated: true, completion: nil)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    private func setupPageViewControllerWithInitialPhoto(_ initialPhoto: MarketPhotoViewable? = nil){
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing: 16.0])
        pageViewController.view.backgroundColor = UIColor.clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let photo = initialPhoto, dataSource.contains(photo){
            changeToPhoto(photo, animated: false)
        } else if let photo = dataSource.photos.first{
            changeToPhoto(photo, animated: false)
        }
        
    }
    
    private func setupOverlayView(){
        overlayView.view().autoresizingMask = [.flexibleHeight, .flexibleWidth]
        overlayView.view().frame = view.bounds
        view.addSubview(overlayView.view())
        overlayView.setHidden(false, animated: false)
        overlayView.delegate = self
    }
    
    func changeToPhoto(_ photo: MarketPhotoViewable, animated: Bool, direction: UIPageViewController.NavigationDirection = .forward){
        if !dataSource.contains(photo){ return }
        let photoViewController = initializePhotoViewController(with: photo)
        pageViewController.setViewControllers([photoViewController], direction: direction, animated: animated, completion: nil)
        updateCurrentPhotosInformation()
    }
    
    func initializePhotoViewController(with photo: MarketPhotoViewable) -> MarketPhotoViewController{
        let controller = MarketPhotoViewController()
        controller.photo = photo
        return controller
    }
    
    private func updateCurrentPhotosInformation(){
        if let currentPhoto = currentPhoto{
            overlayView.populateWithPhoto(currentPhoto)
            //fetchedImage = currentPhoto.image
            //print(fetchedImage)
        }
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
    
    
    
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.dataSource = MarketGalleryDataSource(photos: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dataSource = MarketGalleryDataSource(photos: [])
        super.init(nibName: nil, bundle: nil)
    }
}

extension MarketPhotosController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updateCurrentPhotosInformation()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? MarketPhotoViewController, let pht = controller.photo, let photoIndex = dataSource.indexOfPhoto(pht), let newPhoto = dataSource[photoIndex-1] else {
            if let newPhoto = dataSource[dataSource.numberOfPhotos - 1], dataSource.numberOfPhotos != 1 {
                return initializePhotoViewController(with: newPhoto)
            }
            return nil
        }
        return initializePhotoViewController(with: newPhoto)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? MarketPhotoViewController, let pht = controller.photo, let photoIndex = dataSource.indexOfPhoto(pht), let newPhoto = dataSource[photoIndex + 1] else {
            if let newPhoto = dataSource.photoAtIndex(0) , dataSource.numberOfPhotos != 1{
                return initializePhotoViewController(with: newPhoto)
            }
            return nil
        }
        return initializePhotoViewController(with: newPhoto)
    }
}
extension MarketPhotosController : TinderCardDelegate {
    
    func didInfoButtonTapped() {
        print("Button tapped ")
        self.rightBarPressed()
    }
}





