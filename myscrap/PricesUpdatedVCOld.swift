//
//  PricesUpdatedVCOld.swift
//  myscrap
//
//  Created by myscrap on 10/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class PricesUpdatedVCOld: BaseRevealVC {
    
    @IBOutlet weak var tableView: UITableView!
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
    
    lazy var refreshControl :UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
        return rf
    }()
    
    var timer: Timer!
    var isRefreshDone = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupTableView()
        title = "Prices"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        activityIndicator.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
        self.tableView.isHidden = true
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
    }
    
    //MARK:- REFRESH CONTROL
    @objc private func handleRefresh(_ rc: UIRefreshControl){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        self.getData()
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem){
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        activityIndicator.startAnimating()
        self.isRefreshDone = true
        getData()
    }
    
    func setupTableView() {
        
        //Title Cell
        tableView.register(ForexTitleTVCell.nib, forCellReuseIdentifier: ForexTitleTVCell.identifier)
        tableView.register(LondonTitleTVCell.nib, forCellReuseIdentifier: LondonTitleTVCell.identifier)
        tableView.register(ComexTitleTVCell.nib, forCellReuseIdentifier: ComexTitleTVCell.identifier)
        tableView.register(NymexTitleTVCell.nib, forCellReuseIdentifier: NymexTitleTVCell.identifier)
        
        //Header Cell
        tableView.register(LondonHeaderTVCell.nib, forCellReuseIdentifier: LondonHeaderTVCell.identifier)
        tableView.register(ComexHeaderTVCell.nib, forCellReuseIdentifier: ComexHeaderTVCell.identifier)
        tableView.register(NymexHeaderTVCell.nib, forCellReuseIdentifier: NymexHeaderTVCell.identifier)
        
        //Main Body Cell
        tableView.register(ForexPricesTVCell.nib, forCellReuseIdentifier: ForexPricesTVCell.identifier)
        tableView.register(LondonPricesTVCell.nib, forCellReuseIdentifier: LondonPricesTVCell.identifier)
        tableView.register(ComexPricesTVCell.nib, forCellReuseIdentifier: ComexPricesTVCell.identifier)
        tableView.register(NymexPricesTVCell.nib, forCellReuseIdentifier: NymexPricesTVCell.identifier)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.addSubview(refreshControl)
    }
    
    @objc func getData() {
        service.fetchPricesUpdated { (success, items) in
            DispatchQueue.main.async {
                if success {
                    if let item = items {
                        self.forexTime = item.forexTime
                        self.lmeTime = item.lmeTime
                        self.comexTime = item.comexTime
                        self.nymexTime = item.nymexTime
                        self.forexItems = item.forex
                        self.lmeItems = item.lme
                        self.comexItems = item.comex
                        self.nymexItems = item.nymex
                        self.updateTableView()
                        self.tableView.isHidden = false
                        
                        if self.isRefreshDone {
                            self.isRefreshDone = false
                            self.showToast(message: "Prices Updated")
                        }
                    }
                } else {
                    if self.activityIndicator.isAnimating{
                        self.activityIndicator.stopAnimating()
                    }
                    self.showToast(message: "Server error to show the price data")
                }
            }
        }
    }
    
    private func updateTableView(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    static func storyBoardInstance() -> PricesUpdatedVC?{
        let st = UIStoryboard(name: StoryBoard.MAIN, bundle: nil)
        return st.instantiateViewController(withIdentifier: "PricesUpdatedVC") as? PricesUpdatedVC
    }
    
    deinit {
        print("Prices Deinited")
    }
}
extension PricesUpdatedVCOld : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else if section == 1{
            return forexItems.count
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return lmeItems.count
        } else if section == 4 {
            return 1
        } else if section == 5 {
            return comexItems.count
        } else if section == 6 {
            return 1
        } else {
            return nymexItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell : ForexTitleTVCell = tableView.dequeueReusableCell(withIdentifier: ForexTitleTVCell.identifier, for: indexPath) as? ForexTitleTVCell {
                cell.titleLbl.text = "Forex"
                cell.lastUpdateLbl.text = forexTime
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            if let cell : ForexPricesTVCell = tableView.dequeueReusableCell(withIdentifier: ForexPricesTVCell.identifier, for: indexPath) as? ForexPricesTVCell {
                let data = forexItems[indexPath.item]
                cell.lbl1.text = data.name
                cell.lbl2.text = data.price
                if indexPath.item == forexItems.count - 1 {
                    cell.separatorView.isHidden = true
                } else {
                    cell.separatorView.isHidden = false
                }
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 2 {
            if let cell : LondonTitleTVCell = tableView.dequeueReusableCell(withIdentifier: LondonTitleTVCell.identifier, for: indexPath) as? LondonTitleTVCell {
                cell.titleLbl.text = "London Metal Exchange"
                cell.lastUpdateLbl.text = lmeTime
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 3 {
            if let cell : LondonPricesTVCell = tableView.dequeueReusableCell(withIdentifier: LondonPricesTVCell.identifier, for: indexPath) as? LondonPricesTVCell {
                let data = lmeItems[indexPath.item]
//                cell.lbl1.text = data.name
//                cell.lbl2.text = data.cash
//                cell.lbl3.text = data.cash_change
//                cell.lbl4.text = data.threemonth
//                cell.lbl5.text = data.threemonth_change
                if indexPath.item == lmeItems.count - 1 {
                    cell.separatorView.isHidden = true
                } else {
                    cell.separatorView.isHidden = false
                }
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 4 {
            if let cell : ComexTitleTVCell = tableView.dequeueReusableCell(withIdentifier: ComexTitleTVCell.identifier, for: indexPath) as? ComexTitleTVCell {
                cell.titleLbl.text = "COMEX Precious Metal"
                cell.lastUpdateLbl.text = comexTime
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 5 {
            if let cell : ComexPricesTVCell = tableView.dequeueReusableCell(withIdentifier: ComexPricesTVCell.identifier, for: indexPath) as? ComexPricesTVCell {
                let data = comexItems[indexPath.item]
//                cell.lbl1.text = data.name
//                cell.lbl2.text = data.spot_month
//                cell.lbl3.text = data.second_month
//                cell.lbl4.text = data.third_month
                if indexPath.item == comexItems.count - 1 {
                    cell.separatorView.isHidden = true
                } else {
                    cell.separatorView.isHidden = false
                }
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 6 {
            if let cell : NymexTitleTVCell = tableView.dequeueReusableCell(withIdentifier: NymexTitleTVCell.identifier, for: indexPath) as? NymexTitleTVCell {
                cell.titleLbl.text = "NYMEX Energy"
                cell.lastUpdateLbl.text = nymexTime
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if let cell : NymexPricesTVCell = tableView.dequeueReusableCell(withIdentifier: NymexPricesTVCell.identifier, for: indexPath) as? NymexPricesTVCell {
                let data = nymexItems[indexPath.item]
                cell.lbl1.text = data.name
                cell.lbl2.text = data.spot_month
//                cell.lbl3.text = data.change
                if indexPath.item == nymexItems.count - 1 {
                    cell.separatorView.isHidden = true
                } else {
                    cell.separatorView.isHidden = false
                }
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            let cell : LondonHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: LondonHeaderTVCell.identifier) as! LondonHeaderTVCell
            return cell
        } else if section == 5 {
            let cell : ComexHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: ComexHeaderTVCell.identifier) as! ComexHeaderTVCell
            return cell
        } else if section == 7 {
            let cell : NymexHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: NymexHeaderTVCell.identifier) as! NymexHeaderTVCell
            return cell
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 || section == 5 || section == 7 {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 4 || indexPath.section == 6 {
            return 60
        } else {
            return 40
        }
    }
}
