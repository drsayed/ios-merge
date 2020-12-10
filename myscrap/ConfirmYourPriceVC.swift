//
//  ReportYourPriceVC.swift
//  myscrap
//
//  Created by MS1 on 10/10/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

final class ConfirmYourPriceVC: UIViewController {
    
    
    private let service = PriceService()
    var myPriceData: NSMutableDictionary = [:]
    var companyName: String = ""
    var companyID :  String  = ""
    var countryID : String  = ""
    @IBOutlet weak var priceTableView: UITableView!
    
    @IBOutlet weak var selectCompanyBtn: UIButton!
    fileprivate var editedCompanyPrices = [CommudityPriceReport]()
    fileprivate var averageCompanyPrices = [CommudityPriceReport]()
    var cellHeader : ConfirmCommudityTableHeader =  ConfirmCommudityTableHeader()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .gray)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    // MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = false
        priceTableView.delegate = self
        priceTableView.dataSource = self
        
      
        self.setupTableView()
        
      //  self.showToast(message: "Please select the company!")
    }
    func setupTableView() {
        
        //Title Cell
        priceTableView.register(ConfirmCommudityPriceEditCell.nib, forCellReuseIdentifier: ConfirmCommudityPriceEditCell.identifier)
        priceTableView.register(ConfirmCommudityPriceHeader.nib, forCellReuseIdentifier: ConfirmCommudityPriceHeader.identifier)
        priceTableView.register(ConfirmCommudityTableHeader.nib, forCellReuseIdentifier: ConfirmCommudityTableHeader.identifier)
        priceTableView.register(ConfirmCommudityFooter.nib, forCellReuseIdentifier: ConfirmCommudityFooter.identifier)
        
        self.cellHeader =  priceTableView.dequeueReusableCell(withIdentifier: "ConfirmCommudityTableHeader") as! ConfirmCommudityTableHeader
        cellHeader.companyName.text = companyName.uppercased() + " - UAE"
     //   self.cellHeader.selecctCompanyButton.addTarget(self, action: #selector(self.selectCompanyBtnPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
        priceTableView.tableHeaderView = self.cellHeader
        if let cellFootter : ConfirmCommudityFooter =  priceTableView.dequeueReusableCell(withIdentifier: "ConfirmCommudityFooter") as? ConfirmCommudityFooter
        {
            cellFootter.submitPriceButton.addTarget(self, action: #selector(self.submitBtnPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
            cellFootter.editButton.addTarget(self, action: #selector(self.editBtnPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`

            priceTableView.tableFooterView = cellFootter
        }
        
    }
   
    @IBAction func submitBtnPressed(_ sender: Any) {
        
              let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
              spinner.mode = MBProgressHUDMode.indeterminate
              spinner.label.text = "Loading"
              self.submitEditedPriceData(companyID: companyID,countryID:"1")
    }
    @IBAction func editBtnPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    // MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 40, width: 320, height: 40))
            lbNavTitle.center = CGPoint(x: 160, y: 285)
            lbNavTitle.textAlignment = .left
        lbNavTitle.textColor = .white
            lbNavTitle.text = "Report Price"
            self.navigationItem.titleView = lbNavTitle
        
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
              spinner.mode = MBProgressHUDMode.indeterminate
              spinner.label.text = "Loading"
         self.getDataFromPriceToConfirm(companyID: companyID,countryID:"1")
        
        super.viewWillAppear(animated)
        //        if let reveal = self.revealViewController() {
        //            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
        //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //        }
    }
    //MARK:- VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
        super.viewWillDisappear(animated)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- SETUP COLLECTIONVIEW
    private func setupCollectionView(){
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
        ])
        
    }
    
    @objc func getDataFromPriceToConfirm(companyID: String , countryID : String) {
        let service = APIService()
       //5

        service.endPoint = Endpoints.GET_Confirm_Value_Page
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyID)&countryId=\(countryID)"
       //service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=5&countryId=1"
        
        //        print(service.endPoint)
        //        print(service.params)
       //  service.params = "userId=\(AuthService.instance.userId)&apiKey=25d4f9ce16a6e976&companyId=\(companyID)&countryId=\(countryID)"
        service.getDataWith {
            [weak self] result in
            switch result {
                
            case .Success(let dict):
                //                print(dict)
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    if let error = dict["error"] as? Bool{
                        if !error{
                            
                            if let pricesData = dict["data"] as? [[String:AnyObject]]{
                                for data in pricesData{
                                    var name =  data["commodityname"] as! String
                                  //  var nameWithoutSpace = name.trimmingCharacters(in: .whitespaces)
                                    var nameWithoutSpace  = name.replacingOccurrences(of: " ", with: "")

                                    let price =  data["price"] as! String
                                    if price != "-" {
                                        self!.myPriceData[nameWithoutSpace] = price
                                    }
                                    else
                                    {
                                        self!.myPriceData[nameWithoutSpace] = "0"
                                    }
                                    let priceObj = CommudityPriceReport(dict: data)
                                    self!.averageCompanyPrices.append(priceObj)
                                }
                            }
                            self?.priceTableView.reloadData()
                            
                        } else {
                            //  completion(false, nil)
                        }
                    }
                }
            case .Error(let _):
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    self?.showToast(message: "Error Please try again")
                }
                // completion(false, nil)
            }
        }
        
    }
@objc func submitEditedPriceData(companyID: String , countryID : String) {
    
            let service = APIService()
             service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyID)&countryId=\(countryID)"
            service.endPoint = Endpoints.GET_Submit_Commodity_Price

            service.getDataWith {
                [weak self] result in
                switch result {
                    
                case .Success(let dict):
                    //                print(dict)
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self!.view, animated: true)
                        if let error = dict["error"] as? Bool{
                            if !error{
                                NotificationCenter.default.post(name: Notification.Name("LoadScrapData"), object: nil, userInfo: ["LoadScrapData":"1"])

                                self?.navigationController?.popToRootViewController(animated: true)

                            } else {
                                //  completion(false, nil)
                                let status = dict["staus"] as! String
                                 self?.showToast(message: status)
                            }
                        }
                    }
                case .Error(let _):
                    
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self!.view, animated: true)
                        self?.showToast(message: "Error Please try again")
                    }
                    // completion(false, nil)
                }
            }
            
        }
    
}
extension ConfirmYourPriceVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if averageCompanyPrices.count>0 {
            return 1
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return averageCompanyPrices.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell : ConfirmCommudityPriceEditCell = tableView.dequeueReusableCell(withIdentifier: ConfirmCommudityPriceEditCell.identifier, for: indexPath) as? ConfirmCommudityPriceEditCell {
            let data = averageCompanyPrices[indexPath.item]
            cell.lbl1.text = data.commodityname
           cell.priceValue.text = data.price
            
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let cell : ConfirmCommudityPriceHeader = tableView.dequeueReusableCell(withIdentifier: ConfirmCommudityPriceHeader.identifier) as! ConfirmCommudityPriceHeader
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }
}
// UITextFieldDelegate




