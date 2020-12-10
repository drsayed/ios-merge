//
//  UPComingVC.swift
//  myscrap
//
//  Created by MS1 on 1/8/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class UPComingVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(UPComingVC.refreshEvents), for: .valueChanged)
        return rc
    }()
    
    
    var dataSource : [EventItem]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    private let collectionViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        cv.contentInset = collectionViewInsets
        cv.refreshControl = refreshControl
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.identifier)
        
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataSource == nil {
            activityIndicatorView.startAnimating()
            getEvents()
        }
    }
    
    
    
    @objc private func refreshEvents(){
        if activityIndicatorView.isAnimating {
            activityIndicatorView.stopAnimating()
        }
        getEvents()
    }
    
    func getEvents(){
        EventItem.getEvents { success, error, dataSource in
            DispatchQueue.main.async {
                if self.activityIndicatorView.isAnimating {
                    self.activityIndicatorView.stopAnimating()
                }
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                self.dataSource = dataSource
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.identifier, for: indexPath) as? EventCell else { return UICollectionViewCell()}
        cell.eventItem = dataSource?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - collectionViewInsets.left - collectionViewInsets.right
        return CGSize(width: width , height: width / 2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let event = dataSource?[indexPath.item] ,let id = event.eventId else { return }
        let vc = EventDetailVC()
        vc.eventId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


