//
//  LandHomePageV2.swift
//  myscrap
//
//  Created by MyScrap on 2/2/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class LandHomePageV2: UIViewController, UISearchBarDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    /*First time while login the app this api get called
     Get data from API and stores into Realm DB */
    var roastItems = [RoasterItems]()
    let roastHistory = RoasterHistory()
    var isSignedIn = false
    
    fileprivate var dataSource = [LandingItemsV2]()
    fileprivate var service = LandingServiceV2()
    
    fileprivate lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = UIColor.MyScrapGreen
        //rc.attributedTitle = NSAttributedString(string: "PULL DOWN TO REFRESH", attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 14)!, NSAttributedStringKey.foregroundColor : UIColor.MyScrapGreen])
        rc.addTarget(self, action:
            #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    fileprivate var isRefreshControl = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //MarketADShowPopup
    var showPopup = false
    var fromDetailedFeeds = false
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupCV()
        setUpNavBar()
        
        
        //Showing Market AD POPUP here
        if showPopup {
            self.showingMarketPopup()
        }
        
        if isSignedIn {
            let group = DispatchGroup()
            group.enter()
            self.getRoasterHistory(completion: { _ in       //self.feedDataSource.count
                group.leave()
            })
        }
        
        getLandingData(completion: { error in
            if error {
                print("No Data in Landing page")
            } else {
                //print(self.dataSource[1].dataFeeds.count, "Landing items count ")
                self.collectionView.refreshControl = self.refreshControl
            }
        })
    }
    
    func setUpNavBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Copper"
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.white
        searchBar.barStyle = .blackTranslucent
        navigationItem.titleView = searchBar
        searchBar.isTranslucent = true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.present(UINavigationController(rootViewController: SearchViewController()), animated: false, completion: nil)
    }
    
    @objc
    fileprivate func handleRefresh(){
        if network.reachability.isReachable == true {
            
            isRefreshControl = true
            self.getLandingData(completion: { _ in
                //print(self.dataSource[1].dataFeeds.count, "Landing items count ")
            })
            
        } else {
            self.showToast(message: "No internet connection")
        }
        
    }
    
    func setupCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    static func storyBoardInstance() -> LandHomePageV2?{
        let st = UIStoryboard.LAND
        return st.instantiateViewController(withIdentifier: LandHomePageV2.id) as? LandHomePageV2
    }
    
    func getLandingData(completion: @escaping (Bool) -> ()) {
        service.getLandingData { (error, status, topColor, bottomColor, bgImage, data) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
                
                if self.isRefreshControl{
                    self.dataSource = [LandingItemsV2]()
                    self.isRefreshControl = false
                    
                }
                switch data{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Landing data count",self.dataSource.count)
                    let newData = data
                    //newData.removeDuplicates()
                    self.dataSource = newData
                    self.collectionView.reloadData()
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    completion(true)
                }
            }
        }
    }
    
    func getRoasterHistory(completion: @escaping (Bool) -> ()) {
        print("Get roaster history from api")
        roastHistory.getRoasterHistory()
    }
    
    func showingMarketPopup() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketAdvPopUpVC") as! MarketAdvPopUpVC
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func performLikeVC(postId: String){
        let vc = LikesController()
        vc.title = "Likes"
        vc.id = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension LandHomePageV2 : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.count != 0 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let adData = dataSource[0]
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandAdExteriorCell", for: indexPath) as? LandAdExteriorCell else { return UICollectionViewCell()}
            cell.item = adData
            cell.delegate = self
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 150)
    }
}
extension LandHomePageV2 : LandAdScrollDelegate {
    func didTapAdImage(url: String) {
        print("Redirecting to website")
    }
}
