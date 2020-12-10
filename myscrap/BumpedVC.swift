//
//  BumpedVC.swift
//  myscrap
//
//  Created by MS1 on 12/11/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit


class BumpedVC: BaseRevealVC {
    
    fileprivate let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let spacing: CGFloat = 10
    fileprivate var isInitiallyLoaded = false
    
    
    let activityIndicator : UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(frame: .zero)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.style = .gray
        av.hidesWhenStopped = true
        return av
    }()
    
    lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(BumpedVC.handleRefresh(_:)), for: .valueChanged)
        collectionView.refreshControl = rc
        return rc
    }()
    
    fileprivate var dataSource = [BumpedItem]() {
        didSet{
            isInitiallyLoaded = true
            if refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            if activityIndicator.isAnimating{
                activityIndicator.stopAnimating()
            }
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        title = "Bumped"
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        view.addConstraintWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if #available(iOS 11.0, *) {
            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        } else {
            // Fallback on earlier versions
            activityIndicator.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 30).isActive = true
        }
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if dataSource.isEmpty{
            self.activityIndicator.startAnimating()
            getBumps()
        }
    }
    
    private func setupCollectionView(){
        collectionView.register(BumpedCell.self, forCellWithReuseIdentifier: BumpedCell.identifier)
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets
        collectionView.showsVerticalScrollIndicator = false
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl){
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        getBumps()
    }
    
    fileprivate func getBumps(){
        BumpedItem.getBumbs { (success, error, bumpItems) in
            DispatchQueue.main.async {
                if success{
                    guard let items = bumpItems else { print(error ?? "Error"); return}
                    self.dataSource = items
                    BumpedItem.updateBumps()
                }
            }
        }
    }
}

extension BumpedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BumpedCell.identifier, for: indexPath) as! BumpedCell
        cell.bumpedItem = dataSource[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insetLength = insets.left + insets.right
        let width = (collectionView.frame.width - insetLength - spacing) / 2
        let imageHeight = width 
        return CGSize(width: width , height: imageHeight + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.textLbl.text = "No Bumped Posts"
        cell.imageView.image = #imageLiteral(resourceName: "ic_bumped")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isInitiallyLoaded && self.dataSource.count == 0 {
            return CGSize(width: self.view.frame.width, height: view.frame.height)
        }
        return CGSize.zero
    }
}

extension BumpedVC: BumpDelegate{
    
    func didTapChatBtn(cell: BumpedCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center) {
            let bump = dataSource[indexPath.item]
            if let jid = bump.jid{
                performConversationVC(friendId: bump.userId, profileName: bump.name, colorCode: bump.colorCode, profileImage: bump.profilePic, jid: jid, listingId: "", listingTitle: "", listingType: "", listingImg: "")
            }
        }
    }
    
    func didTapCloseBtn(cell: BumpedCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center){
            BumpedItem.removeBumps(friendId: dataSource[indexPath.item].userId, completion: { (success) in
                DispatchQueue.main.async {
                    print(success)
                }
            })
            self.collectionView.performBatchUpdates({
                self.dataSource.remove(at: indexPath.item)
                collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
}


