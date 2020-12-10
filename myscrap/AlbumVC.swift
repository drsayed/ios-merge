//
//  AlbumVC.swift
//  myscrap
//
//  Created by MS1 on 2/25/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage


class AlbumVC: UIViewController {
    
    private let closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "closeButton"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    fileprivate var dataSource = [PictureURL]()
    fileprivate var index: Int = 0
    var image : UIImage = UIImage()
    
    private var flowLayout = UICollectionViewFlowLayout()
    
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
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.register(MyScrapAlbumCell.self)
        return cv
    }()
    
    
    convenience init(index: Int,dataSource: [PictureURL]){
        self.init()
        self.dataSource = dataSource
        self.index = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = UIColor.black
        
        configureLayout()
        
        view.addSubview(collectionView)
        collectionView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: view.bottomAnchor)
        
        view.addSubview(closeButton)

        
        if #available(iOS 11.0, *) {
            let safeAreaLayout = view.safeAreaLayoutGuide
            closeButton.anchor(leading: safeAreaLayout.leadingAnchor, trailing: nil, top: safeAreaLayout.topAnchor, bottom: nil, padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        } else {
            closeButton.anchor(leading: view.leadingAnchor, trailing: nil, top: view.topAnchor, bottom: nil, padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        }
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        
        view.addSubview(buttonMenu)
        
        if #available(iOS 11.0, *) {
                   let safeAreaLayout = view.safeAreaLayoutGuide
                   buttonMenu.anchor(leading: nil, trailing: safeAreaLayout.trailingAnchor, top: safeAreaLayout.topAnchor, bottom: nil, padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 16), size: CGSize(width: 30, height: 30))
               } else {
                   buttonMenu.anchor(leading: nil, trailing: view.trailingAnchor, top: view.topAnchor, bottom: nil, padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 16), size: CGSize(width: 30, height: 30))
               }
     //   buttonMenu.anchor(leading: safeAreaLayout.leadingAnchor, trailing: nil, top: safeAreaLayout.topAnchor, bottom: nil, padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
              
              buttonMenu.addTarget(self, action: #selector(rightBarPressed), for: .touchUpInside)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecogonizeHandler(_:)))
        view.addGestureRecognizer(pan)
        
    }
    
    private func configureLayout(){
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @objc
    private func closeButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        flowLayout.itemSize = view.bounds.size
    }
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    @objc
    func panGestureRecogonizeHandler(_ sender: UIPanGestureRecognizer){
        
        let touchPoint = sender.location(in: self.view.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
        
    }
    
   @objc
      func rightBarPressed(_ sender: UIButton){
       let Alert = UIAlertController(title: "Save Photo", message: nil, preferredStyle: .actionSheet)
       let alert = UIAlertAction(title: "OK", style: .default) { [unowned self] (action) in
           
        for cell in self.collectionView.visibleCells {
               let indexPath = self.collectionView.indexPath(for: cell)
            var url:NSURL = NSURL(string: dataSource[indexPath!.item].images)!
          //  var data:NSData = NSData.dataWithContentsOfURL(url, options: nil, error: nil)
            let data = try? Data(contentsOf: url as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

            self.image = UIImage(data: data!)!
            if self.image  != nil  {
                   print("Contains image but not possible")
                   UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
               } else {
                   print("Image doesn't exist")
                   self.showToast(message: "Failed to download")
               }
               print(indexPath)
           }
        
       
       }
       let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] (action) in
           print("Cancel pressed")
       }
       Alert.addAction(cancel)
       Alert.addAction(alert)
       Alert.view.tintColor = UIColor.GREEN_PRIMARY
       self.present(Alert, animated: true, completion: nil)
   }
    
    deinit {
        print("Album Vc Deinited")
    }
    override func viewWillLayoutSubviews() {
        if index < dataSource.count
        {
            collectionView.scrollToItem(at:IndexPath(item: index, section: 0), at: .right, animated: false)
           

            
        }
    }
}

extension AlbumVC : UICollectionViewDelegate{ }
extension AlbumVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MyScrapAlbumCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        cell.pictureURL = dataSource[indexPath.item]
//        if indexPath.item == 0 {
//            SDWebImageManager.shared().loadImage(with: URL(string: dataSource[indexPath.item].images), options: .refreshCached, progress: nil) {[weak self] (image, data,_, _, _, _) in
//                      guard let img = image else { return }
//             //   self!.image = img
//                  }
//
//        }
       // self.image = cell.imageView.image!
//        cell.rightBarActionBlock = {
//            let Alert = UIAlertController(title: "Save Photo", message: nil, preferredStyle: .actionSheet)
//            let alert = UIAlertAction(title: "OK", style: .default) { [unowned self] (action) in
//
//                if let image = cell.imageView.image {
//                    print("Contains image but not possible")
//                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
//                } else {
//                    print("Image doesn't exist")
//                    self.showToast(message: "Failed to download")
//                }
//            }
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] (action) in
//                print("Cancel pressed")
//            }
//            Alert.addAction(cancel)
//            Alert.addAction(alert)
//            Alert.view.tintColor = UIColor.GREEN_PRIMARY
//            self.present(Alert, animated: true, completion: nil)
//        }
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
         for cell  in collectionView.visibleCells  {
            let  cellImage =  cell as? MyScrapAlbumCell
          //  self.image = cellImage!.imageView.image!
           }
       ///    self.pageControll.currentPage = Int((self.feedImages.contentOffset.x / self.feedImages.contentSize.width) * CGFloat((self.newItem?.pictureURL.count ?? 0) as Int))
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
}



