//
//  PricesTabVC.swift
//  myscrap
//
//  Created by MyScrap on 17/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class PricesTabVC: BaseRevealVC {
    
    
    private let slidingTabController = UISimpleSlidingTabController()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var forexItems = [ForexItem]()
    fileprivate var lmeItems = [LondonLMEItem]()
    fileprivate var comexItems = [ComexItem]()
    fileprivate var nymexItems = [NymexItem]()
    
    fileprivate var forexTime = "-"
    fileprivate var lmeTime = "-"
    fileprivate var comexTime = "-"
    fileprivate var nymexTime = "-"
    
    
    private let service = PriceService()
    
 
    
    var timer: Timer!
    var isRefreshDone = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
      // setupTableView()
        setupUI()
       NotificationCenter.default.addObserver(self, selector: #selector(self.DataDownloadedForPricesVC(notification:)), name: Notification.Name("DataDownloadedForPrices"), object: nil)
   NotificationCenter.default.addObserver(self, selector: #selector(self.ReportPriceButtonPressed(notification:)), name: Notification.Name("ReportYourPriceButtonPressed"), object: nil)
   NotificationCenter.default.addObserver(self, selector: #selector(self.OpenCommodityBtnPressed), name: Notification.Name("OpenCommodityButtonPressed"), object: nil)

        
        
        // activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
               spinner.mode = MBProgressHUDMode.indeterminate
               spinner.label.text = "Loading"
        self.view.bringSubviewToFront(spinner)
        title = "Prices"
    }
    
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
            
             let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
             let nav = UINavigationController(rootViewController: vc)
             revealViewController().pushFrontViewController(nav, animated: true)
         }
    @objc func DataDownloadedForPricesVC(notification: Notification) {
      
        MBProgressHUD.hide(for: self.view, animated: true)
         // activityIndicator.stopAnimating()
    }
    @objc func ReportPriceButtonPressed(notification: Notification) {
           //pushViewController(storyBoard: StoryBoard.MAIN, Identifier: ReportYourPriceVC.id)
        let vc = UIStoryboard(name: StoryBoard.MAIN , bundle: nil).instantiateViewController(withIdentifier: ReportYourPriceVC.id) as! ReportYourPriceVC
        
      
        if  AuthService.instance.companyId != "0" && AuthService.instance.companyId.length > 0 {
         
            print("company id : \(AuthService.instance.companyId)")
            vc.isCompanyDetailExist = true
            vc.companyID =  AuthService.instance.companyId
            vc.countryNameText = AuthService.instance.company
        }
        else
        {
                  vc.isCompanyDetailExist = false
        }
     
        self.navigationController?.pushViewController(vc, animated: true)

             //activityIndicator.stopAnimating()
       }
    @objc func OpenCommodityBtnPressed(notification: Notification) {
              //pushViewController(storyBoard: StoryBoard.MAIN, Identifier: ReportYourPriceVC.id)
         let vc = UIStoryboard(name: StoryBoard.MAIN , bundle: nil).instantiateViewController(withIdentifier: CommudityDetailsVC.id) as! CommudityDetailsVC
        if let commodityid = notification.userInfo?["commodityid"]  as? String
        {
            let commodityName = notification.userInfo?["commodityName"]  as? String
            vc.commodityid = commodityid
            vc.commodityName = commodityName!

        }
        self.navigationController?.pushViewController(vc, animated: true)

                //activityIndicator.stopAnimating()
          }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("ViewWillAppearCalled"), object: nil, userInfo: ["rerfresh":"1"])

        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
    }
    

    
    @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem){
     
        if slidingTabController.currentPosition == 0
        {
            print("Load Prime Prices")
            NotificationCenter.default.post(name: Notification.Name("LoadPrimeData"), object: nil, userInfo: ["LoadPrimeData":"1"])

        }
        else
        {
             print("Load Scrap Prices")
            NotificationCenter.default.post(name: Notification.Name("LoadScrapData"), object: nil, userInfo: ["LoadScrapData":"1"])

        }

    }
    
  
    
    
   
    static func storyBoardInstance() -> PricesUpdatedVC?{
        let st = UIStoryboard(name: StoryBoard.MAIN, bundle: nil)
        return st.instantiateViewController(withIdentifier: "PricesUpdatedVC") as? PricesUpdatedVC
    }
    
    deinit {
        print("Prices Deinited")
    }
    private func setupUI(){
        // view
        view.backgroundColor = .white
        view.addSubview(slidingTabController.view) // add slidingTabController to main view
        // MARK: slidingTabController
        let st = UIStoryboard(name: StoryBoard.MAIN, bundle: nil)
                
        slidingTabController.addItem(item:(st.instantiateViewController(withIdentifier: "PricesUpdatedVC") as? PricesUpdatedVC)!, title: "PRIME") // add first item
        slidingTabController.addItem(item:(st.instantiateViewController(withIdentifier: "MyScrapPricesVC") as? MyScrapPricesVC)!, title: "SCRAP") // add second item
        slidingTabController.setHeaderActiveColor(color: UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00)) // default blue
        slidingTabController.setHeaderInActiveColor(color: .black) // default gray
        slidingTabController.setHeaderBackgroundColor(color: .clear) // default white
        slidingTabController.setCurrentPosition(position: 0) // default 0
        slidingTabController.setStyle(style: .fixed) // default fixed
        slidingTabController.build() // build
    }
    
}

