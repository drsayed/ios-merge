//
//  PricesUpdatedVC.swift
//  myscrap
//
//  Created by MyScrap on 17/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class MyScrapPricesVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var cellTime : ForexTitleTVCell = ForexTitleTVCell()

    fileprivate var averageComdyPricesUAE = [AvrageCommudityPriceDubai]()
    fileprivate var averageComdyPricesIndia = [AvrageCommudityPriceIndia]()

    private let service = PriceService()
    
    lazy var refreshControl :UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
        return rf
    }()
    
    var timer: Timer!
    var timerUpdateLable: Timer!

    var isRefreshDone = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadData(notification:)), name: Notification.Name("LoadScrapData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.initiazeTimer), name: Notification.Name("ViewWillAppearCalled"), object: nil)

             
       setupTableView()
        cellTime = (tableView.dequeueReusableCell(withIdentifier: ForexTitleTVCell.identifier) as? ForexTitleTVCell)!
    

        self.tableView.isHidden = true
     //   setupUI()
        title = "Prices"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
       
        self.initiazeTimer()
    }
    @objc func initiazeTimer()  {
        
        if timerUpdateLable != nil {
            timerUpdateLable.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
//        timerUpdateLable .invalidate()
        timerUpdateLable = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getCurrentDateTime), userInfo: nil, repeats: true)
       getData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        timerUpdateLable.invalidate()
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
    }
    
    //MARK:- REFRESH CONTROL
    @objc private func handleRefresh(_ rc: UIRefreshControl){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        self.getData()
    }
    @objc func getCurrentDateTime()
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        let dubaiTime = DateFormatter()
        dubaiTime.timeZone = TimeZone(identifier:"GST")
      //  londonTime.dateFormat = "dd MMM yyyy"
        dubaiTime.dateFormat = "hh:mm:ss"
        let dubaiTimeString = dubaiTime.string(from: date)

        
        let result = formatter.string(from: date) + " Dubai \(dubaiTimeString)"
        cellTime.lastUpdateLbl.text = result
        //return result
    }
    @objc func ReloadData(notification: Notification) {
                  
           if refreshControl.isRefreshing{
                     refreshControl.endRefreshing()
                 }
             let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                         spinner.mode = MBProgressHUDMode.indeterminate
                         spinner.label.text = "Loading"
                  self.view.bringSubviewToFront(spinner)
               //  activityIndicator.startAnimating()
                 getData()
                  // activityIndicator.stopAnimating()
              
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
        tableView.register(ScrapTitleTVCell.nib, forCellReuseIdentifier: ScrapTitleTVCell.identifier)
        tableView.register(ForexTitleTVCell.nib, forCellReuseIdentifier: ForexTitleTVCell.identifier)

        
        //Header Cell
        tableView.register(ScrapHeaderTVCell.nib, forCellReuseIdentifier: ScrapHeaderTVCell.identifier)
       
        //Main Body Cell
        tableView.register(ScrapPricesTVCell.nib, forCellReuseIdentifier: ScrapPricesTVCell.identifier)
      tableView.register(ScrapFooterCell.nib, forCellReuseIdentifier: ScrapFooterCell.identifier)
       
        
        tableView.showsVerticalScrollIndicator = false
        tableView.addSubview(refreshControl)
        
        if let cellFootter : ScrapFooterCell =  tableView.dequeueReusableCell(withIdentifier: "ScrapFooterCell") as? ScrapFooterCell
 {
    cellFootter.reportPriceButton.addTarget(self, action: #selector(self.reportPriceButtonPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
//            if AuthService.instance.companyCountryID == "224"
//            {
//                cellFootter.reportPriceButton.isHidden = false
//            }
//            else{
//                cellFootter.reportPriceButton.isHidden = true
//
//            }
            if AuthService.instance.companyId == nil || AuthService.instance.companyId == "0" || AuthService.instance.companyCountryID != "224" || AuthService.instance.companyId == ""
            {
                cellFootter.reportPriceButton.isHidden = true
            }
            else{
                cellFootter.reportPriceButton.isHidden = false

            }
            tableView.tableFooterView = cellFootter

        }
      
       
        
    }
    @objc func reportPriceButtonPressed(_ sender: UIButton){ //<- needs `@objc`
        print("\(sender)")
//        let vc = UIStoryboard(name: StoryBoard.MAIN , bundle: nil).instantiateViewController(withIdentifier: EditProfilePopupVC.id)
//
//      //  pushViewController(storyBoard: StoryBoard.MAIN, Identifier: EditProfilePopupVC.id)
//  self.navigationController?.pushViewController(vc, animated: true)
          NotificationCenter.default.post(name: Notification.Name("ReportYourPriceButtonPressed"), object: nil, userInfo: ["code":"0"])
    }
   @objc func commudityDetailsButtonPressed(_ sender: UIButton){ //<- needs `@objc`
          print("\(sender)")
// open details vc

   let data = averageComdyPricesUAE[sender.tag] as  AvrageCommudityPriceDubai
   NotificationCenter.default.post(name: Notification.Name("OpenCommodityButtonPressed"), object: nil, userInfo: ["commodityid": data.commodityid,"commodityName": data.commodityName])
//
//
    
    }
    @objc func getData() {
        service.fetchAvrageCommudityPrices { (success, items) in
            DispatchQueue.main.async {
                if success {
                    if let item = items {
                        self.averageComdyPricesUAE = item.avgCommudityItemsUAE
                       self.averageComdyPricesIndia = item.avgCommudityItemsIndia
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.updateTableView()
                        self.tableView.isHidden = false
                        
                        if self.isRefreshDone {
                            self.isRefreshDone = false
                            self.showToast(message: "Prices Updated")
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)

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
extension MyScrapPricesVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
         return 1
        }
       else if section == 1 {
         return averageComdyPricesUAE.count
        }
           else
        {
             return averageComdyPricesIndia.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if cellTime != nil {
                cellTime.titleLbl.text = ""
                
                self.getCurrentDateTime()
                
                //cellTime.lastUpdateLbl.text =
                return cellTime
            } else {
                return UITableViewCell()
            }
        }

      else  if indexPath.section == 1 {
            
              if let cell : ScrapPricesTVCell = tableView.dequeueReusableCell(withIdentifier: ScrapPricesTVCell.identifier, for: indexPath) as? ScrapPricesTVCell {
                        let data = averageComdyPricesUAE[indexPath.item]
                       cell.lbl1.text = data.commodityName
                        cell.lbl2.text = data.avgPrice
                       // cell.lbl4.text = data.symbol+data.change
                if data.symbol == "-" {
                                              cell.lbl4.text = data.symbol+data.change
                                             }
                                             else
                                               {
                                                   cell.lbl4.text = data.change
                                             }
                cell.commudityDetailsButton.tag = indexPath.item
                cell.commudityDetailsButton.addTarget(self, action: #selector(self.commudityDetailsButtonPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`

                
                        if data.symbol == "=" {
                            cell.titleBackground.backgroundColor = .clear
                            cell.lbl4.text = "-"
                            cell.lbl4.textColor = .black
                            cell.lbl1.textColor = .black;
                            cell.changeIndicator.isHidden = true
                            cell.widthConstant.constant = 0
                            cell.spaceConstant.constant = 4
                        }
                        else if data.symbol == "" {
                            cell.titleBackground.backgroundColor = .clear
                            cell.lbl4.text = data.symbol+data.change
                            if data.change == "0.00" ||  data.change == "0.0"  ||  data.change == "0"  {
                                cell.lbl4.text = "-"
                            }
                            cell.lbl4.textColor = .black
                            cell.lbl1.textColor = .black;
                            cell.changeIndicator.isHidden = true
                        }
                        else{
                            cell.lbl1.textColor = .white;
                            cell.changeIndicator.isHidden = false
                            cell.widthConstant.constant = 18
                            cell.spaceConstant.constant = 4
                            if data.symbol == "-"
                            {
                                cell.titleBackground.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
                                cell.lbl4.textColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
                                cell.changeIndicator.image = UIImage(named: "feed_arrow_down.png")
                            }
                            else
                            {
                                cell.titleBackground.backgroundColor = UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00)
                                cell.lbl4.textColor = UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00)
                                cell.changeIndicator.image = UIImage(named: "feed_arrow_up.png")
                            }
                        }

            //            cell.separatorView.isHidden = true
                       
                      //  UIColor(red: 33/255.0, green: 108/255.0, blue: 41/255.0, alpha: 0.1)
                       
                        
                        if indexPath.item%2==0{
                            cell.contentView.backgroundColor = .white}
                        else{
                            cell.contentView.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00)
                            
                        }
                        return cell
                    } else {
                        return UITableViewCell()
                    }
        }
        else
        {
        if let cell : ScrapPricesTVCell = tableView.dequeueReusableCell(withIdentifier: ScrapPricesTVCell.identifier, for: indexPath) as? ScrapPricesTVCell {
            let data = averageComdyPricesIndia[indexPath.item]
           cell.lbl1.text = data.commodityName
            cell.lbl2.text = data.avgPrice
            cell.lbl4.text = data.symbol+data.change
            if data.symbol == "=" {
                cell.titleBackground.backgroundColor = .clear
                cell.lbl4.text = "-"
                cell.lbl4.textColor = .black
                cell.lbl1.textColor = .black;
                cell.changeIndicator.isHidden = true
            }
            else if data.symbol == "" {
                cell.titleBackground.backgroundColor = .clear
                cell.lbl4.text = data.symbol+data.change
                if data.change == "0.00" ||  data.change == "0.0"  ||  data.change == "0"  {
                    cell.lbl4.text = "-"
                }
                cell.lbl4.textColor = .black
                cell.lbl1.textColor = .black;
                cell.changeIndicator.isHidden = true
            }
            else{
                cell.lbl1.textColor = .white;
                cell.changeIndicator.isHidden = false
                if data.symbol == "-"
                {
                    cell.titleBackground.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
                    cell.lbl4.textColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
                    cell.changeIndicator.image = UIImage(named: "feed_arrow_down.png")
                }
                else
                {
                    cell.titleBackground.backgroundColor = UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00)
                    cell.lbl4.textColor = UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00)
                    cell.changeIndicator.image = UIImage(named: "feed_arrow_up.png")
                }
            }

//            cell.separatorView.isHidden = true
           
          //  UIColor(red: 33/255.0, green: 108/255.0, blue: 41/255.0, alpha: 0.1)
           
            
            if indexPath.item%2==0{
                cell.contentView.backgroundColor = .white}
            else{
                cell.contentView.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00)
                
            }
            return cell
        } else {
            return UITableViewCell()
        }
        }
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let cell : ScrapHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: ScrapHeaderTVCell.identifier) as! ScrapHeaderTVCell
        if section == 1 {
            cell.countryTitle.text = "DUBAI"
        }
        else
        {
            cell.countryTitle.text = "INDIA"
        }
                return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else
        {
            return 36
        }
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 16
        }
        else
        {
            return 26
        }
    }
    func tableView (_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.5
        }
        else
        {
            return 0.5
        }
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//           // return nil
//            let view = UIView(frame: .zero)
//            view.backgroundColor = UIColor.white
//            let separator = UIView(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: 0, height: 0.5))
//            separator.autoresizingMask = .flexibleWidth
//            separator.backgroundColor = .white// tableView.separatorColor
//            view.addSubview(separator)
//            return view
//
//    }
}
