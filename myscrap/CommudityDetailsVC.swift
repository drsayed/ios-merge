//
//  CommudityDetailsVC.swift
//  myscrap
//
//  Created by MS1 on 10/10/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

final class CommudityDetailsVC: UIViewController {
    
    
    private let service = PriceService()
    var myPriceData: NSMutableDictionary = [:]
    var commodityid :  String  = ""
    var commodityName :  String  = ""
    @IBOutlet weak var priceTableView: UITableView!
    
    @IBOutlet weak var selectCompanyBtn: UIButton!
    fileprivate var commodityDetailObj = [CommodityDetail] ()
    fileprivate var companyPrice = [CompanyPrice] ()

   
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
        if #available(iOS 11.0, *) {
            priceTableView.contentInsetAdjustmentBehavior = .never
                } else {
                    automaticallyAdjustsScrollViewInsets = false
                }
        priceTableView.contentInset = UIEdgeInsets.zero
        var frame = CGRect.zero
//        priceTableView.size.height = .leastNormalMagnitude
        priceTableView.tableHeaderView = UIView(frame: frame)
        self.extendedLayoutIncludesOpaqueBars = true
        self.priceTableView.contentInsetAdjustmentBehavior = .never

//        priceTableView.tableFooterView = UIView(frame: frame)
      
        self.setupTableView()
        
      //  self.showToast(message: "Please select the company!")
    }
    func setupTableView() {
        
        //Title Cell
        priceTableView.register(CommudityDetailCompanyCell.nib, forCellReuseIdentifier: CommudityDetailCompanyCell.identifier)
        priceTableView.register(CommudityDetailCompanyHeader.nib, forCellReuseIdentifier: CommudityDetailCompanyHeader.identifier)
//        priceTableView.register(ConfirmCommudityFooter.nib, forCellReuseIdentifier: ConfirmCommudityFooter.identifier)
//
      
        priceTableView.estimatedRowHeight = 44.0;
//        if let cellFootter : ConfirmCommudityFooter =  priceTableView.dequeueReusableCell(withIdentifier: "ConfirmCommudityFooter") as? ConfirmCommudityFooter
//        {
//           // cellFootter.submitPriceButton.addTarget(self, action: #selector(self.submitBtnPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
//            cellFootter.editButton.addTarget(self, action: #selector(self.editBtnPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
//
//            priceTableView.tableFooterView = cellFootter
//        }
        
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
            lbNavTitle.text = commodityName
            self.navigationItem.titleView = lbNavTitle
        
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
              spinner.mode = MBProgressHUDMode.indeterminate
              spinner.label.text = "Loading"
         self.getCommudityDetails(commudityID: commodityid)
        
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
    
    @objc func getCommudityDetails(commudityID: String ) {
        let service = APIService()
       //5

        service.endPoint = Endpoints.GET_Commodity_Detail_Page
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&commodityId=\(commudityID)"
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
                             self!.commodityDetailObj .removeAll()
                                 self!.companyPrice .removeAll()
                               if var commodityDataArry = dict["commodityDetail"] as? NSArray
                            {
                                for commodityData  in commodityDataArry  {
                                    let commodityObj = CommodityDetail(dict: commodityData as! [String:AnyObject])
                                    self!.commodityDetailObj.append(commodityObj)
                                }
                         
                            }
                            if var pricesDataArry = dict["companyPrice"] as? NSArray
                                                       {
                                                           for pricesData  in pricesDataArry  {
                                                               let priceObj = CompanyPrice(dict: pricesData as! [String:AnyObject])
                                                               self!.companyPrice.append(priceObj)
                                                           }
                                                    
                                                       }
                          
                            self?.priceTableView.delegate = self
                            self?.priceTableView.dataSource = self
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
    @IBAction func PhoneButtonPressed(_ sender: UIButton) {
        let data = companyPrice[sender.tag]
        let phonenumber : String = data.phoneNo
        let stringWithoutSpaces = phonenumber.replacingOccurrences(of: " ", with: "")

        if let url = URL(string: "tel://\(stringWithoutSpaces)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func ReportPricePressed(_ sender: UIButton) {
        
          let data = companyPrice[sender.tag]
     
     let vc = UIStoryboard(name: StoryBoard.MAIN , bundle: nil).instantiateViewController(withIdentifier: ReportYourPriceVC.id) as! ReportYourPriceVC
        print("User Company id : \(AuthService.instance.companyId)")
          if AuthService.instance.companyCountryID == "224"
          {
            vc.isCompanyDetailExist = true
                   vc.companyID = data.companyid
                    vc.countryNameText = data.name
          }else{
            vc.isCompanyDetailExist = false
                   vc.companyID = ""
                    vc.countryNameText = ""
        }
           
            self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func CompnayDetailBtnPressed(_ sender: UIButton) {
           
             let data = companyPrice[sender.tag]
             if  let vc = CompanyDetailVC.storyBoardInstance() {
                    vc.title = data.name
                    vc.companyId = data.companyid
                    UserDefaults.standard.set(vc.title, forKey: "companyName")
                    UserDefaults.standard.set(vc.companyId, forKey: "companyId")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
       }
}
extension CommudityDetailsVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if commodityDetailObj.count > 0 || companyPrice.count > 0 {
            return 1
        }
        else
        {
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.companyPrice.count  == 0 {
            return 1
        }
        else
        {
        return companyPrice.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0  {
            
        if let cell : CommudityDetailCompanyHeader = tableView.dequeueReusableCell(withIdentifier: CommudityDetailCompanyHeader.identifier, for: indexPath) as? CommudityDetailCompanyHeader {
            let data = commodityDetailObj[0] as! CommodityDetail
          //  self.title = data.name
        
           // cell.companyName.textColor = UIColor.MyScrapGreen
            cell.descriptionLable.text = data.description
            let imagesArray : NSArray = data.images as NSArray
            cell.pageController.numberOfPages = imagesArray.count
            cell.totalImages = imagesArray
            cell.setUpImages()
            if  imagesArray.count == 0 {
              //  cell.pageController.isHidden = true
                cell.imagesViewHeight.constant = 0
            }
            else
            {
                //   cell.pageController.isHidden = false
                 cell.imagesViewHeight.constant = 400
            }
            return cell
        }
            else {
                      return UITableViewCell()
                  }
        }
        else
        {
        if let cell : CommudityDetailCompanyCell = tableView.dequeueReusableCell(withIdentifier: CommudityDetailCompanyCell.identifier, for: indexPath) as? CommudityDetailCompanyCell {
            let data = companyPrice[indexPath.item-1]
            cell.companyName.text = data.name
           cell.companyAddress.text = data.address
            let mobileNumber = data.countryCode + "-" +  data.phoneNo
            if mobileNumber.length > 0 {
                cell.phoneBtnHeightConstant.constant = 40
            }
            else
            {
                 cell.phoneBtnHeightConstant.constant = 0
            }
            if data.premimum == "1" {
                cell.premiumLable.isHidden = false
                
            }
            else
            {
                cell.premiumLable.isHidden = true

            }
            cell.mobileNumberBtn.setTitle(mobileNumber, for: UIControl.State.normal)
            cell.mobileNumberBtn.tag = indexPath.item-1
            print("User Company id : \(AuthService.instance.companyId)")

            if AuthService.instance.companyId == nil || AuthService.instance.companyCountryID != "224"  || AuthService.instance.companyId == "0" || AuthService.instance.companyId == ""
            {
                cell.reportPriceBtn.isHidden = true
                 cell.reporttButtonHight.constant = 0
                cell.reportButtonSpaces.constant = 0
            }
            else{
              cell.reportPriceBtn.isHidden = false
               cell.reporttButtonHight.constant = 26
              cell.reportButtonSpaces.constant = 20

            }
//            if AuthService.instance.companyId == data.companyid  {
//                cell.reportPriceBtn.isHidden = false
//                cell.reporttButtonHight.constant = 26
//                cell.reportButtonSpaces.constant = 20
//
//            }
//            else
//            {
//                cell.reportPriceBtn.isHidden = true
//                cell.reporttButtonHight.constant = 0
//                cell.reportButtonSpaces.constant = 0
//
//
//            }
            
            cell.reportPriceBtn.tag = indexPath.item-1
              cell.companyDetailsBtn.tag = indexPath.item-1
            cell.mobileNumberBtn.addTarget(self, action: #selector(self.PhoneButtonPressed(_:)), for: .touchUpInside)
            cell.reportPriceBtn.addTarget(self, action: #selector(self.ReportPricePressed(_:)), for: .touchUpInside)
            cell.companyDetailsBtn.addTarget(self, action: #selector(self.CompnayDetailBtnPressed(_:)), for: .touchUpInside)

            return cell
        }
            else {
                      return UITableViewCell()
                  }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}
// UITextFieldDelegate




