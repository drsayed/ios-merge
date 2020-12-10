//
//  FavCompanyVC.swift
//  myscrap
//
//  Created by MS1 on 10/19/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
class FavCompanyVC: UICollectionViewController {

    fileprivate var datasource = [CompanyItem]()
    fileprivate var service = CompanyService()
    
    
    fileprivate var initiallyLoaded = false
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    lazy var refreshControl : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return rf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        activityIndicator.startAnimating()
        service.delegate = self
        service.getFavourites()
        setupCollectionView()

        // Do any additional setup after loading the view.
    }
    
    private func setupCollectionView(){
        collectionView?.register(CompanyCell.Nib, forCellWithReuseIdentifier: CompanyCell.identifier)
        self.collectionView?.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        collectionView?.refreshControl = refreshControl
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    @objc private func handleRefresh(_ refresh : UIRefreshControl){
        service.getFavourites()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCell.identifier, for: indexPath) as! CompanyCell
        cell.item = datasource[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as? EmptyStateView else { return UICollectionReusableView() }
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        cell.textLbl.text = "NO FAVOURITE COMPANIES"
        return cell
    }
}

extension FavCompanyVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 89)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return (datasource.isEmpty && initiallyLoaded ) ? CGSize(width: self.view.frame.width, height: self.view.frame.height) : CGSize(width: self.view.frame.width, height: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { 
        /*if let vc = CompanyProfileVC.storyBoardInstance(){
            vc.companyId = datasource[indexPath.item].id
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        if  let vc = CompanyDetailVC.storyBoardInstance() {
            
            vc.companyId = datasource[indexPath.item].id
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension FavCompanyVC : CompanyDelegate{
    func didReceiveData(data: [CompanyItem]) {
        DispatchQueue.main.async {
            self.datasource = data
            self.refreshCollectionView()
        }
    }
    
    func didReceiveError(error: String) {
        DispatchQueue.main.async {
            print(error)
            self.refreshCollectionView()
        }
    }
}

extension FavCompanyVC{
    fileprivate func refreshCollectionView(){
        initiallyLoaded = true
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        self.collectionView?.reloadData()
    }
}


