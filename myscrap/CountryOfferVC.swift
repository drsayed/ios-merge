//
//  CountryOfferVC.swift
//  myscrap
//
//  Created by MyScrap on 7/4/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CountryOfferVC: UICollectionViewController {
    
    var marketType: MarketType?
    var countryCode: String?
    
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    let service = MarketService()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupViews()
    }
    
    var marketDataSource = [MarketData]()
    
    private func setupViews(){
        view.addSubview(activityIndicator)
        
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        activityIndicator.anchor(leading: nil, trailing: nil, top: view.safeTop, bottom: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        setupCollectionView()
        activityIndicator.startAnimating()
        fetchData()
    }
    
    
    @objc
    func handleRefresh(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        fetchData()
    }
    
    private func fetchData(){
        if let type = marketType, let code = countryCode{
            print(code)
            service.getMarketItems(with: type, country: code) { (result) in
                
                print("Result got")
                switch result{
                case .success(let dict):
                    self.reloadViews(with: nil, marketData: dict.data)
                case .failure(let error):
                    self.reloadViews(with: error, marketData: nil)
                }
            }
        }
        
    }
    
    
    func reloadViews(with error: APIError?, marketData: [MarketData]?){
        if activityIndicator.isAnimating{
            self.activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }
        if let data = marketData{
            self.marketDataSource = data.filter({$0.isriCode != nil})
        }
        collectionView?.reloadData()
    }
    
    private func setupCollectionView(){
        collectionView?.registerNibLoadable(MarketListingCell.self)
        collectionView?.backgroundColor = UIColor.white
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return marketDataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MarketListingCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        cell.marketData = marketDataSource[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performDetailVC(with: indexPath)
    }
    
    static func storyBoardInstance(type: MarketType, countryCode: String) -> CountryOfferVC {
        let vc = CountryOfferVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.marketType = type
        vc.countryCode = countryCode
        return vc
    }
    
    func performDetailVC(with indexPath: IndexPath){
        let data = marketDataSource[indexPath.item]
        let vc = DetailListingOfferVC.controllerInstance(with: data.listingID, with1: data.user_data?.userId!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}

extension CountryOfferVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 108 - 30)
    }
}

extension CountryOfferVC: MarketDataCellDelegate{
    func didPressFavourite(cell: MarketListingCell) {
        print("Fav btn")
    }
    
    func didTapViewMore(cell: MarketListingCell) {
        if let indexPath = collectionView?.indexPathForItem(at: cell.center){
//            let list = marketDataSource[indexPath.row]
//            if let data = list.user_data, let userid = data.userId {
//                print("User Id: \(userid)")
//                performDetailVC(with: indexPath)
//            }
            performDetailVC(with: indexPath)
        }
    }
    func didTap(cell: MarketListingCell) {
        if let ip = collectionView?.indexPathForItem(at: cell.center){
            let list = marketDataSource[ip.row]
            if let data = list.user_data, let firstName = data.firstName, let lastName = data.lastName, let colorCode = data.colorCode, let userid = data.userId, let jid = data.jid, let profilePic = data.profilePic {
                performConversationVC(friendId: userid, profileName: "\(firstName) \(lastName)", colorCode: colorCode, profileImage: profilePic, jid: jid, listingId: "", listingTitle: "", listingType: "", listingImg: "")
            }
        }
    }
 }
