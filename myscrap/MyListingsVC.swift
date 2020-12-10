//
//  MyListingsVC.swift
//  myscrap
//
//  Created by MyScrap on 1/21/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class MyListingsVC: BaseRevealVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var refreshControll : UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    var pushTitle: String{
        return "My Listings"
    }
    
    var sectionTitle: String{
        return "My Listings".uppercased()
    }
    
    var postNotification: Notification.Name{
        return .marketListingSellPosted
    }
    
    
    
    
    //var marketDataSource = [MylistData]()
    //using
    var dataSource = [MyListingItems]()
    let service = MarketService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        service.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(refreshControll)
        
        setupViews()
        activityIndicator.startAnimating()
        addObserver()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "My Listings"
        fetchItems()
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(forName: postNotification, object: nil, queue: nil) { [weak self] (notif) in
            self?.handleRefresh()
        }
    }
    
    
    
    private func setupViews(){
        setupCollectionView()
        view.addSubview(activityIndicator)
        activityIndicator.setTop(to: view.safeTop, constant: 30)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
    }
    
    private func setupCollectionView(){
        collectionView?.registerNibLoadable(MylistingCell.self)
        collectionView?.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "hello")
        collectionView?.showsVerticalScrollIndicator = false
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        collectionView?.refreshControl = refreshControll
        print("CV Width : \(collectionView.width), Height: \(collectionView.height)")
    }
    
    func fetchItems(){
        service.getmarketLists()
    }
    
    @objc
    func handleRefresh(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        fetchItems()
    }
    
    func reloadViews(with error: APIError?, marketData: [MyListingItems]?){
        if activityIndicator.isAnimating{
            self.activityIndicator.stopAnimating()
        }
        if refreshControll.isRefreshing{
            self.refreshControll.endRefreshing()
        }
        if let data = marketData{
            self.dataSource = data
        }
        collectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count : \(dataSource.count)")
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MylistingCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        cell.mylistData = dataSource[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 88)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "hello", for: indexPath) as! CollectionReusableView
        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        cell.label.textAlignment = .right
        cell.label.text = "All (BUY AND SELL)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performDetailVC(indexPath: indexPath)
    }
    
    func performDetailVC(indexPath: IndexPath){
        let data = dataSource[indexPath.item]
        let vc = DetailListingOfferVC.controllerInstance(with: data.listing_id, with1: data.user_id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension MyListingsVC: MylistingCellDelegate{
    func didTapViewMore(cell: MylistingCell) {
        if let indexPath = collectionView?.indexPathForItem(at: cell.center){
            let list = dataSource[indexPath.row]
            //if let userid = list.user_id {
                print("User Id: \(list.user_id)")
                performDetailVC(indexPath: indexPath)
            //}

            //performDetailVC(indexPath: indexPath)
        }
    }
    
    func didTap(cell: MylistingCell) {
//        if let ip = collectionView?.indexPathForItem(at: cell.center){
//            //let list = marketDataSource[ip.row]
//            print("Tapped in cell")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
    }
    
}
extension MyListingsVC : MarketServiceDelegate {
    func didReceiveViewListings(data: [ViewListingItems]) {
        print("No view listings")
    }
    
    func DidReceivedData(data: [MyListingItems]) {
        DispatchQueue.main.async {
            self.dataSource = data
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
            }
            self.collectionView.reloadData()
        }
    }
    
    func DidReceivedError(error: String) {
        showMessage(with: error)
    }
    
    
}
