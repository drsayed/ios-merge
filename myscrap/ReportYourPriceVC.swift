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

final class ReportYourPriceVC: UIViewController,SelectCompanyDelegate {
    
    
    private let service = PriceService()
    var myPriceData: NSMutableDictionary = [:]
    @IBOutlet weak var companyName: ACFloatingTextfield!
    var companyID :  String  = ""
    var countryID : String  = ""
    var countryNameText : String  = ""
    var isCompanyDetailExist : Bool  =  false
       
    var lastPriceIndex : Int = -1
    @IBOutlet weak var priceTableView: UITableView!
    
    @IBOutlet weak var selectCompanyBtn: UIButton!
    fileprivate var editedCompanyPrices = [CommudityPriceReport]()
    fileprivate var averageCompanyPrices = [CommudityPriceReport]()
    var cellHeader : CommudityTableHeader =  CommudityTableHeader()
    
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
        
        //companyName.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 5, 0);
        
        //        companyName.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: companyName.frame.height))
        //        companyName.rightViewMode = .always
       
        self.setupTableView()
        
       
    }
    func setupExistedCompanypricing()
    {
        self.cellHeader.companyNameText.text = countryNameText + " - UAE"
           let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
           spinner.mode = MBProgressHUDMode.indeterminate
           spinner.label.text = "Loading"
           self.getDataFromPrice(companyID: companyID,countryID:"1")
    }
    
    func setupTableView() {
        
        //Title Cell
        priceTableView.register(CommudityPriceEditCell.nib, forCellReuseIdentifier: CommudityPriceEditCell.identifier)
        priceTableView.register(CommudityPriceHeader.nib, forCellReuseIdentifier: CommudityPriceHeader.identifier)
        priceTableView.register(CommudityTableHeader.nib, forCellReuseIdentifier: CommudityTableHeader.identifier)
        priceTableView.register(CommudityFooter.nib, forCellReuseIdentifier: CommudityFooter.identifier)
        
        self.cellHeader =  priceTableView.dequeueReusableCell(withIdentifier: "CommudityTableHeader") as! CommudityTableHeader
        self.cellHeader.selecctCompanyButton.addTarget(self, action: #selector(self.selectCompanyBtnPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
        priceTableView.tableHeaderView = self.cellHeader
        if let cellFootter : CommudityFooter =  priceTableView.dequeueReusableCell(withIdentifier: "CommudityFooter") as? CommudityFooter
        {
            cellFootter.submitPriceButton.removeTarget(nil, action: nil, for: .allEvents)
            cellFootter.submitPriceButton.addTarget(self, action: #selector(self.submitBtnPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
            
            priceTableView.tableFooterView = cellFootter
        }
        
    }
    @objc func doneClick(sender : UIBarButtonItem)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)

        if let cell  : CommudityPriceEditCell = self.priceTableView.cellForRow(at: indexPath)! as? CommudityPriceEditCell {
            cell.priceValueField.resignFirstResponder()
        }
       
    }
    @IBAction func selectCompanyBtnPressed(_ sender: Any) {
        let vc = UIStoryboard(name: StoryBoard.MAIN , bundle: nil).instantiateViewController(withIdentifier: SelectCompanyVC.id) as! SelectCompanyVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        if self.checkChangesOccured()
        {
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Loading"
        self.submitEditPriceData(companyID: companyID,countryID:countryID)
        }
        else
        {
            self.showToast(message: "The Price isn't updated to submit")

        }
    }
    @objc func checkChangesOccured()-> Bool {
           var isFoundChange = false
        
        for data in averageCompanyPrices {
            
            let nameWithoutSpace  = self.returnCoummudityKey(ID: data.commodityname)
             var price = self.myPriceData[nameWithoutSpace] as! String
            if price == "0" {
                price = "-"
            }
            if data.price  != price {
                isFoundChange = true
            }
            
        }
         return isFoundChange
       }
    // MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        if isCompanyDetailExist {
                   
                       self.setupExistedCompanypricing()
               }
               else
               {
                   self.showToast(message: "Please add a company to take a advantage of this feature!")
               }
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 40, width: 320, height: 40))
            lbNavTitle.center = CGPoint(x: 160, y: 285)
            lbNavTitle.textAlignment = .left
        lbNavTitle.textColor = .white
            lbNavTitle.text = "Report Price"
            self.navigationItem.titleView = lbNavTitle
        
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
    func selectedCompany(company: CompanyItem) {
        
        self.cellHeader.companyNameText.text = company.name + " - UAE"
        countryNameText   = company.name
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Loading"
        companyID = company.id
        countryID = company.country
        self.getDataFromPrice(companyID: company.id,countryID:"1")
    }
    @objc func getDataFromPrice(companyID: String , countryID : String) {
        
        let service = APIService()
        service.endPoint = Endpoints.GET_Commodity_Price_Edit
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyID)&countryId=\(countryID)"
        //        print(service.endPoint)
        //        print(service.params)
        service.getDataWith {
            [weak self] result in
            switch result {
                
            case .Success(let dict):
                //                print(dict)
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    if let error = dict["error"] as? Bool{
                        if !error{
                            self!.averageCompanyPrices .removeAll()
                            if let pricesData = dict["data"] as? [[String:AnyObject]]{
                                for data in pricesData{
                                    var name =  data["commodityname"] as! String
                                    //  var nameWithoutSpace = name.trimmingCharacters(in: .whitespaces)
                                    var nameWithoutSpace  = self?.returnCoummudityKey(ID: data["commodityname"] as! String)
                                    
                                    let price =  data["price"] as! String
                                    if  nameWithoutSpace != ""  {
                                        if price != "-" {
                                            self!.myPriceData[nameWithoutSpace] = price
                                        }
                                        else
                                        {
                                            self!.myPriceData[nameWithoutSpace] = "0"
                                        }
                                    }
                                    let priceObj = CommudityPriceReport(dict: data)
                                    self!.averageCompanyPrices.append(priceObj)
                                }
                            }
                            self?.priceTableView.reloadData()
                            
                        } else {
                            self!.averageCompanyPrices .removeAll()
                            self?.priceTableView.reloadData()
                            self?.showToast(message: dict["status"] as! String)
                            self?.priceTableView.tableFooterView = nil
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
    @objc func submitEditPriceData(companyID: String , countryID : String) {
        
        let service = APIService()
        var paramStr = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyID)&countryId=1"
        service.endPoint = Endpoints.GET_Commodity_Price_Edit
        var paramComidity : String = ""
        //        print(service.endPoint)
        //        print(service.params)
        for (key, value) in myPriceData {
            paramComidity = paramComidity + "&\(key)=\(value)"
        }
        print("Property: \"\(paramComidity )\"")
        
        service.params = paramStr + paramComidity
        service.getDataWith {
            [weak self] result in
            switch result {
                
            case .Success(let dict):
                //                print(dict)
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    if let error = dict["error"] as? Bool{
                        if !error{
                            
                            MBProgressHUD.hide(for: self!.view, animated: true)
                            let vc = UIStoryboard(name: StoryBoard.MAIN , bundle: nil).instantiateViewController(withIdentifier: ConfirmYourPriceVC.id) as! ConfirmYourPriceVC
                            vc.companyID = self!.companyID;
                            vc.companyName = self?.countryNameText as! String;
                            vc.countryID = self?.countryID as! String;
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                        else {
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
    @objc func returnCoummudityKey(ID: String) -> String
    {
        //        AlExtrusion6063:
        if ID.contains("Extrusion") && ID.contains("6063"){
            return "AlExtrusion6063";
        }
        else  if ID.contains("Grade") && ID.contains("6061") {
            return "Al6061grade";
        }
        else  if ID.contains("Grade") && ID.contains("6082") {
            return "Al6082grade";
        }
        else  if ID.contains("Al") && ID.contains("Wheels") {
            return "Alwheels";
        }
        else  if ID.contains("Al") && ID.contains("Radiators") {
            return "Alradiators";
        }
        else  if ID.contains("Al") && ID.contains("Castings") {
            return "Alcastings";
        }
        else  if ID.contains("Al") && ID.contains("UBC") {
            return "AlUBC";
        }
        else  if ID.contains("Al") && ID.contains("Soft and Shiny") {
            return "AlSoftandShinywire";
        }
        else  if ID.contains("Al") && ID.contains("Shiny Wire") {
            return "AlShinyWire";
        }
        else  if ID.contains("Al") && ID.contains("Alloy Wire") {
            return "AlAlloywire";
        }
        else  if ID.contains("Al") && ID.contains("Litho Sheets") {
            return "AlLithoSheets";
        }
        else  if ID.contains("Al") && ID.contains("Alloy Sheet") {
            return "AlAlloySheets";
        }
    else  if ID.contains("Copper") && ID.contains("1") {
                      return "CopperNo1";
       }
            else  if ID.contains("Copper") && ID.contains("2") {
                                 return "CopperNo2";
                  }
            else  if ID.contains("Copper") && ID.contains("3") {
                                 return "CopperNo3";
                  }
     
        else  if ID.contains("Copper Radiator")  {
            return "CopperRadiator";
        }
        else  if ID.contains("Brass Honey")  {
            return "BrassHoney";
        }
        else  if ID.contains("Brass Radiator")  {
            return "BrassRadiator";
        }
        else  if ID.contains("Low Copper Brass")  {
            return "LowCopperBrass";
        }
        else  if ID.contains("HMS1") &&  !ID.contains("2")  {
            return "HMS1";
        }
        else  if ID.contains("HMS1 2") ||  ID.contains("HMS 1/2") || ID.contains("HMS 12") || ID.contains("HMS12") {
            return "HMS1/2";
        }
        else  if ID.contains("trump")  {
            return "Altrump";
        }
        else   {
           
            return  ID.replacingOccurrences(of: " ", with: "");
        }
        
    }
}
extension ReportYourPriceVC : UITableViewDelegate , UITableViewDataSource {
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
        
        if let cell : CommudityPriceEditCell = tableView.dequeueReusableCell(withIdentifier: CommudityPriceEditCell.identifier, for: indexPath) as? CommudityPriceEditCell {
            let data = averageCompanyPrices[indexPath.item]
            cell.lbl1.text = data.commodityname
            cell.priceValueField.tag = indexPath.item
            cell.priceValueField.delegate = self
          //  cell.priceValueField.s
            cell.priceValueField.addTarget(self, action: #selector(self.textFieldDidChangeSelection(_:)), for: .editingChanged)

            let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: cell.priceValueField.frame.size.height))
            cell.priceValueField.rightView = rightView
            cell.priceValueField.leftViewMode = .always
            
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.GREEN_PRIMARY
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick(sender:)))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let spaceleft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            doneButton.tag = indexPath.item
            toolBar.setItems([spaceleft,spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            cell.priceValueField.inputAccessoryView = toolBar
            
            
            
            let nameWithoutSpace  = self.returnCoummudityKey(ID: data.commodityname) as? String
            if  nameWithoutSpace != ""   {
                let priceValue  = self.myPriceData[nameWithoutSpace] as? String
                if  priceValue != "0" {
                    cell.priceValueField.text = priceValue
                }
                else
                {
                    cell.priceValueField.text = ""
                }
                
            }
            else
            {
                if data.price == "-"
                {
                    cell.priceValueField.text = ""
                    
                }
                else
                {
                    cell.priceValueField.text = data.price
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let cell : CommudityPriceHeader = tableView.dequeueReusableCell(withIdentifier: CommudityPriceHeader.identifier) as! CommudityPriceHeader
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }
}
// UITextFieldDelegate
extension ReportYourPriceVC : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // User finished typing (hit return): hide the keyboard.
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        print("\(textField.tag)" + " entered Values \(textField.text!)")
        let data = averageCompanyPrices[textField.tag] as CommudityPriceReport
        var name =  data.commodityname as! String
        let nameWithoutSpace  = self.returnCoummudityKey(ID: data.commodityname)
        if  nameWithoutSpace != ""  {
            if textField.text != "" {
                self.myPriceData[nameWithoutSpace] = textField.text
            }
            else
            {
                self.myPriceData[nameWithoutSpace] = "0"
            }
        }
        
    }
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("\(textField.tag)" + " entered Values \(textField.text!)")
               let data = averageCompanyPrices[textField.tag] as CommudityPriceReport
               var name =  data.commodityname as! String
               let nameWithoutSpace  = self.returnCoummudityKey(ID: data.commodityname)
               if  nameWithoutSpace != ""  {
                   if textField.text != "" {
                       self.myPriceData[nameWithoutSpace] = textField.text
                   }
                   else
                   {
                       self.myPriceData[nameWithoutSpace] = "0"
                   }
               }
    }
}




