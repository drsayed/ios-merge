//
//  PhotoAlbumVC.swift
//  myscrap
//
//  Created by MS1 on 8/31/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import Photos
internal let ImageCellIdentifierp = "ImageCell"

internal let defaultItemSpacingp: CGFloat = 1

public typealias PhotoLibraryViewSelectionCompletep = (PHAsset?) -> Void

public class PhotoAlbumVC: UIViewController {
    
    var selectedIndexPaths = [NSMutableArray]()
    
    internal var assets: PHFetchResult<PHAsset>? = nil
    
    public var onSelectionComplete: PhotoLibraryViewSelectionComplete?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CameraGlobals.shared.photoLibraryThumbnailSize
        layout.minimumInteritemSpacing = defaultItemSpacing
        layout.minimumLineSpacing = defaultItemSpacing
        layout.sectionInset = UIEdgeInsets.zero
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setNeedsStatusBarAppearanceUpdate()

        self.title = "Select Photos"
        
        view.backgroundColor = UIColor(white: 0.2, alpha: 1)
        view.addSubview(collectionView)
        
        _ = ImageFetcher()
            .onFailure(onFailure)
            .onSuccess(onSuccess)
            .fetch()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    public func present(_ inViewController: UIViewController, animated: Bool) {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.barTintColor = UIColor.black
        navigationController.navigationBar.barStyle = UIBarStyle.black
        inViewController.present(navigationController, animated: animated, completion: nil)
    }
   
    private func onSuccess(_ photos: PHFetchResult<PHAsset>) {
        assets = photos
        configureCollectionView()
    }
    
    private func onFailure(_ error: NSError) {
        let permissionsView = PermissionsView(frame: view.bounds)
        permissionsView.titleLabel.text = localizedString("permissions.library.title")
        permissionsView.descriptionLabel.text = localizedString("permissions.library.description")
        
        view.addSubview(permissionsView)
    }
    
    private func configureCollectionView() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    internal func itemAtIndexPath(_ indexPath: IndexPath) -> PHAsset? {
        return assets?[(indexPath as NSIndexPath).row]
    }
}

// MARK: - UICollectionViewDataSource -
extension PhotoAlbumVC : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets?.count ?? 0
    }
    
    @objc(collectionView:willDisplayCell:forItemAtIndexPath:) public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is ImageCell {
            if let model = itemAtIndexPath(indexPath) {
                (cell as! ImageCell).configureWithModel(model)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellIdentifier, for: indexPath)
        cell.layer.borderWidth = 3.0
       
        return cell
    }
}

// MARK: - UICollectionViewDelegate -
extension PhotoAlbumVC : UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  onSelectionComplete?(itemAtIndexPath(indexPath))
        
    }
}
