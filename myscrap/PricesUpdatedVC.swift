//
//  PricesUpdatedVC.swift
//  myscrap
//
//  Created by MyScrap on 17/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class PricesUpdatedVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var myActtivityIndicator: UIActivityIndicatorView!
    fileprivate var forexItems = [ForexItem]()
    fileprivate var lmeItems = [LondonLMEItem]()
    fileprivate var lmeOfficial = [LondonLMEOfficialItem]()
    var cellTime : ForexTitleTVCell = ForexTitleTVCell()
    fileprivate var comexItems = [ComexItem]()
    fileprivate var nymexItems = [NymexItem]()
    fileprivate var shinghaiItems = [ShanghaiItem]()
    fileprivate var forexTime = "-"
    fileprivate var lmeTime = "-"
    var timer = Timer()
    fileprivate var lmeOfficialTime = "-"
      fileprivate var lmeDataShow = "0"
    fileprivate var comexTime = "-"
    fileprivate var nymexTime = "-"
    fileprivate var shinghaiTime = "-"
      fileprivate var promoCode = ""
    private let service = PriceService()
    var   subScriptionView = SubscribePopupView()
      var   lmeBlrView = LMEBlurView()
    
    lazy var refreshControl :UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
        return rf
    }()
    
  
    var isRefreshDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
         NotificationCenter.default.addObserver(self, selector: #selector(self.SubscribedButtonPressed(notification:)), name: Notification.Name("SubScrribeButtonPressed"), object: nil)
        
        self.lmeBlrView =  Bundle.main.loadNibNamed("LMEBlurView", owner: self, options: nil)?[0] as! LMEBlurView

        
     //   cellTime = tableView.dequeueReusableCell(withIdentifier: ForexTitleTVCell.identifier, for: indexPath) as? ForexTitleTVCell
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.ApplyBtnPressed(notification:)), name: Notification.Name("ApplyButtonPressed"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SendBtnPressed(notification:)), name: Notification.Name("SendButtonPressed"), object: nil)
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadData(notification:)), name: Notification.Name("LoadPrimeData"), object: nil)

        
        setupTableView()
        cellTime = (tableView.dequeueReusableCell(withIdentifier: ForexTitleTVCell.identifier) as? ForexTitleTVCell)!
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getCurrentDateTime), userInfo: nil, repeats: true)
//        activityIndicator.startAnimating()
//             activityIndicator.isHidden = false
//             self.view.bringSubviewToFront(activityIndicator)
//
//             myActtivityIndicator.startAnimating()
       
        title = "Prices"
    }
    @objc func getCurrentDateTime()
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        let londonTime = DateFormatter()
        londonTime.timeZone = TimeZone(identifier:"GMT")
      //  londonTime.dateFormat = "dd MMM yyyy"
        londonTime.dateFormat = "hh:mm:ss"
        let londonTimeString = londonTime.string(from: date)

        let newYorkTime = DateFormatter()
        newYorkTime.timeZone = TimeZone(identifier:"America/New_York")
      //  londonTime.dateFormat = "dd MMM yyyy"
        newYorkTime.dateFormat = "hh:mm:ss"
        let newYorkTimeString = newYorkTime.string(from: date)
        
        let shanghaiTime = DateFormatter()
        shanghaiTime.timeZone = TimeZone(identifier:"Asia/Shanghai")
      //  londonTime.dateFormat = "dd MMM yyyy"
        shanghaiTime.dateFormat = "hh:mm:ss"
        let shanghaiTimeString = shanghaiTime.string(from: date)
        
        let result = formatter.string(from: date) + " London \(londonTimeString)" + " New York \(newYorkTimeString)" + " Shanghai \(shanghaiTimeString)"
        cellTime.lastUpdateLbl.text = result
        //return result
    }
    @objc func SubscribedButtonPressed(notification: Notification) {
          //  self.showToast(message: "Subscribe pressed")
        subScriptionView =  Bundle.main.loadNibNamed("SubscribePopupView", owner: self, options: nil)?[0] as! SubscribePopupView
        subScriptionView.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
        subScriptionView.intializeUI()
        self.view.addSubview(subScriptionView)
        
           //  activityIndicator.stopAnimating()
       }
    
    @objc func ApplyBtnPressed(notification: Notification) {
            
            // activityIndicator.stopAnimating()
        if let code = notification.userInfo?["code"]  as? String  {
            if code != "" && code.length > 0 {
                self.sendPromoCodeLME(code: code)
                 // self.showToast(message: code)
            }
            else
            {
                  self.showToast(message: "Please fill valid coupon code")
            }
        }
        else
        {
            self.showToast(message: "Please fill valid coupon code")
        }
        //Please fill valid coupon code
       }
    @objc func SendBtnPressed(notification: Notification) {
         
         // activityIndicator.stopAnimating()
     if let email = notification.userInfo?["email"]  as? String  {
        
        if email != "" && self.isValidEmail(email)  {
                
            subScriptionView.removeFromSuperview()

                self.sendEmailsubscribeLME(email: email)
                  
              }
              else
              {
                    self.showToast(message: "Please enter valid email")
              }
     }
     else
     {
         self.showToast(message: "Please enter valid email")
     }
     //Please fill valid coupon code
    }
   func isValidEmail(_ email: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

       let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailPred.evaluate(with: email)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

      self.tableView.isHidden = true
       timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     //   timer.invalidate()
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
    }
    
    //MARK:- REFRESH CONTROL
    @objc private func handleRefresh(_ rc: UIRefreshControl){
//        if activityIndicator.isAnimating{
//            activityIndicator.stopAnimating()
//        }
        self.getData()
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem){
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
      //  activityIndicator.startAnimating()
        self.isRefreshDone = true
        getData()
    }
    
    func setupTableView() {
        
        //Title Cell
        tableView.register(ForexTitleTVCell.nib, forCellReuseIdentifier: ForexTitleTVCell.identifier)
        tableView.register(ForexTitleTVCell.nib, forCellReuseIdentifier: "LMEOfficialTime")
        tableView.register(LondonTitleTVCell.nib, forCellReuseIdentifier: LondonTitleTVCell.identifier)
        tableView.register(ComexTitleTVCell.nib, forCellReuseIdentifier: ComexTitleTVCell.identifier)
        tableView.register(NymexTitleTVCell.nib, forCellReuseIdentifier: NymexTitleTVCell.identifier)
        
        //Header Cell
        tableView.register(LondonHeaderTVCell.nib, forCellReuseIdentifier: LondonHeaderTVCell.identifier)
        tableView.register(ShangaiHeaderTVCell.nib, forCellReuseIdentifier: ShangaiHeaderTVCell.identifier)
        
        tableView.register(ForexHeaderTVCell.nib, forCellReuseIdentifier: ForexHeaderTVCell.identifier)
        tableView.register(ComexHeaderTVCell.nib, forCellReuseIdentifier: ComexHeaderTVCell.identifier)
        tableView.register(NymexHeaderTVCell.nib, forCellReuseIdentifier: NymexHeaderTVCell.identifier)
        tableView.register(LmeOfficialHeaderTVCell.nib, forCellReuseIdentifier: LmeOfficialHeaderTVCell.identifier)

        //Main Body Cell
        tableView.register(ForexPricesTVCell.nib, forCellReuseIdentifier: ForexPricesTVCell.identifier)
        tableView.register(LondonPricesTVCell.nib, forCellReuseIdentifier: LondonPricesTVCell.identifier)
        tableView.register(ComexPricesTVCell.nib, forCellReuseIdentifier: ComexPricesTVCell.identifier)
        tableView.register(NymexPricesTVCell.nib, forCellReuseIdentifier: NymexPricesTVCell.identifier)
        tableView.register(ShangaiPricesTVCell.nib, forCellReuseIdentifier: ShangaiPricesTVCell.identifier)
        tableView.register(LmeOfficialPricesTVCell.nib, forCellReuseIdentifier: LmeOfficialPricesTVCell.identifier)

        tableView.showsVerticalScrollIndicator = false
        tableView.addSubview(refreshControl)
    }
    
    @objc func getDataFromExchange() {
        service.fetchPricesForExchange { (success, items) in
            DispatchQueue.main.async {
                if success {
                    if let item = items {
                        MBProgressHUD.hide(for: (self.view), animated: true)

                        self.shinghaiTime = item.shanghaiTime
                        self.lmeTime = item.lmeTime
                        self.comexTime = item.comexTime
                        self.lmeItems = item.lme
                       // self.lmeDataShow = item.lmeDataShow
                        self.comexItems = item.comex
                        self.shinghaiItems = item.shanghai
                        self.updateTableView()
                        self.tableView.isHidden = false
                        NotificationCenter.default.post(name: Notification.Name("DataDownloadedForPrices"), object: nil, userInfo: ["PricesData":"1"])
                        DispatchQueue.main.async
                            {

                                if self.lmeDataShow == "0" ||  self.lmeDataShow == "" ||  self.lmeDataShow == "10000" {
                                  //  self.lmeBlrView =  Bundle.main.loadNibNamed("LMEBlurView", owner: self, options: nil)?[0] as! LMEBlurView
                                    self.lmeBlrView.frame = CGRect(x:0, y:110, width:self.view.frame.width, height:CGFloat(self.lmeItems.count * 36))
                                    self.lmeBlrView.tag = 1000;
                                    self.lmeBlrView.addBlurreffect()
                                    self.tableView.bringSubviewToFront(self.lmeBlrView)
                                    self.tableView.addSubview(self.lmeBlrView)

                                 }
                                else
                                {
                                    
                                        self.lmeBlrView.tag = 0;
                                        self.lmeBlrView.removeFromSuperview()
                                   

                                }
                        }
                       
                      

                        if self.isRefreshDone {
                            self.isRefreshDone = false
                            self.showToast(message: "Prices Updated")
                        }
                    }
                } else {
//                    if self.activityIndicator.isAnimating{
//                        self.activityIndicator.stopAnimating()
//                    }
                     NotificationCenter.default.post(name: Notification.Name("DataDownloadedForPrices"), object: nil, userInfo: ["PricesData":"0"])
                    self.showToast(message: "Server error to show the price data")
                }
            }
        }
    }
    @objc func getData() {
        service.fetchPricesUpdated { (success, items) in
            DispatchQueue.main.async {
                if success {
                    if let item = items {
                        self.forexTime = item.forexTime
                        self.nymexTime = item.nymexTime
                        self.forexItems = item.forex
                        self.nymexItems = item.nymex
                        self.lmeOfficial = item.lmeOfficial
                        self.lmeOfficialTime = item.lmeTime
                       self.lmeDataShow = item.lmeShow
            
                                
                                if self.lmeDataShow == "1"  {
                                    self.lmeBlrView.tag = 0;
                                    self.lmeBlrView.removeFromSuperview()
                                    
                                 }
                                
                   
                        
                        self.getDataFromExchange()
                      
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)

                    NotificationCenter.default.post(name: Notification.Name("DataDownloadedForPrices"), object: nil, userInfo: ["PricesData":"0"])
                    self.showToast(message: "Server error to show the price data")
                }
            }
        }
    }
//  @objc func sendEmailsubscribeLME(email: String) {
//
//    service.subscribeLME(email: email) { (success, item )  in
//           DispatchQueue.main.sync {
//               MBProgressHUD.hide(for: self.view, animated: true)
//            if let items = item{
//
//                   self.lmeTime = items.lmeTime
//                   self.comexTime = items.newyorkTime
////                   self.shanghaiTime = items.shanghaiTime
////                   self.showlmeItems = items.lme
////                   self.comItems = items.comex
////                   self.shanItems = items.shanghai
//               }
//        }
//    }
//    }
    @objc func sendEmailsubscribeLME(email: String) {
        
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Loading"
        
        let service = APIService()
             service.endPoint = Endpoints.SUBSCRIBE_LME_URL
          service.params = "userId=\(AuthService.instance.userId)&email=\(email)&status=1&apiKey=\(API_KEY)"
        service.getDataWith(completion: { (result) in
        switch result{
            case .Success(let dict):
                let error = dict["error"] as! Bool
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if !error {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                         self.showToast(message: "Request has been sent")
                        })

                    } else {
                          DispatchQueue.main.async {
                        MBProgressHUD.hide(for: (self.view), animated: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                                   self.showToast(message: "invalid access or email already exist")
                                                  })
                          
                        }

                    }
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: (self.view), animated: true)
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                                                       self.showToast(message: "invalid access or email already exist")
                                                                      })
//                    let alert = UIAlertController(title: "Server Error", message: error, preferredStyle: .alert)
//                    alert.view.tintColor = UIColor.GREEN_PRIMARY
//                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
//                        //self.dismiss(animated: true, completion: nil)
//                    }))
//                    self?.present(alert, animated: true, completion: nil)
                }
            }
        })
        
        
    }
     @objc func sendPromoCodeLME(code: String) {
            
            let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinner.mode = MBProgressHUDMode.indeterminate
            spinner.label.text = "Loading"
            
            let service = APIService()
            service.endPoint = Endpoints.CHECK_COUPON_CODE
            service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&couponCode=\(code)"
            service.getDataWith { [weak self] (result) in
                switch result{
                case .Success(let dict):
                    let error = dict["error"] as! Bool
                    DispatchQueue.main.async {
                          MBProgressHUD.hide(for: (self!.view), animated: true)
                        if !error {
                                MBProgressHUD.hide(for: (self!.view), animated: true)
                           
                                  let status = dict["status"] as! String
                                self!.showToast(message: status)
                                if let textfield : UITextField = self!.lmeBlrView.viewWithTag(400) as? UITextField  {
                                    textfield.text = ""
                                }
                                self?.getData()
                                
                          //  self?.getDataFromExchange()
                        } else {
                             MBProgressHUD.hide(for: (self!.view), animated: true)
                                                            let status = dict["status"] as! String
                                                          self!.showToast(message: status)
                                                     self?.getData()
//                                                           })
                            
                        }
                    }
                case .Error(let error):
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: (self!.view), animated: true)
                         MBProgressHUD.hide(for: (self!.view), animated: true)
                                                  DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                                  //      let status = dict["status"] as! String
                                                      self!.showToast(message: error)
                    })
                    }
                }
            }
            
            
        }
    private func updateTableView(){
//        if activityIndicator.isAnimating{
//            activityIndicator.stopAnimating()
//        }
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
extension PricesUpdatedVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1 {
            return lmeItems.count
        }
        else if section == 2 {
            return comexItems.count
        }
        else if section == 3{
            return shinghaiItems.count
        }
        else if section == 4{
               return 1
        }
        else if section == 5{
            return lmeOfficial.count
        }
        else if section == 6{
            return nymexItems.count
        }
            
        else {
            return forexItems.count
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let myCell = cell as! LondonPricesTVCell
            if self.lmeDataShow == "0" ||  self.lmeDataShow == "" ||  self.lmeDataShow == "10000"
            {
                myCell.blurLbl.blur(8, myCell.contentView.backgroundColor!)
            }
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
            
        else if indexPath.section == 1 {
            if let cell : LondonPricesTVCell = tableView.dequeueReusableCell(withIdentifier: LondonPricesTVCell.identifier, for: indexPath) as? LondonPricesTVCell {
                let data = lmeItems[indexPath.item]
                cell.lbl1.text = data.title
                cell.lbl2.text = data.contract
                cell.lbl3.text = data.last
                cell.blurLbl.text = data.last
             
             //   cell.lbl4.text = data.symbol+data.change
                if data.symbol == "-" {
                                              cell.lbl4.text = data.symbol+data.change
                                             }
                                             else
                                               {
                                                   cell.lbl4.text = data.change
                                             }
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
//                  UIColor(red: 33/255.0, green: 108/255.0, blue: 41/255.0, alpha: 0.1)
//                let image = cell.blur(blurRadius: 2.0)
//                let imageview  : UIImageView = UIImageView()
//                imageview.image = image
//                imageview.frame = cell.bounds
//                let customBlurEffectView = CustomBlurEffectView()
//                customBlurEffectView.frame = cell.bounds;//CGRect(x: 0, y: 0, width: 300, height: 300)
//                customBlurEffectView.blurRadius = 10
//                customBlurEffectView.colorTint = .clear
//                customBlurEffectView.colorTintAlpha = 0.4
//               cell.contentView.addSubview(customBlurEffectView);
                
//                let blurEffect1 = UIBlurEffect(style: UIBlurEffect.Style.dark);
//                let blurEffectView1 = UIVisualEffectView(effect: blurEffect1);

//                blurEffectView1.frame = CGRect(x:cell.titleBackground.frame.size.width, y:0, width:cell.frame.size.width-cell.titleBackground.frame.size.width, height:cell.frame.size.height)
//                blurEffectView1.autoresizingMask = [.flexibleWidth, .flexibleHeight];
//                blurEffectView1.alpha = 0.6
              //  cell.contentView.addSubview(blurEffectView1);
  
                if indexPath.item%2==0{
                    cell.contentView.backgroundColor = .white}
                else{
                    cell.contentView.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00)
                    
                }
                if self.lmeDataShow == "0" ||  self.lmeDataShow == "" ||  self.lmeDataShow == "10000"
                {
                    cell.blurLbl.isHidden  = false
                    cell.lbl3.isHidden  = true
                }
                else
                {
//                    if  self.lmeBlrView.tag == 1000
//                    {
                        self.lmeBlrView.tag = 0;
                        self.lmeBlrView.removeFromSuperview()
                  //  }
                     cell.blurLbl.isHidden  = true
                    cell.lbl3.isHidden  = false
                }
                return cell
            } else {
                return UITableViewCell()
            }
        }
        else if indexPath.section == 2 {
            if let cell : ComexPricesTVCell = tableView.dequeueReusableCell(withIdentifier: ComexPricesTVCell.identifier, for: indexPath) as? ComexPricesTVCell {
                let data = comexItems[indexPath.item]
                cell.lbl1.text = data.title
                cell.lbl2.text = data.month
                cell.lbl3.text = data.last
               // cell.lbl4.text = data.symbol+data.change
                if data.symbol == "-" {
                                              cell.lbl4.text = data.symbol+data.change
                                             }
                                             else
                                               {
                                                   cell.lbl4.text = data.change
                                             }
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
        else if indexPath.section == 3 {
            if let cell : ShangaiPricesTVCell = tableView.dequeueReusableCell(withIdentifier: ShangaiPricesTVCell.identifier, for: indexPath) as? ShangaiPricesTVCell {
                let data = shinghaiItems[indexPath.item]
                cell.lbl1.text = data.title
                cell.lbl2.text = data.month
                cell.lbl3.text = data.last
             //  cell.lbl4.text = data.symbol+data.change
                if data.symbol == "-" {
                                              cell.lbl4.text = data.symbol+data.change
                                             }
                                             else
                                               {
                                                   cell.lbl4.text = data.change
                                             }
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
                if indexPath.item%2==0{
                    cell.contentView.backgroundColor = .white}
                else{
                    cell.contentView.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00)
                    
                }
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
        else if indexPath.section == 4 {
            if let cell : ForexTitleTVCell = tableView.dequeueReusableCell(withIdentifier: "LMEOfficialTime", for: indexPath) as? ForexTitleTVCell {
                cell.titleLbl.text = ""
                if lmeOfficial.count > 0 {
                    let data = lmeOfficial[0]
                    cell.lastUpdateLbl.text = data.date
                }
                else
                {
                    cell.lastUpdateLbl.text = ""
                }
             
                return cell
            } else {
                return UITableViewCell()
            }
        }
        else if indexPath.section == 5 {
            if let cell : LmeOfficialPricesTVCell = tableView.dequeueReusableCell(withIdentifier: LmeOfficialPricesTVCell.identifier, for: indexPath) as? LmeOfficialPricesTVCell {
                let data = lmeOfficial[indexPath.item]
                cell.lbl1.text = data.name
                cell.lbl3.text = data.price
                cell.lbl4.text = data.change
                
                if data.change == "-" {
                                  cell.titleBackground.backgroundColor = .clear
                                  cell.lbl4.text = "-"
                                  cell.lbl4.textColor = .black
                                  cell.lbl1.textColor = .black;
                                  cell.changeIndicator.isHidden = true
                              }
                              else{
                                  cell.lbl1.textColor = .white;
                                  cell.changeIndicator.isHidden = false
                    if data.change.contains("-")
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
             //  cell.lbl4.text = data.symbol+data.change
//                if data.symbol == "-" {
//                                              cell.lbl4.text = data.symbol+data.change
//                                             }
//                                             else
//                                               {
//                                                   cell.lbl4.text = data.change
//                                             }
//                if data.symbol == "" {
//                    cell.titleBackground.backgroundColor = .clear
//                    cell.lbl4.text = "-"
//                    cell.lbl4.textColor = .black
//                    cell.lbl1.textColor = .black;
//                    cell.changeIndicator.isHidden = true
//                }
//                else{
//                    cell.lbl1.textColor = .white;
//                    cell.changeIndicator.isHidden = false
//                    if data.symbol == "-"
//                    {
//                        cell.titleBackground.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
//                        cell.lbl4.textColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
//                        cell.changeIndicator.image = UIImage(named: "feed_arrow_down.png")
//                    }
//                    else
//                    {
//                        cell.titleBackground.backgroundColor = UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00)
//                        cell.lbl4.textColor = UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00)
//                        cell.changeIndicator.image = UIImage(named: "feed_arrow_up.png")
//                    }
//                }
                if indexPath.item%2==0{
                    cell.contentView.backgroundColor = .white}
                else{
                    cell.contentView.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00)
                    
                }
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
        else if indexPath.section == 6 {
            if let cell : NymexPricesTVCell = tableView.dequeueReusableCell(withIdentifier: NymexPricesTVCell.identifier, for: indexPath) as? NymexPricesTVCell {
                let data = nymexItems[indexPath.item]
                cell.lbl1.text = data.name
                cell.lbl2.text = data.spot_month
                cell.lbl4.text = data.change

                if data.change == "" {
                                  cell.titleBackground.backgroundColor = .clear
                                  cell.lbl4.text = "-"
                                  cell.lbl4.textColor = .black
                                  cell.lbl1.textColor = .black;
                                  cell.changeIndicator.isHidden = true
                              }
                              else{
                                  cell.lbl1.textColor = .white;
                                  cell.changeIndicator.isHidden = false
                    if data.change.contains("-")
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
        else {
            if let cell : ForexPricesTVCell = tableView.dequeueReusableCell(withIdentifier: ForexPricesTVCell.identifier, for: indexPath) as? ForexPricesTVCell {
                let data = forexItems[indexPath.item]
                cell.lbl1.text = data.name
                cell.lbl2.text = data.price
                //                if indexPath.item == forexItems.count - 1 {
                //                    cell.separatorView.isHidden = true
                //                } else {
                //                    cell.separatorView.isHidden = false
                //                }
                cell.separatorView.isHidden = true
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
        if section == 1 {
            let cell : LondonHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: LondonHeaderTVCell.identifier) as! LondonHeaderTVCell
            return cell
        }
        else if section == 2 {
            let cell : ComexHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: ComexHeaderTVCell.identifier) as! ComexHeaderTVCell
            return cell
        }
        else if section == 3 {
            let cell : ShangaiHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: ShangaiHeaderTVCell.identifier) as! ShangaiHeaderTVCell
            return cell
        }
        else if section == 5 {
            let cell : LmeOfficialHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: LmeOfficialHeaderTVCell.identifier) as! LmeOfficialHeaderTVCell
            return cell
        }
        else if section == 6 {
            let cell : NymexHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: NymexHeaderTVCell.identifier) as! NymexHeaderTVCell
            return cell
        }
        else if section == 7 {
            let cell : ForexHeaderTVCell = tableView.dequeueReusableCell(withIdentifier: ForexHeaderTVCell.identifier) as! ForexHeaderTVCell
            return cell
        }
        else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 || section == 3 || section == 5 || section == 6 || section == 7 {
            return 36
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 4 {
            return 15
        } else {
            return 28
        }
    }
    func tableView (_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 4 || section == 3{
            return 0.5
        } else {
            return 15
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 || section == 4 {
           // return nil
            let view = UIView(frame: .zero)
            view.backgroundColor = UIColor.white
            let separator = UIView(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: 0, height: 0.5))
            separator.autoresizingMask = .flexibleWidth
            separator.backgroundColor = .white// tableView.separatorColor
            view.addSubview(separator)
            return view
        } else {
            let view = UIView(frame: .zero)
            view.backgroundColor = UIColor.white
            let separator = UIView(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: 0, height: 0.5))
            separator.autoresizingMask = .flexibleWidth
            separator.backgroundColor = .white// tableView.separatorColor
            view.addSubview(separator)
            return view
        }
    }

}
extension UIView
{
    func snapshotView(scale scale: CGFloat = 0.0, isOpaque: Bool = true) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, isOpaque, scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

    func blur(blurRadius blurRadius: CGFloat) -> UIImage?
    {
        guard let blur = CIFilter(name: "CIGaussianBlur") else { return nil }

        let image = self.snapshotView(scale: 1.0, isOpaque: true)
        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)

        let ciContext  = CIContext(options: nil)

        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage

        let boundingRect = CGRect(x: 0,
                                  y: 0,
                                  width: frame.width,
                                  height: frame.height)

        let cgImage = ciContext.createCGImage(result, from: boundingRect)

        return UIImage(cgImage: cgImage!)
    }
}
